return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        -- 全局策略：对所有文件类型使用 treesitter
        [""] = rainbow_delimiters.strategy["global"],
        -- 针对特定语言的策略
        vim = rainbow_delimiters.strategy["local"],
      },
      query = {
        -- 使用默认查询
        [""] = "rainbow-delimiters",
        -- 针对特定语言的查询
        lua = "rainbow-blocks",
      },
      priority = {
        -- 高亮优先级
        [""] = 110,
        lua = 210,
      },
      highlight = {
        -- 自定义高亮组（彩虹色）
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      -- 黑名单：这些文件类型不启用
      blacklist = { "html", "css" },
    }

    -- 自定义高亮颜色（可选，如果你不喜欢默认颜色）
    -- 取消注释下面的代码来自定义颜色
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
    -- vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
  end,
}
