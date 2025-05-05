local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoatTeleportUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 270)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = '<font color="rgb(255,255,255)">Panel </font><font color="rgb(255,255,255)">A</font><font color="rgb(0,191,255)">MM</font>'
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.RichText = true
Title.Parent = Frame

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.9, 0, 0, 30)
FlyButton.Position = UDim2.new(0.05, 0, 0, 40)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Text = "Fly: OFF"
FlyButton.Font = Enum.Font.SourceSans
FlyButton.TextSize = 16
FlyButton.Parent = Frame

local DecreaseSpeedButton = Instance.new("TextButton")
DecreaseSpeedButton.Size = UDim2.new(0.2, 0, 0, 30)
DecreaseSpeedButton.Position = UDim2.new(0.05, 0, 0, 80)
DecreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DecreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseSpeedButton.Text = "−"
DecreaseSpeedButton.Font = Enum.Font.SourceSans
DecreaseSpeedButton.TextSize = 16
DecreaseSpeedButton.Parent = Frame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.5, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0.25, 0, 0, 80)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Text = "Speed: 50"
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 16
SpeedLabel.Parent = Frame

local IncreaseSpeedButton = Instance.new("TextButton")
IncreaseSpeedButton.Size = UDim2.new(0.2, 0, 0, 30)
IncreaseSpeedButton.Position = UDim2.new(0.75, 0, 0, 80)
IncreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IncreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseSpeedButton.Text = "+"
IncreaseSpeedButton.Font = Enum.Font.SourceSans
IncreaseSpeedButton.TextSize = 16
IncreaseSpeedButton.Parent = Frame

local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.9, 0, 0, 30)
NoclipButton.Position = UDim2.new(0.05, 0, 0, 120)
NoclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.Font = Enum.Font.SourceSans
NoclipButton.TextSize = 16
NoclipButton.Parent = Frame

local SuperRingButton = Instance.new("TextButton")
SuperRingButton.Size = UDim2.new(0.9, 0, 0, 30)
SuperRingButton.Position = UDim2.new(0.05, 0, 0, 160)
SuperRingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SuperRingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SuperRingButton.Text = "Super Ring: OFF"
SuperRingButton.Font = Enum.Font.SourceSans
SuperRingButton.TextSize = 16
SuperRingButton.Parent = Frame

local GodModeButton = Instance.new("TextButton")
GodModeButton.Size = UDim2.new(0.9, 0, 0, 30)
GodModeButton.Position = UDim2.new(0.05, 0, 0, 200)
GodModeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeButton.Text = "God Mode: OFF"
GodModeButton.Font = Enum.Font.SourceSans
GodModeButton.TextSize = 16
GodModeButton.Parent = Frame

local PlayerListGui = Instance.new("ScreenGui")
PlayerListGui.Name = "PlayerListUI"
PlayerListGui.Parent = Player:WaitForChild("PlayerGui")
PlayerListGui.ResetOnSpawn = false

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(0, 150, 0, 200)
PlayerListFrame.Position = UDim2.new(0, 220, 0, 10)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Parent = PlayerListGui

local PlayerListTitle = Instance.new("TextLabel")
PlayerListTitle.Size = UDim2.new(1, 0, 0, 30)
PlayerListTitle.Position = UDim2.new(0, 0, 0, 0)
PlayerListTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerListTitle.Text = "Players"
PlayerListTitle.Font = Enum.Font.SourceSansBold
PlayerListTitle.TextSize = 18
PlayerListTitle.Parent = PlayerListFrame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 150)
PlayerList.Position = UDim2.new(0.05, 0, 0, 40)
PlayerList.BackgroundTransparency = 1
PlayerList.ScrollBarThickness = 5
PlayerList.Parent = PlayerListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = PlayerList

