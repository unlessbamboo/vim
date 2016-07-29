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
" 可以通过execute pathogen#infect('bundle/{}', 
"                   '~/src/vim/bundle/{}')来指定
" vim插件的存放位置，默认为.vim/bundle
execute pathogen#infect()
"call pathogen#infect()
"" 生成各个插件的文档
"call pathogen#helptags()
" 自动检测文件类型
filetype plugin indent on
syntax on


""""""""""""""""""""""""""""""""""""""" 
"---->>>>vim-instant-markdown插件
"       如果浏览器不能自动打开：http://localhost:8090
""""""""""""""""""""""""""""""""""""""" 
"zshrc的配置
set shell=bash\ -i
let g:instant_markdown_slow=1
" 关闭自动开启浏览器的配置，使用命令:InstantMarkdownPreview
" 开启
let g:instant_markdown_autostart=0
" 映射快捷键
map <silent> <leader>imp :InstantMarkdownPreview<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> (YCM)YouCompleteMe插件
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ----------------python的设置
" 自动获取virtualenv中的信息（如果actiavate)
" 建议将下面的设置放在bamboo.vim中
"let g:ycm_python_binary_path=""

" ---------------YCM本身的设置
" 主动进行补全快捷键设置，默认情况下会使用TAB补全的
"       Tab         一直循环往下，不用像老式的<C-n>
"       shift + tab 不适用于控制台（非gvim/macvim）
" 触发补全设置
let g:ycm_key_invoke_completion = '<C-n>'
" 让vim的补全行为同IDE保持一致
set completeopt=longest,menu
" 跳转到定义处
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <F6> :YcmForceCompileAndDiagnostics<CR>  "force recomile with

" ---------------貌似没用的配置
" 离开插入模式后自动关闭预览窗口
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" 回车即选中当前项
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
" 上下左右键的行为 会显示其他信息
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" syntastic
"nnoremap <leader>lo :lopen<CR>  "open locationlist
"nnoremap <leader>lc :lclose<CR> "close locationlist
"inoremap <leader><leader> <C-x><C-o>

" 不显示开启vim时检查ycm_extra_conf文件的信息  
"let g:ycm_confirm_extra_conf=0
"" 开启基于tag的补全，可以在这之后添加需要的标签路径  
"let g:ycm_collect_identifiers_from_tags_files=1
""注释和字符串中的文字也会被收入补全
"let g:ycm_collect_identifiers_from_comments_and_strings = 0
"" 输入第2个字符开始补全
"let g:ycm_min_num_of_chars_for_completion=2
"" 禁止缓存匹配项,每次都重新生成匹配项
"let g:ycm_cache_omnifunc=0
"" 开启语义补全
"let g:ycm_seed_identifiers_with_syntax=1  
""在注释输入中也能补全
"let g:ycm_complete_in_comments = 1
""在字符串输入中也能补全
"let g:ycm_complete_in_strings = 1
"" 设置在下面几种格式的文件上屏蔽ycm
"let g:ycm_filetype_blacklist = {
      "\ 'tagbar' : 1,
            "\ 'nerdtree' : 1,
                  "\}
                  ""youcompleteme  默认tab  s-tab 和 ultisnips 冲突
                  "let g:ycm_key_list_select_completion = ['<Down>']
                  "let g:ycm_key_list_previous_completion = ['<Up>']
                  "" 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT +
                  ";
                  "let g:ycm_key_invoke_completion = '<M-;>'



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
" ---> vim-signify，自动比较当前文件和最新版本中的区别
"               一旦出现差异，会在左边提示相关信息
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> nerdtree 配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1


