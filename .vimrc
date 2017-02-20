" @file vimrc
" @brief    Slow down your step, and catch up with others.
" @author unlessbamboo
" @version 1.0
" @date 2015-03-03

" Set mapleader
let mapleader = ","

""""""""""""""""""""""""""""""""""""""" 
"---->>>>vim-pathogen管理插件
"           功能：用于加载插件
"           使用：pathogen + git使用类vundle功能
""""""""""""""""""""""""""""""""""""""" 
runtime bundle/vim-pathogen/autoload/pathogen.vim
" 可以通过execute pathogen#infect('bundle/{}', 
"                   '~/src/vim/bundle/{}')来指定
" vim插件的存放位置，默认为.vim/bundle
execute pathogen#infect()
" 生成各个插件的文档
"call pathogen#helptags()
" 自动检测文件类型
syntax on
filetype plugin indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> (YCM)YouCompleteMe插件
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-signify，自动比较当前文件和最新版本中的区别
"               一旦出现差异，会在左边提示相关信息
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-ag，内容搜索，替代ack.vim
"       requirement：安装the_silver_searcher工具
"                   例如，ag -i 'pattern' path
"       格式：
"           Ag [options] {pattern} [{directory}]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自定义Ag路径
"let g:ag_prg="<...> --vimgrep"
" 查找
let g:ag_working_path_mode="r"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-instant-markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"zshrc的配置                                               
" 该配置会导致suspend现象发生，-i表示加载整个interactive配置
 "set shell=bash\ -i                                         
let g:instant_markdown_slow=1                               
" 关闭自动开启浏览器的配置，使用命令:InstantMarkdownPreview                                                   
let g:instant_markdown_autostart=0                         
" 映射快捷键                                               
map <silent> <leader>imp :InstantMarkdownPreview<cr> 



"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> vim-json，对json文件进行语法高亮
"""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> nerdtree 配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1


""""""""""""""""""""""""""""""""""""""" 
"---->>>>powerline状态栏插件
""""""""""""""""""""""""""""""""""""""" 
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" 添加新的字体
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
" 保证xshell或者putty能够正常显示颜色
set t_Co=256
" 主题风格
let g:Powerline_colorscheme='solarized256'


""""""""""""""""""""""""""""""""""""""" 
"---->>>>>python相关配置
""""""""""""""""""""""""""""""""""""""" 
" 关闭smartindent
"au! FileType python setl nosmartindent


""""""""""""""""""""""""""""""""""""""" 
" --->语法检查，syntastic的配置参数
"       获取错误信息：Errors或者lopen
"       错误间跳转：lne或者lp
"   
""""""""""""""""""""""""""""""""""""""" 
" Conflicts withs powerline
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
" 自动拉起或者关闭错误窗口
let g:syntastic_auto_loc_list = 0
" 打开文件时检测
let g:syntastic_check_on_open = 1
" 每次保存时检测
let g:syntastic_check_on_wq = 1
" gcc/g++ 语句支持，被bamboo.vim覆盖
"   auto check my headers files.
" add search path, look bamboo.vim file.
let g:syntastic_c_include_dirs = ['include', 
            \]
let g:syntastic_cpp_include_dirs = ['include', 
            \]
let g:syntastic_c_check_header = 1
let g:syntastic_cpp_check_header = 1
" check when compile code?
let b:syntastic_c_cflags = '-I/usr/include -I/include'
let b:syntastic_cpp_cflags = '-I/usr/include -I/include'
let g:syntastic_cpp_compiler_options = '-std=c++11'



""""""""""""""""""""""""""""""""""""""""
" --->>> lookupfile配置
"       1,<F5>开启窗口，输入bamboo.c + Enter，之后使用<C-N>,<C-P>选择
"       2,LUBufs：缓冲区浏览，在所有的缓冲区中寻找某个函数等，类似cscope
"       3,LUWalk：目录浏览
"       4,忽略大小写查找：\c或者\C
"       PS:依赖genutils插件
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" 生成filenametags文件，注意tf和:中间的空格就正常的空格哦
nmap <silent> <leader>ft :!bash 
            \ /home/bamboo/.local/bin/filenametags
            \<cr>:source ~/.vimrc<cr>
" 加载指定的tags文件，而不是默认的tags文件
if filereadable("./filenametags")
    let g:LookupFile_TagExpr = '"./filenametags"'
