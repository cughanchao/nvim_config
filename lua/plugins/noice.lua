-- ===================== noice.nvim 插件配置 =====================
-- noice.nvim 是一个增强 Neovim UI 的插件，用于改善命令行、消息和通知的显示效果
-- GitHub: https://github.com/folke/noice.nvim

return {
  -- noice.nvim 主插件
  {
    "folke/noice.nvim",
    event = "VeryLazy", -- 懒加载，在启动后延迟加载以提高启动速度
    dependencies = {
      -- 依赖 1: nui.nvim - 提供 UI 组件库
      "MunifTanjim/nui.nvim",

      -- 依赖 2: nvim-notify - 美化的通知系统（可选但推荐）
      -- 如果不需要通知功能，可以删除这个依赖
      {
        "rcarriga/nvim-notify",
        config = function()
          -- nvim-notify 配置
          require("notify").setup({
            -- 通知显示时长（毫秒）
            timeout = 3000,

            -- 通知位置：top_left, top_right, bottom_left, bottom_right
            top_down = true, -- 从上往下排列

            -- 最大宽度和高度
            max_width = 50,
            max_height = 10,

            -- 背景透明度（0-100，0为完全透明）
            background_colour = "#000000",

            -- 通知级别的图标
            icons = {
              ERROR = "",
              WARN = "",
              INFO = "",
              DEBUG = "",
              TRACE = "✎",
            },

            -- 渲染样式：default, minimal, simple, compact
            render = "default",

            -- 动画阶段配置
            stages = "fade_in_slide_out", -- fade_in_slide_out, fade, slide, static
          })

          -- 设置 nvim-notify 为默认通知系统
          vim.notify = require("notify")
        end,
      },
    },

    -- noice.nvim 主配置
    config = function()
      require("noice").setup({
        -- ========== 命令行配置 ==========
        cmdline = {
          enabled = true, -- 启用增强的命令行
          view = "cmdline_popup", -- 命令行显示样式：cmdline_popup（弹窗）、cmdline（底部）

          -- 命令行图标配置（不同命令显示不同图标）
          format = {
            -- 默认命令（如 :set、:edit）
            cmdline = { pattern = "^:", icon = "", lang = "vim" },

            -- 搜索命令（正向搜索 /）
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },

            -- 反向搜索（?）
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },

            -- 过滤命令（:!）
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },

            -- Lua 命令（:lua）
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },

            -- 帮助命令（:help）
            help = { pattern = "^:%s*he?l?p?%s+", icon = "" },

            -- 输入命令（:input）
            input = {}, -- 用于 vim.ui.input
          },
        },

        -- ========== 消息配置 ==========
        messages = {
          enabled = true, -- 启用增强的消息系统
          view = "notify", -- 消息显示方式：notify（通知）、mini（迷你）、split（分割窗口）
          view_error = "notify", -- 错误消息视图
          view_warn = "notify", -- 警告消息视图
          view_history = "messages", -- 历史消息视图（:messages 命令）
          view_search = "virtualtext", -- 搜索计数显示方式：virtualtext（虚拟文本）、false（禁用）
        },

        -- ========== 弹窗通知配置 ==========
        popupmenu = {
          enabled = true, -- 启用弹窗菜单（补全菜单）
          backend = "nui", -- 后端：nui（使用 nui.nvim）、cmp（使用 nvim-cmp 的菜单）

          -- 弹窗菜单样式
          kind_icons = {}, -- 使用默认图标（可自定义补全项图标）
        },

        -- ========== 通知配置 ==========
        notify = {
          enabled = true, -- 启用通知功能
          view = "notify", -- 通知显示方式
        },

        -- ========== LSP 配置 ==========
        lsp = {
          -- 进度消息配置（如 LSP 加载进度）
          progress = {
            enabled = true, -- 启用 LSP 进度消息
            format = "lsp_progress", -- 进度消息格式
            format_done = "lsp_progress_done", -- 完成消息格式
            throttle = 1000 / 30, -- 更新频率（毫秒），降低频率可减少性能开销
            view = "mini", -- 进度消息显示方式：mini（右下角）、notify（通知）
          },

          -- 悬停文档配置（K 键触发）
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true, -- 使用 noice 渲染 markdown
            ["vim.lsp.util.stylize_markdown"] = true, -- 使用 noice 美化 markdown
            ["cmp.entry.get_documentation"] = true, -- 使用 noice 渲染补全文档
          },

          -- 悬停文档显示配置
          hover = {
            enabled = true, -- 启用悬停文档
            silent = false, -- 是否静默（不显示"无悬停信息"提示）
            view = nil, -- 使用默认视图
            opts = {}, -- 额外选项
          },

          -- 签名帮助配置（函数参数提示）
          signature = {
            enabled = true, -- 启用签名帮助
            auto_open = {
              enabled = true, -- 自动打开签名帮助
              trigger = true, -- 在触发字符（如 '('）时自动打开
              luasnip = true, -- 与 LuaSnip 集成
              throttle = 50, -- 节流时间（毫秒）
            },
            view = nil, -- 使用默认视图
            opts = {}, -- 额外选项
          },

          -- LSP 消息配置
          message = {
            enabled = true, -- 启用 LSP 消息
            view = "notify", -- 消息显示方式
            opts = {}, -- 额外选项
          },

          -- LSP 文档配置
          documentation = {
            view = "hover", -- 文档显示方式
            opts = {
              lang = "markdown", -- 文档语言
              replace = true, -- 替换现有文档窗口
              render = "plain", -- 渲染方式：plain（纯文本）、markdown
              format = { "{message}" }, -- 格式化
              win_options = { concealcursor = "n", conceallevel = 3 }, -- 窗口选项
            },
          },
        },

        -- ========== 预设配置 ==========
        presets = {
          bottom_search = false, -- 使用经典的底部命令行搜索（false 则使用弹窗）
          command_palette = true, -- 启用命令面板样式（Ctrl+P 风格）
          long_message_to_split = true, -- 长消息发送到分割窗口
          inc_rename = false, -- 启用 inc-rename.nvim 的输入对话框
          lsp_doc_border = true, -- 为 LSP 文档和悬停添加边框
        },

        -- ========== 路由配置 ==========
        -- 路由用于自定义特定消息的显示方式
        routes = {
          -- 示例：跳过"已写入"消息
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written", -- 匹配包含 "written" 的消息
            },
            opts = { skip = true }, -- 跳过显示
          },

          -- 示例：跳过搜索计数消息（如 [1/10]）
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "%d+L, %d+B", -- 匹配行/字节数消息
            },
            opts = { skip = true },
          },

          -- 示例：将长消息发送到分割窗口
          {
            filter = {
              event = "msg_show",
              min_height = 20, -- 超过 20 行的消息
            },
            view = "split", -- 使用分割窗口显示
          },

          -- 示例：过滤 vim.notify 的特定消息
          -- {
          --   filter = {
          --     event = "notify",
          --     find = "No information available", -- 匹配特定文本
          --   },
          --   opts = { skip = true },
          -- },
        },

        -- ========== 视图配置 ==========
        -- 自定义不同视图的外观和行为
        views = {
          -- 命令行弹窗配置
          cmdline_popup = {
            position = {
              row = "50%", -- 垂直位置（屏幕中央）
              col = "50%", -- 水平位置（屏幕中央）
            },
            size = {
              width = 60, -- 宽度
              height = "auto", -- 高度自动调整
            },
            border = {
              style = "rounded", -- 边框样式：rounded（圆角）、single（单线）、double（双线）、none（无）
              padding = { 0, 1 }, -- 内边距（上下，左右）
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder", -- 高亮组
            },
          },

          -- 弹窗菜单配置（补全菜单）
          popupmenu = {
            relative = "editor", -- 相对位置：editor（编辑器）、cursor（光标）
            position = {
              row = 8, -- 距离顶部的行数
              col = "50%", -- 水平居中
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" }, -- 自定义高亮
            },
          },

          -- 迷你视图配置（用于进度消息）
          mini = {
            position = {
              row = -2, -- 距离底部 2 行
              col = "100%", -- 右对齐
            },
            size = {
              width = "auto",
              height = "auto",
            },
            border = {
              style = "rounded",
            },
            win_options = {
              winblend = 0, -- 透明度（0-100）
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "FloatBorder",
              },
            },
          },
        },

        -- ========== 其他配置 ==========
        -- 命令历史配置
        -- commands = {
        --   history = {
        --     view = "split", -- 历史记录显示方式
        --     filter = {
        --       any = {
        --         { event = "notify" },
        --         { error = true },
        --         { warning = true },
        --         { event = "msg_show", kind = { "" } },
        --         { event = "lsp", kind = "message" },
        --       },
        --     },
        --   },
        -- },
      })
    end,

    -- ========== 快捷键配置 ==========
    keys = {
      -- 查看消息历史
      { "<leader>nm", "<cmd>Noice<cr>", desc = "Noice: 查看所有消息" },

      -- 查看最后一条消息
      { "<leader>nl", "<cmd>Noice last<cr>", desc = "Noice: 查看最后一条消息" },

      -- 查看消息历史（telescope 风格）
      { "<leader>nh", "<cmd>Noice telescope<cr>", desc = "Noice: 消息历史（Telescope）" },

      -- 清除所有通知
      { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Noice: 清除所有通知" },

      -- 启用/禁用 Noice
      { "<leader>nE", "<cmd>Noice enable<cr>", desc = "Noice: 启用" },
      { "<leader>nD", "<cmd>Noice disable<cr>", desc = "Noice: 禁用" },

      -- 查看错误消息
      { "<leader>ne", "<cmd>Noice errors<cr>", desc = "Noice: 查看错误消息" },

      -- 统计信息
      { "<leader>ns", "<cmd>Noice stats<cr>", desc = "Noice: 统计信息" },
    },
  },
}
