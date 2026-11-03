<!--
SPDX-FileCopyrightText: Jonathon Anderson

SPDX-License-Identifier: CC-BY-4.0
-->

# Pixi as a Devcontainer feature

This is a small repository to repackage [Pixi](https://pixi.prefix.dev) as a reusable [Devcontainer](https://containers.dev/) feature.

## Usage

```jsonc
// .devcontainer.json
{
  // ...
  "features": {
    "gchr.io/blue42u/devcontainer-feature.pixi:latest": {}
  }
}
```

To select a specific version of Pixi to install instead of the latest:

```jsonc
// .devcontainer.json
{
  // ...
  "features": {
    "gchr.io/blue42u/devcontainer-feature.pixi:0.83.0": {}
  }
}
```

## Configuration

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| `updatePath` | Update shell init scripts (.bashrc, config.fish, etc.) to add ~/.pixi/bin/ | boolean | `true` |
