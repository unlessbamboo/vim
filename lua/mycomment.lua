require('Comment').setup({
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = ',cc',
        ---Block-comment toggle keymap
        block = ',bc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = ',c',
        ---Block-comment keymap
        block = ',b',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = ',cO',
        ---Add comment on the line below
        below = ',co',
        ---Add comment at the end of line
        eol = ',cA',
    },
})
