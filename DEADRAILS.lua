local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimBotESPUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 240)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = '<font color="rgb(255,255,255)">Dead Rails </font><font color="rgb(255,255,255)">A</font><font color="rgb(0,191,255)">MM</font>'
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.RichText = true
Title.Parent = Frame

local AimBotButton = Instance.new("TextButton")
AimBotButton.Size = UDim2.new(0.9, 0, 0, 30)
AimBotButton.Position = UDim2.new(0.05, 0, 0, 40)
AimBotButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AimBotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBotButton.Text = "AimBot: OFF"
AimBotButton.Font = Enum.Font.SourceSans
AimBotButton.TextSize = 16
AimBotButton.Parent = Frame

local DecreaseDistanceButton = Instance.new("TextButton")
DecreaseDistanceButton.Size = UDim2.new(0.2, 0, 0, 30)
DecreaseDistanceButton.Position = UDim2.new(0.05, 0, 0, 80)
DecreaseDistanceButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DecreaseDistanceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseDistanceButton.Text = "−"
DecreaseDistanceButton.Font = Enum.Font.SourceSans
DecreaseDistanceButton.TextSize = 16
DecreaseDistanceButton.Parent = Frame

local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Size = UDim2.new(0.5, 0, 0, 30)
DistanceLabel.Position = UDim2.new(0.25, 0, 0, 80)
DistanceLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceLabel.Text = "Distance: 100"
DistanceLabel.Font = Enum.Font.SourceSans
DistanceLabel.TextSize = 16
DistanceLabel.Parent = Frame

local IncreaseDistanceButton = Instance.new("TextButton")
IncreaseDistanceButton.Size = UDim2.new(0.2, 0, 0, 30)
IncreaseDistanceButton.Position = UDim2.new(0.75, 0, 0, 80)
IncreaseDistanceButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IncreaseDistanceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseDistanceButton.Text = "+"
IncreaseDistanceButton.Font = Enum.Font.SourceSans
IncreaseDistanceButton.TextSize = 16
IncreaseDistanceButton.Parent = Frame

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.9, 0, 0, 30)
ESPButton.Position = UDim2.new(0.05, 0, 0, 120)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Text = "ESP: OFF"
ESPButton.Font = Enum.Font.SourceSans
ESPButton.TextSize = 16
ESPButton.Parent = Frame

local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.9, 0, 0, 30)
NoclipButton.Position = UDim2.new(0.05, 0, 0, 160)
NoclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.Font = Enum.Font.SourceSans
NoclipButton.TextSize = 16
NoclipButton.Parent = Frame

local function Notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "AimBot & ESP Script",
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

Notify("AimBot & ESP Script Loaded!")

local AimBotEnabled = false
local ESPEnabled = false
local NoclipEnabled = false
local NoclipConnection = nil
local Target = nil
local MaxDistance = 100
local ESPHighlights = {}
local ESPBillboards = {}
local LastTargetUpdate = 0
local TargetUpdateInterval = 0.1
local LastESPUpdate = 0
local ESPUpdateInterval = 1.5

local function FindTarget()
    local closestTarget = nil
    local minDistance = math.huge
    local playerPos = HumanoidRootPart.Position

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= Character then
            if obj.Name == "Model_Horse" or obj.Name == "Model_Unicorn" then
                print("Skipping " .. obj.Name .. " (excluded from aimbot)")
                continue
            end

            local humanoid = obj:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local isCorpse = false
                local parentFolder = obj
                while parentFolder do
                    if parentFolder.Name == "RuntimeItems" then
                        isCorpse = true
                        break
                    end
                    parentFolder = parentFolder.Parent
                end

                if not isCorpse then
                    local head = obj:FindFirstChild("Head")
                    if head and head:IsA("BasePart") then
                        local distance = (head.Position - playerPos).Magnitude
                        if distance < minDistance and distance < MaxDistance then
                            minDistance = distance
                            closestTarget = head
                            print("Found target: " .. obj.Name .. " at distance: " .. distance)
                        end
                    else
                        print("No Head found in " .. obj.Name)
                    end
                else
                    print("Skipping " .. obj.Name .. " (in RuntimeItems)")
                end
            end
        end
    end

    return closestTarget
end

local function UpdateAim()
    if not AimBotEnabled or not Character or not Character.Parent then return end

    local currentTime = tick()
    if currentTime - LastTargetUpdate >= TargetUpdateInterval then
        Target = FindTarget()
        LastTargetUpdate = currentTime
    end

    if Target then
        local cameraPos = HumanoidRootPart.Position + Vector3.new(0, 2, 0)
        local targetPos = Target.Position
        local distance = (targetPos - cameraPos).Magnitude
        if distance > MaxDistance then
            Target = nil
            Camera.CameraType = Enum.CameraType.Custom
            return
        end

        local newCFrame = CFrame.new(cameraPos, targetPos)
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.5)
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end

