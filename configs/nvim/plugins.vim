call plug#begin()

Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} " Some config done, need to setup keybinds

Plug 'rakr/vim-one' " Config Finished

Plug 'timonv/vim-cargo' " Learn Keybinds
Plug 'JuliaEditorSupport/julia-vim' " Intricate said something about making this better, i should mess with that

Plug 'hrsh7th/nvim-cmp' " Nope!
Plug 'neovim/nvim-lspconfig'
Plug 'windwp/nvim-autopairs'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'kdheepak/cmp-latex-symbols'

" Had some issues with python here :\
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim' " Did some stuff here

call plug#end()
