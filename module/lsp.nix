{ pkgs, ... }:
let
  rust = pkgs.fenix.stable.completeToolchain;
in
{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          angularls.enable = true;
          #ansiblels.enable = true;
          bashls.enable = true;
          cssls.enable = true;
          #docker-compose-language-service.enable = true;
          #dockerls.enable = true;
          eslint.enable = true;
          html.enable = true;
          java-language-server = {
            enable = true;
            #rootDir.__raw = "nvim_lsp.util.root_pattern('.git');";
          };
          jsonls.enable = true;
          ltex.enable = true;
          #marksman.enable = true;
          #nixd.enable = true;
          nil-ls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            package = rust;
          };
          #sqls.enable = true;
          taplo.enable = true;
          texlab.enable = true;
          tsserver.enable = true;
          #typos-lsp.enable = true;
          yamlls.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "[d" = {
              action = "goto_prev";
              desc = "Go to prev diagnostic";
            };
            "]d" = {
              action = "goto_next";
              desc = "Go to next diagnostic";
            };
            "<leader>e" = {
              action = "open_float";
              desc = "Show Line Diagnostics";
            };
          };

          lspBuf = {
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Actions";
            };
            "<leader>rn" = {
              action = "rename";
              desc = "Rename Symbol";
            };
            "<leader>cf" = {
              action = "format";
              desc = "Format";
            };
            "gd" = {
              action = "definition";
              desc = "Goto definition (assignment)";
            };
            "gD" = {
              action = "declaration";
              desc = "Goto declaration (first occurrence)";
            };
            "gr" = {
              action = "references";
              desc = "Goto references";
            };
            "gy" = {
              action = "type_definition";
              desc = "Goto Type Defition";
            };

            "gi" = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            "<leader>k" = {

              action = "hover";
              desc = "Hover";
            };
            "<leader>ls" = {
              action = "signature_help";
              desc = "Signature Help";
            };
          };
        };
      };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "toggle-lsp-diagnostics";
        src = pkgs.fetchFromGitHub {
          owner = "WhoIsSethDaniel";
          repo = "toggle-lsp-diagnostics.nvim";
          rev = "afcacba44d86df4c3c9752b869e78eb838f55765";
          hash = "sha256-7yWZjlfO3OclvS4VAd5J7MaOkRPDvBP1xQyGizRzJgk=";
        };
      })
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>tld";
        action = "<Plug>(toggle-lsp-diag)";
        options = {
          desc = "Toggle LSP diagnostics";
        };
      }
    ];
  };
}
