{ pkgs, ... }:
{
	home.packages = with pkgs; [
		jq
		fzf
		gawk
	];

	programs.herdr = {
		enable = true;

		settings = {
			keys = {
				prefix = "ctrl+Space";
				focus_pane_left = [ "prefix+h" "ctrl+alt+h" ];
				focus_pane_down = [ "prefix+j" "ctrl+alt+j" ];
				focus_pane_up = [ "prefix+k" "ctrl+alt+k" ];
				focus_pane_right = [ "prefix+l" "ctrl+alt+l" ];
				command = [
					{
						key = "ctrl+h";
						type = "plugin_action";
						command = "vim-herdr-navigation.left";
						description = "navigate left (vim/herdr)";
					}
					{
						key = "ctrl+j";
						type = "plugin_action";
						command = "vim-herdr-navigation.down";
						description = "navigate down (vim/herdr)";
					}
					{
						key = "ctrl+k";
						type = "plugin_action";
						command = "vim-herdr-navigation.up";
						description = "navigate up (vim/herdr)";
					}
					{
						key = "ctrl+l";
						type = "plugin_action";
						command = "vim-herdr-navigation.right";
						description = "navigate right (vim/herdr)";
					}
					{
						key = "prefix+t";
						type = "popup";
						width = "60%";
						height = "40%";
						command = ''"$HERDR_BIN_PATH" tab list --workspace "''${HERDR_ACTIVE_WORKSPACE_ID:-$HERDR_WORKSPACE_ID}" | ${pkgs.jq}/bin/jq -r '.result.tabs[]? | "\(.number)  \(.label)  \(.tab_id)"' | ${pkgs.fzf}/bin/fzf --with-nth=1,2 --no-input --disabled --info=hidden --layout=reverse --height=100% --no-sort --bind 'j:down,k:up,enter:accept' | ${pkgs.gawk}/bin/awk '{print $NF}' | { read -r id; [ -n "$id" ] && "$HERDR_BIN_PATH" tab focus "$id"; }'';
					}
				];
			};
			theme = {
				name = "one-dark";
				custom = {
					panel_bg = "reset";
				};
			};
		};
	};
}
