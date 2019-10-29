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
" ---> vim-ag，内容搜索，替代ack.vim
"       requirement：安装the_silver_searcher工具
"                   例如，ag -i 'pattern' path
"       格式：
"           Ag [options] {pattern} [{directory}]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自定义Ag路径
"let g:ag_prg="<...> --vimgrep"
" 查找，从项目根目录开始
let g:ag_working_path_mode="r"
" 执行路径
set runtimepath^=~/.vim/bundle/ag.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-json，对json文件进行语法高亮
"      json format and check
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
map  <leader>json :%!python -m json.tool<cr>
vnoremap <leader>json :'<,'>!python -m json.tool<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> jsbeautify: 对css,javascript, html进行格式化
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:editorconfig_Beautifier = '~/.vim/.editorconfig'
map <c-f> :call JsBeautify()<cr>
" 映射(可以配置vnormap)
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
" 自动格式化, 关闭自动格式化(会导致其他问题)
" autocmd FileType javascript :call JsBeautify()
" autocmd FileType json :call JsonBeautify()
" autocmd FileType jsx :call JsxBeautify()
" autocmd FileType html :call HtmlBeautify()
" autocmd FileType css :call CSSBeautify()



"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> filetype
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set dockerfile if find *Dockerfile
autocmd BufNewFile,BufRead *Dockerfile set filetype=dockerfile


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
" disable the folding configuration: set foldenable
" let g:vim_markdown_folding_disabled = 1
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
" docstring的配置参数
"               自动插入docstring字符串
""""""""""""""""""""""""""""""""""""""" 
" 设置拓展
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"nmap  <C-_> <Plug>(pydocstring)
nmap  <leader>py :Pydocstring<cr>



"=======================版本控制=========================
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 版本控制-1-vim-signify
"           用于所有的版本控制
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 没有特别的配置

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 版本控制-2-vim-gitgutter
"           用于git，功能待挖掘
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 关闭或者启动gitgutter，默认开启
map  <leader>gg :GitGutterToggle<cr>
" 关闭或者启动gitgutter signs，默认开启
map  <leader>gs :GitGutterSignsToggle<cr>
" 关闭或者启动高亮，默认开启
map  <leader>gh :GitGutterLineHighlightsToggle<cr>
" 设置文件发生更改后出现提示的延时时间（定时器）,默认为4s，设置为250ms
set updatetime=250
" To keep your Vim snappy（短小精悍），最大更改为500，默认值
let g:gitgutter_max_signs = 500

" 跳到下一个或者上一个hunk
nmap  <leader>nh <Plug>GitGutterNextHunk
nmap  <leader>ph <Plug>GitGutterPrevHunk
" stage或者undo hunk，取消修改
"   <leader>hs
"   <leader>hu
" 其他命令，哎，git




""""""""""""""""""""""""""""""""""""""" 
" --->>> YCM configure
"
""""""""""""""""""""""""""""""""""""""" 
" 设置python或者python3
let g:ycm_python_binary_path="python"
let g:ycm_complete_in_strings = 2
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_key_invoke_completion = ''
nnoremap <leader>jd :YcmCompleter GoTo<cr>

" java eclim
let g:EclimCompletionMethod = 'omnifunc'


""""""""""""""""""""""""""""""""""""""" 
" --->语法检查，syntastic的配置参数
"       获取错误信息：Errors或者lopen
"       错误间跳转：lne或者lp
"     PS:关于c/c++/python等配置见印象笔记或者github wiki、帮助文档
"       每一个目录都有一份独有的bamboo.vim配置当前项目的语言配置
"   
""""""""""""""""""""""""""""""""""""""" 
" 错误标注（和SyntasticStatuslineFlag()配合）
" let g:syntastic_error_symbol = 'EE'
" let g:syntastic_style_error_symbol = 'E>'
" let g:syntastic_warning_symbol = 'WW'
" let g:syntastic_style_warning_symbol = 'W>'

" 0不自动. 1自动拉起关闭. 2 自动关闭. 3 自动拉起 默认2, 建议为1
" 设置为1，会影响其他插件，抛出E924(help E924)错误，使用lopen来开启错误信息
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0

" pylint, flake8, shellcheckers
" let g:syntastic_python_checkers=['flake8', 'pylint']
" let g:syntastic_python_pylint_args='--rcfile=~/.vim/.pylintrc'
" let g:syntastic_sh_checkers=['shellcheckers']

" HTML
" let g:syntastic_html_tidy_ignore_errors = [
"            \ '<span> proprietary attribute'
"            \]

" 错误跳转
" noremap <leader>le :Errors<CR>
" noremap  <F4> :let g:syntastic_auto_loc_list = (
"             \g:syntastic_auto_loc_list == '0' ? '1' : '0')<CR>
" syntastic过慢导致的问题（需要按两次才能取消哦，注意大写的E）
" 关闭html错误检查
" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': ['html'] }
" nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>



"""""""""""""""""""""""""""""""""""""""
" 插件: ale
" 功能: 异步代码检查插件
"""""""""""""""""""""""""""""""""""""""
" 控制错误输出格式, 通过这个 linter找到确切的忽略错误的方式
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%...code...%: [%linter%] %%s [%severity%]'
" use quickfix list instead of the loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0

" help ale-python 信息
" 指定pylintrc位置
let g:ale_python_pylint_options = '--rcfile ~/.vim/.pylintrc'
" 启用virtualenv
let g:ale_python_pylint_use_global = 0
" tidy
let g:ale_html_tidy_options = '-q -e -language en -config ~/.vim/.tidy.conf'
" 禁用某些插件, 目前只能使用白名单(ale_linters, ale_linters_explicit)

" 错误移动
noremap <leader>ef :ALEFirst<CR>
noremap <leader>en :ALENext<CR>
noremap <leader>el :ALELast<CR>
noremap <leader>ep :ALEPrevious<CR>
" 关闭自动打开错误quickfix
" noremap <leader>ec :call BambooDisableAleQuickfix() <CR>
" function BambooDisableAleQuickfix()
"     let g:ale_set_quickfix = 0
"     let g:ale_open_list = 0
" endfunc



""""""""""""""""""""""""""""""""""""""" 
" 插件：Vimjas/vim-python-pep8-indent
" 功能：基于pep8的自动缩进设置，非常棒
""""""""""""""""""""""""""""""""""""""" 
" flake8, .vim/.flake8，并创建软连接:ln -sf ~/.vim/.flake8 ~/.config/flake8
" 自定义配置, 见github以及印象笔记
" let g:flake8_ignore = 'E701, E301'

" pylint, 创建~/.vim/.pylintrc, 并通过pylint_options指定, 文件名可以任意取值



""""""""""""""""""""""""""""""""""""""" 
" vim-surround配置
"       见help surround
"       主页: https://github.com/tpope/vim-surround
" 单引号/双引号/标签的快速操作
""""""""""""""""""""""""""""""""""""""" 
" 没有特殊的配置，不要文档中的custom configure


"""""""""""""""""""""""""""""""""""""""注释模块"""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""
" --->> 注释模块1——nerdcommenter
"""""""""""""""""""""""""""""""""""""""
" for c++ style, change the '@' to '\'
" Add space delims when comment
let g:NERDSpaceDelims=1
" User compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs=1
" Align line-wise comment delimiters flush left instead of 
" following code indentation
" 终于找到这个了，还是得看官网---2016年 08月 15日 星期一 10:09:31 CST
let g:NERDDefaultAlign='left'
" set a language to use its alternate delimiters by default
let g:NERDAltDelims_java=1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters={ 'c': { 'left': '/**', 'right':'*/'} }
" 注释空行
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1




