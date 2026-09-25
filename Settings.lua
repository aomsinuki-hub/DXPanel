--========================================================
-- DXPanel - Settings Tab
--========================================================

return function(Window, Info)

    local Tab = Window:Tab({

        Title = Info.Title or "Settings",

        Icon = Info.Icon or "⚙",

    })

    --====================================================
    -- UI SETTINGS
    --====================================================

    Tab:Section({
        Title = "UI SETTINGS",
    })

    Tab:Toggle({

        Title = "Example Setting",

        Default = true,

        Callback = function(enabled)

            print(
                "[DXPanel] Setting:",
                enabled
            )

        end,

    })

    --====================================================
    -- WINDOW
    --====================================================

    Tab:Section({
        Title = "WINDOW",
    })

    Tab:Button({

        Title = "Hide DXPanel",

        Callback = function()

            Window:Close()

        end,

    })

    Tab:Button({

        Title = "Show DXPanel",

        Callback = function()

            Window:Open()

        end,

    })

    Tab:Button({

        Title = "Toggle DXPanel",

        Callback = function()

            Window:Toggle()

        end,

    })

end
