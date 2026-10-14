{ ... }:
{
  programs.alacritty = {
		enable = true;
    settings = {
			env = {
				TERM = "xterm-256color";
				COLORTERM = "truecolor";
			};
			font = {
				normal.family = "DroidSansM Nerd Font Mono";
				size = 16;
		  };
    };
  };
}
