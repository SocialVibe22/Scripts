local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "MasterHub",
    LoadingTitle = "MasterHub",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MasterHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "discord.gg/masterhub",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "MasterHub Key System",
        Subtitle = "Key Required",
        Note = "Enter key to access MasterHub",
        FileName = "MasterHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"MasterHub2025"}
    }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Create tabs based on game
local gameId = game.PlaceId

if gameId == 3101667897 then -- Legends of Speed
    -- Load Legends of Speed tab code
    loadstring(game:HttpGet('https://raw.githubusercontent.com/SocialVibe22/Scripts/main/LegendsSpeedTab.lua'))()
elseif gameId == 537413528 then -- Build A Boat
    -- Load Build A Boat tab code
    loadstring(game:HttpGet('https://raw.githubusercontent.com/SocialVibe22/Scripts/main/BuildABoatTab.lua'))()
elseif gameId == 3956818381 then -- Ninja Legends
    -- Load Ninja Legends tab code
    loadstring(game:HttpGet('https://raw.githubusercontent.com/SocialVibe22/Scripts/main/NinjaLegendsTab.lua'))()
elseif gameId == 6516141723 then -- Doors
    -- Load Doors tab code
    loadstring(game:HttpGet('https://raw.githubusercontent.com/SocialVibe22/Scripts/main/DoorsTab.lua'))()
else
    -- Create a default tab for unsupported games
    local DefaultTab = Window:CreateTab("Main")
    DefaultTab:CreateLabel("This game is not currently supported")
end

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

-- Load configuration
Rayfield:LoadConfiguration()

-- Success notification
Rayfield:Notify({
    Title = "MasterHub Loaded",
    Content = "Successfully loaded MasterHub!",
    Duration = 3
})
