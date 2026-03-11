return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- 为每种文件类型配置 linter
      lint.linters_by_ft = {
        -- Python: 使用 ruff（快速且全面，替代 flake8+pylint）
        python = { "ruff" },

        -- C/C++: 使用 cppcheck（静态分析）
        c = { "cppcheck" },
        cpp = { "cppcheck" },

        -- CMake: 使用 cmakelint
        cmake = { "cmakelint" },

        -- Shell: 使用 shellcheck
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        -- Lua：用 luacheck 检查（Neovim 配置）
        lua = { "luacheck" },
      }

      -- 自定义 cppcheck 配置
      lint.linters.cppcheck.args = {
        "--enable=warning,style,performance,portability",
        "--suppress=missingIncludeSystem",
        "--inline-suppr",
        "--quiet",
        "--template={file}:{line}:{column}: {severity}: {message} [{id}]",
      }

      -- 自动触发 linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- 只对可修改的正常 buffer 执行 lint
          if vim.bo.modifiable and vim.bo.buftype == "" then
            lint.try_lint()
          end
        end,
      })

      -- 手动触发 linting 的键映射
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
        vim.notify("Lint check completed", vim.log.levels.INFO, { title = "nvim-lint" })
      end, { desc = "Trigger linting for current file" })

      -- 显示当前 buffer 的 linters
      vim.keymap.set("n", "<leader>li", function()
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if linters then
          vim.notify("Linters for " .. vim.bo.filetype .. ": " .. table.concat(linters, ", "), vim.log.levels.INFO)
        else
          vim.notify("No linters configured for " .. vim.bo.filetype, vim.log.levels.WARN)
        end
      end, { desc = "Show linters for current filetype" })
    end,
  },
}
