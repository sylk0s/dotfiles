return {
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = 'Find files'})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = 'Live grep'})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = 'Find buffer'})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = 'Find help'})
        vim.keymap.set('n', '<leader>ft', builtin.treesitter, {desc = 'Find TS names'})
        vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, {desc = 'Find implementations'})
        vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {desc = 'Find definitions'})
        vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, {desc = 'Find type definitions'})
        vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {desc = 'Find references'})
        vim.keymap.set('n', '<leader>fci', builtin.lsp_incoming_calls, {desc = 'Find incoming calls'})
        vim.keymap.set('n', '<leader>fco', builtin.lsp_outgoing_calls, {desc = 'Find outgoing calls'})
        vim.keymap.set('n', '<leader>fsb', builtin.lsp_document_symbols, {desc = 'Find buffer symbols'})
        vim.keymap.set('n', '<leader>fsw', builtin.lsp_document_symbols, {desc = 'Find workspace symbols'})
      end,
    }
