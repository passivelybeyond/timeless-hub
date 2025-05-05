Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local supportedGames = {
    1962086868, -- tower of hell (noob)
    3582763398, -- tower of hell (pro)
    537413528, -- build a boat for treasure
    6403373529, -- slap battles
}

if(not table.find(supportedGames, game.PlaceId)) then
    Rayfield:Notify({
        Title = "Error",
        Content = "Game is not supported.",
        Duration = 6.5,
        Image = "ban",
    })
end

setclipboard("https://loot-link.com/s?nIoKT50l")

Window = Rayfield:CreateWindow({
   Name = "Timeless Hub - "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Timeless Hub",
   LoadingSubtitle = "by Timeless Community",
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "timelesshub", -- Create a custom folder for your hub/game
      FileName = "Timeless Hub"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/9bp4cGs8WM", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Timeless Hub",
      Subtitle = "Key System",
      Note = "The key system link has been copied to your clipboard.", -- Use this to tell the user how to get a key
      FileName = "th-key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/key.txt"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

if(game.PlaceId == supportedGames[1] or game.PlaceId == supportedGames[2]) then -- tower of hell noob or pro
    loadstring(game:HttpGet("https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/timelesstohl.lua"))()
elseif(game.PlaceId == supportedGames[3]) then -- build a boat for treasure
    loadstring(game:HttpGet("https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/timelessbabft.lua"))()
elseif(game.PlaceId == supportedGames[4]) then -- slap battles
    setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/passivelybeyond/timeless-hub/refs/heads/main/timelessslapfarm.lua"))()')
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Timeless Hub", -- Required
        Text = "Slap autofarm script copied to clipboard, put in the 'autoexec' folder.", -- Required
    })
end
