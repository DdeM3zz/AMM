-- MenuAMM: Admin Panel Script for Roblox using Xeno Executor
-- Features: Teleportation, Kill All, Flight, Noclip, ESP, Speed Hack, God Mode, Kick Player, Infinite Jump, Teleport Up, Kill Player, Auto-Respawn, Harass (fixed), Spin Player (fixed), Explode Player, Gravity Hack, Random Teleport
-- GUI: Wider (600x600), black/blue theme (Color3.fromRGB(0, 0, 0) and Color3.fromRGB(0, 150, 255)), three-column button layout, toggleable action menu, 10px button spacing, MadeByLabel hidden when minimized, Made by: DdeM3zz
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

-- Main Frame (Draggable, Widened)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 600)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -300)
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

-- Notification Label for Kick, Kill All, Random Teleport Feedback
local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Size = UDim2.new(0.5, -10, 0, 35)
NotificationLabel.Position = UDim2.new(0.5, 5, 0, 565)
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
        MainFrame.Size = UDim2.new(0, 600, 0, 40)
        FunctionsFrame.Visible = false
        MadeByLabel.Visible = false -- Hide when minimized
        MinimizeButton.Text = "+"
        MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    else
        MainFrame.Size = UDim2.new(0, 600, 0, 600)
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

-- Kill All Function
local function KillAll()
    NotificationLabel.Text = "Kill All attempted"
    NotificationLabel.Visible = true
    local success = false
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    for _ = 1, 5 do
                        humanoid.Health = 0
                        player.Character:BreakJoints()
                        wait(0.1)
                    end
                    success = true
                end
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
        targetPlayer.Character:BreakJoints()
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
                LocalPlayer.Character:BreakJoints()
                wait(0.1)
                LocalPlayer:LoadCharacter()
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

-- Harass Variables and Function (Fixed)
local HarassEnabled = {}
local HarassConnections = {} -- Store connections for cleanup

local function ToggleHarass(targetPlayer, harassButton)
    if HarassEnabled[targetPlayer] then
        HarassEnabled[targetPlayer] = false
        if HarassConnections[targetPlayer] then
            HarassConnections[targetPlayer]:Disconnect()
            HarassConnections[targetPlayer] = nil
        end
        harassButton.Text = "Toggle Harass"
    else
        HarassEnabled[targetPlayer] = true
        harassButton.Text = "Stop Harass"
        local connection = RunService.Heartbeat:Connect(function()
            if not HarassEnabled[targetPlayer] or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                HarassEnabled[targetPlayer] = false
                harassButton.Text = "Toggle Harass"
                if HarassConnections[targetPlayer] then
                    HarassConnections[targetPlayer]:Disconnect()
                    HarassConnections[targetPlayer] = nil
                end
                return
            end
            local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            local behindPos = targetCFrame * CFrame.new(0, 0, 3) -- 3 studs behind
            LocalPlayer.Character.HumanoidRootPart.CFrame = behindPos
            wait(0.2)
            if HarassEnabled[targetPlayer] then
                targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                local forwardPos = targetCFrame * CFrame.new(0, 0, 2) -- 2 studs behind
                LocalPlayer.Character.HumanoidRootPart.CFrame = forwardPos
            end
        end)
        HarassConnections[targetPlayer] = connection
    end
end

-- Spin Player Variables and Function (Fixed)
local Spinning = false
local SpinSpeed = 50
local BodyAngularVelocity = nil
local TouchConnections = {}
local LastFlingTimes = {} -- Debounce for flinging

