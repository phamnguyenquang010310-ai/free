--[[
    ==================================================
    * LONGKAKA HUB - FULL OPERATIONAL EDITION [MERGED - v2]
    * Realkid UI Style & Interactive Checkboxes
    * Improved: AutoQuest (uses comprehensive quest list + keyword NPC search)
    ==================================================
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("LongkakaHub") then PlayerGui.LongkakaHub:Destroy() end

local Config = {
    AutoFarm = false, FastAtk = false, ESP = false, NoClip = false,
    WalkWater = false, Aimbot = false, TeleportPlayer = false, AutoFruit = false,
    AutoYama = false, AutoTushita = false, HopDealer = false,
    AutoSeaEvent = false, AutoLeviathan = false,
    AutoQuest = false -- new: auto accept/start quest
}
_G.Config = Config

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "LongkakaHub"
ScreenGui.ResetOnSpawn = false

-- Nút thu phóng mở Hub (Phong cách Realkid)
local FloatingBtn = Instance.new("TextButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
FloatingBtn.Text = "LK"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 16
FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FloatingBtn.Draggable = true
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FloatingBtn).Color = Color3.fromRGB(255, 50, 50)

-- Khung chính UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 420)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 65)

-- Thanh tiêu đề chuẩn Hub
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "LONGKAKA HUB <font color='#ff3c3c'>| Fully Operational</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Danh sách Tab bên trái
local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.Size = UDim2.new(0, 140, 1, -55)
TabContainer.Position = UDim2.new(0, 10, 0, 48)
TabContainer.BackgroundTransparency = 1
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

-- Khu vực nội dung bên phải
local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.Size = UDim2.new(1, -165, 1, -55)
PagesContainer.Position = UDim2.new(0, 155, 0, 48)
PagesContainer.BackgroundTransparency = 1

local function CreateTab(name)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        page.Visible = true
    end)
    return page
end

local FarmTab = CreateTab("Farm & Misc")
local CombatTab = CreateTab("PvP & ESP")
local QuestTab = CreateTab("Advanced Quest")
local EventTab = CreateTab("Sea & Events")
FarmTab.Visible = true

local function AddCheckbox(parent, name, configKey)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -5, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local box = Instance.new("Frame", row)
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(0, 12, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = Color3.fromRGB(80, 80, 100)
    boxStroke.Thickness = 1.5

    local checkMark = Instance.new("Frame", box)
    checkMark.Size = UDim2.new(0, 12, 0, 12)
    checkMark.Position = UDim2.new(0.5, -6, 0.5, -6)
    checkMark.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    checkMark.Visible = Config[configKey]
    Instance.new("UICorner", checkMark).CornerRadius = UDim.new(0, 3)

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        local active = Config[configKey]
        checkMark.Visible = active
        boxStroke.Color = active and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(80, 80, 100)
    end)
end

-- Thêm các tính năng vào Tab
AddCheckbox(FarmTab, "Auto Farm Level", "AutoFarm")
AddCheckbox(FarmTab, "Fast Attack", "FastAtk")
AddCheckbox(FarmTab, "No Clip", "NoClip")
AddCheckbox(FarmTab, "Walk On Water", "WalkWater")
AddCheckbox(FarmTab, "Auto Accept Quest", "AutoQuest") -- <-- mới thêm

AddCheckbox(CombatTab, "PvP Aimbot", "Aimbot")
AddCheckbox(CombatTab, "Teleport Player", "TeleportPlayer")
AddCheckbox(CombatTab, "ESP Player & HP/Lvl", "ESP")
AddCheckbox(CombatTab, "Auto Fruit Pickup", "AutoFruit")

AddCheckbox(QuestTab, "Auto Elite / Yama", "AutoYama")
AddCheckbox(QuestTab, "Auto Tushita / CDK", "AutoTushita")
AddCheckbox(QuestTab, "Server Hop Dealer", "HopDealer")

AddCheckbox(EventTab, "Auto Sea Event", "AutoSeaEvent")
AddCheckbox(EventTab, "Auto Leviathan", "AutoLeviathan")

--[[
    ==================================================
    * LONGKAKA HUB - FULL OPERATIONAL EDITION [PART 2]
    * Complete Executable Logic Engine
    ==================================================
]]--

