FROM rust:slim-bookworm
WORKDIR /vtube-project

# Setup Rust
RUN rustup default nightly && rustup update nightly

# Setup dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates gpg wget git && \
    wget --retry-on-host-error -t 50 -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
            gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install -y \
        kitware-archive-keyring cmake ninja-build clang python3 python3-venv libvulkan-dev file \
        build-essential \
        scons \
        pkg-config \
        libx11-dev \
        libxcursor-dev \
        libxinerama-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libasound2-dev \
        libpulse-dev \
        libudev-dev \
        libxi-dev \
        libxrandr-dev \
        python-is-python3 \
        libopencv-core-dev \
        libopencv-highgui-dev \
        libopencv-calib3d-dev \
        libopencv-features2d-dev \
        libopencv-imgproc-dev \
        libopencv-video-dev


# Setup AppImage
RUN cd /usr/bin && \
    wget https://github.com/linuxdeploy/linuxdeploy/releases/download/1-alpha-20240109-1/linuxdeploy-x86_64.AppImage && \
    mv linuxdeploy-x86_64.AppImage linuxdeploy && \
    chmod u+x linuxdeploy && \
    wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage && \
    mv appimagetool-x86_64.AppImage appimagetool && \
    chmod u+x appimagetool


VOLUME /vtube-project
CMD [ "./generate_appimage.sh" ]

