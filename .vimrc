" @file vimrc
" @brief    Slow down your step, and catch up with others.
" @author unlessbamboo
" @version 1.0
" @date 2015-03-03

" Set mapleader
let mapleader = ","


""""""""""""""""""""""""""""""""""""""" 
"---->>>>vim-pathogen管理插件
""""""""""""""""""""""""""""""""""""""" 
runtime bundle/vim-pathogen/autoload/pathogen.vim
" 首先关闭文件检测
filetype off

" vim插件的存放位置，默认为.vim/bundle，可以不设置该项
execute pathogen#infect()
" 执行pathogen，虽然通过git来安装，但是还是需要pathogen管理
call pathogen#infect()
" 生成各个插件的文档(很重要)
call pathogen#helptags()

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
" docstring的配置参数: 自动插入docstring字符串
" update: 2022-11-11: 升级docstring为2.0, 依赖doq, 需要在docstring项目根目录下执行: make install
""""""""""""""""""""""""""""""""""""""" 
" 设置拓展
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"nmap  <C-_> <Plug>(pydocstring)
nmap  <leader>py :Pydocstring<cr>
" 忽略__init__
let g:pydocstring_ignore_init = 1
" 支持: numpy, sphinx, google
let g:pydocstring_formatter = 'sphinx'
" 自定义模板
" let g:pydocstring_templates_path = '/path/to/custom/templates'


""""""""""""""""""""""""文件缓冲区窗口模块""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""" 
" ---> 文件缓冲区窗口插件1——BufExplorer
""""""""""""""""""""""""""""""""""""""" 
" Do not show default help.
let g:bufExplorerDefaultHelp=0       
" Show relative paths.
let g:bufExplorerShowRelativePath=1  
" Sort by most recently used.
let g:bufExplorerSortBy='mru'        
" Split left.
let g:bufExplorerSplitRight=0        
" Split vertically.
let g:bufExplorerSplitVertical=1     
" Split width
let g:bufExplorerSplitVertSize = 30  
" Open in new window.
let g:bufExplorerUseCurrentWindow=1  
autocmd BufWinEnter \[Buf\ List\] setl nonumber

""""""""""""""""""""""""""""""""""""""""""""""
" ---> 文件缓冲区窗口插件2
"       winmanager的配置： 界面分隔,是否自动打开winmanager，
"                       设置winmanger高度
""""""""""""""""""""""""""""""""""""""""""""""
" 设置显示方式或者界面分隔，左上角BE/FE共用一个窗口，右下角为taglist
" 其中左上角BufExporer和FP的切换使用Ctrl + N
let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:defaultExplorer = 0
" 自动打开winmanager
let g:AutoOpenWinManager=0
" 设置宽度
let g:winMaagerWidth=30
" goto first explorer window
map  <leader>ff :FirstExplorerWindow<cr>
" goto bottom explorer window
map  <leader>bb :BottomExplorerWindow<cr>
" reload
nmap  <F6> :WMToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 文件缓冲区窗口插件-3-nerdtree 配置
"           显示当前目录下的树形目录树，有时候有用
"      PS: 建议结合lookupfile来使用
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 是否在vim启动的时候默认开启NERDTree
" autocmd VimEnter * NERDTree
" 窗口显示的位置，默认为左边
" let NERDTreeWinPos='right'
" 是否自动显示BookMarks
let NERDTreeShowBookmarks=1
" nerdtree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1
let NERDTreeWinSize = 25
" exclude some files
let NERDTreeIgnore = ['\.pyc$', 'log?', 'cscope.*', 'tags', 
            \ 'media', 'doc']
" 启动或者隐藏NERDTree
nmap  <F2> :NERDTreeToggle<cr>
" 刷新目录树
nmap  <F3> :NERDTree<cr>


""""""""""""""""""""""""""""""""""""""""
" ---> 文件缓冲区窗口插件-4-lookupfile配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" 可执行文件：
"   <https://github.com/unlessbamboo/grocery-shop/blob/master/bamboo/shell/filenametags>
nmap  <leader>ft :!bash 
            \ /home/bamboo/.local/bin/filenametags
            \<cr>:source ~/.vimrc<cr>
" 加载指定的tags文件，而不是默认的tags文件，增加查找性能
if filereadable("./filenametags")
    let g:LookupFile_TagExpr = '"./filenametags"'
endif
" 最少输入字符位数才开始查找匹配
let g:LookupFile_MinPatLength = 3
" 不保存上次查找的字符串
let g:LookupFile_PreserveLastPattern = 0
" 保存查找历史
let g:LookupFile_PreservePatternHistory = 1 
" 回车打开第一个匹配项目
let g:LookupFile_AlwaysAcceptFirst = 1
" 不允许创建不存在的文件
let g:LookupFile_AllowNewFiles = 0
" F5的功能，查找文件，映射LookupFile为,lk
nmap  <leader>luk :LUTags<cr>
" 浏览缓冲区，列出缓冲区中所有文件，映射LUBufs为ll
nmap  <leader>lul :LUBufs<cr>
" 浏览目录，查看该目录下所有文件，映射LUWalk为lw
nmap  <leader>luw :LUWalk<cr>
" 默认设置忽略大小写查找, 重写该函数
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'


""""""""""""""""""""""""""""""""""""""" 
" ---> 文件基本操作
""""""""""""""""""""""""""""""""""""""" 
" 1 重命名文件，使用插件rename，该方法有很多缺陷
" saveas <new file> : will move a file from its location to CWD.
" 2 使用Explore, 之后使用 R-- 重命名, D--删除文件
noremap  <leader>sa :Explore<CR>
" 3 复制当前文件名到剪贴板(cs-copy filename, cp-copy file path)
"   关于expand, 见印象笔记
noremap  <leader>cf :let @+=expand("%")<CR>
noremap  <leader>cp :let @+=expand("%:p")<CR>
noremap  <leader>ct :let @+=expand("%:t")<CR>

" set dockerfile if find *Dockerfile
autocmd BufNewFile,BufRead *Dockerfile set filetype=dockerfile



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


"""""""""""""""""""""""""""""""""""""""
"  --->>> Emmet-vim
" emmet快捷输入方式:
"   输入某些命令(input模式) + ctrl_y + ,
"""""""""""""""""""""""""""""""""""""""
" html基本框架
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif
" HTML注释
autocmd filetype *html* imap <c-_> <c-y>/
autocmd filetype *html* map <c-_> <c-y>/


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
" 插件配置集合
if filereadable(expand("~/.vim/plugin/plugins.vim"))
    source ~/.vim/plugin/plugins.vim
endif
" 配色模块
if filereadable(expand("~/.vim/plugin/colors.vim"))
    source ~/.vim/plugin/colors.vim
endif
" 版本控制模块
if filereadable(expand("~/.vim/plugin/vcs.vim"))
    source ~/.vim/plugin/vcs.vim
endif
" 老的弃用插件集合
if filereadable(expand("~/.vim/plugin/old.vim"))
    source ~/.vim/plugin/old.vim
endif
