-- BABFT AutoFarm Script with Custom GUI
-- Created by Grok on May 03, 2025
-- For Build A Boat For Treasure (PlaceId: 537413528)

-- Verify game
if game.PlaceId ~= 537413528 then
    warn("This script is for Build A Boat For Treasure only!")
    return
end

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player and character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- HTTP request function
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Folder setup
if not isfolder("BABFT") then makefolder("BABFT") end
if not isfolder("BABFT/Settings") then makefolder("BABFT/Settings") end

-- Global variables
local AutoFarmEnabled = false
local SilentMode = false
local WebhookURL = ""
local WebhookInterval = 1800
local WebhookEnabled = false
local clockTime = 0
local totalGoldGained = 0
local totalGoldBlocks = 0
local goldPerHour = 0
local lastGoldValue = player.Data.Gold.Value
local lastGoldBlockValue = player.Data.GoldBlock.Value
local running = false
local antiAFKConnection = nil
local TriggerChest = Workspace.BoatStages.NormalStages.TheEnd.GoldenChest.Trigger

-- Anti-AFK function
local function enableAntiAFK()
    if not antiAFKConnection then
        antiAFKConnection = player.Idled:Connect(function()
            if AutoFarmEnabled then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
end

local function disableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- Format time for display
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local sec = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, sec)
end

-- Webhook function
local function sendWebhook()
    if WebhookURL == "" or not WebhookEnabled then return end
    local embed = {
        title = "BABFT AutoFarm Stats",
        description = "Current AutoFarm Statistics",
        color = 16777215,
        fields = {
            {name = "Elapsed Time", value = formatTime(clockTime)},
            {name = "Gold Blocks Gained", value = tostring(totalGoldBlocks)},
            {name = "Gold Gained", value = tostring(totalGoldGained)},
            {name = "Gold per Hour", value = tostring(math.floor(goldPerHour))},
            {name = "Total Gold", value = tostring(player.Data.Gold.Value)}
        },
        footer = {text = "BABFT AutoFarm Script"},
        thumbnail_url = "https://tr.rbxcdn.com/180DAY-5cc07c05652006d448479ae66212782d/768/432/Image/Webp/noFilter"
    }
    local headers = {["Content-Type"] = "application/json"}
    local data = {embeds = {embed}}
    local body = HttpService:JSONEncode(data)
    httprequest({Url = WebhookURL, Method = "POST", Headers = headers, Body = body})
end

-- Stats tracking
local function startClock()
    if running then return end
    running = true
    while AutoFarmEnabled and running do
        clockTime = clockTime + 1
        task.wait(1)
    end
    running = false
end

RunService.Stepped:Connect(function()
    if AutoFarmEnabled and not running then
        task.wait(5)
        startClock()
    end
end)

spawn(function()
    while true do
        if AutoFarmEnabled then
            local currentGold = player.Data.Gold.Value
            local currentGoldBlocks = player.Data.GoldBlock.Value
            local goldGained = currentGold - lastGoldValue
            totalGoldGained = totalGoldGained + goldGained
            totalGoldBlocks = currentGoldBlocks - lastGoldBlockValue
            goldPerHour = clockTime > 0 and (totalGoldGained / clockTime) * 3600 or 0
            lastGoldValue = currentGold
            lastGoldBlockValue = currentGoldBlocks
        end
        task.wait(1)
    end
end)

-- Webhook interval loop
spawn(function()
    while true do
        if AutoFarmEnabled and WebhookEnabled and WebhookURL ~= "" then
            sendWebhook()
            task.wait(WebhookInterval)
        else
            task.wait(1)
        end
    end
end)

