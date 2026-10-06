import {getValidTikTokAccessToken} from "../../_lib/tiktokAuth.js";
import {getSessionOpenId,json} from "../../_lib/tiktokSession.js";
const URL="https://open.tiktokapis.com/v2/post/publish/status/fetch/";
export async function onRequestPost({request,env}){
  try{
    const {openId}=await getSessionOpenId(request,env);
    const b=await request.json(), id=String(b?.publish_id||"").trim();
    if(!id||id.length>128) return json({ok:false,error:"A valid publish_id is required."},400);
    const auth=await getValidTikTokAccessToken(env,openId);
    const r=await fetch(URL,{method:"POST",headers:{Authorization:`Bearer ${auth.accessToken}`,"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify({publish_id:id})});
    const j=await r.json();
    if(!r.ok||j?.error?.code!=="ok") return json({ok:false,error:j?.error?.message||"TikTok publish status request failed.",tiktok_error:j?.error?.code||null},r.status||400);
    const d=j.data||{};
    return json({ok:true,status:d.status||null,fail_reason:d.fail_reason||null,publicly_available_post_id:d.publicly_available_post_id||[]});
  }catch(e){return json({ok:false,error:e?.message||"Publish status check failed."},401);}
}
