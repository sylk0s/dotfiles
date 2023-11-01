{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.neovim;
in {
  options.modules.shell.neovim = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      neovim
    ];

    # I stole this as an example
    # TODO just redo my vim config some time
    home-manager.users.${config.user.name}.programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          # Syntax
          vim-nix
          vim-markdown
                    yuck-vim

          # Quality of life
          vim-lastplace         # Opens document where you left it
          auto-pairs            # Print double quotes/brackets/etc
          vim-gitgutter         # See uncommitted changes of file :GitGutterEnable

          # File Tree
          nerdtree              # File Manager - set in extraConfig to F6

          # Customization
          wombat256-vim         # Color scheme for lightline
          #srcery-vim            # Color scheme for text

          lightline-vim         # Info bar at bottom
          indent-blankline-nvim # Indentation lines
        ];

        extraConfig = ''
          syntax enable                             " Syntax highlighting
          "colorscheme srcery                        " Color scheme text

          let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }                                     " Color scheme lightline

          highlight Comment cterm=italic gui=italic " Comments become italic
          hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

          set number                                " Set numbers

          nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree

      "expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
        '';
      };
    };
  };
}
