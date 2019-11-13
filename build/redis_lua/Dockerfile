FROM redis

# add lua to container
# add支持拷贝进容器后自动解压缩
# ADD lua-5.3.5.tar.gz /
ADD http://www.lua.org/ftp/lua-5.3.5.tar.gz /

RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y libreadline-dev
RUN apt-get install -y make
RUN make -C /lua-5.3.5 linux
RUN make -C /lua-5.3.5 install