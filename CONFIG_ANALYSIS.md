# Neovim 配置分析文档

> 生成日期：2026-08-09　|　环境：macOS / Neovim v0.12.4 / LuaJIT 2.1
> 管理方式：lazy.nvim（插件）+ mason.nvim（语言工具）+ 自写 Lua 模块（custom）
> 最近更新：2026-08-09（接入 minuet-ai.nvim + avante.nvim，见第 0 节）

---

## 0. 变更记录（跨机器同步参考）

> 本 session 起，每次对话造成的配置改动都会同步记录到本节，方便在其他电脑上还原。

### 2026-08-09：接入 AI 补全与助手

- 新增 [lua/plugins/minuet.lua]：minuet-ai.nvim，as-you-type AI 补全，接入 nvim-cmp（source `minuet`、`<A-y>` 手动触发、`fetching_timeout = 2000`）。
- 新增 [lua/plugins/avante.lua]：avante.nvim，Cursor 风格 AI 助手；自动安装依赖 plenary.nvim、nui.nvim、nvim-web-devicons、render-markdown.nvim；文件选择复用已有 fzf-lua。
- `lua/lazyentry.lua` 注册两个新插件文件；`lazy-lock.json` 已更新（含 5 个新插件）。
- 默认模型 DeepSeek（minuet 用 `openai_fim_compatible`，avante 用 `__inherited_from = "openai"` 的自定义 provider）；`AI_PROVIDER=openai` 可整体切到 OpenAI。
- API key 一律通过环境变量注入（DEEPSEEK_API_KEY / OPENAI_API_KEY / ANTHROPIC_API_KEY），不写入仓库（详见 2.16 / 2.17 / 7.4 节）。
- avante 首次安装已在本机完成 `build = "make"`（下载预编译 tiktoken 等组件，约 12MB）。

### 2026-08-09（补充）：API key 环境检查与修复

- 检查结论：`~/.bamboo_profile`（symlink → `~/bambooenv/bamboo/env/.bamboo_profile`，由 `~/.zshrc` 106-107 行 source）里的 Neovim key 段落存在自引用 bug：`export DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}`，导致 DeepSeek key 始终为空；真实 key 定义在 `/data/shell/key.sh` 的 `MY_DEEPSEEK_API_KEY` / `MY_PACKYCODE_API_KEY`。
- 修复：改为 `export DEEPSEEK_API_KEY=${MY_DEEPSEEK_API_KEY}`；`OPENAI_API_KEY=${MY_PACKYCODE_API_KEY}`、`ANTHROPIC_API_KEY=${MY_ANTHROPIC_API_KEY}`（key.sh 中当前为空）、`AI_PROVIDER="deepseek"` 均正常。
- 验证：新交互 shell 中 `AI_PROVIDER=deepseek`、`DEEPSEEK_API_KEY` 35 字符、`OPENAI_API_KEY` 51 字符，加载正常。
- 权限：`.bamboo_profile` 与 `/data/shell/key.sh` 均已 `chmod 600`（此前 755/644，本机其他用户可读）。
- 提醒：排查过程中 key 明文曾出现在诊断输出中，建议轮换；key 不要提交进 git 仓库（key.sh 未跟踪；`.bamboo_profile` 虽在 bambooenv 仓库内，但只含 `${MY_*}` 引用、无明文 key）。

### 2026-08-09（补充）：minuet "API key 环境变量不存在" 报错排查

- 报错含义：minuet 在 nvim 启动时按配置的 `api_key` 变量名取环境变量，取不到就报 `The API key has not been provided as an environment variable...`（来源：`lua/minuet/backends/openai_fim_compatible.lua` / `openai_compatible.lua`）。
- 原因：报错的 nvim 实例是修复 `.bamboo_profile` 之前启动的，启动时环境里 `DEEPSEEK_API_KEY` 为空；nvim 启动后 `vim.env` 不会刷新。
- 验证：新交互 shell 中启动 nvim，`vim.env` 可见 `DEEPSEEK_API_KEY=35`、`OPENAI_API_KEY=51`、`AI_PROVIDER=deepseek`，加载正常。
- 解决：关闭旧 nvim 实例，从新终端（或 `source ~/.bamboo_profile` 后）重新启动。
- 预防：若以后从 GUI（Spotlight/Finder）启动 nvim，zsh 启动文件不会执行，需改用 `launchctl setenv` 或把 export 挪到 `~/.zshenv`；tmux 场景注意旧 server 继承的旧环境。

### 2026-08-10：核对 avante 官方依赖清单（结论：无需改动）

