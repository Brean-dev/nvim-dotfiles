-- Signs like VS Code’s gutter icons
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		source = "if_many", -- show linter name if multiple sources
		prefix = "●", -- or "■", "▎", ""
		format = function(d)
			local msg = d.message
			if d.code then
				msg = msg .. " [" .. d.code .. "]"
			end
			return msg
		end,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

-- Optional: quick peek like VS Code hover
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	callback = function()
		vim.diagnostic.open_float(
			nil,
			{ focusable = false, close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" } }
		)
	end,
})

-- Optional: handy mappings
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
