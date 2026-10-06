import {getValidTikTokAccessToken} from "../../_lib/tiktokAuth.js";
import {getSessionOpenId,json} from "../../_lib/tiktokSession.js";
const URL="https://open.tiktokapis.com/v2/post/publish/creator_info/query/";
export async function onRequestGet({request,env}){
  try{
    const {openId}=await getSessionOpenId(request,env);
    const auth=await getValidTikTokAccessToken(env,openId);
    const r=await fetch(URL,{method:"POST",headers:{Authorization:`Bearer ${auth.accessToken}`,"Content-Type":"application/json; charset=UTF-8"}});
    const j=await r.json();
    if(!r.ok||j?.error?.code!=="ok") return json({ok:false,error:j?.error?.message||"TikTok creator info request failed.",tiktok_error:j?.error?.code||null},r.status||400);
    const c=j.data||{};
    return json({ok:true,creator_username:c.creator_username||null,creator_nickname:c.creator_nickname||null,creator_avatar_url:c.creator_avatar_url||null,privacy_level_options:c.privacy_level_options||[],comment_disabled:Boolean(c.comment_disabled),duet_disabled:Boolean(c.duet_disabled),stitch_disabled:Boolean(c.stitch_disabled),max_video_post_duration_sec:c.max_video_post_duration_sec??null});
  }catch(e){return json({ok:false,error:e?.message||"TikTok account is not connected."},401);}
}
