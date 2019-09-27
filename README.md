This repo represents the scripts to generate docker images to build applications
against the current state of Qt for WebAssembly (using 5.13 branch).

Images can be found here https://hub.docker.com/r/maukalinow/qtwasm_builder

# Building:
Build locally:
```shell script
cd build
docker build . -t qtwasm
```
Or build and deploy to dockerhub:
```shell script
./build/generate_qtwasm_image.sh
```

