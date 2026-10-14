# In case you want to pin a specific version of
# pacakge, you can override the package like this:
#
# (pkgs.vimPlugins.codecompanion-nvim.overrideAttrs (old: {
#   version = "19.14.0";
#
#   src = pkgs.fetchFromGitHub {
#     owner = "olimorris";
#     repo = "codecompanion.nvim";
#     tag = "v19.14.0";
#     hash = "sha256-/cx7LV866OPfTaK781dPbouPRjb2HXJZ3SwGVU/rnsA=";
#   };
# }))

{ pkgs, ... }:
let
  toLua = str: "\n${str}\n\n";
  toLuaFile = file: "\n${builtins.readFile file}\n\n";
  vueLanguageServerPath = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter

      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.css
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.vue
      nvim-treesitter-parsers.tsx
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.scss
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.cpp
      nvim-treesitter-parsers.dart

      copilot-vim
      comment-nvim
      nvim-ts-context-commentstring
      neo-tree-nvim
      blink-cmp

      telescope-fzf-native-nvim
      toggleterm-nvim
      snipe-nvim

      telescope-nvim

      dressing-nvim

      lualine-nvim
      nvim-web-devicons
      plenary-nvim

      {
        plugin = render-markdown-nvim;
        config = toLuaFile ./neovim/plugin/rendermarkdown.lua;
      }

      mini-pick

      {
        plugin = mini-clue;
        config = toLuaFile ./neovim/plugin/mini-clue.lua;
      }

      {
        plugin = gruvbox-nvim;
        type = "viml";
        config = "colorscheme gruvbox";
      }

      {
        plugin = nvim-autopairs;
        type = "lua";
        config = toLua "require(\"nvim-autopairs\").setup()";
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = toLuaFile ./neovim/plugin/gitsigns.lua;
      }

      {
        plugin = conform-nvim;
        type = "lua";
        config = toLuaFile ./neovim/plugin/conform.lua;
      }
    ];

    initLua = ''
          vim.g.vue_language_server_path = "${vueLanguageServerPath}"
          ${builtins.readFile ./neovim/init.lua}
      		${builtins.readFile ./neovim/keymaps.lua}
          ${builtins.readFile ./neovim/plugin/lsp.lua}
          ${builtins.readFile ./neovim/plugin/comment.lua}
          ${builtins.readFile ./neovim/plugin/toggleterm.lua}
          ${builtins.readFile ./neovim/plugin/snipe.lua}
          ${builtins.readFile ./neovim/plugin/platformio.lua}
    '';
  };
}
