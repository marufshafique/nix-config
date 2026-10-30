vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { noremap = true, silent = true, desc = "Format Buffer" })

vim.keymap.set(
	"n",
	"<leader>ld",
	"<cmd>Telescope diagnostics bufnr=0<CR>",
	{ noremap = true, silent = true, desc = "Buffer Diagnostics" }
)

vim.keymap.set("n", "<leader>e", function()
	local in_diffview = false
	local ok, lib = pcall(require, "diffview.lib")
	if ok and lib.get_current_view then
		local view_ok, view = pcall(lib.get_current_view)
		if view_ok and view then
			in_diffview = true
		end
	end
	if not in_diffview then
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
			if ft == "DiffviewFiles" or ft == "DiffviewFileHistory" then
				in_diffview = true
				break
			end
		end
	end
	if in_diffview then
		vim.cmd("DiffviewToggleFiles")
	else
		vim.cmd("Neotree toggle")
	end
	vim.cmd("wincmd =")
end, { noremap = true, silent = true, desc = "Toggle Explorer (NeoTree / Diffview)" })
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

-- Window navigation handled by vim-herdr-navigation
-- (modules/neovim/plugin/herdr-navigation.lua): <C-h/j/k/l> moves within
-- Neovim splits, crosses to herdr panes at edge, falls back to plain
-- wincmd outside herdr.

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
vim.keymap.set(
	"n",
	"<leader>gc",
	"<cmd>Telescope git_branches<CR>",
	{ noremap = true, silent = true, desc = "Git Checkout" }
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

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "Y", '"+y', { noremap = true, silent = true, desc = "Yank to System Clipboard" })

-- Paste from system clipboard
vim.keymap.set("n", "P", '"+p', { noremap = true, silent = true, desc = "Paste from System Clipboard" })

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