-- AutoFarm logic
local function startAutoFarm()
    if not AutoFarmEnabled then return end
    enableAntiAFK()
    local tempPart = Instance.new("Part", Workspace)
    tempPart.Size = Vector3.new(5, 1, 5)
    tempPart.Transparency = 1
    tempPart.CanCollide = true
    tempPart.Anchored = true
    local decal = Instance.new("Decal", tempPart)
    decal.Texture = "rbxassetid://139953968294114"
    decal.Face = Enum.NormalId.Top

    local function teleportToStage(iteration)
        if not AutoFarmEnabled then return end
        local pos, chestPos
        if SilentMode then
            pos = (iteration == 1) and CFrame.new(160.161041, 29.595888, 973.813720) or
                  CFrame.new(70.024177, 138.902633, 1371.634155 + (iteration - 2) * 770)
            chestPos = (iteration == 5) and CFrame.new(70.024177, 138.902633, 1371.634155 + 3 * 770)
        else
            pos = (iteration == 1) and CFrame.new(160.161041, 29.595888, 973.813720) or
                  CFrame.new(-51, 65, 984 + (iteration - 1) * 770)
            chestPos = (iteration == 5) and CFrame.new(-51, 65, 984 + 4 * 770)
        end
        if chestPos then
            TriggerChest.CFrame = chestPos
            task.delay(0.8, function() Workspace.ClaimRiverResultsGold:FireServer() end)
        end
        humanoidRootPart.CFrame = pos
        tempPart.Position = humanoidRootPart.Position - Vector3.new(0, 2, 0)
        if iteration == 1 then
            task.wait(2.3)
        elseif iteration ~= 4 then
            repeat task.wait() until #tostring(player.OtherData["Stage"..(iteration-1)].Value) > 2
            Workspace.ClaimRiverResultsGold:FireServer()
        end
    end

    for i = 1, 10 do
        if not AutoFarmEnabled then break end
        teleportToStage(i)
    end
    tempPart:Destroy()
end

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.Text = "BABFT AutoFarm"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 200, 90)
ToggleButton.Text = "AutoFarm: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Parent = MainFrame
ToggleButton.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    ToggleButton.Text = "AutoFarm: " .. (AutoFarmEnabled and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
    if not AutoFarmEnabled then
        TriggerChest.CFrame = CFrame.new(-55.7065125, -358.739624, 9492.35645, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        disableAntiAFK()
    else
        player.Character:BreakJoints()
        task.wait(1)
        character = player.Character or player.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        spawn(startAutoFarm)
        player.CharacterAdded:Connect(function()
            if AutoFarmEnabled then
                character = player.Character
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                spawn(startAutoFarm)
            end
        end)
    end
end)

local SilentButton = Instance.new("TextButton")
SilentButton.Size = UDim2.new(0, 100, 0, 30)
SilentButton.Position = UDim2.new(0, 10, 0, 90)
SilentButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
SilentButton.Text = "Silent: OFF"
SilentButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentButton.TextSize = 14
SilentButton.Font = Enum.Font.SourceSans
SilentButton.Parent = MainFrame
SilentButton.MouseButton1Click:Connect(function()
    SilentMode = not SilentMode
    SilentButton.Text = "Silent: " .. (SilentMode and "ON" or "OFF")
    SilentButton.BackgroundColor3 = SilentMode and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
end)

local WebhookLabel = Instance.new("TextLabel")
WebhookLabel.Size = UDim2.new(1, -20, 0, 20)
WebhookLabel.Position = UDim2.new(0, 10, 0, 130)
WebhookLabel.BackgroundTransparency = 1
WebhookLabel.Text = "Webhook Settings"
WebhookLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WebhookLabel.TextSize = 16
WebhookLabel.Font = Enum.Font.SourceSansBold
WebhookLabel.TextXAlignment = Enum.TextXAlignment.Left
WebhookLabel.Parent = MainFrame

local WebhookInput = Instance.new("TextBox")
WebhookInput.Size = UDim2.new(1, -20, 0, 30)
WebhookInput.Position = UDim2.new(0, 10, 0, 150)
WebhookInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WebhookInput.Text = "Webhook URL"
WebhookInput.TextColor3 = Color3.fromRGB(150, 150, 150)
WebhookInput.TextSize = 14
WebhookInput.Font = Enum.Font.SourceSans
WebhookInput.ClearTextOnFocus = false
WebhookInput.Parent = MainFrame
WebhookInput.FocusLost:Connect(function()
    WebhookURL = WebhookInput.Text
end)

local IntervalInput = Instance.new("TextBox")
IntervalInput.Size = UDim2.new(1, -20, 0, 30)
IntervalInput.Position = UDim2.new(0, 10, 0, 190)
IntervalInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
IntervalInput.Text = "Interval (seconds)"
IntervalInput.TextColor3 = Color3.fromRGB(150, 150, 150)
IntervalInput.TextSize = 14
IntervalInput.Font = Enum.Font.SourceSans
IntervalInput.ClearTextOnFocus = false
IntervalInput.Parent = MainFrame
IntervalInput.FocusLost:Connect(function()
    local value = tonumber(IntervalInput.Text)
    WebhookInterval = value and value >= 60 and value or 1800
    IntervalInput.Text = tostring(WebhookInterval)
end)

local WebhookToggle = Instance.new("TextButton")
WebhookToggle.Size = UDim2.new(0, 100, 0, 30)
WebhookToggle.Position = UDim2.new(0, 10, 0, 230)
WebhookToggle.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
WebhookToggle.Text = "Webhook: OFF"
WebhookToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
WebhookToggle.TextSize = 14
WebhookToggle.Font = Enum.Font.SourceSans
WebhookToggle.Parent = MainFrame
WebhookToggle.MouseButton1Click:Connect(function()
    WebhookEnabled = not WebhookEnabled
    WebhookToggle.Text = "Webhook: " .. (WebhookEnabled and "ON" or "OFF")
    WebhookToggle.BackgroundColor3 = WebhookEnabled and Color3.fromRGB(80, 200, 90) or Color3.fromRGB(245, 60, 60)
end)

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 20)
StatsLabel.Position = UDim2.new(0, 10, 0, 270)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Statistics"
StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsLabel.TextSize = 16
StatsLabel.Font = Enum.Font.SourceSansBold
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(1, -20, 0, 20)
TimeLabel.Position = UDim2.new(0, 10, 0, 290)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "Elapsed Time: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 14
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = MainFrame