local function updatePlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(1, 0, 0, 30)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.Text = otherPlayer.Name
            PlayerButton.Font = Enum.Font.SourceSans
            PlayerButton.TextSize = 16
            PlayerButton.Parent = PlayerList

            PlayerButton.MouseButton1Click:Connect(function()
                local character = Player.Character
                local otherCharacter = otherPlayer.Character
                if character and otherCharacter then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local otherHumanoidRootPart = otherCharacter:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart and otherHumanoidRootPart then
                        humanoidRootPart.CFrame = otherHumanoidRootPart.CFrame + Vector3.new(0, 0, 2)
                        Notify("Teleported to " .. otherPlayer.Name)
                    end
                end
            end)
        end
    end

    PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

local PlayerListDragging = false
local PlayerListDragStart, PlayerListStartPos

PlayerListFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        PlayerListDragging = true
        PlayerListDragStart = input.Position
        PlayerListStartPos = PlayerListFrame.Position
    end
end)

PlayerListFrame.InputChanged:Connect(function(input)
    if PlayerListDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = input.Position - PlayerListDragStart
        PlayerListFrame.Position = UDim2.new(PlayerListStartPos.X.Scale, PlayerListStartPos.X.Offset + Delta.X, PlayerListStartPos.Y.Scale, PlayerListStartPos.Y.Offset + Delta.Y)
    end
end)

PlayerListFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        PlayerListDragging = false
    end
end)

local function Notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Panel Script",
            Text = text,
            Duration = 5
        })
    end)
end

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

Notify("Panel Script Loaded!")

local FlyEnabled = false
local FlySpeed = 50
local NoclipEnabled = false
local SuperRingEnabled = false
local GodModeEnabled = false
local godModeConnection = nil

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }

    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        Player.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(Player, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function hasVehicleSeatOrSeat(model)
    if not model then return false end
    for _, descendant in pairs(model:GetDescendants()) do
        if descendant:IsA("VehicleSeat") or descendant.Name == "Seat" then
            return true
        end
    end
    return false
end

local function ForcePart(v)
    local parentModel = v.Parent
    while parentModel and not parentModel:IsA("Model") do
        parentModel = parentModel.Parent
    end
    if parentModel and hasVehicleSeatOrSeat(parentModel) then
        return
    end

    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = 9999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local function RetainPart(Part)
    local parentModel = Part.Parent
    while parentModel and not parentModel:IsA("Model") do
        parentModel = parentModel.Parent
    end
    if parentModel and hasVehicleSeatOrSeat(parentModel) then
        return false
    end

    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(Workspace) then
        if Part.Parent == Player.Character or Part:IsDescendantOf(Player.Character) then
            return false
        end
        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        Part.CanCollide = false
        return true
    end
    return false
end

local radius = 50
local height = 100
local rotationSpeed = 1
local attractionStrength = 1000
local parts = {}

local function addPart(part)
    if part:IsA("BasePart") and not part.Anchored and not table.find(parts, part) then
        table.insert(parts, part)
    end
end

local function removePart(part)
    local index = table.find(parts, part)
    if index then
        table.remove(parts, index)
    end
end

for _, part in pairs(Workspace:GetDescendants()) do
    addPart(part)
end

Workspace.DescendantAdded:Connect(addPart)
Workspace.DescendantRemoving:Connect(removePart)

local superRingConnection = nil
local function StartSuperRing()
    for _, part in pairs(parts) do
        if RetainPart(part) then
            ForcePart(part)
        end
    end

    if superRingConnection then
        superRingConnection:Disconnect()
    end
    superRingConnection = RunService.Heartbeat:Connect(function()
        if not SuperRingEnabled then return end
        local humanoidRootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local tornadoCenter = humanoidRootPart.Position
            for _, part in pairs(parts) do
                if part.Parent and not part.Anchored then
                    local pos = part.Position
                    local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                    local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                    local newAngle = angle + math.rad(rotationSpeed)
                    local targetPos = Vector3.new(
                        tornadoCenter.X + math.cos(newAngle) * math.min(radius, distance),
                        tornadoCenter.Y + (height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / height)))),
                        tornadoCenter.Z + math.sin(newAngle) * math.min(radius, distance)
                    )
                    local directionToTarget = (targetPos - part.Position).Unit
                    part.Velocity = directionToTarget * attractionStrength
                end
            end
        end
    end)
