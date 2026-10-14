vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { noremap = true, silent = true, desc = "Format Buffer" })

vim.keymap.set(
	"n",
	"<leader>ld",
	"<cmd>Telescope diagnostics bufnr=0<CR>",
	{ noremap = true, silent = true, desc = "Buffer Diagnostics" }
)

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true, desc = "Toggle NeoTree" })
vim.keymap.set(
	"n",
	"<leader>lc",
	"<cmd>CodeCompanionChat Toggle<cr>",
	{ noremap = true, silent = true, desc = "Toggle CodeCompanionChat" }
)
vim.keymap.set(
	"n",
	"<leader>lx",
	"<cmd>CodeCompanionChat<cr>",
	{ noremap = true, silent = true, desc = "New CodeCompanionChat" }
)

vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { noremap = true, silent = true, desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>q!<cr>", { noremap = true, silent = true, desc = "Force Quit" })
vim.keymap.set("n", "<leader>h", "<cmd>noh<cr>", { noremap = true, silent = true, desc = "Clear Search Highlight" })

vim.keymap.set("n", "<leader>db", "<cmd>bd<cr>", { noremap = true, silent = true, desc = "Close Buffer" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true, silent = true, desc = "Save Buffer" })
vim.keymap.set("n", "<leader>W", "<cmd>w!<cr>", { noremap = true, silent = true, desc = "Force Save Buffer" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "gl", "$", { noremap = true, silent = true, desc = "Go to End of Line" })
vim.keymap.set("n", "gh", "0", { noremap = true, silent = true, desc = "Go to Start of Line" })
vim.keymap.set("n", "ge", "G", { noremap = true, silent = true, desc = "Go to End of File" })

vim.keymap.set("n", "mm", "%", { noremap = true, silent = true, desc = "Go to Matching Pair" })
vim.keymap.set("n", "m", "v", { noremap = true, silent = true, desc = "Start Visual Mode" })

-- telescope related keymaps
vim.keymap.set(
	"n",
	"<leader>f",
	"<cmd>Telescope find_files<CR>",
	{ noremap = true, silent = true, desc = "Find Files" }
)
-- vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "List Buffers" })
vim.keymap.set(
	"n",
	"<leader>go",
	"<cmd>Telescope git_status<CR>",
	{ noremap = true, silent = true, desc = "Git Status" }
)
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live Grep" })

vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Toggle Line Comment" })
vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Toggle Line Comment" })

vim.keymap.set(
	"n",
	"<leader>gl",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Open Diagnostic Float" }
)

-- Copy absolute path to system clipboard
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied absolute path: " .. path)
end, { desc = "Copy absolute file path" })

-- Copy relative path to system clipboard
vim.keymap.set("n", "<leader>pr", function()
	local path = vim.fn.expand("%")
	vim.fn.setreg("+", path)
	vim.notify("Copied relative path: " .. path)
end, { desc = "Copy relative file path" })
