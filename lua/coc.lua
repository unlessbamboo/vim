----------------------------------------------------------
-- 选取需要的coc.nvim官网推荐的配置
----------------------------------------------------------

-- 关闭备份功能, 避免在保存文件时产生备份文件
vim.opt.backup = false
vim.opt.writebackup = false

-- 加快代码检查和更新的频率，提高用户体验
vim.opt.updatetime = 300

-- 总是显示 signcolumn，防止诊断信息出现时导致文本内容移动
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- 定义了一个函数 _G.check_back_space()，用于检查是否需要进行自动补全
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation(重要)
-- 代码导航跳转: 定义, 类型定义, 实现, 引用
keyset("n", "<leader>jd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "<leader>jy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "<leader>ji", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "<leader>jr", "<Plug>(coc-references)", {silent = true})


-- 执行 show_docs 函数来显示代码的文档信息(定义)
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "<leader>sk", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- 对选中的代码进行格式化，使其按照代码风格规范排版(可视模式和普通模式)
--[[
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
]]

-- 当你执行格式化操作时，Coc.nvim 插件会调用 formatSelected 动作来格式化选中的代码
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- 在代码中使用类似 coc#on_enter() 来跳转到占位符位置时，触发并执行动作来显示相关的签名帮助信息
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})


--[[
-- :format, 执行该命令将会对当前缓冲区进行代码格式化
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
-- :fold, 执行该命令可以折叠当前缓冲区的代码, 可以携带一个参数表示层级
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
-- :runCommand, 执行该命令可以对当前缓冲区的导入语句进行整理和排序
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
]]
