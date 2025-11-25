--NOTE: latex
local vimtex = {
        "lervag/vimtex",
        config = function()
                vim.g.tex_flavor = "latex" -- Default tex file format

                -- vim.g.vimtex_indent_bib_enabled = 0
                -- vim.g.vimtex_indent_enabled = 0

                vim.g.vimtex_complete_enabled = 0
                -- Disable imaps (using Ultisnips)
                vim.g.vimtex_imaps_enabled = 0
                -- auto open quickfix on compile errors
                vim.g.vimtex_quickfix_mode = 0
                vim.g.vimtex_view_method = "skim"

                -- vim.g.vimtex_view_method = "sioyek"

                vim.g.vimtex_compiler_latexmk_engines = {
                        _ = "-lualatex",
                        pdflatex = "-pdf",
                        dvipdfex = "-pdfdvi",
                        lualatex = "-lualatex",
                        xelatex = "-xelatex",
                }
        end,
        dependencies = {
                "ybian/smartim",
                config = function()
                        vim.g.smartim_default = "com.apple.keylayout.ABC"
                end,
        },
        ft = "tex",
}

-- Terminal window navigation
-- { { "t", }, "<C-h>",  "<C-\\><C-N><C-w>h", opts },
-- { { "t", }, "<C-j>",  "<C-\\><C-N><C-w>j", opts },
-- { { "t", }, "<C-k>",  "<C-\\><C-N><C-w>k", opts },
-- { { "t", }, "<C-l>",  "<C-\\><C-N><C-w>l", opts },

--PLUG:
M[#M + 1] = {
        "projekt0n/github-nvim-theme",
        main = "github-theme",
        opts = {
                groups = {
                        all = {
                                TabLineSel = { fg = "palette.red", bg = "bg" },
                                BlinkCmpKind = { link = "KeyWord" },
                                AlphaHeader = { fg = "#39C5BB" },
                                IndentLine = { link = "Whitespace" },
                                IndentLineCurrent = { link = "Whitespace" },
                        },
                },
        },
        lazy = true,
}

--NOTE: trouble
local trouble = require("trouble")
trouble.setup({
        focus = true,
        auto_preview = false,
        auto_close = true,
        win = { position = "right" },
        preview = {
                type = "float",
                relative = "editor",
                border = "single",
                position = { 0, -2 },
                size = { width = 0.3, height = 0.3 },
                zindex = 200,
        },
        modes = {
                symbols = {
                        auto_preview = false,
                        focus = true,
                },
        },
})

keymap({ "n" }, "<leader>tx", function()
        if trouble.is_open({}) then
                require("trouble").close()
        end
end, key_opts)
keymap({ "n" }, "<leader>tj", function()
        if trouble.is_open({}) then
                require("trouble").next({ jump = true })
        end
end, key_opts)
keymap({ "n" }, "<leader>tk", function()
        if trouble.is_open({}) then
                require("trouble").prev({ jump = true })
        end
end, key_opts)
