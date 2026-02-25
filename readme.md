### 1 ChangeLog

+ 2025：使用基于coc,ale等插件构建的nvim配置，插件管理使用plug

+ 2026-02-18：基于最新版本的neovim，插件管理使用lazy，基于nvim-lsp，treesitter，各个语言最新LSP插件为基础构建


### 2 配置
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
+ 

2. 配置安装流程

```sh
```

