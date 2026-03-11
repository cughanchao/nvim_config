-- basic settings
vim.opt.encoding = "UTF-8"
-- vim.opt.fileencoding = "UTF-8"
vim.opt.fileencodings = "utf-8,gbk,gb2312,gb18030"

vim.opt.number = true -- 显示绝对行号
-- vim.opt.relativenumber = true -- 显示相对行号（方便跳转）
vim.opt.cursorline = true -- 高亮光标所在行
vim.opt.signcolumn = "yes" -- 始终显示符号列（避免代码偏移）
vim.opt.colorcolumn = "100" -- 80列处显示竖线（代码长度规范）

-- 1. 缩进基础规则
vim.opt.tabstop = 4 -- 制表符(Tab)显示为4个空格宽度
vim.opt.softtabstop = 4 -- 按Tab时插入的空格数
vim.opt.shiftwidth = 0 -- 自动缩进/>>/<< 时的缩进宽度,0表示继承tabstop
vim.opt.shiftround = true -- 缩进对齐到 shiftwidth 倍数
vim.opt.expandtab = true -- 将Tab转换为空格（推荐，跨编辑器兼容）
vim.opt.smarttab = true -- 智能Tab：行首按Tab用shiftwidth，其他用softtabstop

-- 2. 自动缩进开关
vim.opt.autoindent = true -- 新行继承上一行的缩进（基础）
vim.opt.smartindent = true -- 智能缩进（对C类语言友好，如if后自动缩进）
vim.opt.cindent = true -- C语言风格缩进（增强smartindent）
vim.opt.wrap = false -- 关闭行换行（避免缩进错乱）

-- 3. 可视化辅助（可选，便于查看缩进）
vim.opt.list = true -- 显示不可见字符（Tab/空格）
vim.opt.listchars = { -- 自定义不可见字符显示样式
  tab = "→ ", -- Tab显示为 → + 空格
  trail = "·", -- 行尾多余空格显示为 ·
  space = " ", -- 普通空格不特殊显示
}

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.showmode = false

vim.opt.autoread = true -- 文件外部修改时自动读取

vim.opt.mouse = "a" -- 所有模式启用鼠标
vim.opt.mousemodel = "extend" -- 鼠标选择模式（扩展选择）
vim.opt.backup = false -- 关闭备份文件
vim.opt.writebackup = false -- 写入时不创建备份
vim.opt.swapfile = false -- 关闭交换文件（避免生成 .swp）

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true -- 启用真彩色（支持现代配色方案）

vim.opt.splitbelow = true -- 在下方分屏
vim.opt.splitright = true --  在右侧分屏

vim.opt.clipboard = "unnamedplus"

-- ===================== 不同文件类型的缩进配置 =====================
local indent_settings = vim.api.nvim_create_augroup("IndentSettings", { clear = true })

-- Lua: 2空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  group = indent_settings,
})

-- Python: 4空格缩进（PEP 8标准）
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
  group = indent_settings,
})

-- C/C++: 4空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
  group = indent_settings,
})

-- JavaScript/TypeScript/JSON: 2空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "json", "jsonc", "jsx", "tsx" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  group = indent_settings,
})

-- HTML/CSS/YAML: 2空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "scss", "yaml", "yml", "xml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  group = indent_settings,
})

-- Makefile: 使用真实Tab（不转换为空格）
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false -- Makefile必须用Tab
  end,
  group = indent_settings,
})

require("config.lazy")
