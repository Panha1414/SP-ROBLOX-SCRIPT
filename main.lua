-- ដំណើរការ Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- បង្កើតផ្ទាំង UI គោល
local Window = Rayfield:CreateWindow({
   Name = "SP ROBLOX SCRIPT",
   LoadingTitle = "កំពុងបើក SP ROBLOX SCRIPT...",
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
   KeySystem = false -- ដូរទៅ true បើសិនជាចង់តម្រូវឲ្យអ្នកលេងវាយ Key មុនចូល
})

-- បង្កើត Tab សម្រាប់ដាក់មុខងារ
local MainTab = Window:CreateTab("🏠 ទំព័រដើម", nil)
local MainSection = MainTab:CreateSection("មុខងារទូទៅ (General)")

-- បង្កើតប៊ូតុងសម្រាប់ដំណើរការកូដ Tenshi ដើមពីក្រោយ (បើចង់បានមុខងាររបស់វា)
MainTab:CreateButton({
   Name = "បើកមុខងារ Tenshi Finder",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/syss1211/Tenshi-script/abbe55c9c3d75025f1cc0459c1135c1bb65d9d17/Tenshi-Finder-Beta.lua"))()
       Rayfield:Notify({
           Title = "ជោគជ័យ",
           Content = "មុខងារត្រូវបានបើកដំណើរការ!",
           Duration = 3,
           Image = 4483362458,
       })
   end,
})

-- បង្កើត Toggle សម្រាប់បិទបើកមុខងារ Farm
MainTab:CreateToggle({
   Name = "Auto Farm (សាកល្បង)",
   CurrentValue = false,
   Flag = "AutoFarm", 
   Callback = function(Value)
       -- កន្លែងសរសេរកូដ Auto Farm បន្ថែម
       print("Auto Farm ដំណើរការ: ", Value)
   end,
})

-- បង្កើត Tab ព័ត៌មាន
local InfoTab = Window:CreateTab("ℹ️ ព័ត៌មាន", nil)
InfoTab:CreateLabel("Developer: @sophapanha")
InfoTab:CreateLabel("Telegram Channel: @SPROBLOX")
InfoTab:CreateLabel("YouTube: @sp_roblox1")
