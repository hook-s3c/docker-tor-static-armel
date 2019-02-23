FROM multiarch/ubuntu-core:x86-xenial

#install curl and build essential
RUN apt-get update
RUN apt-get install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi binutils-arm-linux-gnueabi
RUN apt-get install -y build-essential curl
RUN apt-get install -y xutils-dev
# Can't use system versions of libz, libevent, or libssl when doing a static build.


## Build openssl from source
RUN export cross=arm-linux-gnueabi-
RUN curl -fsSL "https://www.openssl.org/source/openssl-1.0.2m.tar.gz" | tar zxvf -
WORKDIR openssl-1.0.2m
RUN uname -m
RUN export MACHINE=arm
RUN sed -i s/read\ GUESSOS/GUESSOS\=armv7-whatever-linux2/ ./config
RUN CC="arm-linux-gnueabi-gcc" CXX="arm-linux-gnueabi-g++" CXXFLAGS="-c -fPIC" RANLIB="arm-linux-gnueabi-ranlib" ./config --prefix=$PWD/install no-zlib no-shared no-dso 
#RUN ls /usr/arm-linux-gnueabi/bin/

RUN make depend
RUN make -j1
RUN make install
#RUN make CXX="arm-linux-gnueabi-g++" CXXFLAGS="-c" CC="arm-linux-gnueabi-gcc" AR="arm-linux-gnueabi-ar r" RANLIB="arm-linux-gnueabi-ranlib"
#RUN make install CC="arm-linux-gnueabi-gcc" AR="arm-linux-gnueabi-ar r" RANLIB="arm-linux-gnueabi-ranlib"
WORKDIR ..



# Build zlib from source
RUN curl -fsSL "https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz" | tar zxvf -
WORKDIR libevent-2.1.8-stable
RUN CXX="arm-linux-gnueabi-g++" CXXFLAGS="-c"  ./configure --host=arm-linux-gnueabi --prefix=$PWD/install \
                --disable-shared \
                --enable-static \
		--with-pic \
		--disable-samples \
		--disable-libevent-regress
RUN make -j$(nproc) 
RUN make install 
WORKDIR ..

# Build zlib from source
RUN curl -fsSL "https://zlib.net/zlib-1.2.11.tar.gz" | tar zxvf -
WORKDIR zlib-1.2.11
RUN CFLAGS="-O4" CC="arm-linux-gnueabi-gcc" CXX="arm-linux-gnueabi-g++" CXXFLAGS="-c" ./configure --prefix=$PWD/install

RUN make -j$(nproc)
RUN make  install
WORKDIR ..




# Static toribuild
ARG TOR_VERSION
#ENV TOR_VERSION=0.3.5.6-rc
#RUN curl -fsSL "https://www.torproject.com/dist/tor-${TOR_VERSION}.tar.gz" | tar xzf -

ENV TOR_VERSION=0.3.3.10
RUN curl -fsSL "https://archive.torproject.org/tor-package-archive/tor-${TOR_VERSION}.tar.gz" | tar xzf -

WORKDIR tor-${TOR_VERSION}

RUN ls /libevent-2.1.8-stable/

RUN CC="arm-linux-gnueabi-gcc" CXX="arm-linux-gnueabi-g++" CXXFLAGS="-c"  ./configure --host=arm-linux-gnueabi --prefix=$PWD/install \
                --enable-static-tor \
		--enable-static-libevent --with-libevent-dir=/libevent-2.1.8-stable/install \
                --enable-static-openssl --with-openssl-dir=/openssl-1.0.2m/install \
                --enable-static-zlib --with-zlib-dir=/zlib-1.2.11/install \
		--disable-gcc-hardening \
		--disable-system-torrc \
		--disable-asciidoc \
		--disable-systemd \
		--disable-lzma \
		--disable-seccomp


RUN make -j$(nproc)
RUN make CC="arm -linux-gnueabi-gcc" AR="arm-linux-gnueabi-ar r" RANLIB="arm-linux-gnueabi-ranlib" install
