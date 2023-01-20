local keymap = vim.api.nvim_set_keymap

-- VSC Like Saving
keymap('n', '<c-s>', ':w<CR>', {})
keymap('i', '<c-s>', '<Esc>:w<CR>a', {})

-- Navigation Keybinds between vim windows
local opts = { noremap = true }
keymap('n', '<c-j>', '<c-w>j', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-k>', '<c-w>k', opts)
keymap('n', '<c-l>', '<c-w>l', opts)

-- Maps keybind in normal mode
local function nkeymap(key, map)
  keymap('n', key, map, opts)
end

-- mapping for autocomplete
keymap('i', 'Tab', 'cmp.mapping.confirm({ select = true })<cr>', opts)

nkeymap('gd', ':lua vim.lsp.buf.definition()<cr>')
nkeymap('gD', ':lua vim.lsp.buf.declaration()<cr>')
nkeymap('gi', ':lua vim.lsp.buf.implementation()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.document_symbol()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.workspace_symbol()<cr>')
nkeymap('gr', ':lua vim.lsp.buf.references()<cr>')
nkeymap('gt', ':lua vim.lsp.buf.type_definition()<cr>')
nkeymap('K', ':lua vim.lsp.buf.hover()<cr>')
nkeymap('<c-k>', ':lua vim.lsp.buf.signature_help()<cr>')
nkeymap('<leader>af', ':lua vim.lsp.buf.code_action()<cr>')
nkeymap('<leader>rn', ':lua vim.lsp.buf.rename()<cr>')
nkeymap('\\', ':NvimTreeToggle<CR>')
nkeymap('<c-n>', ':bnext<cr>')
nkeymap('<c-m>', ':bprevious<cr>')

nkeymap('ff',':Telescope find_files<cr>')
nkeymap('fg',':Telescope live_grep<cr>')
nkeymap('fb',':Telescope buffers<cr>')
nkeymap('fh',':Telescope help_tags<cr>')
