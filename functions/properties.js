export async function onRequestGet(context) {
  const requestUrl = new URL(context.request.url);
  const origin = requestUrl.origin;

  const title = 'Properties Malaysia | MK Khairul Property Tools';

  const description =
    'Browse properties for sale and rent in Malaysia with MK Khairul. Explore residential, commercial and land listings with direct property enquiry.';

  const canonical = `${origin}/properties`;

  const assetUrl = new URL('/', requestUrl);
  const assetResponse = await context.env.ASSETS.fetch(assetUrl);

  if (!assetResponse.ok) {
    return assetResponse;
  }

  let html = await assetResponse.text();

  html = html
    .replace(
      /<title>[\s\S]*?<\/title>/i,
      `<title>${title}</title>`,
    )
    .replace(
      /<meta\s+name="description"[\s\S]*?>/i,
      `<meta name="description" content="${description}">`,
    )
    .replace(
      /<link\s+rel="canonical"[\s\S]*?>/i,
      `<link rel="canonical" href="${canonical}">`,
    )
    .replace(
      /<meta\s+property="og:title"[\s\S]*?>/i,
      `<meta property="og:title" content="${title}">`,
    )
    .replace(
      /<meta\s+property="og:description"[\s\S]*?>/i,
      `<meta property="og:description" content="${description}">`,
    )
    .replace(
      /<meta\s+property="og:url"[\s\S]*?>/i,
      `<meta property="og:url" content="${canonical}">`,
    )
    .replace(
      /<meta\s+name="twitter:title"[\s\S]*?>/i,
      `<meta name="twitter:title" content="${title}">`,
    )
    .replace(
      /<meta\s+name="twitter:description"[\s\S]*?>/i,
      `<meta name="twitter:description" content="${description}">`,
    );

  return new Response(html, {
    status: 200,
    headers: {
      'Content-Type': 'text/html; charset=UTF-8',
      'Cache-Control': 'public, max-age=300',
    },
  });
}