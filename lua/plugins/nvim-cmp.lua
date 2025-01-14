---@module "lazy"
---@type LazyPluginSpec
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		---@param fallback fun(): nil # The fallback behaviour if no visible completion window and no snippet node.
		local function next(fallback)
			if cmp.visible() then
				-- Prefer navigating completion window of jumping between snippet nodes
				if #cmp.get_entries() == 1 then
					cmp.confirm({ select = true })
				else
					cmp.select_next_item()
				end
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end

		---@param fallback fun(): nil # The fallback behaviour if no visible completion window and no snippet node.
		local function prev(fallback)
			-- Prefer navigating completion window of jumping between snippet nodes
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(next, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(prev, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{
					name = "lazydev",
					-- set group index to 0 to skip loading LuaLS completions
					group_index = 0,
				},
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, { { name = "buffer" } }),
		})
	end,
}