- 必需项 plenary / nui / nvim-web-devicons / render-markdown 均已配置。
- nvim-cmp 与 fzf-lua 本配置已有（fzf 已设为 avante 的 selector），不重复声明。
- mini.pick / telescope 仅用于替代文件选择器，不装；copilot.lua 仅用于 `provider="copilot"`，不装。
- 唯一可选未装的是 `img-clip.nvim`（对话中粘贴图片）；如需再加。

---

## 1. 总体架构

这是一个 **模块化 + lazy.nvim** 的现代 Neovim 配置：入口 `init.lua` 负责加载，插件按文件拆分在 `lua/plugins/` 下，不能用插件管理器装载的外部工具/自写逻辑放在 `lua/custom/` 下，LSP 语言级配置放在 `lua/lsp/` 下。`<leader>` 键是 `,`。

### 1.1 目录结构（实际）

```sh
.
├── init.lua                  # 入口：加载 prev → lazyentry → custom 模块 → 可选 bamboo
├── lazy-lock.json            # lazy.nvim 插件版本锁（更新后自动变更）
├── readme.md                 # 作者自述（部分内容已过时）
├── CLAUDE.md                 # 协作规则（中文回复、不主动 commit 等）
├── .stylua.toml              # Lua 代码格式化风格（stylua 用）
├── .luacheckrc               # Lua 静态检查配置（luacheck 用）
├── colors/
│   └── molokai.vim           # 自带的 molokai 配色（老版本，非官方插件版）
├── lua/
│   ├── lazyentry.lua         # lazy.nvim 初始化 + 插件清单
│   ├── prev.lua              # 兼容旧配置的空壳模块
│   ├── custom/               # 不能用 lazy 管理的外部工具 & 自写逻辑
│   │   ├── common.lua        # 通用编辑器设置、窗口管理快捷键
│   │   ├── color.lua         # 主题、字体、大文件优化
│   │   ├── indent.lua        # 缩进/折叠、语言级缩进
│   │   ├── quickfix.lua      # quickfix 窗口交互后自动关闭
│   │   ├── reload.lua        # 快速编辑/重载配置
│   │   └── translate.lua     # 翻译（调用 translate-shell）
│   ├── lsp/
│   │   ├── init.lua          # 诊断显示、LSP 快捷键、capabilities
│   │   ├── pyright.lua       # Python LSP（pyright）
│   │   └── lua_ls.lua        # Lua LSP（lua-language-server）
│   └── plugins/              # 每个文件 = 一组插件配置
│       ├── fzf.lua           # fzf-lua 文件/搜索
│       ├── filetree.lua      # nvim-tree 文件树
│       ├── gitsigns.lua      # Git 行内标记
│       ├── lualine.lua       # 状态栏
│       ├── lspconfig.lua     # LSP 框架入口
│       ├── cmp.lua           # 补全 nvim-cmp
│       ├── autopairs.lua     # 自动括号
│       ├── minuet.lua        # AI 补全（DeepSeek/OpenAI 按 AI_PROVIDER 切换）
│       ├── avante.lua        # AI 助手（Cursor 风格，含依赖声明）
│       ├── conform.lua       # 保存时格式化
│       ├── lint.lua          # 异步 lint
│       ├── mason.lua         # LSP/工具安装管理
│       ├── treesitter.lua    # 语法树高亮
│       ├── comment.lua       # 注释切换
│       ├── basic.lua         # 空占位（molokai 插件已注释）
│       └── language.lua      # 空占位
└── backup/
    └── translate.lua         # 旧版翻译模块备份（未跟踪 git）
```

### 1.2 启动流程

1. `init.lua`：设置 leader 为 `,`，加载 `prev`（空壳），配置 git 镜像，注册 `LazySetup` 自动命令，然后 `require("lazyentry")`。
2. `lazyentry.lua`：首次启动自动 clone lazy.nvim 本体；随后 `require("lazy").setup({...})` 注册全部插件。
3. `init.lua` 继续加载 `custom/` 下 6 个模块（翻译、缩进、主题、重载、通用、quickfix）。
4. `pcall(require, "bamboo")`：加载个人自定义模块（当前不存在，静默跳过）。

实测无头启动约 **0.25s**，属于正常水平；其中 nvim-tree 与 treesitter 的加载占了主要耗时，但影响不大。

---

## 2. 实现的功能

### 2.1 插件管理
- lazy.nvim 负责下载、加载、更新、清理全部插件，版本记录在 `lazy-lock.json`。
- 采用「事件 / 文件类型 / 命令」三种懒加载策略（详见第 3 节表）。
- 配置了 git 镜像（FastGit），**但该镜像已停止服务，属于隐患，见第 7 节**。

