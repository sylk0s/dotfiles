return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true
    vim.keymap.set("n", "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", {desc = "Bufferline next"})
    vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", {desc = "Bufferline prev"})
    vim.keymap.set("n", "<leader>bf", "<Cmd>BufferLinePick<CR>", {desc = "Buffer line pick"})
    vim.keymap.set("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", {desc = "Buffer line close"})
    vim.keymap.set("n", "<leader>bm", "<Cmd>BufferLineMoveNext<CR>", {desc = "Buffer move next"})
    vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineMovePrev<CR>", {desc = "Buffer move prev"})


    for i=1,9 do vim.keymap.set("n", "<leader>b"..tostring(i), "<Cmd>BufferLineGoToBuffer "..tostring(i).."<CR>", {desc= "Go to buffer "..tostring(i)}) end

    require("bufferline").setup{
      options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_buffer_icon = true,

        -- custom area for diagnostic alerts
        custom_areas = {
          right = function()
              local result = {}
              local seve = vim.diagnostic.severity
              local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
              local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
              local info = #vim.diagnostic.get(0, {severity = seve.INFO})
              local hint = #vim.diagnostic.get(0, {severity = seve.HINT})

              if error ~= 0 then
                  table.insert(result, {text = "  " .. error, link = "DiagnosticError"})
              end

              if warning ~= 0 then
                  table.insert(result, {text = "  " .. warning, link = "DiagnosticWarn"})
              end

              if hint ~= 0 then
                  table.insert(result, {text = "  " .. hint, link = "DiagnosticHint"})
              end

              if info ~= 0 then
                  table.insert(result, {text = "  " .. info, link = "DiagnosticInfo"})
              end
              return result
          end,
        }
      }
    }
  end
}
