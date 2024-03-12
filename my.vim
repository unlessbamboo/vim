" 一些不适合使用lua表示的初始化语句

" 
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')


"----------------------------工作区文件夹-----------------------------
" 与 VSCode 不同，vim 没有工作区支持。解决方案是从打开的文件解析工作区文件夹
" 参考: https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders
"   au: autocmd
au FileType html let b:coc_root_patterns = ['.git', '.env', 'tailwind.config.js', 'tailwind.config.cjs']
