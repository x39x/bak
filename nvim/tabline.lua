local api = vim.api
local fn = vim.fn
local au = api.nvim_create_autocmd
local aug = api.nvim_create_augroup("matsu.matsuline", { clear = true })

local state = {
    -- tabline
    show_labels = false,
    buffers = {},
    tabs = {},
    active_bufnr = nil,
}

---========================================================================
-- global
---========================================================================
local TPB_EXCLUDED_FT = { fzf = true }
local TPB_EXCLUDED_BT = { quickfix = true }
local TPB_LABEL_CHARS = { "h", "j", "k", "l", "g", "m", "n", "f", "w", "e", "r", "u" }

local function set_hl(name, inherit)
    local marker = inherit and "$" or "#"
    return "%" .. marker .. name .. marker
end

local function file_flag(bufnr)
    bufnr = bufnr or 0
    local bo = vim.bo[bufnr]
    if not bo then
        return
    end
    if bo.readonly then
        return "[]"
    elseif bo.buftype == "terminal" then
        return "[]"
    elseif not bo.modifiable then
        return "[=]"
    elseif bo.modified then
        return "[+]"
    end
    return "   "
end

local function escape_statusline(s)
    return (s:gsub("%%", "%%%%"))
end

---========================================================================
-- topbar
---========================================================================
-- 包裹 click 函数：%{id}@v:lua.{handler}@ ... %X
local function clickable(handler, id, text)
    return string.format("%%%d@v:lua.%s@%s%%X", id, handler, text)
end

-------------------- Buffer --------------------

local function is_valid_buffer(bufnr)
    local bo = vim.bo[bufnr]
    if not bo then
        return
    end

    --- special ft/bt
    if bo.filetype == "man" then
        return true
    end

    --- exclude ft/bt

    if TPB_EXCLUDED_FT[bo.filetype] then
        return false
    end

    if TPB_EXCLUDED_BT[bo.buftype] then
        return false
    end

    return bo.buflisted
end

local function get_buffer_name(bufnr)
    local name = vim.fs.basename(api.nvim_buf_get_name(bufnr))
    if name == "" then
        return "[No Name]"
    end

    local len = fn.strchars(name)
    if len > 39 then
        return fn.strcharpart(name, 0, 13) .. "..." .. fn.strcharpart(name, len - 19)
    end
    return name
end

local function collect_buffers()
    local current = api.nvim_get_current_buf()
    if is_valid_buffer(current) then
        state.active_bufnr = current
    end

    local buffers = {}
    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if is_valid_buffer(bufnr) then
            local index = #buffers + 1
            buffers[index] = {
                bufnr = bufnr,
                name = get_buffer_name(bufnr),
                label = state.show_labels and (TPB_LABEL_CHARS[index] or "#") or " ",
            }
        end
    end

    state.buffers = buffers
    return buffers
end

-- 渲染单个 buffer，返回 { str, width }
local function render_buffer(buffer)
    local flag = file_flag(buffer.bufnr)
    local name_hl = buffer.bufnr == state.active_bufnr and set_hl("MatsuLineA", true) or set_hl("TabLine")

    local str = clickable(
        "matsu_click_buf",
        buffer.bufnr,
        table.concat({
            " ",
            set_hl("MatsuLineBold"),
            set_hl("MatsuLineD", true),
            buffer.label,
            name_hl,
            escape_statusline(buffer.name),
            set_hl("MatsuLineC"),
            flag,
        })
    )
    local width = 1 + fn.strdisplaywidth(buffer.label .. buffer.name .. flag)

    return { str = str, width = width, is_active = buffer.bufnr == state.active_bufnr }
end

