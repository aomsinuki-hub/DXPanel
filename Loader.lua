--========================================================
-- DXPanel Loader
--========================================================

local BASE_URL =
    "https://raw.githubusercontent.com/aomsinuki-hub/DXPanel/main/"

--========================================================
-- SAFE LOAD
--========================================================

local function Load(path)
    local url = BASE_URL .. path

    local success, result = pcall(function()
        local source = game:HttpGet(url)

        if not source or source == "" then
            error("Empty response")
        end

        local fn, compileError = loadstring(source)

        if not fn then
            error(compileError or "loadstring failed")
        end

        return fn()
    end)

    if not success then
        warn("[DXPanel] Failed to load:", path)
        warn("[DXPanel] Error:", result)
        return nil
    end

    return result
end

--========================================================
-- LOAD CORE
--========================================================

local DXPanel = Load("Core.lua")

if not DXPanel then
    error("[DXPanel] Core.lua failed to load")
end

--========================================================
-- CREATE WINDOW
--========================================================

local Window = DXPanel:CreateWindow({
    Title = "DXPanel",

    Width = 560,
    Height = 420,
})

if not Window then
    error("[DXPanel] Failed to create Window")
end

-- สำคัญ:
-- ต้อง Attach ก่อนโหลด Tab
DXPanel:AttachWindowMethods(Window)

--========================================================
-- LOAD MANIFEST
--========================================================

local Manifest = Load("Tabs/Manifest.lua")

if type(Manifest) ~= "table" then
    error("[DXPanel] Manifest.lua must return a table")
end

--========================================================
-- LOAD TABS
--========================================================

local loadedTabs = 0

for index, Info in ipairs(Manifest) do

    if type(Info) ~= "table" then
        warn(
            "[DXPanel] Invalid manifest entry:",
            index
        )

        continue
    end

    if Info.Enabled == false then
        continue
    end

    if not Info.Name then
        warn(
            "[DXPanel] Tab has no Name:",
            index
        )

        continue
    end

    local path =
        "Tabs/" ..
        tostring(Info.Name) ..
        ".lua"

    local TabFunction = Load(path)

    if type(TabFunction) ~= "function" then

        warn(
            "[DXPanel] Invalid Tab module:",
            path
        )

        continue
    end

    local success, err = pcall(function()
        TabFunction(Window, Info)
    end)

    if success then
        loadedTabs += 1

        print(
            "[DXPanel] Loaded Tab:",
            Info.Name
        )
    else
        warn(
            "[DXPanel] Tab error:",
            Info.Name
        )

        warn(err)
    end
end

--========================================================
-- SELECT FIRST TAB
--========================================================

if #Window.Tabs > 0 then

    Window:SelectTab(
        Window.Tabs[1]
    )

else

    warn("[DXPanel] No enabled tabs loaded")

end

print(
    "[DXPanel] Loaded successfully | Tabs:",
    loadedTabs
)

return Window
