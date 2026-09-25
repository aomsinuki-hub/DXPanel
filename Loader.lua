--========================================================
-- DXPanel Loader
--========================================================

local BASE_URL =
    "https://raw.githubusercontent.com/aomsinuki-hub/DXPanel/main/"

local function Load(path)

    local url = BASE_URL .. path

    local success, result = pcall(function()

        return loadstring(
            game:HttpGet(url)
        )()

    end)

    if not success then

        warn("[DXPanel] Failed to load:", path)
        warn(result)

        return nil
    end

    return result
end

--========================================================
-- CORE
--========================================================

local DXPanel = Load("Core.lua")

if not DXPanel then
    error("[DXPanel] Core.lua failed to load")
end

--========================================================
-- WINDOW
--========================================================

local Window = DXPanel:CreateWindow({
    Title = "DXPanel",
    Width = 560,
    Height = 420,
})

DXPanel:AttachWindowMethods(Window)

--========================================================
-- MANIFEST
--========================================================

local Manifest = Load("Tabs/Manifest.lua")

if not Manifest then
    error("[DXPanel] Manifest.lua failed to load")
end

--========================================================
-- LOAD TABS
--========================================================

for _, Info in ipairs(Manifest) do

    if Info.Enabled ~= false then

        local path =
            "Tabs/" .. tostring(Info.Name) .. ".lua"

        local TabFunction = Load(path)

        if TabFunction then

            local success, err = pcall(function()

                TabFunction(Window, Info)

            end)

            if not success then

                warn(
                    "[DXPanel] Tab error:",
                    Info.Name,
                    err
                )

            end

        end

    end

end

--========================================================
-- SELECT FIRST TAB
--========================================================

if #Window.Tabs > 0 then

    Window:SelectTab(
        Window.Tabs[1]
    )

end

print("[DXPanel] Loaded successfully")
