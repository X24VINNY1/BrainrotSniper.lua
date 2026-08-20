--[[
    BRAINROT SNIPER v4 — Xeno Executor
    CoreGui fix — real remotes
    oil up gng 6767
]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Config = {
    SelectedArea = 12,
    AutoShoot = false,
    CollectCash = false,
    UpgradeAll = false,
    AutoRebirth = false,
}
local Running = true

-- ══════ GUI (CoreGui so it shows in Xeno) ══════
local old = CoreGui:FindFirstChild("BSGUI"); if old then old:Destroy() end
local SG = Instance.new("ScreenGui"); SG.Name="BSGUI"; SG.Parent=CoreGui

local MF = Instance.new("Frame"); MF.Size=UDim2.new(0,260,0,250); MF.Position=UDim2.new(0.02,0,0.3,0)
MF.BackgroundColor3=Color3.fromRGB(25,25,30); MF.BorderSizePixel=0; MF.Active=true; MF.Draggable=true; MF.Parent=SG
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,6)
local s=Instance.new("UIStroke",MF); s.Color=Color3.fromRGB(60,60,70)

local TB=Instance.new("Frame",MF); TB.Size=UDim2.new(1,0,0,35); TB.BackgroundColor3=Color3.fromRGB(20,20,25); TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,6)
local tc=Instance.new("Frame",TB); tc.Size=UDim2.new(1,0,0,8); tc.Position=UDim2.new(0,0,1,-8); tc.BackgroundColor3=Color3.fromRGB(20,20,25); tc.BorderSizePixel=0

local TL=Instance.new("TextLabel",TB); TL.Text="BRAINROT SNIPER"; TL.Font=Enum.Font.GothamBold; TL.TextSize=16
TL.TextColor3=Color3.fromRGB(255,255,255); TL.Size=UDim2.new(1,-40,1,0); TL.Position=UDim2.new(0,12,0,0); TL.BackgroundTransparency=1; TL.TextXAlignment=Enum.TextXAlignment.Left

local MB=Instance.new("TextButton",TB); MB.Text="▼"; MB.Font=Enum.Font.GothamBold; MB.TextSize=12; MB.TextColor3=Color3.fromRGB(180,180,180)
MB.Size=UDim2.new(0,30,0,30); MB.Position=UDim2.new(1,-35,0,3); MB.BackgroundTransparency=1
local isMin=false; MB.MouseButton1Click:Connect(function() isMin=not isMin; MF.Size=isMin and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,250); MB.Text=isMin and "▶" or "▼" end)

local C=Instance.new("Frame",MF); C.Size=UDim2.new(1,-20,1,-45); C.Position=UDim2.new(0,10,0,40); C.BackgroundTransparency=1
Instance.new("UIListLayout",C).Padding=UDim.new(0,6)

-- Area selector
local ar=Instance.new("Frame",C); ar.Size=UDim2.new(1,0,0,30); ar.BackgroundTransparency=1; ar.LayoutOrder=0
local al=Instance.new("TextLabel",ar); al.Text="Select Area"; al.Font=Enum.Font.Gotham; al.TextSize=14; al.TextColor3=Color3.fromRGB(220,220,220)
al.Size=UDim2.new(0.6,0,1,0); al.BackgroundTransparency=1; al.TextXAlignment=Enum.TextXAlignment.Left
local ab=Instance.new("TextBox",ar); ab.Text=tostring(Config.SelectedArea); ab.Font=Enum.Font.GothamBold; ab.TextSize=14; ab.TextColor3=Color3.fromRGB(255,255,255)
ab.Size=UDim2.new(0,50,0,26); ab.Position=UDim2.new(1,-55,0,2); ab.BackgroundColor3=Color3.fromRGB(40,40,50); ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,4)

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

-- ══════ GRAB REMOTES ══════
local RE, RF

local function getRemote(folder, name)
    if not folder then return nil end
    return folder:FindFirstChild(name)
end

task.spawn(function()
    local net = nil
    for i = 1, 30 do
        local shared = RS:FindFirstChild("Shared")
        if shared then
            local pkgs = shared:FindFirstChild("Packages")
            if pkgs then
                net = pkgs:FindFirstChild("Net")
                if net then break end
            end
        end
        task.wait(0.5)
    end

    if net then
        RE = net:FindFirstChild("RE")
        RF = net:FindFirstChild("RF")
    end
end)

