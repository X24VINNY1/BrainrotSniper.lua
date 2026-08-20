--[[
    BRAINROT SNIPER v2 — Xeno Executor
    real remotes, real game structure
    oil up gng 6767
]]
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ══════ REMOTE PATHS ══════
local NetFolder = RS:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Net")
local RE = NetFolder:WaitForChild("RE")
local RF = NetFolder:WaitForChild("RF")

-- Remote Events
local RE_BrainrotAttack = RE:WaitForChild("BrainrotAttack")
local RE_ClaimGold = RE:WaitForChild("ClaimGold")
local RE_RebirthUp = RE:WaitForChild("RebirthUp")
local RE_ShotLevelUp = RE:WaitForChild("ShotLevelUp")
local RE_ShieldLevelUp = RE:WaitForChild("ShieldLevelUp")
local RE_DroneLevelUp = RE:WaitForChild("DroneLevelUp")
local RE_UpgradeBrainrot = RE:WaitForChild("UpgradeBrainrot")
local RE_LoadPosition = RE:WaitForChild("LoadPosition")
local RE_EquipBestBrainrot = RE:WaitForChild("EquipBestBrainrot")
local RE_PlaceBrainrot = RE:WaitForChild("PlaceBrainrot")
local RE_DroneCreate = RE:WaitForChild("DroneCreate")
local RE_DroneClaim = RE:WaitForChild("DroneClaim")
local RE_DroneHit = RE:WaitForChild("DroneHit")
local RE_ScopeState = RE:WaitForChild("ScopeState")
local RE_SellAllBrainrot = RE:WaitForChild("SellAllBrainrot")

-- Remote Functions
local RF_DroneCapture = RF:WaitForChild("DroneCapture")
local RF_DroneRequest = RF:WaitForChild("DroneRequest")

-- ══════ CONFIG ══════
local Config = {
    SelectedArea = 12,
    AutoShoot = false,
    CollectCash = false,
    UpgradeAll = false,
    AutoRebirth = false,
}
local Running = true

-- ══════ CORE FUNCTIONS ══════

-- Select Area: fire LoadPosition to teleport to area
local function teleportArea(areaNum)
    pcall(function()
        RE_LoadPosition:FireServer(areaNum)
    end)
end

-- Auto Shoot: scope in, find brainrots, attack them, equip best, send drone
local function doAutoShoot()
    -- equip best brainrot
    pcall(function()
        RE_EquipBestBrainrot:FireServer()
    end)

    -- scope in
    pcall(function()
        RE_ScopeState:FireServer(true)
    end)

    -- find enemies in workspace and attack
    local enemyFolders = {
        workspace:FindFirstChild("Enemies"),
        workspace:FindFirstChild("Mobs"),
        workspace:FindFirstChild("Brainrots"),
        workspace:FindFirstChild("NPCs"),
        workspace:FindFirstChild("Targets"),
    }

    for _, folder in pairs(enemyFolders) do
        if folder then
            for _, enemy in pairs(folder:GetChildren()) do
                local targetPart = enemy:FindFirstChild("HumanoidRootPart")
                    or enemy:FindFirstChild("Head")
                    or enemy:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    pcall(function()
                        RE_BrainrotAttack:FireServer(enemy)
                    end)
                    pcall(function()
                        RE_BrainrotAttack:FireServer(targetPart.Position)
                    end)
                    pcall(function()
                        RE_BrainrotAttack:FireServer(enemy, targetPart.Position)
                    end)
                end
            end
        end
    end

    -- also try balloon hits (some areas use balloons)
    pcall(function()
        local balloons = workspace:FindFirstChild("Balloons")
        if balloons then
            for _, balloon in pairs(balloons:GetChildren()) do
                local part = balloon:FindFirstChildWhichIsA("BasePart")
                if part then
                    local RE_BalloonHit = RE:FindFirstChild("BalloonHit")
                    if RE_BalloonHit then
                        RE_BalloonHit:FireServer(balloon)
                    end
                end
            end
        end
    end)

    -- send drone to area
    pcall(function()
        RE_DroneCreate:FireServer(Config.SelectedArea)
    end)
    pcall(function()
        RE_DroneCreate:FireServer()
    end)

    -- scope out
    pcall(function()
        RE_ScopeState:FireServer(false)
    end)