AimBotButton.MouseButton1Click:Connect(function()
    AimBotEnabled = not AimBotEnabled
    AimBotButton.Text = "AimBot: " .. (AimBotEnabled and "ON" or "OFF")
    if AimBotEnabled then
        Notify("AimBot enabled!")
        playSound("12221967")
        Camera.CameraType = Enum.CameraType.Scriptable
        RunService.RenderStepped:Connect(UpdateAim)
    else
        Notify("AimBot disabled!")
        playSound("12221967")
        Camera.CameraType = Enum.CameraType.Custom
        Target = nil
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X and not UserInputService:GetFocusedTextBox() then
        AimBotEnabled = not AimBotEnabled
        AimBotButton.Text = "AimBot: " .. (AimBotEnabled and "ON" or "OFF")
        if AimBotEnabled then
            Notify("AimBot enabled via X!")
            playSound("12221967")
            Camera.CameraType = Enum.CameraType.Scriptable
            RunService.RenderStepped:Connect(UpdateAim)
        else
            Notify("AimBot disabled via X!")
            playSound("12221967")
            Camera.CameraType = Enum.CameraType.Custom
            Target = nil
        end
    end
end)

DecreaseDistanceButton.MouseButton1Click:Connect(function()
    MaxDistance = math.max(10, MaxDistance - 10)
    DistanceLabel.Text = "Distance: " .. MaxDistance
    Notify("AimBot distance decreased to " .. MaxDistance)
end)

IncreaseDistanceButton.MouseButton1Click:Connect(function()
    MaxDistance = math.min(500, MaxDistance + 10)
    DistanceLabel.Text = "Distance: " .. MaxDistance
    Notify("AimBot distance increased to " .. MaxDistance)
end)

local function UpdateESP()
    local currentTime = tick()
    if currentTime - LastESPUpdate < ESPUpdateInterval then return end
    LastESPUpdate = currentTime

    for _, highlight in pairs(ESPHighlights) do
        highlight:Destroy()
    end
    ESPHighlights = {}

    for _, billboard in pairs(ESPBillboards) do
        billboard:Destroy()
    end
    ESPBillboards = {}

    if not ESPEnabled then return end

    local runtimeItemsFolder = Workspace:FindFirstChild("RuntimeItems")
    if runtimeItemsFolder then
        for _, item in pairs(runtimeItemsFolder:GetChildren()) do
            if item:IsA("BasePart") or item:IsA("Model") then
                local targetPart = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                if not targetPart then
                    print("No BasePart found in " .. item.Name .. " for ESP")
                    continue
                end

                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = targetPart
                billboard.Parent = targetPart

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = item.Name
                label.TextColor3 = item.Name == "Coal" and Color3.fromRGB(0, 0, 0) or
                                item.Name == "Bond" and Color3.fromRGB(245, 245, 220) or
                                (item.Name == "BrainJar" or item.Name == "Vampire Knife") and Color3.fromRGB(139, 0, 0) or
                                item.Name == "BankCombo" and Color3.fromRGB(0, 255, 0) or
                                Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Parent = billboard

                table.insert(ESPBillboards, billboard)
                print("Added ESP name for: " .. item.Name .. " with color " .. (item.Name == "Coal" and "black" or
                    item.Name == "Bond" and "beige" or
                    (item.Name == "BrainJar" or item.Name == "Vampire Knife") and "maroon" or
                    item.Name == "BankCombo" and "green" or "white"))
            end
        end
    else
        print("RuntimeItems folder not found")
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= Character then
            local humanoid = obj:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local isCorpse = false
                local parentFolder = obj
                while parentFolder do
                    if parentFolder.Name == "RuntimeItems" then
                        isCorpse = true
                        break
                    end
                    parentFolder = parentFolder.Parent
                end

                if not isCorpse then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Adornee = obj
                    highlight.Parent = obj
                    table.insert(ESPHighlights, highlight)
                    print("Added ESP highlight for mob: " .. obj.Name)
                end
            end
        end
    end
end

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPButton.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    if ESPEnabled then
        Notify("ESP enabled!")
        playSound("12221967")
        UpdateESP()
        task.spawn(function()
            while ESPEnabled do
                UpdateESP()
                task.wait(ESPUpdateInterval)
            end
        end)
        Workspace.RuntimeItems.ChildAdded:Connect(UpdateESP)
        Workspace.RuntimeItems.ChildRemoved:Connect(UpdateESP)
    else
        Notify("ESP disabled!")
        playSound("12221967")
        UpdateESP()
    end
end)

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    NoclipButton.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
    Notify("Noclip " .. (NoclipEnabled and "enabled" or "disabled") .. "!")
    playSound("12221967")

    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Character and Character.Parent then
                for _, part in pairs(Character:GetDescendants()) do
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
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

NoclipButton.MouseButton1Click:Connect(ToggleNoclip)

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

Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    if AimBotEnabled then
        Notify("Character respawned, AimBot re-enabled!")
        Camera.CameraType = Enum.CameraType.Scriptable
    end
    if ESPEnabled then
        UpdateESP()
    end
    if NoclipEnabled then
        ToggleNoclip()
    end
end)

playSound("2865227271")
