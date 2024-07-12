#!/usr/bin/bash

pushd deps/vtube-project
./CI/build_dependencies.sh -DTSV_ABSOLUTE_PATH=OFF -DCMAKE_CXX_STANDARD=20

# We can't build the actual executable as that requires a display server

# Copy all libs to bin
mkdir -p bin
find -L addons/ -iname "*.so" -exec cp {} ./bin/ \;
cp third_party/install/texture_share_vk/lib/*.so ./bin/
popd


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$PWD/deps/vtube-project/third_party/install/texture_share_vk/lib"

# Install vtube_project.pck
mkdir -p AppDir/usr/share/vtube_project
cp vtube_project.pck AppDir/usr/share/vtube_project/

# Install texture-share-vk and godot base
linuxdeploy --appimage-extract-and-run --appdir AppDir \
    -e deps/vtube-project/third_party/install/texture_share_vk/bin/texture-share-vk-server \
    -e deps/vtube-project/third_party/godot/bin/godot.linuxbsd.template_release.x86_64

# Install vtube_project libraries
ls deps/vtube-project/bin/*.so | xargs -I {} linuxdeploy --appimage-extract-and-run --appdir AppDir -l "{}"

# Install start script, .desktop and icon
cp vtube_project.sh AppDir/usr/bin/
linuxdeploy --appimage-extract-and-run --appdir AppDir -e /usr/bin/bash -d vtube_project.desktop -i vtube_project.png

# Copy godot base as linuxdeploy uses patchelf to change rpath, which breaks the executable
# ( might be related to https://github.com/NixOS/patchelf/issues/528 )
cp deps/vtube-project/third_party/godot/bin/godot.linuxbsd.template_release.x86_64 AppDir/usr/bin/

# Use appimage instead of linuxdeploy as it won't break the executable
appimagetool --appimage-extract-and-run AppDir

