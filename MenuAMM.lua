-- MenuAMM: Admin Panel Script for Roblox using Xeno Executor
-- Features: Teleportation, Kill All (improved with server attempts), Flight (WASD), Noclip, ESP, Speed Hack, God Mode, Kick Player (with notification), Infinite Jump, Teleport Up, Kill Player, Auto-Respawn
-- GUI: Larger (500x600), black/blue theme (only Color3.fromRGB(0, 0, 0) and Color3.fromRGB(0, 150, 255)), no gradients, toggleable action menu, minimize/maximize, increased button spacing, MadeByLabel hidden when minimized, no hints, Made by: DdeM3zz
-- GitHub Integration: Loads via loadstring from GitHub raw URL

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10

-- Rounded Corners for MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Border for MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Title Bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
TitleLabel.Text = "AMM Admin Panel"
TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

-- Rounded Corners for TitleLabel
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

-- Border for TitleLabel
local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
TitleStroke.Thickness = 1
TitleStroke.Transparency = 0.3
TitleStroke.Parent = TitleLabel

-- Minimize Button
local Minimized = false
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Parent = TitleLabel

-- Rounded Corners for MinimizeButton
local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Border for MinimizeButton
local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
MinimizeStroke.Thickness = 1
MinimizeStroke.Transparency = 0.5
MinimizeStroke.Parent = MinimizeButton

-- Functions Frame
local FunctionsFrame = Instance.new("Frame")
FunctionsFrame.Size = UDim2.new(1, -10, 1, -50)
FunctionsFrame.Position = UDim2.new(0, 5, 0, 45)
FunctionsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
FunctionsFrame.BorderSizePixel = 0
FunctionsFrame.Parent = MainFrame

-- Rounded Corners for FunctionsFrame
local FunctionsCorner = Instance.new("UICorner")
FunctionsCorner.CornerRadius = UDim.new(0, 10)
FunctionsCorner.Parent = FunctionsFrame

-- Scrolling Frame for Player List
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.5, -10, 0, 460)
PlayerListFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
PlayerListFrame.ScrollBarThickness = 5
PlayerListFrame.Parent = FunctionsFrame

-- Rounded Corners for PlayerListFrame
local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 8)
PlayerListCorner.Parent = PlayerListFrame

-- UI List Layout for Player Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Notification Label for Kick and Kill All Feedback
local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Size = UDim2.new(0.5, -10, 0, 35)
NotificationLabel.Position = UDim2.new(0.5, 5, 0, 500) -- Adjusted position
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Text = ""
NotificationLabel.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
NotificationLabel.TextSize = 12
NotificationLabel.Font = Enum.Font.SourceSans
NotificationLabel.Parent = FunctionsFrame
NotificationLabel.Visible = false

-- Made by Label
local MadeByLabel = Instance.new("TextLabel")
MadeByLabel.Size = UDim2.new(1, -10, 0, 30)
MadeByLabel.Position = UDim2.new(0, 5, 1, -35)
MadeByLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
MadeByLabel.Text = "Made by: DdeM3zz"
MadeByLabel.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
MadeByLabel.TextSize = 14
MadeByLabel.Font = Enum.Font.SourceSans
MadeByLabel.Parent = MainFrame

-- Rounded Corners for MadeByLabel
local MadeByCorner = Instance.new("UICorner")
MadeByCorner.CornerRadius = UDim.new(0, 8)
MadeByCorner.Parent = MadeByLabel

-- Button Creation Function
local function CreateButton(name, parent, size, position, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = size
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.Parent = parent
    Button.MouseButton1Click:Connect(callback)

    -- Rounded Corners for Button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button

    -- Border for Button
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.5
    ButtonStroke.Parent = Button

    -- Hover Effect
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
        Button.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
        Button.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black
    end)

    return Button
end

-- Minimize/Maximize Function
local function ToggleMinimize()
    Minimized = not Minimized
    if Minimized then
        MainFrame.Size = UDim2.new(0, 500, 0, 40)
        FunctionsFrame.Visible = false
        MadeByLabel.Visible = false -- Hide when minimized
        MinimizeButton.Text = "+"
        MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    else
        MainFrame.Size = UDim2.new(0, 500, 0, 600)
        FunctionsFrame.Visible = true
        MadeByLabel.Visible = true -- Show when maximized
        MinimizeButton.Text = "-"
        MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    end
