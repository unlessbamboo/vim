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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-json，对json文件进行语法高亮
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bash 支持设置
"       1,函数注释快捷键：\cfu
"       PS:更加详细的信息请见《印象笔记-vim-插件》笔记
"           或帮助手册
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:BASH_AuthorName   = 'bamboo'
let g:BASH_Email        = 'unlessbamboo@gmail.com'
let g:BASH_Company      = 'BigUniverse'


""""""""""""""""""""""""""""""""""""""" 
" -->> markddown
""""""""""""""""""""""""""""""""""""""" 
"zshrc的配置                                               
set shell=bash\ -i                                         
let g:instant_markdown_slow=1                               
" 关闭自动开启浏览器的配置，使用命令:InstantMarkdownPreview                                                   
let g:instant_markdown_autostart=0                         
" 映射快捷键                                               
map <silent> <leader>imp :InstantMarkdownPreview<cr>



""""""""""""""""""""""""""""""""""""""" 
" docstring的配置参数
"               自动插入docstring字符串
""""""""""""""""""""""""""""""""""""""" 
" 设置拓展
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"nmap <silent> <C-_> <Plug>(pydocstring)
nmap <silent> <leader>py :Pydocstring<cr>



"=======================c-family=========================
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -->>> DoxygenToolkit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 函数和类注释，进行键的映射(输入,fg，即输出如下的字段)
nmap <leader>fg :Dox<cr>
" 插入文件名，作者时间                                 
nmap <leader>fa :DoxAuthor<cr>
" 插件license注释
nmap <leader>fl :DoxLic<cr>
" 跳过文档的编写，不知道干什么的
nmap <leader>fu :DoxUndoc<cr>
" 块注释
nmap <leader>fb :DoxBlock<cr>


function! MyDoxygenGcc()
    " for C++ style, change the '@' to '\'
    let g:DoxygenToolkit_commentType = "C"
    " 高亮显示
    let g:doxygen_enhanced_color = 1

    " 用于设置注释简写的信息，一般为函数名
    "   例如：/// @brief func1
    let g:DoxygenToolkit_briefTag_pre = "@brief "
    "let g:DoxygenToolkit_briefTag_post = "endding"
    let g:DoxygenToolkit_briefTag_funcName = "yes"

    " 模板参数
    let g:DoxygenToolkit_templateParamTag_pre = "@tparam "
    " 普通函数参数
    let g:DoxygenToolkit_paramTag_pre = "@param "
    " 返回值
    let g:DoxygenToolkit_returnTag = "@return "
    let g:DoxygenToolkit_maxFunctionProtoLines = 30

    " 宏定义
    let g:DoxygenToolkit_blockTag = "@name "
    let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
    " let g:DoxygenToolkit_blockHeader = "--------------------------------------------"
    " let g:DoxygenToolkit_blockFooter = "--------------------------------------------"
    " 类定义
    let g:DoxygenToolkit_classTag = "@class "

    " 文件头的输出信息
    let g:DoxygenToolkit_fileTag = "@file "
    let g:DoxygenToolkit_dateTag = "@date "
    let g:DoxygenToolkit_authorTag = "@author "
    let g:DoxygenToolkit_versionTag = "@version "
    let g:DoxygenToolkit_licenseTag="unlessbamboo"
    let g:DoxygenToolkit_authorName = "unlessbamboo@gmail.com"
endfunction