local Camera = Workspace.CurrentCamera
local WaterPlat = Instance.new("Part", Workspace)
WaterPlat.Name = "WaterPlat"
WaterPlat.Size = Vector3.new(50, 1, 50)
WaterPlat.Anchored = true
WaterPlat.Transparency = 1

RunService.RenderStepped:Connect(function()
    pcall(function()
        -- ESP Player + Level + HP
        if _G.Config.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
                    local head = p.Character.Head
                    if not head:FindFirstChild("ESP_TAG") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "ESP_TAG"
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.AlwaysOnTop = true
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = Color3.fromRGB(0, 255, 255)
                        tl.TextSize = 11
                        tl.Font = Enum.Font.GothamBold
                    end
                    local lvlVal = "?"
                    pcall(function() lvlVal = tostring(p.Data.Level.Value) end)
                    head.ESP_TAG.TextLabel.Text = string.format("[%s]\nLvl: %s | HP: %d", p.Name, lvlVal, math.floor(p.Character.Humanoid.Health))
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESP_TAG") then
                    p.Character.Head.ESP_TAG:Destroy()
                end
            end
        end

        -- PvP Aimbot
        if _G.Config.Aimbot then
            local target = nil
            local dist = 9999
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (p.Character.Head.Position - Camera.CFrame.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = p.Character.Head
                    end
                end
            end
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end

        -- Walk On Water
        if _G.Config.WalkWater and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WaterPlat.Position = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Position.X, 1, LocalPlayer.Character.HumanoidRootPart.Position.Z)
            WaterPlat.CanCollide = true
        else
            WaterPlat.CanCollide = false
        end

        -- NoClip
        if _G.Config.NoClip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

-- Helper functions for AutoQuest
local function getModelCFrame(model)
    if not model then return nil end
    if model.PrimaryPart then return model.PrimaryPart.CFrame end
    for _, c in pairs(model:GetChildren()) do
        if c:IsA("BasePart") then return c.CFrame end
    end
    return nil
end

-- Comprehensive quest name list (common start-quest remote names)
local candidateQuests = {
    -- Sea 1
    "BanditQuest", "MonkeyQuest", "PirateQuest", "DesertQuest", "SnowBanditQuest",
    "MarineQuest", "PrisonerQuest", "ColosseumQuest", "MilitaryQuest", "FishmanQuest",
    "SkyQuest",
    -- Sea 2
    "CitizenQuest", "MarineLieutenantQuest", "ZombieQuest", "SnowMountainQuest", "HotAndColdQuest",
    "CursedShipQuest", "IceCastleQuest",
    -- Sea 3
    "PortTownQuest", "HydraQuest", "GreatTreeQuest", "FloatingTurtleQuest", "HauntedCastleQuest", "SeaOfTreatsQuest",
    -- Other known
    "TushitaQuest", "EliteHunter"
}

-- Keywords to match NPC names in workspace (from your Sea 1/2/3 mapping)
local questKeywords = {
    "bandit","monkey","pirate","desert","snow","marine","prison","colosseum","magma","military",
    "fishman","fountain","citizen","rose","flower","zombie","snowmountain","hot","cold","cursed","ice",
    "port","hydra","great","tree","floating","turtle","haunted","treats","tushita","yama","elite"
}

local function playerHasQuest()
    local ok, res = pcall(function()
        if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
            return ReplicatedStorage.Remotes.CommF_:InvokeServer("GetQuest")
        end
        return nil
    end)
    if not ok then return nil end
    return res
end

local function tryStartQuestByName(qname)
    local ok = false
    pcall(function()
        if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qname)
            ok = true
        end
    end)
    return ok
end

local function tryStartKnownQuests()
    for _, q in ipairs(candidateQuests) do
        local ok = tryStartQuestByName(q)
        if ok then return true end
    end
    return false
end

local function stringContainsAny(str, keywords)
    if not str then return false end
    local s = string.lower(str)
    for _, kw in ipairs(keywords) do
        if string.find(s, kw, 1, true) then
            return true
        end
    end
    return false
end

local function tryClickQuestNPC()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            local parent = obj.Parent
            local lname = (parent and parent.Name) and string.lower(parent.Name) or ""
            -- exact or keyword match
            if stringContainsAny(lname, questKeywords) or stringContainsAny(parent.Name, questKeywords) then
                local cf = getModelCFrame(parent)
                if cf and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = cf * CFrame.new(0, 3, 0)
                        fireclickdetector(obj)
                    end)
                    return true
                end
            end
        end
        if obj:IsA("ProximityPrompt") then
            local parent = obj.Parent
            local lname = (parent and parent.Name) and string.lower(parent.Name) or ""
            if stringContainsAny(lname, questKeywords) then
                local model = parent
                local cf = getModelCFrame(model)
                if cf and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = cf * CFrame.new(0, 3, 0)
                        if obj.HoldDuration and obj.HoldDuration == 0 then
                            if pcall(function() obj:InputHoldBegin() end) then
                                pcall(function() obj:InputHoldEnd() end)
                            end
                        else
                            -- Try to trigger via :PromptButtonHoldBegan if available (safe pcall)
                            pcall(function()
                                if obj.Trigger then
                                    obj:Trigger() -- some prompts support Trigger
                                end
                            end)
                        end
                    end)
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            -- Fast Attack
            if _G.Config.FastAtk then
                local cf = LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework")
                if cf then
                    local ctrl = debug.getupvalues(require(cf))[2].activeController
                    if ctrl then
                        ctrl.timeToNextAttack = 0
                        ctrl:attack()
                    end
                end
            end

            -- Auto Farm Level (Bay trên đầu quái)
            if _G.Config.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, e in pairs(enemies:GetChildren()) do
                        if e:FindFirstChild("HumanoidRootPart") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            break
                        end
                    end
                end
            end

            -- Auto Fruit Pickup (Spawn hoặc vứt ra)
            if _G.Config.AutoFruit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(Workspace:GetChildren()) do
                    if (v.Name:find("Fruit") or v.Name:find("DevilFruit")) and v:FindFirstChild("Handle") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                    end
                end
            end

            -- Teleport Player
            if _G.Config.TeleportPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPlr = nil
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        targetPlr = p
                        break
                    end
                end
                if targetPlr then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end

            -- Auto Sea Event
            if _G.Config.AutoSeaEvent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local seaMonsters = Workspace:FindFirstChild("SeaMonsters")
                if seaMonsters then
                    for _, m in pairs(seaMonsters:GetChildren()) do
                        if m:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            break
                        end
                    end
                end
            end

            -- Auto Leviathan
            if _G.Config.AutoLeviathan and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:find("Leviathan") and obj:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                        break
                    end
                end
            end

            -- Advanced Quests (Elite / Yama / Tushita)
            if _G.Config.AutoYama then
                pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter", "GetQuest") end)
            end
            if _G.Config.AutoTushita then
                pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "TushitaQuest") end)
            end

            -- AutoQuest: try accept/start quest if not active
            if _G.Config.AutoQuest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Kiểm tra xem đã có quest đang active chưa
                local hasQ = nil
                pcall(function() hasQ = playerHasQuest() end)
                local active = false
                if hasQ then
                    if type(hasQ) == "table" then
                        active = next(hasQ) ~= nil
                    else
                        active = true
                    end
                end

                if not active then
                    local started = false
                    -- thử gọi StartQuest bằng tên phổ biến
                    started = tryStartKnownQuests()
                    -- nếu không start được bằng remote, thử click NPC trong workspace
                    if not started then
                        started = tryClickQuestNPC()
                    end
                    -- optional debug
                    -- print("AutoQuest: started=", started)
                end
            end

            -- Server Hop Legendary Sword Dealer
            if _G.Config.HopDealer then
                local dealer = Workspace:FindFirstChild("LegendarySwordDealer")
                if not dealer then
                    local success, servers = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=Asc&limit=100"))
                    end)
                    if success and servers and servers.data then
                        for _, s in pairs(servers.data) do
                            if s.playing < 12 and s.id ~= game.JobId then
                                TeleportService:TeleportToPlaceInstance(2753915549, s.id, LocalPlayer)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

print("Longkaka Hub Fully Operational & Loaded!")
