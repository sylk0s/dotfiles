-- Open NERDTree on nvim startup
vim.api.nvim_create_autocmd(
  "VimEnter",
  { command = [[NERDTree | wincmd p]] }
)

-- Exits nvim if NERDTree is the only remaining window
vim.api.nvim_create_autocmd(
  "BufEnter",
  { command = [[if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]] }
)

-- If a buffer tries to replace NERDTree, move it elsewhere and then bring back NERDTree
vim.api.nvim_create_autocmd(
  "BufEnter",
  { command = [[if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif]] }
)