end

local function StopSuperRing()
    if superRingConnection then
        superRingConnection:Disconnect()
        superRingConnection = nil
    end
    for _, part in pairs(parts) do
        if part.Parent then
            part.CanCollide = true
        end
    end
end

local function StartFlying()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("Humanoid") or not Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local Humanoid = Character.Humanoid
    local RootPart = Character.HumanoidRootPart
    Humanoid.PlatformStand = true

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart

    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Parent = RootPart

    spawn(function()
        while FlyEnabled and Character and Character.Parent and RootPart.Parent do
            local CameraCFrame = Camera.CFrame
            local MoveDirection = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                MoveDirection = MoveDirection + CameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                MoveDirection = MoveDirection - CameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                MoveDirection = MoveDirection - CameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                MoveDirection = MoveDirection + CameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
            end

            if MoveDirection.Magnitude > 0 then
                MoveDirection = MoveDirection.Unit * FlySpeed
            end
            BodyVelocity.Velocity = MoveDirection

            BodyGyro.CFrame = CFrame.new(RootPart.Position, RootPart.Position + CameraCFrame.LookVector)

            task.wait()
        end

        if BodyVelocity then
            BodyVelocity:Destroy()
        end
        if BodyGyro then
            BodyGyro:Destroy()
        end
        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end)
end

local function StartNoclip()
    spawn(function()
        while NoclipEnabled and Player.Character do
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            task.wait(0.1)
        end

        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

local function StartGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            godModeConnection = humanoid.HealthChanged:Connect(function(health)
                if GodModeEnabled and health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
    end
end

local function StopGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

DecreaseSpeedButton.MouseButton1Click:Connect(function()
    FlySpeed = math.max(10, FlySpeed - 10)
    SpeedLabel.Text = "Speed: " .. FlySpeed
    Notify("Fly Speed decreased to " .. FlySpeed)
end)

IncreaseSpeedButton.MouseButton1Click:Connect(function()
    FlySpeed = math.min(200, FlySpeed + 10)
    SpeedLabel.Text = "Speed: " .. FlySpeed
    Notify("Fly Speed increased to " .. FlySpeed)
end)

FlyButton.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyButton.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
    if FlyEnabled then
        Notify("Fly mode enabled! Use WASD to move, E to go up, Q to go down.")
        StartFlying()
    else
        Notify("Fly mode disabled!")
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipButton.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
    if NoclipEnabled then
        Notify("Noclip mode enabled!")
        StartNoclip()
    else
        Notify("Noclip mode disabled!")
    end
end)

SuperRingButton.MouseButton1Click:Connect(function()
    SuperRingEnabled = not SuperRingEnabled
    SuperRingButton.Text = "Super Ring: " .. (SuperRingEnabled and "ON" or "OFF")
    if SuperRingEnabled then
        Notify("Super Ring v4.1 enabled!")
        playSound("12221967")
        StartSuperRing()
    else
        Notify("Super Ring v4.1 disabled!")
        playSound("12221967")
        StopSuperRing()
    end
end)

GodModeButton.MouseButton1Click:Connect(function()
    GodModeEnabled = not GodModeEnabled
    GodModeButton.Text = "God Mode: " .. (GodModeEnabled and "ON" or "OFF")
    if GodModeEnabled then
        Notify("God Mode enabled!")
        StartGodMode()
    else
        Notify("God Mode disabled!")
        StopGodMode()
    end
end)

local Dragging = false
local DragStart, StartPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = input.Position - DragStart
        Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

Player.CharacterAdded:Connect(function(character)
    if FlyEnabled then
        StartFlying()
        Notify("Character respawned, fly mode re-enabled!")
    end
    if NoclipEnabled then
        StartNoclip()
        Notify("Character respawned, noclip mode re-enabled!")
    end
    if SuperRingEnabled then
        StartSuperRing()
        Notify("Character respawned, Super Ring v4.1 re-enabled!")
    end
    if GodModeEnabled then
        StartGodMode()
        Notify("Character respawned, God Mode re-enabled!")
    end
end)

playSound("2865227271")
