
function xmlEscape(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

export function onRequestGet(context) {
  const origin = new URL(context.request.url).origin;

  const urls = [
    { loc: `${origin}/`, changefreq: 'daily', priority: '1.0' },
    { loc: `${origin}/properties`, changefreq: 'daily', priority: '0.9' },
  ];

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls
  .map(
    (item) => `  <url>
    <loc>${xmlEscape(item.loc)}</loc>
    <changefreq>${item.changefreq}</changefreq>
    <priority>${item.priority}</priority>
  </url>`,
  )
  .join('\n')}
</urlset>`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml; charset=UTF-8',
      'Cache-Control': 'public, max-age=300',
      'X-Robots-Tag': 'noindex',
    },
  });
}
