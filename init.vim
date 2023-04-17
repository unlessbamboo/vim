" 1. 原有vim配置
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc


" 3. 引用lua根文件
lua require("bamboo")