""""""""""""""""""""""""""""""""""标签模块"""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置1——tags的配置
""""""""""""""""""""""""""""""""""""""""""""""
" 生成tags的命令
map <F8> :!ctags
            \ --languages=c,c++,python,java,php,sh -R 
            \ --exclude=@$HOME/.vim/.ctagsignore 
            \ --c++-kinds=+p --fields=+iaS --extra=+q .
            \ <CR><CR> :TlistUpdate<CR>
imap <F8> <ESC>:!ctags 
            \ --languages=c,c++,python,java,php,sh,js -R 
            \ --exclude=@$HOME/.vim/.ctagsignore 
            \ --c++-kinds=+p --fields=+iaS --extra=+q .
            \ <CR><CR> :TlistUpdate<CR>

"""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置2——cscope
"""""""""""""""""""""""""""""""""""""""""""""
map <F9> :!find -L `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" -o 
            \ -name "*.java" -o -name "*.py" -o -name "*.php"
            \ >cscope.files<CR><CR>:!cscope -Rbq<CR>:cs reset<CR><CR>
imap <F9> <ESC>:!find -L `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" 
            \ -o -name "*.java" -o -name "*.py" -o -name "*.php"
            \ >cscope.files<CR><CR>:!cscope -Rbq<CR>:cs reset<CR><CR>
if has("cscope")
    set csprg=/usr/local/bin/cscope
    set csto=1
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    else
        let cscope_file=findfile("cscope.out", ".;") 
        let cscope_pre=matchstr(cscope_file, ".*/")
        if !empty(cscope_file) && filereadable(cscope_file)
            exe "cs add" cscope_file cscope_pre
        endif
    endif
    set csverb
endif
" 可以手动输入:cs f s stringA
" 查找该符号所有出现的地方
nmap <leader>css :cs find s <C-R>=expand("<cword>")<CR><CR>
" 查找该符号定义的地方
nmap <leader>csg :cs find g <C-R>=expand("<cword>")<CR><CR>
" 查找调用该符号的函数
nmap <leader>csc :cs find c <C-R>=expand("<cword>")<CR><CR>
" 查找该字符串, 比cs find s更加全面
nmap <leader>cst :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cse :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>csf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>csi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>csd :cs find d <C-R>=expand("<cword>")<CR><CR>

"""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置3
"   taglist的配置：vim跟随缓冲区退出，这里的文件数目不是根据窗口数哦，比如
"                   打开vim（没有跟随文件）此时主编辑区不算是一个文件。
"                   2014年 09月 17日 星期三 21:16:07 CST taglist的设置
"""""""""""""""""""""""""""""""""""""""
" 在剩余多少窗口时退出缓存
let Tlist_Exit_OnlyWindow=1
" 单一窗口显示的文件数
let Tlist_Show_One_File=1
" 窗口显示在右边或者左边，1为右边
let Tlist_Use_Right_Window=0
" 非当前文件，函数列表折叠隐藏，1为隐藏
let Tlist_File_Fold_Auto_Close=0
" 打开/关闭taglist窗口，不过被winmanager替代，见文件缓冲区插件2说明
" map  <F6> :TlistToggle<cr>
" 自动加载
autocmd BufWritePost *.* :TlistUpdate




"""""""""""""""""""""""""""配色模块"""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----> 配色配置1
"   molokai配色步骤:
"               1，molokai.vim放入colors/目录下面
"               2，molokai默认没有给对应元素配色
"               3，配置都是自定义的，可以删除
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 配色主题
colorscheme molokai
" 原始的monokai背景色
let g:molokai_original=1
" 256支持
let g:rehash256=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--->>配色配置2
"   solarized配色步骤：
"               1，vim-colors-solarized存入bundle目录下
"               2，设置配色方案
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" 背景（dark/light）
"if has('gui_running')
"set background=dark
"else
"set background=light
"endif
"" 256支持
"let g:solarized_termcolors=256
"" 选择颜色主题solarized
"colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--->>配色配置3
"       其他通用配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 匹配函数名，为函数名定义颜色做准备
autocmd BufNewFile,BufRead * :syntax match cfunctions 
            \"\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
autocmd BufNewFile,BufRead * :syntax match cfunctions 
            \"\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
" 给函数名加自定义颜色
hi cfunctions ctermfg=8
hi Type ctermfg=118 cterm=none 
" 结构体配色
hi Structure ctermfg=118 cterm=none
" 宏配色修改
"hi Macro ctermfg=161 cterm=bold
hi PreCondit ctermfg=161 cterm=bold
" 当前行的底色
set cursorline

""""""""""""""""""""""""""""""""""""""" 
"--->>配色配置4
"   powerline状态栏插件
"       结合terminal的状态栏设置，涉及字体等信息，
"       见印象笔记->vim->powerline安装
"   PS:
"       后期一键自动化安装的时候容易，现在配置很麻烦
""""""""""""""""""""""""""""""""""""""" 
" 找到powerline插件位置，当然也可以放在vim目录下面
let s:python2_ubuntu="~/.local/lib/python2.7/site-packages/powerline/bindings/vim/"
let s:python3_ubuntu="~/.local/lib/python3.4/site-packages/powerline/bindings/vim/"
let s:python2_mac="~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/"
if exists(s:python2_ubuntu)
    set rtp+=python2_ubuntu
endif
if exists(s:python3_ubuntu)
    set rtp+=python3_ubuntu
endif
if exists(s:python2_mac)
    set rtp+=python2_mac
endif
" 添加新的字体
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
" 主题风格
let g:Powerline_colorscheme='solarized256'

""""""""""""""""""""""""""""""""""""""" 
"--->>配色配置5
" Colorizer 高亮html/css中的颜色代码
""""""""""""""""""""""""""""""""""""""" 
" 自动开启, 编辑vimrc太过卡顿, 采用映射, 人工开启
" let g:colorizer_auto_color = 1
noremap  <leader>color :let g:colorizer_auto_color = 1<CR>
let g:colorizer_auto_filetype='css,html'
let g:colorizer_skip_comments = 1
let g:colorizer_auto_map = 1



""""""""""""""""""""""""""""""""""""""" 
" ---> 日常模块1——quickfix分析
"  
""""""""""""""""""""""""""""""""""""""" 
" Quickfix document
noremap <leader>ln :lne<CR>
noremap <leader>lp :lp<CR>
noremap <leader>lc :cclose<CR>
noremap <leader>lo :cwindow<CR>


""""""""""""""""""""""""""""""""""""""" 
" ---> 日常模块2——Calendar：
""""""""""""""""""""""""""""""""""""""" 
" 日期分隔符
let g:calendar_date_separator = "-"
" 打开日历时的视图
let g:calendar_view = "day"
" view布局，用于>切换时的布局
let g:calendar_views = ['year', 'day', 'month', 'week', 'clock', 'days']


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
" exclude some files
let NERDTreeIgnore = ['\.pyc$', 'migrations', 'log?', 'cscope.*', 'tags', 
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
" preview window close
nmap <leader>pc :pc<CR>

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
"""""""""""""""""""""""""""""""""""""""
" html基本框架
" imap  <leader>html5 :html:5<C-r>,

if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif


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
" 添加自定义的库文件位置
" let $PYTHONPATH='/Users/bamboo/Public/iLifeDiary/iLifeDiary/:/Users/zhengbifeng/Public/iLifeDiary/iLifeDiary'
if filereadable("bamboo.vim")
    source bamboo.vim
endif
