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

# Install the binary for the container user and the remote user
install() {
  mkdir -p "$2"/.pixi/bin || return $?
  cp "dist/pixi-$archspec" "$2"/.pixi/bin/pixi || return $?
  chmod +x "$2"/.pixi/bin/pixi || return $?
  chown "$1":"$1" "$2"/.pixi/bin/pixi || chown "$1" "$2"/.pixi/bin/pixi || return $?
}
install "$_CONTAINER_USER" "$_CONTAINER_USER_HOME"
if [ "$_CONTAINER_USER" != "$_REMOTE_USER" ]; then
  install "$_REMOTE_USER" "$_REMOTE_USER_HOME"
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
