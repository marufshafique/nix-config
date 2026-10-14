{ pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   zsh-autosuggestions
  # ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "nrs" = "nixos-rebuild switch --flake . --impure";
      "vi" = "nvim";
      "ll" = "ls -l";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    initContent = ''
      eval "$(direnv hook zsh)"
    '';
  };
}
