""""""""""""""""""""""""文件缓冲区窗口模块""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""" 
" ---> 文件缓冲区窗口插件1——BufExplorer
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
" ---> 文件缓冲区窗口插件2
"       winmanager的配置： 界面分隔,是否自动打开winmanager，
"                       设置winmanger高度
""""""""""""""""""""""""""""""""""""""""""""""
" 设置显示方式或者界面分隔，左上角BE/FE共用一个窗口，右下角为taglist
" 其中左上角BufExporer和FP的切换使用Ctrl + N
" let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
" let g:defaultExplorer = 0
" " 自动打开winmanager
" let g:AutoOpenWinManager=0
" " 设置宽度
" let g:winMaagerWidth=30
" " goto first explorer window
" map  <leader>ff :FirstExplorerWindow<cr>
" " goto bottom explorer window
" map  <leader>bb :BottomExplorerWindow<cr>
" " reload
" nmap  <F6> :WMToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 文件缓冲区窗口插件-3-nerdtree 配置
"           显示当前目录下的树形目录树，有时候有用
"      PS: 建议结合lookupfile来使用
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 是否在vim启动的时候默认开启NERDTree
" autocmd VimEnter * NERDTree
" 窗口显示的位置，默认为左边
" let NERDTreeWinPos='right'
" 是否自动显示BookMarks
let NERDTreeShowBookmarks=1
" nerdtree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1
let NERDTreeWinSize = 25
" exclude some files
let NERDTreeIgnore = ['\.pyc$', 'log?', 'cscope.*', 'tags', 
            \ 'media', 'doc']
" 启动或者隐藏NERDTree
nmap  <F2> :NERDTreeToggle<cr>
" 刷新目录树
nmap  <F3> :NERDTree<cr>


""""""""""""""""""""""""""""""""""""""""
" ---> 文件缓冲区窗口插件-4-lookupfile配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" " 可执行文件：
" "   <https://github.com/unlessbamboo/grocery-shop/blob/master/bamboo/shell/filenametags>
" nmap  <leader>ft :!bash
"             \ /home/bamboo/.local/bin/filenametags
"             \<cr>:source ~/.vimrc<cr>
" " 加载指定的tags文件，而不是默认的tags文件，增加查找性能
" if filereadable("./filenametags")
"     let g:LookupFile_TagExpr = '"./filenametags"'
" endif
" " 最少输入字符位数才开始查找匹配
" let g:LookupFile_MinPatLength = 3
" " 不保存上次查找的字符串
" let g:LookupFile_PreserveLastPattern = 0
" " 保存查找历史
" let g:LookupFile_PreservePatternHistory = 1
" " 回车打开第一个匹配项目
" let g:LookupFile_AlwaysAcceptFirst = 1
" " 不允许创建不存在的文件
" let g:LookupFile_AllowNewFiles = 0
" " F5的功能，查找文件，映射LookupFile为,lk
" nmap  <leader>luk :LUTags<cr>
" " 浏览缓冲区，列出缓冲区中所有文件，映射LUBufs为ll
" nmap  <leader>lul :LUBufs<cr>
" " 浏览目录，查看该目录下所有文件，映射LUWalk为lw
" nmap  <leader>luw :LUWalk<cr>
" " 默认设置忽略大小写查找, 重写该函数
" function! LookupFile_IgnoreCaseFunc(pattern)
"     let _tags = &tags
"     try
"         let &tags = eval(g:LookupFile_TagExpr)
"         let newpattern = '\c' . a:pattern
"         let tags = taglist(newpattern)
"     catch
"         echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
"         return ""
"     finally
"         let &tags = _tags
"     endtry
"
"     " Show the matches for what is typed so far.
"     let files = map(tags, 'v:val["filename"]')
"     return files
" endfunction
" let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'


""""""""""""""""""""""""""""""""""""""" 
" ---> 文件基本操作
""""""""""""""""""""""""""""""""""""""" 
" 1 重命名文件，使用插件rename，该方法有很多缺陷
" saveas <new file> : will move a file from its location to CWD.
" 2 使用Explore, 之后使用 R-- 重命名, D--删除文件
noremap  <leader>sa :Explore<CR>
" 3 复制当前文件名到剪贴板(cs-copy filename, cp-copy file path)
"   关于expand, 见印象笔记
noremap  <leader>cf :let @+=expand("%")<CR>
noremap  <leader>cp :let @+=expand("%:p")<CR>
noremap  <leader>ct :let @+=expand("%:t")<CR>

" 设置拓展
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
" set dockerfile if find *Dockerfile
autocmd BufNewFile,BufRead *Dockerfile set filetype=dockerfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> 2. fzf.vim
"  基于fzf命令, 功能非常强大, 这里仅仅用到一些常用的命令
"  参考: https://github.com/junegunn/fzf.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" a. 文件搜索: 进入fzf交互界面
" files(经常使用)
nnoremap <leader>ff  :FZF<CR>
" git ls-files, 此时会自动跳转到当前版本控制的根目录, 若不在git下则该命令无效
nnoremap <leader>fg  :GFiles<CR>
" 在交互界面列出所有的buffers, 这个可比一个个的往下打开buffer好多了(请多使用)
nnoremap <leader>fb :Buffers<CR>

" b. 全文搜索(基于rg)
nnoremap <leader>fs :Rg<CR>
nnoremap <leader>css :Rg <C-R><C-W><CR>
" tags, 但是速度很慢
nnoremap <leader>ft :Tags<CR>
