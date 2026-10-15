-- NOTE: cmp config
local cmp_border = { " ", " ", " ", " ", " ", " ", " ", " " }

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
	completion = {
		-- keyword = { range = "prefix" },
		menu = {
			border = cmp_border,
			scrollbar = false,
		},
		documentation = { window = { border = "single", scrollbar = false }, auto_show = false },
	},
	cmdline = {
		keymap = { preset = "inherit" },
	},
	keymap = {
		["<C-space>"] = {},
		["<C-l>"] = { "select_and_accept", "fallback" },
		["<C-y>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
	},
	signature = {
		enabled = true,
		window = { border = cmp_border, scrollbar = false },
	},
	sources = {
		providers = {
			snippets = {
				opts = {
					extended_filetypes = {
						javascriptreact = { "html" },
					},
				},
			},
		},
	},
})
