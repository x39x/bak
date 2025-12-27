--NOTE: mason install
local M = {}

M.config = function()
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

--NOTE: spell completion
M.nullls_config = function()
        local null_ls = require("null-ls")
        local completion = null_ls.builtins.completion
        null_ls.setup({
                sources = {
                        completion.spell,
                },
        })
end

--NOTE: LSP rename
M.rename = function()
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

-- pyright
local lsp_keymaps = require("lspconfig.keymap")
local python_path = require("utils.python_path")
pyright = {
        on_init = function(client)
                client.config.settings.python.pythonPath = python_path
        end,
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
                ".git",
        },
        settings = {
                python = {
                        analysis = {
                                typeCheckingMode = "off",
                        },
                },
        },
        on_attach = function(_, bufnr)
                lsp_keymaps(bufnr)
        end,
}
