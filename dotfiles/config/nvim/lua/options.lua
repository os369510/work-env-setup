require "nvchad.options"

local opt = vim.opt

-- Mouse
opt.mouse = ""

-- Diff
opt.diffopt:append "vertical"

-- File format
opt.fileformat = "unix"

-- Performance
opt.lazyredraw = true

-- Backup/swap
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Bells
opt.errorbells = false
opt.visualbell = false

-- Indentation
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true

-- Display
opt.showmatch = true
opt.wildmenu = true
opt.wrap = false
opt.number = false
opt.tabpagemax = 50
opt.autoread = true
opt.cursorline = true
opt.backspace = "indent,eol,start"
opt.textwidth = 80
opt.winminheight = 0
opt.wildignore:append { "*.o", "*.obj", "*.exe", "*.so", "*.lo", "*.a" }

-- Folding
opt.foldenable = true
opt.foldmethod = "marker"

-- Trailing whitespace highlight
vim.api.nvim_set_hl(0, "RedundantSpaces", { ctermbg = "red", bg = "red" })
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("RedundantSpaces", [[\s\+$]])
  end,
})

-- Shell file type settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.g.sh_fold_enabled = 5
    vim.g.is_bash = 1
    vim.opt_local.foldmethod = "syntax"
  end,
})
