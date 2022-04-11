local opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }
local term_opts = { silent = true }

-- TODO: move to whichkey.lua

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Primagen remaps https://www.youtube.com/watch?v=hSHATqh8svM
keymap("n", "Y", "y$", opts) -- yank to end of line
keymap("n", "n", "nzzzv", opts) -- keep line centered for next
keymap("n", "N", "Nzzzv", opts) -- keep line centered for previous
keymap("n", "J", "mzJ`z", opts) -- keep line centered for line concatenation

-- TODO add remaps for jumplist mutations

keymap("i", ',', ",<c-g>u", opts) -- add undo break point for .
keymap("i", '.', ".<c-g>u", opts) -- add undo break point for ,
keymap("i", '!', "!<c-g>u", opts) -- add undo break point for !
keymap("i", '?', "?<c-g>u", opts) -- add undo break point for ?

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "p", '"_dP', opts)
keymap("v", "J", ":move '>+1<CR>gv=gv", opts)
keymap("v", "K", ":move '<-2<CR>gv=gv", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("n", "<leader>j", ":move .+1<CR>==", opts)
keymap("n", "<leader>k", ":move .-2JJJ<CR>==", opts)

-- Terminal --
keymap("t", "<ESC>", "<C-\\><C-N>", term_opts) -- return to normal mode
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
