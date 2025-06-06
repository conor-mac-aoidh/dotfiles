-- Modern completion with nvim-cmp
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
    "hrsh7th/cmp-buffer",       -- Buffer completion source
    "hrsh7th/cmp-path",         -- Path completion source
    "hrsh7th/cmp-cmdline",      -- Command line completion
    "L3MON4D3/LuaSnip",        -- Snippet engine
    "saadparwaiz1/cmp_luasnip", -- Snippet completion source
    "rafamadriz/friendly-snippets", -- Snippet collection
    "onsails/lspkind.nvim",     -- LSP completion icons
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      
      -- Performance optimizations
      performance = {
        debounce = 60,              -- Delay before triggering completion
        throttle = 30,              -- Delay between completion requests
        fetching_timeout = 500,     -- Timeout for completion fetching
        confirm_resolve_timeout = 80, -- Timeout for resolving completion
        async_budget = 1,           -- Time budget for async operations
        max_view_entries = 200,     -- Maximum entries to show
      },

      completion = {
        completeopt = "menu,menuone,noinsert",
      },

      sources = cmp.config.sources({
        { 
          name = "nvim_lsp", 
          priority = 1000,
          -- Filter out snippets from LSP (use dedicated snippet source)
          entry_filter = function(entry, ctx)
            return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
          end,
        },
        { 
          name = "luasnip", 
          priority = 750 
        },
        { 
          name = "buffer", 
          priority = 500,
          keyword_length = 3,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        },
        { 
          name = "path", 
          priority = 250 
        },
      }),

      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        
        -- Tab completion with snippet expansion
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ 
          select = true,
          behavior = cmp.ConfirmBehavior.Replace 
        }),
      }),

      -- Better UI
      window = {
        completion = cmp.config.window.bordered({
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        }),
      },

      -- Formatting with icons
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
          before = function(entry, vim_item)
            -- Source names for context
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        }),
      },

      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },

      -- Sorting for better completion order
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })

    -- Command line completion for search
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })

    -- Command line completion for commands
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        { 
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" }
          }
        }
      })
    })

    -- Custom highlight for ghost text
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  end,
}
