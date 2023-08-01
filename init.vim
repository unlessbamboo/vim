" 1. 原有vim配置
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" 2. 包管理(仅仅是nvim)
call plug#begin()

" 窗口管理
Plug 'vim-scripts/winmanager'
" bash支持
Plug 'vim-scripts/bash-support.vim'
" 通用工具
Plug 'vim-scripts/genutils'
" 浏览项目和树形插件
Plug 'scrooloose/nerdtree'
" 探索和切换缓冲区的插件
Plug 'jlanzarotta/bufexplorer'
" Vim 中文文档插件
Plug 'yianwillis/vimcdoc'
"  Vim 的 Git 插件
Plug 'tpope/vim-fugitive'

" 代码片段
Plug 'SirVer/ultisnips'
" 代码格式化(保存的时候自动格式化等)
Plug 'sbdchd/neoformat'
" 搜索: 强大的模糊搜索功能
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
Plug 'psf/black', { 'branch': 'stable' }

" python
Plug 'Vimjas/vim-python-pep8-indent'
" 使用coc-jedi替代, 仅仅适用于neovim
" Plug 'davidhalter/jedi-vim'

" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" lsp: 若要临时禁用某个插件: Plug 'neoclide/coc.nvim', {'on': []}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 代码注释, 注意, nvim-treesitter必须放在coc.nvim的后面, 否则会被覆盖掉的
" Plug 'scrooloose/nerdcommenter'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" 注意, comment.nvim依赖上面的语言解析器
Plug 'numToStr/Comment.nvim'


call plug#end()

" 导入vim中的老配置 
source ~/.vim/plugin/entrypoint.vim
" 引用lua根文件
lua require("bamboo")
