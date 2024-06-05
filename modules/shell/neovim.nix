{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell.neovim;
in {
  options.modules.shell.neovim = {
    enable = mkBoolOpt true;
  };

  # Some links
  # https://nixalted.com/
  # https://github.com/KFearsoff/NixOS-config/blob/088641c3527f1027ebd366a9abb5cc557cd6f0c1/modules/neovim/lua/plugins/nix.lua
  # https://github.com/Kidsan/nixos-config/blob/main/home/programs/neovim/nvim/lua/plugins/lsp.lua
  # https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

  config = mkIf cfg.enable {
    environment.variables.EDITOR = "nvim";

    environment.systemPackages = with pkgs; [
      # LSP
      lua-language-server
      rust-analyzer
      java-language-server
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      clang-tools_17
      cmake-language-server
      dockerfile-language-server-nodejs
      statix
      alejandra
      nil

      # Deps of telescope
      ripgrep
      fd
    ];

    home-manager.users.${config.user.name} = {
      programs = {
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;

          plugins = with pkgs.vimPlugins; [
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

            # TODO
            # telescope
            telescope-nvim
            plenary-nvim
            nvim-web-devicons

            # TODO
            # comfort.nvim
            # UI stuff
            # lang specific
            # spectre, flash
            # todo-comments-nvim
            # leap?
            alpha-nvim
            # copilot?
            # diffview
            # noice
            #
          ];

          extraLuaConfig = ''
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
                      path = "${pkgs.vimUtils.packDir config.home-manager.users.${config.user.name}.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
                      patterns = {"folke", "catppuccin", "nvim-treesitter", "hrsh7th", "saadparwaiz1", "L3MON4D3", "neovim", "mfussenegger", "rafamadriz", "windwp", "nvim-tree", "nvim-lua", "nvim-telescope", "goolord" },
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
        source = "${config.dotfiles.configDir}/nvim/lua";
      };
    };
  };
}