end

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

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

local function TeleportToHighestPoint()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local highestY = -math.huge
        local highestPos = nil
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Position.Y > highestY then
                highestY = part.Position.Y
                highestPos = part.Position
            end
        end
        if highestPos then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(highestPos + Vector3.new(0, 5, 0))
        end
    end
end

-- Kill All Function (Improved)
local function KillAll()
    NotificationLabel.Text = "Kill All attempted"
    NotificationLabel.Visible = true
    local success = false
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Attempt multiple times to bypass server sync
                    for _ = 1, 5 do
                        humanoid.Health = 0
                        player.Character:BreakJoints()
                        wait(0.1)
                    end
                    success = true
                end
                -- Try to find and fire RemoteEvents for damage
                for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("damage") or remote.Name:lower():find("hit") or remote.Name:lower():find("kill")) then
                        pcall(function()
                            remote:FireServer({Target = player.Character.Humanoid, Damage = math.huge})
                        end)
                    end
                end
                for _, remote in ipairs(workspace:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (remote.Name:lower():find("damage") or remote.Name:lower():find("hit") or remote.Name:lower():find("kill")) then
                        pcall(function()
                            remote:FireServer({Target = player.Character.Humanoid, Damage = math.huge})
                        end)
                    end
                end
            end
        end
    end)
    if not success then
        NotificationLabel.Text = "Kill All failed: Server restrictions"
    end
    wait(3)
    NotificationLabel.Visible = false
end

-- Kill Player Function
local function KillPlayer(targetPlayer)
    if targetPlayer ~= LocalPlayer and targetPlayer.Character then
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
        targetPlayer.Character:BreakJoints() -- Fallback to ensure kill
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
                box.Color3 = Color3.fromRGB(0, 150, 255) -- Blue
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

-- Infinite Jump Variables and Function
local InfiniteJumpEnabled = false

local function ToggleInfiniteJump()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
end

-- Auto-Respawn Variables and Function
local AutoRespawnEnabled = false
local AutoRespawnConnection = nil

local function ToggleAutoRespawn()
    AutoRespawnEnabled = not AutoRespawnEnabled
    if AutoRespawnEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            AutoRespawnConnection = humanoid.Died:Connect(function()
                LocalPlayer.Character:BreakJoints() -- Ensure death
                wait(0.1) -- Brief delay
                LocalPlayer:LoadCharacter() -- Respawn
            end)
        end
    else
        if AutoRespawnConnection then
            AutoRespawnConnection:Disconnect()
            AutoRespawnConnection = nil
        end
    end
end

-- Kick Player Function with Notification
local function KickPlayer(targetPlayer)
    if targetPlayer ~= LocalPlayer then
        NotificationLabel.Text = "Kick attempted on " .. targetPlayer.Name
        NotificationLabel.Visible = true
        pcall(function()
            targetPlayer:Kick("Kicked by AMM Admin")
        end, function(err)
            NotificationLabel.Text = "Kick failed: Server restrictions"
        end)
        wait(3)
        NotificationLabel.Visible = false
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

-- Update Player List with Toggleable Action Menu
local CurrentActionFrame = nil
local CurrentSelectedPlayer = nil

