return {
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "kevinhwang91/nvim-hlslens", -- 可选：增强搜索结果标记
      "lewis6991/gitsigns.nvim", -- Git 变更标记集成
      "mfussenegger/nvim-lint", -- 可选：显示 lint 诊断（也可仅用 LSP 诊断）
    },
    config = function()
      local scrollbar = require("scrollbar")

      scrollbar.setup({
        -- 显示设置
        show = true, -- 始终显示滚动条
        show_in_active_only = false, -- 所有窗口都显示
        set_highlights = true, -- 自动设置高亮颜色
        folds = 1000, -- 处理折叠的最大行数
        max_lines = false, -- 不限制最大行数
        hide_if_all_visible = false, -- 内容全部可见时也显示
        throttle_ms = 100, -- 更新节流时间（毫秒）

        -- 滚动条外观
        handle = {
          text = " ", -- 滚动条字符
          blend = 30, -- 透明度（0=不透明，100=完全透明）
          color = nil, -- 使用默认颜色
          color_nr = nil, -- 使用默认
          highlight = "CursorColumn", -- 高亮组
          hide_if_all_visible = true, -- 全部可见时隐藏滚动条手柄
        },

        -- 标记配置
        marks = {
          Cursor = {
            text = "─", -- 当前光标位置
            priority = 0,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          Search = {
            text = { "-", "=" }, -- 搜索结果标记
            priority = 1,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Search",
          },
          Error = {
            text = { "-", "=" }, -- 错误标记
            priority = 2,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextError",
          },
          Warn = {
            text = { "-", "=" }, -- 警告标记
            priority = 3,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextWarn",
          },
          Info = {
            text = { "-", "=" }, -- 信息标记
            priority = 4,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextInfo",
          },
          Hint = {
            text = { "-", "=" }, -- 提示标记
            priority = 5,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextHint",
          },
          Misc = {
            text = { "-", "=" }, -- 其他标记
            priority = 6,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          GitAdd = {
            text = "│", -- Git 新增行
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsAdd",
          },
          GitChange = {
            text = "│", -- Git 修改行
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsChange",
          },
          GitDelete = {
            text = "▁", -- Git 删除行
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsDelete",
          },
        },

        -- 排除的文件类型
        excluded_buftypes = {
          "terminal",
          "nofile",
        },
        excluded_filetypes = {
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "TelescopePrompt",
          "NvimTree",
          "neo-tree",
          "dashboard",
          "alpha",
          "lazy",
          "mason",
          "DressingInput",
        },

        -- 自动命令配置
        autocmd = {
          render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
          },
          clear = {
            "BufWinLeave",
            "TabLeave",
            "TermLeave",
            "WinLeave",
          },
        },

        -- 处理器配置
        handlers = {
          cursor = true, -- 显示光标位置
          diagnostic = true, -- 显示诊断信息
          gitsigns = true, -- 显示 Git 变更（需要 gitsigns.nvim）
          handle = true, -- 显示滚动条手柄
          search = true, -- 显示搜索结果
          ale = false, -- 不使用 ALE
        },
      })

      -- 与 gitsigns 集成
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
}
