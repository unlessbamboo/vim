" 1. 原有vim配置
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" 2. 包管理(仅仅是nvim)
call plug#begin()

Plug 'vim-scripts/winmanager'
Plug 'vim-scripts/bash-support.vim'
Plug 'vim-scripts/genutils'
Plug 'scrooloose/nerdtree'
Plug 'jlanzarotta/bufexplorer'
Plug 'yianwillis/vimcdoc'
Plug 'tpope/vim-fugitive'
" 代码注释
" Plug 'scrooloose/nerdcommenter'
Plug 'numToStr/Comment.nvim'

" 代码片段
Plug 'SirVer/ultisnips'
" 代码格式化
Plug 'sbdchd/neoformat'
" 搜索
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 颜色
" Plug 'chrisbra/Colorizer'
" Plug 'altercation/vim-colors-solarized'
" Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'powerline/powerline'

" 其他
Plug 'cespare/vim-toml'
Plug 'kevinoid/vim-jsonc'
" Plug 'plasticboy/vim-markdown'

" nvim专用-代码补全(被coc.nvim替代了, 见readme.md说明)
" Plug 'neovim/nvim-lspconfig'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-cmdline'
" Plug 'hrsh7th/nvim-cmp'

" HTML, CSS, JS
Plug 'mattn/emmet-vim'

" 代码检查
Plug 'w0rp/ale'

" python
Plug 'Vimjas/vim-python-pep8-indent'
" 使用coc-jedi替代, 仅仅适用于neovim
" Plug 'davidhalter/jedi-vim'

" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" lsp: 若要临时禁用某个插件: Plug 'neoclide/coc.nvim', {'on': []}
Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()

" 导入vim中的老配置 
source ~/.vim/plugin/entrypoint.vim
" 引用lua根文件
lua require("bamboo")