end

-- Collect Cash: claim gold + drone claims
local function doCollectCash()
    pcall(function()
        RE_ClaimGold:FireServer()
    end)
    pcall(function()
        RE_DroneClaim:FireServer()
    end)
    -- try drone capture/request
    pcall(function()
        RF_DroneCapture:InvokeServer()
    end)
    pcall(function()
        RF_DroneRequest:InvokeServer()
    end)
end

-- Upgrade All: sniper, shield, drone, brainrots
local function doUpgradeAll()
    -- upgrade sniper (shot level)
    for i = 1, 5 do
        pcall(function()
            RE_ShotLevelUp:FireServer()
        end)
        pcall(function()
            RE_ShotLevelUp:FireServer(i)
        end)
    end

    -- upgrade shield
    for i = 1, 5 do
        pcall(function()
            RE_ShieldLevelUp:FireServer()
        end)
        pcall(function()
            RE_ShieldLevelUp:FireServer(i)
        end)
    end

    -- upgrade drones
    for i = 1, 5 do
        pcall(function()
            RE_DroneLevelUp:FireServer()
        end)
        pcall(function()
            RE_DroneLevelUp:FireServer(i)
        end)
    end

    -- upgrade brainrots
    for i = 1, 10 do
        pcall(function()
            RE_UpgradeBrainrot:FireServer(i)
        end)
    end
    pcall(function()
        RE_UpgradeBrainrot:FireServer()
    end)

    -- equip best
    pcall(function()
        RE_EquipBestBrainrot:FireServer()
    end)
end

-- Auto Rebirth
local function doRebirth()
    pcall(function()
        RE_RebirthUp:FireServer()
    end)
    pcall(function()
        RE_RebirthUp:FireServer(true)
    end)
end

-- ══════ GUI ══════
local old = LP.PlayerGui:FindFirstChild("BSGUI"); if old then old:Destroy() end
local SG = Instance.new("ScreenGui"); SG.Name="BSGUI"; SG.ResetOnSpawn=false; SG.Parent=LP.PlayerGui

local MF = Instance.new("Frame"); MF.Size=UDim2.new(0,260,0,250); MF.Position=UDim2.new(0.02,0,0.3,0)
MF.BackgroundColor3=Color3.fromRGB(25,25,30); MF.BorderSizePixel=0; MF.Active=true; MF.Draggable=true; MF.Parent=SG
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,6)
local s=Instance.new("UIStroke",MF); s.Color=Color3.fromRGB(60,60,70)

-- Title bar
local TB=Instance.new("Frame",MF); TB.Size=UDim2.new(1,0,0,35); TB.BackgroundColor3=Color3.fromRGB(20,20,25); TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,6)
local tc=Instance.new("Frame",TB); tc.Size=UDim2.new(1,0,0,8); tc.Position=UDim2.new(0,0,1,-8); tc.BackgroundColor3=Color3.fromRGB(20,20,25); tc.BorderSizePixel=0

local TL=Instance.new("TextLabel",TB); TL.Text="BRAINROT SNIPER"; TL.Font=Enum.Font.GothamBold; TL.TextSize=16
TL.TextColor3=Color3.fromRGB(255,255,255); TL.Size=UDim2.new(1,-40,1,0); TL.Position=UDim2.new(0,12,0,0); TL.BackgroundTransparency=1; TL.TextXAlignment=Enum.TextXAlignment.Left

local MB=Instance.new("TextButton",TB); MB.Text="▼"; MB.Font=Enum.Font.GothamBold; MB.TextSize=12; MB.TextColor3=Color3.fromRGB(180,180,180)
MB.Size=UDim2.new(0,30,0,30); MB.Position=UDim2.new(1,-35,0,3); MB.BackgroundTransparency=1
local min=false; MB.MouseButton1Click:Connect(function() min=not min; MF.Size=min and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,250); MB.Text=min and "▶" or "▼" end)

-- Content
local C=Instance.new("Frame",MF); C.Size=UDim2.new(1,-20,1,-45); C.Position=UDim2.new(0,10,0,40); C.BackgroundTransparency=1
Instance.new("UIListLayout",C).Padding=UDim.new(0,6)

