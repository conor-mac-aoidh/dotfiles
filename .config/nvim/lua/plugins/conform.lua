-- Modern formatting with conform.nvim
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        lua = { "stylua" },
      },
      
      -- Format on save
      format_on_save = function(bufnr)
        -- Disable for certain file types
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      
      -- Customize formatters
      formatters = {
        prettier = {
          -- Only run if config file exists
          condition = function(self, ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.cjs",
              "prettier.config.js",
              "prettier.config.cjs",
            }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    })

    -- Command to toggle format on save
    vim.api.nvim_create_user_command("FormatToggle", function()
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
        vim.notify("Format on save enabled", vim.log.levels.INFO)
      else
        vim.g.disable_autoformat = true
        vim.notify("Format on save disabled", vim.log.levels.WARN)
      end
    end, { desc = "Toggle format on save" })
  end,
}
