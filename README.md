<!--
SPDX-FileCopyrightText: Jonathon Anderson

SPDX-License-Identifier: CC-BY-4.0
-->

# Pixi as a Devcontainer feature

This is a small repository to repackage [Pixi](https://pixi.prefix.dev)'s standalone binaries as a reusable [Devcontainer](https://containers.dev/) feature.

## Why?

- **No dependencies**. At all. Compatible with every container image under the sun, including the weird ones.
- **No extras**. You get exactly what you asked for and nothing more.
- **No version skew**. The version is where the version should be, not an option added below.

## Usage

```jsonc
// .devcontainer.json
{
  // ...
  "features": {
    "ghcr.io/blue42u/devcontainer-features/pixi:latest": {}
  }
}
```

To select a specific version of Pixi to install instead of the latest:

```jsonc
// .devcontainer.json
{
  // ...
  "features": {
    "ghcr.io/blue42u/devcontainer-features/pixi:0.83.0": {}
  }
}
```

## Configuration

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| `overwrite` | Overwrite any existing `/usr/bin/pixi` | boolean | `false` |
| `updatePath` | Update shell init scripts (.bashrc, config.fish, etc.) to add `~/.pixi/bin/` to the default PATH | boolean | `true` |
