-- Bird Game Script
-- Scripter: svetho | UI Designer: smugily
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
 
-- ESP Storage
local espObjects = {}
local espEnabled = {
    Common = false,
    Rare = false,
    Mythical = false
}
local playerESPEnabled = false
local noclipEnabled = false
local noclipConnection = nil
 
-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BirdGameGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
 
-- ========== MAIN GUI ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 550)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui
 
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame
 
-- Animated gradient border
local borderFrame = Instance.new("Frame")
borderFrame.Name = "Border"
borderFrame.Size = UDim2.new(1, 4, 1, 4)
borderFrame.Position = UDim2.new(0, -2, 0, -2)
borderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
borderFrame.Parent = mainFrame
 
local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 22)
borderCorner.Parent = borderFrame
 
local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
borderGradient.Rotation = 45
borderGradient.Parent = borderFrame
 
-- Animate border
spawn(function()
    while wait(0.05) do
        borderGradient.Rotation = (borderGradient.Rotation + 2) % 360
    end
end)
 
-- Shadow effect
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame
 
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 26)
shadowCorner.Parent = shadow
 
-- Title bar with gradient
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
 
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
titleGradient.Rotation = 90
titleGradient.Parent = titleBar
 
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar
 
-- Fix bottom corners
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 20)
titleFix.Position = UDim2.new(0, 0, 1, -20)
titleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar
 
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐦 BIRD GAME SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar
 
-- Tab System
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 45)
tabContainer.Position = UDim2.new(0, 10, 0, 70)
tabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame
 
local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 12)
tabCorner.Parent = tabContainer
 
-- Tab Buttons
local function createTabButton(name, position, icon)
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Size = UDim2.new(0.5, -5, 1, -10)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Text = icon .. " " .. name
    button.TextColor3 = Color3.fromRGB(180, 180, 180)
    button.TextSize = 15
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = tabContainer
 
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
 
    return button
end
 
local mainTab = createTabButton("Main", UDim2.new(0, 5, 0, 5), "🔍")
local creditsTab = createTabButton("Made By", UDim2.new(0.5, 0, 0, 5), "👥")
 
-- Content Frames
local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1, 0, 1, -125)
mainContent.Position = UDim2.new(0, 0, 0, 125)
mainContent.BackgroundTransparency = 1
mainContent.Visible = true
mainContent.Parent = mainFrame
 
local creditsContent = Instance.new("Frame")
creditsContent.Name = "CreditsContent"
creditsContent.Size = UDim2.new(1, 0, 1, -125)
creditsContent.Position = UDim2.new(0, 0, 0, 125)
creditsContent.BackgroundTransparency = 1
creditsContent.Visible = false
creditsContent.Parent = mainFrame
 
-- Tab switching logic
local currentTab = "Main"
local function switchTab(tabName)
    currentTab = tabName
 
    if tabName == "Main" then
        mainContent.Visible = true
        creditsContent.Visible = false
        TweenService:Create(mainTab, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
        TweenService:Create(creditsTab, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(180, 180, 180)
        }):Play()
    else
        mainContent.Visible = false
        creditsContent.Visible = true
        TweenService:Create(creditsTab, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
        TweenService:Create(mainTab, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(180, 180, 180)
        }):Play()
    end
end
 
mainTab.MouseButton1Click:Connect(function() switchTab("Main") end)
creditsTab.MouseButton1Click:Connect(function() switchTab("Credits") end)
 
switchTab("Main")
 
-- ========== MAIN CONTENT SCROLL ==========
local mainScroll = Instance.new("ScrollingFrame")
mainScroll.Size = UDim2.new(1, -20, 1, -10)
mainScroll.Position = UDim2.new(0, 10, 0, 5)
mainScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainScroll.BorderSizePixel = 0
mainScroll.ScrollBarThickness = 6
mainScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
mainScroll.CanvasSize = UDim2.new(0, 0, 0, 540)
mainScroll.Parent = mainContent
 
local mainScrollCorner = Instance.new("UICorner")
mainScrollCorner.CornerRadius = UDim.new(0, 12)
mainScrollCorner.Parent = mainScroll
 
-- Player ESP & Noclip Buttons
local utilityHeader = Instance.new("TextLabel")
utilityHeader.Size = UDim2.new(1, -30, 0, 35)
utilityHeader.Position = UDim2.new(0, 15, 0, 10)
utilityHeader.BackgroundTransparency = 1
utilityHeader.Text = "⚡ UTILITIES"
utilityHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
utilityHeader.TextSize = 18
utilityHeader.Font = Enum.Font.GothamBold
utilityHeader.TextXAlignment = Enum.TextXAlignment.Left
utilityHeader.Parent = mainScroll
 
