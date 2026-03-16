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

    -- 折叠配置已移至 nvim-ufo 插件
    -- nvim-ufo 会自动使用 treesitter 作为折叠提供者
  end,
}
