call plug#begin()

" Navigation
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} " Some config done, need to setup keybinds
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim'

" Aesthetic
Plug 'rakr/vim-one' 

" Language Server / Lang Specific
Plug 'onsails/lspkind.nvim'
Plug 'iamcco/vim-language-server'
Plug 'simrat39/rust-tools.nvim'
Plug 'timonv/vim-cargo'
Plug 'JuliaEditorSupport/julia-vim' 

" CMP Stuff
Plug 'hrsh7th/nvim-cmp' 
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'windwp/nvim-autopairs'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'kdheepak/cmp-latex-symbols'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'


Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()
