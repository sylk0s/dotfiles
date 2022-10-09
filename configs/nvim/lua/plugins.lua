local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end
vim.cmd('packadd packer.nvim')
local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'vimwiki/vimwiki'
    --use 'preservim/nerdtree'
    --use 'ms-jpq/chadtree'
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
	'kyazdani42/nvim-web-devicons', -- optional, for file icons
      },
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use 'kyazdani42/nvim-web-devicons'
    use 'akinsho/bufferline.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use 'onsails/lspkind.nvim'
    use { "williamboman/mason.nvim" }

    use 'simrat39/rust-tools.nvim'
    use 'timonv/vim-cargo'
    use 'JuliaEditorSupport/julia-vim'
    use 'elkowar/yuck.vim'
    use 'gpanders/nvim-parinfer'
    use 'benknoble/vim-racket'

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'

    use 'neovim/nvim-lspconfig'
    use 'windwp/nvim-autopairs'

    use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"})
    use 'saadparwaiz1/cmp_luasnip'

    use 'nvim-treesitter/nvim-treesitter'
    use 'ryanoasis/vim-devicons'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use 'nvim-lualine/lualine.nvim'

    use {
     'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
end)
