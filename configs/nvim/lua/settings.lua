vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- This works, it doesnt work when i do it with the proper lua thingy...
vim.cmd [[set mouse=a]]

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

vim.cmd [[colorscheme catppuccin]]

-- vim.cmd [[colorscheme onedark]]
vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]

require('lualine').setup()
