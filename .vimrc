" @file vimrc
" @brief    Slow down your step, and catch up with others.
" @author unlessbamboo
" @version 1.0
" @date 2015-03-03

" Set mapleader
let mapleader = ","


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


" 自动检测文件类型，见印象笔记中说明
filetype plugin indent on
syntax on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-json，对json文件进行语法高亮
"      json format and check
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
map  <leader>json :%!python -m json.tool<cr>
vnoremap <leader>json :'<,'>!python -m json.tool<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-instant-markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:instant_markdown_slow=1
" 关闭自动开启浏览器的配置，使用命令:InstantMarkdownPreview
let g:instant_markdown_autostart=0
" 映射快捷键
map  <leader>imp :InstantMarkdownPreview<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To enable conceal use Vim's standard conceal configuration
" 此时文档中看不到```vim配置信息
set conceallevel=2
" Allow for the TOC window to auto-fix
let g:vim_markdown_toc_autofit = 1
" Folding level
let g:vim_markdown_folding_level = 6
" fold style
" let g:vim_markdown_folding_style_pythonic = 1
" Heder level handle
" :HeaderDecrease, :HeaderIncrease
" TOC
map  <leader>toc :Toc<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bash support 支持设置
"       1,函数注释快捷键：\cfu
"       PS:更加详细的信息请见《印象笔记-vim-插件》笔记
"           或帮助手册
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:BASH_AuthorName   = 'bamboo'
let g:BASH_Email        = 'unlessbamboo@gmail.com'
let g:BASH_Company      = 'BigUniverse'


""""""""""""""""""""""""""""""""""""""" 
"---->>>>正常的基础命令
""""""""""""""""""""""""""""""""""""""" 
" 语法高亮
syntax enable
" 高亮命中的文本或者set nohlsearch
set hlsearch
" 临时取消高亮F3显示的开关按钮
noremap  <leader>hl :nohlsearch<Bar>:echo<CR>
"突出高亮显示当前行
set cursorline
" 插入时间, 使用UTC时间来表示
nnoremap <leader>date "=strftime("%Y-%m-%d")<CR>p
nnoremap <leader>time "=strftime("%Y-%m-%d %T")<CR>p

" 设置黑色背景，保证告警文本的效果能够更加显著
set background=dark
" 显示行号
set nu
" 设置状态行
set laststatus=2
"显示当前行号和列号
set ruler
"在状态栏显示正在输入的命令
set showcmd
" 搜索时忽略大小写
set ignorecase
" 随着键入即时搜索
set incsearch
" 设置字体和字号
set guifont=Monaco:h20
" 鼠标设置
set mouse=a
" noremap  <F4> :let &mouse = (&mouse == 'a' ? 'v' : 'a')<CR>
" paste设置，不适用F7，而是采用,+p
set pastetoggle=<leader>+p
" 保存所有文件
nmap <leader>wa :wa<cr>
" 仅仅在下拉菜单中显示匹配项目，自动插入所有匹配项目的相同文本
set completeopt=longest,menu
set nocompatible

" 映射文件移动命令
nmap <leader>mo3 30%
nmap <leader>mo5 50%
nmap <leader>mo8 80%


""""""""""""""""""""""""""""""""""""""""""""""
" ---> 折叠配置
""""""""""""""""""""""""""""""""""""""""""""""
" 基于缩进的代码折叠
set foldmethod=indent
" 基于语法的代码折叠
" set foldmethod=syntax
" 启动时开启或者关闭折叠
" set foldenable
set nofoldenable
set foldlevelstart=99
" 映射(使用空格键进行反复操作)
nnoremap <space> za
vnoremap <space> zf

""""""""""""""""""""""""""""""""""""""" 
"--->>>寄存器
"   vim-repeat: 重复第三方插件的宏命令
""""""""""""""""""""""""""""""""""""""" 
" 宏快捷键：@a寄存器变为<leader>h寄存器
nmap <leader>h @

""""""""""""""""""""""""""""""""""""""" 
"--->>>vimrc的重载
""""""""""""""""""""""""""""""""""""""" 
" Fast reloading of the .vimrc
map  <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map  <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

""""""""""""""""""""""""""""""""""""""" 
"--->>>制表符(tabstop)的操作：
""""""""""""""""""""""""""""""""""""""" 
" ai:自动缩进，ci:类似c语言的缩进，si：基于autoindent的smart缩进
set autoindent
" 左缩进
set shiftwidth=4
" 制表符位数
set tabstop=4
" 制表位转为空格
set expandtab
"	backspace设置
"		eol 	插入模式下输入backspace合并两行
"		start	删除此时插入前的操作
set backspace=indent,eol,start
"	whichwrap行间移动
"		b	backspace是否需能够回退到上一行
"		s	spcace是够能够继续到下一行
set whichwrap=b,s,<,>

