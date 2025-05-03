-- Dead Rails AutoFarm Script with Custom GUI
-- Created by Grok on May 03, 2025
-- For Dead Rails (PlaceId: 70876832253163 for game, 116495829188952 for lobby)

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player and character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- HTTP request function
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Global variables
local AutoFarmEnabled = false
local BondCount = 0
local TrackCount = 1
local TrackPassed = false
local FoundLobby = false
local Cooldown = 0.1
local antiAFKConnection = nil

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

-- AutoFarm logic
local function startAutoFarm()
    if not AutoFarmEnabled then return end
    enableAntiAFK()

    if game.PlaceId == 116495829188952 then
        -- Lobby: Find and join a game
        local CreateParty = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CreatePartyClient")
        while AutoFarmEnabled and not FoundLobby do
            print("Finding Lobby...")
            for _, v in pairs(Workspace.TeleportZones:GetChildren()) do
                if v.Name == "TeleportZone" and v.BillboardGui.StateLabel.Text == "Waiting for players..." then
                    print("Lobby Found!")
                    humanoidRootPart.CFrame = v.ZoneContainer.CFrame
                    FoundLobby = true
                    task.wait(1)
                    CreateParty:FireServer({["maxPlayers"] = 1})
                    break
                end
            end
            task.wait(Cooldown)
        end
    elseif game.PlaceId == 70876832253163 then
        -- Game: Farm bonds
        local StartingTrack = Workspace.RailSegments:FindFirstChild("RailSegment")
        local CollectBond = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("ActivateObjectClient")
        local Items = Workspace.RuntimeItems
        humanoidRootPart.Anchored = true

        while AutoFarmEnabled do
            if not TrackPassed then
                print("Teleporting to track", TrackCount)
                TrackPassed = true
            end
            humanoidRootPart.CFrame = StartingTrack.Guide.CFrame + Vector3.new(0, 250, 0)

            if StartingTrack.NextTrack.Value then
                StartingTrack = StartingTrack.NextTrack.Value
                TrackCount = TrackCount + 1
            else
                TeleportService:Teleport(116495829188952, player)
                FoundLobby = false
                TrackCount = 1
                TrackPassed = false
            end

            repeat
                for _, v in pairs(Items:GetChildren()) do
                    if v.Name == "Bond" or v.Name == "BondCalculated" then
                        spawn(function()
                            for i = 1, 1000 do
                                pcall(function()
                                    v.Part.CFrame = humanoidRootPart.CFrame
                                end)
                            end
                            CollectBond:FireServer(v)
                        end)
                        if v.Name == "Bond" then
                            BondCount = BondCount + 1
                            print("Got", BondCount, "Bonds")
                            v.Name = "BondCalculated"
                        end
                    end
                end
                task.wait()
            until not Items:FindFirstChild("Bond")
            TrackPassed = false
            task.wait(Cooldown)
        end
        humanoidRootPart.Anchored = false
    end
end

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsAutoFarmGUI"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.Text = "Dead Rails AutoFarm"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(245, 60, 60)
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
        disableAntiAFK()
        humanoidRootPart.Anchored = false
    else
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

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 20)
StatsLabel.Position = UDim2.new(0, 10, 0, 90)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Statistics"
StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsLabel.TextSize = 16
StatsLabel.Font = Enum.Font.SourceSansBold
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

local BondsLabel = Instance.new("TextLabel")
BondsLabel.Size = UDim2.new(1, -20, 0, 20)
BondsLabel.Position = UDim2.new(0, 10, 0, 110)
BondsLabel.BackgroundTransparency = 1
BondsLabel.Text = "Bonds Collected: 0"
BondsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BondsLabel.TextSize = 14
BondsLabel.Font = Enum.Font.SourceSans
BondsLabel.TextXAlignment = Enum.TextXAlignment.Left
BondsLabel.Parent = MainFrame

local TracksLabel = Instance.new("TextLabel")
TracksLabel.Size = UDim2.new(1, -20, 0, 20)
TracksLabel.Position = UDim2.new(0, 10, 0, 130)
TracksLabel.BackgroundTransparency = 1
TracksLabel.Text = "Tracks Passed: 0"
TracksLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TracksLabel.TextSize = 14
TracksLabel.Font = Enum.Font.SourceSans
TracksLabel.TextXAlignment = Enum.TextXAlignment.Left
TracksLabel.Parent = MainFrame

-- Update stats display
spawn(function()
    while true do
        BondsLabel.Text = "Bonds Collected: " .. BondCount
        TracksLabel.Text = "Tracks Passed: " .. TrackCount
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
    humanoidRootPart.Anchored = false
end)

warn("Dead Rails AutoFarm Script Loaded Successfully!")
