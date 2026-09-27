--[[
============================================================
  SPX HUB — STEAL AN EGG (Custom Edition)
  Created for: Sopha Panha
  Place ID: 107778070777162
============================================================
]]

local Players         = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService      = game:GetService("RunService")
local StarterGui      = game:GetService("StarterGui")

local LocalPlayer     = Players.LocalPlayer

-- 🎨 THEME & CONFIG
local CONFIG = {
    AutoStealEnabled  = false,
    AutoCollectEnabled = false,
    SpeedBoostEnabled = false,
    ESPEnabled        = false,
    SpeedValue        = 60,
    StealInterval     = 0.2,
}

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = 3,
        })
    end)
end

-- 🔍 REMOTE RESOLVER (ស្វែងរក Remote ស្វ័យប្រវត្តិពីលទ្ធផល Scanner)
local function getRemote(name)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and obj.Name:lower() == name:lower() then
            return obj
        end
    end
    return nil
end

local remoteSteal = getRemote("SetSteal") or getRemote("StealEgg")
local remoteCollect = getRemote("AskFieldEggCarry") or getRemote("CollectEgg")

-- 🛡️ SILENT STEAL (លួចដោយមិនផ្ញើ Target ទីតាំងខ្លួនឯង ដើម្បីកុំឱ្យសត្វដេញតាម)
local function silentSteal()
    if remoteSteal then
        pcall(function()
            if remoteSteal:IsA("RemoteEvent") then
                -- ផ្ញើសញ្ញា True ដោយមិនបញ្ជូន Player Position ដើម្បីបន្លมប្រព័ន្ធសត្វដេញ
                remoteSteal:FireServer(true)
            end
        end)
    end
end

local function autoCollectEggs()
    if remoteCollect then
        pcall(function()
            if remoteCollect:IsA("RemoteEvent") then
                remoteCollect:FireServer()
            end
        end)
    end
end

-- ⚡ SPEED BOOST
local function applySpeed(on)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = on and CONFIG.SpeedValue or 16
        end
    end
end

-- 👀 ESP EGGS
local espFolder = nil
local function updateESP()
    if not CONFIG.ESPEnabled then
        if espFolder then espFolder:Destroy() espFolder = nil end
        return
    end
    if not espFolder then
        espFolder = Instance.new("Folder")
        espFolder.Name = "SPX_ESP"
        espFolder.Parent = workspace
    else
        espFolder:ClearAllChildren()
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("egg") and (obj:IsA("BasePart") or obj:IsA("Model")) then
            local hl = Instance.new("Highlight")
            hl.Adornee = obj
            hl.FillColor = Color3.fromRGB(0, 170, 255)
            hl.FillTransparency = 0.4
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = espFolder
        end
    end
end

-- 🖥️ GUI CREATION (SPX HUB UI)
local function makeGUI()
    local guiParent = LocalPlayer:WaitForChild("PlayerGui")
    pcall(function() if gethui then guiParent = gethui() end end)

    local old = guiParent:FindFirstChild("SPXHubMain")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SPXHubMain"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.Parent = guiParent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 360)
    frame.Position = UDim2.new(0, 30, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(15, 30, 60)
    header.BorderSizePixel = 0
    header.Parent = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -15, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "✦ SPX HUB — STEAL AN EGG ✦"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Scrolling Frame for Buttons
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -50)
    scroll.Position = UDim2.new(0, 0, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 5)
    pad.Parent = scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    local function addToggle(label, key, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = CONFIG[key] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(25, 40, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Text = label .. ": " .. (CONFIG[key] and "ON" or "OFF")
        btn.BorderSizePixel = 0
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Click:Connect(function()
            CONFIG[key] = not CONFIG[key]
            btn.Text = label .. ": " .. (CONFIG[key] and "ON" or "OFF")
            btn.BackgroundColor3 = CONFIG[key] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(25, 40, 70)
            if callback then callback(CONFIG[key]) end
        end)
    end

    addToggle("Silent Auto Steal", "AutoStealEnabled")
    addToggle("Auto Collect Eggs", "AutoCollectEnabled")
    addToggle("Speed Boost (60)", "SpeedBoostEnabled", function(on)
        applySpeed(on)
    end)
    addToggle("Egg ESP Highlighting", "ESPEnabled")
end

-- 🔄 MAIN LOOPS
task.spawn(function()
    while task.wait(CONFIG.StealInterval) do
        if CONFIG.AutoStealEnabled then
            pcall(silentSteal)
        end
        if CONFIG.AutoCollectEnabled then
            pcall(autoCollectEggs)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if CONFIG.ESPEnabled then
        pcall(updateESP)
    end
end)

-- INITIALIZE
pcall(makeGUI)
notify("SPX Hub", "Script loaded successfully!")