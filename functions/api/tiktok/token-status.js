import {
  getValidTikTokAccessToken
} from "../../_lib/tiktokAuth.js";

export async function onRequestGet(context) {
  try {
    const result =
      await getValidTikTokAccessToken(
        context.env
      );

    return new Response(
      JSON.stringify(
        {
          ok: true,
          service:
            "MK KHAIRUL TikTok Token Manager",
          token_available:
            Boolean(result.accessToken),
          refreshed:
            Boolean(result.refreshed),
          expiry_available:
            Boolean(result.expiresAt),
          note:
            "TikTok token is available securely and is not displayed."
        },
        null,
        2
      ),
      {
        status: 200,
        headers: {
          "Content-Type":
            "application/json; charset=utf-8",
          "Cache-Control": "no-store"
        }
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify(
        {
          ok: false,
          service:
            "MK KHAIRUL TikTok Token Manager",
          error:
            error?.message ||
            "TikTok token manager test failed."
        },
        null,
        2
      ),
      {
        status: 500,
        headers: {
          "Content-Type":
            "application/json; charset=utf-8",
          "Cache-Control": "no-store"
        }
      }
    );
  }
}