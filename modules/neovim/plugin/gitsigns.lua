require("gitsigns").setup({
	update_debounce = 100,
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "Next git hunk" })

		map("n", "[g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "Previous git hunk" })

		-- Actions
		map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })

		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk" })

		map("v", "<leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk" })

		map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
		map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
		map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

		map("n", "<leader>gb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Blame line" })

		map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })

		map("n", "<leader>gD", function()
			gitsigns.diffthis("~")
		end, { desc = "Diff this (~)" })

		map("n", "<leader>gQ", function()
			gitsigns.setqflist("all")
		end, { desc = "Git quickfix (all)" })
		map("n", "<leader>gq", gitsigns.setqflist, { desc = "Git quickfix" })

		-- Toggles
		map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
		map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select git hunk" })
	end,
})
