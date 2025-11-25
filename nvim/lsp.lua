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