local function UpdatePlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(1, -10, 0, 35)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black
            PlayerButton.TextSize = 14
            PlayerButton.Font = Enum.Font.SourceSans
            PlayerButton.Parent = PlayerListFrame
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = PlayerButton
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
            ButtonStroke.Thickness = 1
            ButtonStroke.Transparency = 0.5
            ButtonStroke.Parent = PlayerButton
            PlayerButton.MouseButton1Click:Connect(function()
                if CurrentSelectedPlayer == player and CurrentActionFrame then
                    -- Close the menu if clicking the same player
                    CurrentActionFrame:Destroy()
                    CurrentActionFrame = nil
                    CurrentSelectedPlayer = nil
                else
                    -- Close existing menu if open
                    if CurrentActionFrame then
                        CurrentActionFrame:Destroy()
                        CurrentActionFrame = nil
                    end
                    -- Open new menu for selected player
                    CurrentSelectedPlayer = player
                    CurrentActionFrame = Instance.new("Frame")
                    CurrentActionFrame.Size = UDim2.new(0.5, -10, 0, 150)
                    CurrentActionFrame.Position = UDim2.new(0.5, 5, 0, 320) -- Adjusted position
                    CurrentActionFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
                    CurrentActionFrame.Parent = FunctionsFrame
                    local ActionCorner = Instance.new("UICorner")
                    ActionCorner.CornerRadius = UDim.new(0, 8)
                    ActionCorner.Parent = CurrentActionFrame

                    CreateButton("TeleportBehind", CurrentActionFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 5), "Teleport Behind", function()
                        TeleportBehind(player)
                    end)

                    CreateButton("TeleportTo", CurrentActionFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 40), "Teleport To", function()
                        TeleportToPlayer(player)
                    end)

                    CreateButton("KillPlayer", CurrentActionFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 75), "Kill", function()
                        KillPlayer(player)
                    end)

                    CreateButton("KickPlayer", CurrentActionFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 110), "Kick", function()
                        KickPlayer(player)
                    end)
                end
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- GUI Buttons and Inputs (Two Columns, Top-Right, Increased Spacing)
-- Left Column
CreateButton("KillAll", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.5, 5, 0, 5), "Kill All", KillAll)
CreateButton("ToggleFlight", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.5, 5, 0, 50), "Toggle Flight", ToggleFlight)
CreateButton("ToggleNoclip", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.5, 5, 0, 95), "Toggle Noclip", ToggleNoclip)
CreateButton("ToggleInfiniteJump", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.5, 5, 0, 140), "Toggle Inf Jump", ToggleInfiniteJump)

-- Right Column
CreateButton("ToggleESP", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.75, -5, 0, 5), "Toggle ESP", ToggleESP)
CreateButton("ToggleGodMode", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.75, -5, 0, 50), "Toggle God Mode", ToggleGodMode)
CreateButton("ToggleAutoRespawn", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.75, -5, 0, 95), "Toggle Auto-Respawn", ToggleAutoRespawn)
CreateButton("TeleportUp", FunctionsFrame, UDim2.new(0.25, -10, 0, 35), UDim2.new(0.75, -5, 0, 140), "Teleport Up", TeleportToHighestPoint)

-- Speed Hack Input
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.5, -10, 0, 35)
SpeedInput.Position = UDim2.new(0.5, 5, 0, 190) -- Adjusted position
SpeedInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
SpeedInput.Text = "16" -- Default walk speed
SpeedInput.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
SpeedInput.TextSize = 14
SpeedInput.Font = Enum.Font.SourceSans
SpeedInput.Parent = FunctionsFrame

-- Rounded Corners for SpeedInput
local SpeedInputCorner = Instance.new("UICorner")
SpeedInputCorner.CornerRadius = UDim.new(0, 10)
SpeedInputCorner.Parent = SpeedInput

-- Border for SpeedInput
local SpeedInputStroke = Instance.new("UIStroke")
SpeedInputStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
SpeedInputStroke.Thickness = 1
SpeedInputStroke.Transparency = 0.5
SpeedInputStroke.Parent = SpeedInput

-- Apply Speed Button
CreateButton("ApplySpeed", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 235), "Apply Speed", function()
    ApplySpeed(SpeedInput.Text)
end)

-- Input Handling for Flight, Teleport, and Infinite Jump
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
        elseif input.KeyCode == Enum.KeyCode.Space and InfiniteJumpEnabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
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
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
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
        box.Color3 = Color3.fromRGB(0, 150, 255) -- Blue
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

-- Character Added for Auto-Respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    if AutoRespawnEnabled then
        local humanoid = character:WaitForChild("Humanoid")
        AutoRespawnConnection = humanoid.Died:Connect(function()
            LocalPlayer.Character:BreakJoints() -- Ensure death
            wait(0.1) -- Brief delay
            LocalPlayer:LoadCharacter() -- Respawn
        end)
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