### 2.2 基础编辑器
- 行号、当前行高亮、鼠标支持、状态栏常显、光标位置显示、命令回显。
- 搜索：增量搜索、忽略大小写、高亮结果、`<leader>hl` 取消高亮。
- 缩进：Tab=4 空格；Python/C/Java 4 空格，前端 2 空格，Lua/Ruby 2 空格；自动缩进 + 智能缩进。
- 折叠：基于缩进折叠，默认全部展开；`<space>` 切换/创建折叠。
- 窗口：分屏、跳转、旋转、等宽/等高等全套快捷键（见 5.2）。
- 大文件优化：>10MB 文件自动关闭语法高亮事件、关闭 swap/undo、按只读加载。
- 杂项：插入日期/时间、切换粘贴模式、跳转 30%/50%/80% 位置、HTML 用系统浏览器预览（macOS `open`）。

### 2.3 文件查找与搜索（fzf-lua）
- `,ff` 用 fd 模糊查找文件（忽略 node_modules/venv/.git 等）。
- `,fg` 用 ripgrep 实时全文搜索；`,fb` 切换缓冲区；`,fh` 搜帮助。
- 依赖外部命令 `fd`、`fzf`（已安装）。

### 2.4 文件树（nvim-tree）
- `F2` 开关、`,ef` 定位当前文件、`,ec` 折叠全部、`,er` 刷新。
- 左侧 35 列宽，带文件/目录/Git 状态图标；忽略 node_modules、venv 等目录。

### 2.5 LSP（语言服务器）
- 框架：nvim-lspconfig + 新版 `vim.lsp.config` API（Neovim 0.11 风格）。
- Python：pyright（类型检查、补全、跳转）。Lua：lua-language-server。
- 前端：ts_ls（TS/JS/TSX）、html、cssls 均已显式配置并启用（`lua/lsp/ts_ls.lua`、`lua/lsp/html_css.lua`），与 Python/Lua 共用同一套跳转键位。
- 统一禁用 LSP 自带格式化，交给 conform.nvim。
- 统一快捷键：`,gd` 定义、`,gi` 实现、`,gr` 引用、`,K` 悬浮文档、`,rn` 重命名、`,ca` 代码操作。
- 诊断：行内小圆点标记 + 侧边符号 + 悬浮框；`[d` / `]d` 上/下一个错误，`,e` 显示错误详情。

### 2.6 补全（nvim-cmp）
- 补全源：LSP、当前缓冲区、文件路径；命令行为独立配置（`/`、`?` 用缓冲区源，`:` 用路径+命令源）。
- 键位：`Tab`/`Shift-Tab` 选择、`Enter` 确认、`Esc` 取消。
- 与 nvim-autopairs 联动：确认补全后自动补上括号。

### 2.7 格式化（conform.nvim）
- 保存时自动格式化（3 秒超时，不走 LSP fallback）；`,rf` 手动格式化。
- Python → ruff（fix + format）；Lua → stylua；JS/TS/TSX/Vue/HTML/CSS/JSON/Markdown → prettier。
- **注意：ruff 当前未安装，Python 格式化实际不可用**（见第 7 节）。

### 2.8 语法检查（nvim-lint）
- 保存后异步 lint：Python → ruff、JS/TS/Vue → eslint、Go → golangci-lint、Shell → shellcheck。
- **ruff 与 golangci-lint 当前未安装，对应语言的 lint 不可用**（见第 7 节）。

### 2.9 Treesitter 语法树
- 启动时按清单安装解析器，已装：python、rust、javascript、html、css、markdown、go、lua（共 9 个 .so，位于 `~/.local/share/nvim/site/parser`）。
- 提供更精确的语法高亮，并作为 Comment.nvim 的依赖。

### 2.10 Git 集成（gitsigns）
- 行内显示新增/修改/删除标记，支持 hunk 级操作：`]g`/`[g` 下一个/上一个变更块，`,gb` 行 blame、`,gp` 预览、`,gs` 暂存、`,gu` 取消暂存。

### 2.11 状态栏（lualine）
- 显示：模式 | git 分支/变更数/诊断数 | 文件名（含路径）| 文件类型 | 进度 | 行列位置。

### 2.12 主题
- 使用 `colors/molokai.vim`（老版自定义 molokai），深色背景，真彩色，Monaco 20 号字体。
- 官方 molokai 插件已在 `basic.lua` 中注释（因为 colors 目录自带了一份）。

