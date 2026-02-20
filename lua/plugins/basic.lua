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
    "godlygeek/tabular", -- 文本对齐（markdown 依赖）
    lazy = true,
    cmd = "Tabularize",
  },
  {
    "powerline/powerline", -- 状态栏
    lazy = false, -- 启动时加载（状态栏需全局生效）
  },
  -- 2026-02-19 09:30:11: 本身colors目录下就自带了一套,先注释
  --[[ { 
    "tomasr/molokai", -- Molokai 配色插件（核心）
    lazy = false,
  }, ]]
}
