### 1 ChangeLog

+ 2025：使用基于coc,ale等插件构建的nvim配置，插件管理使用plug

+ 2026-02-18：基于最新版本的neovim，插件管理使用lazy，基于nvim-lsp，treesitter，各个语言最新LSP插件为基础构建


### 2 物理结构
1. 目录结构

```sh
.
├── colors
│   └── molokai.vim
├── init.lua
├── lazy-lock.json
├── lua
│   ├── custom
│   ├── format
│   ├── lazyentry.lua
│   ├── lsp
│   ├── plugins
│   └── prev.lua
└── readme.md
```

+ colors：没有使用官方默认的molokai配色，仍然使用老版本的自定义配色，更加习惯
+ init.lua：入口文件，分为三大部分：加载prev、加载lazy入口、加载一些通用的（不能用lazy）插件
+ lua/lazyentry.lua：lazy插件管理入口文件
+ lua/plugins：存放lazy管理的部分需要单独配置（模块化）的插件，一个文件代表一个插件配置
+ lua/lsp：所有语言的lsp单独配置，他们一般会在lua/plugins/lspconfig.lua中被引用
+ lua/format：所有语言的格式化单独配置，他们会在lua/plugins/lspconfig.lua中被引用，不过放在lsp引用之后
+ lua/custom：所有不能使用lazy管理的插件，一般为通过外置命令行等配置的插件

2. python

使用lspconfig + pyright + ruff来完成python的开发环境

+ `pyright` 负责类型检查 / 语言补全
+ `ruff` 替代 pylint/flake8 做代码格式化 / 语法检查
+ `lspconfig` 则是 Neovim 对接 LSP 服务的核心桥梁

需要安装pyright和ruff命令。

3. lua

使用lspconfig + lua_ls + stylua来完成lua的开发环境

+ lua_ls：Lua 官方 LSP 服务
+ stylua：极速 Lua 格式化工具（替代 luafmt）

### 3 配置

1. 基本配置安装流程

```sh
# a. 下载安装最新的neovim，最好升级下brew并做一次doctor再进行操作，将电脑里面老的没有的app删了
#		在下面过程中通过命令来更新插件 :Lazy update
# 最后，建议先清理一遍电脑中已有的neovim包，删除neovim再重装
brew install neovim
# b. 安装字体并在item2终端上更改字体，以便treefolder左边的文件格式图标不会显示为问号
brew install font-hack-nerd-font
# c. 安装fzf + fd + fzf-lua
brew install fd fzf
fd --version && fzf --version
# d. neovim中英翻译
brew install translate-shell
# e. nvim-treesitter增量解析器生成工具，能将代码文本转换成结构化的「抽象语法树（AST）」
  npm install -g tree-sitter-cli
# 注意安装好后需要打开neovim安装python和lua： 
#		:TSInstall python lua
#		:checkhealth nvim-treesitter
```

2. python开发环境

```sh
# a. 安装ruff
curl -LsSf https://astral.sh/ruff/install.sh | sh
# b. pyright
npm install -g pyright
```

3. lua开发环境

```sh
# a. 安装lua_ls，注意，不用通过tree-sitter安装lua，否则出现各种古里古怪的错误
brew install lua-language-server
# b. 安装stylua
brew install stylua
```