function! MyDoxygenCx()
    " for C++ style, change the '@' to '\'
    let g:DoxygenToolkit_commentType = "C++"
    " 高亮显示
    let g:doxygen_enhanced_color = 1

    " 用于设置注释简写的信息，一般为函数名
    "   例如：/// @brief func1
    let g:DoxygenToolkit_briefTag_pre = "\\brief "
    "let g:DoxygenToolkit_briefTag_post = "endding"
    let g:DoxygenToolkit_briefTag_funcName = "yes"

    " 模板参数
    let g:DoxygenToolkit_templateParamTag_pre = "\\tparam "
    " 普通函数参数
    let g:DoxygenToolkit_paramTag_pre = "\\param "
    " @exception is also valid，C++中函数存在此类用法
    let g:DoxygenToolkit_throwTag_pre = "\\throw "
    " 返回值
    let g:DoxygenToolkit_returnTag = "\\return "
    let g:DoxygenToolkit_maxFunctionProtoLines = 30

    " 宏定义
    let g:DoxygenToolkit_blockTag = "\\name "
    let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
    let g:DoxygenToolkit_blockHeader = "--------------------------------------------"
    let g:DoxygenToolkit_blockFooter = "--------------------------------------------"
    " 类定义
    let g:DoxygenToolkit_classTag = "\\class "

    " 文件头的输出信息
    let g:DoxygenToolkit_fileTag = "\\file "
    let g:DoxygenToolkit_dateTag = "\\date "
    let g:DoxygenToolkit_authorTag = "\\author "
    let g:DoxygenToolkit_versionTag = "\\version "
    let g:DoxygenToolkit_licenseTag="unlessbamboo"
    let g:DoxygenToolkit_authorName = "unlessbamboo@gmail.com"
endfunction
" 对于.h文件如何搞？，所以必须在相应项目中设置哦
autocmd BufNewFile,BufRead *.cpp :call MyDoxygenCx()
autocmd BufNewFile,BufRead *.c :call MyDoxygenC()



"=======================HTML/CSS=========================
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -->> emmet-vim
"       Html and css 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable emmet-vim at special model
"   i/n/v, or a
" Enable all function in all mode
let g:user_emmet_mode='a'
" Enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" To remap the default <c-y> leader
" let g:user_emmet_leader_key='<C-Z>'


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
map <silent> <leader>gg :GitGutterToggle<cr>
" 关闭或者启动gitgutter signs，默认开启
map <silent> <leader>gs :GitGutterSignsToggle<cr>
" 关闭或者启动高亮，默认开启
map <silent> <leader>gh :GitGutterLineHighlightsToggle<cr>
" 设置文件发生更改后出现提示的延时时间（定时器）,默认为4s，设置为250ms
set updatetime=250
" To keep your Vim snappy（短小精悍），最大更改为500，默认值
let g:gitgutter_max_signs = 500

" 跳到下一个或者上一个hunk
nmap <silent> <leader>nh <Plug>GitGutterNextHunk
nmap <silent> <leader>ph <Plug>GitGutterPrevHunk
" stage或者undo hunk，取消修改
"   <leader>hs
"   <leader>hu
" 其他命令，哎，git




""""""""""""""""""""""""""""""""""""""" 
" --->>> YCM configure
"
""""""""""""""""""""""""""""""""""""""" 
" Default ycm config
let g:ycm_global_ycm_extra_conf = 
            \'~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
" 设置python或者python3
let g:ycm_python_binary_path="python"
" 关闭YCM自带的syntastci
let g:ycm_show_diagnostics_ui = 0


""""""""""""""""""""""""""""""""""""""" 
" --->语法检查，syntastic的配置参数
"       获取错误信息：Errors或者lopen
"       错误间跳转：lne或者lp
"     PS:关于c/c++/python等配置见印象笔记或者github wiki、帮助文档
"       每一个目录都有一份独有的bamboo.vim配置当前项目的语言配置
"   
""""""""""""""""""""""""""""""""""""""" 
" 必要配置1，和powerline冲突，舍弃
" Conflicts withs powerline，so close
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" 必要配置2--错误标注（和SyntasticStatuslineFlag()配合）
let g:syntastic_error_symbol = 'EE'
let g:syntastic_style_error_symbol = 'E>'
let g:syntastic_warning_symbol = 'WW'
let g:syntastic_style_warning_symbol = 'W>'
" 必要配置3
" 不需要手动调用 SyntasticSetTocList. 默认1
let g:syntastic_always_populate_loc_list = 1
" 自动拉起关闭错误窗口.
" 0不自动. 1自动拉起关闭. 2 自动关闭. 3 自动拉起 默认2, 建议为1
let g:syntastic_auto_loc_list = 1
" 打开文件时做语法检查, 默认 0
let g:syntastic_check_on_open = 1
" 报错时做语法检查, 默认 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers=['flake8', 'pylint']
" 注意,flake8包含（pep8/pycodestyle-pep257/pyflakes三个checkers）
let g:syntastic_python_flake8_args='--ignore=F401,E402,W291'
" pylint 格式(新增msg_id，以便进行相应的warning排除)
let g:syntastic_python_pylint_post_args = '--msg-template="{path}:{line}:{column}:{C}: {msg_id}[{symbol}] {msg}"'
let g:syntastic_python_pylint_args='--disable=W0611,W0613,C0413,C0411,c0303'