local function ToggleSpin(spinButton)
    Spinning = not Spinning
    if Spinning then
        spinButton.Text = "Stop Spin"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            BodyAngularVelocity = Instance.new("BodyAngularVelocity")
            BodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
            BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
            BodyAngularVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local connection = part.Touched:Connect(function(hit)
                        if Spinning then
                            local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
                            if otherPlayer and otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local currentTime = tick()
                                if not LastFlingTimes[otherPlayer] or (currentTime - LastFlingTimes[otherPlayer] > 1) then
                                    LastFlingTimes[otherPlayer] = currentTime
                                    local direction = (hit.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
                                    local flingVelocity = direction * math.min(SpinSpeed * 10, 5000)
                                    local bv = Instance.new("BodyVelocity")
                                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bv.Velocity = flingVelocity
                                    bv.Parent = otherPlayer.Character.HumanoidRootPart
                                    spawn(function()
                                        wait(0.1)
                                        if bv then bv:Destroy() end
                                    end)
                                end
                            end
                        end
                    end)
                    table.insert(TouchConnections, connection)
                end
            end
        end
    else
        spinButton.Text = "Toggle Spin"
        if BodyAngularVelocity then
            BodyAngularVelocity:Destroy()
            BodyAngularVelocity = nil
        end
        for _, connection in pairs(TouchConnections) do
            connection:Disconnect()
        end
        TouchConnections = {}
        LastFlingTimes = {}
    end
end

local function ApplySpinSpeed(speedText)
    local speed = tonumber(speedText)
    if speed and speed >= 0 and speed <= 500 then
        SpinSpeed = speed
        if Spinning and BodyAngularVelocity then
            BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
        end
    end
end

-- Explode Player Variables and Function
local Exploding = false
local ExplodeConnections = {}

local function ToggleExplode(explodeButton)
    Exploding = not Exploding
    if Exploding then
        explodeButton.Text = "Stop Explode"
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local connection = part.Touched:Connect(function(hit)
                        if Exploding then
                            local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
                            if otherPlayer and otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local explosion = Instance.new("Explosion")
                                explosion.Position = otherPlayer.Character.HumanoidRootPart.Position
                                explosion.BlastRadius = 5
                                explosion.BlastPressure = 0 -- Visual only
                                explosion.Parent = workspace
                                local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                                if humanoid then
                                    humanoid.Health = 0
                                end
                                otherPlayer.Character:BreakJoints()
                            end
                        end
                    end)
                    table.insert(ExplodeConnections, connection)
                end
            end
        end
    else
        explodeButton.Text = "Toggle Explode"
        for _, connection in pairs(ExplodeConnections) do
            connection:Disconnect()
        end
        ExplodeConnections = {}
    end
end

-- Gravity Hack Variables and Function
local GravityEnabled = false
local GravityValue = 196.2 -- Default Roblox gravity
local BodyForce = nil

local function ToggleGravity(gravityButton)
    GravityEnabled = not GravityEnabled
    if GravityEnabled then
        gravityButton.Text = "Stop Gravity"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            BodyForce = Instance.new("BodyForce")
            BodyForce.Force = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart:GetMass() * (196.2 - GravityValue), 0)
            BodyForce.Parent = LocalPlayer.Character.HumanoidRootPart
        end
    else
        gravityButton.Text = "Toggle Gravity"
        if BodyForce then
            BodyForce:Destroy()
            BodyForce = nil
        end
    end
end

local function ApplyGravity(gravityText)
    local gravity = tonumber(gravityText)
    if gravity and gravity >= 10 and gravity <= 196.2 then
        GravityValue = gravity
        if GravityEnabled and BodyForce and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            BodyForce.Force = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart:GetMass() * (196.2 - GravityValue), 0)
        end
    end
end

