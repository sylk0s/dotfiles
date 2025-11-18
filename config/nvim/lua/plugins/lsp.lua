return {
    "neovim/nvim-lspconfig",
    config = function()
        local lsp = vim.lsp -- require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

        local nproc = vim.fn.systemlist("nproc")[1]

        lsp.config("lua_ls", {
            capabilities = lsp_capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            }
        })

        lsp.config("rust_analyzer", {
            capabilities = lsp_capabilities,
        })

        lsp.config("java_language_server", {
            capabilities = lsp_capabilities,
        })

        lsp.config("pyright", {
            capabilities = lsp_capabilities,
        })

        lsp.config("racket_langserver", {
            capabilities = lsp_capabilities,
        })

        lsp.config("julials", {
            capabilities = lsp_capabilities,
        })

        lsp.config("ts_ls", {
            capabilities = lsp_capabilities,
        })

        lsp.config("bashls", {
            capabilities = lsp_capabilities,
        })

        lsp.config("gopls", {
            capabilities = lsp_capabilities,
        })

        lsp.config("clangd", {
          capabilities = lsp_capabilities,
          cmd = {
            "clangd",
            "--header-insertion=never",
            "-j=" .. nproc,
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--background-index",
          }
        })

        lsp.config("cmake", {
            capabilities = lsp_capabilities,
        })

        lsp.config("dockerls", {
            capabilities = lsp_capabilities,
        })

        lsp.config("ocamllsp", {
            capabilities = lsp_capabilities,
        })

        lsp.config("nil_ls", {
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
        })
    end
}
