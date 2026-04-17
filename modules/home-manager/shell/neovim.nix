{
  config,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.shell.neovim;
in {
  options.sylk.shell.neovim = {
    enable = mk-enable true;
  };

  # Some links
  # https://nixalted.com/
  # https://github.com/KFearsoff/NixOS-config/blob/088641c3527f1027ebd366a9abb5cc557cd6f0c1/modules/neovim/lua/plugins/nix.lua
  # https://github.com/Kidsan/nixos-config/blob/main/home/programs/neovim/nvim/lua/plugins/lsp.lua
  # https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          # LSP
          lua-language-server
          rust-analyzer
          java-language-server
          #TODO
          #nodePackages.pyright
          typescript-language-server
          bash-language-server
          #clang-tools_17
          cmake-language-server
          dockerfile-language-server
          statix
          alejandra
          nil
          vtsls

          # Deps of telescope
          ripgrep
          fd

          # deps of the sshfs thing I use
        ]
        ++ (with pkgs.ocamlPackages; [
          ocaml-lsp
        ]);

      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    nixpkgs.overlays = [inputs.flake-awesome-neovim-plugins.overlays.default];

    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        defaultEditor = true;

        plugins = (with pkgs.vimPlugins; [
          lazy-nvim

          which-key-nvim
          nvim-autopairs

          # theming
          catppuccin-nvim

          # completions
          nvim-cmp
          cmp-buffer # buffer completions
          cmp-path # path completions
          cmp_luasnip # snipper completions
          cmp-nvim-lsp # LSP completions
          cmp-cmdline

          # snippets
          luasnip
          friendly-snippets

          # lsp
          nvim-lspconfig
          nvim-lint

          # treesitter
          nvim-treesitter.withAllGrammars

          telescope-nvim
          plenary-nvim
          nvim-web-devicons

          comment-nvim
          lualine-nvim
          gitsigns-nvim
          neo-tree-nvim
          todo-comments-nvim
          bufferline-nvim
          remote-sshfs-nvim
          persistence-nvim

          cmp-nvim-lua
          cmp-latex-symbols
          cmp-nvim-lsp-document-symbol
          cmp-nvim-lsp-signature-help
          cmp-calc
  
          alpha-nvim

          # web dev things.
          neotest
          neotest-vitest
          null-ls-nvim
          FixCursorHold-nvim

          precognition-nvim

          ocaml-nvim
          # TODO ???
          # comfort.nvim
          # lang specific
          # spectre, flash
          # leap?
          # diffview
        ]) ++ (with pkgs.awesomeNeovimPlugins; [
          prettier-nvim
          nvim-eslint
        ]);

        initLua = ''
          vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings

          require("lazy").setup({
                  spec = {
                     -- Import plugins from lua/plugins
                     { import = "plugins" },
                  },
                  performance = {
                    reset_packpath = false,
                    rtp = {
                        reset = false,
                    }
                },
                dev = {
                    path = "${config.xdg.dataHome}/nvim/site/pack/hm/start",
                    patterns = {""},
                },
                install = {
                    -- Safeguard in case we forget to install a plugin with Nix
                    missing = false,
                },
          })

          require("settings")
        '';
      };
    };

    xdg.configFile."nvim/lua" = {
      recursive = true;
      source = "${inputs.self.outPath}/config/nvim/lua";
    };
  };
}
