---
    vim project introduction
---
<h3 align="right">---一个使用markdowm语法的插件说明</h3>


### 1 Introduction
Unlessbamboo's personal vim configure.Exists many indenpendence branch:
- master            :normal and basic configure.
- old\_completer    :my old vim plugins, use ctags,cscope,and others plugins
- new\_completer    :my new vim plugins, user YCM/syntastic, and others plugins
- gcc               :C IDE
- cx                :C++ IDE
- python            :python IDE


### 2 old\_completer
- 在系统各个头文件或者py文件目录生成tags/cscope数据库；
- 在每一个项目下存在bamboo.vim，进行单独的配置（加载tags/cscope）
- 从而实现代码的查找和跳转


### 3 new\_completer
#### 3.1 Install
- Install YCM
- Install Syntastci
- Install special language checkers
- Configure vimrc accross by different language.

#### 3.2 shell
- bashsupport   shell IDE
- shellcheck    Use at syntastic

#### 3.3 HTML/CSS
- emmet-vim     Use emmet at vim.


### 4 gcc
- a.vim       Switch between source files and header files. 
- DoxygenToolkit  Doxygen document


### 5 cx
- a.vim       Switch between source files and header files. 
- DoxygenToolkit  Doxygen document


### 6 python
- python-mode   At old\_completer
- vim-pydocstring   python docstring
