return {
  -- Plugins for UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto" }, -- 自动适配主题
        extensions = { "nvim-tree" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  --  indent-blankline.nvim：显示缩进线（可视化辅助）
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│", -- 缩进线字符（竖线）
          tab_char = "│",
        },
        scope = { enabled = true }, -- 显示代码块作用域缩进线
        exclude = {
          filetypes = { "nvim-tree", "terminal", "lazy" }, -- 排除无需缩进的文件类型
        },
      })
    end,
  },

  -- Plugins for coding
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- 基于语法树检测，更智能
        ts_config = { lua = { "string" }, javascript = { "template_string" } },
      })
      -- 关联 cmp，补全后自动添加括号
      -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      -- local cmp = require("cmp")
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("Comment").setup({
        -- 启用 treesitter 上下文感知注释
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
      -- 快捷键：gcc 注释单行，gc 可视化模式注释选中内容
      -- 无需额外映射，插件已默认配置
      vim.keymap.set(
        "n",
        "<C-/>",
        "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
        { desc = "注释/取消注释当前行" }
      )
      vim.keymap.set(
        "v",
        "<C-/>",
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        { desc = "注释/取消注释选中行" }
      )
    end,
  },

  -- treesitter 上下文注释支持（Markdown 代码块识别）
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable_autocmd = false, -- 禁用自动命令，由 Comment.nvim 接管
    },
  },

  -- todo-comments.nvim: 高亮 TODO/FIXME/NOTE 等注释
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter", -- 需要 treesitter 支持
    },
    event = { "BufReadPost", "BufNewFile" }, -- 读取或创建文件时加载
    config = function()
      require("todo-comments").setup({
        signs = true, -- 在侧边栏显示图标
        sign_priority = 8,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        highlight = {
          multiline = true,
          before = "",
          keyword = "wide", -- 高亮整个关键词
          after = "fg",
          pattern = [[.*<(KEYWORDS)(\s*\([^)]*\))?\s*:]], -- 支持 TODO (author): 格式
          comments_only = true, -- 只在注释中高亮
          max_line_len = 400,
          exclude = {},
        },
      })
    end,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "下一个 TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "上一个 TODO",
      },
      { "<leader>tl", "<cmd>TodoTelescope<cr>", desc = "查找 TODO" },
    },
  },

  -- =====================================================================
  -- trim.nvim: 自动删除行尾空白和文件末尾空行
  -- GitHub: https://github.com/cappyzawa/trim.nvim
  -- =====================================================================
  -- {
  --   "cappyzawa/trim.nvim",
  --   event = "BufWritePre", -- 保存文件前加载
  --   opts = {
  --     -- ==================== 修剪规则 ====================
  --     patterns = {
  --       [[%s/\s\+$//e]], -- 删除行尾空白字符
  --       [[%s/\($\n\s*\)\+\%$//]], -- 删除文件末尾多余空行
  --       [[%s/\(\n\n\)\n\+/\1/]], -- 将连续多个空行合并为两个空行
  --     },
  --
  --     -- ==================== 高亮配置 ====================
  --     trim_on_write = true, -- 保存时自动修剪
  --     trim_trailing = true, -- 修剪行尾空白
  --     trim_last_line = true, -- 修剪文件末尾空行
  --     trim_first_line = false, -- 不修剪文件开头空行
  --
  --     -- ==================== 高级选项 ====================
  --     -- 排除特定文件类型（可以添加到这里）
  --     ft_blocklist = { "markdown", "text" },
  --   },
  -- },
}
