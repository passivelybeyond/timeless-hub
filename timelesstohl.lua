-- Core Services
local tower = workspace.tower
local sections = tower.sections
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Player References
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Humanoid = character:WaitForChild("Humanoid")

-- State Variables
local autoFarming = false
local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

-- Utility: Get global value by path
local function getGlobal(path)
    local value = getfenv(0)
    while value and path ~= "" do
        local name, nextValue = string.match(path, "^([^.]+)%.?(.*)$")
        value = value[name]
        path = nextValue
    end
    return value
end

-- Test framework for executor support
local passes, fails, undefined, running = 0, 0, 0, 0
local function test(name, aliases, callback)
    running += 1
    task.spawn(function()
        if not callback then
            print("⏺️ " .. name)
        elseif not getGlobal(name) then
            fails += 1
            Rayfield:Notify({
                Title = "Warning",
                Content = identifyexecutor() .. " does not support getconnections().",
                Duration = 8
            })
        else
            local success, message = pcall(callback)
            if success then
                passes += 1
            else
                fails += 1
                Rayfield:Notify({
                    Title = "Warning",
                    Content = identifyexecutor() .. " callback failed: " .. tostring(message),
                    Duration = 8
                })
            end
        end
        local undefinedAliases = {}
        for _, alias in ipairs(aliases) do
            if getGlobal(alias) == nil then
                table.insert(undefinedAliases, alias)
            end
        end
        if #undefinedAliases > 0 then
            undefined += 1
            warn("⚠️ Missing aliases: " .. table.concat(undefinedAliases, ", "))
        end
        running -= 1
    end)
end

test("getconnections", {}, function()
    local types = { Enabled = "boolean", ForeignState = "boolean", LuaConnection = "boolean", Function = "function", Thread = "thread", Fire = "function", Defer = "function", Disconnect = "function", Disable = "function", Enable = "function", }
    local bindable = Instance.new("BindableEvent")
    bindable.Event:Connect(function() end)
    local connection = getconnections(bindable.Event)[1]
    for k, v in pairs(types) do
        assert(connection[k] ~= nil, "Missing field '" .. k .. "'")
        assert(type(connection[k]) == v, "Field '" .. k .. "' expected " .. v .. ", got " .. type(connection[k]))
    end
end)

-- Anti-AFK
local GC = getconnections or get_signal_cons
if GC then
    for _, conn in pairs(GC(player.Idled)) do
        if conn.Disable then conn.Disable(conn)
        elseif conn.Disconnect then conn.Disconnect(conn)
        end
    end
else
    local VirtualUser = cloneref(game:GetService("VirtualUser"))
    player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Godmode: Clone Humanoid
function godmode()
    local Cam = workspace.CurrentCamera
    local Pos = Cam.CFrame
    local Human = character:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    local nHuman = Human:Clone()
    nHuman.Parent = character
    nHuman:SetStateEnabled(15, false)
    nHuman:SetStateEnabled(1, false)
    nHuman:SetStateEnabled(0, false)
    nHuman.BreakJointsOnDeath = true
    Human:Destroy()
    workspace.CurrentCamera.CameraSubject = nHuman
    Cam.CFrame = Pos
    nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local animateScript = character:FindFirstChild("Animate")
    if animateScript then
        animateScript.Disabled = true
        task.wait()
        animateScript.Disabled = false
    end
    nHuman.Health = nHuman.MaxHealth
end

-- Tween to a given section index
function tweenToSection(i)
    for _, v in pairs(sections:GetChildren()) do
        if v.Name ~= "lobby" and v.Name ~= "finish" and v.i.Value == i then
            local target = v.start.CFrame
            local offset = Vector3.new(0, humanoidRootPart.Size.Y, 0)
            local final = CFrame.new(target.Position + offset) * CFrame.Angles(0, target.Rotation.Y, 0)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = final})
            tween:Play()
            tween.Completed:Wait()
            return
        end
    end
    warn("section " .. i .. " not found")
end

-- Finish tweens
function finishTween()
    tweenToSection("finish")
end
function finishGlowTween()
    local v = sections.finish.FinishGlow
    local target = v.CFrame
    local offset = Vector3.new(0, humanoidRootPart.Size.Y, 0)
    local final = CFrame.new(target.Position + offset) * CFrame.Angles(0, target.Rotation.Y, 0)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = final})
    tween:Play()
    tween.Completed:Wait()
end

-- Auto farm loop on timer
player.PlayerGui.timer.timeLeft:GetPropertyChangedSignal("Text"):Connect(function()
    if player.PlayerGui.timer.timeLeft.Text == "0:00" and autoFarming then
        task.wait(5)
        Rayfield:Notify({ Title = "Auto farm", Content = "Restarting auto-farm...", Duration = 8 })
        startAutoFarm()
    end
end)

-- Noob Tower Routine
function noobTower()
    godmode(); task.wait(1)
    for i = 2, 7 do if not autoFarming then return end tweenToSection(i) end
    finishTween(); finishGlowTween(); task.wait(0.5)
    if autoFarming then character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end
end

-- Pro Tower Routine
function proTower()
    godmode(); task.wait(1)
    for i = 2, 13 do if not autoFarming then return end tweenToSection(i) end
    finishTween(); finishGlowTween(); task.wait(0.5)
    if autoFarming then character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end
end

-- Start Auto-Farm Based on Place
function startAutoFarm()
    autoFarming = true
    Rayfield:Notify({ Title = "Auto farm", Content = "Auto farm started.", Duration = 8 })
    if game.PlaceId == 1962086868 then noobTower()
    elseif game.PlaceId == 3582763398 then proTower() end
end

-- Update references on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar; humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    local h = newChar:WaitForChild("Humanoid")
    workspace.CurrentCamera.CameraSubject = h
    print("Camera subject updated on respawn")
end)

local MainTab = Window:CreateTab("Main", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- AutoFarm Toggle
MainTab:CreateToggle({ Name = "Auto farm", CurrentValue = false, Flag = "AutoFarm", Callback = function(value)
    autoFarming = value
    if value then startAutoFarm() else print("Auto farm stopped") end
end})

-- Auto-Farm Speed Slider
SettingsTab:CreateSlider({ Name = "Auto farm speed", Range = {0, 5}, Increment = 1, CurrentValue = 0, Flag = "FarmSpeed",
    Text = true, Tooltip = "Going too fast may get you detected, be cautious (0 recommended)",
    Callback = function(value)
        if value == 0 then tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        elseif value == 1 then tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        elseif value == 2 then tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        elseif value == 4 then tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        elseif value == 5 then tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end
    end
})

Window:SelectTab(MainTab)

-- Disconnect unwanted localscripts
local function DisableSignal(signal, name)
    local ok = true
    for i, conn in next, getconnections(signal) do
        local success, err = pcall(conn.Disable)
        if success then print("Disconnected " .. name .. "#" .. i)
        else warn("Failed to disconnect " .. name .. ": " .. tostring(err)); ok = false end
    end
    return ok
end

local ls1 = player.PlayerScripts:FindFirstChild('LocalScript')
local ls2 = player.PlayerScripts:FindFirstChild('LocalScript2')
if ls1 and DisableSignal(ls1.Changed, 'LocalScript') then ls1:Destroy() end
if ls2 and DisableSignal(ls2.Changed, 'LocalScript2') then ls2:Destroy() end
