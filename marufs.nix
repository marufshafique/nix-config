{ pkgs, ... }:

{
  imports = [
    ./modules/tmuxconf.nix
    ./modules/helix.nix
    ./modules/neovim.nix
  ];

  # nix.package = pkgs.nix;
  home.username = "marufs";
  home.homeDirectory = "/Users/marufs";

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    go
    gopls
    tinygo

    postgresql
    cocoapods

    nil
    nixd
    nixfmt

    stylua
    lua
    lua-language-server
    vue-language-server

    ffmpeg

    typescript
    typescript-language-server
    tailwindcss-language-server
    nodejs_22

    yarn
    eslint
    eslint_d
    prettier
    emmet-ls
    emmet-language-server

    tree

    file
    fd
    ripgrep
    deno

    lazygit

    poppler

    devenv
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      			export NVM_DIR="$HOME/.nvm"
      				[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
      				[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

      			export EDITOR="hx"
      			export VISUAL="hx"
      			export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
      			export PATH=$PATH:$(npm bin -g)
      			export DPRINT_INSTALL="/Users/marufs/.dprint"
      			export PATH="$DPRINT_INSTALL/bin:$PATH"
      			export PATH="$HOME/.npm-global/bin:$PATH"

      			# pnpm
      			export PNPM_HOME="/Users/marufs/Library/pnpm"
      			case ":$PATH:" in
      				*":$PNPM_HOME:"*) ;;
      				*) export PATH="$PNPM_HOME:$PATH" ;;
      			esac
      			# pnpm end

      			[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env" 

      			# add to ~/.zshrc
      			export BUN_INSTALL="$HOME/.bun"
      			export PATH="$BUN_INSTALL/bin:$PATH"
      			export PATH=$HOME/go/bin:$PATH
            export PATH="$HOME/development/flutter/bin:$PATH"

            # Add nixpkgs-allow-unfree to allow unfree packages
            export NIXPKGS_ALLOW_UNFREE=1
      		'';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  # programs.git = {
  #   enable = true;
  #   userName = "shm-wtag";
  #   userEmail = "maruf.shafique@welldev.io";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