### 2.13 翻译（translate-shell）
- 依赖 `brew install translate-shell` 提供的 `trans` 命令（Bing 引擎、简单模式）。
- 单词/选中文本/当前行的英译中悬浮窗；中译英通知；翻译结果插入下一行。

### 2.14 注释（Comment.nvim）
- `,cc` 行注释、`,bc` 块注释；`,c`/`,b` 为操作符前缀（如 `,cip` 注释整段）。
- **`,cc` 与 quickfix.lua 的快捷键冲突，见第 7 节。**

### 2.15 Markdown 目录（vim-markdown）
- `,toc` 打开 Markdown 标题目录（`:Toc`），窗口宽度自动适配；对应选项在 `common.lua` 中设置。
- 提供 Markdown 折叠与语法支持，按 `ft = "markdown"` 懒加载。

### 2.16 AI 补全（minuet-ai.nvim）
- as-you-type 代码补全，支持 FIM（DeepSeek/Codestral/Qwen 等）与 chat 补全（OpenAI 等），随 nvim-cmp 菜单展示。
- 模型切换：`AI_PROVIDER` 环境变量（默认 `deepseek`；`openai` 走 `openai_compatible` chat 补全），预设表在 `minuet.lua` 顶部，改后重启 nvim 或 `:Lazy reload minuet-ai.nvim` 生效。
- 快捷键：`<A-y>` 手动触发补全；接受/选择沿用 cmp 的 Tab/Enter。
- 运行中可 `:Minuet change_provider <name>` / `:Minuet change_model [provider:model]` 切换 provider 类型/模型（同类型不同端点仍需改 `AI_PROVIDER`）。

### 2.17 AI 助手（avante.nvim）
- Cursor 风格：侧栏对话、选中代码内联编辑、自动应用 diff；项目根目录放 `avante.md` 可注入项目级指令。
- 模型切换：启动时读 `AI_PROVIDER`（deepseek / openai / claude）；运行中 `:AvanteModels` 或 `:AvanteSwitchProvider` 直接切换，无需重启。
- 快捷键（`,` 为 leader）：`,aa` 提问、`,an` 新对话、`,ae` 内联编辑、`,at` 开关侧栏、`,ar` 刷新、`,ac` 添加当前文件到会话（avante 默认键位，冲突时自动跳过）。
- 依赖与构建：plenary / nui / nvim-web-devicons / render-markdown 随 lazy 自动安装；`build = "make"` 必须保留。

### 2.18 配置自维护
- `,ee` 快速打开 `init.lua`；`,ss` 重载配置（会清空 `custom.*` 等模块缓存后重新执行 `init.lua`）；保存 `init.lua` 后自动重载。
- quickfix 窗口：回车/鼠标点击跳转后自动关闭，`:cc/:cn` 等跳转命令后也会自动关闭；`,qfix` 手动关闭。

---

## 3. 插件清单与作用

| 插件 | 加载时机 | 作用 |
|---|---|---|
| folke/lazy.nvim | 启动 | 插件管理器：安装/更新/清理/版本锁 |
| ibhagwan/fzf-lua | 启动 | 文件、全文搜索、缓冲区、帮助、LSP 引用的模糊查找 |
| nvim-tree/nvim-web-devicons | 依赖 | 文件类型图标（fzf-lua / nvim-tree / lualine 共用） |
| nvim-tree/nvim-tree.lua | 启动 | 文件树侧边栏 |
| lewis6991/gitsigns.nvim | BufReadPre | Git 行内标记与 hunk 操作 |
| nvim-lualine/lualine.nvim | 启动 | 状态栏 |
| nvim-treesitter/nvim-treesitter | 启动 | 语法树高亮、解析器安装 |
| neovim/nvim-lspconfig | 按文件类型 | LSP 配置框架（pyright / lua_ls 等） |
| hrsh7th/nvim-cmp | InsertEnter | 补全框架（含 minuet AI 源） |
| hrsh7th/cmp-nvim-lsp | 依赖 | 为 LSP 提供补全 capabilities |
| hrsh7th/cmp-buffer | 依赖 | 当前缓冲区补全源 |
| hrsh7th/cmp-path | 依赖 | 文件路径补全源 |
| hrsh7th/cmp-cmdline | 依赖 | 命令行模式补全源 |
| windwp/nvim-autopairs | InsertEnter | 自动闭合括号/引号，与 cmp 联动 |
| stevearc/conform.nvim | BufWritePre | 保存时/手动格式化 |
| mfussenegger/nvim-lint | BufWritePost / BufEnter | 异步 lint |
| williamboman/mason.nvim | 执行 :Mason 时 | 安装管理 LSP/格式化/lint 等命令行工具 |
| williamboman/mason-lspconfig.nvim | 依赖 | mason 与 lspconfig 的桥接（声明管理清单） |
| numToStr/Comment.nvim | BufReadPost | 行/块注释切换 |
| preservim/vim-markdown | ft = markdown | Markdown 目录（:Toc）、折叠与语法支持 |
| milanglacier/minuet-ai.nvim | InsertEnter | AI as-you-type 补全（FIM/chat，DeepSeek/OpenAI 可切换） |
| yetone/avante.nvim | VeryLazy | Cursor 风格 AI 助手（对话/内联编辑/自动 diff） |
| nvim-lua/plenary.nvim | 依赖（avante） | Lua 通用工具库 |
| MunifTanjim/nui.nvim | 依赖（avante） | UI 组件库 |
| MeanderingProgrammer/render-markdown.nvim | ft = markdown/Avante | Markdown 渲染（对话窗口美化） |

