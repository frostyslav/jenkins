pipeline {
  environment {
    LUAJIT_VER="2.0.5"
    NDK_VER="0.3.0"
    NGX_VER="1.13.10"
    NGX_LUA_VER="0.10.11"
  }
  agent none

  stages {
    stage('Build'){
      agent {
        docker { image 'ubuntu:16.04'
                 args '-v /tmp/:/root/deb'
        }
      }

      steps {
      sh '''
      apt update && apt install wget make build-essential libpcre3-dev zlibc zlib1g-dev checkinstall

      wget http://luajit.org/download/LuaJIT-${LUAJIT_VER}.tar.gz
      tar xvf LuaJIT-${LUAJIT_VER}.tar.gz
      cd LuaJIT-${LUAJIT_VER}
      make
      make install
      cd ..

      wget https://github.com/simplresty/ngx_devel_kit/archive/v${NDK_VER}.tar.gz
      tar xvf v${NDK_VER}.tar.gz

      wget https://github.com/openresty/lua-nginx-module/archive/v${NGX_LUA_VER}.tar.gz
      tar xvf v${NGX_LUA_VER}.tar.gz

      wget http://nginx.org/download/nginx-${NGX_VER}.tar.gz
      tar xvf nginx-${NGX_VER}.tar.gz
      cd nginx-${NGX_VER}

      export LUAJIT_LIB=/usr/local/lib
      export LUAJIT_INC=/usr/local/include/luajit-2.0/

      ./configure --prefix=/opt/nginx \
               --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
               --add-module=/root/ngx_devel_kit-${NDK_VER} \
               --add-module=/root/lua-nginx-module-0.10.11

      checkinstall --install=no -D -y --maintainer=pzab --pkgversion=$NGX_VER --pkgname=nginx
      mkdir /root/deb
      cp nginx_${NGX_VER}-1_amd64.deb /root/deb/
      '''
      }
    }

  }
}
