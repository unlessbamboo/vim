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

