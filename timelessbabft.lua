-- Services & Player
local Players = game:GetService("Players")
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Humanoid = character:WaitForChild("Humanoid")

-- State & Config
local autoFarming = false
local flySpeed = 390.45
local flyDuration = 22.5

-- Anti-AFK
local GC = getconnections or get_signal_cons
if GC then
    for _, conn in pairs(GC(player.Idled)) do
        if conn.Disable then conn.Disable(conn)
        elseif conn.Disconnect then conn.Disconnect(conn)
        end
    end
else
    player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local MainTab = Window:CreateTab("Main", "layout-dashboard")
local SettingsTab = Window:CreateTab("Settings", "settings")
Window:SelectTab(MainTab)

-- Auto-Farm Toggle
MainTab:CreateToggle({
    Name = "Auto farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(value)
        autoFarming = value
        if autoFarming then
            startAutoFarm()
        else
            stopFlying()
        end
    end
})

-- Speed Slider
SettingsTab:CreateSlider({
    Name = "Auto farm Speed",
    Range = {5, 10},
    Increment = 1,
    CurrentValue = 5,
    Flag = "FarmSpeed",
    Text = true,
    Tooltip = "Control how fast the auto farm goes (going too fast may get you detected)",
    Callback = function(value)
        if value == 5 then flySpeed, flyDuration = 390.45, 22
        elseif value == 6 then flySpeed, flyDuration = 550, 16
        elseif value == 7 then flySpeed, flyDuration = 700, 12.5
        elseif value == 8 then flySpeed, flyDuration = 800, 11.5
        elseif value == 9 then flySpeed, flyDuration = 900, 10
        elseif value == 10 then flySpeed, flyDuration = 1000, 9
        end
    end
})

-- Noclip Utility
local function enableNoclip(chr)
    for _, part in pairs(chr:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Auto-Farm Logic
function startAutoFarm()
    spawn(function()
        while autoFarming do
            character = player.Character or player.CharacterAdded:Wait()
            if not character:FindFirstChild("HumanoidRootPart") then
                task.wait(1)
                continue
            end
            HumanoidRootPart = character.HumanoidRootPart
            Humanoid = character:FindFirstChild("Humanoid")

            -- Teleport & Noclip
            HumanoidRootPart.CFrame = CFrame.new(-50, 100, 0)
            enableNoclip(character)

            -- Apply flight velocity
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e4, 1e4, 1e4)
            bodyVelocity.Velocity = HumanoidRootPart.CFrame.LookVector * flySpeed
            bodyVelocity.Parent = HumanoidRootPart

            task.wait(flyDuration)
            bodyVelocity:Destroy()

            -- Drop & respawn
            HumanoidRootPart.CFrame = CFrame.new(15, -5, 9495)
            character:BreakJoints()
            task.wait(4.5)
        end
    end)
end

function stopFlying()
    autoFarming = false
    if character and character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(character.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
        character:BreakJoints()
    end
end
