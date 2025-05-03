-- StandAMM Script for Xeno Executor
-- Creates a clone of the player that follows behind-left, syncing rotation and playing animation ID 132642704417515

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart
local AnimationId = "rbxassetid://132642704417515"
local clone = nil

-- Wait for character to fully load
local function waitForCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character and Character:WaitForChild("HumanoidRootPart", 5)
    if not HumanoidRootPart then
        warn("Failed to find HumanoidRootPart, retrying...")
        return false
    end
    return true
end

-- Create clone
local function createClone()
    if not waitForCharacter() then return nil end
    
    local clone = Character:Clone()
    if not clone then return nil end
    
    clone.Name = "StandAMM_Clone"
    clone.Parent = workspace
    
    -- Remove scripts to prevent clone from acting independently
    for _, obj in pairs(clone:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            obj:Destroy()
        end
    end
    
    -- Setup humanoid
    local humanoid = clone:WaitForChild("Humanoid", 5)
    if not humanoid then
        clone:Destroy()
        return nil
    end
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    
    -- Load and play animation
    local animator = humanoid:WaitForChild("Animator", 5)
    if not animator then
        clone:Destroy()
        return nil
    end
    local animation = Instance.new("Animation")
    animation.AnimationId = AnimationId
    local animationTrack = animator:LoadAnimation(animation)
    animationTrack:Play()
    
    return clone
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
