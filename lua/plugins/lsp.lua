return {

  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "pyright",
          "bashls",
          "yamlls",
          -- "rust_analyzer",
          -- "cmake",
          -- "eslint",
          -- "rome",
        },
        automatic_installation = true, -- 自动安装已配置的 LSP
      })
      -- 快捷键：leader + lsp 打开 mason 界面
      vim.keymap.set("n", "<leader>lsp", "<cmd>Mason<CR>", { desc = "Open Mason LSP manager" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 配置 Lua LSP (lua_ls)
      -- 使用 Neovim 0.11+ 推荐的 vim.lsp.config API
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            completion = {
              callSnippet = "Replace",
              keywordSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- 为 lazydev 添加库支持
                "${3rd}/luv/library",
              },
            },
            telemetry = { enable = false },
          },
        },
      })

      -- 配置 Python LSP (pyright)
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
            },
            pythonPath = vim.fn.exepath("python3") or vim.fn.exepath("python"),
          },
        },
      })

      -- 配置 clangd
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--fallback-style=google",
        },
        filetypes = { "c", "cpp", "cc", "objc", "objcpp", "h", "hpp" },
      })

      -- CMake: cmake
      vim.lsp.config("cmake", {
        capabilities = capabilities,
        filetypes = { "cmake", "CMakeLists.txt" },
      })

      -- Yaml: yamlls
      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        filetypes = { "yaml", "yml" },
      })

      -- Bash: bashls
      vim.lsp.config("bashls", {
        capabilities = capabilities,
      })

      -- 启用所有 LSP
      vim.lsp.enable({ "lua_ls", "pyright", "clangd", "cmake", "yamlls", "bashls" })

      -- 配置诊断显示（过滤 vim 相关警告作为后备方案）
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- 过滤所有与 vim 变量相关的警告
            local message = diagnostic.message or ""
            if
              message:match("lowercase%-global")
              or message:match("mutating non%-standard global")
              or message:match("global variable 'vim'")
              or message:match("undefined variable 'vim'")
              or message:match("accessing undefined variable 'vim'")
            then
              return nil
            end
            return diagnostic.message
          end,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP 快捷键已由 lspsaga.lua 配置，此处注释避免冲突
      -- vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
      -- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Find references" })
      -- vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostics" })
    end,
  },

  -- =====================================================================
  -- Lspsaga: 增强 LSP 功能的 UI 插件
  -- 功能：美化的悬停文档、代码操作、重命名、诊断跳转、符号大纲等
  -- 官方文档: https://nvimdev.github.io/lspsaga/
  -- =====================================================================
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- 语法高亮支持
      "nvim-tree/nvim-web-devicons", -- 图标支持
      "neovim/nvim-lspconfig", -- LSP 核心（必须）
    },
    event = "LspAttach", -- 当 LSP 附加到缓冲区时加载（延迟加载，提升启动速度）

    config = function()
      require("lspsaga").setup({

        -- ==================== UI 界面设置 ====================
        ui = {
          border = "rounded", -- 浮动窗口边框样式：rounded(圆角), single(单线), double(双线), shadow(阴影)
          winblend = 10, -- 窗口透明度（0-100）
          code_action = "💡", -- 代码操作提示图标（左侧显示的灯泡,需 Nerd Font）
          diagnostic = "", -- 诊断图标
          colors = {
            normal_bg = "", -- 空字符串表示使用默认背景色
          },
        },

        -- ==================== 符号路径导航（窗口顶部） ====================
        -- 在窗口顶部显示当前光标所在的符号路径（如：Class > Method > Variable）
        symbol_in_winbar = {
          enable = true, -- 启用符号路径显示
          separator = " › ", -- 路径分隔符
          show_file = true, -- 显示文件名
          folder_level = 2, -- 显示文件夹层级数量
          color_mode = true, -- 使用语义高亮颜色
        },

        -- ==================== 诊断信息设置 ====================
        -- 控制错误、警告等诊断信息的显示方式
        diagnostic = {
          on_insert = false, -- Insert 模式不显示诊断（避免卡顿）
          on_insert_follow = false,
          show_code_action = true, -- 在诊断浮窗中显示可用的代码操作
          show_source = true,
          jump_num_shortcut = true,
          border_follow = true, -- 浮窗边框颜色跟随诊断严重程度（错误=红色、警告=黄色）
          diagnostic_only_current = false, -- false=显示所有诊断，true=只显示当前行诊断
          max_width = 0.8, -- 诊断浮窗最大宽度（0.8 = 屏幕宽度的 80%）
          max_height = 0.6, -- 诊断浮窗最大高度
          max_show_width = 0.9, -- 最大显示宽度
          max_show_height = 0.6, -- 最大显示高度
          text_hl_follow = true, -- 文本高亮跟随诊断颜色
        },

        -- ==================== 代码操作设置 ====================
        -- 控制代码操作（Code Action）的显示和交互
        code_action = {
          num_shortcut = true, -- 显示数字快捷键（1, 2, 3...），可按数字快速选择
          show_server_name = true, -- 显示提供该操作的 LSP 服务器名称
          extend_gitsigns = false, -- 是否扩展 gitsigns 插件的操作（需安装 gitsigns）
          keys = {
            quit = "<Esc>", -- 退出代码操作窗口的快捷键
            exec = "<CR>", -- 执行选中操作的快捷键（回车）
          },
        },

        -- ==================== 悬停文档设置 ====================
        -- 控制 K 键显示的悬停文档窗口（函数签名、类型信息等）
        hover = {
          max_width = 0.8, -- 最大宽度（0.6 = 屏幕宽度的 60%）
          max_height = 0.8, -- 最大高度
          auto_close = true, -- 光标离开时自动关闭悬浮窗
          open_link = "gx", -- 在文档中打开链接的快捷键（例如打开 HTTP 链接）
          open_cmd = "!open", -- macOS 打开链接的命令（Linux 用 "!xdg-open"）
        },

        -- ==================== 定义预览设置 ====================
        -- 控制 "预览定义" 功能的浮窗行为
        definition = {
          width = 0.8, -- 预览窗口宽度
          height = 0.5, -- 预览窗口高度
          keys = {
            edit = "<CR>", -- 在当前窗口打开定义
            vsplit = "<C-v>", -- 垂直分屏打开定义
            split = "<C-h>", -- 水平分屏打开定义
            tabe = "<C-t>", -- 在新标签页打开定义
            quit = "<Esc>", -- 关闭预览窗口
            close = "<C-c>", -- 关闭预览窗口（同 quit）
          },
        },

        -- ==================== 重命名设置 ====================
        -- 控制符号重命名的交互方式
        rename = {
          in_select = true, -- 打开重命名窗口时自动选中当前符号名称（方便直接输入）
          auto_save = false, -- 重命名后不自动保存文件（建议手动保存，避免误操作）
          project_max_width = 0.6, -- 项目级重命名窗口最大宽度
          project_max_height = 0.5, -- 项目级重命名窗口最大高度
          keys = {
            quit = "<C-c>", -- 取消重命名
            exec = "<CR>", -- 执行重命名（回车确认）
            select = "x", -- 选择/取消选择某个重命名目标
          },
        },

        -- ==================== 符号大纲设置 ====================
        -- 控制右侧符号大纲（Outline）窗口的行为
        outline = {
          win_position = "right", -- 大纲窗口位置：right(右侧), left(左侧)
          win_width = 35, -- 大纲窗口宽度（字符数）
          auto_preview = true, -- 光标移动时自动预览符号定义
          detail = true, -- 显示符号详细信息（参数、返回类型等）
          auto_close = true, -- 跳转到符号后自动关闭大纲窗口
          close_after_jump = false, -- 跳转后是否立即关闭（false=保持打开）
          layout = "normal", -- 布局样式：normal(常规), float(浮动窗口)
          max_height = 0.5, -- 最大高度（浮动模式下生效）
          left_width = 0.3, -- 左侧宽度（浮动模式下生效）
          keys = {
            toggle_or_jump = "<CR>", -- 展开/折叠或跳转到符号
            quit = "<Esc>", -- 关闭大纲窗口
            jump = "e", -- 跳转到符号定义
          },
        },

        -- ==================== Lightbulb（灯泡提示） ====================
        -- 在有代码操作可用时，在左侧显示灯泡图标提示
        lightbulb = {
          enable = true, -- 启用灯泡提示
          sign = true, -- 在符号列（sign column）显示灯泡
          virtual_text = false, -- 不在行尾显示虚拟文本提示（避免干扰）
        },

        -- ==================== 滚动预览设置 ====================
        -- 控制预览窗口的滚动行为
        scroll_preview = {
          scroll_down = "<C-d>", -- 向下滚动预览窗口
          scroll_up = "<C-u>", -- 向上滚动预览窗口
        },

        -- ==================== 查找器设置 ====================
        -- 控制 "查找引用/实现" 功能的显示
        finder = {
          max_height = 0.6, -- 最大高度
          default = "ref+imp", -- 默认显示：ref(引用) + imp(实现)
          layout = "float", -- 布局：float(浮动), normal(常规)
          silent = false, -- 不静默（显示查找结果数量）
          keys = {
            shuttle = "[w", -- 在结果区和预览区之间切换焦点
            toggle_or_open = "<CR>", -- 展开/折叠或打开结果
            vsplit = "<C-v>", -- 垂直分屏打开
            split = "<C-h>", -- 水平分屏打开
            tabe = "<C-t>", -- 在新标签页打开
            tabnew = "t", -- 在新标签页打开（同上）
            quit = "<Esc>", -- 关闭查找器
            close = "<C-c>", -- 关闭查找器
          },
        },
      })

      -- =====================================================================
      -- 快捷键配置（详细说明）
      -- 说明：<leader> 默认是空格键，可在 init.lua 中修改
      -- =====================================================================

      local keymap = vim.keymap.set

      -- ==================== 诊断跳转 ====================
      -- 在代码中跳转到下一个/上一个错误或警告
      keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
        desc = "跳转到上一个诊断问题（错误/警告）",
      })
      keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", {
        desc = "跳转到下一个诊断问题（错误/警告）",
      })

      -- 只跳转错误（忽略警告、提示等）
      keymap("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, {
        desc = "跳转到上一个错误（仅错误，忽略警告）",
      })
      keymap("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, {
        desc = "跳转到下一个错误（仅错误，忽略警告）",
      })

      -- ==================== 悬停文档 ====================
      -- 替代 Neovim 原生的 K 键，显示更美观的悬停文档
      -- 用途：查看函数签名、变量类型、类/方法的文档注释
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", {
        desc = "显示悬停文档（函数签名/类型/文档注释）",
      })
      -- 在悬停窗口内按两次 K 可将光标移入窗口，方便查看长文档
      keymap("n", "KK", "<cmd>Lspsaga hover_doc ++keep<CR>", {
        desc = "显示悬停文档并保持焦点在窗口内",
      })

      -- ==================== 定义跳转 ====================
      -- gd: Go to Definition（跳转到定义）
      keymap("n", "gd", function()
        require("lspsaga.definition"):init(1, 1)
      end, {
        desc = "跳转到定义（打开定义所在文件）",
      })
      -- gD: Peek Definition（预览定义，不离开当前文件）
      keymap("n", "gD", function()
        require("lspsaga.definition"):init(2, 1)
      end, {
        desc = "在浮窗中预览定义（不离开当前文件）",
      })

      -- ==================== 类型定义跳转 ====================
      -- gt: Go to Type Definition（跳转到类型定义）
      keymap("n", "gt", function()
        require("lspsaga.definition"):init(1, 2)
      end, {
        desc = "跳转到类型定义（例如：变量的类定义）",
      })
      -- gT: Peek Type Definition（预览类型定义）
      keymap("n", "gT", function()
        require("lspsaga.definition"):init(2, 2)
      end, {
        desc = "在浮窗中预览类型定义",
      })

      -- ==================== 查找引用和实现 ====================
      -- gr: Go to References（查找所有引用该符号的位置）
      keymap("n", "gr", "<cmd>Lspsaga finder<CR>", {
        desc = "查找符号的引用和实现（弹出查找器）",
      })
      -- 只查找引用（不包含实现）
      keymap("n", "gR", "<cmd>Lspsaga finder ref<CR>", {
        desc = "仅查找引用（不显示实现）",
      })

      -- ==================== 代码操作 ====================
      -- <leader>ca: Code Action（代码操作）
      -- 用途：自动修复错误、导入缺失模块、生成代码等
      -- 支持普通模式和可视模式（可选中代码块后执行）
      keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", {
        desc = "显示可用的代码操作（修复/重构/导入）",
      })

      -- ==================== 重命名 ====================
      -- <leader>rn: Rename（重命名符号）
      -- 用途：重命名变量、函数、类等，自动更新所有引用
      keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", {
        desc = "重命名当前符号（变量/函数/类）",
      })
      -- 项目级重命名（包括其他文件中的引用）
      keymap("n", "<leader>rN", "<cmd>Lspsaga rename ++project<CR>", {
        desc = "项目级重命名（跨文件重命名所有引用）",
      })

      -- ==================== 显示诊断信息 ====================
      -- gl: Show Line Diagnostics（显示当前行的诊断信息）
      keymap("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", {
        desc = "显示当前行的诊断信息（错误/警告详情）",
      })
      -- gL: Show Cursor Diagnostics（显示光标所在位置的诊断）
      keymap("n", "gL", "<cmd>Lspsaga show_cursor_diagnostics<CR>", {
        desc = "显示光标位置的诊断信息",
      })
      -- <leader>ld: Show Buffer Diagnostics（显示整个文件的诊断列表）
      keymap("n", "<leader>ld", "<cmd>Lspsaga show_buf_diagnostics<CR>", {
        desc = "显示当前缓冲区的所有诊断信息",
      })

      -- ==================== 符号大纲 ====================
      -- <leader>o: Outline（切换符号大纲窗口）
      -- 用途：显示当前文件的所有函数、类、变量等符号列表
      keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", {
        desc = "切换符号大纲（显示文件结构）",
      })

      -- ==================== 浮动终端 ====================
      -- <leader>tt: Toggle Terminal（切换浮动终端）
      keymap("n", "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", {
        desc = "切换浮动终端（打开/关闭）",
      })
      -- 终端模式下用 Ctrl+x 快速关闭终端
      keymap("t", "<C-x>", "<C-\\><C-n><cmd>Lspsaga term_toggle<CR>", {
        desc = "在终端模式下关闭终端",
      })

      -- ==================== 调用层次 ====================
      -- 查看函数的调用关系（谁调用了这个函数，这个函数调用了谁）
      keymap("n", "<leader>lci", "<cmd>Lspsaga incoming_calls<CR>", {
        desc = "查看调用当前函数的所有位置（调用方）",
      })
      keymap("n", "<leader>lco", "<cmd>Lspsaga outgoing_calls<CR>", {
        desc = "查看当前函数调用的所有函数（被调用方）",
      })
    end,
  },
}
