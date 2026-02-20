return {
  -- 插件分组：工具类
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
