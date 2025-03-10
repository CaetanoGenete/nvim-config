--- This module provides default settings for jdtls
---
--- If not provided, paths to required jar and config files will be discovered where possible.

--- @class JDTLSPaths
--- The path to the java executable. If a value is not provided, it will be assumed to be available in the system PATH.
--- @field java_path string?
--- The root directory of the jdtls project. jdtls jar files are expected to exist in the /plugins directory relative
--- to this value. If a value is not provided, an attempt will be made to discover an appropriate directory.
--- @field jdtls_home string?
--- The parent directory for jdtls project data directories (see
--- https://github.com/mfussenegger/nvim-jdtls#data-directory-configuration). Defaults to
--- `stdpath('cache')/jdtls/workspaces`.
--- @field workspace_directory string?
--- The OS and architecture specific configuration directory for jdtls (see the `-configuration` option described at
--- https://github.com/eclipse-jdtls/eclipse.jdt.ls#running-from-the-command-line). If a value is not provided, an
--- attempt will be made to determine the OS and architecture of the current system, from which an appropriate value
--- will be selected.
--- @field config_directory string?
--- The path to the jdtls jar file. Defaults to `{jdtls_home}/plugins/org.eclipse.equinox.launcher.jar`.
--- @field jar_path string?
--- The jdtls project data directory (see https://github.com/mfussenegger/nvim-jdtls#data-directory-configuration).
--- Defaults to `{workspace_directory}/{project_name}`, where `{project_name}` will be generated based on the current
--- working directory.
--- @field data_directory string?

--- @class JDTLSSettings
--- The shell command used to start the jdtls language server. If not provided, a suitable default will be constructed
--- from values defined in {jdtls_paths}.
--- @field cmd string[]?
--- The root directory of the project. By default, will search for key marker files such as `.git` and `pom.xml`.
--- @field root_dir string?

--- @class JDTLSUserSettings
--- Paths to be passed to the jdtls binary's command-line, or path fragments from which to construct/deduce/discover
--- said paths.
--- @field jdtls_paths JDTLSPaths?
--- Settings to be passed to jdtls.
--- @field jdtls_settings JDTLSSettings?
--- Additional arguments passed to the jdtls command.
--- @field additional_jvm_args string[]?
--- Whether to add lombok as a java-agent.
---	- If `true`, will look for the lombok binary in common locations, failing with a warning if it cannot find it.
---	- If a string, will assume it represents a path to the lombok jar file.
--- Defaults to `false`.
--- @field lombok boolean|string?

local log = require("utils.log")
local module_utils = require("utils.module")

--- @type JDTLSSettings
local M = {}
M.root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" })

---@type JDTLSUserSettings
local user_jdtls_settings = module_utils.require_or("config.user.lsp.jdtls", {})

---@return string? jdtls_home The path to jdtls or `nil` if not found.
local function try_discover_jdtls_home()
	--- @type string[]
	local jdtls_search_paths = {}

	local mason_ok, mason_registry = pcall(require, "mason-registry")
	if mason_ok then
		table.insert(jdtls_search_paths, mason_registry.get_package("jdtls"):get_install_path())
	end

	for _, path in ipairs(jdtls_search_paths) do
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
	end

	return nil
end

---@return string? lombok_path The path to lombok binary or `nil` if not found.
local function try_discover_lombok()
	--- TODO: Cache this result

	--- @type string[]
	local lombok_search_paths = {
		-- OSX maven lombok install dir
		"~/.m2/repository/org/projectlombok",
	}

	local mason_ok, mason_registry = pcall(require, "mason-registry")
	if mason_ok and mason_registry.has_package("lombok-nightly") then
		table.insert(lombok_search_paths, 1, mason_registry.get_package("lombok-nightly"):get_install_path())
	end

	for _, path in ipairs(lombok_search_paths) do
		--- @type string[]
		local candidates = vim.fn.glob(vim.fs.joinpath(path, "/**/lombok*.jar"), nil, true)
		if #candidates > 0 then
			local result = candidates[#candidates]
			log.fmt_debug("Lombok found at `%s`", result)
			return result
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
	local additional_jvm_args = user_jdtls_settings.additional_jvm_args or {}

	if config_directory == nil then
		log.debug("config_directory was not provided, using jdtls_home to determine most suitable value")

		jdtls_home = assert(
			jdtls_home or try_discover_jdtls_home(),
			"`config_directory` was not provided nor was `jdtls_home` found. Could not determine `config_directory`."
		)

		local config_fragment = ""
		if vim.fn.has("win32") == 1 then
			log.debug("OS is `windows`.")
			config_fragment = "config_win"
		else
			-- Assume user is on a unix system
			if vim.fn.has("mac") == 1 then
				log.debug("OS is `OSX`.")
				config_fragment = "config_mac"
			else
				log.debug("Could not determine OS, assuming `linux`.")
				config_fragment = "config_linux"
			end

			-- Try to determine if architecture is arm
			local result = vim.system({ "uname", "-p" }, { text = true }):wait()
			if result.code == 0 and vim.trim(result.stdout) == "arm" then
				log.debug("Architecture is `arm`.")
				config_fragment = config_fragment .. "_arm"
			end
		end

		config_directory = vim.fs.joinpath(jdtls_home, config_fragment)
	end

	if jar_path == nil then
		log.debug("jar_path was not provided, using jdtls_home to determine most suitable value")

		jdtls_home = assert(
			jdtls_home or try_discover_jdtls_home(),
			"`jar_path` was not provided nor was `jdtls_home` found, could not determine `jar_path`."
		)
		jar_path = vim.fs.joinpath(jdtls_home, "/plugins/org.eclipse.equinox.launcher.jar")
	end

	if data_directory == nil then
		--- @diagnostic disable-next-line:param-type-mismatch cache should always return a single string
		workspace_directory = workspace_directory or vim.fs.joinpath(vim.fn.stdpath("cache"), "/jdtls/workspaces")
		data_directory = vim.fs.joinpath(workspace_directory, vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"))
	end

	if user_jdtls_settings.lombok or false then
		local lombok = user_jdtls_settings.lombok

		if type(lombok) == "string" then
			if vim.fn.isdirectory(lombok) == 0 then
				log.fmt_warn("Directory `%s` is invalid.", lombok)
				goto exit_error
			end

			if not vim.endswith(lombok, ".jar") then
				log.fmt_warn("Directory `%s` is not a valid jar file.", lombok)
				goto exit_error
			end
		else
			lombok = try_discover_lombok()
			if lombok == nil then
				log.fmt_warn("Could not find `lombok`, try specify `lombok` as path to a valid binary.")
				goto exit_error
			end
		end

		table.insert(additional_jvm_args, "-javaagent:" .. lombok)
		::exit_error::
	end

	log.fmt_debug("java path: %s", java_path)
	log.fmt_debug("jdtls jar path: %s", jar_path)
	log.fmt_debug("jdtls config dir: %s", config_directory)
	log.fmt_debug("jdtls data dir: %s", data_directory)

	M.cmd = {}
	vim.list_extend(M.cmd, {
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
	})
	vim.list_extend(M.cmd, additional_jvm_args)
	vim.list_extend(M.cmd, {
		"-jar",
		jar_path,
		"-configuration",
		config_directory,
		"-data",
		data_directory,
	})
end

return vim.tbl_extend("force", M, user_jdtls_settings.jdtls_settings or {})
