import { getValidTikTokAccessToken } from "../../_lib/tiktokAuth.js";

const PUBLISH_URL = "https://open.tiktokapis.com/v2/post/publish/content/init/";
const MAX_MEDIA = 10;

function json(data,status=200){return new Response(JSON.stringify(data,null,2),{status,headers:{"Content-Type":"application/json; charset=utf-8","Cache-Control":"no-store"}});}
function authorized(req,env){
  const expected=String(env.TIKTOK_AUTOMATION_SECRET||"");
  const got=String(req.headers.get("X-MK-Automation-Secret")||"");
  return expected && got && expected===got;
}
function validCloudinary(raw){
  try{
    const u=new URL(raw);
    return u.protocol==="https:" && u.hostname==="res.cloudinary.com" && u.pathname.startsWith("/wajj1zqw/image/upload/");
  }catch{return false;}
}
export async function onRequestPost(context){
  try{
    if(!authorized(context.request,context.env)) return json({ok:false,error:"Unauthorized."},401);
    const b=await context.request.json();
    const contentId=String(b?.content_id||"").trim();
    const title=String(b?.title||"").trim().slice(0,90);
    const caption=String(b?.caption||"").trim();
    const hashtags=String(b?.hashtags||"").trim();
    const approved=b?.approved===true;
    const media=Array.isArray(b?.media)?b.media.filter(Boolean):[];
    if(!/^MK-\d{3,}$/.test(contentId)) return json({ok:false,error:"Invalid content_id."},400);
    if(!approved) return json({ok:false,error:"Content is not approved for posting."},409);
    if(!caption || !media.length || media.length>MAX_MEDIA) return json({ok:false,error:"Caption and 1-10 media items are required."},400);
    if(!media.every(validCloudinary)) return json({ok:false,error:"Only approved MK KHAIRUL Cloudinary media is allowed."},400);

    const origin=new URL(context.request.url).origin;
    const photoImages=media.map(src=>origin+"/tiktok-media/proxy?src="+encodeURIComponent(src));
    const auth=await getValidTikTokAccessToken(context.env);
    const payload={
      post_info:{
        title:title||contentId,
        description:(caption+" "+hashtags).trim(),
        disable_comment:false,
        privacy_level:String(b?.privacy_level||"SELF_ONLY"),
        auto_add_music:true,
        brand_content_toggle:false,
        brand_organic_toggle:true
      },
      source_info:{source:"PULL_FROM_URL",photo_cover_index:0,photo_images:photoImages},
      post_mode:"DIRECT_POST",
      media_type:"PHOTO",
      is_aigc:b?.is_aigc!==false
    };
    const response=await fetch(PUBLISH_URL,{method:"POST",headers:{Authorization:`Bearer ${auth.accessToken}`,"Content-Type":"application/json; charset=UTF-8"},body:JSON.stringify(payload)});
    const result=await response.json();
    if(!response.ok || result?.error?.code!=="ok") return json({ok:false,service:"MK KHAIRUL TikTok Dynamic Publisher",content_id:contentId,tiktok_error:result?.error?.code||"publish_init_failed",message:result?.error?.message||"TikTok publish initialization failed."},response.status||500);
    return json({ok:true,service:"MK KHAIRUL TikTok Dynamic Publisher",content_id:contentId,publish_initialized:true,publish_id:result?.data?.publish_id||null,privacy_level:payload.post_info.privacy_level,auto_add_music:true,media_count:photoImages.length,token_refreshed:Boolean(auth.refreshed)});
  }catch(e){return json({ok:false,service:"MK KHAIRUL TikTok Dynamic Publisher",error:e?.message||"Publish failed."},500);}
}
