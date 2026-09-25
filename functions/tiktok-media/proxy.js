const ALLOWED_HOST = "res.cloudinary.com";
const ALLOWED_CLOUD = "wajj1zqw";

function safeSource(raw) {
  let u;
  try { u = new URL(raw); } catch { return null; }
  if (u.protocol !== "https:" || u.hostname !== ALLOWED_HOST) return null;
  const parts = u.pathname.split("/").filter(Boolean);
  if (parts[0] !== ALLOWED_CLOUD || parts[1] !== "image" || parts[2] !== "upload") return null;
  if (!u.pathname.includes("/image/upload/")) return null;
  u.pathname = u.pathname.replace("/image/upload/", "/image/upload/f_jpg,q_auto/");
  return u.toString();
}

async function serve(request) {
  const reqUrl = new URL(request.url);
  const src = safeSource(reqUrl.searchParams.get("src") || "");
  if (!src) return new Response("Invalid media source.", { status: 400, headers: {"Cache-Control":"no-store"} });

  const upstream = await fetch(src, { method: request.method === "HEAD" ? "HEAD" : "GET", headers: { Accept: "image/jpeg,image/*;q=0.9,*/*;q=0.8" }});
  if (!upstream.ok) return new Response("Media unavailable.", { status: 502, headers: {"Cache-Control":"no-store"} });

  const h = new Headers();
  h.set("Content-Type","image/jpeg");
  const len=upstream.headers.get("Content-Length"); if(len) h.set("Content-Length",len);
  h.set("Cache-Control","public, max-age=86400");
  h.set("X-Content-Type-Options","nosniff");
  return new Response(request.method === "HEAD" ? null : upstream.body,{status:200,headers:h});
}
export function onRequestGet({request}) { return serve(request); }
export function onRequestHead({request}) { return serve(request); }
