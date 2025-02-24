if _G.ScriptLoaded then return end
_G.ScriptLoaded = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ultimate Script Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Master",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UltimateHub",
        FileName = "Config"
    }
})

local LegendsSpeedTab = Window:CreateTab("Legends of Speed")

local function createStatsDisplay()
    local statsGui = Instance.new("ScreenGui")
    statsGui.Name = "StatsGui"
    statsGui.Parent = player.PlayerGui

    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsDisplay"
    statsFrame.Size = UDim2.new(0, 200, 0, 120)
    statsFrame.Position = UDim2.new(0, 10, 0.5, -60)
    statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.Parent = statsGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = statsFrame

    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "StatsText"
    statsLabel.Size = UDim2.new(1, -20, 1, -20)
    statsLabel.Position = UDim2.new(0, 10, 0, 10)
    statsLabel.BackgroundTransparency = 1
    statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsLabel.TextSize = 14
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.Parent = statsFrame

    return statsLabel
end

LegendsSpeedTab:CreateToggle({
    Name = "Show Stats",
    CurrentValue = false,
    Flag = "ShowStats",
    Callback = function(Value)
        if Value then
            local statsLabel = createStatsDisplay()
            RunService.RenderStepped:Connect(function()
                if not Value then return end
                if not player:FindFirstChild("leaderstats") then return end
                statsLabel.Text = string.format(
                    "Speed: %s\nRebirths: %s\nGems: %s\nSteps: %s\nHoops: %s",
                    tostring(player.leaderstats.Speed.Value),
                    tostring(player.leaderstats.Rebirths.Value),
                    tostring(player.leaderstats.Gems.Value),
                    tostring(player.leaderstats.Steps.Value),
                    tostring(player.leaderstats.Hoops.Value)
                )
            end)
        else
            local statsGui = player.PlayerGui:FindFirstChild("StatsGui")
            if statsGui then statsGui:Destroy() end
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Orbs",
    CurrentValue = false,
    Flag = "AutoOrbs",
    Callback = function(Value)
        getgenv().AutoOrbs = Value
        while getgenv().AutoOrbs do
            pcall(function()
                for _, orb in pairs(workspace.orbFolder:GetChildren()) do
                    if orb:IsA("Part") then
                        ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orb)
                    end
                end
                for _, world in pairs(workspace:GetChildren()) do
                    if world.Name:match("World") then
                        for _, orb in pairs(world:GetDescendants()) do
                            if orb:IsA("Part") and orb.Name == "outerOrb" then
                                ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orb)
                            end
                        end
                    end
                end
            end)
            task.wait()
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        getgenv().AutoRebirth = Value
        while getgenv().AutoRebirth do
            pcall(function()
                ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
            end)
            task.wait()
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Race",
    CurrentValue = false,
    Flag = "AutoRace",
    Callback = function(Value)
        getgenv().AutoRace = Value
        while getgenv().AutoRace do
            pcall(function()
                for _, race in pairs(workspace:GetChildren()) do
                    if race.Name:find("raceStart") then
                        firetouchinterest(rootPart, race, 0)
                        task.wait()
                        firetouchinterest(rootPart, race, 1)
                        break
                    end
                end
            end)
            task.wait(0.5)
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Gems",
    CurrentValue = false,
    Flag = "AutoGems",
    Callback = function(Value)
        getgenv().AutoGems = Value
        while getgenv().AutoGems do
            pcall(function()
                for _, gem in pairs(workspace.gemFolder:GetChildren()) do
                    if gem:IsA("Part") then
                        ReplicatedStorage.rEvents.gemEvent:FireServer("collectGem", gem)
                    end
                end
            end)
            task.wait()
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Hoops",
    CurrentValue = false,
    Flag = "AutoHoops",
    Callback = function(Value)
        getgenv().AutoHoops = Value
        while getgenv().AutoHoops do
            pcall(function()
                for _, hoop in pairs(workspace.Hoops:GetChildren()) do
                    if hoop:IsA("Part") then
                        ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", hoop)
                    end
                end
            end)
            task.wait()
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Steps",
    CurrentValue = false,
    Flag = "AutoSteps",
    Callback = function(Value)
        getgenv().AutoSteps = Value
        while getgenv().AutoSteps do
            pcall(function()
                ReplicatedStorage.rEvents.stepEvent:FireServer("buyAllSteps")
            end)
            task.wait(1)
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Trails",
    CurrentValue = false,
    Flag = "AutoTrails",
    Callback = function(Value)
        getgenv().AutoTrails = Value
        while getgenv().AutoTrails do
            pcall(function()
                ReplicatedStorage.rEvents.trailEvent:FireServer("buyAllTrails")
            end)
            task.wait(1)
        end
    end
})

local worlds = {
    ["City"] = CFrame.new(-9682.98, 74.8522, 3099.89),
    ["Snow City"] = CFrame.new(-9676.01, 74.8522, 3782.31),
    ["Magma City"] = CFrame.new(-11054.9, 74.8522, 3819.92),
    ["Space"] = CFrame.new(-8629.7998, 74.8522, 3735.96997),
    ["Candy Land"] = CFrame.new(-11054.9, 74.8522, 4048.97)
}

LegendsSpeedTab:CreateDropdown({
    Name = "Teleport",
    Options = {"City", "Snow City", "Magma City", "Space", "Candy Land"},
    CurrentOption = "City",
    Flag = "SelectedWorld",
    Callback = function(Value)
        if worlds[Value] then
            rootPart.CFrame = worlds[Value]
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Auto Farm All",
    CurrentValue = false,
    Flag = "AutoFarmAll",
    Callback = function(Value)
        getgenv().AutoFarmAll = Value
        if Value then
            getgenv().AutoOrbs = true
            getgenv().AutoGems = true
            getgenv().AutoHoops = true
            getgenv().AutoRebirth = true
            getgenv().AutoSteps = true
            getgenv().AutoTrails = true
            getgenv().AutoRace = true
        else
            getgenv().AutoOrbs = false
            getgenv().AutoGems = false
            getgenv().AutoHoops = false
            getgenv().AutoRebirth = false
            getgenv().AutoSteps = false
            getgenv().AutoTrails = false
            getgenv().AutoRace = false
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(Value)
        if Value then
            humanoid.WalkSpeed = 100
        else
            humanoid.WalkSpeed = 16
        end
    end
})

LegendsSpeedTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        getgenv().AntiAFK = Value
        if Value then
            player.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

LegendsSpeedTab:CreateButton({
    Name = "Collect All",
    Callback = function()
        pcall(function()
            for _, orb in pairs(workspace.orbFolder:GetChildren()) do
                ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", orb)
            end
            for _, gem in pairs(workspace.gemFolder:GetChildren()) do
                ReplicatedStorage.rEvents.gemEvent:FireServer("collectGem", gem)
            end
            for _, hoop in pairs(workspace.Hoops:GetChildren()) do
                ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", hoop)
            end
            ReplicatedStorage.rEvents.stepEvent:FireServer("buyAllSteps")
            ReplicatedStorage.rEvents.trailEvent:FireServer("buyAllTrails")
            ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
        end)
    end
})

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if Rayfield.Flags.SpeedBoost.Value then
        humanoid.WalkSpeed = 100
    end
end)

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "All features are ready to use!",
    Duration = 3
})
