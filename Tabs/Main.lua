--========================================================
-- DXPanel - Main Tab
--========================================================

return function(Window, Info)

    local Tab = Window:Tab({
        Title = Info.Title or "Main",
        Icon = Info.Icon or "◆",
    })

    --====================================================
    -- SECTION
    --====================================================

    Tab:Section({
        Title = "MAIN",
    })

    Tab:Label(
        "Welcome to DXPanel"
    )

    --====================================================
    -- BUTTON
    --====================================================

    Tab:Button({

        Title = "Test Button",

        Callback = function()

            print("[DXPanel] Test Button clicked")

        end,

    })

    --====================================================
    -- TOGGLE
    --====================================================

    Tab:Toggle({

        Title = "Example Toggle",

        Default = false,

        Callback = function(value)

            print(
                "[DXPanel] Toggle:",
                value
            )

        end,

    })

end
