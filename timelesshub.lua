local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local TweenService = game:GetService("TweenService")

local player = game:GetService("Players").LocalPlayer
local character = player.Character
local HumanoidRootPart = character.HumanoidRootPart
local Humanoid = character.Humanoid

-- game ids
local buildaboat = 537413528

if(game.PlaceId == buildaboat) then
    local bodyVelocity
	local autoFarming = false
    local flyDuration = 22.5
    local flySpeed = 390.45

	local Window = Fluent:CreateWindow({
		Title = "Timeless Hub - Build A Boat For Treasure",
		SubTitle = "by Timeless Community",
		TabWidth = 160,
		Size = UDim2.fromOffset(600, 360),
		Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
	})

	local Tabs = {
		Main = Window:AddTab({ Title = "Main", Icon = "" }),
		Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
	}

	local Options = Fluent.Options

	local Toggle = Tabs.Main:AddToggle("AutoFarm", {Title = "Auto farm", Default = false })

    local Slider = Tabs.Settings:AddSlider("Slider", {
        Title = "Auto farm Speed (going to fast may get you detected)",
        Description = "Control how was fast the auto farm goes. (speed 5 recommended)",
        Default = 5,
        Min = 5,
        Max = 10,
        Rounding = 0
    })

    Slider:OnChanged(function(Value)
        if(Value == 5) then
            flySpeed = 390.45
            flyDuration = 22
        elseif(Value == 6) then
            flySpeed = 550
            flyDuration = 16
        elseif(Value == 7) then
            flySpeed = 700
            flyDuration = 12.5
        elseif(Value == 8) then
            flySpeed = 800
            flyDuration = 11.5
        elseif(Value == 9) then
            flySpeed = 900
            flyDuration = 10
        elseif(Value == 10) then
            flySpeed = 1000
            flyDuration = 9
        end
    end)

    function enableNoclip(character)
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    function startAutoFarm()
        spawn(function()
            while autoFarming do
                -- Check if character and HumanoidRootPart exist
                character = player.Character or player.CharacterAdded:Wait()
                
                -- Wait for HumanoidRootPart to be available
                if not character:FindFirstChild("HumanoidRootPart") then
                    repeat wait() until character:FindFirstChild("HumanoidRootPart")
                end
                
                HumanoidRootPart = character.HumanoidRootPart
                Humanoid = character:FindFirstChild("Humanoid")
                
                if HumanoidRootPart then
                    HumanoidRootPart.CFrame = CFrame.new(-50, 100, 0)
                    enableNoclip(character)
                    
                    -- Fly with boosted speed
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                    bodyVelocity.Velocity = Vector3.new(0, 0, flySpeed)
                    bodyVelocity.Parent = HumanoidRootPart
                    
                    wait(flyDuration)
                    
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                    
                    HumanoidRootPart.CFrame = CFrame.new(15, -5, 9495)
                    character:BreakJoints()
                    
                    -- Wait for character to respawn
                    task.wait(4.5)
                else
                    -- Wait a bit before trying again if HumanoidRootPart doesn't exist
                    task.wait(1)
                end
            end
        end)
    end

    function stopFlying()
        if bodyVelocity then
            bodyVelocity:Destroy()
            character:BreakJoints()
        end
    end

    Toggle:OnChanged(function()
        if(Options.AutoFarm.Value == false) then
			autoFarming = false
            stopFlying()
		else
			autoFarming = true
			startAutoFarm()
		end
    end)
end
