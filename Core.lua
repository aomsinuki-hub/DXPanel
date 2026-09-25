--========================================================
-- DXPanel CORE v2
-- Red / Black Neon UI
-- Fixed: Close / Open / Toggle / Drag / Resize
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DXPanel = {}
DXPanel.__index = DXPanel

--========================================================
-- CONFIG
--========================================================

local CONFIG = {
    Name = "DXPanel",

    Title = "DXPanel",

    Width = 560,
    Height = 420,

    MinWidth = 420,
    MinHeight = 300,

    Background = Color3.fromRGB(12, 12, 14),
    Panel = Color3.fromRGB(18, 18, 21),
    Secondary = Color3.fromRGB(25, 25, 29),

    Text = Color3.fromRGB(245, 245, 245),
    SubText = Color3.fromRGB(150, 150, 155),

    Accent = Color3.fromRGB(220, 35, 45),
    AccentDark = Color3.fromRGB(120, 15, 25),

    TweenTime = 0.18,
}

--========================================================
-- UTILS
--========================================================

local function tween(object, properties, time)
    if not object or not object.Parent then
        return
    end

    local info = TweenInfo.new(
        time or CONFIG.TweenTime,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    local t = TweenService:Create(
        object,
        info,
        properties
    )

    t:Play()

    return t
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")

    c.CornerRadius = UDim.new(
        0,
        radius or 8
    )

    c.Parent = parent

    return c
end

local function stroke(
    parent,
    color,
    transparency,
    thickness
)
    local s = Instance.new("UIStroke")

    s.Color =
        color or CONFIG.Accent

    s.Transparency =
        transparency or 0

    s.Thickness =
        thickness or 1

    s.Parent = parent

    return s
end

local function padding(
    parent,
    left,
    right,
    top,
    bottom
)
    local p = Instance.new("UIPadding")

    p.PaddingLeft =
        UDim.new(0, left or 0)

    p.PaddingRight =
        UDim.new(0, right or 0)

    p.PaddingTop =
        UDim.new(0, top or 0)

    p.PaddingBottom =
        UDim.new(0, bottom or 0)

    p.Parent = parent

    return p
end

--========================================================
-- CREATE WINDOW
--========================================================

function DXPanel:CreateWindow(options)

    options = options or {}

    local Window = {}

    Window.__index = Window

    setmetatable(
        Window,
        {
            __index = self
        }
    )

    Window.Title =
        options.Title
        or CONFIG.Title

    Window.Tabs = {}

    Window.CurrentTab = nil

    Window._Connections = {}

    Window._Destroyed = false

    --====================================================
    -- SIZE
    --====================================================

    local windowWidth =
        math.max(
            options.Width
            or CONFIG.Width,

            CONFIG.MinWidth
        )

    local windowHeight =
        math.max(
            options.Height
            or CONFIG.Height,

            CONFIG.MinHeight
        )

    --====================================================
    -- DESTROY OLD GUI
    --====================================================

    local old =
        PlayerGui:FindFirstChild(
            CONFIG.Name
        )

    if old then
        old:Destroy()
    end

    --====================================================
    -- SCREEN GUI
    --====================================================

    local ScreenGui =
        Instance.new("ScreenGui")

    ScreenGui.Name =
        CONFIG.Name

    ScreenGui.ResetOnSpawn =
        false

    ScreenGui.IgnoreGuiInset =
        true

    ScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    ScreenGui.DisplayOrder =
        999999

    ScreenGui.Parent =
        PlayerGui

    Window.ScreenGui =
        ScreenGui

    --====================================================
    -- MAIN
    --====================================================

    local Main =
        Instance.new("Frame")

    Main.Name =
        "Main"

    Main.Size =
        UDim2.fromOffset(
            windowWidth,
            windowHeight
        )

    Main.AnchorPoint =
        Vector2.new(0.5, 0.5)

    Main.Position =
        UDim2.new(
            0.5,
            0,
            0.5,
            0
        )

    Main.BackgroundColor3 =
        CONFIG.Background

    Main.BorderSizePixel =
        0

    Main.ClipsDescendants =
        true

    Main.Active =
        true

    Main.Parent =
        ScreenGui

    corner(Main, 12)

    stroke(
        Main,
        CONFIG.Accent,
        0.25,
        1
    )

    Window.Main =
        Main

    --====================================================
    -- TOP BAR
    --====================================================

    local Top =
        Instance.new("Frame")

    Top.Name =
        "TopBar"

    Top.Size =
        UDim2.new(
            1,
            0,
            0,
            48
        )

    Top.BackgroundColor3 =
        CONFIG.Panel

    Top.BorderSizePixel =
        0

    Top.Active =
        true

    Top.Parent =
        Main

    corner(Top, 12)

    -- Fix rounded bottom
    local TopFix =
        Instance.new("Frame")

    TopFix.Size =
        UDim2.new(
            1,
            0,
            0,
            12
        )

    TopFix.Position =
        UDim2.new(
            0,
            0,
            1,
            -12
        )

    TopFix.BackgroundColor3 =
        CONFIG.Panel

    TopFix.BorderSizePixel =
        0

    TopFix.Parent =
        Top

    --====================================================
    -- ACCENT LINE
    --====================================================

    local AccentLine =
        Instance.new("Frame")

    AccentLine.Size =
        UDim2.new(
            1,
            0,
            0,
            2
        )

    AccentLine.Position =
        UDim2.new(
            0,
            0,
            1,
            -2
        )

    AccentLine.BackgroundColor3 =
        CONFIG.Accent

    AccentLine.BorderSizePixel =
        0

    AccentLine.Parent =
        Top

    --====================================================
    -- TITLE
    --====================================================

    local Title =
        Instance.new("TextLabel")

    Title.BackgroundTransparency =
        1

    Title.Position =
        UDim2.fromOffset(
            16,
            0
        )

    Title.Size =
        UDim2.new(
            1,
            -120,
            1,
            0
        )

    Title.Font =
        Enum.Font.GothamBold

    Title.Text =
        Window.Title

    Title.TextColor3 =
        CONFIG.Text

    Title.TextSize =
        16

    Title.TextXAlignment =
        Enum.TextXAlignment.Left

    Title.Parent =
        Top

    Window.TitleLabel =
        Title

    --====================================================
    -- CLOSE BUTTON
    --====================================================

    local Close =
        Instance.new("TextButton")

    Close.Name =
        "Close"

    Close.Size =
        UDim2.fromOffset(
            34,
            34
        )

    Close.Position =
        UDim2.new(
            1,
            -42,
            0,
            7
        )

    Close.BackgroundColor3 =
        Color3.fromRGB(
            35,
            20,
            22
        )

    Close.Text =
        "×"

    Close.TextColor3 =
        CONFIG.Text

    Close.TextSize =
        22

    Close.Font =
        Enum.Font.GothamBold

    Close.AutoButtonColor =
        false

    Close.ZIndex =
        30

    Close.Parent =
        Top

    corner(Close, 8)

    Window.CloseButton =
        Close

    Close.MouseEnter:Connect(
        function()

            tween(
                Close,
                {
                    BackgroundColor3 =
                        CONFIG.Accent
                }
            )

        end
    )

    Close.MouseLeave:Connect(
        function()

            if Window.IsOpen then

                tween(
                    Close,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(
                                35,
                                20,
                                22
                            )
                    }
                )

            end

        end
    )

    --====================================================
    -- TAB BAR
    --====================================================

    local TabBar =
        Instance.new("ScrollingFrame")

    TabBar.Name =
        "TabBar"

    TabBar.Size =
        UDim2.new(
            0,
            130,
            1,
            -48
        )

    TabBar.Position =
        UDim2.new(
            0,
            0,
            0,
            48
        )

    TabBar.BackgroundColor3 =
        CONFIG.Panel

    TabBar.BorderSizePixel =
        0

    TabBar.ScrollBarThickness =
        2

    TabBar.ScrollBarImageColor3 =
        CONFIG.Accent

    TabBar.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            0
        )

    TabBar.Parent =
        Main

    padding(
        TabBar,
        8,
        8,
        10,
        10
    )

    local TabLayout =
        Instance.new("UIListLayout")

    TabLayout.Padding =
        UDim.new(0, 6)

    TabLayout.SortOrder =
        Enum.SortOrder.LayoutOrder

    TabLayout.Parent =
        TabBar

    TabLayout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(
        function()

            if not TabBar.Parent then
                return
            end

            TabBar.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    TabLayout
                        .AbsoluteContentSize.Y
                    + 20
                )

        end
    )

    Window.TabBar =
        TabBar

    --====================================================
    -- CONTENT
    --====================================================

    local Content =
        Instance.new("Frame")

    Content.Name =
        "Content"

    Content.Size =
        UDim2.new(
            1,
            -130,
            1,
            -48
        )

    Content.Position =
        UDim2.new(
            0,
            130,
            0,
            48
        )

    Content.BackgroundColor3 =
        CONFIG.Background

    Content.BorderSizePixel =
        0

    Content.Parent =
        Main

    Window.Content =
        Content

    --====================================================
    -- DRAG SYSTEM
    --====================================================

    local dragging =
        false

    local dragStart =
        nil

    local startPos =
        nil

    Top.InputBegan:Connect(
        function(input)

            -- ไม่ให้ปุ่ม Close เริ่ม Drag
            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or
                input.UserInputType ==
                Enum.UserInputType.Touch
            then

                local mousePos =
                    input.Position

                local closePos =
                    Close.AbsolutePosition

                local closeSize =
                    Close.AbsoluteSize

                local insideClose =
                    mousePos.X >= closePos.X
                    and
                    mousePos.X <=
                        closePos.X
                        + closeSize.X
                    and
                    mousePos.Y >= closePos.Y
                    and
                    mousePos.Y <=
                        closePos.Y
                        + closeSize.Y

                if insideClose then
                    return
                end

                dragging =
                    true

                dragStart =
                    input.Position

                startPos =
                    Main.Position

                local connection

                connection =
                    input.Changed:Connect(
                        function()

                            if input.UserInputState ==
                                Enum.UserInputState.End
                            then

                                dragging =
                                    false

                                if connection then
                                    connection:Disconnect()
                                end

                            end

                        end
                    )

            end

        end
    )

    local dragConnection =
        UserInputService.InputChanged:Connect(
            function(input)

                if not dragging then
                    return
                end

                if input.UserInputType ~=
                    Enum.UserInputType.MouseMovement
                    and
                    input.UserInputType ~=
                    Enum.UserInputType.Touch
                then
                    return
                end

                if not Main.Parent then
                    dragging = false
                    return
                end

                local delta =
                    input.Position
                    - dragStart

                Main.Position =
                    UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset
                            + delta.X,

                        startPos.Y.Scale,
                        startPos.Y.Offset
                            + delta.Y
                    )

            end
        )

    table.insert(
        Window._Connections,
        dragConnection
    )

    --====================================================
    -- RESIZE
    --====================================================

    local Resize =
        Instance.new("TextButton")

    Resize.Name =
        "Resize"

    Resize.Size =
        UDim2.fromOffset(
            30,
            30
        )

    Resize.Position =
        UDim2.new(
            1,
            -30,
            1,
            -30
        )

    Resize.BackgroundTransparency =
        1

    Resize.Text =
        "◢"

    Resize.TextColor3 =
        CONFIG.Accent

    Resize.TextSize =
        17

    Resize.Font =
        Enum.Font.GothamBold

    Resize.AutoButtonColor =
        false

    Resize.ZIndex =
        40

    Resize.Parent =
        Main

    Window.ResizeButton =
        Resize

    local resizing =
        false

    local resizeStart =
        nil

    local startSize =
        nil

    Resize.InputBegan:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or
                input.UserInputType ==
                Enum.UserInputType.Touch
            then

                resizing =
                    true

                resizeStart =
                    input.Position

                startSize =
                    Main.AbsoluteSize

                local connection

                connection =
                    input.Changed:Connect(
                        function()

                            if input.UserInputState ==
                                Enum.UserInputState.End
                            then

                                resizing =
                                    false

                                if connection then
                                    connection:Disconnect()
                                end

                            end

                        end
                    )

            end

        end
    )

    local resizeConnection =
        UserInputService.InputChanged:Connect(
            function(input)

                if not resizing then
                    return
                end

                if input.UserInputType ~=
                    Enum.UserInputType.MouseMovement
                    and
                    input.UserInputType ~=
                    Enum.UserInputType.Touch
                then
                    return
                end

                if not Main.Parent then
                    resizing = false
                    return
                end

                local delta =
                    input.Position
                    - resizeStart

                local width =
                    math.max(
                        CONFIG.MinWidth,
                        startSize.X
                            + delta.X
                    )

                local height =
                    math.max(
                        CONFIG.MinHeight,
                        startSize.Y
                            + delta.Y
                    )

                Main.Size =
                    UDim2.fromOffset(
                        width,
                        height
                    )

            end
        )

    table.insert(
        Window._Connections,
        resizeConnection
    )

    --====================================================
    -- OPEN BUTTON
    --====================================================

    local OpenButton =
        Instance.new("TextButton")

    OpenButton.Name =
        "OpenButton"

    OpenButton.Size =
        UDim2.fromOffset(
            52,
            52
        )

    OpenButton.Position =
        UDim2.new(
            0,
            18,
            0.5,
            -26
        )

    OpenButton.BackgroundColor3 =
        CONFIG.Panel

    OpenButton.Text =
        "DX"

    OpenButton.TextColor3 =
        CONFIG.Text

    OpenButton.TextSize =
        14

    OpenButton.Font =
        Enum.Font.GothamBold

    OpenButton.AutoButtonColor =
        false

    OpenButton.Visible =
        false

    OpenButton.ZIndex =
        100

    OpenButton.Parent =
        ScreenGui

    corner(
        OpenButton,
        12
    )

    stroke(
        OpenButton,
        CONFIG.Accent,
        0.15,
        1
    )

    Window.OpenButton =
        OpenButton

    OpenButton.MouseEnter:Connect(
        function()

            tween(
                OpenButton,
                {
                    BackgroundColor3 =
                        Color3.fromRGB(
                            40,
                            20,
                            24
                        )
                }
            )

        end
    )

    OpenButton.MouseLeave:Connect(
        function()

            tween(
                OpenButton,
                {
                    BackgroundColor3 =
                        CONFIG.Panel
                }
            )

        end
    )

    --====================================================
    -- WINDOW METHODS
    --====================================================

    function Window:Open()

        if self._Destroyed then
            return
        end

        Main.Visible =
            true

        OpenButton.Visible =
            false

        self.IsOpen =
            true

    end

    function Window:Close()

        if self._Destroyed then
            return
        end

        Main.Visible =
            false

        OpenButton.Visible =
            true

        self.IsOpen =
            false

    end

    function Window:Toggle()

        if self._Destroyed then
            return
        end

        if self.IsOpen then
            self:Close()
        else
            self:Open()
        end

    end

    function Window:Destroy()

        if self._Destroyed then
            return
        end

        self._Destroyed =
            true

        for _, connection in
            ipairs(self._Connections)
        do

            pcall(function()
                connection:Disconnect()
            end)

        end

        table.clear(
            self._Connections
        )

        if ScreenGui then
            ScreenGui:Destroy()
        end

    end

    --====================================================
    -- BUTTON EVENTS
    --====================================================

    Close.MouseButton1Click:Connect(
        function()

            Window:Close()

        end
    )

    OpenButton.MouseButton1Click:Connect(
        function()

            Window:Open()

        end
    )

    Window.IsOpen =
        true

    return Window
