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
" 代码注释
Plug 'scrooloose/nerdcommenter'
" 搜索
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 颜色
Plug 'chrisbra/Colorizer'
Plug 'altercation/vim-colors-solarized'
Plug 'powerline/powerline'

" 其他
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'

" HTML, CSS, JS
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'ternjs/tern_for_vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'mattn/emmet-vim'

" 代码检查
Plug 'w0rp/ale'
" 若要临时禁用某个插件: Plug 'neoclide/coc.nvim', {'on': []}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'davidhalter/jedi-vim'

call plug#end()

" 3. 导入vim中的老配置 
source ~/.vim/plugin/entrypoint.vim

" 3. 引用lua根文件
lua require("bamboo")
