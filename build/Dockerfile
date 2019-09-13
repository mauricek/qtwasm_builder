FROM ubuntu:latest AS baseBuild

ARG packages="build-essential git cmake \
python3 \
python \
ninja-build \
build-essential \
"
# Required for non-interactive timezone installation
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN apt-get update && apt-get install -q -yy $packages

RUN mkdir -p /root/dev
WORKDIR /root/dev

RUN git clone https://github.com/emscripten-core/emsdk.git
WORKDIR /root/dev/emsdk

RUN ./emsdk install latest
RUN ./emsdk activate latest

ENV PATH="/root/dev/emsdk:/root/dev/emsdk/fastcomp/emscripten:/root/dev/emsdk/node/12.9.1_64bit/bin:${PATH}"

FROM baseBuild AS qtbuilder
ARG targetBranch=5.13
RUN mkdir -p /development
WORKDIR /development

RUN git clone --branch=$targetBranch git://code.qt.io/qt/qt5.git

WORKDIR /development/qt5

RUN ./init-repository --module-subset=all,-qtwebengine,-qt3d,-qtquick3d

RUN mkdir -p /development/qt5_build
WORKDIR /development/qt5_build

RUN /development/qt5/configure -xplatform wasm-emscripten -nomake examples -nomake tests -opensource --confirm-license -prefix /usr/local/Qt
RUN make -j `grep -c '^processor' /proc/cpuinfo`
RUN make install

# Construct the build image from user perspective
FROM baseBuild AS userbuild

COPY --from=qtbuilder /usr/local/Qt /usr/local/Qt
ENV PATH="/usr/local/Qt/bin:${PATH}"

WORKDIR /project/build
CMD qmake /project/source && make -j `grep -c '^processor' /proc/cpuinfo`

