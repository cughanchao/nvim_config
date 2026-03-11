return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- 在打开 Lua 文件时加载
    opts = {
      library = {
        -- 加载 luvit 类型以支持 vim.uv
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  -- luvit-meta: 提供 vim.uv 的类型定义
  { "Bilal2453/luvit-meta", lazy = true },
}
