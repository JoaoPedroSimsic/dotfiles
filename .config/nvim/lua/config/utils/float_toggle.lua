local M = {}

-- Track floating windows by key
local tracked_windows = {}

--- Toggle a floating window
--- @param key string Unique identifier for this float window
--- @param open_fn function Function that opens the float window
function M.toggle(key, open_fn)
	local tracked = tracked_windows[key]

	-- If float window exists and is valid, close it
	if tracked and tracked.float_win and vim.api.nvim_win_is_valid(tracked.float_win) then
		-- Close the float window directly
		vim.api.nvim_win_close(tracked.float_win, true)
		tracked_windows[key] = nil
		
		-- If we were in the float window, return to source
		local current_win = vim.api.nvim_get_current_win()
		if current_win == tracked.float_win and tracked.source_win and vim.api.nvim_win_is_valid(tracked.source_win) then
			vim.api.nvim_set_current_win(tracked.source_win)
		end
		
		return
	end

	-- Store current window as source before opening float
	local source_win = vim.api.nvim_get_current_win()

	-- Open the window
	local result = { open_fn() }
	
	-- Some functions return the window ID directly (like vim.diagnostic.open_float)
	-- Others don't (like vim.lsp.buf.hover), so we need to find it
	local new_win = result[2] or M.find_last_float()
	
	if new_win then
		tracked_windows[key] = {
			float_win = new_win,
			source_win = source_win,
		}
	end
end

--- Find the most recently created floating window
--- @return number|nil Window ID or nil if not found
function M.find_last_float()
	local wins = vim.api.nvim_list_wins()
	-- Iterate backwards to find the most recent float
	for i = #wins, 1, -1 do
		local config = vim.api.nvim_win_get_config(wins[i])
		if config.relative ~= "" then
			return wins[i]
		end
	end
	return nil
end

--- Close all tracked floating windows
function M.close_all()
	for key, tracked in pairs(tracked_windows) do
		if tracked and tracked.float_win and vim.api.nvim_win_is_valid(tracked.float_win) then
			vim.api.nvim_win_close(tracked.float_win, true)
		end
		tracked_windows[key] = nil
	end
end

--- Check if cursor is currently in a tracked floating window
--- @param key string Unique identifier for the float window
--- @return boolean True if cursor is in the tracked float window
function M.is_in_float(key)
	local tracked = tracked_windows[key]
	if not tracked or not tracked.float_win then
		return false
	end
	
	if not vim.api.nvim_win_is_valid(tracked.float_win) then
		return false
	end
	
	local current_win = vim.api.nvim_get_current_win()
	return current_win == tracked.float_win
end

return M
