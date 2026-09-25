import {
  getValidTikTokAccessToken
} from "../../_lib/tiktokAuth.js";

const CREATOR_INFO_URL =
  "https://open.tiktokapis.com/v2/post/publish/creator_info/query/";

export async function onRequestGet(context) {
  try {
    const auth =
      await getValidTikTokAccessToken(
        context.env
      );

    const response = await fetch(
      CREATOR_INFO_URL,
      {
        method: "POST",
        headers: {
          Authorization:
            `Bearer ${auth.accessToken}`,
          "Content-Type":
            "application/json; charset=UTF-8"
        }
      }
    );

    const result = await response.json();

    if (
      !response.ok ||
      result?.error?.code !== "ok"
    ) {
      return jsonResponse(
        {
          ok: false,
          service:
            "MK KHAIRUL TikTok Creator Info",
          tiktok_error:
            result?.error?.code ||
            "creator_info_failed",
          message:
            result?.error?.message ||
            "TikTok creator info request failed."
        },
        response.status || 500
      );
    }

    const creator = result.data || {};

    return jsonResponse({
      ok: true,
      service:
        "MK KHAIRUL TikTok Creator Info",

      creator_connected: true,

      creator_username:
        creator.creator_username || null,

      creator_nickname:
        creator.creator_nickname || null,

      privacy_level_options:
        creator.privacy_level_options || [],

      comment_disabled:
        Boolean(
          creator.comment_disabled
        ),

      duet_disabled:
        Boolean(
          creator.duet_disabled
        ),

      stitch_disabled:
        Boolean(
          creator.stitch_disabled
        ),

      max_video_post_duration_sec:
        creator.max_video_post_duration_sec ??
        null,

      token_refreshed:
        Boolean(auth.refreshed),

      note:
        "TikTok creator information retrieved successfully. OAuth tokens are not displayed."
    });
  } catch (error) {
    return jsonResponse(
      {
        ok: false,
        service:
          "MK KHAIRUL TikTok Creator Info",
        error:
          error?.message ||
          "Creator info test failed."
      },
      500
    );
  }
}

function jsonResponse(data, status = 200) {
  return new Response(
    JSON.stringify(data, null, 2),
    {
      status,
      headers: {
        "Content-Type":
          "application/json; charset=utf-8",
        "Cache-Control": "no-store"
      }
    }
  );
}