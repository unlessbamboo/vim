
""""""""""""""""""""""""""""""""""""""" 
" --->>> YCM configure
"  1. 首先必须在 Python3.6 下进行编译(使用pyenv安装)
"  2. 如果需要安装python3开发环境, 请指定python路径为python3.6,
"       使用系统自带的 Python3.8 无法进行跳转操作
"  3. 在项目目录下.ycm_extra_conf.py指定python interpreter好像没用功
"  4. YCM调动omnifunc来进行补全工作
""""""""""""""""""""""""""""""""""""""" 
" let g:ycm_python_binary_path = "python"
" let g:ycm_complete_in_strings = 2
" let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_add_preview_to_completeopt = 1
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
" let g:ycm_key_invoke_completion = ''
" css/html自动补全: 四空格起始的行, 冒号加空格的行情况
" let g:ycm_semantic_triggers = {
"     \   'css': [ 're!^\s{4}', 're!:\s+'],
"     \   'html': [ '</' ],
"     \ }
" nnoremap <leader>jd :YcmCompleter GoTo<cr>

" java eclim
" let g:EclimCompletionMethod = 'omnifunc'
" 关闭函数preview windows
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
" 关闭打开的preview windows: (类似<F5>的功能)
" noremap <leader>pc :pclose<CR>
" nmap <leader>pc :pc<CR>


"""""""""""""""""""""""""""""""""""""""
" 插件: coc-nvim
" LSP: 语言服务器协议, 支持编辑器或 IDE 中编程语言的丰富编辑功能: 
"   在其自己的进程中运行库, 并使用进程间通信与之通信, 来回发送的消息形成协议
" 相比viml和python插件, coc优势: 
"   a. 优异的异步性能: 独立于vim的nodejs进程, viml和coc之间基于事件互相通信
"   b. 性能优化: coc 提供了 document change 事件, 无需额外事件以及传输消耗即可实时获取所有 缓冲区内容
"   c. 基于 javascript 社区的模块
"   d. 使用 coc 提供的 API
"   e. 统一化 vim 和 neovim 适配, coc 新版在传输层对于 vim 做了 neovim 接口的适配
"   f. 更加可靠的代码
"   g. 调试代码
" 参考: https://zhuanlan.zhihu.com/p/65524706
" 安装: 注意安装release分支
" python注意: 
"   1. 对于不同的虚拟环境, 需要额外运行: 
"           a. CocCommand -> python.setInterpreter
"           b. 选择当前需要的python解释器
"   2. 这些配置会保存到/Users/bamboounuse/.config/coc下而非项目目录下
"""""""""""""""""""""""""""""""""""""""
" let g:coc_global_extensions = ['coc-json']
" if filereadable(expand("~/.vim/coc.vim"))
"     source ~/.vim/coc.vim
" endif
" 不启用coc
" let b:coc_enable=0


""""""""""""""""""""""""""""""""""""""" 
" 插件：Vimjas/vim-python-pep8-indent
" 功能：基于pep8的自动缩进设置，非常棒
""""""""""""""""""""""""""""""""""""""" 
" flake8, .vim/.flake8，并创建软连接:ln -sf ~/.vim/.flake8 ~/.config/flake8
" 自定义配置, 见github以及印象笔记
" let g:flake8_ignore = 'E701, E301'

" pylint, 创建~/.vim/.pylintrc, 并通过pylint_options指定, 文件名可以任意取值


""""""""""""""""""""""""""""""""""""""" 
" vim-surround配置
"       见help surround
"       主页: https://github.com/tpope/vim-surround
" 单引号/双引号/标签的快速操作
""""""""""""""""""""""""""""""""""""""" 
" 没有特殊的配置，不要文档中的custom configure


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> autojump, 整合autojump到vim中, 注意只能打开目录
" 1. :J dir1
" 2. :JumpStat  查看列表
" 问题: 引入这个包之后会导致每次错误保存界面都有错乱显示, 暂弃用该功能,
" 可以使用find + path来替代该功能, 后者麻烦点: set path=.,/user/include/,,
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
