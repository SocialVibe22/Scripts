local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Verificar o jogo atual
local placeId = game.PlaceId

-- Criar janela principal
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

-- Serviços
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

-- IDs dos jogos
local GAMES = {
    LEGENDS_OF_SPEED = 3101667897,
    NINJA_LEGENDS = 3956818381,
    DOORS = 6516141723,
    BUILD_A_BOAT = 537413528
}

-- Criar a tab do Legends of Speed
if placeId == GAMES.LEGENDS_OF_SPEED then
    -- Legends of Speed Tab
    local LegendsSpeedTab = Window:CreateTab("Legends of Speed", 4483362458)
    
    -- Auto Farm Section
    local FarmingSection = LegendsSpeedTab:CreateSection("Auto Farming")

    LegendsSpeedTab:CreateToggle({
        Name = "Auto Collect Orbs",
        CurrentValue = false,
        Flag = "AutoOrbs",
        Callback = function(Value)
            getgenv().AutoOrbs = Value
            
            while getgenv().AutoOrbs do
                pcall(function()
                    for _, orb in pairs(workspace.orbFolder:GetChildren()) do
                        if orb:IsA("Part") then
                            local args = {
                                [1] = "collectOrb",
                                [2] = orb
                            }
                            ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                        end
                    end

                    for _, world in pairs(workspace:GetChildren()) do
                        if world.Name:match("World") then
                            for _, orb in pairs(world:GetDescendants()) do
                                if orb:IsA("Part") and orb.Name == "outerOrb" then
                                    local args = {
                                        [1] = "collectOrb",
                                        [2] = orb
                                    }
                                    ReplicatedStorage.rEvents.orbEvent:FireServer(unpack(args))
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
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
                task.wait(0.1)
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
                task.wait(1)
            end
        end
    })

    -- World Teleport Section
    local TeleportSection = LegendsSpeedTab:CreateSection("World Teleport")

    LegendsSpeedTab:CreateDropdown({
        Name = "Teleport to World",
        Options = {"City", "Snow City", "Magma City", "Space", "Candy Land"},
        CurrentOption = "City",
        Flag = "SelectedWorld",
        Callback = function(Value)
            local positions = {
                ["City"] = CFrame.new(-9682.98, 74.8522, 3099.89),
                ["Snow City"] = CFrame.new(-9676.01, 74.8522, 3782.31),
                ["Magma City"] = CFrame.new(-11054.9, 74.8522, 3819.92),
                ["Space"] = CFrame.new(-8629.7998, 74.8522, 3735.96997),
                ["Candy Land"] = CFrame.new(-11054.9, 74.8522, 4048.97)
            }
            
            if positions[Value] then
                rootPart.CFrame = positions[Value]
            end
        end
    })

    -- Auto Buy Section
    local ShopSection = LegendsSpeedTab:CreateSection("Auto Buy")

    LegendsSpeedTab:CreateButton({
        Name = "Buy All Steps",
        Callback = function()
            ReplicatedStorage.rEvents.stepEvent:FireServer("buyAllSteps")
        end
    })

    LegendsSpeedTab:CreateButton({
        Name = "Buy All Trails",
        Callback = function()
            ReplicatedStorage.rEvents.trailEvent:FireServer("buyAllTrails")
        end
    })

elseif placeId == GAMES.NINJA_LEGENDS then
    -- Carregar Ninja Legends Tab
    loadstring(game:HttpGet('https://raw.githubusercontent.com/yourrepo/NinjaLegendsTab.lua'))()
    
elseif placeId == GAMES.DOORS then
    -- Carregar Doors Tab
    loadstring(game:HttpGet('https://raw.githubusercontent.com/yourrepo/DoorsTab.lua'))()
    
elseif placeId == GAMES.BUILD_A_BOAT then
    -- Carregar Build a Boat Tab
    loadstring(game:HttpGet('https://raw.githubusercontent.com/yourrepo/BuildABoatTab.lua'))()
else
    -- Notificar que o jogo não é suportado
    Rayfield:Notify({
        Title = "Game Not Supported",
        Content = "This game is not currently supported by MasterHub!",
        Duration = 5
    })
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
