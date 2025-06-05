local M = {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { 
		"nvim-lua/plenary.nvim",
		"kkharji/sqlite.lua", -- Required dependency for frecency
		"nvim-telescope/telescope-frecency.nvim", 
	},
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
			-- Better fuzzy finding settings
			path_display = { "truncate" },
			sorting_strategy = "ascending",
			layout_strategy = "vertical",
			layout_config = {
				vertical = { width = 0.8 },
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
		},
		pickers = {
			find_files = {
				hidden = true,
				layout_strategy = "vertical",
				layout_config = {
					vertical = { width = 0.8 },
				},
				-- Enable fuzzy finder
				find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
			},
			buffers = {
				sort_mru = true
			},
			oldfiles = {
				layout_strategy = "vertical",
				layout_config = {
					vertical = { width = 0.8 },
				},
				sort_mru = true,
				prompt_title = "Recently Used Files"
			},
			live_grep = {
				additional_args = function()
					return { "--hidden" }
				end,
				layout_strategy = "vertical",
			},
		},
		extensions = {
			frecency = {
				db_root = vim.fn.stdpath("data"),
				show_scores = true, -- Show frecency scores
				show_unindexed = true,
				ignore_patterns = {
					"*.git/*", 
					"*/tmp/*",
					"*/node_modules/*",
					"*/dist/*",
					"*/.nx/*",
					"*/.angular/*",
				},
				workspaces = {
					-- Add your workspaces here
					["frontend"] = vim.fn.expand("~/src/frontend"),
				},
				layout_strategy = "vertical",
				layout_config = {
					vertical = { width = 0.8 },
				},
				default_workspace = "CWD",
				max_timestamps = 10000,
				show_filter_column = true, -- Show filter column
			},
		},
	})
	
	-- Load extensions
	require("telescope").load_extension("frecency")
	
	local builtin = require("telescope.builtin")
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	
	-- Custom smart file finder that combines frecency with fuzzy finding
	local function smart_file_finder()
		telescope.extensions.frecency.frecency({
			layout_strategy = "vertical",
			layout_config = {
				vertical = { 
					width = 0.8,
					height = 0.9,
					prompt_position = "top",
					preview_cutoff = 40,
				},
			},
			prompt_title = "Smart File Search (Recent + All Files)",
			show_scores = true,
			show_filter_column = true,
		})
	end
	
	-- Alternative: Create a custom picker that merges recent and all files
	local function unified_file_search()
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local make_entry = require("telescope.make_entry")
		
		-- Get recent files from frecency
		local recent_files = {}
		local frecency_db = require("telescope._extensions.frecency.db")
		if frecency_db then
			local files = frecency_db.get_file_scores(vim.loop.cwd(), {})
			for _, file in ipairs(files) do
				if #recent_files < 100 then -- Limit recent files
					table.insert(recent_files, file.filename)
				end
			end
		end
		
		-- Custom finder that searches both recent and all files
		local finder = finders.new_async_job({
			command_generator = function(prompt)
				if prompt == "" or prompt == nil then
					-- Show recent files when no search term
					return { "echo", table.concat(recent_files, "\n") }
				else
					-- Use ripgrep for fuzzy finding when searching
					return { 
						"rg", 
						"--files", 
						"--hidden", 
						"--glob", "!.git/*",
						"--glob", "!node_modules/*",
						"--glob", "!dist/*",
						"--glob", "!.nx/*",
						"--glob", "!.angular/*",
					}
				end
			end,
			entry_maker = make_entry.gen_from_file({}),
			cwd = vim.loop.cwd(),
		})
		
		pickers.new({}, {
			prompt_title = "Files (Recent → All)",
			finder = finder,
			sorter = conf.file_sorter({}),
			previewer = conf.file_previewer({}),
			layout_strategy = "vertical",
			layout_config = {
				vertical = { 
					width = 0.8,
					height = 0.9,
					prompt_position = "top",
				},
			},
		}):find()
	end
	
	-- Keymaps
	vim.keymap.set("n", "<C-p>", smart_file_finder, { desc = "Smart file search" })
	
	-- Alternative mapping for unified search
	vim.keymap.set("n", "<leader>fu", unified_file_search, { desc = "Unified file search" })
	
	-- Keep your existing keymaps
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
	vim.keymap.set("n", "<leader>.", function()
		builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
	end, { desc = "Find files in current directory" })
	
	-- Frecency specific bindings
	vim.keymap.set("n", "<leader>fr", function()
		telescope.extensions.frecency.frecency()
	end, { desc = "Frecency files" })
	
	-- Old files for comparison
	vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old files" })
	
	-- LSP bindings
	vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Find references' })
	vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Go to definition' })
	
	-- User commands
	vim.api.nvim_create_user_command("FrecencyRecent", function()
		telescope.extensions.frecency.frecency({ default_filter = "recent" })
	end, {})
	
	vim.api.nvim_create_user_command("FrecencyAll", function() 
		telescope.extensions.frecency.frecency({ default_filter = "frecent" })
	end, {})
	
	-- Command for quick file type switching
	vim.api.nvim_create_user_command("Files", smart_file_finder, {})
end

return M
