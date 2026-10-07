import {getValidTikTokAccessToken} from "../../_lib/tiktokAuth.js";
import {getSessionOpenId,json} from "../../_lib/tiktokSession.js";
const TIKTOK_PUBLISH_URL="https://open.tiktokapis.com/v2/post/publish/content/init/";
export async function onRequestPost({request,env}){
  try{
    const {openId}=await getSessionOpenId(request,env);
    const b=await request.json();
    if(b?.consent!==true) return json({ok:false,error:"Please confirm consent before posting."},400);
    const title=String(b?.title||"").trim();
    const description=String(b?.description||"").trim();
    const privacy=String(b?.privacy_level||"").trim();
    const images=Array.isArray(b?.photo_images)?b.photo_images.filter(Boolean):[];
    if(!title || !privacy || !images.length || images.length>10) return json({ok:false,error:"Title, privacy and 1-10 photos are required."},400);
    const origin=new globalThis.URL(request.url).origin;
    if(!images.every(x=>{try{const u=new globalThis.URL(x);return u.origin===origin && u.pathname.startsWith("/tiktok-user-media/");}catch{return false;}}))
      return json({ok:false,error:"Please upload photos through this page before posting."},400);
    const auth=await getValidTikTokAccessToken(env,openId);
    const ci=await fetch("https://open.tiktokapis.com/v2/post/publish/creator_info/query/",{method:"POST",headers:{Authorization:`Bearer ${auth.accessToken}`,"Content-Type":"application/json; charset=UTF-8"}});
    const cj=await ci.json();
    if(!ci.ok || cj?.error?.code!=="ok") return json({ok:false,error:cj?.error?.message||"Could not refresh creator settings."},400);
    const c=cj.data||{}, allowed=c.privacy_level_options||[];
    if(!allowed.includes(privacy)) return json({ok:false,error:"Selected privacy option is no longer available. Refresh the page."},400);
    const allowComment=b?.allow_comment===true && !c.comment_disabled;
    const commercial=b?.commercial===true, yourBrand=b?.your_brand===true, branded=b?.branded_content===true;
    if(commercial && !yourBrand && !branded) return json({ok:false,error:"Select Your Brand and/or Branded Content for commercial content."},400);
    const payload={
      post_info:{title,description,privacy_level:privacy,disable_comment:!allowComment,auto_add_music:true,brand_organic_toggle:commercial&&yourBrand,brand_content_toggle:commercial&&branded},
      source_info:{source:"PULL_FROM_URL",photo_cover_index:0,photo_images:images},
      post_mode:"DIRECT_POST",media_type:"PHOTO",is_aigc:b?.is_aigc===true
    };
    const r=await fetch(TIKTOK_PUBLISH_URL,{method:"POST",headers:{Authorization:`Bearer ${auth.accessToken}`,"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(payload)});
    const j=await r.json();
    if(!r.ok || j?.error?.code!=="ok") return json({ok:false,error:j?.error?.message||"TikTok publish initialization failed.",tiktok_error:j?.error?.code||null},r.status||400);
    return json({ok:true,publish_id:j?.data?.publish_id||null,message:"Content sent to TikTok."});
  }catch(e){return json({ok:false,error:e?.message||"Publish failed."},401);}
}
