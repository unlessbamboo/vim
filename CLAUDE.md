# CLAUDE.md

## 协作规则

- **回复语言**：始终用中文回复
- **代码风格**：保持与现有代码一致，不要自作主张重构未被要求的部分
- **提交代码**：除非我明确要求，否则不要执行 git commit / git push
- **确认再动**：删除文件、修改数据库结构、修改 docker-compose 等破坏性操作前，先和我确认
- **简洁回复**：不要重复我说过的话，直接给出结论或改动
- **保留报错**：修复问题时尽量保留插件/程序原有的错误输出，不要用兜底、吞异常、包 wrapper 等方式暗自隐藏报错——先让问题可见，再决定怎么处理

---

## 项目概览

这是一个 Neovim 配置目录，日常支持 Python 和前端（html/css/js/ts/vue）开发，同时带 Lua（写配置用）和 Go 的基础支持。

- Neovim：0.12+（用到原生 `vim.lsp.config` / `vim.lsp.enable`）
- 插件管理：lazy.nvim
- LSP：nvim-lspconfig + 原生 LSP，不用 mason 自动装（`automatic_installation = false`）
- 语法：nvim-treesitter **main 分支**（注意不是 master，API 和用法都不同）
- 补全：nvim-cmp + AI（minuet-ai 行内补全 / avante.nvim 助手）
- 格式化：conform.nvim（保存时自动）；检查：nvim-lint（保存后触发）
- leader 键：`,`（`mapleader` 和 `maplocalleader` 都是逗号）

---

## 代码结构

```sh
.
├── colors/molokai.vim      # 自定义 molokai 配色（老版本，不是 tomasr/molokai 插件）
├── init.lua                # 入口
├── lazy-lock.json          # 插件版本锁
├── lua/
│   ├── prev.lua            # init.lua 最先加载，目前是空壳（M.setup() 为空）
│   ├── lazyentry.lua       # lazy.nvim 初始化 + 插件清单（手动逐个 require）
│   ├── custom/             # 不走 lazy 的配置，由 init.lua 直接 require
│   ├── plugins/            # 一个文件一个插件，返回 lazy spec（table 或 table 列表）
│   └── lsp/                # 各语言 LSP 单独配置，被 plugins/lspconfig.lua 引用
└── readme.md               # 安装 / 依赖说明（外部命令清单在这里）
```

### 加载顺序

相关文件:init.lua

1. 设置 `leader = ,`
2. `require("prev").setup()`（pcall 保护）
3. `require("lazyentry")` —— 启动 lazy 并加载所有插件
4. 逐个加载 `custom.*`：`translate` / `indent` / `color` / `reload` / `common` / `quickfix`
5. `pcall(require, "bamboo")` —— 可选的个人模块，不存在也不报错

### 模块职责

