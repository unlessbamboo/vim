#!/bin/bash - 
# 将当前目录的所有需要的代码文件导入到特定的目录

# -type f: 文件
# -not -path "xx" 表示排除
# -o 表示或的关系
find -L `pwd` -type f \( -name "*.css" -o -name "*.js" -name "*.h" -o -name \
       "*.c" -o -name "*.cpp" -name "*.java" -o -name "*.py" -o -name "*.php" \
       -o -name "*.css" -o -name "*.js" -o -name "*.vue" -o -name "*.html" \) \
       -not -path "`pwd`/node_modules/*" -not -path "`pwd`/deploy/*" \
       -not -path "`pwd`/.*/*" -not -path "`pwd`/venv/*" > `pwd`/cscope.files
