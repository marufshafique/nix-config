# nix-hm-flake-config

Declarative system + home configuration for **NixOS (x86_64-linux)** and **macOS (aarch64-darwin)**,
built on [Nix flakes](https://nixos.wiki/wiki/Flakes), [Home Manager](https://github.com/nix-community/home-manager)
and [nix-darwin](https://github.com/LnL7/nix-darwin).

One repo drives three targets (see `flake.nix` outputs):

| Target | Attr | What it manages |
|---|---|---|
| NixOS system | `.#nixos` | Whole OS (`configuration.nix`) + Home Manager as a NixOS module (`home.nix`) |
| macOS system | `.#macos` | macOS system defaults, Aerospace, Sketchybar + Home Manager as a darwin module (`marufs.nix`) |
| Home only (mac, no sudo) | `.#marufs` | Standalone Home Manager for user `marufs` (`marufs.nix`) |

## Layout

```
flake.nix            # inputs (nixpkgs, home-manager, nix-darwin, ...) + the three outputs above
configuration.nix    # NixOS system config (services, fonts, udev, nix-ld, ...)
home.nix             # home-manager config used on NixOS (imports ./modules)
marufs.nix           # home-manager config used on macOS (imports selected modules)
modules/
  default.nix        # module bundle imported by home.nix (Linux desktop set)
  neovim.nix + neovim/   # Neovim plugins, LSP, keymaps (keymaps.lua, plugin/*.lua)
  niri/ cosmic/ nixos/   # Linux desktop / OS modules
  aerospace.nix sketchybar.nix macos-defaults.nix  # macOS modules
  zsh.nix tmuxconf.nix helix.nix ghostty.nix alacritty.nix ...
```

Key detail: on NixOS, Home Manager runs **as a system module**, so user packages live in
`home.nix`; on macOS the standalone (`homeConfigurations`) and darwin-module configs both
use `marufs.nix`. The Neovim setup under `modules/neovim/` is shared by both.

## Rebuild

Run from the repo root. After switching, **restart your terminal/editor** — already-running
processes keep the old generation's files (e.g. Neovim keeps the old `init.lua` until reopened).

### NixOS

```sh
sudo nixos-rebuild switch --flake .#nixos
```

Why `sudo`: this manages the whole OS (system services, fonts, udev rules in
`configuration.nix`) plus the Home Manager user config. `--flake .#nixos` selects the
`nixosConfigurations.nixos` output from the flake in the current directory.

### macOS (nix-darwin, system scope)

```sh
sudo darwin-rebuild switch --flake .#macos
```

Why `sudo`: this applies system-wide macOS settings (`macos-defaults.nix`, Sketchybar,
Aerospace wiring) in addition to the user config. `--flake .#macos` selects
`darwinConfigurations.macos`.

### macOS (home only, no sudo)

```sh
home-manager switch --flake .#marufs
```

Why no `sudo`: standalone Home Manager only writes files under `$HOME` (dotfiles, user
packages, Neovim config). Use this when you only changed user-level things in `marufs.nix`
or `modules/neovim/` and don't want to touch system settings. `--flake .#marufs` selects
`homeConfigurations."marufs"`.

## New machine setup

1. **Install Nix** with flakes enabled. Easiest: the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer)
   (enables `nix-command` + `flakes` out of the box). Otherwise install Nix from
   [nixos.org](https://nixos.org/download) and add to `/etc/nix/nix.conf` (or `~/.config/nix/nix.conf`):
   `experimental-features = nix-command flakes`.
2. **Clone this repo** and `cd` into it.
3. **Adjust identity/paths**: `marufs.nix` hardcodes `home.username = "marufs"` and
   `/Users/marufs`; `home.nix` gets the user from the NixOS module instead. Update these
   (and the git identity in `home.nix` → `programs.git.settings`) for the new machine/user.
4. **First build**:
   - NixOS (fresh install): `configuration.nix` imports `/etc/nixos/hardware-configuration.nix`,
     which already exists on any NixOS install — nothing to copy. Then run
     `sudo nixos-rebuild switch --flake .#nixos`.
   - macOS: install `nix-darwin` once (`nix run nix-darwin -- switch --flake .#macos`),
     afterwards just `sudo darwin-rebuild switch --flake .#macos`.
     For home-only: [install Home Manager](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)
     once, then `home-manager switch --flake .#marufs`.
5. **Unfree packages** are already allowed (`nixpkgs.config.allowUnfree = true`); on a
   foreign distro/macOS you may also need `export NIXPKGS_ALLOW_UNFREE=1` for ad-hoc `nix` commands.

## Flake hygiene (gotchas)

- **New files must be `git add`-ed before rebuilding.** Flake evaluation only sees
  git-tracked files, so a new module (e.g. `modules/neovim/plugin/foo.lua`) is invisible
  — or fails evaluation — until staged. Rule of thumb: `git add -A` (or at least the new
  files), then rebuild. Modified tracked files are picked up with a harmless "Git tree
  is dirty" warning.
- **Update inputs**: `nix flake update` (all) or `nix flake lock --update-input nixpkgs`
  (one input). The `neovim` input is a **pinned nixpkgs revision** used only for Neovim
  packages — update it deliberately, since it changes plugin versions.
- **Conflicting dotfiles**: Home Manager renames pre-existing files it would overwrite
  using `backupFileExtension` (`"backup"` on NixOS, `".backup"` on macOS). If a managed
  file looks stale, check for `*.backup` siblings in `$HOME`.
- **Check before switching**: `nix flake check` (evaluate all outputs) and
  `nix-instantiate --parse <file>` for a quick syntax check of a single `.nix` file.

## Troubleshooting

- **Change not applied after rebuild** → you are likely looking at an old process:
  quit and reopen the terminal/editor. Verify with the live symlink, e.g.
  `readlink ~/.config/nvim/init.lua` should point into the newest `/nix/store/...` generation.
- **"Path ... is not tracked by Git"** → `git add` the new file and rebuild.
- **`switch` wants sudo / permission denied** → you picked a system-scope command
  (`nixos-rebuild`/`darwin-rebuild`); for user-only changes use the `home-manager` command instead.
- **Home Manager file collision** → back up or remove the unmanaged file (or rely on the
  automatic `*.backup`), then switch again.
