-- MenuAMM: Admin Panel Script for Roblox using Xeno Executor
-- Features: Gravity Hack, Infinite Jump, Spin Player, God Mode, Flight, ESP, Teleport Behind Player (Alt/GUI), Speed Hack
-- GUI: 600x600px, black/blue theme (Color3.fromRGB(0, 0, 0) and Color3.fromRGB(0, 150, 255)), single-column buttons, player list, minimize/maximize, Made by: DdeM3zz
-- GitHub Integration: Loads via loadstring from GitHub raw URL

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AMM_AdminPanel"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame (Draggable, 600x600)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 600)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 10

-- Rounded Corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Border
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

-- Rounded Corners for Title
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

-- Border for Title
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

-- Rounded Corners for Minimize
local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Border for Minimize
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

-- Rounded Corners for Functions
local FunctionsCorner = Instance.new("UICorner")
FunctionsCorner.CornerRadius = UDim.new(0, 10)
FunctionsCorner.Parent = FunctionsFrame

-- Player List (Left)
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.5, -10, 0, 460)
PlayerListFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
PlayerListFrame.ScrollBarThickness = 5
PlayerListFrame.Parent = FunctionsFrame

-- Rounded Corners for PlayerList
local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 8)
PlayerListCorner.Parent = PlayerListFrame

-- UI List Layout for Player Buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

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

-- Rounded Corners for MadeBy
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

    -- Rounded Corners
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button

    -- Border
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

-- TextBox Creation Function
local function CreateTextBox(name, parent, size, position, defaultText)
    local TextBox = Instance.new("TextBox")
    TextBox.Name = name
    TextBox.Size = size
    TextBox.Position = position
    TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
    TextBox.Text = defaultText
    TextBox.TextColor3 = Color3.fromRGB(0, 150, 255) -- Blue
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.SourceSans
    TextBox.Parent = parent

    -- Rounded Corners
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 10)
    TextBoxCorner.Parent = TextBox

    -- Border
    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.Color = Color3.fromRGB(0, 150, 255) -- Blue
    TextBoxStroke.Thickness = 1
    TextBoxStroke.Transparency = 0.5
    TextBoxStroke.Parent = TextBox

    return TextBox
end

-- Minimize/Maximize
local function ToggleMinimize()
    Minimized = not Minimized
    if Minimized then
        MainFrame.Size = UDim2.new(0, 600, 0, 40)
        FunctionsFrame.Visible = false
        MadeByLabel.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 600, 0, 600)
        FunctionsFrame.Visible = true
        MadeByLabel.Visible = true
        MinimizeButton.Text = "-"
    end
end
MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

-- Feature Functions
-- Gravity Hack
local GravityEnabled = false
local GravityValue = 196.2
local BodyForce = nil

local function ToggleGravity(gravityButton)
    GravityEnabled = not GravityEnabled
    gravityButton.Text = GravityEnabled and "Stop Gravity" or "Toggle Gravity"
    if GravityEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            BodyForce = Instance.new("BodyForce")
            BodyForce.Force = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart:GetMass() * (196.2 - GravityValue), 0)
            BodyForce.Parent = LocalPlayer.Character.HumanoidRootPart
        end
    else
        if BodyForce then BodyForce:Destroy() BodyForce = nil end
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

-- Infinite Jump
local InfiniteJumpEnabled = false
local function ToggleInfiniteJump(infJumpButton)
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    infJumpButton.Text = InfiniteJumpEnabled and "Stop Inf Jump" or "Toggle Inf Jump"
end

-- Spin Player
local Spinning = false
local SpinSpeed = 50
local BodyAngularVelocity = nil
local TouchConnections = {}
local LastFlingTimes = {}

local function ToggleSpin(spinButton)
    Spinning = not Spinning
    spinButton.Text = Spinning and "Stop Spin" or "Toggle Spin"
    if Spinning then
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
        if BodyAngularVelocity then BodyAngularVelocity:Destroy() BodyAngularVelocity = nil end
        for _, connection in pairs(TouchConnections) do connection:Disconnect() end
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

-- God Mode
local GodModeEnabled = false
local GodModeConnection = nil

local function ToggleGodMode(godModeButton)
    GodModeEnabled = not GodModeEnabled
    godModeButton.Text = GodModeEnabled and "Stop God Mode" or "Toggle God Mode"
    if GodModeEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.MaxHealth = 1e9
            humanoid.Health = 1e9
            GodModeConnection = humanoid.HealthChanged:Connect(function(health)
                if health < 1e9 then humanoid.Health = 1e9 end
            end)
        end
    else
        if GodModeConnection then GodModeConnection:Disconnect() GodModeConnection = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- Flight
local Flying = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyGyro = nil

local function ToggleFlight(flightButton)
    Flying = not Flying
    flightButton.Text = Flying and "Stop Flight" or "Toggle Flight"
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

-- ESP
local ESPEnabled = false
local ESPBoxes = {}

local function ToggleESP(espButton)
    ESPEnabled = not ESPEnabled
    espButton.Text = ESPEnabled and "Stop ESP" or "Toggle ESP"
    if not ESPEnabled then
        for _, box in pairs(ESPBoxes) do box:Destroy() end
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

