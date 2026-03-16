return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- 延迟加载
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- 300ms后显示which-key提示
  end,
  config = function()
    local wk = require("which-key")

    wk.setup({
      plugins = {
        marks = true, -- 显示标记
        registers = true, -- 显示寄存器
        spelling = {
          enabled = true, -- 启用拼写建议
          suggestions = 20, -- 显示的建议数量
        },
        presets = {
          operators = true, -- 操作符（如d, y, c等）
          motions = true, -- 动作（如w, b, e等）
          text_objects = true, -- 文本对象（如iw, aw等）
          windows = true, -- 窗口命令
          nav = true, -- 导航命令
          z = true, -- 折叠命令
          g = true, -- g前缀命令
        },
      },
      win = {
        border = "rounded", -- 边框样式：none, single, double, shadow, rounded
        padding = { 1, 2 }, -- 内边距 [top/bottom, left/right]
        wo = {
          winblend = 0, -- 窗口透明度
        },
      },
      layout = {
        height = { min = 4, max = 25 }, -- 窗口高度
        width = { min = 20, max = 50 }, -- 窗口宽度
        spacing = 3, -- 列之间的间距
        align = "left", -- 对齐方式
      },
      show_help = true, -- 在底部显示帮助信息
      show_keys = true, -- 显示当前按键
      -- triggers配置：定义哪些按键前缀会触发which-key
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "z", mode = { "n", "v" } },
        { "g", mode = { "n", "v" } },
        { "[", mode = { "n", "v" } },
        { "]", mode = { "n", "v" } },
        { "<C-w>", mode = { "n" } },
      },
      -- 图标配置：优先使用mini.icons，回退到nvim-web-devicons
      icons = {
        breadcrumb = "»", -- 面包屑分隔符
        separator = "➜", -- 键和描述之间的分隔符
        group = "+", -- 分组符号
        mappings = false, -- 使用nvim-web-devicons而不是mini.icons
      },
    })

    -- ==================== Leader键分组描述 ====================
    wk.add({
      -- 顶级分组
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>g", group = "Git" },
      { "<leader>b", group = "Buffer" },
      { "<leader>d", group = "Debug" },
      { "<leader>r", group = "Run" },
      { "<leader>c", group = "Colorizer" },
      { "<leader>t", group = "Todo/Toggle" },
      { "<leader>a", group = "Auto-save" },
      { "<leader>z", group = "Fold Level" },

      -- File/Find 分组 (Telescope)
      { "<leader>ff", desc = "Find files" },
      { "<leader>fa", desc = "Find all files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fw", desc = "Find word under cursor" },
      { "<leader>fb", desc = "Find buffers" },
      { "<leader>fo", desc = "Find recent files" },
      { "<leader>fh", desc = "Find help tags" },
      { "<leader>fc", desc = "Command history" },
      { "<leader>fr", desc = "LSP references" },
      { "<leader>fd", desc = "LSP definitions" },
      { "<leader>fs", desc = "Document symbols" },
      { "<leader>fS", desc = "Workspace symbols" },
      { "<leader>fk", desc = "Find keymaps" },
      { "<leader>ft", desc = "Change colorscheme" },
      { "<leader>fm", desc = "Find marks" },
      { "<leader>fe", desc = "Focus file tree" },

      -- Git 分组
      { "<leader>gc", desc = "Git commits" },
      { "<leader>gs", desc = "Git status" },
      { "<leader>gb", desc = "Git branches" },
      { "<leader>gg", desc = "LazyGit" },
      { "<leader>gf", desc = "LazyGit current file" },
      { "<leader>gl", desc = "LazyGit project history" },

      -- Git Hunk 操作
      { "<leader>gh", group = "Git Hunk" },
      { "<leader>ghs", desc = "Stage hunk" },
      { "<leader>ghr", desc = "Reset hunk" },
      { "<leader>ghS", desc = "Stage buffer" },
      { "<leader>ghu", desc = "Undo stage hunk" },
      { "<leader>ghR", desc = "Reset buffer" },
      { "<leader>ghp", desc = "Preview hunk" },
      { "<leader>ghd", desc = "Diff this" },
      { "<leader>ghD", desc = "Diff this ~" },

      -- Git Toggle
      { "<leader>gt", group = "Git Toggle" },
      { "<leader>gtb", desc = "Toggle blame line" },
      { "<leader>gtd", desc = "Toggle deleted" },

      -- Git Conflict
      { "<leader>gco", desc = "Choose ours" },
      { "<leader>gct", desc = "Choose theirs" },
      { "<leader>gcb", desc = "Choose both" },
      { "<leader>gc0", desc = "Choose none" },
      { "<leader>gcq", desc = "List conflicts" },

      -- Git Blame Line
      { "<leader>gbl", desc = "Blame line" },

      -- Buffer 操作
      { "<leader>bl", desc = "Next buffer" },
      { "<leader>bh", desc = "Previous buffer" },

      -- Debug 调试
      { "<leader>db", desc = "Toggle breakpoint" },
      { "<leader>dc", desc = "Continue" },
      { "<leader>di", desc = "Step into" },
      { "<leader>do", desc = "Step over" },
      { "<leader>dO", desc = "Step out" },
      { "<leader>dr", desc = "Open REPL" },
      { "<leader>dl", desc = "Run last" },
      { "<leader>dt", desc = "Terminate" },
      { "<leader>du", desc = "Toggle UI" },

      -- Run 运行
      { "<leader>rr", desc = "Run script" },
      { "<leader>rc", desc = "Close run window" },

      -- Colorizer
      { "<leader>ct", desc = "Toggle colorizer" },
      { "<leader>cr", desc = "Reload colorizer" },

      -- Todo
      { "<leader>tl", desc = "Todo list" },

      -- Auto-save
      { "<leader>as", desc = "Toggle auto-save" },
      { "<leader>aq", desc = "Auto-save status" },

      -- File tree
      { "<leader>e", desc = "Toggle file tree" },

      -- Buffer 切换
      { "<leader>w", desc = "Close buffer" },
      { "<leader>1", desc = "Go to buffer 1" },

      -- Fold Level (nvim-ufo)
      { "<leader>z0", desc = "Fold all" },
      { "<leader>z1", desc = "Fold to level 1" },
      { "<leader>z2", desc = "Fold to level 2" },
      { "<leader>z3", desc = "Fold to level 3" },
      { "<leader>z4", desc = "Fold to level 4" },
      { "<leader>z5", desc = "Fold to level 5" },
      { "<leader>z9", desc = "Unfold all" },
    })

    -- ==================== 其他常用快捷键组 ====================
    wk.add({
      -- 窗口操作
      { "<C-h>", desc = "Go to left window" },
      { "<C-j>", desc = "Go to down window" },
      { "<C-k>", desc = "Go to up window" },
      { "<C-l>", desc = "Go to right window" },

      -- 折叠操作 (z prefix)
      { "za", desc = "Toggle fold" },
      { "zA", desc = "Toggle all folds" },
      { "zc", desc = "Close fold" },
      { "zC", desc = "Close all folds" },
      { "zo", desc = "Open fold" },
      { "zO", desc = "Open all folds" },
      { "zM", desc = "Close all folds" },
      { "zR", desc = "Open all folds" },
      { "zm", desc = "Fold more" },
      { "zr", desc = "Fold less" },

      -- LSP快捷键 (如果有配置LSP的话)
      { "gd", desc = "Go to definition" },
      { "gD", desc = "Go to declaration" },
      { "gr", desc = "Go to references" },
      { "gi", desc = "Go to implementation" },
      { "K", desc = "Hover/Preview fold" },
    })
  end,
}
