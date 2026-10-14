{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "dark_plus";
      editor = {
        true-color = true;
        line-number = "relative";
        mouse = true;
        lsp.display-messages = true;
        # tab-width = 2;
        # indent-unit = "  ";
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
    };
    languages = {
      language-server = {
        "typescript-language-server".config.plugins = [
          {
            name = "@vue/typescript-plugin";
            location = "/Users/marufs/.npm-global/lib/node_modules/@vue/language-server";
            languages = [ "vue" ];
          }
        ];
        volar = {
          command = "vue-language-server";
          args = [ "--stdio" ];
          config = {
            vue.hybridMode = false;
            typescript.tsdk = "/Users/marufs/.npm-global/lib/node_modules/typescript/lib";
          };
        };
      };
      language = [
        {
          name = "vue";
          scope = "source.vue";
          injection-regex = "vue";
          file-types = [ "vue" ];
          roots = [ "package.json" ".git" ];
          auto-format = true;
          language-servers = [ "volar" ];
          formatter = {
            command = "prettier";
            args = [ "--parser" "vue" ];
          };
        }

        {
          name = "go";
          auto-format = false;
        }
        {
          name = "rust";
          auto-format = false;
        }
        {
          name = "zig";
          auto-format = true;
        }
      ];
    };
  };
}
