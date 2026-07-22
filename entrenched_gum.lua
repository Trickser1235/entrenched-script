--// GUM Entrenched Script - Strong Prediction + Ctrl Hide
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimbotEnabled = true
local SilentAimEnabled = true
local ESPEnabled = true
local PredictionFactor = 0.165  -- Strong prediction for Entrenched

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 350, 0, 420)
MainPanel.Position = UDim2.new(0.5, -175, 0.5, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(15,15,15)
MainPanel.Visible = true
MainPanel.Parent = ScreenGui
Instance.new("UICorner", MainPanel).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(0,140,70)
Title.Text = "GUM ENTRENCHED"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = MainPanel
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local function ToggleBtn(text, y, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.9,0,0,50)
    f.Position = UDim2.new(0.05,0,0,y)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    f.Parent = MainPanel
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamSemibold
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.35,0,0.75,0)
    b.Position = UDim2.new(0.62,0,0.125,0)
    b.BackgroundColor3 = default and Color3.fromRGB(0,200,100) or Color3.fromRGB(80,80,80)
    b.Text = default and "ON" or "OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    local state = default
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(80,80,80)
        b.Text = state and "ON" or "OFF"
        cb(state)
    end)
end

ToggleBtn("Aimbot + Head Lock", 70, true, function(v) AimbotEnabled = v end)
ToggleBtn("Silent Aim", 130, true, function(v) SilentAimEnabled = v end)
ToggleBtn("Red Box ESP", 190, true, function(v) ESPEnabled = v end)

-- Red Box ESP
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local hl = Instance.new("Highlight")
    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
    hl.FillTransparency = 1
    hl.OutlineTransparency = 0
    hl.Parent = plr.Character or plr.CharacterAdded:Wait()
end

for _,p in ipairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- Closest Enemy with Prediction
local function GetTarget()
    local closest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Team ~= LocalPlayer.Team then
            local root = p.Character.Head
            local d = (Camera.CFrame.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                closest = p.Character
            end
        end
    end
    return closest
end

-- Silent Aim
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    if SilentAimEnabled and key == "Hit" and self == LocalPlayer:GetMouse() then
        local char = GetTarget()
        if char and char:FindFirstChild("Head") then
            local head = char.Head
            return CFrame.new(head.Position + head.Velocity * PredictionFactor)
        end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    local char = GetTarget()
    if char and char:FindFirstChild("Head") then
        local head = char.Head
        local pred = head.Position + head.Velocity * PredictionFactor
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, pred)
    end
end)

-- Ctrl to Hide/Show GUI
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        MainPanel.Visible = not MainPanel.Visible
    end
end)

print("GUM Entrenched Loaded - Ctrl to Hide")
