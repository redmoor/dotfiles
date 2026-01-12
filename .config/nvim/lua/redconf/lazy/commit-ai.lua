-- Gemini AI-powered commit message generator
-- Analyzes staged git changes and generates conventional commit messages

local M = {}

-- Default configuration
M.config = {
	api_key = vim.env.GEMINI_API_KEY,
	model = "gemini-2.5-flash-lite",
	max_diff_lines = 500,
	timeout = 30000,
	insert_mode = "replace",
}

-- Validate environment and prerequisites
function M.validate()
	-- Check API key
	if not M.config.api_key or M.config.api_key == "" then
		return false, "GEMINI_API_KEY environment variable not set. Set it with: export GEMINI_API_KEY=your_key"
	end

	-- Check if in git repository
	local result = vim.fn.system("git rev-parse --git-dir 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		return false, "Not in a git repository"
	end

	return true, nil
end

-- Get staged changes diff
function M.get_staged_diff()
	local diff = vim.fn.system("git diff --cached")

	if vim.v.shell_error ~= 0 then
		return nil, "Failed to get git diff"
	end

	if diff == "" or diff == nil then
		return nil, "No staged changes found. Use 'git add' first."
	end

	-- Truncate if too large
	local lines = vim.split(diff, "\n")
	if #lines > M.config.max_diff_lines then
		lines = vim.list_slice(lines, 1, M.config.max_diff_lines)
		table.insert(lines, "\n... (diff truncated)")
		diff = table.concat(lines, "\n")
	end

	return diff, nil
end

-- Build prompt for Gemini
function M.build_prompt(diff)
	return string.format(
		[[Generate a concise git commit message for this diff. Follow these rules:
1. Use conventional commits format (add:, fix:, refactor:, test:, style:)
2. Keep subject line under 72 characters
3. Use imperative mood ("add feature" not "added feature")
4. Respond with ONLY the commit message, no explanation or markdown

Diff:
%s]],
		diff
	)
end

-- Call Gemini API
function M.call_gemini_api(prompt, callback)
	local curl = require("plenary.curl")
	local url = string.format(
		"https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
		M.config.model,
		M.config.api_key
	)

	local body = vim.json.encode({
		contents = { {
			parts = { {
				text = prompt,
			} },
		} },
	})

	curl.post(url, {
		body = body,
		headers = {
			["Content-Type"] = "application/json",
		},
		timeout = M.config.timeout,
		callback = vim.schedule_wrap(function(response)
			if response.status ~= 200 then
				callback(nil, string.format("API error (status %d): %s", response.status, response.body))
				return
			end

			local ok, decoded = pcall(vim.json.decode, response.body)
			if not ok then
				callback(nil, "Failed to parse API response")
				return
			end

			-- Extract commit message from response
			local message = decoded.candidates
				and decoded.candidates[1]
				and decoded.candidates[1].content
				and decoded.candidates[1].content.parts
				and decoded.candidates[1].content.parts[1]
				and decoded.candidates[1].content.parts[1].text

			if not message then
				callback(nil, "No message in API response")
				return
			end

			-- Clean up the message
			message = message:gsub("^%s+", ""):gsub("%s+$", "")

			callback(message, nil)
		end),
	})
end

-- Insert message into buffer
function M.insert_message(message)
	local buf = vim.api.nvim_get_current_buf()

	if M.config.insert_mode == "replace" then
		-- Replace first line (or insert at top if empty)
		vim.api.nvim_buf_set_lines(buf, 0, 1, false, { message })
	else
		-- Append after first line
		local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
		table.insert(lines, message)
		vim.api.nvim_buf_set_lines(buf, 0, 1, false, lines)
	end

	-- Move cursor to end of message for editing
	vim.api.nvim_win_set_cursor(0, { 1, #message })
end

-- Main function
function M.generate()
	-- Validate environment
	local ok, err = M.validate()
	if not ok then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	-- Get diff
	local diff, diff_err = M.get_staged_diff()
	if diff_err then
		vim.notify(diff_err, vim.log.levels.WARN)
		return
	end

	-- Show loading notification
	vim.notify("Generating commit message...", vim.log.levels.INFO)

	-- Build prompt and call API
	local prompt = M.build_prompt(diff)

	M.call_gemini_api(prompt, function(message, api_err)
		if api_err then
			vim.notify("Failed to generate commit message: " .. api_err, vim.log.levels.ERROR)
			return
		end

		-- Insert into buffer
		M.insert_message(message)
		vim.notify("Commit message generated!", vim.log.levels.INFO)
	end)
end

-- Setup function for lazy.nvim
function M.setup(opts)
	-- Merge user options
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Create user command
	vim.api.nvim_create_user_command("CommitMsg", function()
		M.generate()
	end, {
		desc = "Generate AI commit message from staged changes",
	})

	-- Auto-generate and add keymap in commit buffers
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "gitcommit",
		callback = function(event)
			-- Add keymap for manual regeneration
			vim.keymap.set("n", "<leader>cm", "<cmd>CommitMsg<cr>", {
				buffer = event.buf,
				desc = "Generate AI Commit Message",
			})

			-- Auto-generate if buffer is empty (first line is empty)
			vim.schedule(function()
				local first_line = vim.api.nvim_buf_get_lines(event.buf, 0, 1, false)[1]
				if first_line == "" or first_line == nil then
					M.generate()
				end
			end)
		end,
	})
end

-- Lazy.nvim plugin specification
return {
	"nvim-lua/plenary.nvim",
	name = "commit-ai",
	lazy = false,
	config = function()
		M.setup({})
	end,
}
