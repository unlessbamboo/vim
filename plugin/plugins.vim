"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件配置集合
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 1. jedi-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 2. vim-ag，内容搜索，替代ack.vim
"       requirement：安装the_silver_searcher工具
"                   例如，ag -i 'pattern' path
"       格式：
"           Ag [options] {pattern} [{directory}]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 查找，从项目根目录开始
let g:ag_working_path_mode="r"
" 执行路径
set runtimepath^=~/.vim/bundle/ag.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 3. jsbeautify: 对css,javascript, html进行格式化
"  默认配置文件: .editorconfig
"  配置: 指定换行空格等信息
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


"""""""""""""""""""""""""""""""""""""""
" ---> 4. ale
" 功能: 异步代码检查插件
" PS: 在django项目中, 如果根目录存在settings.py文件, 则filetype异常
"""""""""""""""""""""""""""""""""""""""
" 控制错误输出格式, 通过这个 linter找到确切的忽略错误的方式
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '%...code...%: [%linter%] %%s [%severity%]'
" use quickfix list instead of the loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0

" help ale-python 信息
" 1. 指定pylintrc位置(最好每一个项目下面自己保留一份配置)
" 2. 对于不同版本的pylintrc, 自己重新生成一份:  pylint --generate-rcfile > .pylintrc
" 对于每一个项目, 如果需要自定义配置, 则可以在bamboo.vim中增加如下配置
if !filereadable(".pylintrc")
    let g:ale_python_pylint_options = '--rcfile ~/.vim/.pylintrc'
else
    " getcwd获取当前工作目录
    let g:ale_python_pylint_options = '--rcfile '.getcwd().'/.pylintrc'
endif

" 如果希望对某个文件不检查, 在指定文件开头设置: pylint: skip-file
" 如果希望对某个文件不检查flake8, 在文件开头: flake8: noqa
" 启用virtualenv
let g:ale_python_pylint_use_global = 1
" tidy
let g:ale_html_tidy_options = '-q -e -language en -config ~/.vim/.tidy.conf'
" 禁用某些插件, 目前只能使用白名单(ale_linters, ale_linters_explicit)
let b:ale_linters = {'javascript': ['eslint'], 'html': ['tidy']}

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
