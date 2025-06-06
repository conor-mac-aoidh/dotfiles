-- Modern LSP configuration
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim", -- JSON schemas
  },
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Enhanced capabilities for better completions
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    
    -- Performance optimizations
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" }
    }

    -- Performance-optimized on_attach function
    local on_attach = function(client, bufnr)
      -- Disable LSP formatting (let conform.nvim handle it)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      
      -- Disable inlay hints by default (uncomment next lines to enable)
      -- if client.supports_method("textDocument/inlayHint") then
      --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      -- end
      
      -- Buffer-local keymaps
      local opts = { buffer = bufnr, silent = true }
      local keymap = vim.keymap.set
      
      keymap("n", "gd", vim.lsp.buf.definition, opts)
      keymap("n", "gD", vim.lsp.buf.declaration, opts)
      keymap("n", "gi", vim.lsp.buf.implementation, opts)
      keymap("n", "gt", vim.lsp.buf.type_definition, opts)
      keymap("n", "K", vim.lsp.buf.hover, opts)
      keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      keymap("n", "<leader>D", vim.lsp.buf.type_definition, opts)
      keymap("n", "gl", vim.diagnostic.open_float, opts)
      keymap("n", "[d", vim.diagnostic.goto_prev, opts)
      keymap("n", "]d", vim.diagnostic.goto_next, opts)
    end

    -- TypeScript/JavaScript LSP - Optimized for NX monorepos
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- Critical: Proper root directory detection for NX
      root_dir = util.root_pattern(
        "nx.json",              -- NX workspace root (highest priority)
        "tsconfig.json",        -- TypeScript project
        "tsconfig.app.json",    -- Angular app
        "tsconfig.lib.json",    -- Angular library  
        "project.json",         -- NX project config
        "package.json",         -- npm project
        ".git"                  -- Fallback
      ),
      init_options = {
        preferences = {
          -- Performance improvements
          disableSuggestions = false,
          quotePreference = "auto",
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          includeCompletionsWithSnippetText = true,
          includeAutomaticOptionalChainCompletions = true,
          includeCompletionsWithClassMemberSnippets = true,
          includeCompletionsWithObjectLiteralMethodSnippets = true,
        }
      },
      settings = {
        typescript = {
          suggest = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
          },
          preferences = {
            importModuleSpecifier = "relative",
            includePackageJsonAutoImports = "auto",
          },
          inlayHints = {
            -- Disable all inlay hints
            includeInlayParameterNameHints = "none",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          },
        },
        javascript = {
          suggest = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
          },
        }
      },
      filetypes = { 
        "javascript", 
        "javascriptreact", 
        "typescript", 
        "typescriptreact" 
      },
    })

    -- Angular Language Service
    lspconfig.angularls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = util.root_pattern("angular.json", "project.json"),
      filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
    })

    -- ESLint LSP (for code actions, not diagnostics - nvim-lint handles that)
    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        
        -- Auto-fix on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      root_dir = util.root_pattern(
        ".eslintrc",
        ".eslintrc.json",
        ".eslintrc.js",
        ".eslintrc.cjs",
        "eslint.config.js",
        "eslint.config.cjs",
        "package.json"
      ),
      -- Only provide code actions, not diagnostics
      settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine"
          },
          showDocumentation = {
            enable = true
          }
        },
        codeActionOnSave = {
          enable = false,
          mode = "all"
        },
        experimental = {
          useFlatConfig = false
        },
        format = false,
        nodePath = "",
        onIgnoredFiles = "off",
        packageManager = "npm",
        problems = {
          shortenToSingleLine = false
        },
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
          mode = "location"
        }
      }
    })

    -- JSON LSP with schema support
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        }
      }
    })

    -- HTML LSP
    lspconfig.html.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "htmlangular" },
    })

    -- CSS LSP
    lspconfig.cssls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Lua LSP for Neovim configuration
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT"
          },
          diagnostics = {
            globals = { "vim" }
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false
          },
        }
      }
    })

    -- NX LSP for NX-specific features
    lspconfig.nxls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Global LSP settings for better performance
    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      virtual_text = {
        spacing = 2,
        severity = { min = vim.diagnostic.severity.WARN }
      },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      signs = true,
      underline = true,
    })

    -- Update Neovim's path for NX monorepo
    vim.opt.path:append({ "apps/**", "libs/**", "node_modules", "." })

    -- Global keymaps
    vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

    -- Useful commands
    vim.api.nvim_create_user_command("ToggleInlayHints", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints" })

    vim.api.nvim_create_user_command("LspRestart", function()
      vim.cmd("LspStop")
      vim.defer_fn(function()
        vim.cmd("LspStart")
      end, 500)
    end, { desc = "Restart LSP servers" })
  end,
}
