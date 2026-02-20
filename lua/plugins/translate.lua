--[[
旧世界遗址: 删除vim-doc中文文档插件
新世界风景: 通过安装brew install translate-shell来进行终端翻译
按键:
  ,tw: 翻译光标下的单词
  ,ts: 翻译选中的文本
  ,tl: 翻译当前行

注意,如果想关闭翻译弹框,则需要光标移动到弹框之后再按ESC
--]]

local M = {}

-- 核心翻译函数（封装重复逻辑）
local function translate_text(text, from_lang, to_lang)
  if text == "" then
    vim.notify("无翻译文本！", vim.log.levels.WARN)
    return ""
  end

  -- 处理特殊字符，避免命令执行失败
  local safe_text = text:gsub("'", "'\\''")
  local cmd = string.format("trans -e bing -b %s:%s '%s'", from_lang, to_lang, safe_text)
  local handle = io.popen(cmd)
  if not handle then
    vim.notify("翻译工具调用失败，请检查 translate-shell 是否安装！", vim.log.levels.ERROR)
    return ""
  end

  local result = handle:read("*a")
  handle:close()
  return result:gsub("\n", "") -- 去除换行符
end

-- 显示悬浮窗口（封装）
local function show_float_win(content)
  local lines = vim.split(content, "\n")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  -- 计算窗口大小
  local width = math.min(80, vim.fn.winwidth(0) - 10)
  local height = math.min(10, #lines)
  -- 打开悬浮窗口
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  })
  -- 绑定关闭快捷键(必须把鼠标移动到悬浮框再按ESC)
  vim.keymap.set("n", "<ESC>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<CR>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf, noremap = true, silent = true })
end

-- 初始化翻译快捷键
function M.setup()
  local opts = { noremap = true, silent = true }

  -- 1. 翻译光标下单词（英→中）
  vim.keymap.set("n", "<leader>tw", function()
    local word = vim.fn.expand("<cword>")
    local result = translate_text(word, "en", "zh")
    if result ~= "" then
      -- vim.notify(string.format("%s → %s", word, result), vim.log.levels.INFO)
      show_float_win(string.format("%s → %s", word, result))
    end
  end, opts)

  -- 2. 翻译选中文本（英→中）
  vim.keymap.set("v", "<leader>ts", function()
    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")
    local text = vim.api.nvim_buf_get_text(0, start_pos[1]-1, start_pos[2], end_pos[1]-1, end_pos[2]+1, {})
    text = table.concat(text, "\n")
    local result = translate_text(text, "en", "zh")
    if result ~= "" then
      -- vim.notify(string.format("选中文本翻译：%s", result), vim.log.levels.INFO)
      show_float_win(result)
    end
  end, opts)

  -- 3. 翻译当前行（英→中）
  vim.keymap.set("n", "<leader>tl", function()
    local line = vim.api.nvim_get_current_line()
    local result = translate_text(line, "en", "zh")
    if result ~= "" then
      -- vim.notify(string.format("当前行翻译：%s", result), vim.log.levels.INFO)
      show_float_win(result)
    end
  end, opts)

  -- 4. 反向翻译（中→英）
  vim.keymap.set("n", "<leader>te", function()
    local word = vim.fn.expand("<cword>")
    local result = translate_text(word, "zh", "en")
    if result ~= "" then
      vim.notify(string.format("%s → %s", word, result), vim.log.levels.INFO)
    end
  end, opts)

  -- 5. 翻译并插入到下一行（可选）
  vim.keymap.set("n", "<leader>ti", function()
    local word = vim.fn.expand("<cword>")
    local result = translate_text(word, "en", "zh")
    if result ~= "" then
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, { "-- " .. result })
    end
  end, opts)
end

-- 导出模块
return M
