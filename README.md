---
    vim project introduction
---
<h3 align="right">---一个使用markdowm语法的插件说明</h3>


## Introduction
Unlessbamboo's personal vim configure.Exists many indenpendence branch:
- master            normal and basic configure.
- old\_completer    my old vim plugins, use ctags,cscope,and others plugins
- new\_completer    my new vim plugins, user YCM/syntastic, and others plugins
- gcc               C IDE
- cx                C++ IDE
- python            python IDE


## old\_completer
1. 在系统各个头文件或者py文件目录生成tags/cscope数据库；
2. 在每一个项目下存在bamboo.vim，进行单独的配置（加载tags/cscope）
3. 从而实现代码的查找和跳转


## new\_completer
### 1, Install
1. Install YCM
2. Install Syntastci
3. Install special language checkers
4. Configure vimrc accross by different language.

### 2, shell
- bashsupport   shell IDE
- shellcheck    Use at syntastic
### 3, HTML/CSS
- emmet-vim     Use emmet at vim.



## gcc
- a.vim       Switch between source files and header files. 
- DoxygenToolkit  Doxygen document


## cx
- a.vim       Switch between source files and header files. 
- DoxygenToolkit  Doxygen document


## python
- python-mode   At old\_completer
- vim-pydocstring   python docstring