local function createUtilityButton(name, icon, position, color)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0.48, 0, 0, 45)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Text = icon .. " " .. name
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = mainScroll
 
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
 
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 2, 1, 2)
    glow.Position = UDim2.new(0, -1, 0, -1)
    glow.BackgroundColor3 = color
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = 0
    glow.Parent = button
 
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 10)
    glowCorner.Parent = glow
 
    return button, glow
end
 
local playerESPButton, playerESPGlow = createUtilityButton("Player ESP", "👤", UDim2.new(0, 15, 0, 55), Color3.fromRGB(255, 255, 255))
local noclipButton, noclipGlow = createUtilityButton("Noclip", "👻", UDim2.new(0.52, 0, 0, 55), Color3.fromRGB(255, 255, 255))
 
-- Egg ESP Header
local eggHeader = Instance.new("TextLabel")
eggHeader.Size = UDim2.new(1, -30, 0, 35)
eggHeader.Position = UDim2.new(0, 15, 0, 115)
eggHeader.BackgroundTransparency = 1
eggHeader.Text = "🥚 EGG TRACKING"
eggHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
eggHeader.TextSize = 18
eggHeader.Font = Enum.Font.GothamBold
eggHeader.TextXAlignment = Enum.TextXAlignment.Left
eggHeader.Parent = mainScroll
 
-- Teleport Functions
local function teleportToEgg(eggType, toPlot)
    local eggs = getAllEggs()
    local targetEggs = eggs[eggType]
 
    if #targetEggs == 0 then
        return
    end
 
    local targetEgg = targetEggs[1]
 
    if toPlot then
        local plotsFolder = workspace:FindFirstChild("Plots")
        if plotsFolder then
            for i = 1, 8 do
                local base = plotsFolder:FindFirstChild(tostring(i))
                if base then
                    for _, obj in pairs(base:GetDescendants()) do
                        if obj == targetEgg then
                            if base:IsA("BasePart") then
                                player.Character.HumanoidRootPart.CFrame = base.CFrame + Vector3.new(0, 5, 0)
                            elseif base.PrimaryPart then
                                player.Character.HumanoidRootPart.CFrame = base.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                            else
                                player.Character.HumanoidRootPart.CFrame = targetEgg.CFrame + Vector3.new(0, 5, 0)
                            end
                            return
                        end
                    end
                end
            end
        end
    end
 
    if targetEgg:IsA("BasePart") then
        player.Character.HumanoidRootPart.CFrame = targetEgg.CFrame + Vector3.new(0, 5, 0)
    elseif targetEgg:IsA("Model") and targetEgg.PrimaryPart then
        player.Character.HumanoidRootPart.CFrame = targetEgg.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
    end
end
 
