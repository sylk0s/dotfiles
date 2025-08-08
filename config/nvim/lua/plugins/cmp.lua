return {
	"hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		{"L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
    }},
    "kdheepak/cmp-latex-symbols",
    -- "zjp-CN/nvim-cmp-lsp-rs",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-calc",
	},
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            diagnostics = "nvim_lsp",
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                      if luasnip.expandable() then
                          luasnip.expand()
                      else
                          cmp.confirm({
                              select = true,
                          })
                      end
                  else
                      fallback()
                  end
              end),

              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = 'nvim_lsp_signature_help' },
                { name = "nvim_lua" },
                { name = "luasnip" }, -- For luasnip users.
                {
                  name = "latex_symbols",
                  option = {
                    strategy = 1, -- julia
                  },
                },
                { name = "calc" },
                { name = "buffer" },
                { name = "path" },
            }),
        })


        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            {{ name = 'nvim_lsp_document_symbol' },},
            {{ name = 'buffer' },},
          }
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
