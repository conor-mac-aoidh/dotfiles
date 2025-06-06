-- Modern linting with nvim-lint
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Function to check if a linter is available
    local function is_executable(name)
      if vim.fn.executable(name) == 1 then
        return true
      end
      -- Check Mason's bin directory
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. name
      return vim.fn.executable(mason_bin) == 1
    end

    -- Configure linters with fallback
    lint.linters_by_ft = {
      javascript = {},
      javascriptreact = {},
      typescript = {},
      typescriptreact = {},
    }

    -- Set up linter based on availability
    local function setup_eslint_linter()
      local linters = {}
      
      if is_executable("eslint_d") then
        table.insert(linters, "eslint_d")
      elseif is_executable("eslint") then
        table.insert(linters, "eslint")
      end

      if #linters > 0 then
        lint.linters_by_ft.javascript = linters
        lint.linters_by_ft.javascriptreact = linters
        lint.linters_by_ft.typescript = linters
        lint.linters_by_ft.typescriptreact = linters
        
        vim.notify("Using linter: " .. table.concat(linters, ", "), vim.log.levels.INFO)
      else
        vim.notify("No ESLint linter found. Install eslint_d or eslint via Mason.", vim.log.levels.WARN)
      end
    end

    -- Configure Mason path
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

    -- Set up linters after a delay to allow Mason to install
    vim.defer_fn(setup_eslint_linter, 1000)

    -- Performance: debounce linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if eslint config exists and linters are configured
        local has_eslint_config = vim.fs.find({
          ".eslintrc",
          ".eslintrc.json",
          ".eslintrc.js",
          ".eslintrc.cjs",
          "eslint.config.js",
          "eslint.config.cjs",
        }, { upward = true })[1]

        if has_eslint_config and #(lint.linters_by_ft[vim.bo.filetype] or {}) > 0 then
          lint.try_lint()
        end
      end,
    })

    -- Manual lint command
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    -- Command to refresh linter setup
    vim.api.nvim_create_user_command("LintRefresh", setup_eslint_linter, { desc = "Refresh linter setup" })
  end,
}
