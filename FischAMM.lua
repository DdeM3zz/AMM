-- MenuAMM: Admin Panel Script for Roblox using Xeno Executor
-- Features: Teleportation (behind players, mouse point, specific player), Kill All, Flight, Noclip
-- GUI: Draggable, Black/Gray/White theme
-- GitHub Integration: Loads via loadstring from GitHub raw URL

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Local player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Setup using Roblox's UIs
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AMM_AdminPanel"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark Gray
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255) -- White Border
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Black
TitleLabel.Text = "AMM Admin Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

-- Functions Frame
local FunctionsFrame = Instance.new("Frame")
FunctionsFrame.Size = UDim2.new(1, -10, 1, -40)
FunctionsFrame.Position = UDim2.new(0, 5, 0, 35)
FunctionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Gray
FunctionsFrame.Parent = MainFrame

-- Scrolling Frame for Player List
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.5, -10, 0.5, -10)
PlayerListFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerListFrame.ScrollBarThickness = 5
PlayerListFrame.Parent = FunctionsFrame

-- UI List Layout for Player Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Button Creation Function
local function CreateButton(name, parent, size, position, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = size
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Light Gray
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.Parent = parent
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Teleport Functions
local function TeleportBehind(targetPlayer)
    if targetPlayer.Character and LocalPlayer.Character then
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        local behindPos = targetCFrame * CFrame.new(0, 0, 3) -- 3 studs behind
        LocalPlayer.Character.HumanoidRootPart.CFrame = behindPos
    end
end

local function TeleportToMouse()
    if Mouse.Hit then
        if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end

local function TeleportToPlayer(targetPlayer)
    if targetPlayer.Character and LocalPlayer.Character then
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    end
end

-- Kill All Function
local function KillAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

-- Flight and Noclip Variables
local Flying = false
local Noclip = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyGyro = nil

-- Flight Function
local function ToggleFlight()
    Flying = not Flying
    if Flying then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            BodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        end
    else
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end
end

-- Noclip Function
local function ToggleNoclip()
    Noclip = not Noclip
    if Noclip then
        game:GetService("RunService").Stepped:Connect(function()
            if Noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Update Player List
local function UpdatePlayerList()
    PlayerListFrame:ClearAllChildren()
    UIListLayout.Parent = PlayerListFrame -- Reattach UIListLayout
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(1, -10, 0, 30)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 14
            PlayerButton.Font = Enum.Font.SourceSans
            PlayerButton.Parent = PlayerListFrame
            PlayerButton.MouseButton1Click:Connect(function()
                local ActionFrame = Instance.new("Frame")
                ActionFrame.Size = UDim2.new(0.5, -10, 0.5, -10)
                ActionFrame.Position = UDim2.new(0.5, 5, 0, 5)
                ActionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ActionFrame.Parent = FunctionsFrame

                CreateButton("TeleportBehind", ActionFrame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 5), "Teleport Behind", function()
                    TeleportBehind(player)
                end)

                CreateButton("TeleportTo", ActionFrame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 40), "Teleport To", function()
                    TeleportToPlayer(player)
                end)
            end)
        end
    end
end

-- GUI Buttons
CreateButton("KillAll", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0.5, 5), "Kill All", KillAll)
CreateButton("ToggleFlight", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0.5, 40), "Toggle Flight", ToggleFlight)
CreateButton("ToggleNoclip", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0.5, 75), "Toggle Noclip", ToggleNoclip)

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            TeleportToMouse()
        elseif input.KeyCode == Enum.KeyCode.LeftAlt then
            local closestPlayer = nil
            local closestDistance = math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
            if closestPlayer then
                TeleportBehind(closestPlayer)
            end
        elseif input.KeyCode == Enum.KeyCode.Space and Flying then
            if BodyVelocity then
                BodyVelocity.Velocity = (workspace.CurrentCamera.CFrame.LookVector * FlySpeed)
            end
        elseif input.KeyCode == Enum.KeyCode.N then
            ToggleNoclip()
        end
    end
end)

-- Update Player List on Player Join/Leave
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- Flight Movement
UserInputService.InputChanged:Connect(function(input)
    if Flying and input.UserInputType == Enum.UserInputType.MouseMovement then
        if BodyGyro then
            BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end
end)

-- Ensure GUI stays on top
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainFrame.ZIndex = 10