const TIKTOK_TOKEN_URL =
  "https://open.tiktokapis.com/v2/oauth/token/";

const REFRESH_BUFFER_MS = 10 * 60 * 1000;

export async function getValidTikTokAccessToken(env) {
  const tokenStore = env.TIKTOK_TOKENS;
  const clientKey = env.TIKTOK_CLIENT_KEY;
  const clientSecret = env.TIKTOK_CLIENT_SECRET;

  if (!tokenStore) {
    throw new Error(
      "TikTok token storage is not configured."
    );
  }

  if (!clientKey || !clientSecret) {
    throw new Error(
      "TikTok OAuth credentials are not configured."
    );
  }

  const openId = await tokenStore.get("primary");

  if (!openId) {
    throw new Error(
      "No primary TikTok account is connected."
    );
  }

  const recordKey = `tiktok:${openId}`;
  const storedValue = await tokenStore.get(recordKey);

  if (!storedValue) {
    throw new Error(
      "Stored TikTok token record was not found."
    );
  }

  let tokenRecord;

  try {
    tokenRecord = JSON.parse(storedValue);
  } catch {
    throw new Error(
      "Stored TikTok token record is invalid."
    );
  }

  if (
    !tokenRecord.access_token ||
    !tokenRecord.refresh_token
  ) {
    throw new Error(
      "Stored TikTok OAuth tokens are incomplete."
    );
  }

  const now = Date.now();

  const expiresAt = Number(
    tokenRecord.access_token_expires_at || 0
  );

  const tokenStillValid =
    expiresAt > now + REFRESH_BUFFER_MS;

  if (tokenStillValid) {
    return {
      accessToken: tokenRecord.access_token,
      openId,
      refreshed: false,
      expiresAt
    };
  }

  return refreshTikTokAccessToken({
    tokenStore,
    clientKey,
    clientSecret,
    openId,
    tokenRecord
  });
}

async function refreshTikTokAccessToken({
  tokenStore,
  clientKey,
  clientSecret,
  openId,
  tokenRecord
}) {
  const body = new URLSearchParams();

  body.set("client_key", clientKey);
  body.set("client_secret", clientSecret);
  body.set("grant_type", "refresh_token");
  body.set(
    "refresh_token",
    tokenRecord.refresh_token
  );

  const response = await fetch(
    TIKTOK_TOKEN_URL,
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

  let tokenData;

  try {
    tokenData = await response.json();
  } catch {
    throw new Error(
      "TikTok returned an invalid token refresh response."
    );
  }

  if (
    !response.ok ||
    !tokenData.access_token ||
    !tokenData.refresh_token
  ) {
    throw new Error(
      tokenData.error_description ||
      tokenData.error ||
      "TikTok token refresh failed."
    );
  }

  const now = Date.now();

  const refreshedOpenId =
    tokenData.open_id ||
    tokenRecord.open_id ||
    openId;

  const refreshedRecord = {
    open_id: refreshedOpenId,
    access_token: tokenData.access_token,
    refresh_token: tokenData.refresh_token,

    scope:
      tokenData.scope ||
      tokenRecord.scope ||
      "",

    token_type:
      tokenData.token_type ||
      tokenRecord.token_type ||
      "Bearer",

    expires_in:
      tokenData.expires_in || null,

    refresh_expires_in:
      tokenData.refresh_expires_in || null,

    access_token_expires_at:
      tokenData.expires_in
        ? now +
          Number(tokenData.expires_in) * 1000
        : null,

    refresh_token_expires_at:
      tokenData.refresh_expires_in
        ? now +
          Number(
            tokenData.refresh_expires_in
          ) *
            1000
        : null,

    updated_at:
      new Date(now).toISOString()
  };

  const refreshedRecordKey =
    `tiktok:${refreshedOpenId}`;

  await tokenStore.put(
    refreshedRecordKey,
    JSON.stringify(refreshedRecord)
  );

  await tokenStore.put(
    "primary",
    refreshedOpenId
  );

  if (refreshedRecordKey !== `tiktok:${openId}`) {
    await tokenStore.delete(
      `tiktok:${openId}`
    );
  }

  return {
    accessToken: tokenData.access_token,
    openId: refreshedOpenId,
    refreshed: true,
    expiresAt:
      refreshedRecord.access_token_expires_at
  };
}