endif
" 最少输入字符位数才开始查找
let g:LookupFile_MinPatLength = 3
" 不保存上次查找的字符串
let g:LookupFile_PreserveLastPattern = 0
" 保存查找历史
let g:LookupFile_PreservePatternHistory = 1 
" 回车打开第一个匹配项目
let g:LookupFile_AlwaysAcceptFirst = 1
" 不允许创建不存在的文件
let g:LookupFile_AllowNewFiles = 0
" 映射LookupFile为,lk
nmap <silent> <leader>luk :LUTags<cr>
" 映射LUBufs为,ll
nmap <silent> <leader>lul :LUBufs<cr>
" 映射LUWalk为,lw
nmap <silent> <leader>luw :LUWalk<cr>
" 默认设置忽略大小写查找, 重写该函数
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'


"""""""""""""""""""""""""""""""""""""""""
" ---> taglist的配置：vim跟随缓冲区退出，这里的文件数目不是根据窗口数哦，比如
"                   打开vim（没有跟随文件）此时主编辑区不算是一个文件。
"                   2014年 09月 17日 星期三 21:16:07 CST taglist的设置
" PS:为了退出缓冲区时退出vim，在taglist.vim中设置winbufnr的值
"""""""""""""""""""""""""""""""""""""""
" 配置ctags路径
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
" 在剩余多少窗口时退出缓存
let Tlist_Exit_OnlyWindow=1
" 单一窗口显示的文件数
let Tlist_Show_One_File=1
" 窗口显示在右边或者左边，1为右边
let Tlist_Use_Right_Window=0
" 非当前文件，函数列表折叠隐藏，1为隐藏
let Tlist_File_Fold_Auto_Close=0
" 自动加载
autocmd BufWritePost *.* :TlistUpdate

""""""""""""""""""""""""""""""""""""""" 
" BufExplorer介绍：快速浏览所有文件的buf插件，小型的文件
"                     缓存管理
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
" ---> winmanager的配置： 界面分隔,是否自动打开winmanager，设置winmanger高度
"                          <F6>快捷键开启，设置自动开启变量在winmanager.vim中设置
""""""""""""""""""""""""""""""""""""""""""""""
" 设置显示方式或者界面分隔
" 或者'TagList|FileExplorer, BufExplorer'
let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:defaultExplorer = 0
" 自动打开winmanager
let g:AutoOpenWinManager=0
" 设置宽度
let g:winMaagerWidth=30
" goto first explorer window
map <silent> <leader>ff :FirstExplorerWindow<cr>
" goto bottom explorer window
map <silent> <leader>bb :BottomExplorerWindow<cr>
" reload
nmap <silent> <F10> :WMToggle<cr>


"#######################################个人vim设置##########################
"""""""""""""""""""""""""""""""""""""""
" --->  重新载入vimrc配置:
"       <leader>ss为映射，生效时将leader替换为变量mapleader,
"               即<leader>ss变为",ss"快捷键
"       <leader>ee ---- ",ee"快捷键，打开配置
"""""""""""""""""""""""""""""""""""""""
" Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc


""""""""""""""""""""""""""""""""""""""""""""""
" ---> ctags的配置：
""""""""""""""""""""""""""""""""""""""""""""""
" 生成tags的命令
map <F9> :!ctags --exclude=jj
            \ --languages=c,c++,python,java,php,sh -R 
            \ --c++-kinds=+p --fields=+iaS --extra=+q .
            \ <CR><CR> :TlistUpdate<CR>
imap <F9> <ESC>:!ctags  --languages=c,c++,python,java,php,sh,js -R 
            \ --c++-kinds=+p --fields=+iaS --extra=+q .
            \ <CR><CR> :TlistUpdate<CR>

"""""""""""""""""""""""""""""""""""""""""""""
" ---> cscope生成选项：
"""""""""""""""""""""""""""""""""""""""""""""
map <F8> :!find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" -o 
            \ -name "*.java" -o -name "*.py" 
            \ >cscope.files<CR><CR>:!cscope -Rbq<CR>:cs reset<CR><CR>
imap <F8> <ESC>:!find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" 
            \ -o -name "*.java" -o -name "*.py" 
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
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>


"""""""""""""""""""""""""""""""""""""""
" --->  窗口切割映射键和跳转快捷键
"       
"""""""""""""""""""""""""""""""""""""""
" 切割
nmap <silent><leader>vs :vs<cr>
nmap <silent><leader>sp :sp<cr>
" 左边窗口
nmap <silent><leader>hw <C-w>h
" 右边窗口
nmap <silent><leader>lw <C-w>l
" 上边窗口
nmap <silent><leader>kw <C-w>k
" 下边窗口
nmap <silent><leader>jw <C-w>j
" 移动窗口，左右移动
nmap <silent><leader>rw <C-w><C-r>


