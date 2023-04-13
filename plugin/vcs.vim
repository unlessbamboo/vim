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
" map  <leader>gg :GitGutterToggle<cr>
" 关闭或者启动gitgutter signs，默认开启
" map  <leader>gs :GitGutterSignsToggle<cr>
" 关闭或者启动高亮，默认开启
" map  <leader>gh :GitGutterLineHighlightsToggle<cr>
" 设置文件发生更改后出现提示的延时时间（定时器）,默认为4s，设置为250ms
" set updatetime=250
" To keep your Vim snappy（短小精悍），最大更改为500，默认值
" let g:gitgutter_max_signs = 500

" 跳到下一个或者上一个hunk
" nmap  <leader>nh <Plug>GitGutterNextHunk
" nmap  <leader>ph <Plug>GitGutterPrevHunk
" stage或者undo hunk，取消修改
"   <leader>hs
"   <leader>hu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 版本控制-3-vim-fugitive.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gtd :Git diff<cr>
" 查询当前行的所有提交记录
map <leader>gtb :Git blame<cr>
