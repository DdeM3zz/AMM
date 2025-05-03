-- StandAMM Script for Xeno Executor
-- Creates a clone of the player that follows behind-left, syncing rotation and playing animation ID 132642704417515

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local AnimationId = "rbxassetid://132642704417515"

-- Wait for character to fully load
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- Create clone
local function createClone()
    local clone = Character:Clone()
    clone.Name = "StandAMM_Clone"
    clone.Parent = workspace
    
    -- Remove scripts to prevent clone from acting independently
    for _, obj in pairs(clone:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            obj:Destroy()
        end
    end
    
    -- Setup humanoid
    local humanoid = clone:WaitForChild("Humanoid")
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    
    -- Load and play animation
    local animator = humanoid:WaitForChild("Animator")
    local animation = Instance.new("Animation")
    animation.AnimationId = AnimationId
    local animationTrack = animator:LoadAnimation(animation)
    animationTrack:Play()
    
    return clone
end

-- Initialize clone
local clone = createClone()

-- Update clone position and rotation
RunService.Heartbeat:Connect(function()
    if Character and HumanoidRootPart and clone and clone:FindFirstChild("HumanoidRootPart") then
        local cloneRoot = clone.HumanoidRootPart
        
        -- Position behind-left (offset: -3 studs back, -2 studs left)
        local offset = CFrame.new(-2, 0, -3) -- Left: -2, Back: -3
        local targetCFrame = HumanoidRootPart.CFrame * offset
        
        -- Smoothly interpolate position
        cloneRoot.CFrame = cloneRoot.CFrame:Lerp(targetCFrame, 0.1)
        
        -- Sync rotation (only Y-axis for facing same direction)
        local _, y, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
        cloneRoot.CFrame = CFrame.new(cloneRoot.Position) * CFrame.Angles(0, y, 0)
        
        -- Ensure clone stays upright and doesn't fall
        clone.Humanoid.PlatformStand = true
    else
        -- Recreate clone if it was destroyed
        clone = createClone()
    end
end)

-- Handle clone cleanup on player death
Character.Humanoid.Died:Connect(function()
    if clone then
        clone:Destroy()
    end
end)