""""""""""""""""""""""""""""""""""""""" 
"---->>>>Tmux
"       PS:放在最末尾
""""""""""""""""""""""""""""""""""""""" 
" 设置终端支持的颜色是256颜色
set t_Co=256
" tmux设置
if exists('$TMUX')
    set term=screen-256color
endif


"""""""""""""""""""""""""""""""""""""""
" --->>>crontab设置
"""""""""""""""""""""""""""""""""""""""
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif


"""""""""""""""""""""""""""""""""""""""
" --->>>窗口切割映射键和跳转快捷键
"""""""""""""""""""""""""""""""""""""""
" 切割
nmap <leader>vs :vs<cr>
nmap <leader>sp :sp<cr>
" 左边窗口，请熟练使用，确保不适用<c-w>按钮
nmap <leader>hw <C-w>h
" 右边窗口
nmap <leader>lw <C-w>l
" 上边窗口
nmap <leader>kw <C-w>k
" 下边窗口
nmap <leader>jw <C-w>j
" 移动窗口，左右移动
nmap <leader>rw <C-w><C-r>

" 所有窗口登高等宽
nmap <leader>=w <C-w>=
" 高度-N 
nmap <leader>s_ :resize -20<CR>
nmap <leader>s+ :resize +20<CR>
" 宽度
nmap <leader>v_ :vertical resize -20<CR>
nmap <leader>v+ :vertical resize +20<CR>

"""""""""""""""""""""""""""""""""""""""
"  --->>> session的保存和读取
"""""""""""""""""""""""""""""""""""""""
" 不在session文件中保存当前路径
set sessionoptions-=curdir
set sessionoptions+=sesdir
" 保存/读取session和viminfo
map  <leader>wsv :mksession!<cr> :wviminfo vim.viminfo<cr>
map  <leader>rsv :source ./Session.vim<cr> :rviminfo vim.viminfo<cr>


"""""""""""""""""""""""""""""""""""""""
"  --->>> html设置, 确保放在基本配置的后面, 避免被覆盖
"""""""""""""""""""""""""""""""""""""""
nmap  <leader>hml :!open % <CR>
" html文件采用4个空格缩进方式, 保持同.editorconfig同步
autocmd FileType html setlocal ts=4 sts=4 sw=4
autocmd FileType htmldjango setlocal ts=4 sts=4 sw=4
autocmd FileType css setlocal ts=2 sts=2 sw=2
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
autocmd FileType javascript setlocal ts=2 sts=2 sw=2


"""""""""""""""""""""""""""""""""""""""
"  --->>> xml
"""""""""""""""""""""""""""""""""""""""
" 使用xmllint对选择的文本自动进行xml, 之后执行==G就能格式化
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null


""""""""""""""""""""""""""""""""""""""""""""""
" ---> 大文件
""""""""""""""""""""""""""""""""""""""""""""""
" Protect large files from sources and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowrite (file is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 10
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile 
                \| set eventignore+=FileType 
                \| setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1
                \| else | set eventignore-=FileType | endif
  augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""
" wsl编码错误问题
""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1


""""""""""""""""""""""""""""""""""""""""""""""
" --->>> bamboo.vim的配置(建议放在最后)
"           1，设置tags的加载，不同的语言加载不同的tags
"           2，设置path(一般仅仅用于C语言)
"                   用于gf命令，快速调到指定的文件，当然文件必须
"                   在path搜索目录中:
"                     跳过去:gf(光标下的文件名)或者find + 文件名
"                     跳回来：<C-^>
"           3，现在一般用LookupFile来代替find命令，见上面的说明
"       
""""""""""""""""""""""""""""""""""""""""""""""
" 添加自定义的库文件位置, 注意, 如果需要调试直接echo即可,
" 每次wq都会重新加载vimrc文件, 会自动打印输出信息
" let $PYTHONPATH='/Users/bamboo/Public/iLifeDiary/iLifeDiary/:/Users/zhengbifeng/Public/iLifeDiary/iLifeDiary'
set verbosefile="~/.vim/vim.log"
if filereadable("bamboo.vim")
    source bamboo.vim
else
    if filereadable(expand("~/.vim/bamboo.vim"))
        source ~/.vim/bamboo.vim
    endif
endif
" 文件缓冲区, 注意, 这些模块配置只能放到plugin目录下
source ~/.vim/plugin/filebuff.vim
" 插件配置集合
try
    source ~/.vim/plugin/plugins.vim
catch
    echo "导入plugins插件配置异常"
endtry
" 版本控制模块
source ~/.vim/plugin/vcs.vim
" 老的弃用插件集合
if filereadable(expand("~/.vim/vim/old.vim"))
    source ~/.vim/plugin/old.vim
endif
" 配色模块
source ~/.vim/plugin/colors.vim
