return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- 显示缓冲区（标签页）
        numbers = "none", -- 不显示数字
        close_command = "bdelete! %d", -- 关闭标签页的命令
        separator_style = "thin",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
            padding = 1,
          },
        },
      },
    })
    -- 快捷键：leader + 数字切换标签页，leader + w 关闭当前标签
    vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>")
    vim.keymap.set("n", "<leader>w", "<cmd>bdelete!<CR>", { desc = "Close current buffer" })
    vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
  end,
}
