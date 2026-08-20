--[[
    BRAINROT SNIPER ULTIMATE — Xeno Executor
    every feature. every remote. all of it.
    oil up gng 6767
]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ══════ CONFIG ══════
local Config = {
    SelectedArea = 12,
    AutoShoot = false,
    CollectCash = false,
    UpgradeAll = false,
    AutoRebirth = false,
    AutoFuse = false,
    AutoClaim = false,
}
local Running = true

-- ══════ REMOTES ══════
local RE, RF
pcall(function()
    local net = RS:WaitForChild("Shared", 10):WaitForChild("Packages", 10):WaitForChild("Net", 10)
    RE = net:WaitForChild("RE", 10)
    RF = net:WaitForChild("RF", 10)
end)

local function fireRE(name, ...)
    if not RE then return end
    local r = RE:FindFirstChild(name)
    if r then pcall(function() r:FireServer(...) end) end
end

local function invokeRF(name, ...)
    if not RF then return end
    local r = RF:FindFirstChild(name)
    if r then
        local ok, result = pcall(function() return r:InvokeServer(...) end)
        if ok then return result end
    end
    return nil
end

-- ══════ GAME FOLDERS ══════
local GameFolder = workspace:FindFirstChild("GameFolder")
local RunTime = GameFolder and GameFolder:FindFirstChild("RunTime")
local BrainrotFolder = RunTime and RunTime:FindFirstChild("Brainrot")
local DroneFolder = RunTime and RunTime:FindFirstChild("Drone")
local PlaceBrainrotFolder = RunTime and RunTime:FindFirstChild("PlaceBrainrot")

-- ══════ GUI ══════
local old = CoreGui:FindFirstChild("BSGUI"); if old then old:Destroy() end
local SG = Instance.new("ScreenGui"); SG.Name="BSGUI"; SG.Parent=CoreGui

local MF = Instance.new("Frame"); MF.Size=UDim2.new(0,280,0,345); MF.Position=UDim2.new(0.02,0,0.2,0)
MF.BackgroundColor3=Color3.fromRGB(20,20,25); MF.BorderSizePixel=0; MF.Active=true; MF.Draggable=true; MF.Parent=SG
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,8)
local stroke = Instance.new("UIStroke",MF); stroke.Color=Color3.fromRGB(80,40,120); stroke.Thickness=1.5

-- Title bar
local TB=Instance.new("Frame",MF); TB.Size=UDim2.new(1,0,0,38); TB.BackgroundColor3=Color3.fromRGB(15,15,18); TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,8)
local tc=Instance.new("Frame",TB); tc.Size=UDim2.new(1,0,0,10); tc.Position=UDim2.new(0,0,1,-10); tc.BackgroundColor3=Color3.fromRGB(15,15,18); tc.BorderSizePixel=0

-- accent line under title
local accent = Instance.new("Frame",MF); accent.Size=UDim2.new(1,-20,0,2); accent.Position=UDim2.new(0,10,0,38)
accent.BackgroundColor3=Color3.fromRGB(120,60,180); accent.BorderSizePixel=0

local TL=Instance.new("TextLabel",TB); TL.Text="⚡ BRAINROT SNIPER"; TL.Font=Enum.Font.GothamBold; TL.TextSize=15
TL.TextColor3=Color3.fromRGB(200,160,255); TL.Size=UDim2.new(1,-40,1,0); TL.Position=UDim2.new(0,12,0,0); TL.BackgroundTransparency=1; TL.TextXAlignment=Enum.TextXAlignment.Left

local verLabel=Instance.new("TextLabel",TB); verLabel.Text="ULTIMATE"; verLabel.Font=Enum.Font.GothamBold; verLabel.TextSize=9
verLabel.TextColor3=Color3.fromRGB(120,60,180); verLabel.Size=UDim2.new(0,60,0,14); verLabel.Position=UDim2.new(0,155,0,14); verLabel.BackgroundTransparency=1

local MB=Instance.new("TextButton",TB); MB.Text="▼"; MB.Font=Enum.Font.GothamBold; MB.TextSize=12; MB.TextColor3=Color3.fromRGB(180,180,180)
MB.Size=UDim2.new(0,30,0,30); MB.Position=UDim2.new(1,-35,0,4); MB.BackgroundTransparency=1
local isMin=false
MB.MouseButton1Click:Connect(function()
    isMin=not isMin
    MF.Size=isMin and UDim2.new(0,280,0,38) or UDim2.new(0,280,0,345)
    MB.Text=isMin and "▶" or "▼"
end)

