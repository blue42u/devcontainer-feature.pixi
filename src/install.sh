#!/bin/sh -e

# SPDX-FileCopyrightText: Jonathon Anderson
#
# SPDX-License-Identifier: MIT

# Identify the current architecture
case "$(uname -m)" in
x86_64)
  archspec=x86_64-unknown-linux-musl
  ;;
aarch64)
  archspec=aarch64-unknown-linux-musl
  ;;
riscv64)
  archspec=riscv64gc-unknown-linux-gnu
  ;;
*)
  echo "Unsupported architecture: $(uname -m)"
  exit 1
  ;;
esac

# Confirm the binary is available
cd "$(dirname "$(realpath "$0")")"
if ! [ -e "dist/pixi-$archspec" ]; then
  echo "pixi-$archspec not found in dist/"
  exit 1
fi

# Install the binary a global location
if [ -e /usr/bin/pixi ] && [ "$OVERWRITE" != "true" ]; then
  echo "/usr/bin/pixi already present, not overwriting"
else
  cp dist/pixi-$archspec /usr/bin/pixi
  chmod +x /usr/bin/pixi
fi

# Update the shell init scripts to add $HOME/.pixi/bin/ to the PATH
if [ "$UPDATEPATH" = "true" ]; then
  update_shells() {
    echo "export PATH=$1/.pixi/bin:\"\$PATH\"" >> "$1"/.bashrc
    echo "export PATH=$1/.pixi/bin:\"\$PATH\"" >> "$1"/.zshrc
    # set -gx PATH is used here for compatibility with Fish < 3.2.0 (which lacks fish_add_path)
    mkdir -p "$1"/.config/fish
    echo "set -gx PATH $1/.pixi/bin \$PATH" >> "$1"/.config/fish/config.fish
    echo "set path = ( $1/.pixi/bin \$path )" >> "$1"/.tcshrc
  }
  update_shells "$_CONTAINER_USER_HOME"
  if [ "$_CONTAINER_USER_HOME" != "$_REMOTE_USER_HOME" ]; then
    update_shells "$_REMOTE_USER_HOME"
  fi
fi