> 注：`lua/plugins/basic.lua`（molokai 插件）与 `language.lua` 均为空占位；`prev.lua` 为兼容旧配置的空壳。

---

## 4. 插件维护指南

所有插件操作都在 Neovim 内执行（`:` 开头）。打开 Neovim 后按 `:` 输入命令。

### 4.1 更新插件

```vim
:Lazy update        " 更新全部插件（推荐，定期执行）
:Lazy update nvim-treesitter   " 只更新指定插件
:Lazy self-update   " 更新 lazy.nvim 自身
```

更新后 `lazy-lock.json` 会自动变更（这正是当前 git 工作区显示它被修改的原因），属于正常现象，应一并提交。

### 4.2 添加插件

推荐方式：在 `lua/plugins/` 下新建一个文件（如 `lua/plugins/xxx.lua`），返回 lazy 规范的表，然后在 `lua/lazyentry.lua` 的插件清单中 `require("plugins.xxx")`。

模板：

```lua
return {
  "作者/插件名",            -- GitHub 仓库
  lazy = true,              -- 懒加载（可选）
  event = "BufReadPost",    -- 触发时机：事件 / cmd / ft / keys 任选
  dependencies = { "其他插件" },
  config = function()
    require("插件名").setup({ -- 个性化配置
    })
  end,
}
```

保存后重启 Neovim（或 `:Lazy reload 插件名`），再执行 `:Lazy install`（若 `install.missing = true` 也会自动安装）。

**重要：当前 `init.lua` 中配置的 FastGit 镜像已经失效（该服务已停运），新插件安装会失败。添加插件前建议先删掉镜像配置（见第 7 节）。**

### 4.3 删除插件

1. 从 `lua/lazyentry.lua` 中移除对应 `require`（并删除 `lua/plugins/` 下对应文件）。
2. 重启 Neovim。
3. 执行 `:Lazy clean` 删除磁盘上不再被引用的插件；或 `:Lazy uninstall 插件名` 单独卸载。

### 4.4 lazy.nvim 常用命令

| 命令 | 作用 |
|---|---|
| `:Lazy` | 打开插件管理界面（`I` 安装、`U` 更新、`X` 清理、`S` 重装、`D` 卸载） |
| `:Lazy update` | 更新全部插件 |
| `:Lazy install` | 安装缺失插件 |
| `:Lazy clean` | 清理未被引用的插件 |
| `:Lazy log` | 查看更新日志 |
| `:Lazy profile` | 启动性能分析 |
| `:Lazy home` | 打开插件安装目录（`~/.local/share/nvim/lazy`） |
| `:checkhealth` | 检查 Neovim 与各插件健康状态 |

### 4.5 mason 工具管理（LSP / 格式化 / lint 工具）

```vim
:Mason             " 打开工具管理界面
:MasonInstall ruff " 安装 ruff（当前缺失，Python 格式化/lint 必需）
:MasonInstall golangci-lint
:MasonUpdate       " 更新已装工具
```

当前 mason 已安装：pyright、lua-language-server、typescript-language-server、css/html 语言服务器。

### 4.6 AI 插件维护要点（minuet / avante）

1. **API key**：只放环境变量，不要写进本仓库。推荐在 `~/.zshrc` 导出：

   ```sh
   export DEEPSEEK_API_KEY="..."
   export OPENAI_API_KEY="..."
   export AI_PROVIDER="deepseek"   # deepseek | openai | claude
   ```

