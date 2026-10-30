-- Shows the current git branch in the statusline, right after the file name.
-- Refreshes asynchronously on buffer/directory/focus changes so git never blocks typing.

local refresh_seq = 0

local function current_dir()
	local name = vim.api.nvim_buf_get_name(0)
	-- Ignore virtual buffers (diffview://, etc.) and fall back to cwd
	if name ~= "" and not name:find("^%w+://") then
		return vim.fn.fnamemodify(name, ":p:h")
	end
	return vim.fn.getcwd()
end

local function ensure_branch_in_statusline()
	if vim.o.statusline == "" then
		vim.o.statusline = "%<%f%{g:git_branch_name} %h%m%r%=%-14.(%l,%c%V%) %P"
	elseif not vim.o.statusline:find("git_branch_name", 1, true) then
		local updated, n = vim.o.statusline:gsub("%%f", "%%f%%{g:git_branch_name}", 1)
		if n == 1 then
			vim.o.statusline = updated
		else
			vim.o.statusline = vim.o.statusline .. "%{g:git_branch_name}"
		end
	end
end

function _refresh_git_branch()
	refresh_seq = refresh_seq + 1
	local seq = refresh_seq
	local dir = current_dir()
	-- vim.g.git_branch_cmd can be overridden (e.g. in tests)
	vim.system(vim.g.git_branch_cmd or { "git", "branch", "--show-current" }, { text = true, cwd = dir }, function(res)
		vim.schedule(function()
			-- Drop stale results if the user already moved to another buffer
			if seq ~= refresh_seq then
				return
			end
			local branch = (res.stdout or ""):gsub("%s+$", "")
			if res.code ~= 0 then
				branch = ""
			end
			vim.g.git_branch_name = branch == "" and "" or ("   " .. branch)
			vim.cmd("redrawstatus")
		end)
	end)
end

vim.g.git_branch_name = ""
ensure_branch_in_statusline()

local group = vim.api.nvim_create_augroup("GitBranchStatus", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "DirChanged", "FocusGained" }, {
	group = group,
	callback = function()
		_refresh_git_branch()
	end,
})

_refresh_git_branch()
