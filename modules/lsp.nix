{ config, lib, pkgs, ... }:
let
  rust = pkgs.fenix.stable.completeToolchain or pkgs.rust-analyzer;
in
{
  extraPackages = map (pkg: pkgs.${pkg} or (with pkgs; {
    golangcilint = golangci-lint;
    jsonlint = nodePackages.jsonlint;
  }).${pkg}) (lib.flatten (lib.attrValues config.plugins.lint.lintersByFt));

  plugins = {
    lint = {
      enable = true;
      linters.yamllint.args = [
        "--config-file ${pkgs.writeText "yamllint-config.yaml" /* yaml */ ''
          rules:
            document-start:
              present: false
            line-length:
              max: 180
        ''}"
      ];
      lintersByFt = {
        go = [ "golangcilint" ];
        json = [ "jsonlint" ];
        markdownlint = [ "markdownlint-cli2" ];
        nix = [ "deadnix" "nix" "statix" ];
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
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
        gopls = {
          enable = true;
          settings.gopls = {
            staticcheck = true;
          };
        };
        html.enable = true;
        java-language-server = {
          enable = true;
          # rootDir = "nvim_lsp.util.root_pattern('.git')";
        };
        jsonls.enable = true;
        # does language correction even on keywords...
        #ltex.enable = true;
        lua-ls = {
          enable = true;
          extraOptions.Lua = {
            telemetry.enable = false;
          };
        };
        marksman.enable = true;
        #nixd.enable = true;
        nil-ls = {
          enable = true;
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
            nix.flake.autoArchive = true;
          };
        };
        pylsp.enable = true;
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
        yamlls = {
          enable = true;
          settings.yaml.format.printWidth = 180;
        };
        lemminx.enable = true;
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

    schemastore = {
      enable = true;
      json.enable = true;
      yaml.enable = true;
    };
  };

  keymaps = [ {
    mode = "n";
    key = "<leader>tld";
    action = "<Plug>(toggle-lsp-diag)";
    options.desc = "Toggle LSP diagnostics";
  } ];
}
