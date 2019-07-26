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

# Construct the build image from user perspective
FROM maukalinow/emscripten_object_files AS userbuild

COPY --from=qtbuilder /usr/local/Qt /usr/local/Qt
ENV PATH="/usr/local/Qt/bin:${PATH}"

WORKDIR /project/build
CMD qmake /project/source && make -j `grep -c '^processor' /proc/cpuinfo`
