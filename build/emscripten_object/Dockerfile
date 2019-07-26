FROM ubuntu:latest AS baseBuild

ARG packages="build-essential git cmake \
python \
ninja-build \
icecc \
"
# Required for non-interactive timezone installation
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN apt-get update && apt-get install -q -yy $packages

COPY icecc.conf /etc/icecc/icecc.conf

RUN service iceccd restart

ENV PATH="/usr/lib/icecc/bin:${PATH}"

# llvm
RUN mkdir -p /build/
WORKDIR /build
RUN git clone https://github.com/llvm/llvm-project.git
RUN mkdir -p /build/llvm-project/build
WORKDIR /build/llvm-project/build
RUN cmake -GNinja ../llvm -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi;lld" -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=WebAssembly -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DCMAKE_INSTALL_PREFIX=/opt/llvm
RUN service iceccd restart && ninja -j 30
RUN ninja install

# emscripten
WORKDIR /opt
RUN git clone https://github.com/kripken/emscripten.git
WORKDIR /opt/emscripten
RUN git checkout -b 1.38.40 1.38.40

# binaryen
WORKDIR /build
RUN git clone https://github.com/WebAssembly/binaryen.git
WORKDIR /build/binaryen
RUN cmake -GNinja -DCMAKE_INSTALL_PREFIX=/opt/binaryen
RUN service iceccd restart && ninja -j 30
RUN ninja install


# Construct the tooling image
FROM ubuntu:latest AS toolingBuild

ARG packages="build-essential git cmake \
python \
ninja-build \
nodejs \
openjdk-11-jre \
"

# Required for non-interactive timezone installation
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN apt-get update && apt-get install -q -yy $packages

# Copy content
COPY --from=baseBuild /opt /opt

# initialize environment variables
ENV EMSDK="/opt/emscripten"
ENV PATH="$EMSDK:$PATH"
ENV LLVM="/opt/llvm/bin"
ENV BINARYEN="/opt/binaryen"

# run em++ to initialize properly
RUN em++

