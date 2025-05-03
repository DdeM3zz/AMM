-- Dead Rails ESP and NoClip Script for Xeno Executor
-- Created by DdeM3zz on May 03, 2025
-- For Dead Rails (PlaceId: 70876832253163 for game, 116495829188952 for lobby)

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Player and character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Global variables
local ESPItemsEnabled = false
local ESPOreEnabled = false
local ESPEnemiesEnabled = false
local NoClipEnabled = false
local ESPObjects = {} -- Store ESP adornments and labels
local antiAFKConnection = nil

-- Anti-AFK function
local function enableAntiAFK()
    if not antiAFKConnection then
        antiAFKConnection = player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

local function disableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- ESP creation function
local function createESP(object, color, name)
    if not object or not object.Parent then return end
    local part = object:IsA("BasePart") and object or object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
    box.Color3 = color
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.AdornCFrame = CFrame.new(Vector3.new(0, 0, 0))
    box.Adornee = part
    box.Parent = part

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, part.Size.Y + 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = color
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard

    ESPObjects[object] = {box = box, billboard = billboard}
end

-- Remove ESP from object
local function removeESP(object)
    if ESPObjects[object] then
        pcall(function()
            ESPObjects[object].box:Destroy()
            ESPObjects[object].billboard:Destroy()
        end)
        ESPObjects[object] = nil
    end
end

-- Clear all ESP
local function clearESP()
    for object, _ in pairs(ESPObjects) do
        removeESP(object)
    end
end

-- Update ESP for Items
local function updateItemsESP()
    if not ESPItemsEnabled then
        for _, object in pairs(Workspace:GetDescendants()) do
            if object:IsDescendantOf(Workspace.RuntimeItems) then
                removeESP(object)
            end
        end
        return
    end
    for _, object in pairs(Workspace.RuntimeItems:GetChildren()) do
        if not ESPObjects[object] then
            local color = Color3.fromRGB(0, 0, 255) -- Default: Blue
            if object.Name:lower():find("gold") then
                color = Color3.fromRGB(255, 255, 0) -- Yellow
            elseif object.Name:lower():find("silver") then
                color = Color3.fromRGB(128, 128, 128) -- Gray
            elseif object.Name:lower():find("coal") then
                color = Color3.fromRGB(0, 0, 0) -- Black
            end
            createESP(object, color, object.Name)
        end
    end
end

-- Update ESP for Ore
local function updateOreESP()
    if not ESPOreEnabled then
        for _, object in pairs(Workspace:GetDescendants()) do
            if object:IsDescendantOf(Workspace.Ore) then
                removeESP(object)
            end
        end
        return
    end
    for _, object in pairs(Workspace.Ore:GetChildren()) do
        if not ESPObjects[object] then
            local color
            if object.Name == "GoldOre" then
                color = Color3.fromRGB(255, 255, 0) -- Yellow
            elseif object.Name == "SilverOre" then
                color = Color3.fromRGB(128, 128, 128) -- Gray
            elseif object.Name == "CoalOre" then
                color = Color3.fromRGB(0, 0, 0) -- Black
            else
                color = Color3.fromRGB(0, 0, 255) -- Default: Blue
            end
            createESP(object, color, object.Name)
        end
    end
end

-- Update ESP for NightEnemies
local function updateEnemiesESP()
    if not ESPEnemiesEnabled then
        for _, object in pairs(Workspace:GetDescendants()) do
            if object:IsDescendantOf(Workspace.NightEnemies) then
                removeESP(object)
            end
        end
        return
    end
    for _, object in pairs(Workspace.NightEnemies:GetChildren()) do
        if not ESPObjects[object] then
            local color
            local name = object.Name:gsub("Model_", "")
            if object.Name == "Model_Vampir" then
                color = Color3.fromRGB(255, 0, 0) -- Red
            elseif object.Name == "Model_Werewolf" or object.Name == "Model_Wolf" then
                color = Color3.fromRGB(128, 128, 128) -- Gray
            elseif object.Name:find("Zombie") or object.Name == "Model_Walker" or object.Name == "Model_Runner" then
                color = Color3.fromRGB(0, 255, 0) -- Green
            elseif object.Name:lower():find("outlaw") then
                color = Color3.fromRGB(139, 69, 19) -- Brown
            else
                color = Color3.fromRGB(255, 165, 0) -- Orange (default)
            end
            createESP(object, color, name)
        end
    end
end

-- Handle object addition/removal
Workspace.RuntimeItems.ChildAdded:Connect(function(child)
    if ESPItemsEnabled then
        task.spawn(function()
            local color = Color3.fromRGB(0, 0, 255)
            if child.Name:lower():find("gold") then
                color = Color3.fromRGB(255, 255, 0)
            elseif child.Name:lower():find("silver") then
                color = Color3.fromRGB(128, 128, 128)
            elseif child.Name:lower():find("coal") then
                color = Color3.fromRGB(0, 0, 0)
            end
            createESP(child, color, child.Name)
        end)
    end
end)

Workspace.RuntimeItems.ChildRemoved:Connect(function(child)
    removeESP(child)
end)

Workspace.Ore.ChildAdded:Connect(function(child)
    if ESPOreEnabled then
        task.spawn(function()
            local color
            if child.Name == "GoldOre" then
                color = Color3.fromRGB(255, 255, 0)
            elseif child.Name == "SilverOre" then
                color = Color3.fromRGB(128, 128, 128)
            elseif child.Name == "CoalOre" then
                color = Color3.fromRGB(0, 0, 0)
            else
                color = Color3.fromRGB(0, 0, 255)
            end
            createESP(child, color, child.Name)
        end)
    end
end)

