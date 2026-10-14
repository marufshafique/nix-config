{ ... }:
{
  programs.ghostty = {
		enable = true;
    enableZshIntegration = true;
    settings = {
			font-family = "DroidSansM Nerd Font Mono";
      font-size = 16;
      shell-integration = "zsh";
			window-decoration = "none";
			window-theme = "dark";
    };
  };
}
