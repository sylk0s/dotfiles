local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

require('luasnip.loaders.from_vscode').lazy_load()

-- Treesitter enable
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = "all",

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  --indent = {
  --  enable = true,
  --}
}

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

require("mason").setup()

local lsp_config = require("lspconfig")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Lua LSP Config
lsp_config.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'use'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lsp_config.julials.setup{}

lsp_config.arduino_language_server.setup {
  cmd = {
    "arduino-language-server",
    "-cli-config", "/path/to/arduino-cli.yaml",
    "-fqbn", "arduino:avr:uno",
    "-cli", "arduino-cli",
    "-clangd", "clangd"
  }
}

lsp_config.awk_ls.setup{}
lsp_config.bashls.setup{}
lsp_config.cmake.setup{}
lsp_config.cssls.setup{}
lsp_config.dockerls.setup{}
lsp_config.gradle_ls.setup{}
lsp_config.gopls.setup{}
lsp_config.html.setup{}
lsp_config.java_language_server.setup{}
lsp_config.jsonls.setup{}
lsp_config.opencl_ls.setup{}
lsp_config.pylsp.setup{}
lsp_config.quick_lint_js.setup{}
lsp_config.r_language_server.setup{}
lsp_config.racket_langserver.setup{}
lsp_config.rust_analyzer.setup{}
lsp_config.terraform_lsp.setup{}
lsp_config.texlab.setup{}
lsp_config.tsserver.setup{}
