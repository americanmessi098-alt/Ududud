--// MOBILE AUTO CLICKER
--// Mobile-friendly position picker, draggable GUI, and adjustable click speed.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// SETTINGS
local CLICK_DELAY = 0.01 -- seconds between clicks
local MAX_SPEED = false
local clicking = false
local selectingPosition = false
local clickPosition = nil

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MobileAutoClicker"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(285, 245)
Main.Position = UDim2.new(0.5, -142, 0.5, -117)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(90, 90, 110)
Stroke.Thickness = 1
Stroke.Parent = Main

--// Header / drag area
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundTransparency = 1
Header.Active = true
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(15, 7)
Title.Size = UDim2.new(1, -30, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "MOBILE AUTO CLICKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(15, 29)
Subtitle.Size = UDim2.new(1, -30, 0, 15)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Drag the header to move"
Subtitle.TextColor3 = Color3.fromRGB(125, 125, 140)
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(15, 51)
Status.Size = UDim2.new(1, -30, 0, 22)
Status.Font = Enum.Font.Gotham
Status.Text = "Position: NOT SET"
Status.TextColor3 = Color3.fromRGB(170, 170, 180)
Status.TextSize = 12
Status.Parent = Main

--// Position button
local SetPosition = Instance.new("TextButton")
SetPosition.Position = UDim2.fromOffset(15, 77)
SetPosition.Size = UDim2.new(1, -30, 0, 38)
SetPosition.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
SetPosition.BorderSizePixel = 0
SetPosition.Font = Enum.Font.GothamBold
SetPosition.Text = "SET CLICK POSITION"
SetPosition.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPosition.TextSize = 13
SetPosition.AutoButtonColor = false
SetPosition.Parent = Main

local SetCorner = Instance.new("UICorner")
SetCorner.CornerRadius = UDim.new(0, 9)
SetCorner.Parent = SetPosition

--// Speed label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.fromOffset(15, 120)
SpeedLabel.Size = UDim2.new(1, -30, 0, 20)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "CLICK SPEED"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Main

--// Speed textbox
local SpeedBox = Instance.new("TextBox")
SpeedBox.Position = UDim2.fromOffset(15, 143)
SpeedBox.Size = UDim2.new(1, -30, 0, 32)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedBox.BorderSizePixel = 0
SpeedBox.ClearTextOnFocus = false
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.PlaceholderText = "Clicks per second (example: 20)"
SpeedBox.Text = "100"
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
SpeedBox.TextSize = 12
SpeedBox.Parent = Main

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedBox

local MaxSpeed = Instance.new("TextButton")
MaxSpeed.Position = UDim2.fromOffset(15, 175)
MaxSpeed.Size = UDim2.new(0.5, -20, 0, 24)
MaxSpeed.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
MaxSpeed.BorderSizePixel = 0
MaxSpeed.Font = Enum.Font.GothamBold
MaxSpeed.Text = "MAX SPEED: OFF"
MaxSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxSpeed.TextSize = 10
MaxSpeed.AutoButtonColor = false
MaxSpeed.Parent = Main

local MaxCorner = Instance.new("UICorner")
MaxCorner.CornerRadius = UDim.new(0, 7)
MaxCorner.Parent = MaxSpeed

local SpeedInfo = Instance.new("TextLabel")
SpeedInfo.BackgroundTransparency = 1
SpeedInfo.Position = UDim2.new(0.5, 5, 0, 175)
SpeedInfo.Size = UDim2.new(0.5, -20, 0, 24)
SpeedInfo.Font = Enum.Font.Gotham
SpeedInfo.Text = "100 CPS  •  0.010 sec delay"
SpeedInfo.TextColor3 = Color3.fromRGB(130, 130, 145)
SpeedInfo.TextSize = 10
SpeedInfo.TextXAlignment = Enum.TextXAlignment.Left
SpeedInfo.Parent = Main

--// Start / Stop
local Start = Instance.new("TextButton")
Start.Position = UDim2.fromOffset(15, 205)
Start.Size = UDim2.new(0.5, -20, 0, 32)
Start.BackgroundColor3 = Color3.fromRGB(35, 120, 65)
Start.BorderSizePixel = 0
Start.Font = Enum.Font.GothamBold
Start.Text = "START"
Start.TextColor3 = Color3.fromRGB(255, 255, 255)
Start.TextSize = 12
Start.AutoButtonColor = false
Start.Parent = Main

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 8)
StartCorner.Parent = Start

local Stop = Instance.new("TextButton")
Stop.Position = UDim2.new(0.5, 5, 0, 205)
Stop.Size = UDim2.new(0.5, -20, 0, 32)
Stop.BackgroundColor3 = Color3.fromRGB(130, 45, 45)
Stop.BorderSizePixel = 0
Stop.Font = Enum.Font.GothamBold
Stop.Text = "STOP"
Stop.TextColor3 = Color3.fromRGB(255, 255, 255)
Stop.TextSize = 12
Stop.AutoButtonColor = false
Stop.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 8)
StopCorner.Parent = Stop

