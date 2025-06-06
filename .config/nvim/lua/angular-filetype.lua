-- Angular file type detection and configuration
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.component.html",
    "*.template.html",
  },
  callback = function()
    vim.bo.filetype = "htmlangular"
    vim.bo.commentstring = "<!-- %s -->"
  end,
})

-- Set Angular TypeScript files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.component.ts",
    "*.service.ts",
    "*.directive.ts",
    "*.pipe.ts",
    "*.guard.ts",
    "*.resolver.ts",
  },
  callback = function()
    vim.bo.filetype = "typescript"
  end,
})

-- Better Angular template highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "htmlangular", "html" },
  callback = function()
    -- Improve syntax highlighting for Angular templates
    vim.opt_local.iskeyword:append("-")
    vim.opt_local.iskeyword:append(":")
    vim.opt_local.iskeyword:append("@")
    
    -- Set up custom syntax highlighting
    vim.cmd([[
      syntax match angularDirective /@\w\+/ contained
      syntax match angularBinding /\[\w\+\]/ contained
      syntax match angularEvent /(\w\+)/ contained
      syntax match angularInterpolation /{{.\{-}}}/ contained
      
      highlight link angularDirective Keyword
      highlight link angularBinding Special
      highlight link angularEvent Function
      highlight link angularInterpolation String
    ]])
  end,
})
