
### 1 术语
1. lsp
LSP是Language Server Protocol的缩写, 它是一种为编辑器和IDE提供语言服务的协议. 它的目标是将语言智能与编辑器/IDE解耦, 使得多种编辑器/IDE可以共享一些通用的语言服务，从而减少语言实现的重复工作，加速语言实现的迭代速度，为开发者提供更好的开发体验。

目前流行的lsp插件有: `coc.nvim, vim-lsp, LanguageClient-neovim`, 关于`coc.nvim`和`vim-lsp`的区别, 知乎上有如下说明:

+ 性能上因为 nvim-lsp 不需要远程通讯大概更好一点，不过主要取决于 language server
+ 稳定性上已有功能应该都比较稳定了
+ 使用体验上 coc.nvim 的补全和错误提示是直接提供的，上手相对容易，但是在定制方面因为coc.nvim 主要基于配置文件只提供了有限的设置，不如 nvim-lsp 那么灵活透明

目前作者先使用`coc.nvim`.


### 2 配置
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

### 3 coc
1. coc本身并不提供具体语言的补全功能，更多的只是提供了一个补全功能的平台，所以在安装完成后，我们需要安装具体的语言服务以支持对应的补全功能。 例如安装JSON相关插件

```vim
" 注意: coc-tsserver同时支持javascript和typescript
CocInstall coc-json coc-html coc-css coc-tsserver
```

此时该插件会被安装到`~/.config/coc/extensions/node_modules/coc-json`目录下, 此时可以通过`CocList extensions`查看当前已经安装的coc插件. 另外, 可以通过[地址](https://www.npmjs.com/search?q=keywords:coc.nvim)获取当前支持的coc.nvim子插件. 

1) coc自插件管理工具`coc-marketplace`(有点卡, 也不太全), 其命令如下:

```vim
" 1. 安装
CocInstall coc-marketplace

" 2. 管理
CocList marketplace

" 3. 搜索python相关, 然后选择即可管理
CocList marketplace python
```

2) 通过coc.nvim官网的文档查看支持的插件: [coc.extensions](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)

### 4 plugins

+ bamboo.vim: 自定义
+ filebuff.vim: 文件缓冲区配置
+ plugins.vim: 插件配置
+ colors.vim: 配色配置


参考:

+ [从0开始配置nvim](https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/)
