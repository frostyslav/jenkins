# STAGE 1. Build
FROM ubuntu:16.04 as builder
ENV LUAJIT_VER="2.0.5" \
    NDK_VER="0.3.0" \
    NGX_VER="1.13.10" \
    NGX_LUA_VER="0.10.11"

# Install requirements
RUN apt update && \
    apt install -y make build-essential libpcre3-dev zlibc zlib1g-dev checkinstall

# Install lua
ADD http://luajit.org/download/LuaJIT-${LUAJIT_VER}.tar.gz ./
RUN tar xvf LuaJIT-${LUAJIT_VER}.tar.gz && \
    cd LuaJIT-${LUAJIT_VER} && \
    make && make install

# Download and untar ngx devel kit and lua-nginx-module
ADD https://github.com/simplresty/ngx_devel_kit/archive/v${NDK_VER}.tar.gz ./
RUN tar xvf v${NDK_VER}.tar.gz
ADD https://github.com/openresty/lua-nginx-module/archive/v${NGX_LUA_VER}.tar.gz ./
RUN tar xvf v${NGX_LUA_VER}.tar.gz

# Compile nginx with required options and create deb file
ADD http://nginx.org/download/nginx-${NGX_VER}.tar.gz ./
ENV LUAJIT_LIB=/usr/local/lib \
    LUAJIT_INC=/usr/local/include/luajit-2.0/
RUN tar xvf nginx-${NGX_VER}.tar.gz && \
    ls -alt && \
    cd nginx-${NGX_VER} && \
    ./configure --prefix=/opt/nginx \
                --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
                --add-module=/ngx_devel_kit-${NDK_VER} \
                --add-dynamic-module=/lua-nginx-module-0.10.11 \
    && checkinstall --install=no -D -y --maintainer=pzab --pkgversion=$NGX_VER --pkgname=nginx

# STAGE 2.
#FROM bitnami/minideb:stretch as application
FROM ubuntu:16.04 as application
ENV NGX_VER="1.13.10"
COPY --from=builder /nginx-${NGX_VER}/nginx_${NGX_VER}-1_amd64.deb /
RUN dpkg -i nginx_${NGX_VER}-1_amd64.deb
EXPOSE 80 80
