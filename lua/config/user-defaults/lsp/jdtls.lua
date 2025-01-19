--- This module provides default settings for jdtls
---
--- If not provided, paths to required jar and config files will be discovered where possible.

--- @class JDTLSPaths
---
--- The path to the java executable. If a value is not provided, it will be assumed to be available in the system PATH.
--- @field java_path string?
---
--- The root directory of the jdtls project. jdtls jar files are expected to exist in the /plugins directory relative
--- to this value. If a value is not provided, an attempt will be made to discover an appropriate directory.
--- @field jdtls_home string?
---
--- The parent directory for jdtls project data directories (see
--- https://github.com/mfussenegger/nvim-jdtls#data-directory-configuration). Defaults to
--- `stdpath('cache')/jdtls/workspaces`.
--- @field workspace_directory string?
---
--- The OS and architecture specific configuration directory for jdtls (see the `-configuration` option described at
--- https://github.com/eclipse-jdtls/eclipse.jdt.ls#running-from-the-command-line). If a value is not provided, an
--- attempt will be made to determine the OS and architecture of the current system, from which an appropriate value
--- will be selected.
--- @field config_directory string?
---
--- The path to the jdtls jar file. Defaults to `{jdtls_home}/plugins/org.eclipse.equinox.launcher.jar`.
--- @field jar_path string?
---
--- The jdtls project data directory (see https://github.com/mfussenegger/nvim-jdtls#data-directory-configuration).
--- Defaults to `{workspace_directory}/{project_name}`, where `{project_name}` will be generated based on the current
--- working directory.
--- @field data_directory string?

--- @class JDTLSSettings
---
--- The shell command used to start the jdtls language server. If not provided, a suitable default will be constructed
--- from values defined in {jdtls_paths}.
--- @field cmd string[]?
---
--- The root directory of the project. By default, will search for key marker files such as `.git` and `pom.xml`.
--- @field root_dir string?

--- @class JDTLSUserSettings
---
--- Paths to be passed to the jdtls binary's command-line, or path fragments from which to construct/deduce/discover
--- said paths.
--- @field jdtls_paths JDTLSPaths
---
--- Settings to be passed to jdtls.
--- @field jdtls_settings JDTLSSettings

local log = require("utils.log")

--- @type JDTLSSettings
local M = {
	root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {},
	},
}

---@type boolean, JDTLSUserSettings
local ok, user_jdtls_settings = pcall(require, "config.user.lsp.jdtls")
if ok then
	M = vim.tbl_extend("force", M, user_jdtls_settings.jdtls_settings)
end

---Searches for jdtls in standard locations.
---@return string? jdtls_home The path to jdtls or nil if not found.
local function try_discover_jdtls_home()
	local jdtls_search_paths = {
		vim.fn.stdpath("data") .. "/mason/packages/jdtls", -- mason
	}

	for _, path in ipairs(jdtls_search_paths) do
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
	end

	return nil
end

if M.cmd == nil then
	local jdtls_paths = user_jdtls_settings.jdtls_paths or {}
	local java_path = jdtls_paths.java_path or "java"
	local config_directory = jdtls_paths.config_directory
	local jar_path = jdtls_paths.jar_path
	local workspace_directory = jdtls_paths.workspace_directory
	local data_directory = jdtls_paths.data_directory
	local jdtls_home = jdtls_paths.jdtls_home

	if config_directory == nil then
		log.debug("config_directory was not provided, using jdtls_home to determine most suitable value")

		-- Optimisation: only serach for jdtls if necessary
		jdtls_home = jdtls_home or try_discover_jdtls_home()
		if jdtls_home == nil then
			vim.notify(
				"User has not provided `config_directory` nor `jdtls_home`, a suitable config_directory could not be determined",
				vim.log.levels.ERROR
			)
		else
			local config_fragment = ""

			if vim.fn.has("win32") == 1 then
				config_fragment = "config_win"
			else
				-- Assume user is on a unix system
				if vim.fn.has("mac") == 1 then
					config_fragment = "config_mac"
				else
					-- Assume linux
					config_fragment = "config_linux"
				end

				-- Try to determine if architecture is arm
				local result = vim.system({ "uname", "-p" }, { text = true }):wait()
				if result.code == 0 and vim.trim(result.stdout) == "arm" then
					config_fragment = config_fragment .. "_arm"
				end
			end

			config_directory = jdtls_home .. "/" .. config_fragment
		end
	end

	if jar_path == nil then
		log.debug("jar_path was not provided, using jdtls_home to determine most suitable value")

		-- Optimisation: only serach for jdtls if necessary
		jdtls_home = jdtls_home or try_discover_jdtls_home()
		if jdtls_home == nil then
			vim.notify(
				"User has not provided `jar_path` nor `jdtls_home`, no suitable value for 'jar_path' could be determined",
				vim.log.levels.ERROR
			)
		else
			jar_path = jdtls_home .. "/plugins/org.eclipse.equinox.launcher.jar"
		end
	end

	if data_directory == nil then
		if workspace_directory == nil then
			workspace_directory = vim.fn.stdpath("cache") .. "/jdtls/workspaces"
		end

		data_directory = workspace_directory .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	end

	log.debug("java path: %s", { java_path })
	log.debug("jdtls jar path: %s", { jar_path })
	log.debug("jdtls config dir: %s", { config_directory })
	log.debug("jdtls data dir: %s", { data_directory })

	M.cmd = {
		java_path,
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		jar_path,
		"-configuration",
		config_directory,
		"-data",
		data_directory,
	}
end

return M
