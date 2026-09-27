--[[
============================================================
  SPX HUB — STEAL AN EGG (Escape Edition)
  Created for: Sopha Panha
  Place ID: 107778070777162
============================================================
]]

local Players         = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService      = game:GetService("RunService")
local StarterGui      = game:GetService("StarterGui")

local LocalPlayer     = Players.LocalPlayer

-- 🎨 CONFIG & STATE
local CONFIG = {
    AutoStealEnabled    = false,
    AutoCollectEnabled  = false,
    SpeedBoostEnabled   = false,
    ESPEnabled          = false,
    TeleportEscape      = true, -- គេចខ្លួនស្វ័យប្រវត្តិក្រោយពេលលួច
    SpeedValue          = 60,
    StealInterval       = 0.3,
}

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = 3,
        })
    end)
end

-- 🔍 REMOTE RESOLVER
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

-- 🏠 រកមើលទីតាំង Base របស់អ្នកផ្ទាល់ដើម្បីជាកន្លែងគេចខ្លួន
local function getMyBasePosition()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return Vector3.new(0, 10, 0) end
    for _, plot in ipairs(plots:GetChildren()) do
        local data = plot:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner:IsA("ObjectValue") then
            local v = owner.Value
            if v and (v.Name == LocalPlayer.Name or tostring(v) == tostring(LocalPlayer.UserId)) then
                return plot:GetPivot().Position + Vector3.new(0, 5, 0)
            end
        end
    end
    return Vector3.new(0, 10, 0) -- Fallback position
end

-- ⚡ TELEPORT ESCAPE 
local function escapeToSafety()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local safePos = getMyBasePosition()
        hrp.CFrame = CFrame.new(safePos)
    end
end

-- 🛡️ SILENT STEAL + ESCAPE
local function silentSteal()
    if remoteSteal then
        pcall(function()
            if remoteSteal:IsA("RemoteEvent") then
                remoteSteal:FireServer(true)
            end
        end)
        if CONFIG.TeleportEscape then
            task.delay(0.05, escapeToSafety) -- ហោះគេចភ្លាមៗក្រោយបញ្ជូនសញ្ញាលួច
        end
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
    frame.Size = UDim2.new(0, 280, 0, 390)
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
    title.Text = "✦ SPX HUB — ESCAPE MODE ✦"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Scrolling Frame
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
    addToggle("Auto-Escape (Teleport)", "TeleportEscape")
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
notify("SPX Hub", "Escape Mode loaded successfully!")
