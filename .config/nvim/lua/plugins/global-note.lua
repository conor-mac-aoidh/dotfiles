local M = {
	"backdround/global-note.nvim",
	lazy = false,
}

M.config = function()
	local global_note = require("global-note")
	global_note.setup({
		filename = "todo.md",
		directory = "./",
	})

	vim.keymap.set("n", "<leader>n", global_note.toggle_note, {
		desc = "Toggle note",
	})
end

return M
