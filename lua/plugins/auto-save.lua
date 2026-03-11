return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" }, -- 懒加载，提升启动速度
  opts = {
    -- ==================== 基础配置 ====================
    enabled = true, -- 启用自动保存

    -- ==================== 触发条件 ====================
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" }, -- 立即保存的事件
      defer_save = { "InsertLeave", "TextChanged" }, -- 延迟保存的事件
      cancel_deferred_save = { "InsertEnter" }, -- 取消延迟保存的事件（修正拼写）
    },

    -- 忽略的文件类型（如临时文件、终端、Telescope 弹窗）
    ignore_filetypes = {
      "neo-tree",
      "TelescopePrompt",
      "dashboard",
      "terminal",
      "lazy",
      "nofile",
    },
    -- 忽略的缓冲区类型
    ignore_buftypes = { "nofile", "prompt", "terminal" },

    -- ==================== 保存条件 ====================
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      -- 不保存以下情况
      if
        fn.getbufvar(buf, "&modifiable") == 1 -- 缓冲区可修改
        and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) -- 不在排除的文件类型中
      then
        return true -- 满足条件，保存
      end
      return false -- 不满足条件，不保存
    end,

    -- ==================== 保存前后的:q钩子 ====================
    write_all_buffers = false, -- 只保存当前缓冲区，不保存所有缓冲区
    noautocmd = false, -- 触发 autocmd 事件（允许格式化等插件工作）

    -- ==================== 延迟保存配置 ====================
    debounce_delay = 1000, -- 延迟保存的时间（毫秒），避免频繁保存

    -- ==================== 回调函数 ====================
    callbacks = {
      enabling = nil, -- 启用自动保存时的回调
      disabling = nil, -- 禁用自动保存时的回调
      before_asserting_save = nil, -- 判断是否保存前的回调
      before_saving = nil, -- 保存前的回调
      after_saving = function(buf)
        -- 保存后的回调：显示提示（可选）
        if vim.g.auto_save_silent ~= true then
          local filename = vim.fn.expand("%:t")
          vim.notify("💾 " .. filename, vim.log.levels.INFO, {
            title = "Auto Save",
            timeout = 500, -- 500毫秒后自动消失
          })
        end
      end,
    },

    -- ==================== 排除的文件类型 ====================
    -- 可以通过 condition 函数中的 utils.not_in 来排除
    -- 或者直接在这里配置（需要修改 condition 函数）
  },

  config = function(_, opts)
    require("auto-save").setup(opts)

    -- 初始化状态追踪（插件默认启用）
    vim.g.my_auto_save_enabled = true

    -- ==================== 快捷键配置 ====================
    -- 切换自动保存开关
    vim.keymap.set("n", "<leader>as", function()
      local auto_save = require("auto-save")

      -- 执行切换
      auto_save.toggle()

      -- 切换我们的状态追踪
      vim.g.my_auto_save_enabled = not vim.g.my_auto_save_enabled

      -- 显示当前状态
      if vim.g.my_auto_save_enabled then
        vim.notify("✅ 自动保存已启用", vim.log.levels.INFO)
      else
        vim.notify("❌ 自动保存已禁用", vim.log.levels.WARN)
      end
    end, { desc = "切换自动保存" })

    -- 切换静默模式（不显示保存通知）aa
    vim.keymap.set("n", "<leader>aq", function()
      vim.g.auto_save_silent = not vim.g.auto_save_silent
      if vim.g.auto_save_silent then
        vim.notify("🔇 自动保存静默模式", vim.log.levels.INFO)
      else
        vim.notify("🔔 自动保存通知模式", vim.log.levels.INFO)
      end
    end, { desc = "切换自动保存静默模式" })
  end,
}