" shellcheckers and sh
let g:syntastic_sh_checkers=['shellcheckers']

" c and c++
let g:syntastci_c_checkers=['gcc']
let g:syntastci_cpp_checkers=['gcc']


" gcc/g++ 语句支持：help syntastic-checkers获取更多信息
" Check header files
let g:syntastic_c_check_header = 1
let b:syntastic_c_cflags = '-I/include'
let g:syntastic_c_include_dirs = []
" let g:syntastic__compiler_options = ''
" 增加config的查找路径，这些配置文件中包含CFLAGS或者include目录等信息
" let g:syntastic_c_config_file = ''
" 移除某些错误信息
" let g:syntastic_c_remove_include_errors = 1
" 错误输出格式
" let g:syntastic_c_errorformat = "%f:%l%c: %trror: %m"
" C编译器
let g:syntastic_c_compiler = "gcc"

" g++
let g:syntastic_cpp_check_header = 1
let b:syntastic_cpp_cflags = '-I/include'
" let g:syntastic_cpp_include_dirs = []                                                       
" 编译器选项
let g:syntastic_cpp_compiler_options = '-std=c++11'
" Enable header files being re-checked on every file write.
let g:syntastic_cpp_auto_refresh_includes = 1
" let g:syntastic_cpp_remove_include_errors = 1
" let g:syntastic_cpp_errorformat = "%f:%l%c: %trror: %m"
let g:syntastic_cpp_compiler = "g++"




