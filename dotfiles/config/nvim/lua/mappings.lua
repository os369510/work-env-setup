require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Keep Space free as the leader-key prefix.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- Browser preview for Markdown, including fenced Mermaid diagrams.
map("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", {
  silent = true,
  desc = "Open Markdown/Mermaid preview",
})
map("n", "<leader>mx", "<cmd>MarkdownPreviewStop<CR>", {
  silent = true,
  desc = "Stop Markdown/Mermaid preview",
})

-- Tagbar toggle (replaces taglist <C-l>)
map("n", "<C-l>", ":TagbarToggle<CR>", { silent = true, desc = "Toggle tagbar" })

-- vim-translator: <Leader>t to translate word in popup
map("n", "<Leader>t", "<Plug>TranslateW", { desc = "Translate word" })
