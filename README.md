# -
# - time based anti-stole chain
# nginx configuration was as below:
     location  /h14 {  
         #here /h14 must be configure in the lua file /root/work/lua/ence.lua;
         include mime.types;
         set $vroot "/root/work/img";
         root  $vroot;
         rewrite_by_lua_file '/root/work/lua/ence.lua';
     }


#user example:
#generate link:
#curl -x 10.103.23.135:8087  't1.etcp.cn/h14?m=en&file=44.html'
#result: t1.etcp.cn/h14m3u4L508G7IfapE9pdkDfqy3gvKVFtUbv6Icie0ADph4Vq29WWRHzk7XXWgp4=m3u4L508G7IfapE9pd44.html

#visit link after a period:
# curl -x 10.103.23.135:8087 't1.etcp.cn/h14m3u4L508G7IfapE9pdpHMdjqtVjTUMqzNA04155Vv2ZRzPDIKInIiTizvu6Mc=m3u4L508G7IfapE9pd33.html'
#<html>
#<head><title>410 Gone</title></head>
#<body bgcolor="white">
#<center><h1>410 Gone</h1></center>
#<hr><center>openresty/1.13.6.1</center>
#</body>
#</html>


