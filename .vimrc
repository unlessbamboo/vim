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
syntax on
filetype plugin indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-pyenv 用于保证pyenv和vim的兼容运行，好像没用
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> emmet-vim，用于html,css的编写
"           展开缩略词：div>p#foo$*3>a + <c-y> + ,
"           包裹指定变为指定的标签：
"               V+选取+<c-y>, + (输入ul>li*)
"               其中后面的根据实际情况输入
"           选中标签（插入模式）：
"               整个标签（<c-y>d）
"               标签内容（<c-y>D）
"           编辑点跳转：
"               下一个：<c-y>n
"               上一个：<c-y>N
"           更新图片大小
"               <c-y>i，图片必须真实存在
"           合并多行
"               <c-y>m
"           移除某一个标签对
"               <c-y>k
"           分割/合并标签
"               将标签从<tags></tags>合并<tags ../>
"           切换注释
"               <c-y>/
"           生成锚
"               <c-y>a
"           根据URL地址生成引用文本
"               <c-y>A
"   注意：如果更改了快捷键，请修改上面的<c-y>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" Redifine trigger key，default <c-y>
let g:user_emmet_leader_key='<Tab>'
" Add custom snippets when install web-api for emmet-vim
"let g:user_emmet_settings = webapi#json#decode(
            "\join(readfile(expand(
            "\'~/.snippets_custom.json')), "\n"))
            

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> webapi-vim，An interface to WEB APIs
"       参考：
" https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
"       快捷键：
"           1，自动添加图片大小，<c-y>i，路径所指图片必须存在
"           2，注释
"               移动到需要注释的标签头部，<c-y>j，进行注释和取消
"           3，url
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-ag，内容搜索，替代ack.vim
"       requirement：安装the_silver_searcher工具
"                   例如，ag -i 'pattern' path
"       格式：
"           Ag [options] {pattern} [{directory}]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自定义Ag路径
"let g:ag_prg="<...> --vimgrep"
" 查找
let g:ag_working_path_mode="r"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-json，对json文件进行语法高亮
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-javascript，配置js开发环境
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
" 自定义隐匿字符
let g:javascript_conceal_function       = "ƒ"
let g:javascript_conceal_null           = "ø"
let g:javascript_conceal_this           = "@"
let g:javascript_conceal_return         = "⇚"
let g:javascript_conceal_undefined      = "¿"
let g:javascript_conceal_NaN            = "ℕ"
let g:javascript_conceal_prototype      = "¶"
let g:javascript_conceal_static         = "•"
let g:javascript_conceal_super          = "Ω"
let g:javascript_conceal_arrow_function = "⇒"


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
""""""""""""""""""""""""""""""""""""""" 
"---->>>>>python自动补全插件 jedi vim
""""""""""""""""""""""""""""""""""""""" 
" 在跳转的同时进行切割，可选项有left/right/top/bottom/winwidth
"let g:jedi#use_splits_not_buffers = "left"
let g:jedi#show_call_signatures = "1"
" 跳转，类似<C-]>，其中返回为<C-t>
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#completions_command = "<C-N>"


""""""""""""""""""""""""""""""""""""""" 
"---->>>>python-mode配置(python2.7)
"               K               显示python文档
"               <Leader>b     Set, unset breakpoint
"               [[            Jump on previous class or function
"               ]]            Jump on next class or function
"               [M            Jump on previous class or method
"               ]M            Jump on next class or method
"       PS:考虑到和syntastic语法检查冲突，关闭pylint检查
"               
""""""""""""""""""""""""""""""""""""""" 
" 避免和jedi vim冲突
let g:pymode_rope=0
" Linting, disable if exists syntastic
let g:pymode_lint=0

" doc
let g:pymode_doc=1
" 查看文档快捷键
let g:pymode_doc_key='K'
" support virtualenv
let g:pymode_virtualenv = 1
" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'
" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
" Don't autofold code
let g:pymode_folding = 0
" 关闭pyflakes插件的语法检查
" let g:pyflakes_use_quickfix = 0
" 缓存中的跳转映射--python-mode中的CodeCheck代码检查
map <silent> <leader>ln :lnext<cr>
map <silent> <leader>lp :lprev<cr>



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
" vim-surround配置
"       见印象笔记中的说明
""""""""""""""""""""""""""""""""""""""" 
" 没有特殊的配置，不要文档中的custom configure

""""""""""""""""""""""""""""""""""""""" 
" --->语法检查，syntastic的配置参数
"       获取错误信息：Errors或者lopen
"       错误间跳转：lne或者lp
"     PS:关于c/c++/python等配置见印象笔记或者github wiki、帮助文档
"       每一个目录都有一份独有的bamboo.vim配置当前项目的语言配置
"   
""""""""""""""""""""""""""""""""""""""" 
" 必要配置1
" Conflicts withs powerline，so close
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" 必要配置2--错误标注（和SyntasticStatuslineFlag()配合）
let g:syntastic_error_symbol = 'EE'
let g:syntastic_style_error_symbol = 'E>'
let g:syntastic_warning_symbol = 'WW'
let g:syntastic_style_warning_symbol = 'W>'
let g:syntastic_always_populate_loc_list = 1
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


""""""""""""""""""""""""""""""""""""""" 
" docstring的配置参数
"               自动插入docstring字符串
""""""""""""""""""""""""""""""""""""""" 
" 设置拓展
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"nmap <silent> <C-_> <Plug>(pydocstring)
nmap <silent> <leader>py :Pydocstring<cr>




""""""""""""""""""""""""""""""""""GCC模块"""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""
" --->  GCC模块1
"   DoxygenToolkit注释文档配置:
"       详细的信息见DoxygenToolkit.vim插件
"               
"""""""""""""""""""""""""""""""""""""""
" 函数和类注释，进行键的映射(输入,fg，即输出如下的字段)
nmap <leader>fg :Dox<cr>
" 插入文件名，作者时间
nmap <leader>fa :DoxAuthor<cr>
" 插件license注释
nmap <leader>fl :DoxLic<cr>
" 跳过文档的编写，不知道干什么的
" nmap <leader>fu :DoxUndoc<cr>
" 块注释
nmap <leader>fb :DoxBlock<cr>
" c/c++语言风格见不同目录下的配置

"""""""""""""""""""""""""""""""""""""""
" --->  GCC模块2
"""""""""""""""""""""""""""""""""""""""
nmap <leader>as :A<cr>
nmap <leader>ass :AS<cr>
nmap <leader>asv :AV<cr>



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
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/
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
" ---> 文件缓冲区窗口插件3
"      nerdtree 配置
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
" ---> 文件缓冲区窗口插件4
"   lookupfile配置
"       1,<F5>开启窗口，输入bamboo.c + Enter，之后使用<C-N>,<C-P>选择
"       2,LUBufs：缓冲区浏览，在所有的缓冲区中寻找某个函数等，类似cscope
"       3,LUWalk：目录浏览
"       4,忽略大小写查找：\c或者\C
"       PS:依赖genutils插件
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" 生成filenametags文件，注意tf和:中间的空格就正常的空格哦
" 其中/home/bamboo/.local/bin/filenametags可执行文件见：
" <https://github.com/unlessbamboo/grocery-shop/blob/master/bamboo/shell/filenametags>
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
syntax on
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