2. **切换模型**：改 `AI_PROVIDER` 后重启 nvim（minuet 不重启不生效）；avante 可在运行中 `:AvanteModels` / `:AvanteSwitchProvider` 切换。
3. **avante 构建**：更新后若提示构建过期，执行 `:AvanteBuild`（或 `:Lazy build avante.nvim`）。
4. **新电脑同步**：首次 `:Lazy install` 会自动执行 avante 的 `make` 构建，需要网络；预编译下载失败时，安装 cargo 后 `:AvanteBuild source=true`。

---

## 5. 日常使用手册

`<leader>` 即 `,`。以下快捷键均为配置中实际绑定的。

### 5.1 文件与查找

| 快捷键 | 功能 |
|---|---|
| `,ff` | 模糊查找文件 |
| `,fg` | 全文实时搜索（rg） |
| `,fb` | 切换缓冲区 |
| `,fh` | 搜索帮助文档 |
| `,fr` | 查看当前符号的引用（fzf 版） |
| `F2` | 开关文件树 |
| `,ef` / `,ec` / `,er` | 文件树：定位文件 / 折叠全部 / 刷新 |
| `,wa` | 保存所有文件 |
| `,ee` | 编辑 init.lua |
| `,ss` | 重载配置 |

### 5.2 窗口操作

| 快捷键 | 功能 |
|---|---|
| `,vs` / `,sp` | 垂直 / 水平分屏 |
| `,hw` `,lw` `,kw` `,jw` | 跳到 左/右/上/下 窗口 |
| `,rw` | 旋转窗口布局 |
| `,=w` | 所有窗口等宽等高 |
| `,s_` / `,s+` | 高度减/加 20 |
| `,v_` / `,v+` | 宽度减/加 20 |

### 5.3 LSP 与诊断

| 快捷键 | 功能 |
|---|---|
| `,gd` / `,gi` / `,gr` | 跳转定义 / 实现 / 引用 |
| `,K` | 悬浮显示文档 |
| `,rn` | 重命名符号 |
| `,ca` | 代码操作（quick fix 等） |
| `,e` | 显示当前行错误详情 |
| `[d` / `]d` | 上一个 / 下一个诊断 |

### 5.4 Git

| 快捷键 | 功能 |
|---|---|
| `]g` / `[g` | 下一个 / 上一个变更块 |
| `,gb` | 当前行 git blame |
| `,gp` | 预览变更块 |
| `,gs` / `,gu` | 暂存 / 取消暂存当前变更块 |

### 5.5 编辑

| 快捷键 | 功能 |
|---|---|
| `Tab` / `Shift-Tab` | 补全菜单上/下选择 |
| `Enter`（补全中） | 确认补全 |
| `,rf` | 手动格式化（normal / visual） |
| `,cc` / `,bc` | 行注释 / 块注释 |
| `,c` + 动作 / `,b` + 动作 | 按动作注释（如 `,cip` 注释整段） |
| `<space>` | 切换折叠（normal）；创建折叠（visual） |
| `,hl` | 取消搜索高亮 |
| `,h` + 寄存器 | 播放宏（如 `,ha` 播放寄存器 a） |
| `,p` | 切换粘贴模式 |
| `,date` / `,time` | 插入当前日期 / 时间 |
| `,mo3` / `,mo5` / `,mo8` | 跳到文件 30% / 50% / 80% 处 |
| `,hml` | 用浏览器预览当前 HTML（macOS） |

### 5.6 翻译

| 快捷键 | 功能 |
|---|---|
| `,tw` | 翻译光标下单词（英→中，悬浮窗） |
| `,ts` | 翻译选中的文本（visual） |
| `,tl` | 翻译当前行 |
| `,te` | 单词中译英（通知栏显示） |
| `,ti` | 翻译并插入到下一行 |

> 悬浮窗关闭方式：把鼠标移到悬浮窗内按 `Esc` 或 `Enter`。

### 5.7 其他常用命令

| 命令 | 用途 |
|---|---|
| `:LspInfo` | 查看当前文件启用的 LSP |
| `:ConformInfo` | 查看当前文件可用的格式化器 |
| `:Mason` | 工具管理界面 |
| `:Lazy` | 插件管理界面 |
| `:checkhealth` | 健康检查（装完新工具后建议跑一次） |
| `:TSInstall python` 等 | 按需安装 treesitter 解析器（当前已装 9 个，一般不需要） |

### 5.8 AI 补全与助手