-- Create egg row function
local function createEggRow(name, color, yPos)
    local row = Instance.new("Frame")
    row.Name = name .. "Row"
    row.Size = UDim2.new(1, -30, 0, 95)
    row.Position = UDim2.new(0, 15, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    row.BorderSizePixel = 0
    row.Parent = mainScroll
 
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 12)
    rowCorner.Parent = row
 
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 2, 1, 2)
    glow.Position = UDim2.new(0, -1, 0, -1)
    glow.BackgroundColor3 = color
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = 0
    glow.Parent = row
 
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 12)
    glowCorner.Parent = glow
 
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 6, 0, 40)
    indicator.Position = UDim2.new(0, 12, 0, 10)
    indicator.BackgroundColor3 = color
    indicator.BorderSizePixel = 0
    indicator.Parent = row
 
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
 
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 150, 0, 24)
    nameLabel.Position = UDim2.new(0, 28, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = color
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row
 
    local countLabel = Instance.new("TextLabel")
    countLabel.Name = "CountLabel"
    countLabel.Size = UDim2.new(0, 140, 0, 20)
    countLabel.Position = UDim2.new(0, 28, 0, 34)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "Found: 0"
    countLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    countLabel.TextSize = 13
    countLabel.Font = Enum.Font.Gotham
    countLabel.TextXAlignment = Enum.TextXAlignment.Left
    countLabel.Parent = row
 
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = UDim2.new(0, 85, 0, 28)
    espButton.Position = UDim2.new(1, -95, 0, 10)
    espButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    espButton.BorderSizePixel = 0
    espButton.Text = "ESP"
    espButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    espButton.TextSize = 13
    espButton.Font = Enum.Font.GothamBold
    espButton.AutoButtonColor = false
    espButton.Parent = row
 
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = espButton
 
    local tpPlotButton = Instance.new("TextButton")
    tpPlotButton.Name = "TPPlotButton"
    tpPlotButton.Size = UDim2.new(0, 200, 0, 28)
    tpPlotButton.Position = UDim2.new(0, 12, 1, -38)
    tpPlotButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tpPlotButton.BorderSizePixel = 0
    tpPlotButton.Text = "📍 TP to Plot"
    tpPlotButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tpPlotButton.TextSize = 13
    tpPlotButton.Font = Enum.Font.GothamBold
    tpPlotButton.AutoButtonColor = false
    tpPlotButton.Parent = row
 
    local tpPlotCorner = Instance.new("UICorner")
    tpPlotCorner.CornerRadius = UDim.new(0, 8)
    tpPlotCorner.Parent = tpPlotButton
 
    local tpEggButton = Instance.new("TextButton")
    tpEggButton.Name = "TPEggButton"
    tpEggButton.Size = UDim2.new(0, 200, 0, 28)
    tpEggButton.Position = UDim2.new(1, -212, 1, -38)
    tpEggButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tpEggButton.BorderSizePixel = 0
    tpEggButton.Text = "🥚 TP to Egg"
    tpEggButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tpEggButton.TextSize = 13
    tpEggButton.Font = Enum.Font.GothamBold
    tpEggButton.AutoButtonColor = false
    tpEggButton.Parent = row
 
    local tpEggCorner = Instance.new("UICorner")
    tpEggCorner.CornerRadius = UDim.new(0, 8)
    tpEggCorner.Parent = tpEggButton
 
    local function setupHover(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
        end)
 
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            }):Play()
        end)
    end
 
    setupHover(tpPlotButton)
    setupHover(tpEggButton)
 
    espButton.MouseEnter:Connect(function()
        if not espEnabled[name] then
            TweenService:Create(espButton, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
        end
    end)
 
    espButton.MouseLeave:Connect(function()
        if not espEnabled[name] then
            TweenService:Create(espButton, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            }):Play()
        end
    end)
 
    espButton.MouseButton1Click:Connect(function()
        espEnabled[name] = not espEnabled[name]
        if espEnabled[name] then
            espButton.Text = "ESP ON"
            TweenService:Create(espButton, TweenInfo.new(0.2), {
                BackgroundColor3 = color,
                TextColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()
        else
            espButton.Text = "ESP"
            TweenService:Create(espButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            clearESP(name)
        end
    end)
 
    tpPlotButton.MouseButton1Click:Connect(function()
        teleportToEgg(name, true)
    end)
 
    tpEggButton.MouseButton1Click:Connect(function()
        teleportToEgg(name, false)
    end)
 
    return row, countLabel
end
 
local commonRow, commonCountLabel = createEggRow("Common", Color3.fromRGB(200, 200, 200), 160)
local rareRow, rareCountLabel = createEggRow("Rare", Color3.fromRGB(150, 150, 150), 265)
local mythicalRow, mythicalCountLabel = createEggRow("Mythical", Color3.fromRGB(100, 100, 100), 370)
 
-- TP to Base Button (below egg rows)
local tpBaseButton = Instance.new("TextButton")
tpBaseButton.Name = "TPBaseButton"
tpBaseButton.Size = UDim2.new(1, -30, 0, 45)
tpBaseButton.Position = UDim2.new(0, 15, 0, 480)
tpBaseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpBaseButton.BorderSizePixel = 0
tpBaseButton.Text = "🏠 TP to Your Base"
tpBaseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpBaseButton.TextSize = 14
tpBaseButton.Font = Enum.Font.GothamBold
tpBaseButton.AutoButtonColor = false
tpBaseButton.Parent = mainScroll
 
local tpBaseCorner = Instance.new("UICorner")
tpBaseCorner.CornerRadius = UDim.new(0, 10)
tpBaseCorner.Parent = tpBaseButton
 
local tpBaseGlow = Instance.new("Frame")
tpBaseGlow.Size = UDim2.new(1, 2, 1, 2)
tpBaseGlow.Position = UDim2.new(0, -1, 0, -1)
tpBaseGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tpBaseGlow.BackgroundTransparency = 0.9
tpBaseGlow.BorderSizePixel = 0
tpBaseGlow.ZIndex = 0
tpBaseGlow.Parent = tpBaseButton
 
local tpBaseGlowCorner = Instance.new("UICorner")
tpBaseGlowCorner.CornerRadius = UDim.new(0, 10)
tpBaseGlowCorner.Parent = tpBaseGlow
 
-- TP to Base Function
local function teleportToBase()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        warn("Character not found!")
        return
    end
 
    print("Attempting to teleport to spawn...")
 
    -- Get the player's spawn location
    local spawnLocation = player.RespawnLocation
 
    -- If RespawnLocation is set, teleport there
    if spawnLocation and spawnLocation:IsA("SpawnLocation") then
        print("Found RespawnLocation, teleporting...")
        player.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
        return
    end
 
    -- Otherwise, search for spawn locations in workspace
    local spawns = {}
 
    -- Check for team spawns if player is on a team
    if player.Team then
        print("Checking for team spawns...")
        for _, spawn in pairs(workspace:GetDescendants()) do
            if spawn:IsA("SpawnLocation") and spawn.TeamColor == player.TeamColor then
                table.insert(spawns, spawn)
            end
        end
    end
 
    -- If no team spawns found, get neutral spawns
    if #spawns == 0 then
        print("Checking for neutral spawns...")
        for _, spawn in pairs(workspace:GetDescendants()) do
            if spawn:IsA("SpawnLocation") and spawn.Neutral then
                table.insert(spawns, spawn)
            end
        end
    end
 
    -- If no neutral spawns, get ANY spawn
    if #spawns == 0 then
        print("Checking for any spawns...")
        for _, spawn in pairs(workspace:GetDescendants()) do
            if spawn:IsA("SpawnLocation") then
                table.insert(spawns, spawn)
            end
        end
    end
 
    -- If spawns found, teleport to the first one
    if #spawns > 0 then
        print("Found spawn, teleporting...")
        player.Character.HumanoidRootPart.CFrame = spawns[1].CFrame + Vector3.new(0, 5, 0)
        return
    end
 
    -- Fallback: Try to find player's plot/base in Plots folder
    print("Checking Plots folder...")
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        -- Try different plot numbering systems
        for i = 1, 100 do
            local possibleBase = plotsFolder:FindFirstChild(tostring(i))
            if possibleBase then
                local ownerValue = possibleBase:FindFirstChild("Owner")
                if ownerValue and (ownerValue.Value == player or ownerValue.Value == player.UserId or ownerValue.Value == player.Name) then
                    print("Found player's plot:", i)
                    if possibleBase:IsA("BasePart") then
                        player.Character.HumanoidRootPart.CFrame = possibleBase.CFrame + Vector3.new(0, 5, 0)
                    elseif possibleBase.PrimaryPart then
                        player.Character.HumanoidRootPart.CFrame = possibleBase.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    else
                        -- Find any BasePart in the plot
                        for _, part in pairs(possibleBase:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name:lower():find("spawn") then
                                player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                                return
                            end
                        end
                        -- If no spawn found, just teleport to first basepart
                        for _, part in pairs(possibleBase:GetDescendants()) do
                            if part:IsA("BasePart") then
                                player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 10, 0)
                                return
                            end
                        end
                    end
                    return
                end
            end
        end
 
        -- Try by player name
        local playerBase = plotsFolder:FindFirstChild(player.Name)
        if playerBase then
            print("Found base by player name")
            if playerBase:IsA("BasePart") then
                player.Character.HumanoidRootPart.CFrame = playerBase.CFrame + Vector3.new(0, 5, 0)
                return
            end
        end
    end
 
    -- Last resort: teleport to 0, 50, 0 (common spawn height)
    print("Using fallback spawn position...")
    player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
end
 
-- TP to Base Button Handler
tpBaseButton.MouseButton1Click:Connect(function()
    teleportToBase()
    -- Flash effect on click
    TweenService:Create(tpBaseButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    wait(0.1)
    TweenService:Create(tpBaseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
end)
 
tpBaseButton.MouseEnter:Connect(function()
    TweenService:Create(tpBaseButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
    TweenService:Create(tpBaseGlow, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.7
    }):Play()
end)
 
tpBaseButton.MouseLeave:Connect(function()
    TweenService:Create(tpBaseButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
    TweenService:Create(tpBaseGlow, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.9
    }):Play()
end)
 
-- Player ESP Functions
local playerESPObjects = {}
 
local function createPlayerESP(targetPlayer)
    if playerESPObjects[targetPlayer] or targetPlayer == player then return end
 
    local char = targetPlayer.Character
    if not char then return end
 
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Adornee = char:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char:FindFirstChild("HumanoidRootPart")
 
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = targetPlayer.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 18
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.4
    textLabel.Parent = billboard
 
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = char
 
    playerESPObjects[targetPlayer] = {billboard, highlight}
end
 
local function clearPlayerESP()
    for targetPlayer, espData in pairs(playerESPObjects) do
        if espData[1] then espData[1]:Destroy() end
        if espData[2] then espData[2]:Destroy() end
        playerESPObjects[targetPlayer] = nil
    end
end
 
local function updatePlayerESP()
    if playerESPEnabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                createPlayerESP(targetPlayer)
            end
        end
    end
end
 
-- Noclip Function
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
 
    if noclipEnabled then
        noclipButton.Text = "👻 Noclip ON"
        TweenService:Create(noclipButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
        TweenService:Create(noclipGlow, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.7
        }):Play()
 
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipButton.Text = "👻 Noclip"
        TweenService:Create(noclipButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
        TweenService:Create(noclipGlow, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.9
        }):Play()
 
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
 
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end
 
-- Player ESP Button Handler
playerESPButton.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
 
    if playerESPEnabled then
        playerESPButton.Text = "👤 Player ESP ON"
        TweenService:Create(playerESPButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
        TweenService:Create(playerESPGlow, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.7
        }):Play()
        updatePlayerESP()
    else
        playerESPButton.Text = "👤 Player ESP"
        TweenService:Create(playerESPButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
        TweenService:Create(playerESPGlow, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.9
        }):Play()
        clearPlayerESP()
    end
end)
 
playerESPButton.MouseEnter:Connect(function()
    if not playerESPEnabled then
        TweenService:Create(playerESPButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        }):Play()
    end
end)
 
playerESPButton.MouseLeave:Connect(function()
    if not playerESPEnabled then
        TweenService:Create(playerESPButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end
end)
 
-- Noclip Button Handler
noclipButton.MouseButton1Click:Connect(toggleNoclip)
 
noclipButton.MouseEnter:Connect(function()
    if not noclipEnabled then
        TweenService:Create(noclipButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        }):Play()
    end
end)
 
noclipButton.MouseLeave:Connect(function()
    if not noclipEnabled then
        TweenService:Create(noclipButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end
end)
 
-- ========== CREDITS CONTENT ==========
local creditsScroll = Instance.new("ScrollingFrame")
creditsScroll.Size = UDim2.new(1, -20, 1, -10)
creditsScroll.Position = UDim2.new(0, 10, 0, 5)
creditsScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
creditsScroll.BorderSizePixel = 0
creditsScroll.ScrollBarThickness = 6
creditsScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
creditsScroll.CanvasSize = UDim2.new(0, 0, 0, 635)
creditsScroll.Parent = creditsContent
 
local creditsScrollCorner = Instance.new("UICorner")
creditsScrollCorner.CornerRadius = UDim.new(0, 12)
creditsScrollCorner.Parent = creditsScroll
 
local creditsHeader = Instance.new("TextLabel")
creditsHeader.Size = UDim2.new(1, -30, 0, 40)
creditsHeader.Position = UDim2.new(0, 15, 0, 15)
creditsHeader.BackgroundTransparency = 1
creditsHeader.Text = "✨ DEVELOPMENT TEAM"
creditsHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
creditsHeader.TextSize = 20
creditsHeader.Font = Enum.Font.GothamBold
creditsHeader.TextXAlignment = Enum.TextXAlignment.Left
creditsHeader.Parent = creditsScroll
 
local scripterCard = Instance.new("Frame")
scripterCard.Size = UDim2.new(1, -30, 0, 100)
scripterCard.Position = UDim2.new(0, 15, 0, 65)
scripterCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scripterCard.BorderSizePixel = 0
scripterCard.Parent = creditsScroll
 
local scripterCorner = Instance.new("UICorner")
scripterCorner.CornerRadius = UDim.new(0, 12)
scripterCorner.Parent = scripterCard
 
local scripterGlow = Instance.new("Frame")
scripterGlow.Size = UDim2.new(1, 2, 1, 2)
scripterGlow.Position = UDim2.new(0, -1, 0, -1)
scripterGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scripterGlow.BackgroundTransparency = 0.85
scripterGlow.BorderSizePixel = 0
scripterGlow.ZIndex = 0
scripterGlow.Parent = scripterCard
 
local scripterGlowCorner = Instance.new("UICorner")
scripterGlowCorner.CornerRadius = UDim.new(0, 12)
scripterGlowCorner.Parent = scripterGlow
 
local scripterIcon = Instance.new("TextLabel")
scripterIcon.Size = UDim2.new(0, 60, 0, 60)
scripterIcon.Position = UDim2.new(0, 15, 0, 20)
scripterIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scripterIcon.BackgroundTransparency = 0.8
scripterIcon.BorderSizePixel = 0
scripterIcon.Text = "💻"
scripterIcon.TextSize = 32
scripterIcon.Font = Enum.Font.GothamBold
scripterIcon.Parent = scripterCard
 
local scripterIconCorner = Instance.new("UICorner")
scripterIconCorner.CornerRadius = UDim.new(0, 10)
scripterIconCorner.Parent = scripterIcon
 
local scripterRole = Instance.new("TextLabel")
scripterRole.Size = UDim2.new(1, -95, 0, 20)
scripterRole.Position = UDim2.new(0, 85, 0, 20)
scripterRole.BackgroundTransparency = 1
scripterRole.Text = "SCRIPTER"
scripterRole.TextColor3 = Color3.fromRGB(180, 180, 180)
scripterRole.TextSize = 12
scripterRole.Font = Enum.Font.GothamBold
scripterRole.TextXAlignment = Enum.TextXAlignment.Left
scripterRole.Parent = scripterCard
 
local scripterName = Instance.new("TextLabel")
scripterName.Size = UDim2.new(1, -95, 0, 28)
scripterName.Position = UDim2.new(0, 85, 0, 40)
scripterName.BackgroundTransparency = 1
scripterName.Text = "svetho"
scripterName.TextColor3 = Color3.fromRGB(255, 255, 255)
scripterName.TextSize = 20
scripterName.Font = Enum.Font.GothamBold
scripterName.TextXAlignment = Enum.TextXAlignment.Left
scripterName.Parent = scripterCard
 
local designerCard = Instance.new("Frame")
designerCard.Size = UDim2.new(1, -30, 0, 100)
designerCard.Position = UDim2.new(0, 15, 0, 180)
designerCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
designerCard.BorderSizePixel = 0
designerCard.Parent = creditsScroll
 
local designerCorner = Instance.new("UICorner")
designerCorner.CornerRadius = UDim.new(0, 12)
designerCorner.Parent = designerCard
 
local designerGlow = Instance.new("Frame")
designerGlow.Size = UDim2.new(1, 2, 1, 2)
designerGlow.Position = UDim2.new(0, -1, 0, -1)
designerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
designerGlow.BackgroundTransparency = 0.85
designerGlow.BorderSizePixel = 0
designerGlow.ZIndex = 0
designerGlow.Parent = designerCard
 
local designerGlowCorner = Instance.new("UICorner")
designerGlowCorner.CornerRadius = UDim.new(0, 12)
designerGlowCorner.Parent = designerGlow
 
local designerIcon = Instance.new("TextLabel")
designerIcon.Size = UDim2.new(0, 60, 0, 60)
designerIcon.Position = UDim2.new(0, 15, 0, 20)
designerIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
designerIcon.BackgroundTransparency = 0.8
designerIcon.BorderSizePixel = 0
designerIcon.Text = "🎨"
designerIcon.TextSize = 32
designerIcon.Font = Enum.Font.GothamBold
designerIcon.Parent = designerCard
 
local designerIconCorner = Instance.new("UICorner")
designerIconCorner.CornerRadius = UDim.new(0, 10)
designerIconCorner.Parent = designerIcon
 
local designerRole = Instance.new("TextLabel")
designerRole.Size = UDim2.new(1, -95, 0, 20)
designerRole.Position = UDim2.new(0, 85, 0, 20)
designerRole.BackgroundTransparency = 1
designerRole.Text = "UI DESIGNER"
designerRole.TextColor3 = Color3.fromRGB(180, 180, 180)
designerRole.TextSize = 12
designerRole.Font = Enum.Font.GothamBold
designerRole.TextXAlignment = Enum.TextXAlignment.Left
designerRole.Parent = designerCard
 
local designerName = Instance.new("TextLabel")
designerName.Size = UDim2.new(1, -95, 0, 28)
designerName.Position = UDim2.new(0, 85, 0, 40)
designerName.BackgroundTransparency = 1
designerName.Text = "smugily"
designerName.TextColor3 = Color3.fromRGB(255, 255, 255)
designerName.TextSize = 20
designerName.Font = Enum.Font.GothamBold
designerName.TextXAlignment = Enum.TextXAlignment.Left
designerName.Parent = designerCard
 
local infoHeader = Instance.new("TextLabel")
infoHeader.Size = UDim2.new(1, -30, 0, 40)
infoHeader.Position = UDim2.new(0, 15, 0, 295)
infoHeader.BackgroundTransparency = 1
infoHeader.Text = "ℹ️ INFORMATION"
infoHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
infoHeader.TextSize = 20
infoHeader.Font = Enum.Font.GothamBold
infoHeader.TextXAlignment = Enum.TextXAlignment.Left
infoHeader.Parent = creditsScroll
 
local infoBox = Instance.new("Frame")
infoBox.Size = UDim2.new(1, -30, 0, 170)
infoBox.Position = UDim2.new(0, 15, 0, 345)
infoBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infoBox.BorderSizePixel = 0
infoBox.Parent = creditsScroll
 
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 12)
infoCorner.Parent = infoBox
 
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -30, 1, -30)
infoText.Position = UDim2.new(0, 15, 0, 15)
infoText.BackgroundTransparency = 1
infoText.Text = [[📌 Version: 2.0 Enhanced
🔑 Toggle Key: Press 'H'
🎯 Features: Egg ESP, Player ESP, Noclip, Teleport
⚡ Performance: Optimized
🌐 Theme: Black & White Minimalist
💡 Support: Community Driven
 
This script helps you locate and collect eggs efficiently across all game plots. Use ESP to visualize eggs and players through walls, noclip to walk through objects, and teleport directly to eggs or plots!]]
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 12
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.Parent = infoBox
 
-- ========== LOADING OVERLAY ==========
local loadingOverlay = Instance.new("Frame")
loadingOverlay.Name = "LoadingOverlay"
loadingOverlay.Size = UDim2.new(1, 0, 1, -60)
loadingOverlay.Position = UDim2.new(0, 0, 0, 60)
loadingOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadingOverlay.BackgroundTransparency = 0.2
loadingOverlay.BorderSizePixel = 0
loadingOverlay.ZIndex = 10
loadingOverlay.Parent = mainFrame
 
local overlayCorner = Instance.new("UICorner")
overlayCorner.CornerRadius = UDim.new(0, 20)
overlayCorner.Parent = loadingOverlay
 
local overlayFix = Instance.new("Frame")
overlayFix.Size = UDim2.new(1, 0, 0, 20)
overlayFix.Position = UDim2.new(0, 0, 0, 0)
overlayFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
overlayFix.BackgroundTransparency = 0.2
overlayFix.BorderSizePixel = 0
overlayFix.ZIndex = 10
overlayFix.Parent = loadingOverlay
 
local loadingContent = Instance.new("Frame")
loadingContent.Size = UDim2.new(0, 320, 0, 240)
loadingContent.Position = UDim2.new(0.5, -160, 0.5, -120)
loadingContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loadingContent.BorderSizePixel = 0
loadingContent.ZIndex = 11
loadingContent.Parent = loadingOverlay
 
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 16)
contentCorner.Parent = loadingContent
 
local contentBorder = Instance.new("Frame")
contentBorder.Size = UDim2.new(1, 3, 1, 3)
contentBorder.Position = UDim2.new(0, -1.5, 0, -1.5)
contentBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
contentBorder.BackgroundTransparency = 0.5
contentBorder.BorderSizePixel = 0
contentBorder.ZIndex = 10
contentBorder.Parent = loadingContent
 
local contentBorderCorner = Instance.new("UICorner")
contentBorderCorner.CornerRadius = UDim.new(0, 17)
contentBorderCorner.Parent = contentBorder
 
local loadingIcon = Instance.new("TextLabel")
loadingIcon.Size = UDim2.new(0, 100, 0, 100)
loadingIcon.Position = UDim2.new(0.5, -50, 0, 30)
loadingIcon.BackgroundTransparency = 1
loadingIcon.Text = "🐦"
loadingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingIcon.TextSize = 75
loadingIcon.Font = Enum.Font.GothamBold
loadingIcon.ZIndex = 12
loadingIcon.Parent = loadingContent
 
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 30)
loadingText.Position = UDim2.new(0, 20, 0, 140)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Initializing..."
loadingText.TextColor3 = Color3.fromRGB(230, 230, 230)
loadingText.TextSize = 18
loadingText.Font = Enum.Font.GothamBold
loadingText.ZIndex = 12
loadingText.Parent = loadingContent
 
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(0, 280, 0, 10)
loadingBarBg.Position = UDim2.new(0.5, -140, 1, -45)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.ZIndex = 12
loadingBarBg.Parent = loadingContent
 
