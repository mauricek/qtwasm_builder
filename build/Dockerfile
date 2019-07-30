FROM maukalinow/emscripten_object_files AS qtbuilder
ARG targetBranch=5.13
RUN mkdir -p /development
WORKDIR /development

RUN git clone --branch=$targetBranch git://code.qt.io/qt/qt5.git

WORKDIR /development/qt5

RUN ./init-repository --module-subset=all,-qtwebengine,-qt3d

RUN sed -i '/BINARYEN_TRAP_MODE/d' qtbase/mkspecs/wasm-emscripten/qmake.conf
WORKDIR /development/qt5/qtbase
RUN git status
RUN git diff
WORKDIR /development/qt5

RUN mkdir -p /development/qt5_build
WORKDIR /development/qt5_build

RUN /development/qt5/configure -xplatform wasm-emscripten -nomake examples -nomake tests -opensource --confirm-license -no-warnings-are-errors -release -device-option WASM_OBJECT_FILES=1 -prefix /usr/local/Qt
RUN make -j `grep -c '^processor' /proc/cpuinfo`
RUN make install

# Fill up the cache for pre-deployment
# TODO: This does not work currently as the example directory for qtbase and qtdeclarative
# are not fully compiling for webassembly
#RUN mkdir -p /development/qt5_build/qtdeclarative/examples
#WORKDIR /development/qt5_build/qtdeclarative/examples
#RUN /usr/local/Qt/bin/qmake /development/qt5/qtdeclarative/examples && make

# Construct the build image from user perspective
FROM maukalinow/emscripten_object_files AS userbuild

COPY --from=qtbuilder /usr/local/Qt /usr/local/Qt
COPY --from=qtbuilder /root/.emscripten_cache /root/.emscripten_cache

ENV PATH="/usr/local/Qt/bin:${PATH}"

WORKDIR /project/build
# Using debug mode and no optimization speeds up most of the part
CMD qmake CONFIG+=debug /project/source && make -j `grep -c '^processor' /proc/cpuinfo`
