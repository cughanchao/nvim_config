return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },

  -- use a release tag to download pre-built binaries
  version = "1.*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = {
        function(cmp)
          -- 如果补全菜单可见，接受当前选中的补全项
          if cmp.is_visible() then
            return cmp.accept()
          end
          -- 检查光标后是否有闭合括号，如果有则跳出
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local char_after = line:sub(col + 1, col + 1)
          if char_after:match("[%)%]%}'\"`]") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
          else
            -- 检查光标前是否至少有一个字符
            local char_before = line:sub(col, col)
            if char_before:match("%w") then
              return cmp.show()
            else
              -- 如果没有字符，插入 Tab
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
          end
        end,
      },
      -- 使用 Ctrl+n/Ctrl+p 在补全菜单中上下选择
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = { auto_show = false },
      trigger = {
        show_on_keyword = true,
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lsp = {
          min_keyword_length = 1, -- LSP 补全至少输入 1 个字符才触发
        },
        path = {
          min_keyword_length = 1,
        },
        snippets = {
          min_keyword_length = 1,
        },
        buffer = {
          min_keyword_length = 1,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- 让 lazydev 补全显示在最前面
          score_offset = 100,
          min_keyword_length = 1,
        },
      },
    },
    cmdline = {
      sources = function()
        local cmd_type = vim.fn.getcmdtype()
        if cmd_type == "/" then
          return { "buffer" }
        elseif cmd_type == ":" then
          return { "cmdline" }
        else
          return {}
        end
      end,
      keymap = {
        preset = "super-tab",
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
