return {
  -- nvim-ufo: 现代化的代码折叠插件
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async", -- 异步支持
    "nvim-treesitter/nvim-treesitter", -- treesitter支持
  },
  event = "BufReadPost", -- 延迟加载，打开文件时加载
  config = function()
    -- 基本选项配置
    vim.o.foldcolumn = "1" -- 显示折叠列（'0'隐藏, '1'显示）
    vim.o.foldlevel = 99 -- 打开文件时默认展开级别（99表示全部展开）
    vim.o.foldlevelstart = 99 -- 新缓冲区的初始折叠级别
    vim.o.foldenable = true -- 启用折叠
    -- 设置填充字符：简化配置，只设置fold和eob
    vim.o.fillchars = [[eob: ,fold: ]]

    -- 配置折叠提供者
    -- 优先使用treesitter，回退到indent
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" ... %d lines "):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end

    require("ufo").setup({
      -- 折叠提供者选择器
      provider_selector = function(bufnr, filetype, buftype)
        -- 优先使用treesitter，如果不可用则使用indent
        return { "treesitter", "indent" }
      end,

      -- 折叠虚拟文本处理函数
      fold_virt_text_handler = handler,

      -- 预览配置
      preview = {
        win_config = {
          border = "rounded", -- 预览窗口边框样式
          winblend = 0, -- 窗口透明度
          winhighlight = "Normal:Normal", -- 高亮组
        },
        mappings = {
          scrollU = "<C-u>", -- 向上滚动
          scrollD = "<C-d>", -- 向下滚动
          jumpTop = "[", -- 跳转到顶部
          jumpBot = "]", -- 跳转到底部
        },
      },
    })

    -- ============ 快捷键配置 ============
    local opts = { noremap = true, silent = true }

    -- zR: 打开所有折叠
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, opts)

    -- zM: 关闭所有折叠
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, opts)

    -- zr: 打开一级折叠
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, opts)

    -- zm: 关闭一级折叠
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, opts)

    -- K: 预览折叠（悬停显示折叠内容）
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- 如果没有折叠，则使用LSP的悬停功能
        vim.lsp.buf.hover()
      end
    end, opts)

    -- ============ 快速设置折叠层级 ============
    -- <leader>z0 到 <leader>z9: 快速跳转到指定折叠层级
    vim.keymap.set("n", "<leader>z0", function()
      vim.wo.foldlevel = 0
    end, { desc = "折叠所有层级" })

    vim.keymap.set("n", "<leader>z1", function()
      vim.wo.foldlevel = 1
    end, { desc = "折叠到第1层" })

    vim.keymap.set("n", "<leader>z2", function()
      vim.wo.foldlevel = 2
    end, { desc = "折叠到第2层" })

    vim.keymap.set("n", "<leader>z3", function()
      vim.wo.foldlevel = 3
    end, { desc = "折叠到第3层" })

    vim.keymap.set("n", "<leader>z4", function()
      vim.wo.foldlevel = 4
    end, { desc = "折叠到第4层" })

    vim.keymap.set("n", "<leader>z5", function()
      vim.wo.foldlevel = 5
    end, { desc = "折叠到第5层" })

    vim.keymap.set("n", "<leader>z9", function()
      vim.wo.foldlevel = 99
    end, { desc = "展开所有层级" })

    -- ============ 常用折叠快捷键说明 ============
    -- 以下是vim/nvim原生的折叠快捷键（nvim-ufo也支持）：
    --
    -- zo: 打开光标下的折叠
    -- zc: 关闭光标下的折叠
    -- za: 切换光标下的折叠（打开<->关闭）
    --
    -- zO: 递归打开光标下的所有折叠
    -- zC: 递归关闭光标下的所有折叠
    -- zA: 递归切换光标下的所有折叠
    --
    -- zR: 打开所有折叠（nvim-ufo增强）
    -- zM: 关闭所有折叠（nvim-ufo增强）
    --
    -- zr: 减少折叠级别（打开更多折叠）
    -- zm: 增加折叠级别（关闭更多折叠）
    --
    -- K:  预览折叠内容（nvim-ufo特性）
    --
    -- ============ 快速折叠层级（自定义） ============
    -- <leader>z0: 折叠所有层级
    -- <leader>z1: 只展开第1层
    -- <leader>z2: 只展开第2层
    -- <leader>z3: 只展开第3层
    -- <leader>z4: 只展开第4层
    -- <leader>z5: 只展开第5层
    -- <leader>z9: 展开所有层级
  end,
}
