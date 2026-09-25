--========================================================
-- DXPanel - Player Tab
--========================================================

local Players =
    game:GetService("Players")

local LocalPlayer =
    Players.LocalPlayer

return function(Window, Info)

    local Tab = Window:Tab({

        Title =
            Info.Title
            or "Player",

        Icon =
            Info.Icon
            or "●",

    })

    --====================================================
    -- PLAYER
    --====================================================

    Tab:Section({
        Title = "PLAYER",
    })

    Tab:Label(
        "Player: "
        .. LocalPlayer.Name
    )

    Tab:Label(
        "UserId: "
        .. tostring(LocalPlayer.UserId)
    )

    --====================================================
    -- TEST BUTTON
    --====================================================

    Tab:Button({

        Title = "Print Player Info",

        Callback = function()

            print(
                "[DXPanel] Player:",
                LocalPlayer.Name
            )

            print(
                "[DXPanel] UserId:",
                LocalPlayer.UserId
            )

        end,

    })

    --====================================================
    -- EXAMPLE TOGGLE
    --====================================================

    Tab:Toggle({

        Title = "Player Example",

        Default = false,

        Callback = function(value)

            print(
                "[DXPanel] Player Toggle:",
                value
            )

        end,

    })

end
