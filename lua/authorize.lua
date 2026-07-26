local jwt = require "resty.jwt"

local function read_file(path)
    local f = io.open(path, "rb")
    if not f then
        return nil
    end
    local content = f:read("*all")
    f:close()
    return content
end

local key_path = "/usr/local/openresty/nginx/keys/public.pem"
local public_key = read_file(key_path)

if not public_key then
    ngx.log(ngx.ERR, "FILE NOT FOUND: ", key_path)
    ngx.status = 500
    ngx.header.content_type = "application/json"
    ngx.say('{"error": "Internal Server Error", "message": "Security key missing"}')
    return ngx.exit(500)
end

local auth_header = ngx.var.http_Authorization
if not auth_header or not string.find(auth_header, "Bearer ") then
    ngx.status = 401
    ngx.header.content_type = "application/json"
    ngx.say('{"error": "Missing or malformed Token"}')
    return ngx.exit(401)
end

local token = string.sub(auth_header, 8)

local res = jwt:verify(public_key, token)

if not res.verified then
    ngx.status = 401
    ngx.header.content_type = "application/json"
    local message = res.reason or "Invalid Token"
    ngx.say('{"error": "Unauthorized", "message": "' .. message .. '", "code": "TOKEN_INVALID"}')
    return ngx.exit(401)
end

if res.payload and res.payload.member_card_uuid then
    ngx.req.set_header("X-User-UUID", res.payload.member_card_uuid)
end