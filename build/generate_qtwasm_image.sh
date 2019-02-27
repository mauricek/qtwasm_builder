#!/bin/bash
#set -ex

dockerRepo=maukalinow/qtwasm_builder
qtHead=$(git ls-remote git://code.qt.io/qt/qt5.git refs/heads/5.13 | cut -f 1)

echo "*** Checking Qt HEAD: $qtHead"

if docker pull $dockerRepo:$qtHead
then
    echo "*** Image for qt5.git branch 5.13 $qtHead already generated. Nothing to do..."
    exit 0
fi

if ! docker build --no-cache -t qtwasm_builder .
then
   echo "*** Could not build image! Check output"
   exit 1
fi

docker tag qtwasm_builder $dockerRepo:$qtHead
docker tag qtwasm_builder $dockerRepo:latest

echo "*** Image generated and locally tagged, now push"
echo "    docker push $dockerRepo:$qtHead"
echo "    docker push $dockerRepo:latest"

exit 0
