return {
  {
    "vim-scripts/bash-support.vim", -- bash 语法支持
    lazy = true,
    ft = { "sh", "bash" }, -- 仅打开 sh/bash 文件时加载
  },
  {
    "cespare/vim-toml", -- toml 语法支持
    lazy = true,
    ft = "toml",
  },
  {
    "preservim/vim-markdown", -- markdown 语法支持
    lazy = true,
    ft = "markdown",
    dependencies = { "godlygeek/tabular" }, -- 依赖 tabular 插件
  },
  {
    "mattn/emmet-vim", -- HTML/JS/CSS 快速编写
    lazy = true,
    ft = { "html", "css", "javascript", "vue" },
  },
  {
    "fatih/vim-go", -- go 开发工具
    lazy = true,
    ft = "go",
    build = ":GoUpdateBinaries", -- 安装后自动更新二进制工具
  },
  {
    "Vimjas/vim-python-pep8-indent", -- python 缩进规范
    lazy = true,
    ft = "python",
  },

}
