return {
  -- Debug Adapter Protocol client for Neovim
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- JavaScript/TypeScript debug adapter
      "mxsdev/nvim-dap-vscode-js",
      -- UI for nvim-dap
      "rcarriga/nvim-dap-ui",
      -- Virtual text for breakpoints
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require('dap')
      local dap_js = require('dap-vscode-js')
      local dapui = require('dapui')

      -- Setup dap-vscode-js
      dap_js.setup({
        debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
        adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'node-terminal' },
      })

      -- Configure Chrome adapter
      dap.configurations.typescript = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome against localhost",
          url = "https://localhost:4200", -- Adjust to your Angular app's port
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          trace = true, -- Enable for detailed logs
        }
      }
      -- Also add the configuration for JavaScript files
      dap.configurations.javascript = dap.configurations.typescript
      dap.configurations.javascriptreact = dap.configurations.typescript
      dap.configurations.typescriptreact = dap.configurations.typescript

      -- Setup DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.3 },
              { id = "breakpoints", size = 0.2 },
              { id = "stacks", size = 0.3 },
              { id = "watches", size = 0.2 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Set keymaps
      vim.keymap.set('n', '<F5>', function() dap.continue() end)
      vim.keymap.set('n', '<F10>', function() dap.step_over() end)
      vim.keymap.set('n', '<F11>', function() dap.step_into() end)
      vim.keymap.set('n', '<F12>', function() dap.step_out() end)
      vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
      vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end)
      vim.keymap.set('n', '<leader>dl', function() dap.run_last() end)
    end
  },
  -- vscode-js-debug installation - this is downloaded and built on demand
  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    lazy = true,
  },
}