""""""""""""""""""""""""""""""""""""""" 
"---->>>>powerline状态栏插件
""""""""""""""""""""""""""""""""""""""" 
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" 添加新的字体
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
" 保证xshell或者putty能够正常显示颜色
set t_Co=256
" 主题风格
let g:Powerline_colorscheme='solarized256'


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
"---->>>>>python相关配置
""""""""""""""""""""""""""""""""""""""" 
" 关闭smartindent
"au! FileType python setl nosmartindent


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
"               <Ctrl-Space>  Rope autocomplete
"               <Ctrl-c>g     Rope goto definition
"               <Ctrl-c>d     Rope show documentation
"               <Ctrl-c>f     Rope find occurrences
"               <Leader>b     Set, unset breakpoint
"               [[            Jump on previous class or function
"               ]]            Jump on next class or function
"               [M            Jump on previous class or method
"               ]M            Jump on next class or method
"               
""""""""""""""""""""""""""""""""""""""" 
" 避免和jedi vim冲突
let g:pymode_rope=0
let g:pymode_doc=1
" 查看文档快捷键
let g:pymode_doc_key='K'
" Linting，python2.7
let g:pymode_lint=1
let g:pymode_lint_checker="pyflakes,pep8"
" ignore some special errors
let g:pymode_lint_ignore = "E402,W0611"
" auto open window if any errors have been found
let g:pymode_lint_cwindow = 1
" auto check on save
let g:pymode_lint_write = 1
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
" signs
let g:pymode_lint_signs = 1
let g:pymode_lint_todo_symbol = "WW"
let g:pymode_lint_comment_symbol = "CC"
" Don't autofold code
let g:pymode_folding = 0
" 关闭pyflakes插件的语法检查
"let g:pyflakes_use_quickfix = 0
" 缓存中的跳转映射--python-mode中的CodeCheck代码检查
map <silent> <leader>ln :lnext<cr>
map <silent> <leader>lp :lprev<cr>


""""""""""""""""""""""""""""""""""""""" 
" --->语法检查，syntastic的配置参数
"       获取错误信息：Errors或者lopen
"       错误间跳转：lne或者lp
"   
""""""""""""""""""""""""""""""""""""""" 
" Conflicts withs powerline
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
" 自动拉起或者关闭错误窗口
let g:syntastic_auto_loc_list = 0
" 打开文件时检测
let g:syntastic_check_on_open = 1
" 每次保存时检测
let g:syntastic_check_on_wq = 1
" gcc/g++ 语句支持，被bamboo.vim覆盖
"   auto check my headers files.
" add search path, look bamboo.vim file.
let g:syntastic_c_include_dirs = ['include', 
            \]
let g:syntastic_cpp_include_dirs = ['include', 
            \]
let g:syntastic_c_check_header = 1
let g:syntastic_cpp_check_header = 1
" check when compile code?
let b:syntastic_c_cflags = '-I/usr/include -I/include'
let b:syntastic_cpp_cflags = '-I/usr/include -I/include'
let g:syntastic_cpp_compiler_options = '-std=c++11'


""""""""""""""""""""""""""""""""""""""" 
" docstring的配置参数
"               自动插入docstring字符串
""""""""""""""""""""""""""""""""""""""" 
" 设置拓展
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
"nmap <silent> <C-_> <Plug>(pydocstring)
nmap <silent> <leader>py :Pydocstring<cr>


"""""""""""""""""""""""""""""""""""""""
" --->  NERD_comment注释插件配置:
"       <leader>cc：添加注释
"       <leader>cu: 取消注释
"       <leader>ca：在可选的注释之间进行切换，例如/**/和//
"       <leader>cs：性感的方式注释:
"               /*
"                *
"                */
"       num<leader>cc:光标以下num行注释(包括当前行)
"       num<leader>cm:光标以下num块注释(包括当前行)
"""""""""""""""""""""""""""""""""""""""
" for c++ style, change the '@' to '\'


