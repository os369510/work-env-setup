return {
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
}
