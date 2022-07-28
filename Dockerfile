FROM ubuntu:latest

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get install -y git make gcc curl zlib1g-dev libpcre3-dev vim

WORKDIR /build
ENV BUILD_DIR /build

RUN curl -L -o openssl.tar.gz \
    https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_1_1_1q.tar.gz

RUN curl -L -o nginx.tar.gz \
    https://github.com/nginx/nginx/archive/refs/tags/release-1.23.0.tar.gz

RUN curl -L -o nginx-ssl-fingerprint.tar.gz \
    https://github.com/phuslu/nginx-ssl-fingerprint/archive/refs/tags/v0.3.0.tar.gz

RUN curl -L -o lua-nginx-module.tar.gz \
    https://github.com/openresty/lua-nginx-module/archive/refs/tags/v0.10.21.tar.gz

RUN curl -L -o ngx_devel_kit.tar.gz \
    https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v0.3.1.tar.gz

RUN curl -L -o LuaJIT.tar.gz \
    https://github.com/LuaJIT/LuaJIT/archive/refs/tags/v2.1.0-beta3.tar.gz

RUN curl -L -o lua-upstream-nginx-module.tar.gz \
    https://github.com/openresty/lua-upstream-nginx-module/archive/refs/tags/v0.07.tar.gz

RUN curl -L -o echo-nginx-module.tar.gz \
    https://github.com/openresty/echo-nginx-module/archive/refs/tags/v0.62.tar.gz

RUN tar xvf openssl.tar.gz
RUN tar xvf nginx.tar.gz
RUN tar xvf nginx-ssl-fingerprint.tar.gz
RUN tar xvf lua-nginx-module.tar.gz
RUN tar xvf ngx_devel_kit.tar.gz
RUN tar xvf LuaJIT.tar.gz
RUN tar xvf lua-upstream-nginx-module.tar.gz
RUN tar xvf echo-nginx-module.tar.gz

COPY build.sh ${BUILD_DIR}
COPY Makefile ${BUILD_DIR}

RUN cd ${BUILD_DIR}/LuaJIT && \
	make PREFIX=${BUILD_DIR}/LuaJIT && \
	make install PREFIX=${BUILD_DIR}/ngx_lib

RUN make patch && \
   make build && \
   mkdir logs

EXPOSE 443
EXPOSE 8444

CMD ./nginx/objs/nginx -p /build -c nginx-ssl-fingerprint/conf/nginx.conf
