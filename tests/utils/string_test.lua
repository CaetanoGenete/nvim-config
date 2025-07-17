require("plenary.busted")

local str_utils = require("utils.string")

describe("split string", function()
	it("it should split '0 1 2 3' -> {0, 1, 2, 3}.", function()
		assert.are.equal({ 0, 1, 2, 3 }, str_utils.split("0 1 2 3"))
	end)

	it("should handle empty strings.", function()
		assert.are.equal({}, str_utils.split(""))
	end)

	it("should handle different separators.", function()
		assert.are.equal({ "ab", "c", "de", "f" }, str_utils.split("ab, c, de, f", ","))
	end)
end)
