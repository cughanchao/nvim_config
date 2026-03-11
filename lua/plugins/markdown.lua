return {
  -- =====================================================================
  -- markdown-preview.nvim: 浏览器实时预览
  -- 功能：在浏览器中实时预览 Markdown，支持同步滚动和图表
  -- =====================================================================
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      -- 配置选项
      vim.g.mkdp_auto_start = 0 -- 打开 markdown 文件时不自动预览
      vim.g.mkdp_auto_close = 1 -- 关闭 buffer 时自动关闭预览
      vim.g.mkdp_refresh_slow = 0 -- 实时刷新（不延迟）
      vim.g.mkdp_browser = "" -- 使用默认浏览器
      vim.g.mkdp_echo_preview_url = 1 -- 在命令行显示预览 URL

      -- 预览主题：github（GitHub 风格）或 dark
      vim.g.mkdp_theme = "dark"

      -- 页面标题
      vim.g.mkdp_page_title = "${name}"

      -- 预览选项
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0, -- 启用同步滚动
        sync_scroll_type = "middle", -- 滚动类型：middle, top, relative
        hide_yaml_meta = 1, -- 隐藏 YAML 元数据
        sequence_diagrams = {}, -- 序列图配置
        flowchart_diagrams = {}, -- 流程图配置
        content_editable = false, -- 内容不可编辑
      }
    end,
  },

  -- =====================================================================
  -- render-markdown.nvim: 编辑器内渲染
  -- 功能：直接在 Neovim 中美化显示 Markdown（无需浏览器）
  -- =====================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- 语法解析
      "nvim-tree/nvim-web-devicons", -- 图标支持
    },
    opts = {
      -- 标题样式
      heading = {
        enabled = true,
        sign = true, -- 在侧边栏显示标题图标
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- 标题图标
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      -- 代码块样式
      code = {
        enabled = true,
        sign = true,
        style = "full", -- full, normal, language
        left_pad = 2,
        right_pad = 2,
        width = "block", -- block, full
        border = "thin", -- 边框样式
      },

      -- 列表符号
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" }, -- 不同层级的符号
      },

      -- 复选框
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },

      -- 引用块
      quote = {
        enabled = true,
        icon = "▋",
      },

      -- 表格边框
      pipe_table = {
        enabled = true,
        style = "full", -- full, normal, none
      },

      -- 链接
      link = {
        enabled = true,
        image = "󰥶 ", -- 图片图标
        hyperlink = "󰌹 ", -- 链接图标
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- 切换渲染的快捷键
      vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown Render" })
    end,
  },

  -- =====================================================================
  -- headlines.nvim: 标题高亮美化
  -- 功能：为标题添加背景色和分隔线，提升可读性
  -- =====================================================================
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "org", "norg" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = function()
      local opts = {}
      for _, ft in ipairs({ "markdown", "norg", "org" }) do
        opts[ft] = {
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
          },
          fat_headlines = true, -- 标题占满整行
          fat_headline_upper_string = "▃", -- 上边线
          fat_headline_lower_string = "▀", -- 下边线
        }
      end
      return opts
    end,
    config = function(_, opts)
      -- 定义高亮颜色
      vim.cmd([[highlight Headline1 guibg=#1e2718]])
      vim.cmd([[highlight Headline2 guibg=#21262d]])
      vim.cmd([[highlight Headline3 guibg=#26343f]])
      vim.cmd([[highlight Headline4 guibg=#2c2d30]])
      vim.cmd([[highlight Headline5 guibg=#2b2c2f]])
      vim.cmd([[highlight Headline6 guibg=#2a2c2e]])

      require("headlines").setup(opts)
    end,
  },
}