-- Random Teleport Function
local LastRandomTeleport = 0
local function RandomTeleport()
    local currentTime = tick()
    if currentTime - LastRandomTeleport < 5 then
        NotificationLabel.Text = "Random Teleport on cooldown"
        NotificationLabel.Visible = true
        wait(3)
        NotificationLabel.Visible = false
        return
    end
    LastRandomTeleport = currentTime
    NotificationLabel.Text = "Random Teleport executed"
    NotificationLabel.Visible = true
    local minBounds, maxBounds = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            minBounds = Vector3.new(math.min(minBounds.X, part.Position.X), math.min(minBounds.Y, part.Position.Y), math.min(minBounds.Z, part.Position.Z))
            maxBounds = Vector3.new(math.max(maxBounds.X, part.Position.X), math.max(maxBounds.Y, part.Position.Y), math.max(maxBounds.Z, part.Position.Z))
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local randX = math.random(minBounds.X, maxBounds.X)
            local randZ = math.random(minBounds.Z, maxBounds.Z)
            local randY = maxBounds.Y + 5
            player.Character.HumanoidRootPart.CFrame = CFrame.new(randX, randY, randZ)
        end
    end
    wait(3)
    NotificationLabel.Visible = false
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
            PlayerButton.BackgroundColor3 = Color3.fromRGB midst(0, 150, 255) -- Blue
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
                    CurrentActionFrame:Destroy()
                    CurrentActionFrame = nil
                    CurrentSelectedPlayer = nil
                else
                    if CurrentActionFrame then
                        CurrentActionFrame:Destroy()
                        CurrentActionFrame = nil
                    end
                    CurrentSelectedPlayer = player
                    CurrentActionFrame = Instance.new("Frame")
                    CurrentActionFrame.Size = UDim2.new(0.5, -10, 0, 185)
                    CurrentActionFrame.Position = UDim2.new(0.5, 5, 0, 465)
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

                    local harassButton = CreateButton("ToggleHarass", CurrentActionFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 145), "Toggle Harass", function()
                        ToggleHarass(player, harassButton)
                    end)
                end
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- GUI Buttons and Inputs (Three Columns)
-- Left Column
CreateButton("KillAll", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.333, -155, 0, 5), "Kill All", KillAll)
CreateButton("ToggleFlight", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.333, -155, 0, 50), "Toggle Flight", ToggleFlight)
CreateButton("ToggleNoclip", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.333, -155, 0, 95), "Toggle Noclip", ToggleNoclip)
CreateButton("ToggleInfiniteJump", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.333, -155, 0, 140), "Toggle Inf Jump", ToggleInfiniteJump)

-- Middle Column
CreateButton("ToggleESP", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.667, -155, 0, 5), "Toggle ESP", ToggleESP)
CreateButton("ToggleGodMode", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.667, -155, 0, 50), "Toggle God Mode", ToggleGodMode)
CreateButton("ToggleAutoRespawn", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.667, -155, 0, 95), "Toggle Auto-Respawn", ToggleAutoRespawn)
CreateButton("TeleportUp", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(0.667, -155, 0, 140), "Teleport Up", TeleportToHighestPoint)

-- Right Column
local spinButton = CreateButton("ToggleSpin", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(1, -155, 0, 5), "Toggle Spin", function()
    ToggleSpin(spinButton)
end)
local explodeButton = CreateButton("ToggleExplode", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(1, -155, 0, 50), "Toggle Explode", function()
    ToggleExplode(explodeButton)
end)
local gravityButton = CreateButton("ToggleGravity", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(1, -155, 0, 95), "Toggle Gravity", function()
    ToggleGravity(gravityButton)
end)
CreateButton("RandomTeleport", FunctionsFrame, UDim2.new(0, 140, 0, 35), UDim2.new(1, -155, 0, 140), "Random Teleport", RandomTeleport)

-- Speed Hack Input
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.5, -10, 0, 35)
SpeedInput.Position = UDim2.new(0.5, 5, 0, 190)
SpeedInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
SpeedInput.Text = "16"
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
CreateButton("ApplySpeed", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 325), "Apply Speed", function()
    ApplySpeed(SpeedInput.Text)
end)

-- Spin Speed Input
local SpinSpeedInput = Instance.new("TextBox")
SpinSpeedInput.Size = UDim2.new(0.5, -10, 0, 35)
SpinSpeedInput.Position = UDim2.new(0.5, 5, 0, 235)
SpinSpeedInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
SpinSpeedInput.Text = "50"
SpinSpeedInput.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
SpinSpeedInput.TextSize = 14
SpinSpeedInput.Font = Enum.Font.SourceSans
SpinSpeedInput.Parent = FunctionsFrame

-- Rounded Corners for SpinSpeedInput
local SpinSpeedInputCorner = Instance.new("UICorner")
SpinSpeedInputCorner.CornerRadius = UDim.new(0, 10)
SpinSpeedInputCorner.Parent = SpinSpeedInput

-- Border for SpinSpeedInput
local SpinSpeedInputStroke = Instance.new("UIStroke")
SpinSpeedInputStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
SpinSpeedInputStroke.Thickness = 1
SpinSpeedInputStroke.Transparency = 0.5
SpinSpeedInputStroke.Parent = SpinSpeedInput

-- Apply Spin Speed Button
CreateButton("ApplySpinSpeed", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 370), "Apply Spin Speed", function()
    ApplySpinSpeed(SpinSpeedInput.Text)
