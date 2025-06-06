return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  opts_extend = { "ensure_installed" },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    highlight = { 
      enable = true,
      -- Disable for large files for performance
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- Additional language injections for Angular
      additional_vim_regex_highlighting = false,
    },
    indent = { 
      enable = true,
      -- Disable indent for problematic languages
      disable = { "python", "yaml" },
    },
    ensure_installed = {
      -- Core languages
      "bash",
      "c",
      "diff",
      "lua",
      "luadoc",
      "luap",
      "vim",
      "vimdoc",
      "query",
      "regex",
      
      -- Web development
      "html",
      "css",
      "scss",
      "javascript",
      "typescript",
      "tsx",
      "jsdoc",
      "json",
      "jsonc",
      "xml",
      
      -- Angular/template specific
      "angular",      -- Angular templates (if available)
      "embedded_template", -- For mixed content
      
      -- Documentation and config
      "markdown",
      "markdown_inline",
      "yaml",
      "toml",
      "printf",
      
      -- Additional useful parsers
      "python",
      "gitignore",
      "gitcommit",
      "dockerfile",
    },
    
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    
    -- Text objects for better navigation
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
    },
  },
  
  ---@param opts TSConfig
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    
    -- Custom file type associations for Angular
    vim.treesitter.language.register("html", "htmlangular")
    
    -- Set up Angular template file type detection
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.component.html", "*.template.html" },
      callback = function()
        vim.bo.filetype = "htmlangular"
      end,
    })
    
    -- Custom injections for Angular templates
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "html", "htmlangular" },
      callback = function()
        -- Enable TypeScript highlighting in Angular expressions
        vim.treesitter.start(nil, "typescript")
      end,
    })
    
    -- Fix for mixed content highlighting
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    
    -- Configure HTML parser for Angular syntax
    if parser_config.html then
      parser_config.html.injections = {
        -- TypeScript in Angular expressions
        javascript = {
          -- Match content within {{ }}
          "((interpolation) @injection.content (#set! injection.language \"typescript\"))",
          -- Match content within attribute bindings [attr]="..."
          "((attribute_value) @injection.content (#match? @injection.content \"^\\\".*\\\"$\") (#set! injection.language \"typescript\"))",
        },
      }
    end
  end,
}
