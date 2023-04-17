
1. 目录结构

功能: nvim基础配置
目录介绍:

```sh
.
├── coc-settings.json
├── init.vim
├── lua
│   ├── bamboo.lua
│   ├── basic.lua
│   ├── keybindings.lua
│   └── plugins.lua
└── readme.md
```

其中entrypoint可以是`init.vim`或`init.lua`, 一般在该这里导入其他的lua文件, 这些lua文件默认是放在lua文件夹下的:

+ basic.lua: 基础配置
+ keybindings.lua: 配置按键映射
+ lsp.lua: 配置LSP
+ options.lua: 选项配置, 见下面介绍
+ plugins.lua: 配置插件
 
config用于存放各种插件自身的配置, 其中文件名格式一般为``nvim-pluginName.lua``.


2. 选项配置

在nvim和vim中, 选项配置的变量值是不一样的, 下面主要介绍`vim.g, vim.opt, vim.cmd`在两者之间的不同之处

+ vim.g: 类似vim中的g, vim中配置`let g:foo=bar`, 其等价于nvim中`vim.g.foo=bar`配置
+ vim.opt: 类似vim中的局部变量, vim中配置`set foo=bar`, 其等价于nvim中的`vim.opt.foo=bar`配置
+ vim.mcd: 类似vim中的脚本, vim中的配置`some_vim_script`, 其等价于nvim中的`vim.cmd(some_vim_script)`配置

下面是vim中常见的配置转为nvim的例子

```lua
-- tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vi.opt.expandtab = 4
```

3. 按键配置
nvim中的按键配置也不同于vim, 在vim中使用`mode key action`来进行键的映射, 而在nvim中使用`vim.keymap.set(<mode>, <key>, <action>, <opts>)`进行快捷键的映射. 
下面是nvim中的一些快捷键映射

```lua
-- 通用选项
local opts = {
    noremap = true,
    silent = true,
}

-- 绑定
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
```


参考:

+ [从0开始配置nvim](https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/)
