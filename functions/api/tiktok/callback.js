export async function onRequestGet(context) {
  const url = new URL(context.request.url);

  const code = url.searchParams.get("code");
  const returnedState = url.searchParams.get("state");
  const oauthError = url.searchParams.get("error");
  const oauthErrorDescription =
    url.searchParams.get("error_description");

  if (oauthError) {
    return safeResponse(
      {
        ok: false,
        error: "TikTok authorization was not completed.",
        detail: oauthErrorDescription || oauthError
      },
      400
    );
  }

  const cookieHeader =
    context.request.headers.get("Cookie") || "";

  const cookies = parseCookies(cookieHeader);
  const savedState = cookies.tiktok_oauth_state;

  if (
    !returnedState ||
    !savedState ||
    returnedState !== savedState
  ) {
    return safeResponse(
      {
        ok: false,
        error: "OAuth state verification failed."
      },
      400
    );
  }

  if (!code) {
    return safeResponse(
      {
        ok: false,
        error: "Authorization code was not received."
      },
      400
    );
  }

  const clientKey = context.env.TIKTOK_CLIENT_KEY;
  const clientSecret = context.env.TIKTOK_CLIENT_SECRET;
  const tokenStore = context.env.TIKTOK_TOKENS;

  if (!clientKey || !clientSecret) {
    return safeResponse(
      {
        ok: false,
        error: "TikTok OAuth credentials are not configured."
      },
      500
    );
  }

  if (!tokenStore) {
    return safeResponse(
      {
        ok: false,
        error: "TikTok token storage is not configured."
      },
      500
    );
  }

  const redirectUri =
    "https://mkkhairul.pages.dev/api/tiktok/callback";

  const body = new URLSearchParams();

  body.set("client_key", clientKey);
  body.set("client_secret", clientSecret);
  body.set("code", code);
  body.set("grant_type", "authorization_code");
  body.set("redirect_uri", redirectUri);

  try {
    const tokenResponse = await fetch(
      "https://open.tiktokapis.com/v2/oauth/token/",
      {
        method: "POST",
        headers: {
          "Content-Type":
            "application/x-www-form-urlencoded",
          "Cache-Control": "no-cache"
        },
        body: body.toString()
      }
    );

    const tokenData = await tokenResponse.json();

    if (
      !tokenResponse.ok ||
      !tokenData.access_token ||
      !tokenData.refresh_token
    ) {
      return safeResponse(
        {
          ok: false,
          error: "TikTok token exchange failed.",
          detail:
            tokenData.error_description ||
            tokenData.error ||
            "Unknown TikTok OAuth error."
        },
        502,
        true
      );
    }

    if (!tokenData.open_id) {
      return safeResponse(
        {
          ok: false,
          error: "TikTok open_id was not received."
        },
        502,
        true
      );
    }

    const now = Date.now();

    const tokenRecord = {
      open_id: tokenData.open_id,
      access_token: tokenData.access_token,
      refresh_token: tokenData.refresh_token,
      scope: tokenData.scope || "",
      token_type: tokenData.token_type || "Bearer",
      expires_in: tokenData.expires_in || null,
      refresh_expires_in:
        tokenData.refresh_expires_in || null,
      access_token_expires_at:
        tokenData.expires_in
          ? now + Number(tokenData.expires_in) * 1000
          : null,
      refresh_token_expires_at:
        tokenData.refresh_expires_in
          ? now + Number(tokenData.refresh_expires_in) * 1000
          : null,
      updated_at: new Date(now).toISOString()
    };

    await tokenStore.put(
      `tiktok:${tokenData.open_id}`,
      JSON.stringify(tokenRecord)
    );

    await tokenStore.put(
      "primary",
      tokenData.open_id
    );

    return safeResponse(
      {
        ok: true,
        service: "MK KHAIRUL TikTok OAuth",
        message: "TikTok Connected Successfully",
        open_id_received: true,
        scope_received: tokenData.scope || "",
        access_token_received: true,
        refresh_token_received: true,
        tokens_stored_securely: true,
        token_type: tokenData.token_type || "Bearer",
        expires_in: tokenData.expires_in || null,
        refresh_expires_in:
          tokenData.refresh_expires_in || null,
        note:
          "TikTok tokens are stored securely and are not displayed."
      },
      200,
      true
    );
  } catch (error) {
    return safeResponse(
      {
        ok: false,
        error:
          "TikTok token exchange or secure storage failed."
      },
      500,
      true
    );
  }
}

function parseCookies(cookieHeader) {
  const result = {};

  for (const part of cookieHeader.split(";")) {
    const index = part.indexOf("=");

    if (index === -1) continue;

    const key = part.slice(0, index).trim();
    const value = part.slice(index + 1).trim();

    if (key) {
      result[key] = decodeURIComponent(value);
    }
  }

  return result;
}

function safeResponse(
  data,
  status = 200,
  clearState = false
) {
  const headers = new Headers();

  headers.set(
    "Content-Type",
    "application/json; charset=UTF-8"
  );

  headers.set("Cache-Control", "no-store");

  if (clearState) {
    headers.append(
      "Set-Cookie",
      "tiktok_oauth_state=; Path=/api/tiktok; HttpOnly; Secure; SameSite=Lax; Max-Age=0"
    );
  }

  return new Response(
    JSON.stringify(data, null, 2),
    { status, headers }
  );
}
