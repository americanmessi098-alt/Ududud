--// MOBILE AUTO CLICKER
--// Tap SET CLICK POSITION, then tap anywhere on the screen.
--// The selected position becomes the auto-click location.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CLICK_DELAY = 0.01
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
Main.Parent = Gui
Main.Size = UDim2.fromOffset(270, 190)
Main.Position = UDim2.new(0.5, -135, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(90, 90, 110)
Stroke.Thickness = 1
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(15, 10)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "MOBILE AUTO CLICKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17

local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(15, 42)
Status.Size = UDim2.new(1, -30, 0, 25)
Status.Font = Enum.Font.Gotham
Status.Text = "Position: NOT SET"
Status.TextColor3 = Color3.fromRGB(170, 170, 180)
Status.TextSize = 13

local SetPosition = Instance.new("TextButton")
SetPosition.Parent = Main
SetPosition.Position = UDim2.fromOffset(15, 75)
SetPosition.Size = UDim2.new(1, -30, 0, 42)
SetPosition.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
SetPosition.BorderSizePixel = 0
SetPosition.Font = Enum.Font.GothamBold
SetPosition.Text = "SET CLICK POSITION"
SetPosition.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPosition.TextSize = 14
SetPosition.AutoButtonColor = false

local SetCorner = Instance.new("UICorner")
SetCorner.CornerRadius = UDim.new(0, 10)
SetCorner.Parent = SetPosition

local Start = Instance.new("TextButton")
Start.Parent = Main
Start.Position = UDim2.fromOffset(15, 125)
Start.Size = UDim2.new(0.48, -10, 0, 42)
Start.BackgroundColor3 = Color3.fromRGB(35, 120, 65)
Start.BorderSizePixel = 0
Start.Font = Enum.Font.GothamBold
Start.Text = "START"
Start.TextColor3 = Color3.fromRGB(255, 255, 255)
Start.TextSize = 14
Start.AutoButtonColor = false

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 10)
StartCorner.Parent = Start

local Stop = Instance.new("TextButton")
Stop.Parent = Main
Stop.Position = UDim2.new(0.52, 0, 0, 125)
Stop.Size = UDim2.new(0.48, -15, 0, 42)
Stop.BackgroundColor3 = Color3.fromRGB(130, 45, 45)
Stop.BorderSizePixel = 0
Stop.Font = Enum.Font.GothamBold
Stop.Text = "STOP"
Stop.TextColor3 = Color3.fromRGB(255, 255, 255)
Stop.TextSize = 14
Stop.AutoButtonColor = false

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 10)
StopCorner.Parent = Stop

--// Position marker
local Marker = Instance.new("Frame")
Marker.Name = "ClickPositionMarker"
Marker.Size = UDim2.fromOffset(22, 22)
Marker.AnchorPoint = Vector2.new(0.5, 0.5)
Marker.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
Marker.BorderSizePixel = 0
Marker.Visible = false
Marker.ZIndex = 1000
Marker.Parent = Gui

local MarkerCorner = Instance.new("UICorner")
MarkerCorner.CornerRadius = UDim.new(1, 0)
MarkerCorner.Parent = Marker

local MarkerStroke = Instance.new("UIStroke")
MarkerStroke.Thickness = 2
MarkerStroke.Color = Color3.fromRGB(255, 255, 255)
MarkerStroke.Parent = Marker

--// Select position
SetPosition.Activated:Connect(function()
    if clicking then
        return
    end

    selectingPosition = true
    SetPosition.Text = "TAP THE LOCATION..."
    SetPosition.BackgroundColor3 = Color3.fromRGB(100, 75, 35)
    Status.Text = "Tap anywhere to set the position"
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not selectingPosition then
        return
    end

    if input.UserInputType == Enum.UserInputType.Touch then
        selectingPosition = false

        local pos = input.Position
        clickPosition = Vector2.new(pos.X, pos.Y)

        Marker.Position = UDim2.fromOffset(clickPosition.X, clickPosition.Y)
        Marker.Visible = true

        SetPosition.Text = "POSITION SET"
        SetPosition.BackgroundColor3 = Color3.fromRGB(45, 100, 70)
        Status.Text = string.format(
            "Position: %d, %d",
            math.floor(clickPosition.X),
            math.floor(clickPosition.Y)
        )

    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        selectingPosition = false

        local pos = input.Position
        clickPosition = Vector2.new(pos.X, pos.Y)

        Marker.Position = UDim2.fromOffset(clickPosition.X, clickPosition.Y)
        Marker.Visible = true

        SetPosition.Text = "POSITION SET"
        SetPosition.BackgroundColor3 = Color3.fromRGB(45, 100, 70)
        Status.Text = string.format(
            "Position: %d, %d",
            math.floor(clickPosition.X),
            math.floor(clickPosition.Y)
        )
    end
end)

--// Start clicking
Start.Activated:Connect(function()
    if clicking then
        return
    end

    if not clickPosition then
        Status.Text = "Set a click position first!"
        return
    end

    clicking = true
    Status.Text = "AUTO CLICKER: ON"
    Start.Text = "RUNNING"

    task.spawn(function()
        while clicking and clickPosition do
            pcall(function()
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

            task.wait(CLICK_DELAY)
        end
    end)
end)

--// Stop clicking
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

--// Stop automatically if script is destroyed
Gui.Destroying:Connect(function()
    clicking = false
end)
