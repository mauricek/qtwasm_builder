#!/bin/bash
#set -ex
targetBranch=${1:-5.13.1}
username=$(docker info | sed '/Username:/!d;s/.* //');
dockerRepo=${username}/qtwasm
qtHead=$(git ls-remote https://github.com/qt/qt5.git refs/heads/$targetBranch | cut -f 1)

# get and set the name of the latest version of emscripten from trzeci
echo "*** Checking Qt HEAD: $qtHead in branch $targetBranch"

if docker pull $dockerRepo:${targetBranch}_$qtHead
then
    echo "*** Image for qt5.git branch $targetBranch $qtHead already generated. Nothing to do..."
    exit 0
fi


if ! docker build -t qtwasm_builder_$targetBranch --build-arg targetBranch=$targetBranch .
then
   echo "*** Could not build image! Check output"
   exit 1
fi

docker tag qtwasm_builder_$targetBranch $dockerRepo:${targetBranch}_$qtHead
docker tag qtwasm_builder_$targetBranch $dockerRepo:${targetBranch}
docker tag qtwasm_builder_$targetBranch $dockerRepo:latest

echo "*** Image generated and locally tagged, now push"
echo "    docker push $dockerRepo:${targetBranch}_$qtHead"
echo "    docker push $dockerRepo:${targetBranch}"
echo "    docker push $dockerRepo:latest"

exit 0
