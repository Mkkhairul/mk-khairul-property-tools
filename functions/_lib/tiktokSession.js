export function parseCookies(header=""){
  const out={};
  for(const part of header.split(";")){
    const i=part.indexOf("="); if(i<0) continue;
    const k=part.slice(0,i).trim(), v=part.slice(i+1).trim();
    if(k) out[k]=decodeURIComponent(v);
  }
  return out;
}
export async function getSessionOpenId(request,env){
  const store=env.TIKTOK_TOKENS;
  if(!store) throw new Error("TikTok token storage is not configured.");
  const sid=parseCookies(request.headers.get("Cookie")||"").mk_tiktok_session;
  if(!sid) throw new Error("TikTok account is not connected.");
  const openId=await store.get("session:"+sid);
  if(!openId) throw new Error("TikTok session expired. Please connect again.");
  return {sid,openId};
}
export function sessionCookie(sid){
  return `mk_tiktok_session=${encodeURIComponent(sid)}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=2592000`;
}
export function json(data,status=200){
  return new Response(JSON.stringify(data,null,2),{status,headers:{"Content-Type":"application/json; charset=utf-8","Cache-Control":"no-store"}});
}
