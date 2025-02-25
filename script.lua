if getgenv().ScriptLoaded then return end
getgenv().ScriptLoaded = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚡ Speed Legend X",
    LoadingTitle = "Speed Legend X",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SpeedLegendX",
        FileName = "Config"
    }
})

local MainTab = Window:CreateTab("🌟 Main")
local StatsTab = Window:CreateTab("📊 Stats")

local State = {
    autoOrbs = false,
    autoHoops = false,
    autoRebirth = false
}

-- Fixed orb collection function
local function collectOrbs()
    if not State.autoOrbs then return end
    
    pcall(function()
        -- Collect main orbs
        for _, orb in pairs(workspace.orbFolder:GetChildren()) do
            if orb:IsA("Part") then
                firetouchinterest(rootPart, orb, 0)
                task.wait()
                firetouchinterest(rootPart, orb, 1)
            end
        end
        
        -- Collect world orbs
        for _, world in pairs(workspace:GetChildren()) do
            if world.Name:match("World") then
                for _, orb in pairs(world:GetDescendants()) do
                    if orb:IsA("Part") and orb.Name == "outerOrb" then
                        firetouchinterest(rootPart, orb, 0)
                        task.wait()
                        firetouchinterest(rootPart, orb, 1)
                    end
                end
            end
        end
    end)
end

-- Fixed hoop collection function
local function collectHoops()
    if not State.autoHoops then return end
    
    pcall(function()
        for _, hoop in pairs(workspace.Hoops:GetChildren()) do
            if hoop:IsA("Part") then
                firetouchinterest(rootPart, hoop, 0)
                task.wait()
                firetouchinterest(rootPart, hoop, 1)
            end
        end
    end)
end

-- Fixed rebirth function
local function doRebirth()
    if not State.autoRebirth then return end
    
    pcall(function()
        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
    end)
end

MainTab:CreateToggle({
    Name = "🔵 Auto Collect Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        State.autoOrbs = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Orbs Enabled",
                Content = "Now collecting orbs automatically!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "🎯 Auto Collect Hoops",
    CurrentValue = false,
    Flag = "AutoHoops", 
    Callback = function(Value)
        State.autoHoops = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Hoops Enabled",
                Content = "Now collecting hoops automatically!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "♻️ Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        State.autoRebirth = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Rebirth Enabled",
                Content = "Now performing rebirths automatically!",
                Duration = 2
            })
        end
    end
})

-- Main collection loop with error handling
spawn(function()
    while true do
        if State.autoOrbs then
            collectOrbs()
        end
        
        if State.autoHoops then
            collectHoops()
        end
        
        if State.autoRebirth then
            doRebirth()
        end
        
        task.wait(0.1)
    end
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

Rayfield:LoadConfiguration()
