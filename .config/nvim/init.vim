call plug#begin()
" UI
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'ku1ik/vim-monokai'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'stevearc/oil.nvim'
" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" Validation/Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Misc
Plug 'norcalli/nvim-colorizer.lua'
Plug 'backdround/global-note.nvim'

call plug#end()

let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-css',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-angular',
  \ ]

source ~/.config/nvim/basic.vim
source ~/.config/nvim/plugins_config.vim
lua require('plugins_config')
