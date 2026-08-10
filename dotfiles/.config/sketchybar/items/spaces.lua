local colors = require("colors")
local settings = require("settings")

local WORKSPACE_CELLS = 12
local ICONS_PER_CELL = 8

local cells = {}
local target = {}

local function app_image(window)
    local id = window["bundle-id"]
    if id == nil or id == "" then id = window.app end
    if id == nil or id == "" then return nil end
    return "app." .. id
end

local function unique_app_images(windows)
    local seen = {}
    local images = {}
    for _, window in ipairs(windows) do
        local image = app_image(window)
        if image and not seen[image] then
            seen[image] = true
            table.insert(images, image)
        end
    end
    return images
end

local function windows_for(grouped, ws)
    local candidates = {ws.id, ws.number, ws["raw-name"], ws["display-name"]}
    for _, key in ipairs(candidates) do
        if key ~= nil and grouped[key] then return grouped[key] end
        if key ~= nil and grouped[tostring(key)] then return grouped[tostring(key)] end
    end
    return {}
end

local function state_colors(ws)
    local visible = ws["is-current"] or ws["is-visible"]
    if visible then
        if ws["is-focused"] or ws["is-current"] then
            return colors.bg2, colors.accent, colors.accent
        end
        return colors.bg1, colors.fg1, colors.bg2
    end
    return colors.bg1, colors.grey, colors.bg1
end

local function create_cell(i)
    local label = sbar.add("item", "space." .. i .. ".label", {
        position = "left",
        icon = {
            string = tostring(i),
            padding_left = 8,
            padding_right = 4,
            color = colors.grey,
            highlight_color = colors.accent
        },
        label = {drawing = false},
        background = {drawing = false},
        padding_left = settings.group_paddings,
        padding_right = 0,
        drawing = false
    })
    label:subscribe("mouse.clicked", function()
        sbar.omniwm:focus_workspace(target[i])
    end)

    local icons = {}
    local members = {label.name}
    for j = 1, ICONS_PER_CELL do
        local icon = sbar.add("item", "space." .. i .. ".icon." .. j, {
            position = "left",
            icon = {drawing = false},
            label = {drawing = false},
            padding_left = 2,
            padding_right = 2,
            background = {
                drawing = true,
                color = colors.transparent,
                border_width = 0,
                image = {scale = 0.5, drawing = false}
            },
            drawing = false
        })
        icons[j] = icon
        table.insert(members, icon.name)
    end

    local bracket = sbar.add("bracket", "space." .. i .. ".bracket", members, {
        background = {
            color = colors.bg1,
            border_color = colors.bg1,
            border_width = 1,
            height = 26
        },
        drawing = false
    })

    cells[i] = {label = label, icons = icons, bracket = bracket}
end

local function hide_cell(cell)
    cell.label:set({drawing = false})
    for _, icon in ipairs(cell.icons) do icon:set({drawing = false}) end
    cell.bracket:set({drawing = false})
end

local function update_workspaces()
    local workspaces = sbar.omniwm:list_workspaces()
    local grouped = sbar.omniwm:windows_by_workspace()

    for i = 1, WORKSPACE_CELLS do
        local cell = cells[i]
        local ws = workspaces[i]
        if not ws then
            target[i] = nil
            hide_cell(cell)
        else
            target[i] = ws.id or ws.number
            local name = ws["display-name"]
            if name == nil or name == "" then
                name = tostring(ws.number or ws.id or i)
            end

            local bg_color, fg_color, border_color = state_colors(ws)
            local images = unique_app_images(windows_for(grouped, ws))

            cell.label:set({
                icon = {string = name, color = fg_color},
                drawing = true
            })
            for j = 1, ICONS_PER_CELL do
                local image = images[j]
                if image then
                    cell.icons[j]:set({
                        background = {image = {string = image, drawing = true}},
                        drawing = true
                    })
                else
                    cell.icons[j]:set({drawing = false})
                end
            end
            cell.bracket:set({
                background = {color = bg_color, border_color = border_color},
                drawing = true
            })
        end
    end
end

local function create_observer()
    local observer = sbar.add("item", {drawing = false, updates = true})
    observer:subscribe("omniwm_update", function() update_workspaces() end)
    observer:subscribe("front_app_switched", function() update_workspaces() end)
    observer:subscribe("system_woke", function() update_workspaces() end)
end

local function initialize()
    for i = 1, WORKSPACE_CELLS do create_cell(i) end
    update_workspaces()
    create_observer()
end

initialize()
