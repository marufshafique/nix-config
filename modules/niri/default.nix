# Niri compositor config, managed declaratively (vendored from ~/.config/niri/config.kdl).
# The `include "dms/..."` lines at the end resolve to dms-generated files at
# runtime (~/.config/niri/dms/) and are intentionally left untouched.
# System-level niri settings live in ./system.nix (imported by modules/nixos).
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # App launcher used by the Mod+D binding in config.kdl.
    wlr-which-key
    # X11 app support under niri.
    xwayland
    xwayland-satellite
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
