#!/usr/bin/zsh

#
# azsphere-docker-aliases-set
#
# Create aliases for the mcr.microsoft.com/azurespheresdk image executables
#

# alias azsphere-docker-default='docker run --rm -v $PWD:/build liydu/azsphere-docker-devcontainer'

CONTAINER_NAME="azsphere-sdk-docker"
CONTAINER_PROJECT_HOME="/home/azsphereuser"

azsphere-docker-build() {
    PROJECT_PATH=$1
    PROJECT=$2

    if [ $# -eq 1 ]
    then
        PROJECT=$PROJECT_PATH
    fi

    echo "Map project folder to Docker container: $CONTAINER_NAME..."
    docker run --name $CONTAINER_NAME -d -t -v $PWD/$PROJECT_PATH:$CONTAINER_PROJECT_HOME/$PROJECT_PATH liydu/azsphere-docker-devcontainer

    echo "\nGenerate Ninja project..."
    docker exec $CONTAINER_NAME cmake -G "Ninja" \
        -DCMAKE_TOOLCHAIN_FILE="/opt/azurespheresdk/CMakeFiles/AzureSphereToolchain.cmake" \
        -DAZURE_SPHERE_TARGET_API_SET="latest-lts" \
        -DCMAKE_BUILD_TYPE="Debug" \
        $CONTAINER_PROJECT_HOME/$PROJECT

    echo "\nBuild project..."
    docker exec $CONTAINER_NAME ninja

    echo "\nCopy built files to local folder: $PWD/$PROJECT/build..."
    docker cp $CONTAINER_NAME:/build $PWD/$PROJECT

    echo "\nCleanup container:"
    docker rm -f $CONTAINER_NAME
}

azsphere-docker-interactive() {
    docker run --rm -v $PWD/$1:$CONTAINER_PROJECT_HOME=/$1 -it liydu/azsphere-docker-devcontainer
}
