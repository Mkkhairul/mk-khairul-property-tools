import {parseCookies,sessionCookie} from "../../_lib/tiktokSession.js";
export async function onRequestGet({request,env}){
  const url=new URL(request.url);
  const code=url.searchParams.get("code"), returned=url.searchParams.get("state");
  const oauthError=url.searchParams.get("error");
  if(oauthError) return redirect("/tiktok?error="+encodeURIComponent(url.searchParams.get("error_description")||oauthError));
  const saved=parseCookies(request.headers.get("Cookie")||"").tiktok_oauth_state;
  if(!returned||!saved||returned!==saved) return redirect("/tiktok?error="+encodeURIComponent("OAuth state verification failed."));
  if(!code) return redirect("/tiktok?error="+encodeURIComponent("Authorization code was not received."));
  if(!env.TIKTOK_CLIENT_KEY||!env.TIKTOK_CLIENT_SECRET||!env.TIKTOK_TOKENS) return redirect("/tiktok?error="+encodeURIComponent("TikTok OAuth is not configured."));
  const redirectUri=url.origin+"/api/tiktok/callback";
  const body=new URLSearchParams({client_key:env.TIKTOK_CLIENT_KEY,client_secret:env.TIKTOK_CLIENT_SECRET,code,grant_type:"authorization_code",redirect_uri:redirectUri});
  try{
    const r=await fetch("https://open.tiktokapis.com/v2/oauth/token/",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded","Cache-Control":"no-cache"},body:body.toString()});
    const t=await r.json();
    if(!r.ok||!t.access_token||!t.refresh_token||!t.open_id) return redirect("/tiktok?error="+encodeURIComponent(t.error_description||t.error||"TikTok token exchange failed."));
    const now=Date.now();
    const rec={open_id:t.open_id,access_token:t.access_token,refresh_token:t.refresh_token,scope:t.scope||"",token_type:t.token_type||"Bearer",expires_in:t.expires_in||null,refresh_expires_in:t.refresh_expires_in||null,access_token_expires_at:t.expires_in?now+Number(t.expires_in)*1000:null,refresh_token_expires_at:t.refresh_expires_in?now+Number(t.refresh_expires_in)*1000:null,updated_at:new Date(now).toISOString()};
    await env.TIKTOK_TOKENS.put("tiktok:"+t.open_id,JSON.stringify(rec));
    const sid=crypto.randomUUID().replaceAll("-","");
    await env.TIKTOK_TOKENS.put("session:"+sid,t.open_id,{expirationTtl:2592000});
    const h=new Headers({Location:"/tiktok","Cache-Control":"no-store"});
    h.append("Set-Cookie",sessionCookie(sid));
    h.append("Set-Cookie","tiktok_oauth_state=; Path=/api/tiktok; HttpOnly; Secure; SameSite=Lax; Max-Age=0");
    return new Response(null,{status:302,headers:h});
  }catch(e){return redirect("/tiktok?error="+encodeURIComponent("TikTok connection failed."));}
}
function redirect(path){return new Response(null,{status:302,headers:{Location:path,"Cache-Control":"no-store"}});}
