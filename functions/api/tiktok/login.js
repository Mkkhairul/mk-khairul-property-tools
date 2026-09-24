export async function onRequestGet(context) {
  const clientKey = context.env.TIKTOK_CLIENT_KEY;

  if (!clientKey) {
    return new Response(
      JSON.stringify({
        ok: false,
        error: "TIKTOK_CLIENT_KEY is not configured"
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" }
      }
    );
  }

  const redirectUri =
    "https://mkkhairul.pages.dev/api/tiktok/callback";

  const scope =
    "user.info.basic,video.publish,video.upload";

  const state = crypto.randomUUID().replaceAll("-", "");

  const authUrl = new URL(
    "https://www.tiktok.com/v2/auth/authorize/"
  );

  authUrl.searchParams.set("client_key", clientKey);
  authUrl.searchParams.set("scope", scope);
  authUrl.searchParams.set("response_type", "code");
  authUrl.searchParams.set("redirect_uri", redirectUri);
  authUrl.searchParams.set("state", state);

  return Response.redirect(authUrl.toString(), 302);
}