local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimbotEnabled = false
local SilentAimEnabled = false
local ESPEnabled = false
local PredictionFactor = 0.1
local TargetPart = "Head"

local PASSWORD = "420"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GUM_Entrenched_Executor"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Password Frame
local PasswordFrame = Instance.new("Frame")
PasswordFrame.Size = UDim2.new(0, 300, 0, 150)
PasswordFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
PasswordFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PasswordFrame.Parent = ScreenGui
Instance.new("UICorner", PasswordFrame).CornerRadius = UDim.new(0, 12)

local PasswordTitle = Instance.new("TextLabel")
PasswordTitle.Size = UDim2.new(1, 0, 0, 40)
PasswordTitle.BackgroundTransparency = 1
PasswordTitle.Text = "GUM EXECUTOR - ENCRYPTED"
PasswordTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
PasswordTitle.TextScaled = true
PasswordTitle.Font = Enum.Font.GothamBold
PasswordTitle.Parent = PasswordFrame

local PasswordInput = Instance.new("TextBox")
PasswordInput.Size = UDim2.new(0.8, 0, 0, 40)
PasswordInput.Position = UDim2.new(0.1, 0, 0.45, 0)
PasswordInput.PlaceholderText = "ENTER 420"
PasswordInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PasswordInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PasswordInput.Parent = PasswordFrame
Instance.new("UICorner", PasswordInput).CornerRadius = UDim.new(0, 8)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.4, 0, 0, 35)
SubmitBtn.Position = UDim2.new(0.3, 0, 0.75, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
SubmitBtn.Text = "UNLOCK"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Parent = PasswordFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

-- Main Panel
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 420, 0, 520)
MainPanel.Position = UDim2.new(0.5, -210, 0.5, -260)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainPanel.Visible = false
MainPanel.Parent = ScreenGui
Instance.new("UICorner", MainPanel).CornerRadius = UDim.new(0, 16)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 60)
TitleBar.Parent = MainPanel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "GUM EXECUTOR • ENTRENCHED"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Parent = TitleBar

local function CreateToggle(parent, text, yOffset, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 50)
    ToggleFrame.Position = UDim2.new(0.05, 0, 0, yOffset)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.Parent = parent
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 10)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamSemibold
    Label.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
    ToggleBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    ToggleBtn.Parent = ToggleFrame
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
            ToggleBtn.Text = "ON"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            ToggleBtn.Text = "OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        callback(enabled)
    end)
end

CreateToggle(MainPanel, "Aimbot (Visible)", 70, function(s) AimbotEnabled = s end)
CreateToggle(MainPanel, "Silent Aim", 130, function(s) SilentAimEnabled = s end)
CreateToggle(MainPanel, "ESP Enemy", 190, function(s) ESPEnabled = s end)
CreateToggle(MainPanel, "Auto Head Lock", 250, function(s) TargetPart = s and "Head" or "HumanoidRootPart" end)

SubmitBtn.MouseButton1Click:Connect(function()
    if PasswordInput.Text == PASSWORD then
        PasswordFrame:Destroy()
        MainPanel.Visible = true
        print("GUM Executor: Access Granted")
    else
        PasswordInput.Text = "INVALID"
        task.wait(1)
        PasswordInput.Text = ""
    end
end)

-- ESP System
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "GUM_ESP"
ESPFolder.Parent = ScreenGui

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = plr.Character and plr.Character:FindFirstChild("Head")
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = ESPFolder
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = plr.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    NameLabel.TextScaled = true
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Parent = Billboard
    
    local HealthLabel = Instance.new("TextLabel")
    HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    HealthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    HealthLabel.TextScaled = true
    HealthLabel.Font = Enum.Font.Gotham
    HealthLabel.Parent = Billboard
    
    RunService.RenderStepped:Connect(function()
        if not ESPEnabled or not plr.Character or not plr.Character:FindFirstChild("Head") then return end
        local hum = plr.Character:FindFirstChild("Humanoid")
        local dist = 0
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
        end
        if hum then
            HealthLabel.Text = "HP: " .. math.floor(hum.Health) .. " | Dist: " .. math.floor(dist)
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() if ESPEnabled then CreateESP(p) end end)
end)

local function GetClosestEnemy()
    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and p.Team ~= LocalPlayer.Team then
            local root = p.Character:FindFirstChild(TargetPart) or p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (Camera.CFrame.Position - root.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = root
                end
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
        local target = GetClosestEnemy()
        if target then
            return CFrame.new(target.Position + target.Velocity * PredictionFactor)
        end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

-- Aimbot
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestEnemy()
        if target then
            local predPos = target.Position + target.Velocity * PredictionFactor
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predPos)
        end
    end
end)

print("GUM Entrenched Executor Loaded - Ready")
