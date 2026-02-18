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

" 检测操作系统，设置家目录变量
if has('win32') || has('win64')
    let _sys_home_dir = $USERPROFILE
else
    let _sys_home_dir = $HOME
endif


"=======================1. 代码检查和跳转=========================


"""""""""""""""""""""""""""""""""""""""
" ---> 2. ale
" 功能: 异步代码检查插件
" PS: 在django项目中, 如果根目录存在settings.py文件, 则filetype异常
"
" 忽略检查:
"       > 对某个文件不检查, 在指定文件开头设置: pylint: skip-file
"       > 对某个文件不检查flake8, 在文件开头: flake8: noqa
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
if filereadable("pyproject.toml")
    " black
    let g:ale_fixers = {'python': ['black']}
endif

" 1. 指定pylintrc位置(最好每一个项目下面自己保留一份配置)
" 2. 对于不同版本的pylintrc, 自己重新生成一份:  pylint --generate-rcfile > .pylintrc
" 对于每一个项目, 如果需要自定义配置, 则可以在bamboo.vim中增加如下配置
if !filereadable(".pylintrc")
    let g:ale_python_pylint_options = '--rcfile '._sys_home_dir.'/.vim/.pylintrc'
else
    " getcwd获取当前工作目录
    let g:ale_python_pylint_options = '--rcfile '.getcwd().'/.pylintrc'
endif
" 启用virtualenv
let g:ale_python_pylint_use_global = 0

" tidy
let g:ale_html_tidy_options = '-q -e -language en -config '._sys_home_dir.'/.vim/.tidy.conf'

" 禁用某些插件, 目前只能使用白名单(ale_linters, ale_linters_explicit)
"   安装: npm install -g eslint
"   生成配置: 
"       1. 先在某个目录下生成package.json, 再一步步生成: npm init; npm init @eslint/config
"       2. 将生成的.eslintrc.js拷贝到全局, 再按照依赖: 
"           npm install -g @typescript-eslint/eslint-plugin
"           npm install -g @typescript-eslint/parser
"           npm install -g eslint-plugin-vue
"       3. 最终生成的eslintrc.js见用户根目录, 这仅仅是全局的
let b:ale_linters = {'javascript': ['eslint'], 'html': ['tidy'], 'go': ['gopls']}

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

""""""""""""""""""""""""""""""""""""""""""""""
" ---> 标签配置3——Universal tags的配置
""""""""""""""""""""""""""""""""""""""""""""""
imap <F8> <ESC>:!ctags --exclude=node_modules --exclude=deploy -R . <CR><CR>
map <F8> :!ctags --exclude=node_modules --exclude=deploy -R . <CR><CR>


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
" 使用: <key value> + <tabs>, 例如: spdate + <tabs> 会输入当前日期
" 新增: 在UltiSnips目录下增加相关键值
"""""""""""""""""""""""""""""""""""""""
" let g:UltiSnipsExpandTrigger="<tab>"
" 使用 tab 切换下一个触发点，shit+tab 上一个触发点
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
" " 使用 UltiSnipsEdit 命令时垂直分割屏幕
" let g:UltiSnipsEditSplit="vertical"


"""""""""""""""""""""""""""""""""""""""
"  --->>> neoformat替代vim-jsbeautiful, 适配所有语言
"  使用方法: 输入neoformat, 按空格, 然后tab选择需要格式化的工具, 比如prettier
"  前提条件: 安装格式化工具, 例如prettier: npm install -g prettier
"  formatter
"""""""""""""""""""""""""""""""""""""""
" 1. 自动保存, silent!表示静默
augroup fmt
  autocmd!
  autocmd BufWritePre * silent! undojoin | Neoformat
augroup END
" 2. 指定python使用autopep8格式化(默认)
if filereadable("pyproject.toml")
    let g:neoformat_enabled_python = ['black']
else
    let g:neoformat_enabled_python = ['autopep8']
endif


"""""""""""""""""""""""""""""""""""""""
"  --->>> 说明: 
"""""""""""""""""""""""""""""""""""""""
" 1. 服务启动: npm i -g live-server, 之后通过命令: live-server .启动服务
