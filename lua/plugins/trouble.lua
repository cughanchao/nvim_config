return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    opts = {
      -- 主题模式
      mode = "document_diagnostics", -- 默认显示当前文件诊断
      -- position = "bottom", -- 窗口位置（bottom/right）
      -- height = 10, -- 底部窗口高度（右侧窗口用 width）
      -- width = 50, -- 右侧窗口宽度
      -- icons = true, -- 显示图标（需 Nerd Font）
      fold_open = "", -- 展开文件夹图标
      fold_closed = "", -- 折叠文件夹图标
      group = true, -- 按错误类型分组
      padding = true, -- 内边距
      cycle_results = true, -- 循环跳转结果（到末尾后回到开头）

      action_keys = {
        close = "q", -- 关闭窗口
        cancel = "<esc>", -- 取消预览并回到列表
        refresh = "r", -- 手动刷新
        jump = { "<cr>", "<tab>" }, -- 跳转并关闭 trouble 窗口
        open_split = { "<c-x>" }, -- 在水平分割中打开
        open_vsplit = { "<c-v>" }, -- 在垂直分割中打开
        open_tab = { "<c-t>" }, -- 在新标签页中打开
        jump_close = { "o" }, -- 跳转并关闭 trouble
        toggle_mode = "m", -- 切换 workspace/document 模式
        toggle_preview = "P", -- 切换自动预览
        hover = "K", -- 打开悬浮窗查看完整消息
        preview = "p", -- 预览位置
        close_folds = { "zM", "zm" }, -- 关闭所有折叠
        open_folds = { "zR", "zr" }, -- 打开所有折叠
        toggle_fold = { "zA", "za" }, -- 切换折叠
        previous = "k", -- 上一项
        next = "j", -- 下一项
      },
      severity = nil, -- 过滤错误级别（nil=全部，{"error", "warn"}=仅错误/警告）
      indent_lines = true, -- 添加缩进参考线
      auto_open = false, -- 出现诊断时不自动打开
      auto_close = false, -- 没有诊断时不自动关闭
      auto_preview = true, -- 自动预览诊断位置
      auto_fold = false, -- 不自动折叠文件
      auto_jump = { "lsp_definitions" }, -- 只有一个结果时自动跳转的列表
      signs = {
        -- 诊断级别图标
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
      },
      use_diagnostic_signs = true, -- 使用 LSP 定义的诊断符号
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
