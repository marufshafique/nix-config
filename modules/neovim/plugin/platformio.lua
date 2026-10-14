-- PlatformIO (embedded / ESP32 / Arduino) integration for Neovim.
--
-- Prerequisites (installed via home-manager):
--   * platformio  - PlatformIO Core CLI (`pio`)
--   * clang-tools - provides `clangd`, the C/C++ language server
--
-- How C/C++ intellisense works here:
--   PlatformIO has no language server of its own. The `pio run -t compiledb`
--   target emits a `compile_commands.json` at the project root which clangd
--   (configured in lsp.lua) consumes. clangd watches that file and reloads it
--   automatically, so the compile database only has to be regenerated when
--   sources/platformio.ini change (the build keymaps below do that for you).
--
-- Note on `.ino` sketches:
--   PlatformIO pre-processes `.ino` files into a generated `.ino.cpp` under
--   `.pio/build/<env>/`, so clangd cannot map your `.ino` buffer to a compile
--   command and full intellisense will be missing there. The recommended
--   layout for working in Neovim is a `src/main.cpp` project (or thin .ino
--   wrapper around src/*.cpp + *.h code), which gets full clangd support.
--
-- Keymaps (all leader-prefixed):
--   <leader>pb  Build + refresh compile database   (pio run -t compiledb)
--   <leader>pu  Upload firmware                    (pio run -t upload)
--   <leader>pm  Serial monitor                     (pio device monitor)
--                    -> press <C-q> inside the monitor to quit it
--   <leader>pc  Clean                              (pio run -t clean)
--   <leader>pC  Full clean                         (pio run -t fullclean)
--   <leader>pD  Refresh compile_commands.json only (fast, no rebuild)
--   :Pio <args> Run any pio command in a terminal (e.g. `:Pio run -t uploadfs`)

-- Re-usable terminals keyed by command, so toggling the same keymap
-- focuses/re-runs the same terminal instead of stacking new windows.
local terms = {}

--- Find the nearest PlatformIO project root (dir containing platformio.ini).
---@return string?
local function project_root()
	return vim.fs.root(0, "platformio.ini")
end

---@return boolean
local function notify_missing_project()
	vim.notify("Not in a PlatformIO project (no platformio.ini found)", vim.log.levels.WARN, {
		title = "PlatformIO",
	})
	return false
end

---@return boolean
local function check_toggleterm()
	if pcall(require, "toggleterm.terminal") then
		return true
	end
	vim.notify("PlatformIO terminals require toggleterm.nvim", vim.log.levels.ERROR, {
		title = "PlatformIO",
	})
	return false
end

--- Open (or focus) a persistent terminal that runs `cmd` in the PIO project.
--- The terminal is created lazily on first use and re-runs `cmd` every time it
--- is toggled open again after the previous run has finished.
---@param key string
---@param cmd string
---@param opts? { size?: number, on_open?: fun(term: table): nil }
local function pio_terminal(key, cmd, opts)
	local root = project_root()
	if not root or not check_toggleterm() then
		return
	end

	opts = opts or {}
	local Terminal = require("toggleterm.terminal").Terminal

	local term = terms[key]
	-- Re-create the terminal if we moved to a different PlatformIO project.
	if term and term.root ~= root then
		terms[key] = nil
		term = nil
	end

	if not term then
		term = Terminal:new({
			cmd = cmd,
			dir = root,
			direction = "horizontal",
			size = opts.size or 14,
			close_on_exit = false,
			on_open = function(t)
				vim.cmd("startinsert!")
				if opts.on_open then
					opts.on_open(t)
				end
			end,
		})
		term.root = root
		terms[key] = term
	end

	term:toggle()
end

--- Regenerate compile_commands.json in the background (does not build).
--- clangd notices the change and reloads it automatically.
local function refresh_compile_commands()
	local root = project_root()
	if not root then
		notify_missing_project()
		return
	end

	vim.notify("Generating compile_commands.json ...", vim.log.levels.INFO, { title = "PlatformIO" })
	vim.system({ "pio", "run", "-t", "compiledb" }, { cwd = root, text = true }, function(out)
		-- `vim.system` callbacks run in a fast event context, where `vim.notify`
		-- (nvim_echo) is not allowed. Defer to the main loop via vim.schedule.
		vim.schedule(function()
			if out.code == 0 then
				vim.notify("compile_commands.json updated", vim.log.levels.INFO, { title = "PlatformIO" })
			else
				vim.notify(
					"`pio run -t compiledb` failed:\n" .. (vim.trim(out.stderr or "") ~= "" and out.stderr or out.stdout),
					vim.log.levels.ERROR,
					{ title = "PlatformIO" }
				)
			end
		end)
	end)
end

-- `pio run -t compiledb` performs the build and keeps the compile database in
-- sync afterwards, so clangd always sees the latest translation units.
vim.api.nvim_create_user_command("PioBuild", function()
	pio_terminal("build", "pio run && pio run -t compiledb")
end, { desc = "PlatformIO: build + refresh compile db" })

vim.api.nvim_create_user_command("PioUpload", function()
	pio_terminal("upload", "pio run -t upload")
end, { desc = "PlatformIO: upload firmware" })

vim.api.nvim_create_user_command("PioMonitor", function()
	pio_terminal("monitor", "pio device monitor", {
		size = 18,
		-- `pio device monitor` (pyserial miniterm) does not always exit cleanly
		-- on <C-c>, so expose <C-q> to tear the terminal/process down instead.
		on_open = function(term)
			vim.keymap.set("t", "<C-q>", function()
				term:shutdown()
			end, { buffer = term.bufnr, silent = true, desc = "Quit PlatformIO monitor" })
		end,
	})
end, { desc = "PlatformIO: serial monitor (quit with <C-q>)" })

vim.api.nvim_create_user_command("PioClean", function()
	pio_terminal("clean", "pio run -t clean")
end, { desc = "PlatformIO: clean project" })

vim.api.nvim_create_user_command("PioFullClean", function()
	pio_terminal("fullclean", "pio run -t fullclean")
end, { desc = "PlatformIO: full clean" })

vim.api.nvim_create_user_command("PioCompileCommands", refresh_compile_commands, {
	desc = "PlatformIO: (re)generate compile_commands.json for clangd",
})

-- Run an arbitrary `pio ...` command in a fresh terminal.
vim.api.nvim_create_user_command("Pio", function(args)
	pio_terminal("run:" .. args.args, "pio " .. args.args)
end, {
	nargs = "*",
	desc = "PlatformIO: run arbitrary pio command in a terminal",
})

vim.keymap.set("n", "<leader>pb", "<cmd>PioBuild<CR>", { desc = "Build (PlatformIO)" })
vim.keymap.set("n", "<leader>pu", "<cmd>PioUpload<CR>", { desc = "Upload (PlatformIO)" })
vim.keymap.set("n", "<leader>pm", "<cmd>PioMonitor<CR>", { desc = "Serial monitor (PlatformIO, <C-q> to quit)" })
vim.keymap.set("n", "<leader>pc", "<cmd>PioClean<CR>", { desc = "Clean (PlatformIO)" })
vim.keymap.set("n", "<leader>pC", "<cmd>PioFullClean<CR>", { desc = "Full clean (PlatformIO)" })
vim.keymap.set("n", "<leader>pD", "<cmd>PioCompileCommands<CR>", { desc = "Refresh compile db (PlatformIO)" })

-- `.ino` files get the `arduino` filetype in Neovim by default. Let clangd and
-- the cpp treesitter parser treat them like C++ code.
vim.treesitter.language.register("cpp", "arduino")
