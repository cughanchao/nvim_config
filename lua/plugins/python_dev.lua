return {
  -- ==================== Python 代码运行 ====================
  {
    "CRAG666/code_runner.nvim", -- 轻量的代码运行插件
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("code_runner").setup({
        -- 配置Python运行命令（支持虚拟环境）
        filetype = {
          python = function()
            -- 自动识别当前目录的虚拟环境（优先venv/bin/python）
            local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
            if vim.fn.filereadable(venv_python) == 1 then
              return venv_python .. " $file"
            end
            -- 动态查找系统中的 python3 或 python
            local python_cmd = vim.fn.exepath("python3") ~= "" and "python3" or vim.fn.exepath("python")
            if python_cmd == "" then
              vim.notify("Python not found in PATH", vim.log.levels.ERROR)
              return "python3 $file" -- Fallback
            end
            return python_cmd .. " $file"
          end,
        },
        -- 运行窗口配置：浮动窗口（更美观）
        -- mode = "float",
        -- float = {
        --   border = "rounded", -- 使用圆角边框
        --   height = 0.8, -- 窗口高度占屏幕80%
        --   width = 0.8, -- 窗口宽度占屏幕80%
        -- },
      })

      -- 快捷键：<leader>pr 运行当前Python脚本
      vim.keymap.set("n", "<leader>rr", "<cmd>RunCode<CR>", { desc = "Run Python script" })
      -- 快捷键：<leader>prc 关闭运行窗口
      vim.keymap.set("n", "<leader>rc", "<cmd>RunClose<CR>", { desc = "Close run window" })
    end,
  },

  -- ==================== Python 调试器 (DAP) ====================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui", -- 调试 UI 界面
      "nvim-neotest/nvim-nio", -- nvim-dap-ui 依赖
      "mfussenegger/nvim-dap-python", -- Python 调试支持
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- 1. 配置 Python 调试器（使用 debugpy）
      -- 动态查找 Python 解释器路径
      local function find_python_path()
        -- 优先使用虚拟环境中的 Python
        local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
        if vim.fn.filereadable(venv_python) == 1 then
          return venv_python
        end
        -- 查找 conda 环境
        local conda_prefix = vim.env.CONDA_PREFIX
        if conda_prefix then
          local conda_python = conda_prefix .. "/bin/python"
          if vim.fn.filereadable(conda_python) == 1 then
            return conda_python
          end
        end
        -- 使用系统 Python
        local system_python = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
        if system_python ~= "" then
          return system_python
        end
        -- 最后尝试 miniconda（如果存在）
        local miniconda_python = vim.env.HOME .. "/.local/miniconda3/bin/python3"
        if vim.fn.filereadable(miniconda_python) == 1 then
          return miniconda_python
        end
        vim.notify("Python interpreter not found for DAP", vim.log.levels.WARN)
        return "python3" -- Fallback
      end

      require("dap-python").setup(find_python_path(), {
        include_configs = true,
        console = "integratedTerminal",
        pythonPath = find_python_path,
      })

      -- 在默认配置基础上添加 Python 3.13 修复
      local python_configs = dap.configurations.python or {}
      for _, config in ipairs(python_configs) do
        if not config.pythonArgs then
          config.pythonArgs = {}
        end
        -- 添加 Python 3.13 frozen modules 修复
        table.insert(config.pythonArgs, "-Xfrozen_modules=off")
      end

      -- 2. 配置调试 UI 界面
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 }, -- 变量作用域
              { id = "breakpoints", size = 0.25 }, -- 断点列表
              { id = "stacks", size = 0.25 }, -- 调用栈
              { id = "watches", size = 0.25 }, -- 监视表达式
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 }, -- 调试控制台
              { id = "console", size = 0.5 }, -- 程序输出
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- 3. 自动打开/关闭调试 UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- 4. 调试快捷键
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue debugging" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last debug config" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate debugging" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })

      -- 5. 调试图标配置（美化）
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
    end,
  },
}
