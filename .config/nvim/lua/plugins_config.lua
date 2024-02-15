------------------------------
---> Treesitter
------------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "typescript", "javascript", "markdown", "json" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}

------------------------------
---> Telescope
------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      ".git/",
      "node_modules",
      "dist",
      ".nx",
      ".angular",
    }
  },
  pickers = {
    find_files = {
      hidden = true,
      layout_strategy = 'vertical',
      layout_config = {
        vertical = { width = 0.8 }
      }
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end,
      layout_strategy = 'vertical',
    },
  }
}

------------------------------
---> Global Note
------------------------------
local global_note = require("global-note")
global_note.setup({
  filename = "todo.md",
  directory = "./",
})

vim.keymap.set("n", "<leader>n", global_note.toggle_note, {
  desc = "Toggle note",
})
