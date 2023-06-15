-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            opts.remap = nil
        end
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- Remap hjkl => jkil
map({ "n", "x" }, "k", "v:count == 0 ? 'gj' : 'j'", { desc = "Move cursor down", expr = true, silent = true })
map({ "n", "x" }, "K", "L", { desc = "Move cursor to top of screen", silent = true })
map({ "n", "x" }, "i", "v:count == 0 ? 'gk' : 'k'", {  desc = "Move cursor up", expr = true, silent = true })
map({ "n", "x" }, "I", "H", { desc = "Move cursor to bottom of screen", silent = true })
map({ "n", "x" }, "l", "l", { desc = "Move cursor right", silent = true })
map({ "n", "x" }, "L", "$", { desc = "Jump to the end of the line", silent = true })
map({ "n", "x" }, "j", "h", { desc = "Move cursor left", silent = true })
map({ "n", "x" }, "J", "0", { desc = "Jump to the start of the line", silent = true })
map({ "n", "x" }, "H", "I", { desc = "Insert at the beginning of the line", silent = true })
map({ "n", "x" }, "h", "i", { desc = "Insert before the cursor", silent = true })
map({ "n", "x" }, "W", "w", { silent = true })
map({ "n", "x" }, "w", "W", { silent = true })
map({ "n", "x" }, "E", "e", { silent = true })
map({ "n", "x" }, "e", "W", { silent = true })
map({ "n", "x" }, "B", "b", { silent = true })
map({ "n", "x" }, "b", "B", { silent = true })
map({ "n", "x" }, "0", "K", { silent = true })
map({ "n", "x" }, "$", "J", { silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-j>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-k>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-i>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move Lines
map("n", "<A-k>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-i>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-k>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-i>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-k>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-i>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
if Util.has("bufferline.nvim") then
    map("n", "<A-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "<A-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
    map("n", "<A-j>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- Terminal Mappings
map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-i>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })