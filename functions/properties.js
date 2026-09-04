const LISTING_API =
  'https://script.google.com/macros/s/AKfycbyKKrioq22adrb2wpdad3wj6CedlqhLzEomOCkR-AdXcjU75M9pNTTySz5xYBEqN8gb/exec';

function cleanText(value) {
  return String(value ?? '').trim();
}

function escapeHtml(value = '') {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

export async function onRequestGet(context) {
  const requestUrl = new URL(context.request.url);
  const origin = requestUrl.origin;

  const title = 'Properties Malaysia | MK Khairul Property Tools';

  const description =
    'Browse properties for sale and rent in Malaysia with MK Khairul. Explore residential, commercial and land listings with direct property enquiry.';

  const canonical = `${origin}/properties`;

  let propertyLinks = '';

  try {
    const apiResponse = await fetch(LISTING_API, {
      headers: {
        Accept: 'application/json',
      },
    });

    if (apiResponse.ok) {
      const data = await apiResponse.json();

      const listings = Array.isArray(data)
        ? data
        : Array.isArray(data.listings)
          ? data.listings
          : [];

      propertyLinks = listings
        .map((item) => {
          const slug = cleanText(
            item['SEO Slug'] ??
            item['SEO slug'] ??
            item['Seo Slug'],
          );

          if (!slug) return '';

          const propertyTitle =
            cleanText(item['Title']) ||
            cleanText(item['SEO Title']) ||
            'Property Malaysia';

          const url =
            `${origin}/property/${encodeURIComponent(slug)}`;

          return `<li><a href="${escapeHtml(url)}">${escapeHtml(propertyTitle)}</a></li>`;
        })
        .filter(Boolean)
        .join('\n');
    }
  } catch (error) {
    propertyLinks = '';
  }

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

  if (propertyLinks) {
    html = html.replace(
      /<\/body>/i,
      `<noscript>
  <nav aria-label="Property listings">
    <h2>Properties Malaysia</h2>
    <ul>
${propertyLinks}
    </ul>
  </nav>
</noscript>
</body>`,
    );
  }

  return new Response(html, {
    status: 200,
    headers: {
      'Content-Type': 'text/html; charset=UTF-8',
      'Cache-Control': 'public, max-age=300',
    },
  });
}