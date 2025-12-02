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

-- Terminal window navigation
-- { { "t", }, "<C-h>",  "<C-\\><C-N><C-w>h", opts },
-- { { "t", }, "<C-j>",  "<C-\\><C-N><C-w>j", opts },
-- { { "t", }, "<C-k>",  "<C-\\><C-N><C-w>k", opts },
-- { { "t", }, "<C-l>",  "<C-\\><C-N><C-w>l", opts },

local M
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
