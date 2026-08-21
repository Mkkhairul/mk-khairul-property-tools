const LISTING_API = 'https://script.google.com/macros/s/AKfycbyKKrioq22adrb2wpdad3wj6CedlqhLzEomOCkR-AdXcjU75M9pNTTySz5xYBEqN8gb/exec';
const PAGE_SIZE = 10000;

function xmlEscape(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

function normalizeSlug(value) {
  return String(value ?? '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function getSlug(item) {
  const keys = [
    'SEO Slug',
    'SEO_SLUG',
    'Seo Slug',
    'seo_slug',
    'slug',
    'Slug',
  ];

  for (const key of keys) {
    const value = String(item?.[key] ?? '').trim();
    if (value) return normalizeSlug(value);
  }

  const title = String(item?.['Title'] ?? '').trim();
  if (title) return normalizeSlug(title);

  return normalizeSlug(item?.['ID']);
}

function isIndexable(item) {
  const active = String(item?.['Active'] ?? '').trim().toUpperCase();
  const seoIndex = String(item?.['SEO Index'] ?? 'INDEX')
    .trim()
    .toUpperCase();

  return active === 'YES' && seoIndex !== 'NOINDEX';
}

async function loadIndexableListings() {
  const response = await fetch(LISTING_API, {
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'MK-Khairul-Sitemap/1.0',
    },
  });

  if (!response.ok) {
    throw new Error(`Listing API returned ${response.status}`);
  }

  const data = await response.json();

  if (data?.success !== true || !Array.isArray(data?.listings)) {
    throw new Error('Invalid listing API response');
  }

  return data.listings
    .filter(isIndexable)
    .map((item) => ({ ...item, __slug: getSlug(item) }))
    .filter((item) => item.__slug);
}

function responseXml(xml, status = 200) {
  return new Response(xml, {
    status,
    headers: {
      'Content-Type': 'application/xml; charset=UTF-8',
      'Cache-Control': 'public, max-age=300',
      'X-Robots-Tag': 'noindex',
    },
  });
}

function formatLastmod(value) {
  if (!value) return '';

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '';

  return date.toISOString();
}

export async function onRequestGet(context) {
  try {
    const requestUrl = new URL(context.request.url);
    const origin = requestUrl.origin;

    const pageRaw = Number.parseInt(
      requestUrl.searchParams.get('page') || '1',
      10,
    );
    const page = Number.isFinite(pageRaw) && pageRaw > 0 ? pageRaw : 1;

    const listings = await loadIndexableListings();

    const start = (page - 1) * PAGE_SIZE;
    const pageListings = listings.slice(start, start + PAGE_SIZE);

    if (pageListings.length === 0 && listings.length > 0) {
      return responseXml(
        `<?xml version="1.0" encoding="UTF-8"?>
<error>Invalid sitemap page</error>`,
        404,
      );
    }

    const urls = pageListings.map((item) => {
      const lastmod =
        formatLastmod(item['Updated At']) ||
        formatLastmod(item['Bumped At']) ||
        formatLastmod(item['Created At']);

      return {
        loc: `${origin}/property/${item.__slug}`,
        lastmod,
      };
    });

    const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls
  .map(
    (item) => `  <url>
    <loc>${xmlEscape(item.loc)}</loc>${item.lastmod ? `
    <lastmod>${xmlEscape(item.lastmod)}</lastmod>` : ''}
    <changefreq>daily</changefreq>
    <priority>0.8</priority>
  </url>`,
  )
  .join('\n')}
</urlset>`;

    return responseXml(xml);
  } catch (error) {
    return responseXml(
      `<?xml version="1.0" encoding="UTF-8"?>
<error>${xmlEscape(error.message || error)}</error>`,
      500,
    );
  }
}
