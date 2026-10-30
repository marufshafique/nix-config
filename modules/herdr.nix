{ pkgs, ... }:
{
	home.packages = with pkgs; [
		jq
		fzf
		gawk
		python3
	];

	programs.herdr = {
		enable = true;

		settings = {
			onboarding = false;
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
						command = ''ws="''${HERDR_ACTIVE_WORKSPACE_ID:-$HERDR_WORKSPACE_ID}"; tabs="$("$HERDR_BIN_PATH" tab list --workspace "$ws")"; panes="$("$HERDR_BIN_PATH" pane list --workspace "$ws")"; pos="$(echo "$panes" | ${pkgs.jq}/bin/jq -r '(.result.panes | map(.focused // false) | index(true) // 0) + 1')"; sel="$(echo "$panes" | ${pkgs.jq}/bin/jq -r --argjson tabs "$tabs" '($tabs.result.tabs | map({(.tab_id): {number: .number, label: .label}}) | add) as $tabmap | .result.panes[]? | "\(.tab_id),\(.pane_id)\t\($tabmap[.tab_id].number // "?")  \($tabmap[.tab_id].label // .tab_id)  \(.pane_id)  \(.terminal_title_stripped // .terminal_title // "")"' | ${pkgs.fzf}/bin/fzf --delimiter='\t' --with-nth=2 --no-input --disabled --info=hidden --layout=reverse --height=100% --no-sort --bind "j:down,k:up,enter:accept,load:pos($pos)" --accept-nth=1)"; [ -n "$sel" ] || exit 0; tab_id="''${sel%%,*}"; pane_id="''${sel##*,}"; "$HERDR_BIN_PATH" tab focus "$tab_id" >/dev/null 2>&1; if [ -n "$HERDR_SOCKET_PATH" ]; then ${pkgs.python3}/bin/python3 -c 'import socket,json,os,sys; s=socket.socket(socket.AF_UNIX,socket.SOCK_STREAM); s.connect(os.environ["HERDR_SOCKET_PATH"]); s.sendall((json.dumps({"id":"popup","method":"pane.focus","params":{"pane_id":sys.argv[1]}})+"\n").encode()); s.shutdown(socket.SHUT_WR);
while s.recv(65536): pass' "$pane_id"; fi'';
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
