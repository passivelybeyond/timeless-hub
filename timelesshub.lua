local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local TweenService = game:GetService("TweenService")

-- game ids
local buildaboat = 537413528
local tohnoob = 1962086868
local tohpro = 3582763398
local slapbattles = 6403373529

if(game.PlaceId == buildaboat) then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/timelessbabft.lua"))()
elseif(game.PlaceId == tohnoob or game.PlaceId == tohpro) then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/timelesstohl.lua"))()
elseif(game.PlaceId == slapbattles) then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/timelessslapfarm.lua"))()
end
