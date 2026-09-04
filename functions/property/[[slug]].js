const LISTING_API =
  'https://script.google.com/macros/s/AKfycbyKKrioq22adrb2wpdad3wj6CedlqhLzEomOCkR-AdXcjU75M9pNTTySz5xYBEqN8gb/exec';

function escapeHtml(value = '') {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

function safeJson(data) {
  return JSON.stringify(data).replace(/</g, '\\u003c');
}

function cleanText(value) {
  return String(value ?? '').trim();
}

function getImage(property) {
  const possibleFields = [
    'SEO Image',
    'Image1',
    'Image',
    'Image 1',
    'Image URL',
    'Main Image',
    'Thumbnail',
  ];

  for (const field of possibleFields) {
    const value = cleanText(property[field]);
    if (value.startsWith('http')) return value;
  }

  return 'https://mkkhairul.pages.dev/icons/Icon-512.png';
}

function getPrice(property) {
  const raw =
    property['Current Price'] ??
    property['Price'] ??
    property['Selling Price'] ??
    '';

  const number = Number(
    String(raw)
      .replace(/RM/gi, '')
      .replace(/,/g, '')
      .replace(/[^\d.]/g, ''),
  );

  return Number.isFinite(number) && number > 0 ? number : null;
}

export async function onRequestGet(context) {
  const requestUrl = new URL(context.request.url);
  const origin = requestUrl.origin;

  const slugParam = context.params.slug;
  const slug = Array.isArray(slugParam)
    ? slugParam.join('/')
    : String(slugParam ?? '').trim();

  if (!slug) {
    return context.next();
  }

  try {
    const apiResponse = await fetch(LISTING_API, {
      headers: {
        Accept: 'application/json',
      },
    });

    if (!apiResponse.ok) {
      return context.next();
    }

    const data = await apiResponse.json();

    const listings = Array.isArray(data)
      ? data
      : Array.isArray(data.listings)
          ? data.listings
          : [];

    const property = listings.find((item) => {
      const seoSlug = cleanText(
        item['SEO Slug'] ??
        item['SEO slug'] ??
        item['Seo Slug'],
      );

      return seoSlug.toLowerCase() === slug.toLowerCase();
    });

    if (!property) {
      return context.next();
    }

    const title =
      cleanText(property['SEO Title']) ||
      cleanText(property['Title']) ||
      'Property Malaysia | MK Khairul';

    const metaDescription =
      cleanText(property['Meta Description']) ||
      cleanText(property['SEO Description']) ||
      cleanText(property['Description']) ||
      'Property listing Malaysia bersama MK Khairul Property Tools.';

    const propertyTitle =
      cleanText(property['Title']) || title;

    const canonical =
      `${origin}/property/${encodeURIComponent(slug)}`;

    const image = getImage(property);

    const location = [
      cleanText(property['Location']),
      cleanText(property['State']),
    ]
      .filter(Boolean)
      .join(', ');

    const propertyType =
      cleanText(property['Property Type']) || 'Property';

    const price = getPrice(property);


    const schema = {
  '@context': 'https://schema.org',

  '@graph': [
    {
      '@type': 'WebPage',
      '@id': `${canonical}#webpage`,
      url: canonical,
      name: title,
      description: metaDescription,
      inLanguage: 'ms-MY',

      breadcrumb: {
        '@id': `${canonical}#breadcrumb`,
      },

      isPartOf: {
        '@type': 'WebSite',
        '@id': `${origin}/#website`,
        url: `${origin}/`,
        name: 'MK Khairul Property Tools',
      },

      primaryImageOfPage: {
        '@type': 'ImageObject',
        url: image,
      },

      mainEntity: {
        '@type': 'Offer',
        url: canonical,
        name: propertyTitle,
        description: metaDescription,

        itemOffered: {
          '@type': 'Place',
          name: propertyTitle,
          description: propertyType,

          ...(location
            ? {
                address: {
                  '@type': 'PostalAddress',
                  addressLocality: cleanText(property['Location']),
                  addressRegion: cleanText(property['State']),
                  addressCountry: 'MY',
                },
              }
            : {}),
        },

        ...(price
          ? {
              priceCurrency: 'MYR',
              price,
            }
          : {}),
      },
    },

    {
      '@type': 'BreadcrumbList',
      '@id': `${canonical}#breadcrumb`,

      itemListElement: [
        {
          '@type': 'ListItem',
          position: 1,
          name: 'Home',
          item: `${origin}/`,
        },
        {
          '@type': 'ListItem',
          position: 2,
          name: 'Properties',
          item: `${origin}/properties`,
        },
        {
          '@type': 'ListItem',
          position: 3,
          name: propertyTitle,
          item: canonical,
        },
      ],
    },
  ],
};


    const assetUrl = new URL('/', requestUrl);
    const assetResponse = await context.env.ASSETS.fetch(assetUrl);

    if (!assetResponse.ok) {
      return assetResponse;
    }

    let html = await assetResponse.text();

    html = html
      .replace(
        /<title>[\s\S]*?<\/title>/i,
        `<title>${escapeHtml(title)}</title>`,
      )
      .replace(
        /<meta\s+name="description"[\s\S]*?>/i,
        `<meta name="description" content="${escapeHtml(metaDescription)}">`,
      )
      .replace(
        /<link\s+rel="canonical"[\s\S]*?>/i,
        `<link rel="canonical" href="${escapeHtml(canonical)}">`,
      )
      .replace(
        /<meta\s+property="og:type"[\s\S]*?>/i,
        `<meta property="og:type" content="website">`,
      )
      .replace(
        /<meta\s+property="og:title"[\s\S]*?>/i,
        `<meta property="og:title" content="${escapeHtml(title)}">`,
      )
      .replace(
        /<meta\s+property="og:description"[\s\S]*?>/i,
        `<meta property="og:description" content="${escapeHtml(metaDescription)}">`,
      )
      .replace(
        /<meta\s+property="og:url"[\s\S]*?>/i,
        `<meta property="og:url" content="${escapeHtml(canonical)}">`,
      )
      .replace(
        /<meta\s+property="og:image"[\s\S]*?>/i,
        `<meta property="og:image" content="${escapeHtml(image)}">`,
      )
      .replace(
        /<meta\s+name="twitter:title"[\s\S]*?>/i,
        `<meta name="twitter:title" content="${escapeHtml(title)}">`,
      )
      .replace(
        /<meta\s+name="twitter:description"[\s\S]*?>/i,
        `<meta name="twitter:description" content="${escapeHtml(metaDescription)}">`,
      )
      .replace(
        /<meta\s+name="twitter:image"[\s\S]*?>/i,
        `<meta name="twitter:image" content="${escapeHtml(image)}">`,
      )
      .replace(
        /<\/head>/i,
        `<script type="application/ld+json">${safeJson(schema)}</script>\n</head>`,
      );

    return new Response(html, {
      status: 200,
      headers: {
        'Content-Type': 'text/html; charset=UTF-8',
        'Cache-Control': 'public, max-age=300',
      },
    });
  } catch (error) {
    return context.next();
  }
}