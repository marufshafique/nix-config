# Niri compositor config, managed declaratively (vendored from ~/.config/niri/config.kdl).
# DMS owns bar/OSD/lock/notifications via `dms run` (see spawn-at-startup in
# config.kdl). Runtime-generated files in ~/.config/niri/dms/ (outputs, layout,
# colors, cursor, input, windowrules, ...) are included at the END of config.kdl
# and therefore take precedence over the values above. Edit DMS behavior in the
# DMS Settings app, not here.
# System-level niri settings live in ./system.nix (imported by modules/nixos).
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # App launcher used by the Mod+D binding in config.kdl.
    wlr-which-key
    wlr-randr
    # X11 app support under niri.
    xwayland
    xwayland-satellite
    # Bound in config.kdl (lock, brightness keys, wlr-which-key power menu).
    swaylock
    swayidle
    brightnessctl
    # Wayland clipboard utilities (DMS has a built-in manager; these cover
    # scripts and non-DMS flows).
    wl-clipboard
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  # wlr-which-key menu (Mod+D). Managed here so fresh installs don't depend on
  # an imperative ~/.config file. Laptop-screen entries target eDP-1; on the
  # DP-2-only desktop they are harmless no-ops.
  xdg.configFile."wlr-which-key/config.yaml".text = ''
    font: DroidSansM Nerd Font Mono 12
    background: "#282828d0"
    color: "#fbf1c7"
    border: "#8ec07c"
    separator: " ➜ "
    border_width: 2
    corner_r: 10
    padding: 15
    rows_per_column: 5
    column_padding: 25
    anchor: center
    margin_right: 0
    margin_bottom: 0
    margin_left: 0
    margin_top: 0
    inhibit_compositor_keyboard_shortcuts: true
    auto_kbd_layout: true
    menu:
      - key: "p"
        desc: Power
        submenu:
          - key: "s"
            desc: Sleep
            cmd: systemctl suspend
          - key: "r"
            desc: Reboot
            cmd: reboot
          - key: "o"
            desc: Off
            cmd: poweroff
      - key: "l"
        desc: Laptop Screen
        submenu:
          - key: "t"
            desc: Toggle On/Off
            cmd: niri msg output eDP-1 off || niri msg output eDP-1 on
          - key: "s"
            desc: Scale
            submenu:
              - key: "1"
                desc: Set Scale to 1.0
                cmd: niri msg output eDP-1 scale 1.0
              - key: "2"
                desc: Set Scale to 1.1
                cmd: niri msg output eDP-1 scale 1.1
              - key: "3"
                desc: Set Scale to 1.2
                cmd: niri msg output eDP-1 scale 1.2
  '';
}