local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(1, 0)
loadingBarCorner.Parent = loadingBarBg
 
local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingBar.BorderSizePixel = 0
loadingBar.ZIndex = 13
loadingBar.Parent = loadingBarBg
 
local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(1, 0)
loadingBarFillCorner.Parent = loadingBar
 
-- ESP Functions
local function createESP(egg, eggType)
    if espObjects[egg] then return end
 
    local color = Color3.fromRGB(200, 200, 200)
    if eggType == "Rare" then
        color = Color3.fromRGB(150, 150, 150)
    elseif eggType == "Mythical" then
        color = Color3.fromRGB(100, 100, 100)
    end
 
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EggESP"
    billboard.Adornee = egg
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = egg
 
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = eggType
    textLabel.TextColor3 = color
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.4
    textLabel.Parent = billboard
 
    local highlight = Instance.new("Highlight")
    highlight.Name = "EggHighlight"
    highlight.Adornee = egg
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = egg
 
    espObjects[egg] = {billboard, highlight, eggType}
end
 
function clearESP(eggType)
    for egg, espData in pairs(espObjects) do
        if espData[3] == eggType then
            if espData[1] then espData[1]:Destroy() end
            if espData[2] then espData[2]:Destroy() end
            espObjects[egg] = nil
        end
    end
