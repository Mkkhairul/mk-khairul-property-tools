export async function onRequestGet({params,env}){
  const id=String(params.id||"").replace(/[^a-zA-Z0-9]/g,"");
  if(!id) return new Response("Not found",{status:404});
  const result=await env.TIKTOK_TOKENS.getWithMetadata("media:"+id,{type:"arrayBuffer"});
  if(!result?.value) return new Response("Media expired or not found",{status:404});
  return new Response(result.value,{headers:{"Content-Type":result.metadata?.type||"application/octet-stream","Cache-Control":"public, max-age=3600"}});
}