""""""""""""""""""""""""""""""""""""""""
" --->>> lookupfile配置
"       1,<F5>开启窗口，输入bamboo.c + Enter，之后使用<C-N>,<C-P>选择
"       2,LUBufs：缓冲区浏览，在所有的缓冲区中寻找某个函数等，类似cscope
"       3,LUWalk：目录浏览
"       4,忽略大小写查找：\c或者\C
"       PS:依赖genutils插件
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" 生成filenametags文件，注意tf和:中间的空格就正常的空格哦
nmap <silent> <leader>ft :!bash 
            \ /home/bamboo/.local/bin/filenametags
            \<cr>:source ~/.vimrc<cr>
" 加载指定的tags文件，而不是默认的tags文件
if filereadable("./filenametags")
    let g:LookupFile_TagExpr = '"./filenametags"'
endif
" 最少输入字符位数才开始查找
let g:LookupFile_MinPatLength = 3
" 不保存上次查找的字符串
let g:LookupFile_PreserveLastPattern = 0
" 保存查找历史
let g:LookupFile_PreservePatternHistory = 1 
" 回车打开第一个匹配项目
let g:LookupFile_AlwaysAcceptFirst = 1
" 不允许创建不存在的文件
let g:LookupFile_AllowNewFiles = 0
" 映射LookupFile为,lk
nmap <silent> <leader>luk :LUTags<cr>
" 映射LUBufs为,ll
nmap <silent> <leader>lul :LUBufs<cr>
" 映射LUWalk为,lw
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


"""""""""""""""""""""""""""""""""""""""""
" ---> taglist的配置：vim跟随缓冲区退出，这里的文件数目不是根据窗口数哦，比如
"                   打开vim（没有跟随文件）此时主编辑区不算是一个文件。
"                   2014年 09月 17日 星期三 21:16:07 CST taglist的设置
" PS:为了退出缓冲区时退出vim，在taglist.vim中设置winbufnr的值
"""""""""""""""""""""""""""""""""""""""
" 在剩余多少窗口时退出缓存
let Tlist_Exit_OnlyWindow=1
" 单一窗口显示的文件数
let Tlist_Show_One_File=1
" 窗口显示在右边或者左边，1为右边
let Tlist_Use_Right_Window=0
" 非当前文件，函数列表折叠隐藏，1为隐藏
let Tlist_File_Fold_Auto_Close=0
" 自动加载
autocmd BufWritePost *.* :TlistUpdate

""""""""""""""""""""""""""""""""""""""" 
" BufExplorer介绍：快速浏览所有文件的buf插件，小型的文件
"                     缓存管理
" 按键介绍：   
"           1）在光标指定到BufExplorer时（忽略）
"           2）命令模式下：
"               bn       打开下一个buffer文件
"               bp       打开上一个buffer文件
"               b num    打开指定号码的文件
"               num1,num2bd 删除num1到num2之间的缓存
"           3）普通模式下：
"               \bv      垂直打开一个窗口浏览所有的文件缓存
"               \bs      水平打开（这是bufExplore的功能）
"           4) 关闭bufExplorer（前提是进入该窗口）：
"               d        删除单个缓冲文件
"               bd       删除所有缓冲文件
"               在会话保存中会用到（关闭所有动态窗口）
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
" ---> winmanager的配置： 界面分隔,是否自动打开winmanager，设置winmanger高度
"                          <F6>快捷键开启，设置自动开启变量在winmanager.vim中设置
""""""""""""""""""""""""""""""""""""""""""""""
" 设置显示方式或者界面分隔
" 或者'TagList|FileExplorer, BufExplorer'
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


"""""""""""""""""""""""""""""""""""""""
" --->  DoxygenToolkit注释文档配置:
"               
"""""""""""""""""""""""""""""""""""""""
" 函数和类注释，进行键的映射(输入,fg，即输出如下的字段)
nmap <leader>fg : Dox<cr>
" 插入文件名，作者时间
nmap <leader>fa : DoxAuthor<cr>
" 插件license注释
nmap <leader>fl : DoxLic<cr>
" 格式
let g:DoxygenToolkit_authorName="unlessbamboo"
let g:DoxygenToolkit_licenseTag="哇哈哈\<enter>"
let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
let g:DoxygenToolkit_briefTag_pre = "@brief\t"
let g:DoxygenToolkit_paramTag_pre = "@param\t"
let g:DoxygenToolkit_returnTag = "@return\t"
" 是否在brief中写入函数名
let g:DoxygenToolkit_briefTag_funcName = "yes"
let g:DoxygenToolkit_maxFunctionProtoLines = 30
" 高亮显示
let g:doxygen_enhanced_color=1 


"#######################################个人vim设置##########################
"""""""""""""""""""""""""""""""""""""""
" --->  重新载入vimrc配置:
"       <leader>ss为映射，生效时将leader替换为变量mapleader,
"               即<leader>ss变为",ss"快捷键
"       <leader>ee ---- ",ee"快捷键，打开配置
"""""""""""""""""""""""""""""""""""""""
" Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc


""""""""""""""""""""""""""""""""""""""""""""""
" ---> ctags的配置：
" 基本按键命令：
"           ctags -R *          生成简单但是冗余的tags文件（宏，枚举变量，函数，
"                               类型定义，变量，类等）
"           <c-]>               到定义处
"           <c-o>或者<c-t>      返回前面的堆栈处
" 生成ctags的命令：
"           ctags -R –c++-kinds=+px –fields=+iaS –extra=+q . 或者
"           ctags -R --c++-kinds=+px --fields=+iaS --extra=+q -L src.files
"           前者指定当前目录下面的所有文件
"           后者通过src.files文件列表指定，操作的源代码变为src.files
"           源文件。
"           -c++kinds=+px       记录c++文件中的函数声明和各种外部和前向声明
"           –fields=+iaS        要求描述的信息
"           –extra=+q           强制要求ctags保证多个同名函数可以用不同路径
"                               区分
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
" ---> cscope生成选项：
"           -R      生成---搜索子目录中的代码
"           -b      生成---cscope.in.out和cscope.po.out,加快索引
"           -k      生成---不搜索/usr/incude目录
"           -i      生成---指定并非cscope.files的源文件列表
"           -l dir  生成---在dir中查找头文件
"           -u      生成---扫描所有文件，重新生成交叉索引文件
"           -C      生成---搜索时忽略大小写
"      添加选项(cs add path/cscope.out path): 
"           -P path     添加---添加cscope.out时，设置绝对路径
"      寻找选项:
"           s       查找c语言符号出现的地方
"           g       查找定义的位置，类型ctags
"           d       查找本函数调用的函数
"           c       查找调用本函数的函数
"           t       查找指定的字符串
"           e       egrep模式
"           f       查找并打开文件，vim中的find
"           i       查找包含本文件的文件
"      PS:关于-P选项，也可以在cscopes.files中添加, 将.换成`pwd`
"           find PATH[.,pwd] -name "*.h" -o -name "*.c" -o -name "*.cpp"
"               -o -name "*.java" >cscope.files
"           find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" 
"                   \ -o -name "*.java" -o -name "*.py" >cscope.files
"           cscope -Rbq
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