--// Position marker
local Marker = Instance.new("Frame")
Marker.Name = "ClickPositionMarker"
Marker.Size = UDim2.fromOffset(22, 22)
Marker.AnchorPoint = Vector2.new(0.5, 0.5)
Marker.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Marker.BorderSizePixel = 0
Marker.Visible = false
Marker.Active = false
Marker.ZIndex = 1000
Marker.Parent = Gui

local MarkerCorner = Instance.new("UICorner")
MarkerCorner.CornerRadius = UDim.new(1, 0)
MarkerCorner.Parent = Marker

local MarkerStroke = Instance.new("UIStroke")
MarkerStroke.Thickness = 2
MarkerStroke.Color = Color3.fromRGB(255, 255, 255)
MarkerStroke.Parent = Marker

--// Dragging (touch + mouse)
local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

--// Position picker
-- Touch coordinates are converted to GuiInset-free screen coordinates.
-- This avoids the common "clicks higher than selected" offset.
SetPosition.Activated:Connect(function()
    if clicking then
        return
    end

    selectingPosition = true
    SetPosition.Text = "TAP THE TARGET LOCATION"
    SetPosition.BackgroundColor3 = Color3.fromRGB(100, 75, 35)
    Status.Text = "Tap the exact spot you want clicked"
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not selectingPosition then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    -- Don't use a tap on our own GUI as the target.
    if processed then
        return
    end

    selectingPosition = false

    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(0, 0)

    local x = math.clamp(input.Position.X, 0, viewport.X)
    local y = math.clamp(input.Position.Y, 0, viewport.Y)

    clickPosition = Vector2.new(x, y)

    Marker.Position = UDim2.fromOffset(x, y)
    Marker.Visible = true

    SetPosition.Text = "POSITION SET"
    SetPosition.BackgroundColor3 = Color3.fromRGB(45, 100, 70)

    Status.Text = string.format(
        "Position: %d, %d",
        math.floor(x),
        math.floor(y)
    )
end)

--// Speed
local function updateSpeed()
    local cps = tonumber(SpeedBox.Text)

    if not cps then
        SpeedInfo.Text = "Enter a number"
        return
    end

    cps = math.clamp(cps, 1, 5000)
    CLICK_DELAY = 1 / cps

    SpeedBox.Text = tostring(math.floor(cps))
    SpeedInfo.Text = string.format(
        "%d CPS • %.5f delay",
        math.floor(cps),
        CLICK_DELAY
    )
end

MaxSpeed.Activated:Connect(function()
    MAX_SPEED = not MAX_SPEED

    if MAX_SPEED then
        MaxSpeed.Text = "MAX SPEED: ON"
        MaxSpeed.BackgroundColor3 = Color3.fromRGB(130, 75, 35)
        SpeedInfo.Text = "No intentional delay"
    else
        MaxSpeed.Text = "MAX SPEED: OFF"
        MaxSpeed.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
        updateSpeed()
    end
end)

SpeedBox.FocusLost:Connect(function()
    updateSpeed()
end)

--// Start
Start.Activated:Connect(function()
    if clicking then
        return
    end

    if not clickPosition then
        Status.Text = "Set a click position first!"
        return
    end

    if not MAX_SPEED then
        updateSpeed()
    end

    if not clickPosition then
        return
    end

    clicking = true
    Start.Text = "RUNNING"

    if MAX_SPEED then
        Status.Text = "AUTO CLICKER: MAX SPEED"
    else
        Status.Text = string.format(
            "AUTO CLICKER: ON • %d CPS",
            math.floor(1 / CLICK_DELAY)
        )
    end

    task.spawn(function()
        while clicking and clickPosition do
            local ok = pcall(function()
                VirtualInputManager:SendMouseButtonEvent(
                    clickPosition.X,
                    clickPosition.Y,
                    0,
                    true,
                    game,
                    0
                )

                VirtualInputManager:SendMouseButtonEvent(
                    clickPosition.X,
                    clickPosition.Y,
                    0,
                    false,
                    game,
                    0
                )
            end)

            if not ok then
                clicking = false
                Start.Text = "START"
                Status.Text = "VirtualInputManager unavailable"
                break
            end

            if MAX_SPEED then
                task.wait()
            else
                task.wait(CLICK_DELAY)
            end
        end
    end)
end)

--// Stop
Stop.Activated:Connect(function()
    clicking = false
    Start.Text = "START"

    if clickPosition then
        Status.Text = string.format(
            "Position: %d, %d",
            math.floor(clickPosition.X),
            math.floor(clickPosition.Y)
        )
    else
        Status.Text = "Position: NOT SET"
    end
end)

Gui.Destroying:Connect(function()
    clicking = false
    selectingPosition = false
end)
