import {getSessionOpenId,json} from "../../_lib/tiktokSession.js";
const MAX=10*1024*1024;
export async function onRequestPost({request,env}){
  try{
    const {openId}=await getSessionOpenId(request,env);
    const form=await request.formData();
    const file=form.get("file");
    if(!file || typeof file.arrayBuffer!=="function") return json({ok:false,error:"Choose a JPG, JPEG, PNG or WEBP image."},400);
    const type=String(file.type||"").toLowerCase();
    if(!["image/jpeg","image/png","image/webp"].includes(type)) return json({ok:false,error:"Only JPG, PNG or WEBP images are supported."},400);
    if(file.size<1 || file.size>MAX) return json({ok:false,error:"Image must be 10 MB or smaller."},400);
    const id=crypto.randomUUID().replaceAll("-","");
    const key=`media:${id}`;
    await env.TIKTOK_TOKENS.put(key,await file.arrayBuffer(),{expirationTtl:86400,metadata:{type,owner:openId,name:String(file.name||"image")}});
    const origin=new URL(request.url).origin;
    return json({ok:true,id,url:`${origin}/tiktok-user-media/${id}`,expires_in:86400});
  }catch(e){return json({ok:false,error:e?.message||"Upload failed."},401);}
}
