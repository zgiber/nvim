-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local t_opts = { silent = true }

local keymap = vim.keymap.set

-- Terminal mode
keymap("t", "<esc><esc>", "<C-\\><C-N>", t_opts)
keymap("t", "<C-Left>", "<C-\\><C-N><C-w>h", t_opts)
keymap("t", "<C-Down>", "<C-\\><C-N><C-w>j", t_opts)
keymap("t", "<C-Up>", "<C-\\><C-N><C-w>k", t_opts)
keymap("t", "<C-Right>", "<C-\\><C-N><C-w>l", t_opts)
