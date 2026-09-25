export async function onRequestGet(context) {
  const clientKey = context.env.TIKTOK_CLIENT_KEY;

  if (!clientKey) {
    return jsonResponse(
      { ok: false, error: "TikTok OAuth is not configured." },
      500
    );
  }

  const redirectUri =
    "https://mkkhairul.pages.dev/api/tiktok/callback";

  const scope =
    "user.info.basic,video.publish,video.upload";

  const state = crypto.randomUUID().replaceAll("-", "");

  const authUrl =
    new URL("https://www.tiktok.com/v2/auth/authorize/");

  authUrl.searchParams.set("client_key", clientKey);
  authUrl.searchParams.set("scope", scope);
  authUrl.searchParams.set("response_type", "code");
  authUrl.searchParams.set("redirect_uri", redirectUri);
  authUrl.searchParams.set("state", state);

  return new Response(null, {
    status: 302,
    headers: {
      Location: authUrl.toString(),
      "Set-Cookie":
        `tiktok_oauth_state=${state}; Path=/api/tiktok; HttpOnly; Secure; SameSite=Lax; Max-Age=600`,
      "Cache-Control": "no-store"
    }
  });
}

function jsonResponse(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Cache-Control": "no-store"
    }
  });
}
