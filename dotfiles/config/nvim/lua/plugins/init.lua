return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()
      require("configs.treesitter_compat")
    end,
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Go development (replaces fatih/vim-go)
  {
    "fatih/vim-go",
    ft = { "go" },
    build = ":GoInstallBinaries",
    init = function()
      vim.g.go_fmt_autosave = 1
      vim.g.go_imports_autosave = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_methods = 1
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
    end,
  },

  -- Tagbar (replaces taglist.vim, requires universal-ctags)
  {
    "preservim/tagbar",
    cmd = { "TagbarToggle", "TagbarOpen" },
    init = function()
      vim.g.tagbar_compact = 1
      vim.g.tagbar_autofocus = 1
      vim.g.tagbar_autoclose = 1
      vim.g.tagbar_width = 60
    end,
  },

  -- Translator (same as voldikss/vim-translator)
  {
    "voldikss/vim-translator",
    cmd = { "Translate", "TranslateW", "TranslateR" },
    init = function()
      vim.g.translator_default_engines = { "google" }
    end,
  },

  -- Avante: AI coding assistant (Cursor-like, powered by Claude)
  -- Requires: ANTHROPIC_API_KEY env var
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    opts = {
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-6",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "stevearc/dressing.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
          },
        },
      },
    },
  },
}
