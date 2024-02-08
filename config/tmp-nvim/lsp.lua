return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup();
        end
    },
    {
        "neovim/nvim-lspconfig", 
        ft = {"lua"}, 
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspc = require('lspconfig')

            -- lspc['julials'].setup({capabilities = capabilities})
            lspc.lua_ls.setup({capabilities = capabilities})
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        cmd = "LspInstall",
        opts = {}
    },
}