-- Teleport Behind
local function TeleportBehind(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 0, 3) -- 3 studs behind
    end
end

local function TeleportBehindClosest()
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
end

-- Teleport to Mouse (Ctrl only)
local function TeleportToMouse()
    if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
    end
end

-- Speed Hack
local function ApplySpeed(speedText)
    local speed = tonumber(speedText)
    if speed and speed >= 0 and speed <= 500 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- Player List
local CurrentActionFrame = nil
local CurrentSelectedPlayer = nil

local function UpdatePlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = CreateButton(player.Name, PlayerListFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 0), player.Name, function()
                if CurrentSelectedPlayer == player and CurrentActionFrame then
                    CurrentActionFrame:Destroy()
                    CurrentActionFrame = nil
                    CurrentSelectedPlayer = nil
                else
                    if CurrentActionFrame then CurrentActionFrame:Destroy() end
                    CurrentSelectedPlayer = player
                    CurrentActionFrame = Instance.new("Frame")
                    CurrentActionFrame.Size = UDim2.new(0.5, -10, 0, 35)
                    CurrentActionFrame.Position = UDim2.new(0.5, 5, 0, 470)
                    CurrentActionFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
                    CurrentActionFrame.Parent = FunctionsFrame
                    local ActionCorner = Instance.new("UICorner")
                    ActionCorner.CornerRadius = UDim.new(0, 8)
                    ActionCorner.Parent = CurrentActionFrame

                    CreateButton("TeleportBehind", CurrentActionFrame, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 0), "Teleport Behind", function()
                        TeleportBehind(player)
                    end)
                end
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- GUI Elements (Single Column)
local gravityButton = CreateButton("ToggleGravity", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 5), "Toggle Gravity", function()
    ToggleGravity(gravityButton)
end)
local infJumpButton = CreateButton("ToggleInfiniteJump", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 50), "Toggle Inf Jump", function()
    ToggleInfiniteJump(infJumpButton)
end)
local spinButton = CreateButton("ToggleSpin", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 95), "Toggle Spin", function()
    ToggleSpin(spinButton)
end)
local godModeButton = CreateButton("ToggleGodMode", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 140), "Toggle God Mode", function()
    ToggleGodMode(godModeButton)
end)
local flightButton = CreateButton("ToggleFlight", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 185), "Toggle Flight", function()
    ToggleFlight(flightButton)
end)
local espButton = CreateButton("ToggleESP", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 230), "Toggle ESP", function()
    ToggleESP(espButton)
end)

-- Inputs and Apply Buttons
local SpeedInput = CreateTextBox("SpeedInput", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 275), "16")
CreateButton("ApplySpeed", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 320), "Apply Speed", function()
    ApplySpeed(SpeedInput.Text)
end)

local SpinSpeedInput = CreateTextBox("SpinSpeedInput", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 365), "50")
CreateButton("ApplySpinSpeed", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 410), "Apply Spin Speed", function()
    ApplySpinSpeed(SpinSpeedInput.Text)
end)

local GravityInput = CreateTextBox("GravityInput", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 455), "196.2")
CreateButton("ApplyGravity", FunctionsFrame, UDim2.new(0.5, -10, 0, 35), UDim2.new(0.5, 5, 0, 500), "Apply Gravity", function()
    ApplyGravity(GravityInput.Text)
end)

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            TeleportToMouse()
        elseif input.KeyCode == Enum.KeyCode.LeftAlt then
            TeleportBehindClosest()
        elseif input.KeyCode == Enum.KeyCode.Space and InfiniteJumpEnabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Flight Controls
local function UpdateFlight()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local moveDirection = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + lookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - lookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - rightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + rightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * FlySpeed
        end
        if BodyVelocity then BodyVelocity.Velocity = moveDirection end
        if BodyGyro then BodyGyro.CFrame = camera.CFrame end
    end
end

-- Gravity Update
RunService.Stepped:Connect(function()
    if GravityEnabled and BodyForce and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        BodyForce.Force = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart:GetMass() * (196.2 - GravityValue), 0)
    end
end)

-- Spin Update
RunService.Stepped:Connect(function()
    if Spinning and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and BodyAngularVelocity then
        BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
    end
end)

-- Player Join/Leave
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
end)

-- Character Added
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5)
    if GravityEnabled and character:FindFirstChild("HumanoidRootPart") then
        BodyForce = Instance.new("BodyForce")
        BodyForce.Force = Vector3.new(0, character.HumanoidRootPart:GetMass() * (196.2 - GravityValue), 0)
        BodyForce.Parent = character.HumanoidRootPart
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
    if GodModeEnabled and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid.MaxHealth = 1e9
        humanoid.Health = 1e9
        GodModeConnection = humanoid.HealthChanged:Connect(function(health)
            if health < 1e9 then humanoid.Health = 1e9 end
        end)
    end
end)

-- Initial Setup
spawn(function()
    wait(2)
    UpdatePlayerList()
end)

RunService.RenderStepped:Connect(UpdateFlight)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainFrame.ZIndex = 10
