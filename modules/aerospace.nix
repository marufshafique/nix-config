{ pkgs, ... }:
let
  reorganizeWindows = pkgs.writeShellScript "aerospace-reorganize" ''
    export PATH="${pkgs.aerospace}/bin:$PATH"

    # Give macOS a moment to finish restoring windows after login.
    sleep 5

    aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}|%{window-title}' \
      | while IFS='|' read -r id bundle title; do
        case "$bundle" in
          "app.zen-browser.zen")
            aerospace move-node-to-workspace --window-id "$id" 1 ;;
          "org.alacritty")
            aerospace move-node-to-workspace --window-id "$id" 2 ;;
          "com.brave.Browser")
            if [[ "$title" == *DevTools* ]]; then
              aerospace move-node-to-workspace --window-id "$id" 3
            else
              aerospace move-node-to-workspace --window-id "$id" 6
            fi ;;
          "com.docker.docker"|"com.sequel-ace.sequel-ace"|"com.tinyspeck.slackmacgap"|"com.spotify.client")
            aerospace move-node-to-workspace --window-id "$id" 5 ;;
          "com.1password.1password")
            aerospace move-node-to-workspace --window-id "$id" 7 ;;
        esac
      done
  '';
in
{
  services.aerospace = {
    enable = true;

    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      after-startup-command = [
        "exec-and-forget ${reorganizeWindows}"
      ];

      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      on-window-detected = [
        {
          "if" = {
            app-id = "app.zen-browser.zen";
          };
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if" = {
            app-id = "org.alacritty";
          };
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if" = {
            app-id = "com.brave.Browser";
            window-title-regex-substring = "DevTools";
          };
          run = [ "move-node-to-workspace 3" ];
        }
        {
          "if" = {
            app-id = "com.brave.Browser";
          };
          run = [ "move-node-to-workspace 6" ];
        }
        {
          "if" = {
            app-id = "com.docker.docker";
          };
          run = [
            "move-node-to-workspace 5"
            "layout accordion"
          ];
        }
        {
          "if" = {
            app-id = "com.sequel-ace.sequel-ace";
          };
          run = [
            "move-node-to-workspace 5"
            "layout accordion"
          ];
        }
        {
          "if" = {
            app-id = "com.tinyspeck.slackmacgap";
          };
          run = [
            "move-node-to-workspace 5"
            "layout accordion"
          ];
        }
        {
          "if" = {
            app-id = "com.spotify.client";
          };
          run = [
            "move-node-to-workspace 5"
            "layout accordion"
          ];
        }
        {
          "if" = {
            app-id = "com.1password.1password";
          };
          run = [
            "layout floating"
            "move-node-to-workspace 7"
          ];
        }
      ];

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
      };

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = [
          { monitor.secondary = 45; }
          8
        ];
        outer.right = 8;
      };

      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-left = "focus left";
        alt-down = "focus down";
        alt-up = "focus up";
        alt-right = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-left = "move left";
        alt-shift-down = "move down";
        alt-shift-up = "move up";
        alt-shift-right = "move right";

        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
      };
    };
  };
}
