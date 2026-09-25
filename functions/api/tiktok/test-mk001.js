import {
  getValidTikTokAccessToken
} from "../../_lib/tiktokAuth.js";

const PUBLISH_URL =
  "https://open.tiktokapis.com/v2/post/publish/content/init/";

const MK001_MEDIA =
  "https://mkkhairul.pages.dev/tiktok-media/mk-001.png";

const DESCRIPTION =
  "Pagi ni reset balik niat. Start small pun tak apa, asalkan kita terus bergerak. 🤲 — MK KHAIRUL #fyp #MKKHAIRUL #SelamatPagi #MorningMotivation #MindsetMalaysia #UsahaDanDoa";

export async function onRequestPost(context) {
  try {
    const auth = await getValidTikTokAccessToken(context.env);

    const payload = {
      post_info: {
        title: "Mulakan Pagi Dengan Niat",
        description: DESCRIPTION,
        disable_comment: false,
        privacy_level: "SELF_ONLY",
        auto_add_music: true,
        brand_content_toggle: false,
        brand_organic_toggle: true
      },
      source_info: {
        source: "PULL_FROM_URL",
        photo_cover_index: 0,
        photo_images: [MK001_MEDIA]
      },
      post_mode: "DIRECT_POST",
      media_type: "PHOTO"
    };

    const response = await fetch(PUBLISH_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${auth.accessToken}`,
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: JSON.stringify(payload)
    });

    const result = await response.json();

    if (!response.ok || result?.error?.code !== "ok") {
      return jsonResponse({
        ok: false,
        service: "MK KHAIRUL TikTok MK-001 Sandbox Test",
        tiktok_error: result?.error?.code || "publish_init_failed",
        message: result?.error?.message || "TikTok photo publish initialization failed."
      }, response.status || 500);
    }

    return jsonResponse({
      ok: true,
      service: "MK KHAIRUL TikTok MK-001 Sandbox Test",
      content_id: "MK-001",
      publish_initialized: true,
      publish_id: result?.data?.publish_id || null,
      privacy_level: "SELF_ONLY",
      auto_add_music: true,
      media_count: 1,
      token_refreshed: Boolean(auth.refreshed),
      note: "MK-001 was submitted as a private TikTok photo post with TikTok recommended music. OAuth tokens are not displayed."
    });
  } catch (error) {
    return jsonResponse({
      ok: false,
      service: "MK KHAIRUL TikTok MK-001 Sandbox Test",
      error: error?.message || "MK-001 Sandbox publish test failed."
    }, 500);
  }
}

function jsonResponse(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "no-store"
    }
  });
}
