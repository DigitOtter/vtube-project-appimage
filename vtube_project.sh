#!/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PATH="$SCRIPT_DIR/usr/bin"${PATH:+:${PATH}}
LD_LIBRARY_PATH="$SCRIPT_DIR/usr/lib"${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
VTUBE_PROJECT_DIR="$SCRIPT_DIR/usr/share/vtube_project"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$VTUBE_PROJECT_DIR"
exec "$SCRIPT_DIR/usr/bin/godot.linuxbsd.template_release.x86_64" --main-pack "$VTUBE_PROJECT_DIR/vtube_project.pck" "$@"
