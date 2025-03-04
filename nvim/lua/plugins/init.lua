return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require "configs.nvim-tree"
    end,
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  --
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "flake8",
        "checkstyle",
        "vale",
        "lualint",
        "beautysh",
        "bibtex-tidy",
        "black",
        "clang-format",
        "clangd",
        "debugpy",
        "gh",
        "google-java-format",
        "html-lsp",
        "java-debug-adapter",
        "java-language-server",
        "java-test",
        "jdtls",
        "latexindent",
        "lombok-nightly",
        "lua-language-server",
        "markdown-oxide",
        "markdownlint",
        "openjdk-17",
        "prettier",
        "pyright",
        "spring-boot-tools",
        "stylua",
        "texlab",
        "ltex-ls",
        "typescript-language-server",
      },
    },
  },
  --
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "configs.treesitter"
    end,
  },
  --
  {
    "Exafunction/codeium.vim",
    event = { "InsertEnter" },
    config = function()
      vim.keymap.set("i", "<C-/>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-.>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-;>", function()
        return vim.fn["codeium#Complete"]()
      end, { expr = true, silent = true })
      vim.keymap.set({ "n", "i" }, "<M-CR>", function()
        return vim.fn["codeium#Chat"]()
      end, { expr = true, silent = true })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      lazy = false,
      config = function()
        require("telescope").load_extension "fzf"
      end,
    },
  },
  --
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- enabled = function()
      --   return (vim.bo.ft ~= "markdown")
      -- end,
      -- Rest of your plugin spec
      config = function()
        require "configs.ncmp"
      end,
    },
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },
  {
    "sindrets/diffview.nvim", -- optional - Diff integration
    keys = {
      { "<leader>dv", mode = "n", "<cmd>DiffviewOpen<cr>" },
      { "<esc>", mode = "n", "<cmd>DiffviewClose<cr>" },
      { "<leader>dr", mode = "n", "<cmd>DiffviewRefresh<cr>" },
      { "<leader>do", mode = "n", "<cmd>DiffviewOpen --cached<cr>" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require "configs.neogit"
    end,
    events = { "BufRead", "BufNewFile" },
    keys = {
      { "<leader>G", mode = "n", "<cmd>Neogit<cr>" },
    },
  },
  {
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    opts = {
      -- add any options here
      lsp = {
        signature = {
          enable = false,
        },
      },
    },
    event = "VeryLazy",
    config = function()
      require("noice").setup {
        routes = {
          {
            view = "notify",
            filter = {
              event = "msg_showmode",
              any = {
                { find = "recording" },
              },
            },
          },
        },

        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            -- override the default lsp markdown formatter with Noice
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            -- override the lsp markdown formatter with Noice
            ["vim.lsp.util.stylize_markdown"] = true,
            -- override cmp documentation with Noice (needs the other options to work)
            ["cmp.entry.get_documentation"] = true,
          },
          hover = { enabled = false }, -- <-- HERE!
          signature = { enabled = false }, -- <-- HERE!
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
      -- See: https://github.com/folke/noice.nvim/issues/258
      require("noice.lsp").hover()
      -- See: https://github.com/NvChad/NvChad/issues/1656
      -- vim.notify = require("noice").notify
      -- vim.lsp.handlers["textDocument/hover"] = require("noice").hover
      -- vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    config = function()
      require "configs.dressing"
    end,
  },
  -- {
  --   "gen740/SmoothCursor.nvim",
  --   lazy = false,
  --   config = function()
  --     require("smoothcursor").setup {
  --       fancy = {
  --         enable = true,
  --       },
  --       intervals = 15,
  --       speed = 15,
  --     }
  --   end,
  -- },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      require "configs.vimtex"
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,

    keys = {
      { "<leader>ss", mode = "n", "<cmd>SessionSave<cr>" },
      { "<leader>fs", mode = "n", "<cmd>SessionSearch<cr>" },
      { "<leader>sd", mode = "n", "<cmd>Autosession delete<cr>" },
    },

    opts = {
      enabled = true, -- Enables/disables auto creating, saving and restoring
      root_dir = vim.fn.stdpath "data" .. "/sessions/", -- Root dir where sessions will be stored
      auto_save = false, -- Enables/disables auto saving session on exit
      auto_restore = false, -- Enables/disables auto restoring session on start
      auto_create = true, -- Enables/disables auto creating new session files. Can take a function that should return true/false if a new session file should be created or not
      suppressed_dirs = { "~/" }, -- Suppress session restore/create in certain directories
      allowed_dirs = nil, -- Allow session restore/create in certain directories
      auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
      use_git_branch = true, -- Include git branch name in session name
      lazy_support = true, -- Automatically detect if Lazy.nvim is being used and wait until Lazy is done to make sure session is restored correctly. Does nothing if Lazy isn't being used. Can be disabled if a problem is suspected or for debugging
      bypass_save_filetypes = nil, -- List of file types to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
      close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session
      args_allow_single_directory = true, -- Follow normal sesion save/load logic if launched with a single directory as the only argument
      args_allow_files_auto_save = false, -- Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
      continue_restore_on_error = true, -- Keep loading the session even if there's an error
      cwd_change_handling = false, -- Follow cwd changes, saving a session before change and restoring after
      log_level = "error", -- Sets the log level of the plugin (debug, info, warn, error).

      session_lens = {
        load_on_setup = true, -- Initialize on startup (requires Telescope)
        theme_conf = { -- Pass through for Telescope theme options
          -- layout_config = { -- As one example, can change width/height of picker
          --   width = 0.8,    -- percent of window
          --   height = 0.5,
          -- },
        },
        previewer = false, -- File preview for session picker

        session_control = {
          control_dir = vim.fn.stdpath "data" .. "/auto_session/", -- Auto session control dir, for control files, like alternating between two sessions with session-lens
          control_filename = "session_control.json", -- File name of the session control file
        },
      },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    "jake-stewart/multicursor.nvim",
    event = { "bufRead", "bufEnter" },
    branch = "1.0",
    config = function()
      local mc = require "multicursor-nvim"
      mc.setup()

      -- Add cursors above/below the main cursor.
      vim.keymap.set({ "n", "v" }, "<leader>k", function()
        mc.addCursor "k"
      end)
      vim.keymap.set({ "n", "v" }, "<leader>j", function()
        mc.addCursor "j"
      end)

      -- Add a cursor and jump to the next word under cursor.
      vim.keymap.set({ "n", "v" }, "<leader>cw", function()
        mc.addCursor "*"
      end)

      -- Jump to the next word under cursor but do not add a cursor.
      vim.keymap.set({ "n", "v" }, "<leader>cW", function()
        mc.skipCursor "*"
      end)

      -- Rotate the main cursor.
      vim.keymap.set({ "n", "v" }, "<leader>L", mc.nextCursor)
      vim.keymap.set({ "n", "v" }, "<leader>H", mc.prevCursor)

      -- Delete the main cursor.
      vim.keymap.set({ "n", "v" }, "<leader>cx", mc.deleteCursor)

      -- Add and remove cursors with control + left click.
      vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)

      vim.keymap.set({ "n", "v" }, "<leader>cs", function()
        if mc.cursorsEnabled() then
          -- Stop other cursors from moving.
          -- This allows you to reposition the main cursor.
          mc.disableCursors()
        else
          mc.addCursor()
        end
      end)

      vim.keymap.set("n", "<leader>C", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
          vim.cmd "noh"
        end
      end)

      -- Align cursor columns.
      vim.keymap.set("n", "<leader>A", mc.alignCursors)

      -- Split visual selections by regex.
      vim.keymap.set("v", "S", mc.splitCursors)

      -- Append/insert for each line of visual selections.
      vim.keymap.set("v", "I", mc.insertVisual)
      vim.keymap.set("v", "A", mc.appendVisual)

      -- match new cursors within visual selections by regex.
      vim.keymap.set("v", "M", mc.matchCursors)

      -- Rotate visual selection contents.
      vim.keymap.set("v", "<leader>t", function()
        mc.transposeCursors(1)
      end)
      vim.keymap.set("v", "<leader>T", function()
        mc.transposeCursors(-1)
      end)

      -- Customize how cursors look.
      vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
  },
  {
    "nvim-java/nvim-java",
    -- lazy = false,
    ft = { "java" },
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
    config = function()
      require("java").setup {
        root_markers = {
          "settings.gradle",
          "settings.gradle.kts",
          "pom.xml",
          "build.gradle",
          "mvnw",
          "gradlew",
          "build.gradle",
          "build.gradle.kts",
          ".git",
        },
        java_test = {
          enable = true,
          -- enable = false,
        },
        java_debug_adapter = {
          -- enable = true,
          enable = false,
        },
        spring_boot_tools = {
          -- enable = true,
          enable = false,
        },
        jdk = {
          auto_install = true,
        },
        notifications = {
          dap = true,
        },
        verification = {
          invalid_order = true,
          duplicate_setup_calls = true,
          invalid_mason_registry = true,
        },
      }
      require("configs.lspconfig").jdtls.setup {
        on_attach = require("nvchad.configs.lspconfig").on_attach,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
        on_init = require("nvchad.configs.lspconfig").on_init,
        filetypes = { "java" },
      }
    end,
  },
  {
    "nvim-focus/focus.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require "configs.focusss"
    end,
  },
  { -- This plugin
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },
  { -- The task runner we use
    "stevearc/overseer.nvim",
    commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _) end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, _)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
      require("dap-python").setup(path)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require "configs.snacks"
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    main = "render-markdown",
    opts = {},
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    keys = {
      {
        "<leader>rm",
        "<cmd>RenderMarkdown toggle<cr>",
        desc = "Toggle markdown preview",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "=", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "-", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
    },
  },
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      neovim_image_text = "I'm literally better than you",
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "#0cfade",
      stiffness = 0.3,
      trailing_stiffness = 0.1,
      trailing_exponent = 5,
      hide_target_hack = true,
      gamma = 1,
      slowdown_exponent = 0.1,
      max_length = 40,
      time_interval = 15,
    },
    keys = {
      {
        "<leader>st",
        mode = { "n" },
        function()
          require("smear_cursor").toggle()
        end,
      },
    },
    event = "VeryLazy",
  },
  {
    "echasnovski/mini.nvim",
    version = false,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require "configs.linter"
    end,
    event = "VeryLazy",
    keys = {
      {
        "<leader>==",
        mode = { "n" },
        function()
          require("lint").try_lint()
        end,
      },
      {
        "<leader>--",
        mode = { "n" },
        function()
          vim.diagnostic.reset(nil, 0)
        end,
      },
    },
  },
}
