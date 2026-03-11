return {
  {
    "Civitasv/cmake-tools.nvim", -- CMake 项目管理
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "akinsho/toggleterm.nvim",
    },
    config = function()
      -- 1. CMake 配置
      require("cmake-tools").setup({
        cmake_command = "cmake",
        build_directory = "build", -- 编译目录
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- 生成编译命令（供clangd用）
        cmake_build_options = { "-j8" }, -- 8线程编译（根据CPU核心调整）
        debug = {
          adapter = "lldb-vscode", -- 调试器：lldb-vscode
        },
      })

      -- 2. ToggleTerm 集成终端（运行/编译输出）
      -- require("toggleterm").setup({
      --   size = 15,
      --   direction = "horizontal",
      --   open_mapping = [[<leader>t]],
      -- })

      -- 3. 自定义快捷键（单文件编译+运行）
      -- local function compile_and_run_single_file()
      --   local file = vim.fn.expand("%") -- 当前文件
      --   local exe = vim.fn.expand("%:r") -- 可执行文件名（去掉后缀）
      --   local cmd = ""
      --
      --   -- 判断文件类型（C/C++）
      --   if vim.bo.filetype == "c" then
      --     cmd = "gcc -o " .. exe .. " " .. file .. " && ./" .. exe
      --   elseif vim.bo.filetype == "cpp" then
      --     cmd = "g++ -o " .. exe .. " " .. file .. " && ./" .. exe
      --   end
      --
      --   -- 在终端中执行命令
      --   local Terminal = require("toggleterm.terminal").Terminal
      --   local term = Terminal:new({ cmd = cmd, hidden = true })
      --   term:toggle()
      -- end

      -- 快捷键映射
      -- vim.keymap.set("n", "<leader>r", compile_and_run_single_file, { desc = "Run single C/C++ file" })
      vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "CMake Build" }) -- CMake 编译
      vim.keymap.set("n", "<leader>cr", "<cmd>CMakeRun<CR>", { desc = "CMake Run" }) -- CMake 运行
      vim.keymap.set("n", "<leader>cc", "<cmd>CMakeClean<CR>", { desc = "CMake Clean" }) -- 清理编译产物
    end,
  },
}
