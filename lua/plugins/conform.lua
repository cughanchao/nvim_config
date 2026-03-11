return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- 只在保存前加载，不需要 BufReadPre
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({
            async = true, -- 异步格式化，不会阻塞编辑器
            -- 如果没有找到对应的格式化工具（如 stylua、black 等），会回退到 LSP 的格式化功能
            lsp_fallback = true,
          })
        end,
        mode = { "n", "v" },
        desc = "Format buffer or selection",
      },
    },
    opts = {
      -- 格式化工具优先级（按顺序尝试）
      formatters_by_ft = {
        lua = { "stylua" }, -- Lua 用 stylua
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "black", "isort" }, -- Python 用 black+isort
        -- javascript = { "prettier" }, -- JS/TS/JSON/CSS 用 prettier
        -- typescript = { "prettier" },
        json = { "prettier" },
        -- css = { "prettier" },
        markdown = { "prettier" },
        cmake = { "cmake_format" }, -- CMake 用 cmake-format
        -- 通用格式化（无专用工具时用）
        ["*"] = { "trim_whitespace" },
      },
      formatters = {
        -- clang-format: C/C++ 格式化
        clang_format = {
          -- 优先级：项目根目录 .clang-format > 全局配置 > 默认
          -- prepend_args = { "--style", "file" },
          -- 若项目无 .clang-format，可指定预设风格（如 Google/Mozilla/Linux 等）
          prepend_args = { "--style", "Google" },
        },
        -- cmake-format: CMake 格式化
        cmake_format = {
          prepend_args = { "--line-width", "100", "--tab-size", "4" },
        },
        -- stylua: Lua 格式化（2空格缩进）
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        -- black: Python 格式化（默认4空格，PEP 8标准）
        black = {
          prepend_args = { "--line-length", "100" },
        },
        -- prettier: JS/TS/JSON/CSS/HTML 格式化（2空格缩进）
        prettier = {
          prepend_args = { "--tab-width", "2", "--use-tabs", "false" },
        },
      },
      -- 保存时自动格式化
      format_on_save = {
        timeout_ms = 2000, -- 2秒超时，平衡速度和可靠性
        lsp_fallback = true, -- 无 formatter 时回退到 LSP 格式化
      },
    },
  },
}