-- Area selector
local ar=Instance.new("Frame",C); ar.Size=UDim2.new(1,0,0,30); ar.BackgroundTransparency=1; ar.LayoutOrder=0
local al=Instance.new("TextLabel",ar); al.Text="Select Area"; al.Font=Enum.Font.Gotham; al.TextSize=14; al.TextColor3=Color3.fromRGB(220,220,220)
al.Size=UDim2.new(0.6,0,1,0); al.BackgroundTransparency=1; al.TextXAlignment=Enum.TextXAlignment.Left
local ab=Instance.new("TextBox",ar); ab.Text=tostring(Config.SelectedArea); ab.Font=Enum.Font.GothamBold; ab.TextSize=14; ab.TextColor3=Color3.fromRGB(255,255,255)
ab.Size=UDim2.new(0,50,0,26); ab.Position=UDim2.new(1,-55,0,2); ab.BackgroundColor3=Color3.fromRGB(40,40,50); ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,4)
ab.FocusLost:Connect(function()
    local n=tonumber(ab.Text)
    if n and n>=1 and n<=15 then
        Config.SelectedArea=math.floor(n)
        ab.Text=tostring(Config.SelectedArea)
        teleportArea(Config.SelectedArea)
    else
        ab.Text=tostring(Config.SelectedArea)
    end
end)

-- Toggle factory
local function mkToggle(name,ord,key)
    local r=Instance.new("Frame",C); r.Size=UDim2.new(1,0,0,30); r.BackgroundTransparency=1; r.LayoutOrder=ord
    local l=Instance.new("TextLabel",r); l.Text=name; l.Font=Enum.Font.Gotham; l.TextSize=14; l.TextColor3=Color3.fromRGB(220,220,220)
    l.Size=UDim2.new(0.7,0,1,0); l.BackgroundTransparency=1; l.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextButton",r); b.Text=""; b.Size=UDim2.new(0,24,0,24); b.Position=UDim2.new(1,-30,0,3)
    b.BackgroundColor3=Color3.fromRGB(40,40,50); b.BorderSizePixel=0; Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
    local st=Instance.new("UIStroke",b); st.Color=Color3.fromRGB(80,80,90)
    local cm=Instance.new("TextLabel",b); cm.Text=""; cm.Font=Enum.Font.GothamBold; cm.TextSize=16; cm.TextColor3=Color3.fromRGB(100,255,100)
    cm.Size=UDim2.new(1,0,1,0); cm.BackgroundTransparency=1
    b.MouseButton1Click:Connect(function()
        Config[key]=not Config[key]; cm.Text=Config[key] and "✓" or ""
        b.BackgroundColor3=Config[key] and Color3.fromRGB(30,80,30) or Color3.fromRGB(40,40,50)
        st.Color=Config[key] and Color3.fromRGB(60,180,60) or Color3.fromRGB(80,80,90)
    end)
end

mkToggle("Auto Shoot",1,"AutoShoot")
mkToggle("Collect Cash",2,"CollectCash")
mkToggle("Upgrade All",3,"UpgradeAll")
mkToggle("Auto Rebirth",4,"AutoRebirth")

-- ══════ LOOPS ══════

-- Fast loop: auto shoot (every 0.15s)
task.spawn(function()
    while Running and task.wait(0.15) do
        if Config.AutoShoot then
            pcall(doAutoShoot)
        end
    end
end)

-- Slow loop: cash, upgrades, rebirth (every 1.5s)
task.spawn(function()
    while Running and task.wait(1.5) do
        if Config.CollectCash then
            pcall(doCollectCash)
        end
        if Config.UpgradeAll then
            pcall(doUpgradeAll)
        end
        if Config.AutoRebirth then
            pcall(doRebirth)
        end
    end
end)

-- Cleanup
SG.Destroying:Connect(function() Running=false end)

-- Right Ctrl toggles GUI
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode==Enum.KeyCode.RightControl then
        SG.Enabled=not SG.Enabled
    end
end)

print("[BRAINROT SNIPER v2] loaded — real remotes, oil up gng")
print("[BRAINROT SNIPER v2] Right Ctrl to toggle GUI")
