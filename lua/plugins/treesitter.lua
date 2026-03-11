return {
  -- Treesitter: 更快更准确的语法高亮和代码解析
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  -- event = { "BufReadPost", "BufNewFile" }, -- 在打开文件时加载
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects", -- 可选：文本对象支持
  },
  config = function()
    require("nvim-treesitter").setup({
      -- 自动安装缺失的语法解析器
      auto_install = true,

      -- 预装常用语言的解析器
      ensure_installed = {
        "c",
        "cpp",
        "cmake",
        "python",
        "bash",
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "yaml",
        "json",
        "javascript",
        "typescript",
        "html",
        "css",
      },

      -- 语法高亮
      highlight = {
        enable = true,
        -- 禁用 vim 原生语法高亮（避免冲突）
        additional_vim_regex_highlighting = false,
      },

      textobjects = { enable = true },
      -- 智能缩进
      indent = {
        enable = true,
      },

      -- 增量选择
      incremental_selection = {
        enable = true,
      },
    })

    -- 启用代码折叠（基于 treesitter）
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = false -- 默认不折叠（打开文件时展开所有代码）

    -- 确保 treesitter 高亮自动启动
    local ts_group = vim.api.nvim_create_augroup("TreesitterAutostart", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = ts_group,
      callback = function()
        -- 延迟启动以确保 treesitter 已完全加载
        vim.schedule(function()
          local buf = vim.api.nvim_get_current_buf()
          -- 检查是否已经有高亮器
          if not vim.treesitter.highlighter.active[buf] then
            -- 尝试启动 treesitter
            local ok = pcall(vim.treesitter.start, buf)
            if not ok then
              -- 如果启动失败，可能是因为该文件类型不支持
              -- 静默失败，不显示错误
            end
          end
        end)
      end,
      desc = "Auto start treesitter highlighting",
    })
  end,
}
