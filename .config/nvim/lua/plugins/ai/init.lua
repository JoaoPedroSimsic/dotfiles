local manifest = require("config.manifest")
local selected_ai = manifest.tools.ai

local ai_plugins = {
	opencode = "plugins.ai.opencode.init",
	copilot = "plugins.ai.copilot",
	cursor = "plugins.ai.cursor",
}

local module_path = ai_plugins[selected_ai]

if not module_path then
	vim.notify("AI Bridge: No keymap defined for " .. tostring(selected_ai), vim.log.levels.WARN)
	return {}
end

return require(module_path)
