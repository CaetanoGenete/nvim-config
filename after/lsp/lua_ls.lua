local path = nil

local lua_path = os.getenv("LUA_PATH")
if lua_path ~= nil then
	path = vim.tbl_map(vim.fs.normalize, vim.split(lua_path, ";", { trimempty = true }))
end

return {
	settings = {
		Lua = {
			runtime = {
				path = path,
			},
			workspace = {
				library = {
					"C:/Users/caeta/AppData/Roaming/LuaRocks/systree/share/lua/5.1",
				},
			},
		},
	},
}
