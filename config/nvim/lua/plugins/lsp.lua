return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup();
        end
    },
    {
        "neovim/nvim-lspconfig", 
        ft = {"julia", "typst"}, 
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
            local lspc = require('lspconfig')
            lspc['julials'].setup{capabilities = capabilities}
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        cmd = "LspInstall",
        opts = {}
    },
}