end)

-- Gravity Input
local GravityInput = Instance.new("TextBox")
GravityInput.Size = UDim2.new(0.5, -10, 0, 35)
GravityInput.Position = UDim2.new(0.5, 5, 0, 280)
GravityInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
GravityInput.Text = "196.2"
GravityInput.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
GravityInput.TextSize = 14
GravityInput.Font = Enum.Font.SourceSans
GravityInput.Parent = FunctionsFrame

-- Rounded Corners for GravityInput
local GravityInputCorner = Instance.new("UICorner")
GravityInputCorner.CornerRadius = UDim.new(0, 10)
GravityInputCorner.Parent = GravityInput

-- Border for GravityInput
local GravityInputStroke = Instance.new("UIStroke")
GravityInputStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
GravityInputStroke.Thickness = 1
GravityInputStroke.Transparency = 0.5
GravityInputStroke.Parent = GravityInput

-- Apply Gravity Button
CreateButton("ApplyGravity", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 415), "Apply Gravity", function()
    ApplyGravity(GravityInput.Text)
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

-- Spin Update to Ensure Consistency
RunService.Stepped:Connect(function()
    if Spinning and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and BodyAngularVelocity then
        BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
    end
end)

-- ESP Update on Player Join/Leave
Players.PlayerAdded:Connect(function(player)
    wait(1)
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
    if HarassEnabled[player] then
        HarassEnabled[player] = false
        if HarassConnections[player] then
            HarassConnections[player]:Disconnect()
            HarassConnections[player] = nil
        end
    end
end)

-- Character Added for Auto-Respawn, Spin, Explode, Gravity
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5) -- Wait for character to load
    if AutoRespawnEnabled then
        local humanoid = character:WaitForChild("Humanoid")
        AutoRespawnConnection = humanoid.Died:Connect(function()
            LocalPlayer.Character:BreakJoints()
            wait(0.1)
            LocalPlayer:LoadCharacter()
        end)
    end
    if Spinning and character:FindFirstChild("HumanoidRootPart") then
        BodyAngularVelocity = Instance.new("BodyAngularVelocity")
        BodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
        BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
        BodyAngularVelocity.Parent = character.HumanoidRootPart
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                local connection = part.Touched:Connect(function(hit)
                    if Spinning then
                        local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
                        if otherPlayer and otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local currentTime = tick()
                            if not LastFlingTimes[otherPlayer] or (currentTime - LastFlingTimes[otherPlayer] > 1) then
                                LastFlingTimes[otherPlayer] = currentTime
                                local direction = (hit.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
                                local flingVelocity = direction * math.min(SpinSpeed * 10, 5000)
                                local bv = Instance.new("BodyVelocity")
                                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                bv.Velocity = flingVelocity
                                bv.Parent = otherPlayer.Character.HumanoidRootPart
                                spawn(function()
                                    wait(0.1)
                                    if bv then bv:Destroy() end
                                end)
                            end
                        end
                    end
                end)
                table.insert(TouchConnections, connection)
            end
        end
    end
    if Exploding and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                local connection = part.Touched:Connect(function(hit)
                    if Exploding then
                        local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
                        if otherPlayer and otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local explosion = Instance.new("Explosion")
                            explosion.Position = otherPlayer.Character.HumanoidRootPart.Position
                            explosion.BlastRadius = 5
                            explosion.BlastPressure = 0
                            explosion.Parent = workspace
                            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid.Health = 0
                            end
                            otherPlayer.Character:BreakJoints()
                        end
                    end
                end)
                table.insert(ExplodeConnections, connection)
            end
        end
    end
    if GravityEnabled and character:FindFirstChild("HumanoidRootPart") then
        BodyForce = Instance.new("BodyForce")
        BodyForce.Force = Vector3.new(0, character.HumanoidRootPart:GetMass() * (196.2 - GravityValue), 0)
        BodyForce.Parent = character.HumanoidRootPart
    end
end)

-- Initial Player List Update with Delay
spawn(function()
    wait(2)
    UpdatePlayerList()
end)

-- Flight Update Loop
RunService.RenderStepped:Connect(UpdateFlight)

-- Ensure GUI stays on top
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainFrame.ZIndex = 10
