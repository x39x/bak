local rename = function()
        local opts = {
                relative = "cursor",
                row = 0,
                col = 0,
                width = 20,
                height = 1,
                style = "minimal",
                border = "single",
        }
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_open_win(buf, true, opts)
        vim.api.nvim_input("a")
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>stopinsert | close<CR>", { silent = true, buffer = true })
        vim.keymap.set("i", "<CR>", function()
                local new_name = vim.trim(vim.fn.getline("."))
                vim.api.nvim_win_close(0, true)
                vim.cmd("stopinsert")
                vim.fn.cursor(vim.fn.line("."), vim.fn.col(".") + 1)
                vim.lsp.buf.rename(new_name)
        end, { buffer = true })
end

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

local runCode = {
        c = function()
                vim.cmd('TermExec cmd="cd %:p:h && clang %:t -o %:t:r && ./%:t:r && rm %:t:r"')
        end,

        -- cpp = function()
        --         vim.cmd("TermExec cmd=\"cd %:p:h && clang++ %:t -o %:t:r && ./%:t:r && rm %:t:r\"")
        -- end,

        --cpp 20
        cpp = function()
                vim.cmd('TermExec cmd="cd %:p:h && clang++ -std=c++20 -fmodules %:t -o %:t:r && ./%:t:r && rm %:t:r"')
        end,

        go = function()
                vim.cmd('TermExec cmd="cd %:p:h && go run %:t"')
        end,
        python = function()
                vim.cmd('TermExec cmd="cd %:p:h && python3 %:t"')
        end,

        rust = function()
                vim.cmd('TermExec cmd="cd %:p:h && cargo run"')
        end,

        markdown = function()
                vim.cmd("silent! !open %")
        end,

        typst = function()
                vim.cmd("silent! !open -a Skim.app %:p:r.pdf")
        end,
        scheme = function()
                vim.cmd('TermExec cmd="cd %:p:h && racket %:t"')
        end,
}

local nullls_config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local completion = null_ls.builtins.completion
        null_ls.setup({
                debug = false,
                sources = {
                        formatting.black,
                        completion.spell,
                },
        })
end

local lspconfig = function()
        local lspconfig = require("lspconfig")

        local on_attach = function(client, bufnr)
                -- ???
                if client.name == "ts_ls" then
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                end
                lsp_keymaps(bufnr)
        end

        for _, server in pairs(servers) do
                local opts = {
                        on_attach = on_attach,
                }
                local has_custom_opts, server_custom_opts = pcall(require, "39.lsp." .. server)
                if has_custom_opts then
                        opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
                end
                lspconfig[server].setup(opts)
        end
end

-- telescope theme
-- prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
-- results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
-- preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

-- Terminal window navigation
-- { { "t", }, "<C-h>",  "<C-\\><C-N><C-w>h", opts },
-- { { "t", }, "<C-j>",  "<C-\\><C-N><C-w>j", opts },
-- { { "t", }, "<C-k>",  "<C-\\><C-N><C-w>k", opts },
-- { { "t", }, "<C-l>",  "<C-\\><C-N><C-w>l", opts },
