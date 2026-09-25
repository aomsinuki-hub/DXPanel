--========================================================
-- DXPanel - Settings Tab
--========================================================

return function(Window, Info)

    local Tab = Window:Tab({

        Title =
            Info.Title
            or "Settings",

        Icon =
            Info.Icon
            or "⚙",

    })

    --====================================================
    -- SETTINGS
    --====================================================

    Tab:Section({
        Title = "SETTINGS",
    })

    Tab:Label(
        "DXPanel Settings"
    )

    --====================================================
    -- EXAMPLE TOGGLE
    --====================================================

    Tab:Toggle({

        Title = "Example Setting",

        Default = true,

        Callback = function(value)

            print(
                "[DXPanel] Setting:",
                value
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

        Title = "Close DXPanel",

        Callback = function()

            Window:Close()

        end,

    })

    Tab:Button({

        Title = "Open DXPanel",

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
