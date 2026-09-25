export async function onRequestPost(context) {
  const tokenStore = context.env.TIKTOK_TOKENS;
  const clientKey = context.env.TIKTOK_CLIENT_KEY;
  const clientSecret = context.env.TIKTOK_CLIENT_SECRET;

  if (!tokenStore || !clientKey || !clientSecret) {
    return jsonResponse(
      {
        ok: false,
        error: "TikTok refresh configuration is incomplete."
      },
      500
    );
  }

  try {
    // Get the primary TikTok account open_id
    const openId = await tokenStore.get("primary");

    if (!openId) {
      return jsonResponse(
        {
          ok: false,
          error: "No primary TikTok account is connected."
        },
        404
      );
    }

    // Get stored OAuth tokens
    const recordKey = `tiktok:${openId}`;
    const storedValue = await tokenStore.get(recordKey);

    if (!storedValue) {
      return jsonResponse(
        {
          ok: false,
          error: "Stored TikTok token record was not found."
        },
        404
      );
    }

    let tokenRecord;

    try {
      tokenRecord = JSON.parse(storedValue);
    } catch (error) {
      return jsonResponse(
        {
          ok: false,
          error: "Stored TikTok token record is invalid."
        },
        500
      );
    }

    if (!tokenRecord.refresh_token) {
      return jsonResponse(
        {
          ok: false,
          error: "TikTok refresh token is missing."
        },
        500
      );
    }

    // Exchange refresh token for fresh tokens
    const body = new URLSearchParams();

    body.set("client_key", clientKey);
    body.set("client_secret", clientSecret);
    body.set("grant_type", "refresh_token");
    body.set("refresh_token", tokenRecord.refresh_token);

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
      return jsonResponse(
        {
          ok: false,
          error: "TikTok token refresh failed.",
          detail:
            tokenData.error_description ||
            tokenData.error ||
            "Unknown TikTok OAuth error."
        },
        502
      );
    }

    const now = Date.now();

    // TikTok may return the same or a new open_id.
    const refreshedOpenId =
      tokenData.open_id || tokenRecord.open_id || openId;

    const refreshedRecord = {
      open_id: refreshedOpenId,
      access_token: tokenData.access_token,
      refresh_token: tokenData.refresh_token,
      scope: tokenData.scope || tokenRecord.scope || "",
      token_type:
        tokenData.token_type ||
        tokenRecord.token_type ||
        "Bearer",
      expires_in: tokenData.expires_in || null,
      refresh_expires_in:
        tokenData.refresh_expires_in || null,
      access_token_expires_at:
        tokenData.expires_in
          ? now + Number(tokenData.expires_in) * 1000
          : null,
      refresh_token_expires_at:
        tokenData.refresh_expires_in
          ? now +
            Number(tokenData.refresh_expires_in) * 1000
          : null,
      updated_at: new Date(now).toISOString()
    };

    const refreshedRecordKey =
      `tiktok:${refreshedOpenId}`;

    // Save the fresh token pair first.
    await tokenStore.put(
      refreshedRecordKey,
      JSON.stringify(refreshedRecord)
    );

    // Update primary pointer.
    await tokenStore.put(
      "primary",
      refreshedOpenId
    );

    // Remove old record only if open_id changed.
    if (refreshedRecordKey !== recordKey) {
      await tokenStore.delete(recordKey);
    }

    return jsonResponse(
      {
        ok: true,
        service: "MK KHAIRUL TikTok OAuth",
        message: "TikTok token refreshed successfully.",
        open_id_received: true,
        scope_received: refreshedRecord.scope,
        access_token_refreshed: true,
        refresh_token_received: true,
        tokens_stored_securely: true,
        expires_in: refreshedRecord.expires_in,
        refresh_expires_in:
          refreshedRecord.refresh_expires_in,
        note:
          "Fresh TikTok tokens are stored securely and are not displayed."
      },
      200
    );
  } catch (error) {
    return jsonResponse(
      {
        ok: false,
        error: "TikTok token refresh request failed."
      },
      500
    );
  }
}

function jsonResponse(data, status = 200) {
  const headers = new Headers();

  headers.set(
    "Content-Type",
    "application/json; charset=UTF-8"
  );

  headers.set("Cache-Control", "no-store");

  return new Response(
    JSON.stringify(data, null, 2),
    {
      status,
      headers
    }
  );
}