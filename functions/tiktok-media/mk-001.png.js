const SOURCE_URL =
  "https://res.cloudinary.com/wajj1zqw/image/upload/v1789649497/mkcontentposterms0027.png";

export async function onRequestGet() {
  const upstream = await fetch(SOURCE_URL, {
    headers: { Accept: "image/png,image/*;q=0.9,*/*;q=0.8" }
  });

  if (!upstream.ok) {
    return new Response("Media unavailable.", {
      status: 502,
      headers: { "Cache-Control": "no-store" }
    });
  }

  const headers = new Headers();
  headers.set("Content-Type", upstream.headers.get("Content-Type") || "image/png");
  const length = upstream.headers.get("Content-Length");
  if (length) headers.set("Content-Length", length);
  headers.set("Cache-Control", "public, max-age=86400");
  headers.set("X-Content-Type-Options", "nosniff");

  return new Response(upstream.body, {
    status: 200,
    headers
  });
}

export async function onRequestHead() {
  const upstream = await fetch(SOURCE_URL, { method: "HEAD" });

  if (!upstream.ok) {
    return new Response(null, { status: 502 });
  }

  const headers = new Headers();
  headers.set("Content-Type", upstream.headers.get("Content-Type") || "image/png");
  const length = upstream.headers.get("Content-Length");
  if (length) headers.set("Content-Length", length);
  headers.set("Cache-Control", "public, max-age=86400");
  headers.set("X-Content-Type-Options", "nosniff");

  return new Response(null, {
    status: 200,
    headers
  });
}
