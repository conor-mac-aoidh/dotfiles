return {
  'glepnir/lspsaga.nvim',
  branch = 'main',
  config = function()
    require('lspsaga').setup({
      preview = {
        height = 0.8,
        width = 0.8
      },
      lightbulb = {
        enable = false,
      }
    })
  end,
}
