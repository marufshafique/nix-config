{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "Space";
    escapeTime = 0;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-left-icon session
          set -g @dracula-plugins "weather, ram-usage"
          set -g @dracula-show-fahrenheit false
          set -g @dracula-fixed-location "Dhaka"
          set -g @dracula-refresh-rate 10
        '';
      }
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g extended-keys-format csi-u
      set -g status-position top
      set -g extended-keys on
			set -g default-command "${pkgs.zsh}/bin/zsh"

      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
