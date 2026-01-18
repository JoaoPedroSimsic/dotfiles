local M = {}

M.setup = function()
	local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

	local config = {
		cmd = {
			"jdtls",
			"--jvm-arg=-javaagent:" .. lombok_path,
			"-data",
			vim.fn.expand("~/.cache/jdtls/workspace"),
		},
		root_dir = require("jdtls.setup").find_root({ "pom.xml", ".git", "mvnw" }),
		settings = { java = {} },
		init_options = { bundles = {} },
	}
	require("jdtls").start_or_attach(config)
end

return M