local GoldLabel = Instance.new("TextLabel")
GoldLabel.Size = UDim2.new(1, -20, 0, 20)
GoldLabel.Position = UDim2.new(0, 10, 0, 310)
GoldLabel.BackgroundTransparency = 1
GoldLabel.Text = "Gold Gained: 0"
GoldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GoldLabel.TextSize = 14
GoldLabel.Font = Enum.Font.SourceSans
GoldLabel.TextXAlignment = Enum.TextXAlignment.Left
GoldLabel.Parent = MainFrame

local BlocksLabel = Instance.new("TextLabel")
BlocksLabel.Size = UDim2.new(1, -20, 0, 20)
BlocksLabel.Position = UDim2.new(0, 10, 0, 330)
BlocksLabel.BackgroundTransparency = 1
BlocksLabel.Text = "Gold Blocks Gained: 0"
BlocksLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BlocksLabel.TextSize = 14
BlocksLabel.Font = Enum.Font.SourceSans
BlocksLabel.TextXAlignment = Enum.TextXAlignment.Left
BlocksLabel.Parent = MainFrame

local GPHLabel = Instance.new("TextLabel")
GPHLabel.Size = UDim2.new(1, -20, 0, 20)
GPHLabel.Position = UDim2.new(0, 10, 0, 350)
GPHLabel.BackgroundTransparency = 1
GPHLabel.Text = "Gold Per Hour: 0"
GPHLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GPHLabel.TextSize = 14
GPHLabel.Font = Enum.Font.SourceSans
GPHLabel.TextXAlignment = Enum.TextXAlignment.Left
GPHLabel.Parent = MainFrame

-- Update stats display
spawn(function()
    while true do
        TimeLabel.Text = "Elapsed Time: " .. formatTime(clockTime)
        GoldLabel.Text = "Gold Gained: " .. totalGoldGained
        BlocksLabel.Text = "Gold Blocks Gained: " .. totalGoldBlocks
        GPHLabel.Text = "Gold Per Hour: " .. math.floor(goldPerHour)
        task.wait(1)
    end
end)

-- Toggle GUI visibility
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Cleanup on script unload
game:BindToClose(function()
    AutoFarmEnabled = false
    disableAntiAFK()
    TriggerChest.CFrame = CFrame.new(-55.7065125, -358.739624, 9492.35645, 0, 0, -1, 0, 1, 0, 1, 0, 0)
end)

warn("BABFT AutoFarm Script Loaded Successfully!")
