local functions = {}

local function find_longest_string(strings)
	local longest = nil
	for _, string in pairs(strings) do
		if not longest or #string > #longest then
			longest = string
		end
	end
	return longest
end

local function get_git_dir(path)
	local git_dir = vim.fn.system(
		"cd "
			.. path
			.. ' && git rev-parse --show-toplevel 2> /dev/null || echo ""'
	)
	git_dir = git_dir:gsub(".$", "")
	if git_dir == "" then
		return vim.fn.getenv("HOME")
	end
	return git_dir
end

local function find_file_in(filename, starting_path, search_until)
	-- if search_until is empty, get the value for $HOME
	local end_search_at = search_until or vim.fn.getenv("HOME")
	-- if end_search_at is empty or is lenghtier than starting_path it it means that
	-- we couldn't find the file, so we return an empty string
	if end_search_at == vim.NIL or (#starting_path < #end_search_at) then
		return nil
	end
	if filename == ".git" then
		return get_git_dir(starting_path)
	end
	local file_exists = vim.fn.filereadable(starting_path .. "/" .. filename)
	if file_exists == 1 then
		-- found the file we were looking for, return the path to the folder where it was
		return starting_path
	end
	-- if we didn't find the file, recursively search one folder up until we exhaust
	-- the options
	return find_file_in(
		filename,
		vim.fn.fnamemodify(starting_path, ":h"),
		search_until
	)
end

local function get_project_dir(starting_dir)
	local is_dir = vim.fn.isdirectory(starting_dir)
	if is_dir == 0 then
		return nil
	end
	local default_project_roots_files = { ".git", "package.json" }
	local user_project_roots = vim.g.project_roots_files
	local project_roots = vim.tbl_extend(
		"force",
		default_project_roots_files,
		user_project_roots or {}
	)
	local results = {}
	for _, file in pairs(project_roots) do
		local result = find_file_in(file, starting_dir)
		if result then
			table.insert(results, result)
		end
	end
	local project_path = find_longest_string(results)
	return project_path
end

function functions.set_project_dir()
	local project_dir = get_project_dir(vim.fn.expand("%:p:h"))
	if project_dir then
		-- change vim directory to the found project folder
		vim.fn.chdir(project_dir)
	end
end

return functions
