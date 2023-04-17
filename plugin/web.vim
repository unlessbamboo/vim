" 前端页面开发组件


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
" 1. 自动保存
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
" 2. 指定python使用autopep8格式化(默认)
let g:neoformat_enabled_python = ['autopep8']
