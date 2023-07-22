

"""""""""""""""""""""""""""""""""""""""
" --->> 注释模块1——nerdcommenter
"  仅适用于vim, 不适用于nvim
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 1. jedi-vim
"  language: python
" 注意, 需要进入该目录下执行: git submodule update --init --recursive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 默认命令配置
let g:jedi#goto_command = "<leader>jd"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command = "<leader>js"
let g:jedi#goto_definitions_command = "<leader>jg"
let g:jedi#documentation_command = "<leader>jk"
let g:jedi#usages_command = "<leader>jn"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>jr"
let g:jedi#rename_command_keep_name = "<leader>jR"