end
 
function getAllEggs()
    local eggs = {
        Common = {},
        Rare = {},
        Mythical = {}
    }
 
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Common" then
            table.insert(eggs.Common, obj)
        elseif obj.Name == "Rare" then
            table.insert(eggs.Rare, obj)
        elseif obj.Name == "Mythical" then
            table.insert(eggs.Mythical, obj)
        end
    end
 
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for i = 1, 8 do
            local base = plotsFolder:FindFirstChild(tostring(i))
            if base then
                for _, obj in pairs(base:GetDescendants()) do
                    if obj.Name == "Common" then
                        table.insert(eggs.Common, obj)
                    elseif obj.Name == "Rare" then
                        table.insert(eggs.Rare, obj)
                    elseif obj.Name == "Mythical" then
                        table.insert(eggs.Mythical, obj)
                    end
                end
            end
        end
    end
 
    return eggs
end
 
local function updateDisplay()
    local eggs = getAllEggs()
 
    commonCountLabel.Text = "Found: " .. #eggs.Common
    rareCountLabel.Text = "Found: " .. #eggs.Rare
    mythicalCountLabel.Text = "Found: " .. #eggs.Mythical
 
    for eggType, eggList in pairs(eggs) do
        if espEnabled[eggType] then
            for _, egg in pairs(eggList) do
                if egg and egg.Parent then
                    createESP(egg, eggType)
                end
            end
        end
    end
 
    for egg, _ in pairs(espObjects) do
        if not egg or not egg.Parent then
            espObjects[egg] = nil
        end
    end
