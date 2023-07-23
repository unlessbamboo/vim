-- lua配置相关的root配置, 其会被init.vim引用

-----------------------1. 基本配置-----------------------------
-- require("basic")


----------------------2. 插件------------------------------
-- a. 跳转(coc.nvim)
require("coc")

-- b. 注释
require('Comment').setup({
    -- 是否在注释符号和行之间添加空格
    padding = true,
    -- 注释后光标是否保持在原位置
    sticky = true,
    -- 在执行注释/取消注释时要忽略的行
    ignore = nil,
    ---在 NORMAL 模式下用于切换注释的键映射
    toggler = {
        ---Line-comment toggle keymap
        line = ',cc',
        ---Block-comment toggle keymap
        block = ',bc',
    },
    -- 在 NORMAL 和 VISUAL 模式下用于操作注释的键映射
    opleader = {
        ---Line-comment keymap
        line = ',c',
        ---Block-comment keymap
        block = ',b',
    },
    -- 用于额外的注释操作的键映射，例如在上面一行、下面一行或行尾添加注释
    extra = {
        ---在上面一行插入一个注释语句
        above = ',cO',
        ---在光标的下面一行插入一个注释语句
        below = ',co',
        ---Add comment at the end of line
        eol = ',cA',
    },
    -- 在注释之前调用的函数
    pre_hook = nil,
    -- 在注释之后调用的函数
    post_hook = nil,
})
