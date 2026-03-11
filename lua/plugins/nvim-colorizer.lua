return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        -- 为所有文件类型启用
        filetypes = {
          "*", -- 默认所有文件
          -- 特定文件类型的自定义配置
          css = { rgb_fn = true, hsl_fn = true }, -- 启用 CSS 函数
          scss = { rgb_fn = true, hsl_fn = true },
          sass = { rgb_fn = true, hsl_fn = true },
          html = { names = true }, -- 启用颜色名称（如 "red"）
          javascript = { tailwind = true }, -- 启用 Tailwind CSS 支持
          typescript = { tailwind = true },
          javascriptreact = { tailwind = true },
          typescriptreact = { tailwind = true },
          vue = { tailwind = true },
        },

        -- 用户默认选项
        user_default_options = {
          RGB = true, -- 支持 #RGB 格式（如 #fff）
          RRGGBB = true, -- 支持 #RRGGBB 格式（如 #ffffff）
          names = false, -- 不支持颜色名称（如 "red", "blue"）
          RRGGBBAA = true, -- 支持 #RRGGBBAA 格式（带透明度）
          AARRGGBB = true, -- 支持 0xAARRGGBB 格式
          rgb_fn = true, -- 支持 CSS rgb() 和 rgba() 函数
          hsl_fn = true, -- 支持 CSS hsl() 和 hsla() 函数
          css = true, -- 启用所有 CSS 特性（rgb_fn, hsl_fn, names, RRGGBB）
          css_fn = true, -- 启用所有 CSS 函数（rgb_fn, hsl_fn）

          -- 显示模式
          mode = "background", -- 设置显示模式: "foreground" | "background" | "virtualtext"
          -- mode = "foreground", -- 前景色模式（文字颜色）
          -- mode = "virtualtext", -- 虚拟文本模式（在行尾显示颜色块）

          -- Tailwind CSS 支持
          tailwind = false, -- 启用 Tailwind CSS 颜色（如 bg-blue-500）
          sass = { enable = true, parsers = { "css" } }, -- 启用 Sass 颜色

          -- virtualtext 模式专用配置
          virtualtext = "■", -- 虚拟文本显示的字符

          -- 更新时机
          always_update = false, -- 文本改变时是否立即更新颜色
        },

        -- 排除的 buffer 类型
        buftypes = {},

        -- 自定义键映射（可选）
        user_commands = true, -- 启用 :ColorizerToggle 等命令
      })

      -- 键映射：切换颜色高亮
      vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>", { desc = "Toggle colorizer" })
      vim.keymap.set(
        "n",
        "<leader>cr",
        "<cmd>ColorizerReloadAllBuffers<cr>",
        { desc = "Reload colorizer for all buffers" }
      )
    end,
  },
}
