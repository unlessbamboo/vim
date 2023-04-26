" 配色模块
" 2023-04-26 16:25:19: vim独有的molokai移动到vimonly.vim, nvim有一个新的配色

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
" " 匹配函数名，为函数名定义颜色做准备
" autocmd BufNewFile,BufRead * :syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
" autocmd BufNewFile,BufRead * :syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
" " 给函数名加自定义颜色
" hi cfunctions gui=NONE cterm=bold ctermfg=67
" hi Type ctermfg=118 cterm=none
" " 结构体配色
" hi Structure ctermfg=118 cterm=none
" " 宏配色修改
" "hi Macro ctermfg=161 cterm=bold
" hi PreCondit ctermfg=161 cterm=bold
" " 当前行的底色
" set cursorline

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
