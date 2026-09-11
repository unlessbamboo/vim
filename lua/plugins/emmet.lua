--[[
用途：HTML/CSS 快速输入（emmet-vim），按 filetype 延迟加载，无外部依赖（纯 vimscript）。
用法：insert 模式输入缩写后按展开键。
  生成 HTML5 骨架：输入 html:5 后按 <C-y>,（leader 前缀 <C-y> + 逗号）
  其它：div#foo>span.bar 之类缩写的展开、标签包裹、注释切换等都用同一前缀
快捷键前缀：<C-y>（emmet 默认 leader，展开键是 <C-y>,）
]]
return {
	{
		"mattn/emmet-vim",
		ft = { "html", "css", "xml", "htmldjango", "eruby" },
		init = function()
			-- 展开前缀，insert 模式下 html:5 + <C-y>, 生成 HTML5 骨架
			vim.g.user_emmet_leader_key = "<C-y>"
			-- 插件加载时对所有 buffer 安装映射（不写也默认开启，显式声明便于阅读）
			vim.g.user_emmet_install_global = 1
		end,
	},
}
