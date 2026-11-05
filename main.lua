
--==================================================
--       SP ROBLOX SCRIPT HUB PRO
--       Developer: Sopha Panha
--       UI Library: Rayfield
--==================================================

-- [1] LOGO SETTINGS
-- ប្តូរ ID ទៅជា Roblox Image Asset ID របស់អ្នក
local LOGO_ID = 134486997418064

--==================================================
-- [2] LOAD RAYFIELD UI
--==================================================

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/rayfield")
)()

--==================================================
-- [3] CREATE MAIN WINDOW
--==================================================

local Window = Rayfield:CreateWindow({

    Name = "SP ROBLOX SCRIPT HUB",

    Icon = LOGO_ID,

    LoadingTitle = "SP ROBLOX",

    LoadingSubtitle = "Premium Script Hub | By Sopha Panha",

    ShowText = "SP HUB",

    Theme = "Dark",

    ToggleUIKeybind = "K",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SP_ROBLOX_SCRIPT",
        FileName = "SP_Hub"
    },

    Discord = {
        Enabled = false,
        Invite = "SPROBLOX",
        RememberJoins = true
    },

    KeySystem = false
})

--==================================================
-- [4] HELPER FUNCTIONS
--==================================================

local function Notify(title, message, duration)

    Rayfield:Notify({
        Title = title,
        Content = message,
        Duration = duration or 3
    })

end

local function LoadScript(scriptName, scriptURL)

    Notify(
        "SP ROBLOX",
        "កំពុងបើក " .. scriptName .. "...",
        3
    )

    local success, errorMessage = pcall(function()

        local source = game:HttpGet(scriptURL)

        local scriptFunction = loadstring(source)

        assert(scriptFunction, "Cannot compile script")

        scriptFunction()

    end)

    if success then

        Notify(
            "SP ROBLOX",
            scriptName .. " ដំណើរការរួចរាល់!",
            4
        )

    else

        Notify(
            "SP ROBLOX ERROR",
            tostring(errorMessage),
            6
        )

        warn("[SP HUB ERROR] " .. tostring(errorMessage))

    end

end

--==================================================
-- [5] TAB 1 : STEAL AN EGG
--==================================================

local LOGO_ID = 134486997418064

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/rayfield")
)()

local Window = Rayfield:CreateWindow({
    Name = "SP ROBLOX SCRIPT HUB",
    Icon = LOGO_ID,
    LoadingTitle = "SP ROBLOX",
    LoadingSubtitle = "Premium Script Hub",
    Theme = "Dark",
    ToggleUIKeybind = "K",
    KeySystem = false
})

local EggTab = Window:CreateTab("🥚 Steal an Egg", LOGO_ID)

EggTab:CreateSection("SP ROBLOX | STEAL AN EGG")

EggTab:CreateLabel("Welcome to SP ROBLOX SCRIPT HUB")

EggTab:CreateLabel("Select your favorite script below")

-- CODIUMHUB

EggTab:CreateButton({

    Name = "🔵 CODIUMHUB | Android & IOS",

    Callback = function()

        LoadScript(
            "Codiumhub",
            "https://getcodium.xyz/loader.luau"
        )

    end

})

-- CHILLI HUB

EggTab:CreateButton({

    Name = "🌶️ CHILLI HUB SCRIPT | Android",

    Callback = function()

        LoadScript(
            "Chilli Hub",
            "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"
        )

    end

})

-- FYY SCRIPT

EggTab:CreateButton({

    Name = "🍎 FYY SCRIPT | IOS",

    Callback = function()

        LoadScript(
            "FYY Script",
            "https://FyyCommunity.net"
        )

    end

})

-- VENYX HUB

EggTab:CreateButton({

    Name = "⚡ VENYX HUB | Smoother & Faster",

    Callback = function()

        LoadScript(
            "Venyxhub",
            "https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"
        )

    end

})

--==================================================
-- [6] TAB 2 : SP ROBLOX SETTINGS
--==================================================

local SettingsTab = Window:CreateTab(
    "⚙️ Settings",
    LOGO_ID
)

SettingsTab:CreateSection("UI CONTROL")

SettingsTab:CreateLabel("SP ROBLOX SCRIPT HUB PRO")

SettingsTab:CreateLabel("Press K to Hide / Show UI")

SettingsTab:CreateButton({

    Name = "🔄 UI Information",

    Callback = function()

        Notify(
            "SP ROBLOX",
            "Press K to Hide / Show the Hub.",
            5
        )

    end

})

SettingsTab:CreateSection("CLOSE HUB")

SettingsTab:CreateButton({

    Name = "❌ CLOSE SP ROBLOX HUB",

    Callback = function()

        Rayfield:Destroy()

    end

})

--==================================================
-- [7] TAB 3 : INFORMATION
--==================================================

local InfoTab = Window:CreateTab(
    "ℹ️ Information",
    LOGO_ID
)

InfoTab:CreateSection("DEVELOPER INFORMATION")

InfoTab:CreateLabel("Developer: @sophapanha")

InfoTab:CreateLabel("Channel: SP ROBLOX")

InfoTab:CreateSection("SOCIAL MEDIA")

InfoTab:CreateButton({

    Name = "📢 Telegram Channel: @SPROBLOX",

    Callback = function()

        if setclipboard then

            setclipboard("https://t.me/SPROBLOX")

            Notify(
                "SP ROBLOX",
                "Telegram link copied!",
                3
            )

        else

            Notify(
                "SP ROBLOX",
                "Telegram: https://t.me/SPROBLOX",
                5
            )

        end

    end

})

InfoTab:CreateButton({

    Name = "▶️ YouTube: @sp_roblox1",

    Callback = function()

        if setclipboard then

            setclipboard("https://youtube.com/@sp_roblox1")

            Notify(
                "SP ROBLOX",
                "YouTube link copied!",
                3
            )

        end

    end

})

InfoTab:CreateButton({

    Name = "🌐 SP ROBLOX Website",

    Callback = function()

        if setclipboard then

            setclipboard("https://sp-roblox.vercel.app")

            Notify(
                "SP ROBLOX",
                "Website link copied!",
                3
            )

        end

    end

})

--==================================================
-- [8] STARTUP NOTIFICATION
--==================================================

Notify(
    "SP ROBLOX SCRIPT HUB",
    "Welcome! SP HUB PRO Loaded Successfully.",
    6
)

print("====================================")
print("       SP ROBLOX SCRIPT HUB PRO")
print("       Developer: Sopha Panha")
print("       Status: Loaded Successfully")
print("====================================")