-- Content
local C=Instance.new("Frame",MF); C.Size=UDim2.new(1,-20,1,-50); C.Position=UDim2.new(0,10,0,45); C.BackgroundTransparency=1; C.ClipsDescendants=true
local layout = Instance.new("UIListLayout",C); layout.Padding=UDim.new(0,5); layout.SortOrder=Enum.SortOrder.LayoutOrder

-- ══════ UI COMPONENTS ══════

-- Area selector row
local function makeAreaRow()
    local row=Instance.new("Frame",C); row.Size=UDim2.new(1,0,0,28); row.BackgroundTransparency=1; row.LayoutOrder=0
    local lbl=Instance.new("TextLabel",row); lbl.Text="Select Area (1-14)"; lbl.Font=Enum.Font.Gotham; lbl.TextSize=13; lbl.TextColor3=Color3.fromRGB(200,200,210)
    lbl.Size=UDim2.new(0.65,0,1,0); lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left

    local box=Instance.new("TextBox",row); box.Text=tostring(Config.SelectedArea); box.Font=Enum.Font.GothamBold; box.TextSize=14; box.TextColor3=Color3.fromRGB(255,255,255)
    box.Size=UDim2.new(0,50,0,24); box.Position=UDim2.new(1,-55,0,2); box.BackgroundColor3=Color3.fromRGB(35,35,45); box.BorderSizePixel=0
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke",box).Color=Color3.fromRGB(80,40,120)

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n and n >= 1 and n <= 14 then
            Config.SelectedArea = math.floor(n)
            box.Text = tostring(Config.SelectedArea)
            fireRE("LoadPosition", Config.SelectedArea)
        else
            box.Text = tostring(Config.SelectedArea)
        end
    end)
end

-- Toggle row
local function mkToggle(name, ord, key)
    local row=Instance.new("Frame",C); row.Size=UDim2.new(1,0,0,28); row.BackgroundTransparency=1; row.LayoutOrder=ord
    local lbl=Instance.new("TextLabel",row); lbl.Text=name; lbl.Font=Enum.Font.Gotham; lbl.TextSize=13; lbl.TextColor3=Color3.fromRGB(200,200,210)
    lbl.Size=UDim2.new(0.75,0,1,0); lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left

    local btn=Instance.new("TextButton",row); btn.Text=""; btn.Size=UDim2.new(0,22,0,22); btn.Position=UDim2.new(1,-28,0,3)
    btn.BackgroundColor3=Color3.fromRGB(35,35,45); btn.BorderSizePixel=0
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,4)
    local st=Instance.new("UIStroke",btn); st.Color=Color3.fromRGB(70,70,85); st.Thickness=1

    local check=Instance.new("TextLabel",btn); check.Text=""; check.Font=Enum.Font.GothamBold; check.TextSize=15
    check.TextColor3=Color3.fromRGB(120,255,120); check.Size=UDim2.new(1,0,1,0); check.BackgroundTransparency=1

    btn.MouseButton1Click:Connect(function()
        Config[key]=not Config[key]
        check.Text=Config[key] and "✓" or ""
        btn.BackgroundColor3=Config[key] and Color3.fromRGB(25,65,25) or Color3.fromRGB(35,35,45)
        st.Color=Config[key] and Color3.fromRGB(60,180,60) or Color3.fromRGB(70,70,85)
    end)
end

-- Separator
local function mkSep(ord, text)
    local row=Instance.new("Frame",C); row.Size=UDim2.new(1,0,0,18); row.BackgroundTransparency=1; row.LayoutOrder=ord
    local lbl=Instance.new("TextLabel",row); lbl.Text=text; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
    lbl.TextColor3=Color3.fromRGB(120,60,180); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.TextXAlignment=Enum.TextXAlignment.Left
end

-- Build the UI
makeAreaRow()
mkSep(1, "— COMBAT —")
mkToggle("Auto Shoot + Drone", 2, "AutoShoot")
mkSep(3, "— ECONOMY —")
mkToggle("Collect Cash", 4, "CollectCash")
mkToggle("Upgrade All", 5, "UpgradeAll")
mkToggle("Auto Rebirth", 6, "AutoRebirth")
mkSep(7, "— BRAINROTS —")
mkToggle("Auto Fuse (Best)", 8, "AutoFuse")
mkSep(9, "— REWARDS —")
mkToggle("Auto Claim All", 10, "AutoClaim")

-- ══════ CORE FUNCTIONS ══════

