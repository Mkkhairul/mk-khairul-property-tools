import {
  getValidTikTokAccessToken
} from "../../_lib/tiktokAuth.js";

const STATUS_URL =
  "https://open.tiktokapis.com/v2/post/publish/status/fetch/";

export async function onRequestPost(context) {
  try {
    const body = await context.request.json();
    const publishId = String(body?.publish_id || "").trim();

    if (!publishId || publishId.length > 128) {
      return jsonResponse({
        ok: false,
        error: "A valid publish_id is required."
      }, 400);
    }

    const auth = await getValidTikTokAccessToken(context.env);

    const response = await fetch(STATUS_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${auth.accessToken}`,
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: JSON.stringify({ publish_id: publishId })
    });

    const result = await response.json();

    if (!response.ok || result?.error?.code !== "ok") {
      return jsonResponse({
        ok: false,
        service: "MK KHAIRUL TikTok Publish Status",
        tiktok_error: result?.error?.code || "status_fetch_failed",
        message: result?.error?.message || "TikTok publish status request failed."
      }, response.status || 500);
    }

    const data = result.data || {};

    return jsonResponse({
      ok: true,
      service: "MK KHAIRUL TikTok Publish Status",
      status: data.status || null,
      fail_reason: data.fail_reason || null,
      uploaded_bytes: data.uploaded_bytes ?? null,
      publicly_available_post_id:
        data.publicly_available_post_id || [],
      token_refreshed: Boolean(auth.refreshed),
      note: "TikTok publish status retrieved securely. OAuth tokens are not displayed."
    });
  } catch (error) {
    return jsonResponse({
      ok: false,
      service: "MK KHAIRUL TikTok Publish Status",
      error: error?.message || "Publish status check failed."
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
