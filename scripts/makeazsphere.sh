#!/bin/bash
if [[ "$1" == "" ]]; then
    workdir="/src";
else
    workdir="/src/$1";
fi;

if [[ "$5" == "" ]]; then
    hwdir="/src";
else
    hwdir="/src/$5";
fi;

if [[ "$2" == "RTCore" ]]; then
    cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="/opt/azurespheresdk/CMakeFiles/AzureSphereRTCoreToolchain.cmake" \
    -DAZURE_SPHERE_TARGET_API_SET="$3" -DARM_GNU_PATH="$4" -DCMAKE_BUILD_TYPE="Release" "$workdir";
elif [[ "$2" == "HLCore" ]]; then
    if [[ "$6" == "" ]]; then
        cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="/opt/azurespheresdk/CMakeFiles/AzureSphereToolchain.cmake" \
        -DAZURE_SPHERE_TARGET_API_SET="$3" -DCMAKE_BUILD_TYPE="Release" "$workdir";
    else
        cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="/opt/azurespheresdk/CMakeFiles/AzureSphereToolchain.cmake" \
        -DAZURE_SPHERE_TARGET_API_SET="$3" -DAZURE_SPHERE_TARGET_HARDWARE_DEFINITION_DIRECTORY="$hwdir" \
        -DAZURE_SPHERE_TARGET_HARDWARE_DEFINITION="$6" -DCMAKE_BUILD_TYPE="Release" "$workdir";
    fi;
else
    echo "ERROR: Unknown core type: $2"; exit 1;
fi;
