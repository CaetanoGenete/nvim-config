return {
	cmd = {
		"rumdl",
		"server",
		"--config",
		vim.fs.joinpath(vim.fn.stdpath("config"), "external-configs", ".rumdl.toml"),
	},
}
