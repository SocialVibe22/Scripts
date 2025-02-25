if _G.ScriptLoaded then return end
_G.ScriptLoaded = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Legends Speed X",
    LoadingTitle = "Loading Speed X...",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SpeedX",
        FileName = "Config"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Speed X",
        Subtitle = "Key System",
        Note = "Join discord.gg/speedx for key",
        SaveKey = true,
        Key = {"SPEEDX2024"}
    }
})

local MainTab = Window:CreateTab("Main")
local FarmTab = Window:CreateTab("Farming")
local BoostTab = Window:CreateTab("Boosts")
local TeleportTab = Window:CreateTab("Teleport")
local VisualsTab = Window:CreateTab("Visuals")

local State = {
    orbsEnabled = false,
    hoopsEnabled = false,
    gemsEnabled = false,
    autoRebirth = false,
    autoRace = false,
    speedBoost = false,
    visualEffects = false
}

local Config = {
    orbCollectDelay = 0,
    hoopCollectDelay = 0,
    rebirthDelay = 0,
    collectRadius = 50,
    speedMultiplier = 1,
    effectsIntensity = 1
}

local function createVisualEffect(position, color)
    if not State.visualEffects then return end
    
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(1, 1, 1)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.5
    effect.Material = Enum.Material.Neon
    effect.Color = color or Color3.fromRGB(255, 255, 255)
    effect.Parent = workspace

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(effect, tweenInfo, {
        Size = Vector3.new(5, 5, 5),
        Transparency = 1
    }):Play()

    game:GetService("Debris"):AddItem(effect, 0.5)
end

local function collectOrbs()
    pcall(function()
        for _, orb in pairs(workspace.orbFolder:GetChildren()) do
            if orb:IsA("Part") and State.orbsEnabled then
                ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orb)
                createVisualEffect(orb.Position, Color3.fromRGB(0, 255, 255))
            end
        end
        
        for _, world in pairs(workspace:GetChildren()) do
            if world.Name:match("World") then
                for _, orb in pairs(world:GetDescendants()) do
                    if orb:IsA("Part") and orb.Name == "outerOrb" and State.orbsEnabled then
                        ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orb)
                        createVisualEffect(orb.Position, Color3.fromRGB(255, 0, 255))
                    end
                end
            end
        end
    end)
end

local function collectHoops()
    pcall(function()
        for _, hoop in pairs(workspace.Hoops:GetChildren()) do
            if hoop:IsA("Part") and State.hoopsEnabled then
                ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", hoop)
                createVisualEffect(hoop.Position, Color3.fromRGB(255, 255, 0))
            end
        end
    end)
end

MainTab:CreateToggle({
    Name = "Auto Collect Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        State.orbsEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Orbs Enabled",
                Content = "Now collecting all orbs automatically!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Collect Hoops",
    CurrentValue = false,
    Flag = "AutoHoops",
    Callback = function(Value)
        State.hoopsEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Hoops Enabled",
                Content = "Now collecting all hoops automatically!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateSlider({
    Name = "Collection Speed",
    Range = {0, 100},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = 0,
    Flag = "CollectionSpeed",
    Callback = function(Value)
        Config.orbCollectDelay = Value/1000
        Config.hoopCollectDelay = Value/1000
    end
})

BoostTab:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "SpeedMultiplier",
    Callback = function(Value)
        Config.speedMultiplier = Value
        if humanoid then
            humanoid.WalkSpeed = 16 * Value
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Visual Effects",
    CurrentValue = false,
    Flag = "VisualEffects",
    Callback = function(Value)
        State.visualEffects = Value
    end
})

VisualsTab:CreateSlider({
    Name = "Effects Intensity",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "EffectsIntensity",
    Callback = function(Value)
        Config.effectsIntensity = Value
    end
})

local worlds = {
    ["City"] = CFrame.new(-9682.98, 74.8522, 3099.89),
    ["Snow City"] = CFrame.new(-9676.01, 74.8522, 3782.31),
    ["Magma City"] = CFrame.new(-11054.9, 74.8522, 3819.92),
    ["Space"] = CFrame.new(-8629.7998, 74.8522, 3735.96997),
    ["Candy Land"] = CFrame.new(-11054.9, 74.8522, 4048.97)
}

TeleportTab:CreateDropdown({
    Name = "Teleport",
    Options = {"City", "Snow City", "Magma City", "Space", "Candy Land"},
    CurrentOption = "City",
    Flag = "SelectedWorld",
    Callback = function(Value)
        if worlds[Value] then
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad)
            local tween = TweenService:Create(rootPart, tweenInfo, {
                CFrame = worlds[Value]
            })
            tween:Play()
            
            Rayfield:Notify({
                Title = "Teleporting",
                Content = "Teleporting to " .. Value,
                Duration = 1
            })
        end
    end
})

RunService.Heartbeat:Connect(function()
    if State.orbsEnabled then
        collectOrbs()
        task.wait(Config.orbCollectDelay)
    end
    if State.hoopsEnabled then
        collectHoops()
        task.wait(Config.hoopCollectDelay)
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if Config.speedMultiplier > 1 then
        humanoid.WalkSpeed = 16 * Config.speedMultiplier
    end
end)

Rayfield:LoadConfiguration()
