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
    use 'preservim/nerdtree'
    use 'kyazdani42/nvim-web-devicons'
    use 'akinsho/bufferline.nvim'
    use 'ii14/onedark.nvim'
    use 'onsails/lspkind.nvim'

    use 'simrat39/rust-tools.nvim'
    use 'timonv/vim-cargo'
    use 'JuliaEditorSupport/julia-vim'

    use 'hrsh7th/nvim-cmp'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'windwp/nvim-autopairs'

    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'

    use 'nvim-treesitter/nvim-treesitter'
    use 'ryanoasis/vim-devicons'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
end)