"""""""""""""""""""""""""""""""""""""""
" --->  窗口切割映射键和跳转快捷键
"       
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
" --->  宏快捷键
"           @a寄存器 ---》 <leader>h寄存器
"       
"""""""""""""""""""""""""""""""""""""""
nmap <silent><leader>h @


"""""""""""""""""""""""""""""""""""""""
" --->  保存映射
"       
"""""""""""""""""""""""""""""""""""""""
" 保存所有文件
nmap <silent><leader> :wa<cr>


""""""""""""""""""""""""""""""""""""""" 
"--->>>制表符(tabstop)的操作：
"       autoindent	自动缩进
"       shiftwidth	左缩进的字节
"       tabstop	制表位的字节长度
"       expandtab	制表位转为空格
"--->>>退格键删除字符
"	backspace设置
"		eol 	插入模式下输入backspace合并两行
"		start	删除此时插入前的操作
"	whichwrap行间移动
"		b	backspace回退到上一行
"		s	spcace到下一行
""""""""""""""""""""""""""""""""""""""" 
set autoindent
set shiftwidth=4
set tabstop=4
set expandtab
set backspace=indent,eol,start
set whichwrap=b,s,<,>


"""""""""""""""""""""""""""""""""""""""
" --->  临时取消高亮显示的开关按钮
"       
"""""""""""""""""""""""""""""""""""""""
noremap <silent><F3> :nohlsearch<Bar>:echo<CR>
" 高亮命中的文本
set hlsearch
" 彻底关闭高亮
"set nohlsearch
" 临时关闭
"nohlsearch


