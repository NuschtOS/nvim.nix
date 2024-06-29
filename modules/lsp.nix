{ pkgs, ... }:
let
  rust = pkgs.fenix.stable.completeToolchain or pkgs.rust-analyzer;
in
{
  plugins = {
    lint = {
      enable = true;
      lintersByFt = {
        css = [ "eslint_d" ];
        scss = [ "eslint_d" ];
        gitcommit = [ "commitlint" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        json = [ "jsonlint" ];
        markdownlint = [ "markdownlint" ];
        nix = [ "nix" ];
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
      };
      # Trigger linting more aggressively, not only after writing a buffer
      autoCmd.event = [ "BufWritePost" "BufEnter" "BufLeave" ];
    };

    lsp = {
      enable = true;
      servers = {
        angularls.enable = true;
        ansiblels.enable = true;
        bashls.enable = true;
        cssls.enable = true;
        docker-compose-language-service.enable = true;
        dockerls.enable = true;
        eslint.enable = true;
        html.enable = true;
        java-language-server = {
          enable = true;
          #rootDir.__raw = "nvim_lsp.util.root_pattern('.git');";
        };
        jsonls.enable = true;
        ltex.enable = true;
        marksman.enable = true;
        #nixd.enable = true;
        nil-ls.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          package = rust;
        };
        sqls.enable = true;
        taplo.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
        typos-lsp.enable = true;
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

  keymaps = [ {
    mode = "n";
    key = "<leader>tld";
    action = "<Plug>(toggle-lsp-diag)";
    options.desc = "Toggle LSP diagnostics";
  } ];
}
