# CLAUDE.md

## 协作规则

- **回复语言**：始终用中文回复
- **代码风格**：保持与现有代码一致，不要自作主张重构未被要求的部分
- **提交代码**：除非我明确要求，否则不要执行 git commit / git push
- **确认再动**：删除文件、修改数据库结构、修改 docker-compose 等破坏性操作前，先和我确认
- **简洁回复**：不要重复我说过的话，直接给出结论或改动

---

## 项目概览
这是一个neovim配置目录,日常支持python/java和前端开发环境


---

## 代码结构

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

在进行改动的时候请大体按照已有的模块化逻辑进行改动

## 代码规范

---

## 常见坑

---

## TODO / 已知问题
