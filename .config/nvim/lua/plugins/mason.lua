-- Comprehensive Mason setup with proper loading order
return {
  {
    -- Base Mason installation
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "eslint_d",
        "prettier",
        "typescript-language-server",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        },
        border = "rounded",
      },
      PATH = "prepend",
    },
    config = function(_, opts)
      require("mason").setup(opts)
      
      -- Add Mason bin to PATH
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      
      -- Auto-install tools
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  
  {
    -- LSP configuration bridge
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "eslint", 
        "angularls",
        "jsonls",
        "html",
        "cssls",
        "lua_ls",
      },
      automatic_installation = true,
    },
  },
}
