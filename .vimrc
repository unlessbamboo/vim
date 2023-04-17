" @file vimrc
" @brief    Slow down your step, and catch up with others.
" @author unlessbamboo
" @version 1.0
" @date 2015-03-03


" 2. 包管理工具: vim-plug, 命令
"   PlugInstall 安装插件
"   PlugUpdate  更新插件
"   PlugClean   删除插件(需要重新加载vimrc配置文件)
"   PlugStatus  插件状态
"   PlugUpgrade 升级插件
call plug#begin()

Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/winmanager'
Plug 'vim-scripts/bash-support.vim'
Plug 'vim-scripts/lookupfile'
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

" 其他
Plug 'cespare/vim-toml'
Plug 'powerline/powerline'
Plug 'plasticboy/vim-markdown'

" HTML, CSS, JS
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
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


source ~/.vim/plugin/entrypoint.vim