local function doAutoShoot()
    -- equip best
    fireRE("EquipBestBrainrot")

    -- attack all brainrots in RunTime
    if BrainrotFolder then
        for _, brainrot in pairs(BrainrotFolder:GetChildren()) do
            local part = brainrot:FindFirstChild("HumanoidRootPart")
                or brainrot:FindFirstChild("Head")
                or brainrot:FindFirstChildWhichIsA("BasePart")
            if part then
                fireRE("BrainrotAttack", brainrot)
                fireRE("BrainrotAttack", part.Position)
                fireRE("BrainrotAttack", brainrot, part.Position)
            end
        end
    end

    -- attack brainrot models
    local bm = GameFolder and GameFolder:FindFirstChild("BrainrotModels")
    if bm then
        for _, brainrot in pairs(bm:GetChildren()) do
            local part = brainrot:FindFirstChildWhichIsA("BasePart")
            if part then
                fireRE("BrainrotAttack", brainrot)
                fireRE("BrainrotAttack", part.Position)
            end
        end
    end

    -- hit balloons
    local cb = workspace:FindFirstChild("ClientBalloon")
    if cb then
        for _, balloon in pairs(cb:GetChildren()) do
            fireRE("BalloonHit", balloon)
        end
    end

    -- create + manage drones
    fireRE("DroneCreate", Config.SelectedArea)
    fireRE("DroneCreate")

    -- drone hits on enemies
    if DroneFolder then
        for _, drone in pairs(DroneFolder:GetChildren()) do
            fireRE("DroneHit", drone)
        end
    end

    -- place brainrots on all slots
    for i = 1, 10 do
        fireRE("PlaceBrainrot", i)
    end
end

local function doCollectCash()
    -- claim gold
    fireRE("ClaimGold")

    -- drone claims
    fireRE("DroneClaim")
    invokeRF("DroneCapture")
    invokeRF("DroneRequest")

    -- sell weaker brainrots for cash
    -- fireRE("SellAllBrainrot") -- uncomment if you want auto sell
end

local function doUpgradeAll()
    -- sniper (shot level)
    for i = 1, 20 do
        fireRE("ShotLevelUp")
        fireRE("ShotLevelUp", i)
    end

    -- shield
    for i = 1, 20 do
        fireRE("ShieldLevelUp")
        fireRE("ShieldLevelUp", i)
    end
    invokeRF("ChargeShield")

    -- drone
    for i = 1, 20 do
        fireRE("DroneLevelUp")
        fireRE("DroneLevelUp", i)
    end

    -- upgrade brainrots
    for i = 1, 30 do
        fireRE("UpgradeBrainrot", i)
    end
    fireRE("UpgradeBrainrot")

    -- unlock slots
    for i = 1, 10 do
        fireRE("UnlockSlot", i)
    end
    fireRE("UnlockSlot")

    -- equip best
    fireRE("EquipBestBrainrot")
end

local function doRebirth()
    fireRE("RebirthUp")
    fireRE("RebirthUp", true)
    fireRE("RebirthUp", 1)
end

local function doAutoFuse()
    -- fuse brainrots repeatedly to get best ones
    for i = 1, 10 do
        invokeRF("FuseBrainrot")
        invokeRF("FuseBrainrot", i)
        invokeRF("FuseBrainrot", true)
    end
    -- always equip best after fusing
    fireRE("EquipBestBrainrot")
end

local function doAutoClaim()
    -- daily reward
    invokeRF("ClaimDailyReward")

    -- group reward
    invokeRF("ClaimGroupReward")

    -- online reward
    invokeRF("ClaimOnlineReward")

    -- friend join reward
    invokeRF("ClaimFriendJoin")
    invokeRF("ClaimFriendPotion")

    -- season rewards
    invokeRF("SeasonClaimReward")
    invokeRF("SeasonRefreshTask")
    fireRE("SeasonClaimPlayTime")

    -- exclusives pack
    invokeRF("ExclusivesPackClaim")

    -- lucky boxes
    fireRE("OpenLuckyBox")
    fireRE("BuyBox")

    -- potions
    fireRE("UsePotion")
end

-- ══════ LOOPS ══════

-- Fast: shooting (every 0.2s)
task.spawn(function()
    while Running do
        if Config.AutoShoot then pcall(doAutoShoot) end
        task.wait(0.2)
    end
end)

-- Medium: cash + upgrades (every 1s)
task.spawn(function()
    while Running do
        if Config.CollectCash then pcall(doCollectCash) end
        if Config.UpgradeAll then pcall(doUpgradeAll) end
        task.wait(1)
    end
end)

-- Slow: rebirth + fuse + claims (every 3s)
task.spawn(function()
    while Running do
        if Config.AutoRebirth then pcall(doRebirth) end
        if Config.AutoFuse then pcall(doAutoFuse) end
        if Config.AutoClaim then pcall(doAutoClaim) end
        task.wait(3)
    end
end)

-- Cleanup
SG.Destroying:Connect(function() Running=false end)

-- Right Ctrl toggle
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode==Enum.KeyCode.RightControl then SG.Enabled=not SG.Enabled end
end)
