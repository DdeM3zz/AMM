-- MenuAMM: Admin Panel Script for Roblox using Xeno Executor
-- Features: Teleportation, Kill All, Flight (WASD), Noclip, ESP, Speed Hack, God Mode, Kick Player
-- GUI: Draggable, Modern design with gradients, rounded corners, hover effects, text-based hints, Made by: DdeM3zz
-- GitHub Integration: Loads via loadstring from GitHub raw URL

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
MainFrame.Size = UDim2.new(0, 300, 0, 480)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark Gray base
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Gradient for MainFrame
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

-- Rounded Corners for MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
TitleLabel.Text = "AMM Admin Panel"
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255) -- Neon Blue
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

-- Rounded Corners for TitleLabel
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Functions Frame
local FunctionsFrame = Instance.new("Frame")
FunctionsFrame.Size = UDim2.new(1, -10, 1, -40)
FunctionsFrame.Position = UDim2.new(0, 5, 0, 35)
FunctionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Gray base
FunctionsFrame.BorderSizePixel = 0
FunctionsFrame.Parent = MainFrame

-- Gradient for FunctionsFrame
local FunctionsGradient = Instance.new("UIGradient")
FunctionsGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
FunctionsGradient.Rotation = 45
FunctionsGradient.Parent = FunctionsFrame

-- Rounded Corners for FunctionsFrame
local FunctionsCorner = Instance.new("UICorner")
FunctionsCorner.CornerRadius = UDim.new(0, 8)
FunctionsCorner.Parent = FunctionsFrame

-- Scrolling Frame for Player List
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.5, -10, 0, 360)
PlayerListFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerListFrame.ScrollBarThickness = 5
PlayerListFrame.Parent = FunctionsFrame

-- Rounded Corners for PlayerListFrame
local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 6)
PlayerListCorner.Parent = PlayerListFrame

-- UI List Layout for Player Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Hints Label (Text-Based)
local HintsLabel = Instance.new("TextLabel")
HintsLabel.Size = UDim2.new(0.5, -10, 0, 60)
HintsLabel.Position = UDim2.new(0.5, 5, 0, 390)
HintsLabel.BackgroundTransparency = 1 -- Transparent
HintsLabel.Text = "Alt: Teleport behind closest player\nCtrl + Left Click: Teleport to mouse"
HintsLabel.TextColor3 = Color3.fromRGB(200, 200, 200) -- Light Gray
HintsLabel.TextSize = 10
HintsLabel.TextWrapped = true
HintsLabel.Font = Enum.Font.SourceSansItalic
HintsLabel.Parent = FunctionsFrame

-- Made by Label
local MadeByLabel = Instance.new("TextLabel")
MadeByLabel.Size = UDim2.new(1, -10, 0, 20)
MadeByLabel.Position = UDim2.new(0, 5, 1, -25)
MadeByLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MadeByLabel.Text = "Made by: DdeM3zz"
MadeByLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- Brighter White
MadeByLabel.TextSize = 12
MadeByLabel.Font = Enum.Font.SourceSans
MadeByLabel.Parent = MainFrame

-- Rounded Corners for MadeByLabel
local MadeByCorner = Instance.new("UICorner")
MadeByCorner.CornerRadius = UDim.new(0, 6)
MadeByCorner.Parent = MadeByLabel

-- Button Creation Function
local function CreateButton(name, parent, size, position, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = size
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Darker Gray
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(220, 220, 220) -- Brighter White
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.Parent = parent
    Button.MouseButton1Click:Connect(callback)

    -- Rounded Corners for Button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    -- Hover Effect
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Lighter Gray
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Original Dark Gray
    end)

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
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
            player.Character:BreakJoints() -- Fallback to ensure kill
        end
    end
end

-- ESP Variables and Function
local ESPEnabled = false
local ESPBoxes = {}

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    if not ESPEnabled then
        for _, box in pairs(ESPBoxes) do
            box:Destroy()
        end
        ESPBoxes = {}
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = player.Character:GetExtentsSize() * 1.2
                box.Adornee = player.Character
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Transparency = 0.5
                box.Color3 = Color3.fromRGB(255, 0, 0) -- Red outline
                box.Parent = game.CoreGui
                ESPBoxes[player] = box
            end
        end
    end
end

-- Speed Hack Function
local function ApplySpeed(speedText)
    local speed = tonumber(speedText)
    if speed and speed >= 0 and speed <= 500 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- God Mode Variables and Function
local GodModeEnabled = false
local GodModeConnection = nil

