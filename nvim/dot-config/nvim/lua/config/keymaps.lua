-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- NOTE: Heavily inspired by https://www.youtube.com/watch?v=V070Zmvx9AM
--

-- '/' key to toggle commends in Normal mode and Visual mode
vim.keymap.set("n", "/", "gcc", { remap = true, desc = "Toggle comment for line." })
vim.keymap.set("v", "/", "gc", { remap = true, desc = "Toggle comment for selection." })
