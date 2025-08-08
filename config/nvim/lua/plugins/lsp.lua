return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

        local nproc = vim.fn.systemlist("nproc")[1]

        lspconfig.lua_ls.setup({
            capabilities = lsp_capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            }
        })

        lspconfig.rust_analyzer.setup {
            capabilities = lsp_capabilities,
        }

        lspconfig.java_language_server.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.pyright.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.racket_langserver.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.julials.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.ts_ls.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.bashls.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.gopls.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.clangd.setup{
          capabilities = lsp_capabilities,
          cmd = {
            "clangd",
            "--header-insertion=never",
            "-j=" .. nproc,
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--background-index",
          }
        }

        lspconfig.cmake.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.dockerls.setup{
            capabilities = lsp_capabilities,
        }

        lspconfig.ocamllsp.setup{
            capabilities = lsp_capabilities,
        }

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
