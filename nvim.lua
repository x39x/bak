--NOTE: LSP rename
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

--NOTE: spell completion
local nullls_config = function()
        local null_ls = require("null-ls")
        local completion = null_ls.builtins.completion
        null_ls.setup({
                sources = {
                        completion.spell,
                },
        })
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

-- NOTE: cmp config
local cmp_border = { " ", " ", " ", " ", " ", " ", " ", " " }

local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local cmp_icons = {
        Array = "",
        Boolean = "",
        Class = "",
        Codeium = "",
        Color = "󰏘",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Function = "󰆧",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "󰆧",
        Module = "",
        Namespace = "",
        Null = "󰟢",
        Number = "",
        Object = "",
        Operator = "󰆕",
        Package = "",
        Property = "",
        Reference = "󰈇",
        Snippet = "",
        String = "",
        Struct = "󰙅",
        TabNine = "",
        Table = "",
        Tag = "",
        Text = "󰉿",
        TypeParameter = "󰊄",
        Unit = "",
        Value = "󰎠",
        Variable = "",
}

M.dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "windwp/nvim-autopairs",
        {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                        "L3MON4D3/LuaSnip",
                        "rafamadriz/friendly-snippets",
                },
        },
}

M.config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        luasnip.config.set_config({
                enable_autosnippets = true,
        })
        require("luasnip/loaders/from_vscode").lazy_load({
                include = {
                        "lua",
                },
        })
        require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
        })

        cmp.setup({
                snippet = {
                        expand = function(args)
                                luasnip.lsp_expand(args.body) -- load snippets
                        end,
                },
                window = {
                        completion = {
                                scrollbar = false,
                                border = cmp_border,
                        },
                        documentation = {
                                scrollbar = false,
                                border = cmp_border,
                        },
                },
                formatting = {
                        fields = { "kind", "abbr", "menu" },
                        format = function(entry, vim_item)
                                vim_item.kind = string.format("%s", cmp_icons[vim_item.kind])
                                vim_item.menu = ({
                                        nvim_lsp = "[LSP]",
                                        luasnip = "[Snippet]",
                                        buffer = "[Buffer]",
                                        path = "[Path]",
                                })[entry.source.name]
                                return vim_item
                        end,
                },
                experimental = {
                        ghost_text = false,
                },
                mapping = cmp.mapping.preset.insert({

                        ["<A-e>"] = cmp.mapping({
                                i = cmp.mapping.abort(),
                                c = cmp.mapping.close(),
                        }),
                        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
                        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                        ["<CR>"] = cmp.mapping.confirm({
                                behavior = cmp.ConfirmBehavior.Replace,
                                select = true,
                        }),

                        ["<Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                        cmp.select_next_item()
                                elseif luasnip.expandable() then
                                        luasnip.expand()
                                elseif luasnip.expand_or_jumpable() then
                                        luasnip.expand_or_jump()
                                elseif check_backspace() then
                                        fallback()
                                else
                                        fallback()
                                end
                        end, { "i", "s" }),

                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                                if cmp.visible() then
                                        cmp.select_prev_item()
                                elseif luasnip.jumpable(-1) then
                                        luasnip.jump(-1)
                                else
                                        fallback()
                                end
                        end, { "i", "s" }),
                }),
                sources = {
                        { name = "nvim_lsp", max_item_count = 5 },
                        { name = "luasnip", max_item_count = 5 },
                        { name = "buffer", max_item_count = 5 },
                        { name = "path", max_item_count = 5 },
                },
        })
        cmp.event:on( -- insert `(` after select function or method item
                "confirm_done",
                cmp_autopairs.on_confirm_done()
        )
end

--NOTE: cmp lsp config
local LSP = {}

LSP.dependencies = {
        "hrsh7th/cmp-nvim-lsp",
}

LSP.config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        --  ...
        --  ...
        --  ...
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

        local opts = {
                --  ...
                capabilities = capabilities,
        }
        --- ...
        lspconfig[_].setup(opts)
end

--NOTE: mason install

local config = function()
        require("mason").setup()
        local mason_packages = {
                "stylua",
        }
        local function ensure_installed(packages)
                local registry = require("mason-registry")

                for _, pkg_name in ipairs(packages) do
                        if registry.has_package(pkg_name) then
                                local pkg = registry.get_package(pkg_name)
                                if not pkg:is_installed() then
                                        pkg:install()
                                        vim.notify("Installing " .. pkg_name .. " via mason.nvim", vim.log.levels.INFO)
                                end
                        else
                                vim.notify("Package " .. pkg_name .. " not found in registry", vim.log.levels.WARN)
                        end
                end
        end

        vim.defer_fn(function()
                require("mason-registry").refresh(function()
                        ensure_installed(mason_packages)
                end)
        end, 200)
end
