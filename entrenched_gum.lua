--// Improved Entrenched Executor by GUM - Owned by @Axion_Exe
--// Red Box ESP + Smart Aim Lock + Clean UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimbotEnabled = true
local SilentAimEnabled = true
local ESPEnabled = true
local PredictionFactor = 0.115
local PASSWORD = "420"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Better Password Frame
local PWFrame = Instance.new("Frame")
PWFrame.Size = UDim2.new(0, 320, 0, 160)
PWFrame.Position = UDim2.new(0.5, -160, 0.4, 0)
PWFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PWFrame.Parent = ScreenGui
Instance.new("UICorner", PWFrame).CornerRadius = UDim.new(0, 16)

local PWTitle = Instance.new("TextLabel")
PWTitle.Size = UDim2.new(1,0,0,50)
PWTitle.BackgroundTransparency = 1
PWTitle.Text = "GUM EXECUTOR"
PWTitle.TextColor3 = Color3.fromRGB(0, 255, 120)
PWTitle.TextScaled = true
PWTitle.Font = Enum.Font.GothamBlack
PWTitle.Parent = PWFrame

local PWInput = Instance.new("TextBox")
PWInput.Size = UDim2.new(0.8,0,0,45)
PWInput.Position = UDim2.new(0.1,0,0.45,0)
PWInput.PlaceholderText = "ENTER PASSWORD"
PWInput.BackgroundColor3 = Color3.fromRGB(25,25,25)
PWInput.TextColor3 = Color3.new(1,1,1)
PWInput.Parent = PWFrame
Instance.new("UICorner", PWInput).CornerRadius = UDim.new(0, 10)

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0.5,0,0,40)
UnlockBtn.Position = UDim2.new(0.25,0,0.75,0)
UnlockBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
UnlockBtn.Text = "UNLOCK PANEL"
UnlockBtn.TextColor3 = Color3.new(1,1,1)
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.Parent = PWFrame
Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0, 10)

-- Main Panel (Cleaner)
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 380, 0, 480)
MainPanel.Position = UDim2.new(0.5, -190, 0.5, -240)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainPanel.Visible = false
MainPanel.Parent = ScreenGui
Instance.new("UICorner", MainPanel).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,60)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
Title.Text = "GUM • ENTRENCHED"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = MainPanel
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 16)

local function AddToggle(txt, y, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.9,0,0,55)
    f.Position = UDim2.new(0.05,0,0,y)
    f.BackgroundColor3 = Color3.fromRGB(25,25,25)
    f.Parent = MainPanel
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.new(1,1,1)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamSemibold
    l.Parent = f
    
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.3,0,0.7,0)
    b.Position = UDim2.new(0.67,0,0.15,0)
    b.BackgroundColor3 = Color3.fromRGB(80,80,80)
    b.Text = "OFF"
    b.TextColor3 = Color3.fromRGB(255,80,80)
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        if on then
            b.BackgroundColor3 = Color3.fromRGB(0,200,100)
            b.Text = "ON"
            b.TextColor3 = Color3.new(1,1,1)
        else
            b.BackgroundColor3 = Color3.fromRGB(80,80,80)
            b.Text = "OFF"
            b.TextColor3 = Color3.fromRGB(255,80,80)
        end
        callback(on)
    end)
end

AddToggle("Aimbot + Head Lock", 80, function(v) AimbotEnabled = v end)
AddToggle("Silent Aim", 150, function(v) SilentAimEnabled = v end)
AddToggle("Red Box ESP", 220, function(v) ESPEnabled = v end)

UnlockBtn.MouseButton1Click:Connect(function()
    if PWInput.Text == PASSWORD then
        PWFrame:Destroy()
        MainPanel.Visible = true
    else
        PWInput.Text = "WRONG PASSWORD"
        task.wait(1.5)
        PWInput.Text = ""
    end
end)

-- Red Box ESP
local highlights = {}
local function CreateBoxESP(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character or plr.CharacterAdded:Wait()
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = char
    highlights[plr] = highlight
end

for _, p in ipairs(Players:GetPlayers()) do CreateBoxESP(p) end
Players.PlayerAdded:Connect(CreateBoxESP)

-- Smart Aim Lock (Aim at box → lock head)
local targetPlayer = nil
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    
    local mouseTarget = LocalPlayer:GetMouse().Target
    local found = false
    
    for plr, hl in pairs(highlights) do
        if plr.Character and mouseTarget and mouseTarget:IsDescendantOf(plr.Character) then
            targetPlayer = plr
            found = true
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local head = targetPlayer.Character.Head
        local predicted = head.Position + (head.Velocity * PredictionFactor)
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predicted)
    end
end)

-- Silent Aim
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, k)
    if SilentAimEnabled and k == "Hit" and self == LocalPlayer:GetMouse() then
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local head = targetPlayer.Character.Head
            return CFrame.new(head.Position + head.Velocity * PredictionFactor)
        end
    end
    return old(self, k)
end)
setreadonly(mt, true)

print("GUM Improved Executor Loaded - Red Box + Smart Lock")
