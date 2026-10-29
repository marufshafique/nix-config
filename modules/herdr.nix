{ ... }:
{
	programs.herdr = {
		enable = true;

		settings = {
			keys = {
				prefix = "ctrl+Space";
				focus_pane_left = "ctrl+h";
				focus_pane_right = "ctrl+l";
				command = [
					{
						key = "prefix+t";
						type = "popup";
						width = "60%";
						height = "40%";
						command = ''herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r '.result.tabs[] | "\(.number)  \(.label)  \(.tab_id)"' | fzf --with-nth=1,2 | awk '{print $NF}' | xargs -r herdr tab focus'';
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