| 快捷键 / 命令 | 功能 |
|---|---|
| `<A-y>` | 手动触发 minuet AI 补全 |
| `,aa` / `,an` / `,ae` | avante 提问 / 新对话 / 内联编辑选中代码 |
| `,at` / `,ar` / `,ac` | avante 开关侧栏 / 刷新 / 添加当前文件 |
| `:AvanteModels` / `:AvanteSwitchProvider` | avante 运行中切换模型 / provider |
| `:Minuet change_provider <name>` | minuet 切换 provider 类型 |
| `:Minuet change_model [provider:model]` | minuet 切换模型 |

### 5.9 典型工作流

- **Python**：打开 `.py` → pyright 自动启动（类型检查、补全）→ 写代码用 `Tab` 补全 → `,gd` 跳转、`,K` 看文档 → 保存时 conform 调用 ruff 格式化（**需先安装 ruff**）→ `]d` 逐个查看错误，`,e` 看详情，`,ca` 修复。
- **前端（JS/TS/Vue/HTML/CSS）**：`F2` 开文件树，`,ff` 找文件，`,fg` 搜代码；eslint/prettier 已装，保存自动格式化和 lint。
- **Lua（改自己的配置）**：`,ee` 打开 init.lua → 修改后保存自动重载 → stylua 格式化、lua_ls 检查；新增插件按第 4.2 节操作。
- **日常 Git**：`:G` 系列命令**未配置**（无 fugitive），Git 操作建议在终端完成；编辑时用 `]g`/`[g` 浏览改动，`,gs` 暂存单个 hunk。

---

## 6. 外部依赖（环境要求）

| 工具 | 用途 | 状态 |
|---|---|---|
| fd、fzf | fzf-lua 查找 | ✅ 已装（/usr/local/bin） |
| trans（translate-shell） | 翻译功能 | ✅ 已装 |
| stylua | Lua 格式化 | ✅ 已装 |
| lua-language-server | Lua LSP | ✅ 已装 |
| luacheck | Lua 静态检查 | ✅ 已装 |
| pyright | Python LSP | ✅ 已装（mason） |
| typescript-language-server / html / css | 前端 LSP | ✅ 已装（mason） |
| prettier | 前端格式化 | ✅ 已装 |
| eslint | JS/TS lint | ✅ 已装 |
| shellcheck | Shell lint | ✅ 已装 |
| curl | minuet 请求后端 | ✅ 系统自带 |
| make / gcc | avante 构建 | ✅ 已装（首次构建用预编译组件） |
| DEEPSEEK_API_KEY / OPENAI_API_KEY / ANTHROPIC_API_KEY | AI 插件密钥（环境变量） | ✅ 已配置（~/.bamboo_profile + /data/shell/key.sh，600 权限） |
| ollama | minuet/avante 本地模型（可选） | ❌ 未安装（需要时 `brew install ollama`） |
| **ruff** | Python 格式化 + lint | ❌ **未安装** |
| **golangci-lint** | Go lint | ❌ **未安装** |

安装缺失工具：

```sh
:MasonInstall ruff golangci-lint   " 在 nvim 内执行
# 或命令行安装
brew install ruff golangci-lint
```

---

## 7. 发现的问题与建议

### 7.1 高危

1. **FastGit 镜像已失效（已修复）**：`init.lua` 中设置的 `hub.fastgit.xyz` 镜像服务早已停运。该镜像配置已于 2026-08-09 移除，现在恢复 lazy.nvim 默认的官方 GitHub 源，新插件可以正常安装。
2. **ruff 未安装**：conform 的 Python 格式化（`ruff_fix` + `ruff_format`）与 nvim-lint 的 Python 检查都会静默失败，保存 Python 文件时格式化实际不生效。执行 `:MasonInstall ruff` 即可修复。
3. **golangci-lint 未安装**：Go 文件 lint 不可用（配置里有，环境里没有）。

### 7.2 中危（功能失效 / 键位冲突）

