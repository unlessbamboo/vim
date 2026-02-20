-- 允许 Neovim 全局变量
globals = { "vim" }
-- 忽略的规则
ignore = {
  "unused-local", -- 忽略未使用的局部变量
  "empty-line-with-spaces", -- 忽略仅空格的空行
  "trailing-space", -- 忽略行尾空格
}
-- 启用的规则
enable = { "undefined-global", "unused-function" }
