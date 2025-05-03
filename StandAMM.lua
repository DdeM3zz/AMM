-- StandAMM Script for Xeno Executor
-- Simplified version to debug clone creation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = nil
local HumanoidRootPart = nil
local clone = nil

-- Wait for character to fully load
local function waitForCharacter()
    repeat
        Character = LocalPlayer.Character
        if not Character then
            LocalPlayer.CharacterAdded:Wait()
            Character = LocalPlayer.Character
        end
        HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            wait(0.1) -- Ждем 0.1 секунды перед повторной попыткой
        end
    until HumanoidRootPart
    return true
end

-- Create clone
local function createClone()
    if not waitForCharacter() then return nil end
    
    local success, cloned = pcall(function()
        return Character:Clone()
    end)
    
    if not success or not cloned then
        warn("Failed to clone character")
        return nil
    end
    
    cloned.Name = "StandAMM_Clone"
    cloned.Parent = workspace
    
    -- Remove scripts to prevent clone from acting independently
    for _, obj in pairs(cloned:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            obj:Destroy()
        end
    end
    
    -- Setup humanoid (temporary disable animation for debugging)
    local humanoid = cloned:FindFirstChild("Humanoid")
    if not humanoid then
        cloned:Destroy()
        return nil
    end
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    
    return cloned
end

-- Initialize clone
clone = createClone()

-- Update clone position and rotation
RunService.Heartbeat:Connect(function()
    if not Character or not HumanoidRootPart or not clone or not clone:FindFirstChild("HumanoidRootPart") then
        if clone then
            clone:Destroy()
        end
        clone = createClone()
        return
    end
    
    local cloneRoot = clone.HumanoidRootPart
    
    -- Position behind-left (offset: -3 studs back, -2 studs left)
    local offset = CFrame.new(-2, 0, -3)
    local targetCFrame = HumanoidRootPart.CFrame * offset
    
    -- Smoothly interpolate position
    cloneRoot.CFrame = cloneRoot.CFrame:Lerp(targetCFrame, 0.1)
    
    -- Sync rotation (only Y-axis for facing same direction)
    local _, y, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
    cloneRoot.CFrame = CFrame.new(cloneRoot.Position) * CFrame.Angles(0, y, 0)
    
    -- Ensure clone stays upright
    clone.Humanoid.PlatformStand = true
end)

-- Handle character changes
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    if clone then
        clone:Destroy()
    end
    waitForCharacter()
    clone = createClone()
end)