end
 
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
 
    if input.KeyCode == Enum.KeyCode.H then
        guiVisible = not guiVisible
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = guiVisible and UDim2.new(0, 480, 0, 550) or UDim2.new(0, 480, 0, 0)
        }):Play()
        wait(0.1)
        mainFrame.Visible = guiVisible
    end
end)
 
local function animateLoading()
    spawn(function()
        for i = 1, 12 do
            TweenService:Create(loadingIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 20,
                Size = UDim2.new(0, 105, 0, 105)
            }):Play()
            wait(0.3)
            TweenService:Create(loadingIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Rotation = -20,
                Size = UDim2.new(0, 100, 0, 100)
            }):Play()
            wait(0.3)
        end
    end)
 
    local loadingSteps = {
        {progress = 0.2, text = "🔍 Scanning workspace..."},
        {progress = 0.4, text = "🐦 Loading bird data..."},
        {progress = 0.6, text = "📦 Loading egg data..."},
        {progress = 0.8, text = "⚡ Initializing features..."},
        {progress = 1, text = "✅ Complete!"}
    }
 
    for _, step in ipairs(loadingSteps) do
        loadingText.Text = step.text
        TweenService:Create(loadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = UDim2.new(step.progress, 0, 1, 0)
        }):Play()
        wait(0.6)
    end
 
    wait(0.5)
 
    TweenService:Create(loadingOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(overlayFix, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadingContent, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(contentBorder, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadingIcon, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(loadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(loadingBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadingBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
 
    wait(0.5)
    loadingOverlay:Destroy()
end
 
spawn(animateLoading)
 
spawn(function()
    while wait(2) do
        if mainFrame.Visible and currentTab == "Main" then
            updateDisplay()
            if playerESPEnabled then
                updatePlayerESP()
            end
        end
    end
end)
 
wait(3.5)
updateDisplay()
 
print("🐦 Bird Game Script v2.0 - Loaded!")
print("👥 Credits: Scripter: svetho | UI Designer: smugily")
print("🔑 Press H to toggle visibility")
