local miniclue = require("mini.clue")

miniclue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" },

		{ mode = { "n", "x" }, keys = "g", desc = "Go to" },
	},

	clues = {
		{ mode = "n", keys = "<Leader>d", desc = "+Delete" },
		{ mode = "n", keys = "<Leader>g", desc = "+Git" },
		{ mode = "n", keys = "<Leader>l", desc = "+LSP" },
		{ mode = "n", keys = "<Leader>p", desc = "+PlatformIO" },
	},
	show = {
		desc = true,
		truncate_desc = 30,
	},
	window = {
		delay = 100,
		config = {
			width = 35,
		},
	},
})
