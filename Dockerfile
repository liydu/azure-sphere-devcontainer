# Use Docker for Azure Sphere SDK
# https://docs.microsoft.com/en-us/azure-sphere/app-development/container-build

FROM mcr.microsoft.com/azurespheresdk AS azsphere-docker-devcontainer

# [Option] Install zsh
ARG  INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG  UPGRADE_PACKAGES="true"
# Don't install the default packages
ARG  PACKAGES_ALREADY_INSTALLED="true"

# The USER_ID argument will allow to the Docker Image user 
#  to inherit the same UID and GID from the user creating the Docker image
ARG  USERNAME=azsphereuser
ARG  USER_UID=2000
ARG  USER_GID=$USER_UID

# ARM GCC package
ARG  ARM_GCC_VERSION="9-2020q2"
ARG  ARM_GCC_PACK_NAME="gcc-arm-none-eabi-9-2020-q2-update"

# These environment variables will also become available
#  when running a container. The IAR build tools 
#  are going to be on the search path
ENV  AZSPHERE_SDK_PATH="/opt/azurespheresdk"
ENV  AZSPHERE_SRC_PATH="/src"
ENV  AZSPHERE_BUILD_PATH="/build"

# Updates the Ubuntu packages, install sudo and cleanup
RUN  apt-get update && \
     apt-get install -y --no-install-recommends \
          apt-utils \
          sudo \
          curl \
          ca-certificates \
          git \
          locales \
          wget \
          bzip2 \
          apt-transport-https \
          gnupg2 \
          software-properties-common \
          libsqlite3-0 && \
     apt-get clean autoclean && \
     apt-get autoremove -y && \
     rm -rf /var/lib/apt/lists/*

COPY scripts/common-debian.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "${PACKAGES_ALREADY_INSTALLED}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Update CMake
RUN  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
     apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
     apt-get update && \
     apt-get install -y --no-install-recommends cmake

# Get ARM GCC
RUN  wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/${ARM_GCC_VERSION}/${ARM_GCC_PACK_NAME}-x86_64-linux.tar.bz2 | tar -xj -C /opt

# Creates and sets the src and build directory
RUN  mkdir ${AZSPHERE_SRC_PATH} ${AZSPHERE_BUILD_PATH} && \
     chmod u+rwx -R ${AZSPHERE_SRC_PATH} && \
     chmod g+rwx -R ${AZSPHERE_SRC_PATH} && \
     chown ${USERNAME}:${USERNAME} ${AZSPHERE_SRC_PATH} && \
     chmod u+rwx -R ${AZSPHERE_BUILD_PATH} && \
     chmod g+rwx -R ${AZSPHERE_BUILD_PATH} && \
     chown ${USERNAME}:${USERNAME} ${AZSPHERE_BUILD_PATH}

ENV  PATH="${AZSPHERE_SDK_PATH}:/opt/${ARM_GCC_PACK_NAME}/bin:$PATH"

# When the container is started, it will start from the ${AZSPHERE_BUILD_PATH} directory
USER ${USERNAME} 
WORKDIR ${AZSPHERE_BUILD_PATH}