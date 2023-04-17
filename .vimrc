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

" genutils: 通用的 Vim 工具函数库, 提供了许多常用的 Vim 脚本函数
Plug 'vim-scripts/genutils'
" taglist: 允许用户在一个侧边栏中查看当前文件的函数(弃用, 平常根本用不到)
" Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/winmanager'
Plug 'vim-scripts/bash-support.vim'
" lookupfile: 用于在 vim 中快速查找文件的插件, 被fzf替代(弃用)
" Plug 'vim-scripts/lookupfile'
Plug 'scrooloose/nerdtree'
Plug 'jlanzarotta/bufexplorer'
" 快速访问vim文档, 自动更新和下载vim文档
Plug 'yianwillis/vimcdoc'
" git
Plug 'tpope/vim-fugitive'

" 代码注释
Plug 'scrooloose/nerdcommenter'
" 代码片段
Plug 'SirVer/ultisnips'
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
Plug 'maksimr/vim-jsbeautify'
Plug 'mattn/emmet-vim'

" 代码检查
Plug 'w0rp/ale'

" python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'davidhalter/jedi-vim'

call plug#end()


source ~/.vim/plugin/entrypoint.vim
