-- https://github.com/simonmclean/triptych.nvim
-- https://github.com/stevearc/oil.nvim,

require("triptych").setup({
        options = {
                backdrop = 100,
        },
})

require("oil").setup({
        default_file_explorer = false,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        watch_for_changes = true,
        use_default_keymaps = false,
        keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["L"] = "actions.select",
                ["H"] = { "actions.parent", mode = "n" },
                ["q"] = { "actions.close", mode = "n" },
                [","] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["="] = "actions.open_external",
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["<C-p>"] = { "actions.preview", mode = "n" },
                ["<C-R>"] = { "actions.refresh", mode = "n" },
                ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
        },
        view_options = {
                show_hidden = true,
        },
        float = {
                padding = 0,
                border = "single",
                get_win_title = nil,
                preview_split = "auto",
                override = function(conf)
                        local ui = vim.api.nvim_list_uis()[1]
                        local sidebar_width = math.floor(ui.width * 0.17)

                        -- send to nvim_open_win.
                        conf = {
                                relative = "editor",
                                width = sidebar_width,
                                height = ui.height,
                                row = 0,
                                col = ui.width - sidebar_width,
                                style = "minimal",
                                border = "single",
                        }

                        return conf
                end,
        },
})
