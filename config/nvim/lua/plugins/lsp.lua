return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        lspconfig.lua_ls.setup({
            capabilities = lsp_capabilities,
        })

        -- FIX HERE
        lspconfig.rust_analyzer.setup {}

        lspconfig.java_language_server.setup{}

        lspconfig.pyright.setup{}

        lspconfig.racket_langserver.setup{}

        lspconfig.julials.setup{}

        lspconfig.tsserver.setup{}

        lspconfig.bashls.setup{}

        lspconfig.clangd.setup{}

        lspconfig.cmake.setup{}

        lspconfig.dockerls.setup{}

        lspconfig.nil_ls.setup{
            autostart = true,
            capabilities = lsp_capabilities,
            settings = {
                ['nil'] = {
                    testSetting = 42,
                    formatting = {
                        command = { "alejandra" },
                    },
                },
            }
        }
    end
}