""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----> molokai配色步骤:
"               1，molokai.vim放入colors/目录下面
"               2，molokai默认没有给对应元素配色
"               3，配置都是自定义的，可以删除
"
"--->>solarized配色步骤：
"               1，vim-colors-solarized存入bundle目录下
"               2，设置配色方案
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 背景颜色(dark/light)
set background=dark
"" 设置终端支持的颜色是256颜色
set t_Co=256

" 选择颜色主题--molokai 或者 solarized
" colorscheme solarized
" let g:solarized_termcolors=256
colorscheme molokai

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
"---->>>>Tmux
""""""""""""""""""""""""""""""""""""""" 
if exists('$TMUX')
    set term=screen-256color
endif


""""""""""""""""""""""""""""""""""""""" 
"---->>>>正常的基础命令
""""""""""""""""""""""""""""""""""""""" 
" 语法高亮
syntax enable
syntax on
"突出显示当前行
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


""""""""""""""""""""""""""""""""""""""""""""""
" ---> 折叠配置
"       折叠的组合:
"               manual      手动设置
"               indent      缩进来折叠
"               syntax      语法来折叠
"               expr        表达式定义来折叠
"               marker      用标志折叠
"       所有折叠的相同命令：
"               zm          关闭折叠
"               zM          关闭所有折叠
"               zr          打开当前
"               zR          打开所有
"               zc          折叠当前行
"               zo          打开当前折叠
"               zO          打开当前所有嵌套折叠
"               zf          创建折叠（marker模式）
"               zd          删除折叠（manual和marker模式）
"               zD          删除所有折叠
"
"
""""""""""""""""""""""""""""""""""""""""""""""
" 基于缩进的代码折叠
"set foldmethod=indent
" 基于语法的代码折叠
set foldmethod=syntax
" 启动时关闭代码折叠
set nofoldenable


""""""""""""""""""""""""""""""""""""""" 
" 自动补全分析：需要用到检测文件和智能补全预览窗口,tags文件
" 按键介绍：
"       关键字补全  <c-x> <c-n>         默认不用按ctrl+x，python可能需要
"       整行补全    <c-x> <c-l>         先按ctrl+x 再按ctrl+l 
"       文件名补全  <c-x> <c-f>         同上(必须对文件所在目录有访问权限)
"       字典补全    <c-x> <c-k>         ???
"       全能补全    <c-x> <c-o>         ???
" PS:该插件名称为:omnicppcomplete
" PSS:2016-07-22因为python语言的补全问题，尝试使用YCM替换补全
""""""""""""""""""""""""""""""""""""""" 
" 关闭智能补全时的预览窗口
"set completeopt=longest,menu


""""""""""""""""""""""""""""""""""""""" 
" ---> quickfix分析：将编译过程中的错误信息保存到制定的缓存中，
"               vim利用这些信息跳转到源文件的位置，进行
"               错误修改
"       查看make选项：set makeprg
"       按键介绍：
"             cc          显示详细的错误信息，在vim状态栏中显示错误信息
"             cp          跳到上一个错误处，每一次都是显示cc的详细信息
"             cn          同cp相反
"             cw          如果存在错误列表，则打开一个窗口，默认行数为10
"             copen NUM   有时候和cw不同，比如ld错误的时候，cw没有任何信息
"             cclose      关闭上面两个命令打开的窗口
"             cnew        到后一个新的文件列表
"       具体截图请看：quickfix-screenshot/文件中的截图
""""""""""""""""""""""""""""""""""""""" 
" 快捷键设置暂时没有


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