local function ToggleGodMode()
    GodModeEnabled = not GodModeEnabled
    if GodModeEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.MaxHealth = 1e9
            humanoid.Health = 1e9
            GodModeConnection = humanoid.HealthChanged:Connect(function(health)
                if health < 1e9 then
                    humanoid.Health = 1e9
                end
            end)
        end
    else
        if GodModeConnection then
            GodModeConnection:Disconnect()
            GodModeConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- Kick Player Function
local function KickPlayer(targetPlayer)
    if targetPlayer ~= LocalPlayer then
        -- Simulate kick by forcing client disconnection (limited by server)
        pcall(function()
            targetPlayer:Kick("Kicked by AMM Admin")
        end)
    end
end

-- Flight and Noclip Variables
local Flying = false
local Noclip = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyGyro = nil
local NoclipConnection = nil

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
            BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            BodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        end
    else
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    end
end

-- Noclip Function
local function ToggleNoclip()
    Noclip = not Noclip
    if Noclip then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Update Player List
local function UpdatePlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(1, -10, 0, 30)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            PlayerButton.TextSize = 14
            PlayerButton.Font = Enum.Font.SourceSans
            PlayerButton.Parent = PlayerListFrame
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = PlayerButton
            PlayerButton.MouseButton1Click:Connect(function()
                local ActionFrame = Instance.new("Frame")
                ActionFrame.Size = UDim2.new(0.5, -10, 0, 120)
                ActionFrame.Position = UDim2.new(0.5, 5, 0, 245)
                ActionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ActionFrame.Parent = FunctionsFrame
                local ActionCorner = Instance.new("UICorner")
                ActionCorner.CornerRadius = UDim.new(0, 6)
                ActionCorner.Parent = ActionFrame

                CreateButton("TeleportBehind", ActionFrame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 5), "Teleport Behind", function()
                    TeleportBehind(player)
                end)

                CreateButton("TeleportTo", ActionFrame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 40), "Teleport To", function()
                    TeleportToPlayer(player)
                end)

                CreateButton("KickPlayer", ActionFrame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 75), "Kick", function()
                    KickPlayer(player)
                end)
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- GUI Buttons and Inputs (Top-Right)
CreateButton("KillAll", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0, 5), "Kill All", KillAll)
CreateButton("ToggleFlight", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0, 40), "Toggle Flight", ToggleFlight)
CreateButton("ToggleNoclip", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0, 75), "Toggle Noclip", ToggleNoclip)
CreateButton("ToggleESP", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0, 110), "Toggle ESP", ToggleESP)
CreateButton("ToggleGodMode", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0, 145), "Toggle God Mode", ToggleGodMode)

-- Speed Hack Input
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.5, -10, 0, 30)
SpeedInput.Position = UDim2.new(0.5, 5, 0, 180)
SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedInput.Text = "16" -- Default walk speed
SpeedInput.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedInput.TextSize = 14
SpeedInput.Font = Enum.Font.SourceSans
SpeedInput.Parent = FunctionsFrame

-- Rounded Corners for SpeedInput
local SpeedInputCorner = Instance.new("UICorner")
SpeedInputCorner.CornerRadius = UDim.new(0, 6)
SpeedInputCorner.Parent = SpeedInput

CreateButton("ApplySpeed", FunctionsFrame, UDim2.new(0.5, -10, 0, 30), UDim2.new(0.5, 5, 0, 215), "Apply Speed", function()
    ApplySpeed(SpeedInput.Text)
end)

-- Input Handling for Flight and Teleport
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
        elseif input.KeyCode == Enum.KeyCode.N then
            ToggleNoclip()
        end
    end
end)

-- WASD Flight Controls
local function UpdateFlight()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local moveDirection = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + lookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - lookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - rightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + rightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyCodeDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        if BodyVelocity then
            BodyVelocity.Velocity = moveDirection * FlySpeed
        end
        if BodyGyro then
            BodyGyro.CFrame = camera.CFrame
        end
    end
end

-- ESP Update on Player Join/Leave
Players.PlayerAdded:Connect(function(player)
    wait(1) -- Delay to ensure player data is loaded
    UpdatePlayerList()
    if ESPEnabled and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = player.Character:GetExtentsSize() * 1.2
        box.Adornee = player.Character
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Transparency = 0.5
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Parent = game.CoreGui
        ESPBoxes[player] = box
    end
end)

Players.PlayerRemoving:Connect(function(player)
    UpdatePlayerList()
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
end)

-- Initial Player List Update with Delay
spawn(function()
    wait(2) -- Wait for server to load players
    UpdatePlayerList()
end)

-- Flight Update Loop
RunService.RenderStepped:Connect(UpdateFlight)

-- Ensure GUI stays on top
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainFrame.ZIndex = 10
