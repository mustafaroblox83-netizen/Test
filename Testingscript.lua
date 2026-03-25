--// HELLO HUB FULL REBUILD (KEY + AUTO SHOOT)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- =========================
-- 🔐 KEY SYSTEM
-- =========================
local KEY_VALID = "Hello_world123"

local function CheckKey()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "KeySystem"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.8, 0, 0, 40)
    Box.Position = UDim2.new(0.1, 0, 0.3, 0)
    Box.PlaceholderText = "Enter Key..."

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.8, 0, 0, 40)
    Btn.Position = UDim2.new(0.1, 0, 0.65, 0)
    Btn.Text = "Submit"

    local unlocked = false

    Btn.MouseButton1Click:Connect(function()
        if Box.Text == KEY_VALID then
            unlocked = true
            ScreenGui:Destroy()
        else
            Box.Text = "Wrong Key!"
        end
    end)

    repeat task.wait() until unlocked
end

CheckKey()

-- =========================
-- 🔧 TOGGLES
-- =========================
local Toggles = {
    Aimbot     = false,
    StrongLock = false,
    WallCheck  = false,
    NoClip     = false,
    ESP        = false,
    SpeedHack  = false,
    Fly        = false,
    Auto1v1    = false,
    AutoShoot  = false
}

local Connections = {}

-- =========================
-- ⚙️ FEATURE SYSTEM
-- =========================
local function ApplyFeature(key, val)

    if key == "AutoShoot" then
        if val then
            Connections.AutoShoot = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        pcall(function()
                            tool:Activate()
                        end)
                    end
                end
            end)
        else
            if Connections.AutoShoot then
                Connections.AutoShoot:Disconnect()
                Connections.AutoShoot = nil
            end
        end
    end

end

-- =========================
-- 🎨 UI
-- =========================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "HelloHub"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 250)
Main.Position = UDim2.new(0.5, -175, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Hello Hub 😎"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

-- =========================
-- 🔘 TOGGLE FUNCTION
-- =========================
local function CreateToggle(parent, text, key, yPos)

    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,200,0,40)
    btn.Position = UDim2.new(0.5,-100,0,yPos)
    btn.Text = text.." : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        ApplyFeature(key, Toggles[key])

        if Toggles[key] then
            btn.Text = text.." : ON"
            btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        else
            btn.Text = text.." : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
    end)

end

-- =========================
-- 🔫 COMBAT TAB (SIMPLE)
-- =========================
CreateToggle(Main,"Auto Shoot","AutoShoot",60)

-- =========================
-- 🖱️ DRAG
-- =========================
local dragging, dragInput, dragStart, startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
