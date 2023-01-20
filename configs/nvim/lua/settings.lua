vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- This works, it doesnt work when i do it with the proper lua thingy...
vim.cmd [[set mouse=a]]

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

vim.cmd [[colorscheme catppuccin]]

-- vim.cmd [[colorscheme onedark]]
vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]


vim.cmd [[let g:vimtex_view_method = 'zathura']]
vim.cmd [[let maplocalleader = ","]]

vim.cmd [[set conceallevel=1]]
vim.cmd [[let g:tex_conceal='abdmg']]

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})

require("luasnip").config.set_config({ -- Setting LuaSnip config

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use Tab (or some other key if you prefer) to trigger visual selection
  store_selection_keys = "<Tab>",
})

--require('lualine').setup()
