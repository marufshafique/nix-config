require("diffview").setup({
	use_icons = true,
})

vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<cr>", { noremap = true, silent = true, desc = "Open Diffview" })
vim.keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { noremap = true, silent = true, desc = "Close Diffview" })
vim.keymap.set(
	"n",
	"<leader>gh",
	"<cmd>DiffviewFileHistory %<cr>",
	{ noremap = true, silent = true, desc = "File history (current file)" }
)
vim.keymap.set(
	"n",
	"<leader>gH",
	"<cmd>DiffviewFileHistory<cr>",
	{ noremap = true, silent = true, desc = "File history (branch)" }
)
vim.keymap.set(
	"n",
	"<leader>gm",
	"<cmd>DiffviewOpen origin/main...HEAD<cr>",
	{ noremap = true, silent = true, desc = "Diff branch vs main" }
)
