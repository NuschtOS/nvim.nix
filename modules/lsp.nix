{ pkgs, ... }:

{
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
        bashls.enable = true;
        cssls.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        eslint.enable = true;
        gopls = {
          enable = true;
          package = pkgs.go_latest;
          settings.gopls = {
            staticcheck = true;
          };
        };
        html.enable = true;
        java_language_server = {
          enable = true;
          # rootDir = "nvim_lsp.util.root_pattern('.git')";
        };
        jsonls.enable = true;
        lua_ls = {
          enable = true;
          extraOptions.Lua = {
            telemetry.enable = false;
          };
        };
        marksman.enable = true;
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
            nix.flake.autoArchive = true;
          };
        };
        pylsp.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          package = null;
          settings = {
            cargo.features = "all";
            check.features = "all";
          };
        };
        sqls.enable = true;
        taplo.enable = true;
        texlab.enable = true;
        ts_ls.enable = true;
        typos_lsp.enable = true;
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
            desc = "Goto Type Definition";
          };
          "gi" = {
            action = "implementation";
            desc = "Goto Implementation";
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

  keymaps = [{
    mode = "n";
    key = "<leader>tld";
    action = "<Plug>(toggle-lsp-diag)";
    options.desc = "Toggle LSP diagnostics";
  }];
}
