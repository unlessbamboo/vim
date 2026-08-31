# vim（旧配置存档分支）

> ⚠️ **这个分支（`oldvim`）是旧版 Vim 配置的存档，已停止维护。**
>
> 当前在用的配置是 Neovim 版，在 **`main` 分支**。日常使用请切到 `main`：
>
> ```sh
> git checkout main
> ```

---

## 这个分支是什么

- 基于 `.vim` 目录的传统 Vim 配置，补全走 YouCompleteMe。
- 与 `main` 分支（Neovim + lazy.nvim + 原生 LSP + treesitter）**没有共同历史**，是两套独立的配置。
- 保留在这里仅作备份和参考，不再更新。原 GitHub 默认分支 `master` 的内容即此分支。

## 历史

- 2016-07-22：改用 YouCompleteMe，旧配置备份在本分支（`Backup old vim configure at this branch`）。
- 2026-02-15：适配较新版本 Neovim 时的最后一批调整；删除 UltiSnips（报找不到 python 解释器）。
- 2026-08-31：仓库主线切换到 Neovim 配置（`main` 分支），本分支转为存档。

## 目录说明

| 路径 | 说明 |
| --- | --- |
| `.vimrc` | 主配置入口 |
| `autoload/` | 按需加载的 Vimscript 函数 |
| `colors/` | 配色方案 |
| `config/` | 拆分出来的分模块配置 |
| `ftplugin/` | 按文件类型的配置 |
| `plugin/` | 启动即加载的插件脚本 |
| `doc/` | 帮助文档 |
| `mycscope.sh` | cscope 索引脚本 |
| `.editorconfig` / `.flake8` / `.pylintrc*` / `.eslintrc.js` / `.proselintrc` / `.tidy.conf` | 各语言 linter / 格式化配置 |

## 启用方式（如需回退到旧 Vim 配置）

```sh
# 备份现有 ~/.vim 后
git clone -b oldvim git@github.com:unlessbamboo/vim.git ~/.vim
```
