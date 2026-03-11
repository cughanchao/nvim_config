return {
  "nvim-telescope/telescope.nvim",
  -- branch = "master", -- 使用最新的 master 分支，兼容新版 treesitter
  branch = "0.1.x", -- 稳定版，强烈推荐
  dependencies = {
    "nvim-lua/plenary.nvim", -- 必需依赖
    "nvim-tree/nvim-web-devicons", -- 文件图标
    {
      "nvim-telescope/telescope-fzf-native.nvim", -- 性能优化
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- 默认配置
        prompt_prefix = "🔍 ",
        selection_caret = "➤ ",
        path_display = { "truncate" }, -- 路径显示方式
        sorting_strategy = "ascending", -- 排序策略
        layout_strategy = "horizontal", -- 布局策略
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.8,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },

        -- 预览器配置：禁用 treesitter 高亮以避免兼容性问题
        preview = {
          treesitter = {
            enable = false, -- 禁用 treesitter 预览高亮，使用传统语法高亮
          },
        },

        -- 快捷键映射
        mappings = {
          i = {
            -- 插入模式快捷键
            ["<C-j>"] = actions.move_selection_next, -- 下一个
            ["<C-k>"] = actions.move_selection_previous, -- 上一个
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- 发送到 quickfix
            ["<C-x>"] = actions.delete_buffer, -- 删除 buffer
            ["<C-u>"] = actions.preview_scrolling_up, -- 预览窗口向上滚动
            ["<C-d>"] = actions.preview_scrolling_down, -- 预览窗口向下滚动
            ["<Esc>"] = actions.close, -- 退出
          },
          n = {
            -- 正常模式快捷键
            ["q"] = actions.close, -- 退出
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        -- 文件忽略模式
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/",
          "*.pyc",
          "__pycache__",
          ".DS_Store",
        },
      },
      pickers = {
        -- 特定 picker 的配置
        find_files = {
          theme = "dropdown", -- 使用下拉主题
          previewer = false, -- 不显示预览
          hidden = true, -- 显示隐藏文件
        },
        live_grep = {
          theme = "ivy", -- 使用 ivy 主题
          -- 使用默认布局（横向布局，带预览窗口）
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal", -- 以正常模式启动
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer, -- 删除 buffer
            },
            n = {
              ["dd"] = actions.delete_buffer, -- 删除 buffer
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- 启用模糊匹配
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case", -- 智能大小写
        },
      },
    })

    -- 加载 fzf 扩展
    telescope.load_extension("fzf")

    -- ==================== 快捷键映射 ====================
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 文件查找
    keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", vim.tbl_extend("force", opts, { desc = "Find files" }))
    keymap(
      "n",
      "<leader>fa",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      vim.tbl_extend("force", opts, { desc = "Find all files" })
    )

    -- 文本搜索
    keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", vim.tbl_extend("force", opts, { desc = "Live grep" }))
    keymap(
      "n",
      "<leader>fw",
      "<cmd>Telescope grep_string<CR>",
      vim.tbl_extend("force", opts, { desc = "Find word under cursor" })
    )

    -- Buffer 相关
    keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", vim.tbl_extend("force", opts, { desc = "Find buffers" }))

    -- 历史记录
    keymap(
      "n",
      "<leader>fo",
      "<cmd>Telescope oldfiles<CR>",
      vim.tbl_extend("force", opts, { desc = "Find recent files" })
    )
    keymap(
      "n",
      "<leader>fh",
      "<cmd>Telescope help_tags<CR>",
      vim.tbl_extend("force", opts, { desc = "Find help tags" })
    )
    keymap(
      "n",
      "<leader>fc",
      "<cmd>Telescope command_history<CR>",
      vim.tbl_extend("force", opts, { desc = "Command history" })
    )

    -- Git 相关
    keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", vim.tbl_extend("force", opts, { desc = "Git commits" }))
    keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", vim.tbl_extend("force", opts, { desc = "Git status" }))
    keymap(
      "n",
      "<leader>gb",
      "<cmd>Telescope git_branches<CR>",
      vim.tbl_extend("force", opts, { desc = "Git branches" })
    )

    -- LSP 相关
    keymap(
      "n",
      "<leader>fr",
      "<cmd>Telescope lsp_references<CR>",
      vim.tbl_extend("force", opts, { desc = "LSP references" })
    )
    keymap(
      "n",
      "<leader>fd",
      "<cmd>Telescope lsp_definitions<CR>",
      vim.tbl_extend("force", opts, { desc = "LSP definitions" })
    )
    keymap(
      "n",
      "<leader>fs",
      "<cmd>Telescope lsp_document_symbols<CR>",
      vim.tbl_extend("force", opts, { desc = "Document symbols" })
    )
    keymap(
      "n",
      "<leader>fS",
      "<cmd>Telescope lsp_workspace_symbols<CR>",
      vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
    )

    -- 其他实用功能
    keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", vim.tbl_extend("force", opts, { desc = "Find keymaps" }))
    keymap(
      "n",
      "<leader>ft",
      "<cmd>Telescope colorscheme<CR>",
      vim.tbl_extend("force", opts, { desc = "Change colorscheme" })
    )
    keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", vim.tbl_extend("force", opts, { desc = "Find marks" }))
  end,
}
