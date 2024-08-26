local M = {}

local function get_git_remote_url()
	local handle = io.popen("git config --get remote.origin.url")
	local result = handle:read("*a")
	handle:close()

	-- Remove trailing newline
	result = result:gsub("[\n\r]", "")

	return result
end

local function get_github_url(remote_url)
	-- Pattern to match SSH and HTTPS GitHub URLs
	local ssh_pattern = "git@github%.com:([^/]+)/(.+)%.git"
	local https_pattern = "https://github%.com/([^/]+)/(.+)%.git"

	local owner, repo

	-- Try to match SSH format
	owner, repo = remote_url:match(ssh_pattern)

	-- If not SSH, try HTTPS format
	if not owner or not repo then
		owner, repo = remote_url:match(https_pattern)
	end

	-- If we found a match, construct the GitHub URL
	if owner and repo then
		return string.format("https://github.com/%s/%s/blob/main/", owner, repo)
	else
		return nil -- Return nil if we couldn't parse the URL
	end
end

local function get_relative_filepath_and_line_number()
	local file = vim.fn.expand("%:.")
	local line = vim.fn.line(".")
	local path = file .. "#L" .. line
	return path
end

local function get_github_url_of_current_file()
	return get_github_url(get_git_remote_url()) .. get_relative_filepath_and_line_number()
end

M.copy_link = function()
	vim.fn.setreg("+", get_github_url_of_current_file())
end

M.open_link = function()
	vim.ui.open(get_github_url_of_current_file())
end

M.setup = function()
	vim.keymap.set("n", "<leader>gc", M.copy_link, { desc = "[G]ithub link: [C]opy" })
	vim.keymap.set("n", "<leader>go", M.open_link, { desc = "[G]ithub link: [O]pen" })
end

return M