"""""""""""""""""""""""""""""""""""""""
" --->  宏快捷键
"           @a寄存器 ---》 <leader>h寄存器
"       
"""""""""""""""""""""""""""""""""""""""
nmap <silent><leader>h @


"""""""""""""""""""""""""""""""""""""""
" --->  保存映射
"       
"""""""""""""""""""""""""""""""""""""""
" 保存所有文件
nmap <silent><leader> :wa<cr>


""""""""""""""""""""""""""""""""""""""" 
"--->>>制表符(tabstop)的操作：
"       autoindent	自动缩进
"       shiftwidth	左缩进的字节
"       tabstop	制表位的字节长度
"       expandtab	制表位转为空格
"--->>>退格键删除字符
"	backspace设置
"		eol 	插入模式下输入backspace合并两行
"		start	删除此时插入前的操作
"	whichwrap行间移动
"		b	backspace回退到上一行
"		s	spcace到下一行
""""""""""""""""""""""""""""""""""""""" 
set autoindent
set shiftwidth=4
set tabstop=4
set expandtab
set backspace=indent,eol,start
set whichwrap=b,s,<,>


"""""""""""""""""""""""""""""""""""""""
" --->  临时取消高亮显示的开关按钮
"       
"""""""""""""""""""""""""""""""""""""""
noremap <silent><F3> :nohlsearch<Bar>:echo<CR>
" 高亮命中的文本
set hlsearch
" 彻底关闭高亮
"set nohlsearch
" 临时关闭
"nohlsearch


""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----> molokai配色步骤:
"               1，molokai.vim放入colors/目录下面
"               2，molokai默认没有给对应元素配色
"               3，配置都是自定义的，可以删除
"
"--->>solarized配色步骤：
"               1，vim-colors-solarized存入bundle目录下
"               2，设置配色方案
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 背景颜色(dark/light)
set background=dark
"" 设置终端支持的颜色是256颜色
set t_Co=256

" 选择颜色主题--molokai 或者 solarized
" colorscheme solarized
" let g:solarized_termcolors=256
colorscheme molokai

" 匹配函数名，为函数名定义颜色做准备
autocmd BufNewFile,BufRead * :syntax match cfunctions 
            \"\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
autocmd BufNewFile,BufRead * :syntax match cfunctions 
            \"\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
" 给函数名加自定义颜色
hi cfunctions ctermfg=8
hi Type ctermfg=118 cterm=none 
" 结构体配色
hi Structure ctermfg=118 cterm=none
" 宏配色修改
"hi Macro ctermfg=161 cterm=bold
hi PreCondit ctermfg=161 cterm=bold
" 当前行的底色
set cursorline


""""""""""""""""""""""""""""""""""""""" 
"---->>>>Tmux
""""""""""""""""""""""""""""""""""""""" 
if exists('$TMUX')
    set term=screen-256color
endif


""""""""""""""""""""""""""""""""""""""" 
"---->>>>正常的基础命令
""""""""""""""""""""""""""""""""""""""" 
" 语法高亮
syntax enable
syntax on
"突出显示当前行
set cursorline
" 设置黑色背景，保证告警文本的效果能够更加显著
set background=dark
" 显示行号
set nu
" 设置状态行
set laststatus=2
"显示当前行号和列号
set ruler
"在状态栏显示正在输入的命令
set showcmd
" 搜索时忽略大小写
set ignorecase
" 随着键入即时搜索
set incsearch
" 设置字体和字号
set guifont=Monaco:h20
" 鼠标设置
set mouse=a
noremap <silent> <F4> :let &mouse = (&mouse == 'a' ? 'v' : 'a')<CR>
" paste设置
set pastetoggle=<F7>


""""""""""""""""""""""""""""""""""""""""""""""
" ---> 折叠配置
"
""""""""""""""""""""""""""""""""""""""""""""""
" 基于缩进的代码折叠
"set foldmethod=indent
" 基于语法的代码折叠
set foldmethod=syntax
" 启动时关闭代码折叠
set nofoldenable


""""""""""""""""""""""""""""""""""""""""""""""
" --->>> bamboo.vim的配置(建议放在最后)
"           1，设置tags的加载，不同的语言加载不同的tags
"           2，设置path(一般仅仅用于C语言)
"                   用于gf命令，快速调到指定的文件，当然文件必须
"                   在path搜索目录中:
"                     跳过去:gf(光标下的文件名)或者find + 文件名
"                     跳回来：<C-^>
"           3，现在一般用LookupFile来代替find命令，见上面的说明
"       
""""""""""""""""""""""""""""""""""""""""""""""
if filereadable("bamboo.vim")
    source bamboo.vim
endif


