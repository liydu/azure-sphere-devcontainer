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
    echo "Map project folder to Docker container...\n"
    docker run --name $CONTAINER_NAME -d -t -v $PWD/$1:$CONTAINER_PROJECT_HOME/$1 liydu/azsphere-docker-devcontainer

    echo "Generate Ninja project...\n"
    docker exec $CONTAINER_NAME cmake -G "Ninja" \
        -DCMAKE_TOOLCHAIN_FILE="/opt/azurespheresdk/CMakeFiles/AzureSphereToolchain.cmake" \
        -DAZURE_SPHERE_TARGET_API_SET="latest-lts" \
        -DCMAKE_BUILD_TYPE="Debug" \
        $CONTAINER_PROJECT_HOME/$2

    echo "Build project...\n"
    docker exec $CONTAINER_NAME ninja

    echo "Copy built files to local...\n"
    docker cp $CONTAINER_NAME:/build $PWD/$2

    echo "Cleanup...\n"
    docker rm -f $CONTAINER_NAME
}

azsphere-docker-interactive() {
    docker run --rm -v $PWD/$1:$CONTAINER_PROJECT_HOME=/$1 -it liydu/azsphere-docker-devcontainer
}