-- ══════ AREA SELECT ══════
ab.FocusLost:Connect(function()
    local n=tonumber(ab.Text)
    if n and n>=1 and n<=15 then
        Config.SelectedArea=math.floor(n)
        ab.Text=tostring(Config.SelectedArea)
        local r = getRemote(RE, "LoadPosition")
        if r then pcall(function() r:FireServer(Config.SelectedArea) end) end
    else
        ab.Text=tostring(Config.SelectedArea)
    end
end)

-- ══════ CORE FUNCTIONS ══════
local function doAutoShoot()
    if not RE then return end

    local r = getRemote(RE, "EquipBestBrainrot")
    if r then pcall(function() r:FireServer() end) end

    r = getRemote(RE, "ScopeState")
    if r then pcall(function() r:FireServer(true) end) end

    r = getRemote(RE, "BrainrotAttack")
    if r then
        for _, name in pairs({"Enemies","Mobs","Brainrots","NPCs","Targets"}) do
            local folder = workspace:FindFirstChild(name)
            if folder then
                for _, enemy in pairs(folder:GetChildren()) do
                    local part = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Head") or enemy:FindFirstChildWhichIsA("BasePart")
                    if part then
                        pcall(function() r:FireServer(enemy) end)
                        pcall(function() r:FireServer(part.Position) end)
                        pcall(function() r:FireServer(enemy, part.Position) end)
                    end
                end
            end
        end
    end

    local bh = getRemote(RE, "BalloonHit")
    if bh then
        local balloons = workspace:FindFirstChild("Balloons")
        if balloons then
            for _, b in pairs(balloons:GetChildren()) do
                pcall(function() bh:FireServer(b) end)
            end
        end
    end

    r = getRemote(RE, "DroneCreate")
    if r then
        pcall(function() r:FireServer(Config.SelectedArea) end)
        pcall(function() r:FireServer() end)
    end

    r = getRemote(RE, "ScopeState")
    if r then pcall(function() r:FireServer(false) end) end
end

local function doCollectCash()
    if not RE then return end
    local r = getRemote(RE, "ClaimGold")
    if r then pcall(function() r:FireServer() end) end
    r = getRemote(RE, "DroneClaim")
    if r then pcall(function() r:FireServer() end) end
    if RF then
        local f = getRemote(RF, "DroneCapture")
        if f then pcall(function() f:InvokeServer() end) end
        f = getRemote(RF, "DroneRequest")
        if f then pcall(function() f:InvokeServer() end) end
    end
end

local function doUpgradeAll()
    if not RE then return end
    local shot = getRemote(RE, "ShotLevelUp")
    local shield = getRemote(RE, "ShieldLevelUp")
    local drone = getRemote(RE, "DroneLevelUp")
    local brainrot = getRemote(RE, "UpgradeBrainrot")
    local equip = getRemote(RE, "EquipBestBrainrot")

    for i = 1, 5 do
        if shot then pcall(function() shot:FireServer() end); pcall(function() shot:FireServer(i) end) end
        if shield then pcall(function() shield:FireServer() end); pcall(function() shield:FireServer(i) end) end
        if drone then pcall(function() drone:FireServer() end); pcall(function() drone:FireServer(i) end) end
    end
    for i = 1, 10 do
        if brainrot then pcall(function() brainrot:FireServer(i) end) end
    end
    if brainrot then pcall(function() brainrot:FireServer() end) end
    if equip then pcall(function() equip:FireServer() end) end
end

local function doRebirth()
    if not RE then return end
    local r = getRemote(RE, "RebirthUp")
    if r then
        pcall(function() r:FireServer() end)
        pcall(function() r:FireServer(true) end)
    end
end

-- ══════ LOOPS ══════
task.spawn(function()
    while Running and task.wait(0.2) do
        if Config.AutoShoot then pcall(doAutoShoot) end
    end
end)

task.spawn(function()
    while Running and task.wait(1.5) do
        if Config.CollectCash then pcall(doCollectCash) end
        if Config.UpgradeAll then pcall(doUpgradeAll) end
        if Config.AutoRebirth then pcall(doRebirth) end
    end
end)

SG.Destroying:Connect(function() Running=false end)
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode==Enum.KeyCode.RightControl then SG.Enabled=not SG.Enabled end
end)
