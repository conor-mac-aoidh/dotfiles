"call plug#begin()
"" UI
""Plug 'ctrlpvim/ctrlp.vim'
"Plug 'ku1ik/vim-monokai'
"Plug 'patstockwell/vim-monokai-tasty'
"Plug 'itchyny/lightline.vim'
"Plug 'airblade/vim-gitgutter'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'
"Plug 'stevearc/oil.nvim'
"" Syntax
""Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
""Plug 'nvim-treesitter/nvim-treesitter-textobjects'
"" Validation/Completion
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"" Session
"Plug 'rmagatti/auto-session'
"" Misc
"Plug 'norcalli/nvim-colorizer.lua'
"Plug 'backdround/global-note.nvim'
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
"Plug 'nvim-tree/nvim-web-devicons'
"Plug 'sindrets/diffview.nvim'
"Plug 'Equilibris/nx.nvim'

"call plug#end()

source ~/.config/nvim/basic.vim

let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-css',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-angular',
  \ 'coc-yaml',
  \ 'coc-tabnine'
  \ ]

lua require("config.lazy")


"source ~/.config/nvim/plugins_config.vim
"lua require('plugins_config')
