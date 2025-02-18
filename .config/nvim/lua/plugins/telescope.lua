local M = {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
}
M.config = function()
	require("telescope").setup({
		defaults = {
			file_ignore_patterns = {
				".git/",
				"node_modules",
				"dist",
				".nx",
				".angular",
			},
		},
		pickers = {
			find_files = {
				hidden = true,
				layout_strategy = "vertical",
				layout_config = {
					vertical = { width = 0.8 },
				},
			},
      builtin = {
        buffers = {
          sort_mru = true
        }
      },
			live_grep = {
				additional_args = function()
					return { "--hidden" }
				end,
				layout_strategy = "vertical",
			},
		},
	})

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<C-p>", builtin.find_files, {})
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	vim.keymap.set("n", "<leader>.", function()
		builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
	end)
end

return M
