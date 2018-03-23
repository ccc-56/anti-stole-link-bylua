--[[ by dongzh 
--for time-based url anti-stole
--encode url: curl -x 10.103.23.135:8087  't1.etcp.cn/h14?m=en&file=44.html'
--normal visit: curl -x 10.103.23.135:8087 't1.etcp.cn/h14m3u4L508G7IfapE9pdrTh4KY7bi856/r8aQ0bWcqAcLWb7t6hq7opcfcJgbFs=m3u4L508G7IfapE9pd44.html'
--]]

local aes = require "resty.aes"
local str = require "resty.string"
local aob = aes:new("this is ","ttInetCp",aes.cipher(256,"cbc"), aes.hash.sha512, 5)
local interface = "/h14"

--random string
local sympdel = "m3u4L508G7IfapE9pd"

function main()
    if ngx.var.is_args ~= "" then
        --encode filename
        encodeurl()
    else
        --decode url
        judgeurl()
    end
end

function judgeurl()
    local urlinterface
    local tokenid
    local filename
    local url = ngx.var.request_uri
    local beginuxtime
    local beginfilename
    local timediff
    local m,err = ngx.re.match(url,"/([0-9a-zA-Z]+)"..sympdel.."([0-9a-zA-Z%=%+%/]+)"..sympdel.."([0-9a-zA-Z%.]+)")
    if m then
        urlinterface = "/"..m[1]
        tokenid = m[2]
        filename = m[3]
        if interface ~= urlinterface then
            ngx.log(ngx.ERR,"bad interface")
            ngx.exit(408)
        elseif #tokenid ~= 44 then
            ngx.log(ngx.ERR,"bad token")
            ngx.exit(409)
        else
            local detxt = aob:decrypt(ngx.decode_base64(tokenid))
            beginuxtime = detxt:sub(1,10)
            beginfilename = detxt:sub(11)
            if beginfilename ~= filename then
                ngx.log(ngx.ERR,"bad url")
                ngx.exit(411)
            else
                timediff = math.abs(tonumber(ngx.time()) - tonumber(beginuxtime))
                if timediff <= 5*60 then
                    --ngx.exec("/ch114/"..filename)
                    setrealroot(filename)
                else
                    ngx.log(ngx.ERR,"url has expired yet!")
                    ngx.exit(410)
                end
            end
        end
    else
        if err then
            ngx.log(ngx.ERR,"error: ",err)
            return
        end
        ngx.say("url bad format")
    end
    return
end

function encodeurl()
    local uris = ngx.req.get_uri_args()
    local count = 0
    local filename 
    local method
    for k,v in pairs(uris) do
        if k == "file" then
            filename = v
        end 
        if k == "m" then
            method = v
        end 
        count = count + 1
    end
    if count == 2 and filename ~= nil and method == "en" and ngx.var.uri == interface then
        local url = genenurl(filename)
        ngx.say(url)
    else
        ngx.exit(405)
        return
    end
end

function genenurl(fname)
    local url
    local filename = fname
    local ens = aob:encrypt(tostring(ngx.time())..filename)
    local bens = ngx.encode_base64(ens)
    url =  ngx.var.server_name .. ngx.var.uri .. sympdel..bens .. sympdel..filename
    return url
end

function setrealroot(fname)
    ngx.var.vroot = "/root/work/Eimg"
    ngx.req.set_uri("/ch114/"..fname)
end

main()
