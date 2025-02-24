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

loadstring(game:HttpGet('https://raw.githubusercontent.com/SocialVibe22/Scripts/refs/heads/main/LegendsSpeedTab.lua?token=GHSAT0AAAAAAC7PDVNGEQRT6I7OSASEJORAZ55AGBQ'))()

player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

Rayfield:LoadConfiguration()
