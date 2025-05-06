config = function()
        require("mason").setup()
        local mason_packages = {
                "lua-language-server",
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
