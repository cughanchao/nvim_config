return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- 图标依赖
  config = function()
    require("nvim-tree").setup({
      view = { width = 35 }, -- 文件树宽度
      renderer = {
        icons = { show = { file = true, folder = true } }, -- 显示图标
      },
      actions = {
        open_file = { quit_on_open = false }, -- 打开文件不关闭文件树
      },
    })
    -- 快捷键：按 leader + e 打开/关闭文件树
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeFocus<CR>", { desc = "Focus one file tree" })
  end,
}
