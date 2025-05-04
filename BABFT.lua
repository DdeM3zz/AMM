local Player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoatTeleportUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 200) 
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = '<font color="rgb(255,255,255)">BABFT </font><font color="rgb(255,255,255)">A</font><font color="rgb(0,170,255)">MM</font>'
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.RichText = true  
Title.Parent = Frame

local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Size = UDim2.new(0.9, 0, 0, 30)
AutoFarmButton.Position = UDim2.new(0.05, 0, 0, 40)
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.Text = "AutoFarm: OFF"
AutoFarmButton.Font = Enum.Font.SourceSans
AutoFarmButton.TextSize = 16
AutoFarmButton.Parent = Frame

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.9, 0, 0, 30)
FlyButton.Position = UDim2.new(0.05, 0, 0, 80)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Text = "Fly: OFF"
FlyButton.Font = Enum.Font.SourceSans
FlyButton.TextSize = 16
FlyButton.Parent = Frame

local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.9, 0, 0, 30)
NoclipButton.Position = UDim2.new(0.05, 0, 0, 120)
NoclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.Font = Enum.Font.SourceSans
NoclipButton.TextSize = 16
NoclipButton.Parent = Frame

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 0, 160)
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(255, 255, 255)
Footer.Text = '<font color="rgb(255,255,255)">A</font><font color="rgb(0,170,255)">MM</font> Hub 2025'
Footer.Font = Enum.Font.SourceSans
Footer.TextSize = 14
Footer.RichText = true
Footer.Parent = Frame

local function Notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "BABFT Script",
            Text = text,
            Duration = 5
        })
    end)
end

Notify("Boat Teleport Script Loaded!")

local AutoFarmEnabled = false
local CurrentStage = 1
local StagesCompleted = 0
local TotalStages = 10

local FlyEnabled = false
local FlySpeed = 50 
local Camera = Workspace.CurrentCamera

local NoclipEnabled = false

local function CreateTempPlatform(Position)
    local Platform = Instance.new("Part")
    Platform.Size = Vector3.new(10, 1, 10)
    Platform.Position = Position - Vector3.new(0, 2, 0) 
    Platform.Anchored = true
    Platform.CanCollide = true 
    Platform.Transparency = 1  
    Platform.Parent = Workspace

    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.Face = Enum.NormalId.Top
    SurfaceGui.Parent = Platform
    SurfaceGui.AlwaysOnTop = true

    local LogoLabel = Instance.new("TextLabel")
    LogoLabel.Size = UDim2.new(1, 0, 1, 0)
    LogoLabel.BackgroundTransparency = 1
    LogoLabel.Text = "BABFT AMM"
    LogoLabel.Font = Enum.Font.SourceSansBold
    LogoLabel.TextSize = 100 
    LogoLabel.TextTransparency = 0
    LogoLabel.Parent = SurfaceGui

    LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoLabel.RichText = true
    LogoLabel.Text = '<font color="rgb(255,255,255)">BABFT </font><font color="rgb(255,255,255)">A</font><font color="rgb(0,170,255)">MM</font>'

    spawn(function()
        task.wait(3)
        Platform:Destroy()
    end)
end

local function AutoFarm()
    if not AutoFarmEnabled then return end

    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
        Notify("Waiting for character to respawn...")
        return
    end

    if CurrentStage <= TotalStages then
        local StageName = "CaveStage" .. CurrentStage
        local Stage = Workspace.BoatStages.NormalStages:FindFirstChild(StageName)
        if Stage then
            local SandBlock = Stage:FindFirstChild("Sand")
            if SandBlock and SandBlock:IsA("BasePart") then
                local TeleportPosition = SandBlock.Position + Vector3.new(0, 25, 0)  
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportPosition)
                CreateTempPlatform(TeleportPosition)  
                Notify("Teleported to " .. StageName .. "!")
                StagesCompleted = StagesCompleted + 1
                CurrentStage = CurrentStage + 1
                task.wait(2)
            else
                Notify("Sand block not found in " .. StageName .. "!")
            end
        else
            Notify("Stage " .. StageName .. " not found!")
        end
    else
        local TheEnd = Workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
        if TheEnd then
            local function FindGoldenChest(obj)
                for _, child in ipairs(obj:GetDescendants()) do
                    if child.Name == "GoldenChest" and child:IsA("Model") then
                        local triggerPart = child:FindFirstChild("Trigger")
                        if triggerPart and triggerPart:IsA("BasePart") then
                            return triggerPart
                        end
                    end
                end
                return nil
            end

            local TriggerPart = FindGoldenChest(TheEnd)
            if TriggerPart then
                local TeleportPosition = TriggerPart.Position + Vector3.new(0, 15, 0) 
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportPosition)
                -- Platform is not created for GoldenChest
                Notify("Teleported to GoldenChest Trigger!")
                AutoFarmEnabled = false  -- Temporarily disable AutoFarm
                Notify("Waiting for player death and respawn...")
                task.wait(10)  -- Initial 10-second delay after teleport
                Player.CharacterRemoving:Wait() 
                local newCharacter = Player.CharacterAdded:Wait()  
                task.wait(3)  -- Delay 3 seconds after respawn
                if AutoFarmButton then
                    AutoFarmEnabled = true 
                    AutoFarmButton.Text = "AutoFarm: ON"
                    Notify("AutoFarm sequence resumed!")
                    CurrentStage = 1 
                    StagesCompleted = 0  
                    spawn(StartAutoFarmLoop) 
                end
            else
                Notify("Trigger not found in GoldenChest!")
            end
        else
            Notify("TheEnd not found!")
        end
    end
end

local function StartAutoFarmLoop()
    while AutoFarmEnabled do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            if StagesCompleted < TotalStages then
                AutoFarm()
            elseif StagesCompleted == TotalStages then
                AutoFarm()
            end
        else
            task.wait(0.1) 
        end
    end
end

-- Fly logic
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

            -- Movement based on camera direction
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

AutoFarmButton.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    AutoFarmButton.Text = "AutoFarm: " .. (AutoFarmEnabled and "ON" or "OFF")
    if AutoFarmEnabled then
        spawn(StartAutoFarmLoop)
        Notify("AutoFarm sequence started!")
    else
        Notify("AutoFarm sequence stopped!")
    end
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

Player.CharacterAdded:Connect(function()
    if AutoFarmEnabled then
        spawn(StartAutoFarmLoop)
        Notify("Character respawned, restarting AutoFarm sequence!")
    end
    if FlyEnabled then
        StartFlying()
        Notify("Character respawned, fly mode re-enabled!")
    end
    if NoclipEnabled then
        StartNoclip()
        Notify("Character respawned, noclip mode re-enabled!")
    end
end)
