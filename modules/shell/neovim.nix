{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.neovim;
in {
  options.modules.shell.neovim = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    environment.variables.EDITOR = "nvim";

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
            catppuccin-nvim
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
                      patterns = {"folke", "catppuccin" }, -- Specify that "folke/which-key.nvim" will use our dev dir
                  },
                  install = {
                      -- Safeguard in case we forget to install a plugin with Nix
                      missing = false,
                  },
            })

            vim.cmd.colorscheme "catppuccin"

            local opt = vim.opt

            opt.mouse = "a"

            opt.number = true
            opt.relativenumber = true

            opt.autoindent = true
            opt.smartindent = true

            opt.tabstop = 2
            opt.softtabstop = 2
            opt.shiftwidth = 2
            opt.expandtab = true

            opt.completeopt = {'menu', 'menuone', 'noselect'}
          '';
        };
      };

      # plugins = with pkgs.vimPlugins; [
      #   myConfig
      # ];

      # extraConfig = "luafile /home/sylkos/dotfiles/config/nvim/init.lua";

      #   plugins = with pkgs.vimPlugins; [
      #     # Syntax
      #     vim-nix
      #     vim-markdown
      #     yuck-vim

      #     # Quality of life
      #     vim-lastplace # Opens document where you left it
      #     auto-pairs # Print double quotes/brackets/etc
      #     vim-gitgutter # See uncommitted changes of file :GitGutterEnable

      #     # File Tree
      #     nerdtree # File Manager - set in extraConfig to F6

      #     # Customization
      #     wombat256-vim # Color scheme for lightline
      #     #srcery-vim            # Color scheme for text

      #     lightline-vim # Info bar at bottom
      #     indent-blankline-nvim # Indentation lines
      #   ];

      #       extraConfig = ''
      #         syntax enable                             " Syntax highlighting
      #         "colorscheme srcery                        " Color scheme text

      #         let g:lightline = {
      #             \ 'colorscheme': 'wombat',
      #             \ }                                     " Color scheme lightline

      #         highlight Comment cterm=italic gui=italic " Comments become italic
      #         hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

      #         set number                                " Set numbers

      #         nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree

      #         set expandtab
      #         set autoindent
      #         set tabstop=4
      #         set shiftwidth=4
      #         set softtabstop=4
      #       '';
      #     };
      #   };

      xdg.configFile."nvim/lua" = {
        recursive = true;
        source = "${config.dotfiles.configDir}/nvim/lua";
      };
    };
  };
}
