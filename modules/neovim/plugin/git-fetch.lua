local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local fetch_timer = nil
local fetch_running = false

local function ensure_statusline()
	if vim.o.statusline == "" then
		vim.o.statusline = "%<%f %h%m%r%=%-14.(%l,%c%V%) %P"
	end
	if not vim.o.statusline:find("git_fetch_status", 1, true) then
		vim.o.statusline = vim.o.statusline .. "%{g:git_fetch_status}"
	end
end

local function stop_fetch(msg, level)
	if fetch_timer then
		fetch_timer:stop()
		fetch_timer:close()
		fetch_timer = nil
	end
	fetch_running = false
	vim.g.git_fetch_status = ""
	vim.cmd("redrawstatus")
	vim.notify(msg, level or vim.log.levels.INFO)
end

local function _git_fetch_origin()
	if fetch_running then
		vim.notify("git fetch already running", vim.log.levels.WARN)
		return
	end
	ensure_statusline()
	fetch_running = true
	local i = 0
	local uv = vim.uv or vim.loop
	fetch_timer = uv.new_timer()
	fetch_timer:start(
		0,
		120,
		vim.schedule_wrap(function()
			i = (i % #spinner_frames) + 1
			vim.g.git_fetch_status = "  " .. spinner_frames[i]
			vim.cmd("redrawstatus")
		end)
	)
	-- vim.g.git_fetch_cmd can be overridden (e.g. in tests); defaults to git fetch origin
	vim.system(vim.g.git_fetch_cmd or { "git", "fetch", "origin" }, { text = true }, function(res)
		vim.schedule(function()
			if res.code == 0 then
				stop_fetch("git fetch origin complete")
			else
				local err = (res.stderr or ""):gsub("%s+$", "")
				if err == "" then
					err = "exit code " .. res.code
				end
				stop_fetch("git fetch origin failed: " .. err, vim.log.levels.ERROR)
			end
		end)
	end)
end

vim.g.git_fetch_status = ""
ensure_statusline()
vim.keymap.set("n", "<leader>gf", _git_fetch_origin, { noremap = true, silent = true, desc = "Git fetch origin" })
