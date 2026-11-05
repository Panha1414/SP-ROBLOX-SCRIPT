-- ដំណើរការ Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- បង្កើតផ្ទាំង UI គោល (Script Hub)
local Window = Rayfield:CreateWindow({
   Name = "SP ROBLOX SCRIPT HUB",
   LoadingTitle = "កំពុងបើក SP HUB...",
   LoadingSubtitle = "បង្កើតដោយ: សុផា បញ្ញា",
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

---------------------------------------------------------
-- Tab ទី១៖ Steal an Egg (អ្នកអាចប្តូរឈ្មោះបាន)
---------------------------------------------------------
local EggTab = Window:CreateTab("🥚 Steal an Egg", nil)
local EggSection = EggTab:CreateSection("មុខងារសម្រាប់ហ្គេម Steal an Egg")

-- បន្ថែមប៊ូតុងសម្រាប់ Codiumhub
EggTab:CreateButton({
   Name = "បើក Codiumhub (Android & IOS RAM 4GB+)",
   Callback = function()
       loadstring(game:HttpGet("https://getcodium.xyz/loader.luau"))()
       Rayfield:Notify({Title = "SP HUB", Content = "កំពុងដំណើរការ Codiumhub...", Duration = 3})
   end,
})

-- បន្ថែមប៊ូតុងសម្រាប់ CHILLI HUB SCRIPT
EggTab:CreateButton({
   Name = "បើក CHILLI HUB SCRIPT (Android)",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
       Rayfield:Notify({Title = "SP HUB", Content = "កំពុងដំណើរការ CHILLI HUB...", Duration = 3})
   end,
})

-- បន្ថែមប៊ូតុងសម្រាប់ Script FYY
EggTab:CreateButton({
   Name = "បើក Script FYY (IOS)",
   Callback = function()
       loadstring(game:HttpGet("https://FyyCommunity.net"))()
       Rayfield:Notify({Title = "SP HUB", Content = "កំពុងដំណើរការ Script FYY...", Duration = 3})
   end,
})

-- បន្ថែមប៊ូតុងសម្រាប់ Venyxhub
EggTab:CreateButton({
   Name = "បើក Venyxhub (smoother and faster)",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()
       Rayfield:Notify({Title = "SP HUB", Content = "កំពុងដំណើរការ Venyxhub...", Duration = 3})
   end,
})

---------------------------------------------------------
-- Tab ទី៣៖ ព័ត៌មានទំនាក់ទំនង
---------------------------------------------------------
local InfoTab = Window:CreateTab("ℹ️ ព័ត៌មាន", nil)
InfoTab:CreateSection("ទំនាក់ទំនង Admin")
InfoTab:CreateLabel("Developer: @sophapanha")
InfoTab:CreateLabel("Telegram Channel: @SPROBLOX")
InfoTab:CreateLabel("YouTube: @sp_roblox1")
InfoTab:CreateLabel("Website: sp-roblox.vercel.app")
