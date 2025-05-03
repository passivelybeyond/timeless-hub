--[[

LLLLLL TO YOU IF YOU SKID THIS GNG
made by the one and only @passivelybeyond on discord

]]--


game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

-- LocalScript

local Players       = game:GetService("Players")
local RepStorage    = game:GetService("ReplicatedStorage")
local RunService    = game:GetService("RunService")
local TeleportSvc   = game:GetService("TeleportService")
local HttpService   = game:GetService("HttpService")
local StarterGui    = game:GetService("StarterGui")

local localPlayer   = Players.LocalPlayer
local SnowHit       = RepStorage:WaitForChild("SnowHit")

-- Settings
local WAIT_BEFORE_HOP = 2

task.wait()

-- 1) Wait for you & the game to load
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- 2) Touch lobby Teleport1 until you get "entered"
if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered") then
    repeat
        task.wait()
        firetouchinterest(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            workspace.Lobby.Teleport1,
            0
        )
        firetouchinterest(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            workspace.Lobby.Teleport1,
            1
        )
    until game:GetService("Players").LocalPlayer.Character:FindFirstChild("entered")
end

-- 3) Farm all gloves in island5.Slapples
for _, v in ipairs(workspace.Arena.island5.Slapples:GetDescendants()) do
    if v.Name == "Glove" and v:FindFirstChildWhichIsA("TouchTransmitter") then
        firetouchinterest(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            v,
            0
        )
        firetouchinterest(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            v,
            1
        )
    end
end

task.wait(0.5)

-- 4) Spawn harassment loop (SnowHit) in background
spawn(function()
    -- a) wait for at least one OTHER player who’s "entered"
    local target
    repeat
        task.wait()
        local pl = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
        if pl ~= game:GetService("Players").LocalPlayer
            and pl.Character
            and pl.Character:FindFirstChild("HumanoidRootPart")
            and pl.Character:FindFirstChild("entered")
            and pl.Character:FindFirstChild("Humanoid").Health > 0
        then
            target = pl
        end
    until target

    -- c) spam until kicked
    while true do
        game:GetService("GuiService"):ClearError()
        local myChar = game:GetService("Players").LocalPlayer.Character
        if target and myChar and target.Character then
            local hrp = Players
                :WaitForChild(target.Name)
                .Character
                :WaitForChild("HumanoidRootPart")

            local behind = hrp.CFrame * CFrame.new(0, 0, 3)
            --myChar.HumanoidRootPart.Anchored = true
            myChar.HumanoidRootPart.CFrame = behind

            -- now fire your SnowHit remote on their HRP:
            local args = {
                Players
                    :WaitForChild(target.Name)
                    .Character
                    :WaitForChild("HumanoidRootPart")
            }
            local ok, err = pcall(function()
                SnowHit:FireServer(unpack(args))
            end)
            if not ok then
                warn("[SnowHit] Error:", err)
            end
        end

        task.wait()
    end
end)

-- 5) Continue server‑hop logic
local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text  = text,
    })
end

local serverList = {}

while true do
    local success, err = pcall(function()
        for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
            if v.playing and type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
                serverList[#serverList + 1] = v.id
            end
        end
    end)
    
    if success then
        if #serverList > 0 then
            notify(
              "Slapple Farm",
              "Found a new server! Teleporting in " .. WAIT_BEFORE_HOP .. "s…"
            )
            task.wait(WAIT_BEFORE_HOP)
            TeleportSvc:TeleportToPlaceInstance(
                game.PlaceId,
                serverList[math.random(#serverList)]
            )
            break
        else
            error("No servers available")
        end
    else
        notify("Slapple Farm", "Couldn't find a server. Fallback teleportation in " .. WAIT_BEFORE_HOP .. "s…")
        task.wait(WAIT_BEFORE_HOP)
        TeleportSvc:Teleport(game.PlaceId)
        -- some old stuff below hehe
        --notify("Slapple Farm", "Retrying server list…")
        --task.wait(1)
    end
end
