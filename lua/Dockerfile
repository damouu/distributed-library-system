FROM openresty/openresty:alpine-fat

RUN luarocks install lua-resty-jwt

COPY ../nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ../lua/ /usr/local/openresty/nginx/lua/