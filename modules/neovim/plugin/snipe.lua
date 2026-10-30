local snipe = require("snipe")

snipe.setup({
	sort = function(buffers)
		return vim.tbl_filter(function(buf)
			return vim.api.nvim_buf_get_name(buf.id) ~= "" and buf.name ~= "[No Name]"
		end, buffers)
	end,
})

snipe.ui_select_menu = require("snipe.menu"):new({ position = "center" })
snipe.ui_select_menu:add_new_buffer_callback(function(m)
	vim.keymap.set("n", "<esc>", function()
		m:close()
	end, { nowait = true, buffer = m.buf })
end)

vim.ui.select = snipe.ui_select

vim.keymap.set("n", "<leader>b", snipe.open_buffer_menu, { desc = "List Buffers" })