Workspace.Ore.ChildRemoved:Connect(function(child)
    removeESP(child)
end)

Workspace.NightEnemies.ChildAdded:Connect(function(child)
    if ESPEnemiesEnabled then
        task.spawn(function()
            local color
            local name = child.Name:gsub("Model_", "")
            if child.Name == "Model_Vampir" then
                color = Color3.fromRGB(255, 0, 0)
            elseif child.Name == "Model_Werewolf" or child.Name == "Model_Wolf" then
                color = Color3.fromRGB(128, 128, 128)
            elseif child.Name:find("Zombie") or child.Name == "Model_Walker" or child.Name == "Model_Runner" then
                color = Color3.fromRGB(0, 255, 0)
            elseif child.Name:lower():find("outlaw") then
                color = Color3.fromRGB(139, 69, 19)
            else
                color = Color3.fromRGB(255, 165, 0)
            end
            createESP(child, color, name)
        end)
    end
end)

Workspace.NightEnemies.ChildRemoved:Connect(function(child)
    removeESP(child)
end)

-- NoClip implementation
local noClipConnection
local function enableNoClip()
    if noClipConnection then return end
    noClipConnection = RunService.Stepped:Connect(function()
        if not character or not humanoidRootPart then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoClip()
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsESPNoClipGUI"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.Text = "Dead Rails ESP & NoClip"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local ItemsButton = Instance.new("TextButton")
ItemsButton.Size = UDim2.new(0, 100, 0, 30)
ItemsButton.Position = UDim2.new(0, 10, 0, 50)
ItemsButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
ItemsButton.Text = "Items ESP: OFF"
ItemsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemsButton.TextSize = 14
ItemsButton.Font = Enum.Font.SourceSans
ItemsButton.Parent = MainFrame
ItemsButton.MouseButton1Click:Connect(function()
    ESPItemsEnabled = not ESPItemsEnabled
    ItemsButton.Text = "Items ESP: " .. (ESPItemsEnabled and "ON" or "OFF")
    ItemsButton.BackgroundColor3 = ESPItemsEnabled and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
    task.spawn(updateItemsESP)
end)

local OreButton = Instance.new("TextButton")
OreButton.Size = UDim2.new(0, 100, 0, 30)
OreButton.Position = UDim2.new(0, 10, 0, 90)
OreButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
OreButton.Text = "Ore ESP: OFF"
OreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OreButton.TextSize = 14
OreButton.Font = Enum.Font.SourceSans
OreButton.Parent = MainFrame
OreButton.MouseButton1Click:Connect(function()
    ESPOreEnabled = not ESPOreEnabled
    OreButton.Text = "Ore ESP: " .. (ESPOreEnabled and "ON" or "OFF")
    OreButton.BackgroundColor3 = ESPOreEnabled and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
    task.spawn(updateOreESP)
end)

local EnemiesButton = Instance.new("TextButton")
EnemiesButton.Size = UDim2.new(0, 100, 0, 30)
EnemiesButton.Position = UDim2.new(0, 10, 0, 130)
EnemiesButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
EnemiesButton.Text = "Enemies ESP: OFF"
EnemiesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EnemiesButton.TextSize = 14
EnemiesButton.Font = Enum.Font.SourceSans
EnemiesButton.Parent = MainFrame
EnemiesButton.MouseButton1Click:Connect(function()
    ESPEnemiesEnabled = not ESPEnemiesEnabled
    EnemiesButton.Text = "Enemies ESP: " .. (ESPEnemiesEnabled and "ON" or "OFF")
    EnemiesButton.BackgroundColor3 = ESPEnemiesEnabled and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
    task.spawn(updateEnemiesESP)
end)

local NoClipButton = Instance.new("TextButton")
NoClipButton.Size = UDim2.new(0, 100, 0, 30)
NoClipButton.Position = UDim2.new(0, 10, 0, 170)
NoClipButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.TextSize = 14
NoClipButton.Font = Enum.Font.SourceSans
NoClipButton.Parent = MainFrame
NoClipButton.MouseButton1Click:Connect(function()
    NoClipEnabled = not NoClipEnabled
    NoClipButton.Text = "NoClip: " .. (NoClipEnabled and "ON" or "OFF")
    NoClipButton.BackgroundColor3 = NoClipEnabled and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
    if NoClipEnabled then
        task.spawn(enableNoClip)
    else
        disableNoClip()
    end
end)

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0, 100, 0, 30)
ClearButton.Position = UDim2.new(0, 10, 0, 210)
ClearButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
ClearButton.Text = "Clear"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 14
ClearButton.Font = Enum.Font.SourceSans
ClearButton.Parent = MainFrame
ClearButton.MouseButton1Click:Connect(function()
    ESPItemsEnabled = false
    ESPOreEnabled = false
    ESPEnemiesEnabled = false
    NoClipEnabled = false
    ItemsButton.Text = "Items ESP: OFF"
    OreButton.Text = "Ore ESP: OFF"
    EnemiesButton.Text = "Enemies ESP: OFF"
    NoClipButton.Text = "NoClip: OFF"
    ItemsButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
    OreButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
    EnemiesButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
    NoClipButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
    clearESP()
    disableNoClip()
    disableAntiAFK()
end)

-- Toggle GUI visibility
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initial setup
enableAntiAFK()
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    if NoClipEnabled then
        task.spawn(enableNoClip)
    end
end)

-- Cleanup on script unload
game:BindToClose(function()
    clearESP()
    disableNoClip()
    disableAntiAFK()
end)

warn("Dead Rails ESP and NoClip Script for Xeno Executor Loaded Successfully!")
