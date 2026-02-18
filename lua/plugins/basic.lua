return {
  -- 插件分组：窗口/缓冲区管理
  {
    "vim-scripts/winmanager", -- 窗口管理
    lazy = true, -- 懒加载，按需启用
    cmd = { "WMToggle", "WMFocus" }, -- 仅执行这些命令时加载
  },
  {
    "scrooloose/nerdtree", -- 树形文件浏览器
    lazy = true,
    cmd = { "NERDTreeToggle", "NERDTree" },
  },
  {
    "jlanzarotta/bufexplorer", -- 缓冲区浏览
    lazy = true,
    cmd = { "BufExplorer", "BufExplorerHorizontal" },
  },
  -- 插件分组：工具类
  {
    "vim-scripts/genutils", -- 通用工具函数
    lazy = true,
  },
  {
    "yianwillis/vimcdoc", -- 中文文档
    lazy = true,
    cmd = "HelpDoc",
  },
  {
    "tpope/vim-fugitive", -- Git 集成
    lazy = true,
    cmd = { "Git", "Gstatus", "Gcommit", "Gblame" },
  },
  {
    "junegunn/fzf", -- 模糊搜索
    lazy = true,
    build = "./install --bin", -- 仅安装二进制文件
    cmd = "FZF",
  },
  {
    "junegunn/fzf.vim", -- fzf vim 集成
    lazy = true,
    dependencies = { "junegunn/fzf" },
    cmd = { "Files", "Buffers", "Rg" },
  },
  {
    "godlygeek/tabular", -- 文本对齐（markdown 依赖）
    lazy = true,
    cmd = "Tabularize",
  },
  {
    "powerline/powerline", -- 状态栏
    lazy = false, -- 启动时加载（状态栏需全局生效）
  },
  { 
    "tomasr/molokai", -- Molokai 配色插件（核心）
    lazy = false,
  },
  {
    "numToStr/Comment.nvim", -- 代码注释（依赖 treesitter）
    lazy = true,
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("Comment").setup() -- 默认配置，满足基础注释需求
    end,
  },
}
