return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- 打开文件时加载
    opts = {
      -- ==================== 侧边栏符号配置 ====================
      signs = {
        add = { text = "│" }, -- 新增行
        change = { text = "│" }, -- 修改行
        delete = { text = "_" }, -- 删除行
        topdelete = { text = "‾" }, -- 顶部删除
        changedelete = { text = "~" }, -- 修改并删除
        untracked = { text = "┆" }, -- 未跟踪文件
      },

      -- ==================== 行内 Blame 配置 ====================
      current_line_blame = true, -- 显示当前行的 Git blame
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 在行尾显示 (eol=end of line)
        delay = 500, -- 延迟500毫秒显示(避免干扰)
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

      -- ==================== 功能开关 ====================
      signcolumn = true, -- 启用侧边栏符号
      numhl = false, -- 不高亮行号
      linehl = false, -- 不高亮整行
      word_diff = false, -- 不启用单词级别diff
      watch_gitdir = {
        interval = 1000, -- 每秒检查Git目录变化
        follow_files = true, -- 跟踪文件移动
      },
      attach_to_untracked = true, -- 对未跟踪文件也显示标记

      -- ==================== 预览窗口配置 ====================
      preview_config = {
        border = "rounded", -- 圆角边框
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      -- ==================== 快捷键配置 ====================
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- 导航到下一个/上一个变更块（保持原有快捷键）
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "跳转到下一个变更" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "跳转到上一个变更" })

        -- Stage/Unstage 操作（统一使用 <leader>gh 前缀 = Git Hunk）
        map("n", "<leader>ghs", gs.stage_hunk, { desc = "Git: Stage 当前变更块" })
        map("n", "<leader>ghr", gs.reset_hunk, { desc = "Git: Reset 当前变更块" })
        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Git: Stage 选中的变更" })
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Git: Reset 选中的变更" })
        map("n", "<leader>ghS", gs.stage_buffer, { desc = "Git: Stage 整个文件" })
        map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Git: 撤销 Stage" })
        map("n", "<leader>ghR", gs.reset_buffer, { desc = "Git: Reset 整个文件" })

        -- 预览和查看
        map("n", "<leader>ghp", gs.preview_hunk, { desc = "Git: 预览变更" })
        map("n", "<leader>gbl", function()
          gs.blame_line({ full = true })
        end, { desc = "Git: 显示行 Blame" })
        map("n", "<leader>ghd", gs.diffthis, { desc = "Git: Diff 当前文件" })
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, { desc = "Git: Diff 与 HEAD~" })

        -- 切换开关
        map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Git: 切换 Blame 显示" })
        map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Git: 切换已删除内容显示" })

        -- Text object (用于操作变更块，改为 ig 避免与 ih 冲突)
        map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "选择 Git 变更块" })
      end,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim", -- 必需依赖
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "打开 LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit 当前文件历史" },
      { "<leader>gl", "<cmd>LazyGitFilter<cr>", desc = "LazyGit 项目提交历史" },
    },
    config = function()
      -- ==================== LazyGit 配置 ====================
      -- 使用浮动窗口打开
      vim.g.lazygit_floating_window_winblend = 0 -- 窗口透明度 (0-100)
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- 窗口缩放比例
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- 边框字符
      vim.g.lazygit_floating_window_use_plenary = 0 -- 不使用 plenary 窗口

      -- 使用 Neovim 远程功能编辑文件
      vim.g.lazygit_use_neovim_remote = 1

      -- ==================== 自定义配置路径 (可选) ====================
      -- 如果你有自定义的 lazygit 配置文件，可以取消注释
      -- vim.g.lazygit_use_custom_config_file_path = 1
      -- vim.g.lazygit_config_file_path = vim.fn.expand("~/.config/lazygit/config.yml")
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPost", -- 读取文件时加载
    opts = {
      -- ==================== 基础配置 ====================
      default_mappings = true, -- 启用默认快捷键
      default_commands = true, -- 启用默认命令
      disable_diagnostics = false, -- 不禁用诊断 (显示冲突警告)
      list_opener = "copen", -- 打开冲突列表的命令

      -- ==================== 高亮配置 ====================
      highlights = {
        incoming = "DiffAdd", -- Incoming 区域高亮 (绿色)
        current = "DiffText", -- Current 区域高亮 (蓝色)
        ancestor = "DiffChange", -- Ancestor 区域高亮 (黄色,如果是 diff3 模式)
      },

      -- ==================== 标记配置 ====================
      -- 自定义冲突标记的显示文本
      markers = {
        begin = "<<<<<<< ",
        middle = "=======",
        ["end"] = ">>>>>>> ",
      },
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)

      -- ==================== 快捷键说明 ====================
      -- 默认快捷键 (default_mappings = true):
      -- co - 选择 ours (当前分支的更改)
      -- ct - 选择 theirs (传入分支的更改)
      -- cb - 选择 both (保留双方更改)
      -- c0 - 选择 none (删除双方更改)
      -- ]x - 跳转到下一个冲突
      -- [x - 跳转到上一个冲突

      -- ==================== 自定义快捷键 ====================
      -- 默认快捷键不带 leader:
      -- co - 选择 ours (当前分支的更改)
      -- ct - 选择 theirs (传入分支的更改)
      -- cb - 选择 both (保留双方更改)
      -- c0 - 选择 none (删除双方更改)
      -- ]x - 跳转到下一个冲突
      -- [x - 跳转到上一个冲突

      -- 带 leader 的额外快捷键 (统一 <leader>gc 前缀避免与 lspsaga 冲突)
      vim.keymap.set("n", "<leader>gco", "<Plug>(git-conflict-ours)", { desc = "Git冲突: 选择 Ours" })
      vim.keymap.set("n", "<leader>gct", "<Plug>(git-conflict-theirs)", { desc = "Git冲突: 选择 Theirs" })
      vim.keymap.set("n", "<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Git冲突: 选择 Both" })
      vim.keymap.set("n", "<leader>gc0", "<Plug>(git-conflict-none)", { desc = "Git冲突: 选择 None" })
      vim.keymap.set("n", "<leader>gcq", "<cmd>GitConflictListQf<cr>", { desc = "Git冲突: 列出所有冲突" })

      -- ==================== 自动命令 (可选) ====================
      -- 自动在冲突文件中提示用户
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("发现 Git 冲突!", vim.log.levels.WARN)
        end,
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>dvo", "<cmd>DiffviewOpen<cr>", desc = "打开 Diffview" },
      { "<leader>dvc", "<cmd>DiffviewClose<cr>", desc = "关闭 Diffview" },
      { "<leader>dvh", "<cmd>DiffviewFileHistory %<cr>", desc = "当前文件历史" },
      { "<leader>dvH", "<cmd>DiffviewFileHistory<cr>", desc = "项目提交历史" },
    },
    opts = {
      -- ==================== 布局配置 ====================
      diff_binaries = false, -- 不显示二进制文件的 diff
      enhanced_diff_hl = true, -- 增强的 diff 高亮
      use_icons = true, -- 使用图标

      -- ==================== 视图配置 ====================
      view = {
        default = {
          layout = "diff2_horizontal", -- 默认水平分割
          winbar_info = true, -- 显示顶部信息栏
        },
        merge_tool = {
          layout = "diff3_horizontal", -- 合并冲突使用三路对比
          disable_diagnostics = true, -- 解决冲突时禁用诊断
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },
      },

      -- ==================== 文件面板配置 ====================
      file_panel = {
        listing_style = "tree", -- 树形显示 (可选: "list")
        tree_options = {
          flatten_dirs = true, -- 折叠单层目录
          folder_statuses = "only_folded", -- 只显示折叠文件夹的状态
        },
        win_config = {
          position = "left", -- 文件面板位置
          width = 35, -- 文件面板宽度
        },
      },

      -- ==================== 快捷键配置 ====================
      keymaps = {
        disable_defaults = false, -- 保留默认快捷键
        view = {
          -- Diff 视图快捷键
          { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "切换文件面板" } },
          { "n", "gf", "<cmd>DiffviewFocusFiles<cr>", { desc = "聚焦文件面板" } },
          { "n", "[x", "<cmd>lua require('diffview.actions').prev_conflict()<cr>", { desc = "上一个冲突" } },
          { "n", "]x", "<cmd>lua require('diffview.actions').next_conflict()<cr>", { desc = "下一个冲突" } },
        },
        file_panel = {
          -- 文件面板快捷键
          { "n", "j", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "下一个条目" } },
          { "n", "k", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "上一个条目" } },
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "打开 diff" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "打开 diff" } },
          { "n", "s", "<cmd>lua require('diffview.actions').toggle_stage_entry()<cr>", { desc = "Stage/Unstage" } },
          { "n", "S", "<cmd>lua require('diffview.actions').stage_all()<cr>", { desc = "Stage 全部" } },
          { "n", "U", "<cmd>lua require('diffview.actions').unstage_all()<cr>", { desc = "Unstage 全部" } },
          { "n", "R", "<cmd>lua require('diffview.actions').refresh_files()<cr>", { desc = "刷新" } },
          {
            "n",
            "<tab>",
            "<cmd>lua require('diffview.actions').select_next_entry()<cr>",
            { desc = "下一个文件" },
          },
          {
            "n",
            "<s-tab>",
            "<cmd>lua require('diffview.actions').select_prev_entry()<cr>",
            { desc = "上一个文件" },
          },
          { "n", "gf", "<cmd>lua require('diffview.actions').goto_file()<cr>", { desc = "跳转到文件" } },
          {
            "n",
            "<C-w>gf",
            "<cmd>lua require('diffview.actions').goto_file_split()<cr>",
            { desc = "分割打开文件" },
          },
          { "n", "i", "<cmd>lua require('diffview.actions').listing_style()<cr>", { desc = "切换列表样式" } },
        },
        file_history_panel = {
          -- 历史面板快捷键
          { "n", "g!", "<cmd>lua require('diffview.actions').options()<cr>", { desc = "打开选项面板" } },
          {
            "n",
            "D",
            "<cmd>lua require('diffview.actions').open_in_diffview()<cr>",
            { desc = "在 Diffview 中打开" },
          },
          { "n", "y", "<cmd>lua require('diffview.actions').copy_hash()<cr>", { desc = "复制 commit hash" } },
          { "n", "<c-d>", "<cmd>lua require('diffview.actions').scroll_view(-0.25)<cr>", { desc = "向下滚动" } },
          { "n", "<c-u>", "<cmd>lua require('diffview.actions').scroll_view(0.25)<cr>", { desc = "向上滚动" } },
        },
      },

      -- ==================== Hooks 配置 ====================
      hooks = {
        -- 在 diff buffer 中禁用某些插件功能
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false -- 不换行
          vim.opt_local.list = false -- 不显示不可见字符
          vim.opt_local.colorcolumn = "" -- 不显示列标记
        end,
      },
    },
  },
}
