-- StandAMM Script for Xeno Executor
-- Adjusted offset to position clone behind-left

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = nil
local HumanoidRootPart = nil
local clone = nil
local lastAttempt = 0
local attemptDelay = 2 -- Задержка между попытками в секундах

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
            wait(0.1)
        end
    until HumanoidRootPart
    return true
end

-- Create dummy clone (simple part)
local function createDummyClone()
    if not waitForCharacter() then return nil end
    
    local success, result = pcall(function()
        local dummy = Instance.new("Part")
        dummy.Name = "StandAMM_Clone"
        dummy.Size = Vector3.new(2, 5, 1)
        dummy.Anchored = false
        dummy.CanCollide = false
        dummy.BrickColor = BrickColor.new("Bright red")
        dummy.Parent = workspace
        return dummy
    end)
    
    if not success or not result then
        warn("Failed to create dummy clone")
        return nil
    end
    
    return result
end

-- Initialize clone
if tick() - lastAttempt > attemptDelay then
    clone = createDummyClone()
    lastAttempt = tick()
end

-- Update clone position and rotation
RunService.Heartbeat:Connect(function()
    if not Character or not HumanoidRootPart or not clone then
        if tick() - lastAttempt > attemptDelay then
            if clone then
                clone:Destroy()
            end
            clone = createDummyClone()
            lastAttempt = tick()
        end
        return
    end
    
    -- Position behind-left (adjusted offset: -2 studs left, +3 studs back)
    local offset = CFrame.new(-2, 0, 3) -- Changed Z from -3 to +3 to move behind
    local targetCFrame = HumanoidRootPart.CFrame * offset
    
    -- Update position with smooth interpolation
    clone.CFrame = clone.CFrame:Lerp(targetCFrame, 0.1)
    
    -- Sync rotation (only Y-axis for facing same direction)
    local _, y, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
    clone.CFrame = CFrame.new(clone.Position) * CFrame.Angles(0, y, 0)
end)

-- Handle character changes
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    if clone then
        clone:Destroy()
    end
    waitForCharacter()
    if tick() - lastAttempt > attemptDelay then
        clone = createDummyClone()
        lastAttempt = tick()
    end
end)
