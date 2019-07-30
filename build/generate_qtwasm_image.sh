#!/bin/bash
#set -ex
targetBranch=${1:-dev}
dockerRepo=maukalinow/qtwasm_object_files_builder
qtHead=$(git ls-remote git://code.qt.io/qt/qt5.git refs/heads/$targetBranch | cut -f 1)

echo "*** Checking Qt HEAD: $qtHead in branch $targetBranch"

if docker pull $dockerRepo:${targetBranch}_$qtHead
then
    echo "*** Image for qt5.git branch $targetBranch $qtHead already generated. Nothing to do..."
    exit 0
fi

if ! docker build --no-cache -t qtwasm_object_files_builder_$targetBranch --build-arg targetBranch=$targetBranch .
then
   echo "*** Could not build image! Check output"
   exit 1
fi

docker tag qtwasm_object_files_builder_$targetBranch $dockerRepo:${targetBranch}_$qtHead
docker tag qtwasm_object_files_builder_$targetBranch $dockerRepo:${targetBranch}_latest

echo "*** Image generated and locally tagged, now push"
echo "    docker push $dockerRepo:${targetBranch}_$qtHead"
echo "    docker push $dockerRepo:${targetBranch}_latest"

exit 0
