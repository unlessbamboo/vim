"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --------------------------------
" jedi-vim
" ale
"
" --------------------------------
" tags
" cscope
" taglist
" quickfix
" calendar
" vim-fugitive: 版本控制
"
" --------------------------------
"  配色
"
" --------------------------------
" emmet-vim
" UltiSnips
" neoformat


"=======================1. 代码检查和跳转=========================


"""""""""""""""""""""""""""""""""""""""
" ---> 2. ale
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
let g:ale_python_pylint_use_global = 0
" tidy
let g:ale_html_tidy_options = '-q -e -language en -config ~/.vim/.tidy.conf'

" 禁用某些插件, 目前只能使用白名单(ale_linters, ale_linters_explicit)
"   安装: npm install -g eslint
"   生成配置: 
"       1. 先在某个目录下生成package.json, 再一步步生成: npm init; npm init @eslint/config
"       2. 将生成的.eslintrc.js拷贝到全局, 再按照依赖: 
"           npm install -g @typescript-eslint/eslint-plugin
"           npm install -g @typescript-eslint/parser
"           npm install -g eslint-plugin-vue
"       3. 最终生成的eslintrc.js见用户根目录, 这仅仅是全局的
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


"=======================2. 日常组件=========================
""""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置1——tags的配置
""""""""""""""""""""""""""""""""""""""""""""""
" 生成tags的命令
" map <F8> :!ctags
"             \ --languages=c,c++,python,java,php,sh,javascript,html -R
"             \ --exclude=@$HOME/.vim/.ctagsignore
"             \ --c++-kinds=+p --fields=+iaS --extra=+q .
"             \ <CR><CR
" imap <F8> <ESC>:!ctags
"             \ --languages=c,c++,python,java,php,sh,js,javascript,html -R
"             \ --exclude=@$HOME/.vim/.ctagsignore
"             \ --c++-kinds=+p --fields=+iaS --extra=+q .
"             \ <CR><CR>

""""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置3——Universal tags的配置
""""""""""""""""""""""""""""""""""""""""""""""
imap <F8> <ESC>:!ctags --exclude=node_modules --exclude=deploy -R . <CR><CR>
map <F8> :!ctags --exclude=node_modules --exclude=deploy -R . <CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置2——cscope
"  问题1: 无法将find复杂命令成功移入vim中, 所以更改思路, 采用调脚本方式
"  问题2: cs reset在neovim中不存在, 采用静默方式运行
"""""""""""""""""""""""""""""""""""""""""""""
let g:cscope_ignored_dir = 'node_modules$\|dist$\|deploy$'
map <F9> :!~/.vim/mycscope.sh<CR><CR>:!cscope -Rbq<CR><CR>:silent! cs reset<CR><CR>
imap <F9> <ESC>:!~/.vim/mycscope.sh<CR><CR>:!cscope -Rbq<CR><CR>:silent!cs reset<CR><CR>
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
" ---> 标签配置3: taglist
"   taglist的配置：vim跟随缓冲区退出，这里的文件数目不是根据窗口数哦，比如
"                   打开vim（没有跟随文件）此时主编辑区不算是一个文件。
"                   2014年 09月 17日 星期三 21:16:07 CST taglist的设置
"""""""""""""""""""""""""""""""""""""""
" " 在剩余多少窗口时退出缓存
" let Tlist_Exit_OnlyWindow=1
" " 单一窗口显示的文件数
" let Tlist_Show_One_File=1
" " 窗口显示在右边或者左边，1为右边
" let Tlist_Use_Right_Window=0
" " 非当前文件，函数列表折叠隐藏，1为隐藏
" let Tlist_File_Fold_Auto_Close=0
" " 打开/关闭taglist窗口，不过被winmanager替代，见文件缓冲区插件2说明
" " map  <F6> :TlistToggle<cr>
" " 自动加载
" autocmd BufWritePost *.* :TlistUpdate


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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 日常模块-4-vim-fugitive.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gtd :Git diff<cr>
" 查询当前行的所有提交记录
map <leader>gtb :Git blame<cr>




"=======================3. 颜色控制=========================
" 配色模块
" 2023-04-26 16:25:19: vim独有的molokai移动到vimonly.vim, nvim有一个新的配色

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----> 配色配置1
"   molokai配色步骤:
"      1，molokai.vim放入colors/目录下面
"      2，molokai默认没有给对应元素配色
"      3，配置都是自定义的，可以删除
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 配色主题
colorscheme molokai
" 原始的monokai背景色
let g:molokai_original=1
" 256支持
let g:rehash256=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--->>配色配置3
"       其他通用配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 匹配函数名，为函数名定义颜色做准备
autocmd BufNewFile,BufRead * :syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
autocmd BufNewFile,BufRead * :syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
" 给函数名加自定义颜色
hi cfunctions gui=NONE cterm=bold ctermfg=67
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
" " 找到powerline插件位置，当然也可以放在vim目录下面
" let s:python2_ubuntu="~/.local/lib/python2.7/site-packages/powerline/bindings/vim/"
" let s:python3_ubuntu="~/.local/lib/python3.4/site-packages/powerline/bindings/vim/"
" let s:python2_mac="~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/"
" if exists(s:python2_ubuntu)
"     set rtp+=python2_ubuntu
" endif
" if exists(s:python3_ubuntu)
"     set rtp+=python3_ubuntu
" endif
" if exists(s:python2_mac)
"     set rtp+=python2_mac
" endif
" " 添加新的字体
" set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
" set laststatus=2
" " 主题风格
" let g:Powerline_colorscheme='solarized256'





"=======================4. 前端页面开发组件=========================
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
" 设置初始leader, 例如
"   1. 输入html:5, 然后按两下,,就会生成
"   2. 输入div, 然后按两下,,就会自动生成<div></div>
"   3. 输入div.name, 然后按两下,,就会生成<div class="name"></div>
"   4. 输入div#id, 然后按两下会生成: <div id="id"></div>
let g:user_emmet_leader_key="<leader>"
" HTML注释
autocmd filetype *html* imap <c-_> <c-y>/
autocmd filetype *html* map <c-_> <c-y>/


"""""""""""""""""""""""""""""""""""""""
"  --->>> UltiSnips代码片段Engine插件
"""""""""""""""""""""""""""""""""""""""
" let g:UltiSnipsExpandTrigger="<tab>"
" " 使用 tab 切换下一个触发点，shit+tab 上一个触发点
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
" " 使用 UltiSnipsEdit 命令时垂直分割屏幕
" let g:UltiSnipsEditSplit="vertical"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> jsbeautify: 对css,javascript, html进行格式化
"  默认配置文件: .editorconfig
"  配置: 指定换行空格等信息
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:editorconfig_Beautifier = '~/.vim/.editorconfig'
" map <c-f> :call JsBeautify()<cr>
" " 映射(可以配置vnormap)
" autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
" 自动格式化, 关闭自动格式化(会导致其他问题)
" autocmd FileType javascript :call JsBeautify()
" autocmd FileType json :call JsonBeautify()
" autocmd FileType jsx :call JsxBeautify()
" autocmd FileType html :call HtmlBeautify()
" autocmd FileType css :call CSSBeautify()


"""""""""""""""""""""""""""""""""""""""
"  --->>> neoformat替代vim-jsbeautiful, 适配所有语言
"  使用方法: 输入neoformat, 按空格, 然后tab选择需要格式化的工具, 比如prettier
"  前提条件: 安装格式化工具, 例如prettier: npm install -g prettier
"""""""""""""""""""""""""""""""""""""""
" 1. 自动保存, silent!表示静默
augroup fmt
  autocmd!
  autocmd BufWritePre * silent! undojoin | Neoformat
augroup END
" 2. 指定python使用autopep8格式化(默认)
let g:neoformat_enabled_python = ['autopep8']


"""""""""""""""""""""""""""""""""""""""
"  --->>> 说明: 
"""""""""""""""""""""""""""""""""""""""
" 1. 服务启动: npm i -g live-server, 之后通过命令: live-server .启动服务