4. **`,cc` 键位冲突（已修复）**：quickfix 侧已改绑为 `,cq`，不再与 Comment.nvim 的 `,cc` 冲突；顺带修正了 `,cq` 原先误绑定 `:cq`（带错误码退出）的问题，现在是一键跳转+关闭。
5. **`,toc` 失效（已修复）**：已通过 lazy 安装 `preservim/vim-markdown`（`ft = "markdown"` 懒加载），`:Toc` 命令可用，`,toc` 恢复打开 Markdown 目录。
6. **`,ss` 重载不彻底（已修复）**：`reload.lua` 现在会清空 `custom.*`、`prev`、`lazyentry`、`bamboo` 的模块缓存后重新执行 `init.lua`；`lazyentry.lua` 通过 `lazy_did_setup` 跳过 lazy 重复初始化；自动命令改用命名 augroup（clear=true），不会随重载堆叠。
7. **Java 声明与实现不符**：`CLAUDE.md` 声称支持 Java 开发，但配置中没有 jdtls、没有 Java treesitter 解析器。要么补上 jdtls，要么改文档。
8. **前端 LSP 键位缺失（已修复）**：mason-lspconfig 的 `automatic_enable` 会默认启用已安装的 ts_ls/html/cssls，但用的是默认配置、未挂载自定义 `on_attach`，导致 `,gd` 等键位在 TS/HTML/CSS 中不存在（Python/Lua 正常）。已新增显式配置并复用 `lsp.init` 的键位与 capabilities。
9. **quickfix 回车跳转失效（已修复）**：原实现用 `:normal! <CR>` 触发跳转，但键码不会被执行，导致选中引用后原地不动；且尝试用 `feedkeys` 修复时默认会重新映射按键，造成递归崩溃。现改为 `feedkeys(..., "nx")`（不重映射 + 立即执行）触发内置跳转，回车/鼠标点击/`,cq` 均已实测可跳到所选条目并自动关闭窗口。

### 7.3 低危（清理项）

10. **旧 vim-plug 残留（已清理）**：`~/.local/share/nvim/plugged/`（约 95MB）已移至 `~/.local/share/nvim/plugged.bak-20260809` 备份，未直接删除，确认无误后可手动移除该备份目录。
11. **`translate.nvim.cloning` 残留（已删除）**：`~/.local/share/nvim/lazy/` 下 0 字节的克隆失败残留文件已移除。
12. **`.nvimlog` 未忽略（已修复）**：日志文件已删除，并新增仓库级 `.gitignore`（忽略 `.nvimlog` 与 `*.swp`）。
13. **`colors/.molokai.vim.swp` 残留（已删除）**：vim 交换文件已移除。
14. **README / CLAUSE.md 部分过时（已更新）**：目录结构中的 `lua/format/` 已移除并改为指向 `lua/plugins/conform.lua`；treesitter 说明改为「解析器由配置启动时自动安装」。
15. **fzf-lua grep 排除规则（已修复）**：经实测，单引号会被 shell 正确解析，真正的坑是 ripgrep 的 glob 语义——当搜索根为绝对路径时，`!dir/**` 无法排除子目录，需写成 `!**/dir/**`。`lua/plugins/fzf.lua` 已改用修正后的 glob 模式，实测排除生效。

### 7.4 AI 插件（2026-08-09 新增）

16. **API key 配置（已修复）**：minuet/avante 默认读 `DEEPSEEK_API_KEY`，切 OpenAI 需 `AI_PROVIDER=openai` + `OPENAI_API_KEY`。key 由 `~/.zshrc` → `~/.bamboo_profile` → `/data/shell/key.sh` 注入；已修复 `DEEPSEEK_API_KEY` 自引用 bug 并收紧文件权限为 600。密钥不要提交到本 git 仓库（也可用 direnv / macOS Keychain 管理）。
17. **avante 构建依赖网络**：首次安装已在本机完成；换机器同步后 `:Lazy install` 会重新执行 `build = "make"`（下载预编译组件，约 12MB）。若下载失败，需安装 cargo 后执行 `:AvanteBuild source=true`。

---

## 8. 整体总结

这是一套结构清晰、现代感十足的 Neovim 配置：

- **架构**：lazy.nvim 统一管理插件，配置按「plugins（插件）/ lsp（语言）/ custom（自写逻辑）」三块拆分，`lazy-lock.json` 保证版本可复现，`init.lua` 只做装配，改动成本低。
- **能力**：覆盖了日常开发的完整链路——查找（fzf-lua + 文件树）、编辑（补全/括号/注释/折叠）、质量（LSP 诊断、格式化、lint）、版本控制（gitsigns）、AI（minuet 补全 + avante 助手）、体验（状态栏、主题、翻译、快速重载）。Python、Lua、前端（JS/TS/HTML/CSS）是实际可用的主力环境。
- **当前健康度**：配置可正常启动（约 0.25s），大部分功能在线；但有三个真实断点需要处理：FastGit 镜像失效（影响加插件）、ruff 缺失（影响 Python 格式/lint）、`,cc` 键位冲突。清理后这套配置会处于很稳定的状态。

一句话：**这是一套“lazy + LSP + treesitter”体系的标准现代配置，底子很好；维护时优先处理镜像、补齐 ruff，其余按第 4 节的流程增删插件即可。**