end

--========================================================
-- ADD TAB
--========================================================

function DXPanel:AddTab(
    Window,
    options
)

    options =
        options or {}

    local Tab = {}

    Tab.__index =
        Tab

    Tab.Title =
        options.Title
        or "Tab"

    Tab.Icon =
        options.Icon
        or ""

    --====================================================
    -- PAGE
    --====================================================

    Tab.Page =
        Instance.new(
            "ScrollingFrame"
        )

    Tab.Page.Name =
        "Page_" .. Tab.Title

    Tab.Page.Size =
        UDim2.new(
            1,
            0,
            1,
            0
        )

    Tab.Page.BackgroundTransparency =
        1

    Tab.Page.BorderSizePixel =
        0

    Tab.Page.ScrollBarThickness =
        3

    Tab.Page.ScrollBarImageColor3 =
        CONFIG.Accent

    Tab.Page.Visible =
        false

    Tab.Page.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            0
        )

    Tab.Page.Parent =
        Window.Content

    padding(
        Tab.Page,
        12,
        12,
        12,
        12
    )

    local Layout =
        Instance.new("UIListLayout")

    Layout.Padding =
        UDim.new(0, 8)

    Layout.SortOrder =
        Enum.SortOrder.LayoutOrder

    Layout.Parent =
        Tab.Page

    Layout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(
        function()

            if not Tab.Page.Parent then
                return
            end

            Tab.Page.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    Layout.AbsoluteContentSize.Y
                    + 24
                )

        end
    )

    --====================================================
    -- TAB BUTTON
    --====================================================

    local Button =
        Instance.new("TextButton")

    Button.Name =
        "Tab_" .. Tab.Title

    Button.Size =
        UDim2.new(
            1,
            0,
            0,
            38
        )

    Button.BackgroundColor3 =
        CONFIG.Secondary

    Button.Text =
        (
            Tab.Icon ~= ""
            and Tab.Icon .. "  "
            or ""
        )
        .. Tab.Title

    Button.TextColor3 =
        CONFIG.SubText

    Button.TextSize =
        13

    Button.Font =
        Enum.Font.GothamSemibold

    Button.AutoButtonColor =
        false

    Button.Parent =
        Window.TabBar

    corner(
        Button,
        8
    )

    Tab.Button =
        Button

    Button.MouseEnter:Connect(
        function()

            if Window.CurrentTab ~= Tab then

                tween(
                    Button,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(
                                35,
                                22,
                                25
                            )
                    }
                )

            end

        end
    )

    Button.MouseLeave:Connect(
        function()

            if Window.CurrentTab ~= Tab then

                tween(
                    Button,
                    {
                        BackgroundColor3 =
                            CONFIG.Secondary
                    }
                )

            end

        end
    )

    Button.MouseButton1Click:Connect(
        function()

            Window:SelectTab(
                Tab
            )

        end
    )

    Window.Tabs[
        #Window.Tabs + 1
    ] = Tab

    function Tab:Select()

        Window:SelectTab(
            self
        )

    end

    --====================================================
    -- SECTION
    --====================================================

    function Tab:Section(options)

        options =
            options or {}

        local Section =
            Instance.new(
                "TextLabel"
            )

        Section.Size =
            UDim2.new(
                1,
                0,
                0,
                28
            )

        Section.BackgroundTransparency =
            1

        Section.Text =
            options.Title
            or "Section"

        Section.TextColor3 =
            CONFIG.Accent

        Section.TextSize =
            12

        Section.Font =
            Enum.Font.GothamBold

        Section.TextXAlignment =
            Enum.TextXAlignment.Left

        Section.Parent =
            self.Page

        return Section
    end

    --====================================================
    -- BUTTON
    --====================================================

    function Tab:Button(options)

        options =
            options or {}

        local ButtonFrame =
            Instance.new(
                "TextButton"
            )

        ButtonFrame.Size =
            UDim2.new(
                1,
                0,
                0,
                42
            )

        ButtonFrame.BackgroundColor3 =
            CONFIG.Panel

        ButtonFrame.Text =
            options.Title
            or "Button"

        ButtonFrame.TextColor3 =
            CONFIG.Text

        ButtonFrame.TextSize =
            13

        ButtonFrame.Font =
            Enum.Font.GothamSemibold

        ButtonFrame.AutoButtonColor =
            false

        ButtonFrame.Parent =
            self.Page

        corner(
            ButtonFrame,
            8
        )

        stroke(
            ButtonFrame,
            CONFIG.Accent,
            0.8,
            1
        )

        ButtonFrame.MouseEnter:Connect(
            function()

                tween(
                    ButtonFrame,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(
                                35,
                                20,
                                22
                            )
                    }
                )

            end
        )

        ButtonFrame.MouseLeave:Connect(
            function()

                tween(
                    ButtonFrame,
                    {
                        BackgroundColor3 =
                            CONFIG.Panel
                    }
                )

            end
        )

        ButtonFrame.MouseButton1Click:Connect(
            function()

                if typeof(
                    options.Callback
                ) == "function" then

                    task.spawn(
                        options.Callback
                    )

                end

            end
        )

        return ButtonFrame
    end

    --====================================================
    -- TOGGLE
    --====================================================

    function Tab:Toggle(options)

        options =
            options or {}

        local state =
            options.Default == true

        local ButtonFrame =
            Instance.new(
                "TextButton"
            )

        ButtonFrame.Size =
            UDim2.new(
                1,
                0,
                0,
                42
            )

        ButtonFrame.BackgroundColor3 =
            CONFIG.Panel

        ButtonFrame.Text =
            ""

        ButtonFrame.AutoButtonColor =
            false

        ButtonFrame.Parent =
            self.Page

        corner(
            ButtonFrame,
            8
        )

        local Label =
            Instance.new(
                "TextLabel"
            )

        Label.BackgroundTransparency =
            1

        Label.Position =
            UDim2.fromOffset(
                12,
                0
            )

        Label.Size =
            UDim2.new(
                1,
                -70,
                1,
                0
            )

        Label.Text =
            options.Title
            or "Toggle"

        Label.TextColor3 =
            CONFIG.Text

        Label.TextSize =
            13

        Label.Font =
            Enum.Font.GothamSemibold

        Label.TextXAlignment =
            Enum.TextXAlignment.Left

        Label.Parent =
            ButtonFrame

        local Indicator =
            Instance.new("Frame")

        Indicator.Size =
            UDim2.fromOffset(
                38,
                20
            )

        Indicator.Position =
            UDim2.new(
                1,
                -50,
                0.5,
                -10
            )

        Indicator.BackgroundColor3 =
            Color3.fromRGB(
                45,
                45,
                48
            )

        Indicator.Parent =
            ButtonFrame

        corner(
            Indicator,
            10
        )

        local Dot =
            Instance.new("Frame")

        Dot.Size =
            UDim2.fromOffset(
                14,
                14
            )

        Dot.Position =
            UDim2.fromOffset(
                3,
                3
            )

        Dot.BackgroundColor3 =
            Color3.fromRGB(
                180,
                180,
                180
            )

        Dot.Parent =
            Indicator

        corner(
            Dot,
            7
        )

        local function update()

            if state then

                tween(
                    Indicator,
                    {
                        BackgroundColor3 =
                            CONFIG.Accent
                    }
                )

                tween(
                    Dot,
                    {
                        Position =
                            UDim2.new(
                                1,
                                -17,
                                0,
                                3
                            ),

                        BackgroundColor3 =
                            Color3.fromRGB(
                                255,
                                255,
                                255
                            )
                    }
                )

            else

                tween(
                    Indicator,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(
                                45,
                                45,
                                48
                            )
                    }
                )

                tween(
                    Dot,
                    {
                        Position =
                            UDim2.fromOffset(
                                3,
                                3
                            ),

                        BackgroundColor3 =
                            Color3.fromRGB(
                                180,
                                180,
                                180
                            )
                    }
                )

            end

        end

        ButtonFrame.MouseButton1Click:Connect(
            function()

                state =
                    not state

                update()

                if typeof(
                    options.Callback
                ) == "function" then

                    task.spawn(
                        options.Callback,
                        state
                    )

                end

            end
        )

        update()

        return {

            Set = function(_, value)

                state =
                    value == true

                update()

                if typeof(
                    options.Callback
                ) == "function" then

                    task.spawn(
                        options.Callback,
                        state
                    )

                end

            end,

            Get = function()

                return state

            end,

        }
    end

    --====================================================
    -- LABEL
    --====================================================

    function Tab:Label(text)

        local Label =
            Instance.new(
                "TextLabel"
            )

        Label.Size =
            UDim2.new(
                1,
                0,
                0,
                30
            )

        Label.BackgroundTransparency =
            1

        Label.Text =
            tostring(
                text or ""
            )

        Label.TextColor3 =
            CONFIG.SubText

        Label.TextSize =
            12

        Label.Font =
            Enum.Font.Gotham

        Label.TextXAlignment =
            Enum.TextXAlignment.Left

        Label.Parent =
            self.Page

        return Label
    end

    return Tab
end

--========================================================
-- SELECT TAB
--========================================================

function DXPanel:SelectTab(
    Window,
    Tab
)

    if not Window
        or not Tab
    then
        return
    end

    for _, item in ipairs(
        Window.Tabs
    ) do

        item.Page.Visible =
            false

        tween(
            item.Button,
            {
                BackgroundColor3 =
                    CONFIG.Secondary,

                TextColor3 =
                    CONFIG.SubText
            }
        )

    end

    Tab.Page.Visible =
        true

    tween(
        Tab.Button,
        {
            BackgroundColor3 =
                Color3.fromRGB(
                    55,
                    18,
                    22
                ),

            TextColor3 =
                CONFIG.Text
        }
    )

    Window.CurrentTab =
        Tab
end

--========================================================
-- WINDOW METHODS
--========================================================

function DXPanel:AttachWindowMethods(
    Window
)

    function Window:Tab(options)

        return DXPanel:AddTab(
            self,
            options
        )

    end

    function Window:SelectTab(tab)

        return DXPanel:SelectTab(
            self,
            tab
        )

    end

    return Window
end

--========================================================
-- RETURN
--========================================================

return DXPanel
