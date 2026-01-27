return {
  "ocaml/ocaml.nvim",
  config = function ()
    if vim.fn.executable('ocamllsp') ~= 1 then
      return
    end

    require("ocaml").setup({
      keymaps = {
        jump_next_hole = '<leader>ohj',
        jump_prev_hole = '<leader>ohk',
        construct = '<leader>oc',
        jump = '<leader>oj',
        phrase_prev = '<leader>opk',
        phrase_next = '<leader>opj',
        type_enclosing = '<leader>ot',
        type_enclosing_grow = 'k',
        type_enclosing_shrink = 'j',
        type_enclosing_increase = 'l',
        type_enclosing_decrease = 'h',
      }
    })
  end
}
