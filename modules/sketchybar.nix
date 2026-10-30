{ pkgs, ... }:
let
  aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set "$NAME" background.drawing=on
    else
      sketchybar --set "$NAME" background.drawing=off
    fi
  '';

  frontAppPlugin = pkgs.writeShellScript "front_app.sh" ''
    if [ "$SENDER" = "front_app_switched" ]; then
      sketchybar --set "$NAME" label="$INFO"
    fi
  '';

  clockPlugin = pkgs.writeShellScript "clock.sh" ''
    sketchybar --set "$NAME" label="$(date '+%a %b %d %-I:%M %p')"
  '';
in
{
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.jq ];
    config = ''
      sketchybar --bar \
        position=top \
        height=37 \
        blur_radius=30 \
        color=0x40000000 \
        padding_left=10 \
        padding_right=10 \
        display=2 \
        topmost=window

      sketchybar --default \
        icon.font="SF Pro:Semibold:14.0" \
        label.font="SF Pro:Semibold:14.0" \
        icon.color=0xffffffff \
        label.color=0xffffffff \
        padding_left=4 \
        padding_right=4 \
        label.padding_left=4 \
        label.padding_right=4

      sketchybar --add event aerospace_workspace_change

      for sid in 1 2 3 4 5 6 7 8 9; do
        sketchybar --add item space.$sid left \
          --subscribe space.$sid aerospace_workspace_change \
          --set space.$sid \
            background.color=0x44ffffff \
            background.corner_radius=5 \
            background.height=22 \
            background.drawing=off \
            label="$sid" \
            click_script="${pkgs.aerospace}/bin/aerospace workspace $sid" \
            script="${aerospacePlugin} $sid"
      done

      sketchybar --add item space_separator left \
        --set space_separator icon="|" background.padding_left=8 background.padding_right=8 label.drawing=off

      sketchybar --add item front_app left \
        --set front_app script="${frontAppPlugin}" \
        --subscribe front_app front_app_switched

      sketchybar --add item clock right \
        --set clock update_freq=10 script="${clockPlugin}"

      sketchybar --update
    '';
  };
}
