return {
  'ruifm/gitlinker.nvim',
  requires = 'nvim-lua/plenary.nvim',
  config = function()
    require"gitlinker".setup()
    vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {silent = true})
    vim.api.nvim_set_keymap('v', '<leader>gl', '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})
  end,
}
