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