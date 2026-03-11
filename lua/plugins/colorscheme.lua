return {
  -- "loctvl842/monokai-pro.nvim",
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --   require("monokai-pro").setup()
  --   -- vim.cmd.colorscheme("monokai-pro")
  --   vim.cmd.colorscheme("monokai-pro-light")
  -- end,

  "tanvirtin/monokai.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("monokai").setup({
      palette = require("monokai").pro, -- 使用 Monokai Pro 调色板
    })
    vim.opt.background = "light" -- 设置为亮色背景
    vim.cmd.colorscheme("monokai")
  end,
}
