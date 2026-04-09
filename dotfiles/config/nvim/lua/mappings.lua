require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Clear search highlight (matches vimrc <SPACE> mapping)
map("n", "<Space>", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- Tagbar toggle (replaces taglist <C-l>)
map("n", "<C-l>", ":TagbarToggle<CR>", { silent = true, desc = "Toggle tagbar" })

-- vim-translator: <Leader>t to translate word in popup
map("n", "<Leader>t", "<Plug>TranslateW", { desc = "Translate word" })
