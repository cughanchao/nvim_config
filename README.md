# Neovim 配置文档

现代化的 Neovim 配置，专注于 Python 和 C/C++ 开发，提供完整的 IDE 体验。

## 目录

- [快速开始](#快速开始)
- [核心功能](#核心功能)
- [插件列表](#插件列表)
  - [UI & 外观](#ui--外观)
  - [代码智能 & LSP](#代码智能--lsp)
  - [代码质量](#代码质量)
  - [Git 集成](#git-集成)
  - [搜索 & 导航](#搜索--导航)
  - [编辑增强](#编辑增强)
  - [语言特定](#语言特定)
- [快捷键速查](#快捷键速查)
- [环境要求](#环境要求)

---

## 快速开始

### 安装

```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# 克隆本配置
git clone <your-repo-url> ~/.config/nvim

# 启动 Neovim（会自动安装插件）
nvim
```

### 初次启动

1. 插件会通过 [lazy.nvim](https://github.com/folke/lazy.nvim) 自动安装
2. 运行 `:checkhealth` 检查配置状态
3. 运行 `:Mason` 安装所需的 LSP 服务器

---

## 核心功能

- ✨ **现代化 UI** - 美观的主题、状态栏、标签栏和文件树
- 🚀 **快速补全** - 基于 Rust 的 blink.cmp 引擎
- 🔍 **强大搜索** - Telescope 模糊查找 + Spectre 全局替换
- 📝 **智能编辑** - 自动配对、注释、折叠、缩进
- 🐛 **完整调试** - Python DAP 调试器，支持断点、变量查看
- 🎨 **Git 集成** - 行内 blame、diff 视图、LazyGit 界面
- 🧪 **代码质量** - 自动格式化（conform）+ 实时 lint（nvim-lint）
- 🎯 **LSP 增强** - Lspsaga 提供美化的代码动作、重命名、诊断

---

## 插件列表

### UI & 外观

#### 🎨 [monokai.nvim](https://github.com/tanvirtin/monokai.nvim)

**配色方案** - Monokai Pro 配色

- 支持浅色和深色背景
- 与所有插件完美集成

#### 📑 [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

**缓冲区标签栏** - 顶部显示打开的缓冲区

```lua
<leader>1         -- 跳转到缓冲区 1
<leader>w         -- 关闭当前缓冲区
<leader>bl/bh     -- 下一个/上一个缓冲区
```

#### 📊 [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

**状态栏** - 美观的底部状态栏

- 显示模式、分支、diff、诊断、文件信息
- 自动适配主题

#### 📏 [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)

**缩进参考线** - 可视化缩进层级

- 高亮当前作用域
- Treesitter 集成

#### 🌲 [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)

**文件浏览器** - 侧边栏文件树

```lua
<leader>e         -- 切换文件树
<leader>fe        -- 聚焦文件树
```

#### 🎭 [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)

**代码折叠** - 现代化折叠插件

```lua
zo/zc/za          -- 打开/关闭/切换折叠
zR/zM             -- 打开/关闭所有折叠
K                 -- 预览折叠内容
<leader>z0-z9     -- 快速跳转到折叠层级
```

- 基于 Treesitter 的智能折叠
- 显示折叠行数预览

#### 🔔 [noice.nvim](https://github.com/folke/noice.nvim)

**UI 增强** - 命令行、消息、通知的全面改造

```lua
<leader>nm        -- 查看所有消息
<leader>nl        -- 查看最后一条消息
<leader>nd        -- 关闭所有通知
<leader>ne        -- 查看错误消息
```

- 弹出式命令行
- 美观的通知系统
- LSP 进度显示

#### 🎨 [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)

**颜色预览** - 显示颜色代码的实际颜色

```lua
<leader>ct        -- 切换颜色预览
<leader>cr        -- 重新加载
```

- 支持 RGB、HSL、Tailwind
- 背景模式高亮

#### 🌈 [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)

**彩虹括号** - 为嵌套括号着色

- Treesitter 集成
- 自动匹配对应括号

#### 📜 [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)

**滚动条** - 增强滚动条显示

- Git 变更标记
- LSP 诊断标记
- 搜索结果标记

#### 🔧 [nvim-autopairs](https://github.com/windwp/nvim-autopairs)

**自动配对** - 自动关闭括号、引号

- Treesitter 智能配对
- 语言特定规则

#### 💬 [Comment.nvim](https://github.com/numToStr/Comment.nvim)

**智能注释** - 快速切换注释

```lua
<C-/>             -- 切换注释（普通/可视模式）
gcc               -- 注释当前行
gc                -- 注释选区
```

- Treesitter 上下文感知
- 多语言支持

#### 📝 [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)

**TODO 高亮** - 高亮和管理 TODO 注释

```lua
]t / [t           -- 下一个/上一个 TODO
<leader>tl        -- 查找所有 TODO
```

- 支持 TODO、FIXME、HACK、WARN、PERF、NOTE、TEST
- 符号列图标

#### ❓ [which-key.nvim](https://github.com/folke/which-key.nvim)

**快捷键提示** - 显示可用快捷键

- 按下前缀键（如 `<Space>`）300ms 后显示
- 按功能分组的快捷键
- 完整文档

---

### 代码智能 & LSP

#### 🛠️ [mason.nvim](https://github.com/williamboman/mason.nvim)

**LSP 安装器** - 管理 LSP 服务器、DAP、linter、formatter

```lua
<leader>lsp       -- 打开 Mason 界面
```

- 可视化安装界面
- 自动安装配置的服务器

#### 🔌 [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

**LSP 配置** - 配置内置 LSP 客户端

已配置的语言服务器：

- **Lua** - lua_ls（Neovim API 支持）
- **Python** - pyright（性能优化）
- **C/C++** - clangd（clang-tidy 集成）
- **CMake** - cmake
- **YAML** - yamlls
- **Bash** - bashls

#### 🎯 [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim)

**LSP 增强 UI** - 美化的 LSP 功能界面

```lua
K                 -- 悬停文档
gd / gD           -- 跳转/预览定义
gt / gT           -- 跳转/预览类型定义
gr / gR           -- 查找引用
gl / gL           -- 显示诊断
[e / ]e           -- 上一个/下一个诊断
[E / ]E           -- 上一个/下一个错误
<leader>ca        -- 代码动作
<leader>rn        -- 重命名符号
<leader>o         -- 切换大纲
<leader>tt        -- 切换终端
```

- 代码动作灯泡
- 美观的重命名 UI
- 悬浮终端
- 符号大纲
- 调用层级

#### ⚡ [blink.cmp](https://github.com/Saghen/blink.cmp)

**补全引擎** - 基于 Rust 的快速补全

```lua
<Tab>             -- 接受补全/跳出括号/触发
<C-n>/<C-p>       -- 下一个/上一个项目
```

- 超级 Tab 模式
- LSP、路径、片段、缓冲区源
- 智能 Tab 行为
- 命令行补全

#### 📚 [lazydev.nvim](https://github.com/folke/lazydev.nvim)

**Lua 开发** - Neovim Lua API 补全

- Vim API 类型定义
- Luvit 元数据支持
- 与 blink.cmp 集成

#### 🌳 [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

**语法解析器** - 高级语法解析和高亮

- 自动安装缺失的解析器
- 语法高亮（替代 vim regex）
- 智能缩进
- 增量选择
- 文本对象

预装语言：c, cpp, cmake, python, bash, lua, vim, markdown, yaml, json, javascript, typescript, html, css

#### 🚨 [trouble.nvim](https://github.com/folke/trouble.nvim)

**诊断列表** - 美观的诊断/quickfix/位置列表

```lua
<leader>xx        -- 切换诊断
<leader>xX        -- 缓冲区诊断
<leader>xs        -- 符号
<leader>xl        -- LSP 定义/引用
<leader>xL        -- 位置列表
<leader>xQ        -- Quickfix 列表
```

- 按类型分组诊断
- 符号大纲
- 预览和跳转

---

### 代码质量

#### ✨ [conform.nvim](https://github.com/stevearc/conform.nvim)

**格式化器** - 异步代码格式化

```lua
<leader>fm        -- 格式化缓冲区/选区
```

- 保存时自动格式化（2s 超时）
- 无格式化器时回退到 LSP

配置的格式化器：

- **Lua** - stylua（2 空格）
- **C/C++** - clang_format（Google 风格）
- **Python** - black + isort（100 行长度）
- **JSON/Markdown** - prettier
- **CMake** - cmake_format
- **通用** - trim_whitespace

#### 🔍 [nvim-lint](https://github.com/mfussenegger/nvim-lint)

**Linter** - 异步代码检查

```lua
<leader>ll        -- 手动触发 lint
<leader>li        -- 显示配置的 linter
```

- 自动 lint：BufEnter、BufWritePost、InsertLeave

配置的 linter：

- **Python** - ruff
- **C/C++** - cppcheck
- **CMake** - cmakelint
- **Shell** - shellcheck
- **Lua** - luacheck

---

### Git 集成

#### 🎨 [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

**Git 标记** - 符号列的 Git 状态和内联 blame

```lua
]c / [c           -- 下一个/上一个变更块
<leader>ghs       -- 暂存变更块
<leader>ghr       -- 重置变更块
<leader>ghS       -- 暂存整个文件
<leader>ghu       -- 撤销暂存
<leader>ghR       -- 重置整个文件
<leader>ghp       -- 预览变更
<leader>gbl       -- 显示 blame
<leader>ghd       -- Diff 当前文件
<leader>gtb       -- 切换 blame 显示
<leader>gtd       -- 切换已删除内容显示
ig                -- 选择变更块（文本对象）
```

- 符号列的添加/修改/删除标记
- 内联 git blame
- 变更块导航

#### 🦥 [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)

**LazyGit 集成** - LazyGit 终端 UI

```lua
<leader>gg        -- 打开 LazyGit
<leader>gf        -- 当前文件历史
<leader>gl        -- 项目提交历史
```

- 浮动窗口 LazyGit
- 完整的 Git 工作流

#### ⚔️ [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim)

**冲突解决** - 可视化合并冲突解决

```lua
co                -- 选择 ours
ct                -- 选择 theirs
cb                -- 选择 both
c0                -- 选择 none
]x / [x           -- 下一个/上一个冲突
<leader>gco/gct/gcb/gc0  -- Leader 前缀变体
<leader>gcq       -- 列出冲突
```

- 高亮冲突区域
- 快速解决命令

#### 📊 [diffview.nvim](https://github.com/sindrets/diffview.nvim)

**Diff 查看器** - 高级 diff 查看器和文件历史

```lua
<leader>dvo       -- 打开 Diffview
<leader>dvc       -- 关闭 Diffview
<leader>dvh       -- 当前文件历史
<leader>dvH       -- 项目历史
```

- 并排 diff 视图
- 文件历史浏览器
- 3 路合并支持
- 从 diff 视图暂存/取消暂存

---

### 搜索 & 导航

#### 🔭 [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

**模糊查找器** - 文件、文本等的模糊查找

```lua
-- 文件查找
<leader>ff        -- 查找文件
<leader>fa        -- 查找所有文件（包括隐藏）
<leader>fb        -- 查找缓冲区
<leader>fo        -- 最近文件
<leader>fm        -- 查找标记

-- 文本搜索
<leader>fg        -- 实时 grep
<leader>fw        -- 查找光标下的单词

-- Git
<leader>gc        -- Git 提交
<leader>gs        -- Git 状态
<leader>gb        -- Git 分支

-- LSP
<leader>fr        -- LSP 引用
<leader>fd        -- LSP 定义
<leader>fs        -- 文档符号
<leader>fS        -- 工作区符号

-- 其他
<leader>fh        -- 帮助标签
<leader>fc        -- 命令历史
<leader>fk        -- 查找快捷键
<leader>ft        -- 更改配色方案
```

- 快速模糊查找（fzf-native）
- 预览窗口
- 可自定义主题
- 文件忽略模式

#### 🔍 [nvim-spectre](https://github.com/nvim-pack/nvim-spectre)

**搜索和替换** - 项目级搜索和替换

```lua
<leader>S         -- 切换 Spectre
<leader>sw        -- 搜索当前单词
<leader>sp        -- 在当前文件中搜索
<leader>sw (visual) -- 搜索选中文本
```

- 基于 Ripgrep 的搜索
- 基于 Sed 的替换
- 实时预览
- 选择性替换

---

### 编辑增强

#### 💾 [auto-save.nvim](https://github.com/okuuva/auto-save.nvim)

**自动保存** - 自动保存文件

```lua
<leader>as        -- 切换自动保存
<leader>aq        -- 切换静默模式
```

- 触发器：BufLeave、FocusLost（立即）、InsertLeave、TextChanged（延迟 1s）
- 排除：neo-tree、TelescopePrompt、dashboard、terminal、lazy
- 保存通知

---

### 语言特定

#### 🔧 [cmake-tools.nvim](https://github.com/Civitasv/cmake-tools.nvim) - C/C++

**CMake 项目管理** - CMake 构建系统集成

```lua
<leader>cb        -- CMake 构建
<leader>cr        -- CMake 运行
<leader>cc        -- CMake 清理
```

- 生成 compile_commands.json 用于 clangd
- 8 线程编译
- LLDB 调试支持

#### 🐍 [code_runner.nvim](https://github.com/CRAG666/code_runner.nvim) - Python

**Python 脚本运行器** - 快速运行 Python 脚本

```lua
<leader>rr        -- 运行脚本
<leader>rc        -- 关闭运行窗口
```

- 自动检测虚拟环境
- 回退到系统 Python
- 分割/浮动窗口输出

#### 🐛 [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python) - Python

**Python 调试器** - 全功能 Python 调试

```lua
<leader>db        -- 切换断点
<leader>dc        -- 继续/开始
<leader>di        -- 步入
<leader>do        -- 步过
<leader>dO        -- 步出
<leader>dr        -- 打开 REPL
<leader>dl        -- 运行最后配置
<leader>dt        -- 终止
<leader>du        -- 切换调试 UI
```

- Debugpy 集成
- 自动检测 venv/conda/系统 Python
- Python 3.13 兼容性修复
- 调试 UI，包含作用域、断点、堆栈、监视、REPL、控制台
- 自动打开/关闭 UI

#### 📝 [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - Markdown

**浏览器预览** - Markdown 实时预览

```lua
<leader>mp        -- 切换预览
```

- 实时同步
- GitHub/暗色主题
- Mermaid/KaTeX 支持
- 同步滚动

#### 🎨 [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - Markdown

**编辑器内渲染** - 在 Neovim 中渲染 Markdown

```lua
<leader>mr        -- 切换渲染
```

- 美观的标题图标
- 代码块样式
- 复选框渲染
- 引用块
- 表格边框
- 链接图标

#### 🎪 [headlines.nvim](https://github.com/lukas-reineke/headlines.nvim) - Markdown

**标题美化** - 高亮 Markdown 标题

- 标题背景颜色
- 分隔线
- 支持 markdown、org、norg

---

## 快捷键速查

### Leader 键

Leader 键设置为 `<Space>`（空格键）

### 主要前缀

| 前缀            | 功能               | 示例                       |
| ------------- | ---------------- | ------------------------ |
| `<leader>f`   | 查找/搜索（Telescope） | `<leader>ff` - 查找文件      |
| `<leader>g`   | Git 操作           | `<leader>gg` - LazyGit   |
| `<leader>gh`  | Git Hunk         | `<leader>ghs` - 暂存变更块    |
| `<leader>gt`  | Git 切换           | `<leader>gtb` - 切换 blame |
| `<leader>gc`  | Git 冲突           | `<leader>gco` - 选择 ours  |
| `<leader>dv`  | Diffview         | `<leader>dvo` - 打开 diff  |
| `<leader>b`   | 缓冲区              | `<leader>bl` - 下一个缓冲区    |
| `<leader>d`   | 调试               | `<leader>db` - 切换断点      |
| `<leader>r`   | 运行               | `<leader>rr` - 运行脚本      |
| `<leader>c`   | CMake/代码动作       | `<leader>ca` - 代码动作      |
| `<leader>t`   | TODO/切换          | `<leader>tl` - TODO 列表   |
| `<leader>l`   | LSP/Lint         | `<leader>lsp` - 打开 Mason |
| `<leader>x`   | Trouble 诊断       | `<leader>xx` - 切换诊断      |
| `<leader>z`   | 折叠层级             | `<leader>z1` - 折叠到第 1 层  |
| `<leader>n`   | Noice 消息         | `<leader>nm` - 查看消息      |
| `<leader>m`   | Markdown         | `<leader>mp` - 预览        |
| `<leader>s/S` | 搜索替换             | `<leader>S` - Spectre    |
| `<leader>a`   | 自动保存             | `<leader>as` - 切换自动保存    |

### LSP 快捷键

```lua
K                 -- 悬停文档 / 预览折叠
gd / gD           -- 跳转/预览定义
gt / gT           -- 跳转/预览类型定义
gr / gR           -- 查找引用
gi                -- 跳转到实现
gl / gL           -- 显示诊断
[e / ]e           -- 上一个/下一个诊断
[E / ]E           -- 上一个/下一个错误
<leader>ca        -- 代码动作
<leader>rn        -- 重命名符号
<leader>fm        -- 格式化
```

### Git 快捷键

```lua
]c / [c           -- 下一个/上一个变更块
]x / [x           -- 下一个/上一个冲突
<leader>gg        -- LazyGit
<leader>ghs       -- 暂存变更块
<leader>ghp       -- 预览变更
<leader>gtb       -- 切换 blame
```

### 导航快捷键

```lua
<C-h/j/k/l>       -- 窗口导航
<leader>e         -- 切换文件树
<leader>ff        -- 查找文件
<leader>fg        -- 实时 grep
<leader>fb        -- 查找缓冲区
```

### 编辑快捷键

```lua
<C-/>             -- 切换注释
gcc               -- 注释行
gc                -- 注释选区
<Tab>             -- 接受补全
za                -- 切换折叠
```

### 调试快捷键

```lua
<leader>db        -- 切换断点
<leader>dc        -- 继续
<leader>di        -- 步入
<leader>do        -- 步过
<leader>du        -- 切换调试 UI
```

---

## 环境要求

### 必需

- **Neovim** >= 0.10.0
- **Git**
- **Node.js** >= 14（用于 markdown-preview）
- **Python** >= 3.8（用于 Python 开发）
- **编译器**：gcc/clang（用于编译 fzf-native）

### 推荐工具

#### LSP 服务器（通过 Mason 安装）

```bash
:Mason
# 然后安装：
# - lua-language-server
# - pyright
# - clangd
# - bash-language-server
# - yaml-language-server
```

#### 格式化器

```bash
# Python
pip install black isort ruff

# C/C++
# 安装 clang-format（通常随 clang 安装）

# Lua
# stylua 会通过 Mason 自动安装

# JSON/Markdown
npm install -g prettier
```

#### Linter

```bash
# Python
pip install ruff

# C/C++
sudo apt install cppcheck  # Ubuntu/Debian
brew install cppcheck       # macOS

# Shell
sudo apt install shellcheck  # Ubuntu/Debian
brew install shellcheck      # macOS

# CMake
pip install cmakelint

# Lua
luarocks install luacheck
```

#### 其他工具

```bash
# Ripgrep（用于 Telescope 和 Spectre）
sudo apt install ripgrep  # Ubuntu/Debian
brew install ripgrep      # macOS

# Fd（用于 Telescope）
sudo apt install fd-find  # Ubuntu/Debian
brew install fd           # macOS

# LazyGit（用于 Git 集成）
brew install lazygit      # macOS
# 或参考：https://github.com/jesseduffield/lazygit#installation
```

---

## 配置结构

```
~/.config/nvim/
├── init.lua                 # 主配置文件
├── lua/
│   ├── config/
│   │   └── lazy.lua        # Lazy.nvim 插件管理器配置
│   └── plugins/            # 插件配置目录
│       ├── auto-save.lua
│       ├── blink.lua
│       ├── bufferline.lua
│       ├── c_cpp_dev.lua
│       ├── colorscheme.lua
│       ├── common.lua
│       ├── conform.lua
│       ├── gitsigns.lua
│       ├── lazydev.lua
│       ├── lsp.lua
│       ├── markdown.lua
│       ├── noice.lua
│       ├── nvim-colorizer.lua
│       ├── nvim-lint.lua
│       ├── nvim-tree.lua
│       ├── nvim-ufo.lua
│       ├── python_dev.lua
│       ├── rainbow-delimiters.lua
│       ├── scrollbar.lua
│       ├── spectre.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── trouble.lua
│       └── which-key.lua
├── lazy-lock.json          # 插件版本锁定文件
└── README.md               # 本文档
```

---

## 常见问题

### Q: 如何更新插件？

```vim
:Lazy sync
```

### Q: 如何检查配置健康状态？

```vim
:checkhealth
```

### Q: 补全不工作？

1. 检查 LSP 是否正常运行：`:LspInfo`
2. 检查 Mason 中是否安装了对应的 LSP 服务器：`:Mason`
3. 检查 blink.cmp 是否加载：`:Lazy`

### Q: 如何禁用自动保存？

```vim
<leader>as        " 切换自动保存
```

或在配置中设置 `enabled = false`

### Q: 格式化不工作？

1. 检查是否安装了对应的格式化器（如 black、stylua）
2. 运行 `:ConformInfo` 查看状态
3. 手动触发：`<leader>fm`

### Q: Python 调试器找不到？

确保安装了 debugpy：

```bash
pip install debugpy
```

---

## 致谢

本配置参考了以下优秀项目：

- [LazyVim](https://github.com/LazyVim/LazyVim)
- [NvChad](https://github.com/NvChad/NvChad)
- [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 许可证

MIT License

---

## 更新日志

### 2024-03-16

- ✨ 添加 nvim-ufo 代码折叠插件
- ✨ 添加 which-key 快捷键提示插件
- 🐛 修复 which-key 配置问题
- 📝 完成完整的 README 文档

---

**享受你的 Neovim 开发体验！** 🚀

按 `<Space>` 查看所有可用快捷键，或运行 `:Telescope keymaps` 搜索快捷键。