""""""""""""""""""""""""""""""""""""""" 
" vim-surround配置
"       见印象笔记中的说明
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
" Allow commenting and inverting(反转) empty lines 
" (userful when commenting a region)，注释空行
let g:NERDCommentEmptyLines=1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace=1




""""""""""""""""""""""""""""""""""标签模块"""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置1——tags的配置
""""""""""""""""""""""""""""""""""""""""""""""
" 生成tags的命令
map <F9> :!ctags --exclude=jj
            \ --languages=c,c++,python,java,php,sh -R 
            \ --c++-kinds=+p --fields=+iaS --extra=+q .
            \ <CR><CR> :TlistUpdate<CR>
imap <F9> <ESC>:!ctags  --languages=c,c++,python,java,php,sh,js -R 
            \ --c++-kinds=+p --fields=+iaS --extra=+q .
            \ <CR><CR> :TlistUpdate<CR>

"""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置2——cscope
"""""""""""""""""""""""""""""""""""""""""""""
map <F8> :!find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" -o 
            \ -name "*.java" -o -name "*.py" 
            \ >cscope.files<CR><CR>:!cscope -Rbq<CR>:cs reset<CR><CR>
imap <F8> <ESC>:!find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" 
            \ -o -name "*.java" -o -name "*.py" 
            \ >cscope.files<CR><CR>:!cscope -Rbq<CR>:cs reset<CR><CR>
if has("cscope")
  set csprg=/usr/bin/cscope
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
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>

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
" map <silent> <F6> :TlistToggle<cr>
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
" set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set rtp+=~/.local/lib/python3.4/site-packages/powerline/bindings/vim/
" 添加新的字体
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
" 主题风格
let g:Powerline_colorscheme='solarized256'




""""""""""""""""""""""""""""""""""""""" 
" ---> 日常模块1——quickfix分析
""""""""""""""""""""""""""""""""""""""" 
" 快捷键设置暂时没有


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
map <silent> <leader>ff :FirstExplorerWindow<cr>
" goto bottom explorer window
map <silent> <leader>bb :BottomExplorerWindow<cr>
" reload
nmap <silent> <F6> :WMToggle<cr>

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
" 启动或者隐藏NERDTree
nmap <silent> <F2> :NERDTreeToggle<cr>


""""""""""""""""""""""""""""""""""""""""
" ---> 文件缓冲区窗口插件-4-lookupfile配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" 可执行文件：
"   <https://github.com/unlessbamboo/grocery-shop/blob/master/bamboo/shell/filenametags>
nmap <silent> <leader>ft :!bash 
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
nmap <silent> <leader>luk :LUTags<cr>
" 浏览缓冲区，列出缓冲区中所有文件，映射LUBufs为ll
nmap <silent> <leader>lul :LUBufs<cr>
" 浏览目录，查看该目录下所有文件，映射LUWalk为lw
nmap <silent> <leader>luw :LUWalk<cr>
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
"---->>>>正常的基础命令
""""""""""""""""""""""""""""""""""""""" 
" 语法高亮
syntax enable
" 高亮命中的文本或者set nohlsearch
set hlsearch
" 临时取消高亮显示的开关按钮
noremap <silent><F3> :nohlsearch<Bar>:echo<CR>
"突出高亮显示当前行
set cursorline

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
noremap <silent> <F4> :let &mouse = (&mouse == 'a' ? 'v' : 'a')<CR>
" paste设置
set pastetoggle=<F7>
" 保存所有文件
nmap <silent><leader>wa :wa<cr>
" 仅仅在下拉菜单中显示匹配项目，自动插入所有匹配项目的相同文本
set completeopt=longest,menu

""""""""""""""""""""""""""""""""""""""""""""""
" ---> 折叠配置
""""""""""""""""""""""""""""""""""""""""""""""
" 基于缩进的代码折叠
" set foldmethod=indent
" 基于语法的代码折叠
set foldmethod=syntax
" 启动时关闭代码折叠
set nofoldenable

""""""""""""""""""""""""""""""""""""""" 
"--->>>寄存器
""""""""""""""""""""""""""""""""""""""" 
" 宏快捷键：@a寄存器变为<leader>h寄存器
nmap <silent><leader>h @

""""""""""""""""""""""""""""""""""""""" 
"--->>>vimrc的重载
""""""""""""""""""""""""""""""""""""""" 
" Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

""""""""""""""""""""""""""""""""""""""" 
"--->>>制表符(tabstop)的操作：
""""""""""""""""""""""""""""""""""""""" 
" 自动缩进
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
" --->>>窗口切割映射键和跳转快捷键
"""""""""""""""""""""""""""""""""""""""
" 切割
nmap <silent><leader>vs :vs<cr>
nmap <silent><leader>sp :sp<cr>
" 左边窗口
nmap <silent><leader>hw <C-w>h
" 右边窗口
nmap <silent><leader>lw <C-w>l
" 上边窗口
nmap <silent><leader>kw <C-w>k
" 下边窗口
nmap <silent><leader>jw <C-w>j
" 移动窗口，左右移动
nmap <silent><leader>rw <C-w><C-r>

"""""""""""""""""""""""""""""""""""""""
"  --->>> session的保存和读取
"""""""""""""""""""""""""""""""""""""""
" 不在session文件中保存当前路径
set sessionoptions-=curdir
set sessionoptions+=sesdir
" 保存/读取session和viminfo
map <silent> <leader>wsv :mksession!<cr> :wviminfo vim.viminfo<cr>
map <silent> <leader>rsv :source ./Session.vim<cr> :rviminfo vim.viminfo<cr>




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
if filereadable("bamboo.vim")
    source bamboo.vim
endif
