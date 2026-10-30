{ pkgs, ... }:

{
  imports = [
    ./modules
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "marufs";
  # home.homeDirectory = "/home/marufs";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.sessionPath = [
    "$HOME/.npm-globall/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dig
    lazygit
    fastfetch
    tmux
    vim
    helix
    vscode
    arduino-ide
    arduino-cli
    avrdude

    platformio

    # clangd - C/C++ language server used for PlatformIO / Arduino intellisense
    clang-tools

    python3

    ddcutil

    postman

    yazi
    fzf
    tree

    gcc
    rust-analyzer
    nodejs_latest
    yarn
    bun
    go
    goose
    gopls
    cobra-cli
    golangci-lint

    flutter

    nil
    nixd
    nixfmt
    stylua
    lua-language-server

    prettier
    vue-language-server
    svelte-language-server
    typescript
    typescript-language-server
    tailwindcss-language-server
    emmet-ls
    sqlite
    go-migrate
    gofumpt

    tailscale

    vlc
    mpv

    file

    gnumake

    (kicad.override {
      with3d = true;
    })

    evince
    nautilus

    postgresql

    fd
    ripgrep
    firefox

    bibata-cursors
    adwaita-icon-theme
    adw-gtk3 # Adwaita GTK3 theme (dms system check)

    dux-calendar # Dux Labs calendar backend (dms system check)

    chromium
    google-chrome

    golangci-lint-langserver

    cloudflared

    ollama-vulkan

    vscode-langservers-extracted
    eslint
    eslint_d

    discord
    devenv

    tree-sitter
    pi-coding-agent
    opencode

    pavucontrol
    audacity
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "shm-wtag";
        email = "maruf.shafique@welldev.io";
      };
    };
  };

  programs.zen-browser = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # User-wide clangd config: strips GCC-xtensa-only flags that PlatformIO's
  # ESP32/Arduino toolchain adds (clang doesn't know them -> noisy diagnostics).
  # See modules/neovim/plugin/lsp.lua for the clangd LSP setup.
  xdg.configFile."clangd/config.yaml".text = ''
    CompileFlags:
      Remove:
        - "-mlongcalls"
        - "-fstrict-volatile-bitfields"
        - "-fno-tree-switch-conversion"
  '';
}
