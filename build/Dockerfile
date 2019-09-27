FROM trzeci/emscripten-ubuntu:latest AS qtbuilder
ARG targetBranch=5.13.1
RUN mkdir -p /development
WORKDIR /development

RUN git clone --branch=$targetBranch https://github.com/qt/qt5.git

WORKDIR /development/qt5

RUN ./init-repository --module-subset=all,-qtwebengine,-qt3d,-qtquick3d

RUN mkdir -p /development/qt5_build
WORKDIR /development/qt5_build

RUN /emsdk_portable/emsdk_env.sh ; /development/qt5/configure -xplatform wasm-emscripten -nomake examples -nomake tests -opensource --confirm-license -prefix /usr/local/Qt
RUN make -j `grep -c '^processor' /proc/cpuinfo`
RUN make install

# Construct the build image from user perspective
FROM trzeci/emscripten-ubuntu:latest AS userbuild

COPY --from=qtbuilder /usr/local/Qt /usr/local/Qt
ENV PATH="/usr/local/Qt/bin:${PATH}"

WORKDIR /
RUN git clone https://github.com/cpp-pm/polly.git

WORKDIR /project/build

COPY entrypoint.sh /
CMD /entrypoint.sh