local function concat_range(items, first, last)
    local parts = {}
    for i = first, last do
        parts[#parts + 1] = items[i].str
    end
    return table.concat(parts)
end

-- 在 max_width 内渲染 buffer 列表，保证 active buffer 可见
local function render_buffers(max_width)
    local items, active_idx, total = {}, 1, 0

    for i, buffer in ipairs(collect_buffers()) do
        local item = render_buffer(buffer)
        items[i] = item
        total = total + item.width
        if item.is_active then
            active_idx = i
        end
    end

    if #items == 0 then
        return ""
    end
    if total <= max_width then
        return " " .. concat_range(items, 1, #items)
    end

    local budget = max_width - api.nvim_strwidth("  ") -- 按照最长预留边界,使用时根据实际减去
    local first, last = active_idx, active_idx
    local used = items[active_idx].width -- active 即使单个超宽也强制显示 (%< fallback)

    local grew = true
    while grew do
        grew = false
        if last < #items and used + items[last + 1].width <= budget then
            last = last + 1
            used = used + items[last].width
            grew = true
        end
        if first > 1 and used + items[first - 1].width <= budget then
            first = first - 1
            used = used + items[first].width
            grew = true
        end
    end

    local head = " "
    if first > 1 then
        head = set_hl("Comment") .. "  "
    else
        -- head 预留 3 字符，这里只用了一个
        used = used - 2
    end

    -- 使 bufline 占满剩余宽度
    local trail = ""
    if last < #items then
        -- 边界宽度已预留，used==budget 后再加""刚好，不用再减 1
        while used < budget do
            trail = trail .. " "
            used = used + 1
        end
        trail = set_hl("Comment") .. trail .. ""
    end

    return table.concat({ head .. "%<", concat_range(items, first, last), trail })
end

local function click_buffer(bufnr, _, button)
    if button == "r" then
        api.nvim_buf_delete(bufnr, { force = false })
    elseif api.nvim_buf_is_valid(bufnr) then
        api.nvim_win_set_buf(0, bufnr)
    end
    vim.cmd.redrawtabline()
end

-------------------- Tab --------------------

local function render_tab(tab, current_tabid)
    local tab_hl = set_hl("TabLine", true)
    if state.show_labels then
        tab_hl = set_hl("MatsuLineC", true)
    elseif tab.tabid == current_tabid then
        tab_hl = set_hl("MatsuLineB", true)
    end
    local ctx = table.concat({ " ", set_hl("MatsuLineBold"), tab_hl, tab.tabnr, " " })
    return clickable("matsu_click_tab", tab.tabid, ctx)
end

-- 返回 tab 区域的渲染串和显示宽度；超过 max_width 时退为 " 当前/总数 "
local function render_tabs(max_width)
    local current_tabid = api.nvim_get_current_tabpage()
    local tabs, parts, width = {}, {}, 0

    for i, tabid in ipairs(api.nvim_list_tabpages()) do
        tabs[i] = { tabid = tabid, tabnr = api.nvim_tabpage_get_number(tabid) }
        parts[i] = render_tab(tabs[i], current_tabid)
        width = width + 2 + #tostring(tabs[i].tabnr)
    end
    state.tabs = tabs

    if #tabs <= 1 then
        return "", 0
    end
    if width > max_width then
        local str = string.format(" %d/%d ", fn.tabpagenr(), #tabs)
        return str, #str
    end
    return table.concat(parts), width
end

local function click_tab(tabid, _, button)
    if button == "r" then
        vim.cmd.tabclose()
    elseif api.nvim_tabpage_is_valid(tabid) then
        api.nvim_set_current_tabpage(tabid)
    end
    vim.cmd.redrawtabline()
end

-------------------- Topbar --------------------

local function render_tb()
    local columns = vim.o.columns
    local tab_str, tab_width = render_tabs(columns / 3)
    local buf_str = render_buffers(columns - tab_width - 3) -- space

    -- 头部空格由 render_buffers 添加
    return table.concat({ buf_str, "%=", tab_str, "   " })
end

-------------------- Jump --------------------

local function jump()
    state.show_labels = true
    vim.cmd.redrawtabline()

    local char = fn.getcharstr()
    local tabnr = tonumber(char)

    if tabnr then
        for _, tab in ipairs(state.tabs) do
            if tab.tabnr == tabnr and api.nvim_tabpage_is_valid(tab.tabid) then
                api.nvim_set_current_tabpage(tab.tabid)
                break
            end
        end
    else
        for _, buffer in ipairs(state.buffers) do
            if buffer.label == char and api.nvim_buf_is_valid(buffer.bufnr) then
                api.nvim_win_set_buf(0, buffer.bufnr)
                break
            end
        end
    end

    state.show_labels = false
    vim.cmd.redrawtabline()
end

---========================================================================
-- highlight
---========================================================================

local function link_if_unset(name, target)
    if vim.tbl_isempty(api.nvim_get_hl(0, { name = name })) then
        api.nvim_set_hl(0, name, { link = target })
    end
end

local function apply_highlights()
    link_if_unset("MatsuLineA", "Function")
    link_if_unset("MatsuLineB", "Keyword")
    link_if_unset("MatsuLineC", "Added")
    link_if_unset("MatsuLineD", "Removed")

    api.nvim_set_hl(0, "MatsuLineBold", { bold = true })
    api.nvim_set_hl(0, "TabLine", { bold = false })
    api.nvim_set_hl(0, "TabLineSel", { link = "TabLine" })
    api.nvim_set_hl(0, "TabLineFill", { link = "TabLine" })
end

au("ColorScheme", {
    group = aug,
    callback = function()
        apply_highlights()
        vim.cmd.redrawstatus({ bang = true })
    end,
})

---========================================================================
-- setup
---========================================================================

apply_highlights()

_G.matsu_click_buf = click_buffer
_G.matsu_click_tab = click_tab

vim.g.matsu_topbar = render_tb

vim.go.tabline = "%{%g:matsu_topbar()%}"

vim.keymap.set("n", "<leader><leader>", jump)