- **lua/plugins/**：每个文件 `return` 一个 lazy spec。`basic.lua` 和 `language.lua` 目前返回 `{}`（占位）。
- **lua/lsp/**：每个文件写 `vim.lsp.config["xxx"] = {...}` 再 `vim.lsp.enable("xxx")`。`lsp/init.lua` 提供 `setup_diagnostics` / `on_attach`（注册 LSP 快捷键、**关闭 LSP 自带格式化**，交给 conform）/ `capabilities`。
- **lua/plugins/conform.lua**：所有语言的格式化统一在此（ruff / stylua / prettier），`format_on_save` 开启，`lsp_fallback = false`。
- **lua/plugins/lint.lua**：nvim-lint，`BufWritePost` 触发（ruff / eslint / golangci-lint / shellcheck）。
- **lua/custom/**：不能用 lazy 管理的编辑器设置和小功能。`translate` 依赖外部 `trans` 命令。

改动时请沿用已有的模块化方式：**新增插件要在 `lua/lazyentry.lua` 的 `require("lazy").setup({...})` 列表里手动加一行**，plugins/ 目录不是自动 import 的。

---

## 代码规范

### 格式化

相关文件:.stylua.toml，针对本仓库 Lua 文件

- 缩进：**Tab**，`indent_width = 4`
- 行宽：110
- 字符串：优先双引号
- 函数调用：总是带括号（`call_parentheses = "Always"`）
- 不折叠单行语句、不自动排序 require

用 `stylua .` 或存盘时 conform 自动跑。

> 注意：`lua/custom/indent.lua` 会按 filetype 设置 **buffer-local** 缩进——lua/js/ts/vue/html/css 为 2 空格，python 为 4 空格。这只影响手动编辑时的视觉缩进，仓库内 Lua 文件的最终格式以 stylua（Tab）为准。历史文件里 2 空格和 Tab 混用属于已知不一致，改到哪个文件就顺手 stylua 一下。

### Lua 检查

相关文件:.luacheckrc

- 允许全局 `vim`
- 忽略：`unused-local` / `empty-line-with-spaces` / `trailing-space`
- 启用：`undefined-global` / `unused-function`

### 约定

- 所有快捷键带 `desc`，尽量 `noremap = true, silent = true`
- 快捷键风格统一走 `<leader>` 前缀，fzf / LSP / nvim-tree 的键位风格保持一致
- 每个插件文件顶部用 `--[[ ... ]]` 注释写清用途和外部依赖
- autocmd 一律用命名 `augroup` + `clear = true`，避免重载后堆叠

---

## 常用命令

### 插件/解析器

```sh
# 插件更新（在 nvim 内）
:Lazy update
:Lazy sync

# treesitter 解析器：由启动时 require("nvim-treesitter").install({...}) 自动装（见 lua/plugins/treesitter.lua）
# 不要用 :TSInstall（main 分支下语义不同）；检查状态：
:checkhealth nvim-treesitter

# 单独补装某个解析器（headless）
nvim --headless -c "lua require('nvim-treesitter').install({'bash'}):wait(120000)" -c "qa"

# LSP 工具（不自动装）
:MasonInstall pyright lua_ls
:checkhealth vim.lsp
```

### 格式化/检查

```sh
stylua .          # 格式化所有 Lua
luacheck .        # 静态检查
```

- nvim 内手动格式化当前文件：`<leader>rf`
- 存盘自动格式化 + lint

### 配置重载

- `<leader>ss`：重载配置（只清 `custom.*` / `prev` / `lazyentry` / `bamboo` 的缓存并重跑 init.lua）
- 保存 `init.lua` 会自动触发上面的重载
- **插件本身的改动重载不了**，需要重启 nvim 或 `:Lazy reload <plugin>`

---

## 坑与约定

### lazy 不能重复 setup

`lua/lazyentry.lua` 用 `vim.g.lazy_did_setup` 守卫，`<leader>ss` 重载时会再次 `require` 本文件，靠这个标志跳过重复初始化。别去掉这个判断。

### treesitter 用 main 分支

- 解析器清单写死在 `lua/plugins/treesitter.lua` 的 `install({...})` 里，目前有：rust / javascript / python / html / css / markdown / go / lua
- 没列进去的 filetype（sh / json / yaml / toml / bash …）**没有解析器**
- readme 里提到「不要用 tree-sitter 装 lua，会有奇怪报错」——但当前 `lua` 已在清单中（对应提交 `f49df98`）。如再遇到 lua 相关的 treesitter 报错，优先怀疑这里。

### sh/json 等注释时报 `[Comment.nvim] nil`

没有 treesitter 解析器的 filetype（sh / json / yaml / toml …）里用 Comment.nvim 注释会报这个，注释不生效；`.py` 正常是因为装了 python 解析器。根因是 Comment.nvim 对「解析器不存在」的判断不全。

要消掉就把对应语言加进 `lua/plugins/treesitter.lua` 的 `install` 列表补装解析器。**不要在 `comment.lua` 里包 wrapper 兜底吞掉这个报错**（见「协作规则 - 保留报错」）。

### leader 是逗号

大量 `,x` 映射，注意和 `timeoutlen` 的交互；正常查找逗号动作会有等待延迟。

### AI 插件共用 AI_PROVIDER

相关文件:lua/plugins/minuet.lua、lua/plugins/avante.lua

- `minuet-ai.nvim`（行内补全，接进 cmp）和 `avante.nvim`（对话/内联编辑）读同一个 `AI_PROVIDER` 环境变量
- 默认 `deepseek`（需 `DEEPSEEK_API_KEY`）；可选 `openai`（`OPENAI_API_KEY`）；avante 还支持 `claude`（`ANTHROPIC_API_KEY`）
- 改环境变量后需重启 nvim 或 `:Lazy reload minuet-ai.nvim`；avante 可 `:AvanteSwitchProvider` 热切
- `avante.nvim` 的 `build = "make"` 必须保留（编译 tiktoken_core）

### 补全键位

`<CR>` 确认、`<Tab>` / `<S-Tab>` 上下选、`<ESC>` 取消、`<C-l>` 手动触发 minuet（iTerm2 下可靠）。

---

## 外部依赖

配置本身不装这些，缺了对应功能不可用（详见 `readme.md`）：

| 用途       | 命令 / 包                                               |
| ---------- | ------------------------------------------------------- |
| 编辑器     | `neovim`（brew）                                        |
| 图标字体   | `font-hack-nerd-font` + iTerm2 里选中该字体             |
| 模糊查找   | `fd`、`fzf`                                             |
| 翻译       | `translate-shell`（`trans` 命令）                       |
| treesitter | `tree-sitter-cli`（`npm i -g tree-sitter-cli`）         |
| Python     | `ruff`、`pyright`（`npm i -g pyright`）                 |
| Lua        | `lua-language-server`、`stylua`、`luacheck`（luarocks） |
| Shell lint | `shellcheck`                                            |

---

## 快捷键概览

leader = `,`

| 键                                     | 功能                            |
| -------------------------------------- | ------------------------------- |
| `<F2>` / `<leader>ef`                  | 切换文件树 / 定位当前文件       |
| `<leader>ff` `<leader>fg` `<leader>fb` | fzf 找文件 / 全文搜索 / 缓冲区  |
| `<leader>gd` `<leader>gi` `<leader>gr` | LSP 定义 / 实现 / 引用          |
| `<leader>K` `<leader>rn` `<leader>ca`  | 悬浮文档 / 重命名 / code action |
| `<leader>e` `[d` `]d`                  | 诊断浮窗 / 上一个 / 下一个      |
| `<leader>rf`                           | 手动格式化当前文件              |
| `<leader>cc` / `<leader>c`             | 行注释 toggle / 注释算子        |
| `<leader>ss` / `<leader>ee`            | 重载配置 / 编辑 init.lua        |
| `<space>`                              | 折叠 toggle                     |

---

## TODO

- [ ] `lua/plugins/basic.lua`、`lua/plugins/language.lua` 为占位空表，待补充或删除
- [ ] `lua/prev.lua`、`bamboo` 模块目前为空 / 不存在
- [ ] 仓库内 Lua 文件缩进 Tab / 2 空格混用，未统一跑一遍 stylua
