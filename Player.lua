--========================================================
-- DXPanel - Player Tab
--========================================================

return function(Window, Info)

    local Tab = Window:Tab({

        Title = Info.Title or "Player",

        Icon = Info.Icon or "●",

    })

    --====================================================
    -- PLAYER
    --====================================================

    Tab:Section({
        Title = "PLAYER",
    })

    Tab:Label(
        "Player: " .. game.Players.LocalPlayer.Name
    )

    --====================================================
    -- EXAMPLE
    --====================================================

    Tab:Button({

        Title = "Print Player Name",

        Callback = function()

            print(
                "[DXPanel] Player:",
                game.Players.LocalPlayer.Name
            )

        end,

    })

    Tab:Toggle({

        Title = "Example Feature",

        Default = false,

        Callback = function(enabled)

            print(
                "[DXPanel] Example Feature:",
                enabled
            )

        end,

    })

end
