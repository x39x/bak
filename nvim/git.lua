local function process_diff(data)
	-- Adapted from https://github.com/wbthomason/nvim-vcs.lua
	local added, removed, changed = 0, 0, 0
	for _, line in ipairs(data) do
		if string.find(line, [[^@@ ]]) then
			local tokens = vim.fn.matchlist(line, [[^@@ -\v(\d+),?(\d*) \+(\d+),?(\d*)]])
			local line_stats = {
				mod_count = tokens[3] == nil and 0 or tokens[3] == "" and 1 or tonumber(tokens[3]),
				new_count = tokens[5] == nil and 0 or tokens[5] == "" and 1 or tonumber(tokens[5]),
			}

			if line_stats.mod_count == 0 and line_stats.new_count > 0 then
				added = added + line_stats.new_count
			elseif line_stats.mod_count > 0 and line_stats.new_count == 0 then
				removed = removed + line_stats.mod_count
			else
				local min = math.min(line_stats.mod_count, line_stats.new_count)
				changed = changed + min
				added = added + line_stats.new_count - min
				removed = removed + line_stats.mod_count - min
			end
		end
	end
	return { added = added, changed = changed, removed = removed }
end

local function get_diff(file_path)
	local result = vim.system({
		"git",
		"-C",
		vim.fs.dirname(file_path),
		"--no-pager",
		"diff",
		"--no-color",
		"--no-ext-diff",
		"-U0",
		"--",
		vim.fs.basename(file_path),
	}):wait()

	if result.code ~= 0 then
		vim.notify("[MATSU_GIT]: can't get diff txt", vim.log.levels.WARN)
		return { added = 0, modified = 0, removed = 0 }
	end
	return process_diff(vim.split(result.stdout, "\n"))
end

local function resolve_git_dir(git_root)
	local git_path = git_root .. "/.git"
	local stat = vim.uv.fs_stat(git_path)
	if stat and stat.type == "file" then
		local content = vim.fn.readfile(git_path)[1]
		local real_git_dir = content:match("gitdir: (.+)")
		if real_git_dir then
			return vim.fs.normalize(vim.fs.joinpath(git_root, real_git_dir))
		end
	end
	return git_path
end

local function make_git_dict()
	local cur_file = vim.api.nvim_buf_get_name(0)
	local file_dir = vim.fs.dirname(cur_file)

	local result = vim.system({ "git", "-C", file_dir, "rev-parse", "--show-toplevel" }, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("[MATSU_GIT]: can't get git root", vim.log.levels.WARN)
		return nil
	end

	local git_root = vim.trim(result.stdout)
	local git_dir = resolve_git_dir(git_root)
	local head = vim.fn.readfile(git_dir .. "/HEAD")[1]
	head = head:match("refs/heads/(.+)") or (head and head:sub(1, 7)) or "[unknown]"

	local git_dict = vim.tbl_extend("force", { root = git_root, gitdir = git_dir, head = head }, get_diff(cur_file))

	return git_dict
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function(args)
		local bufnr = args.buf
		if vim.bo.buftype ~= "" or vim.bo[bufnr].buflisted then
			return
		end
		vim.b[bufnr] = {}

		local file_path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
		local result = vim.system({ "git", "-C", file_path, "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
		local is_git_file = result.stdout and vim.split(result.stdout, "\n")[1] or nil
		if is_git_file == "true" then
			-- vim.b[bufnr].is_git_repo =
			vim.schedule(function()
				vim.b[bufnr].matsu_git_dict = make_git_dict()
			end)
		end
	end,
})
