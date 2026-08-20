-- BRAINROT SNIPER ULTIMATE — Xeno
-- GUI loads first, game logic can't break it

local Config = {Area=12,AutoShoot=false,CollectCash=false,UpgradeAll=false,AutoRebirth=false,AutoFuse=false,AutoClaim=false}
local Running = true
local RE, RF, GF, BF, DF

-- ════════════════════════════════════
-- GUI (loads first, nothing blocks this)
-- ════════════════════════════════════
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local old = CoreGui:FindFirstChild("BSGUI"); if old then old:Destroy() end
local SG = Instance.new("ScreenGui"); SG.Name="BSGUI"; SG.Parent=CoreGui

-- Main frame
local MF = Instance.new("Frame",SG)
MF.Size=UDim2.new(0,280,0,330)
MF.Position=UDim2.new(0.02,0,0.2,0)
MF.BackgroundColor3=Color3.fromRGB(18,18,22)
MF.BorderSizePixel=0; MF.Active=true; MF.Draggable=true
local mfC = Instance.new("UICorner",MF); mfC.CornerRadius=UDim.new(0,10)
local mfS = Instance.new("UIStroke",MF); mfS.Color=Color3.fromRGB(100,50,150); mfS.Thickness=1.5; mfS.Transparency=0.3

-- Shadow
local shadow = Instance.new("ImageLabel",MF)
shadow.Size=UDim2.new(1,30,1,30); shadow.Position=UDim2.new(0,-15,0,-15)
shadow.BackgroundTransparency=1; shadow.ImageTransparency=0.6; shadow.ZIndex=0
shadow.Image="rbxassetid://5554236805"; shadow.ScaleType=Enum.ScaleType.Slice
shadow.SliceCenter=Rect.new(23,23,277,277)

-- Title bar
local TB = Instance.new("Frame",MF)
TB.Size=UDim2.new(1,0,0,40); TB.BackgroundColor3=Color3.fromRGB(14,14,17); TB.BorderSizePixel=0; TB.ZIndex=2
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,10)
local tbCover = Instance.new("Frame",TB)
tbCover.Size=UDim2.new(1,0,0,12); tbCover.Position=UDim2.new(0,0,1,-12)
tbCover.BackgroundColor3=Color3.fromRGB(14,14,17); tbCover.BorderSizePixel=0; tbCover.ZIndex=2

-- Title text
local TL = Instance.new("TextLabel",TB)
TL.Text="⚡ BRAINROT SNIPER"; TL.Font=Enum.Font.GothamBold; TL.TextSize=15; TL.ZIndex=3
TL.TextColor3=Color3.fromRGB(210,170,255); TL.Size=UDim2.new(0.7,0,1,0)
TL.Position=UDim2.new(0,14,0,0); TL.BackgroundTransparency=1; TL.TextXAlignment=Enum.TextXAlignment.Left

-- Version badge
local badge = Instance.new("TextLabel",TB)
badge.Text="ULTIMATE"; badge.Font=Enum.Font.GothamBold; badge.TextSize=8; badge.ZIndex=3
badge.TextColor3=Color3.fromRGB(18,18,22); badge.BackgroundColor3=Color3.fromRGB(140,80,200)
badge.Size=UDim2.new(0,52,0,14); badge.Position=UDim2.new(0,160,0,13)
Instance.new("UICorner",badge).CornerRadius=UDim.new(0,3)

-- Minimize
local MB = Instance.new("TextButton",TB)
MB.Text="—"; MB.Font=Enum.Font.GothamBold; MB.TextSize=14; MB.ZIndex=3
MB.TextColor3=Color3.fromRGB(160,160,170); MB.Size=UDim2.new(0,30,0,30)
MB.Position=UDim2.new(1,-38,0,5); MB.BackgroundTransparency=1
local isMin = false
MB.MouseButton1Click:Connect(function()
    isMin = not isMin
    MF.Size = isMin and UDim2.new(0,280,0,40) or UDim2.new(0,280,0,330)
    MB.Text = isMin and "+" or "—"
end)

-- Accent line
local acc = Instance.new("Frame",MF)
acc.Size=UDim2.new(1,-24,0,1); acc.Position=UDim2.new(0,12,0,42)
acc.BackgroundColor3=Color3.fromRGB(100,50,150); acc.BorderSizePixel=0

-- Content scroll
local CC = Instance.new("ScrollingFrame",MF)
CC.Size=UDim2.new(1,-16,1,-52); CC.Position=UDim2.new(0,8,0,48)
CC.BackgroundTransparency=1; CC.BorderSizePixel=0; CC.ScrollBarThickness=3
CC.ScrollBarImageColor3=Color3.fromRGB(100,50,150); CC.CanvasSize=UDim2.new(0,0,0,290)
CC.ClipsDescendants=true
local lay = Instance.new("UIListLayout",CC); lay.Padding=UDim.new(0,4); lay.SortOrder=Enum.SortOrder.LayoutOrder

-- ═══ UI Builders ═══

local function mkSep(ord, text)
    local f=Instance.new("Frame",CC); f.Size=UDim2.new(1,-6,0,16); f.BackgroundTransparency=1; f.LayoutOrder=ord
    local l=Instance.new("TextLabel",f); l.Text=text; l.Font=Enum.Font.GothamBold; l.TextSize=9
    l.TextColor3=Color3.fromRGB(130,70,190); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.TextXAlignment=Enum.TextXAlignment.Left
end

local function mkArea(ord)
    local f=Instance.new("Frame",CC); f.Size=UDim2.new(1,-6,0,28); f.BackgroundTransparency=1; f.LayoutOrder=ord
    local l=Instance.new("TextLabel",f); l.Text="Select Area (1-14)"; l.Font=Enum.Font.Gotham; l.TextSize=13
    l.TextColor3=Color3.fromRGB(210,210,220); l.Size=UDim2.new(0.65,0,1,0); l.BackgroundTransparency=1
    l.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextBox",f); b.Text="12"; b.Font=Enum.Font.GothamBold; b.TextSize=13
    b.TextColor3=Color3.new(1,1,1); b.Size=UDim2.new(0,44,0,22); b.Position=UDim2.new(1,-50,0,3)
    b.BackgroundColor3=Color3.fromRGB(30,30,38); b.BorderSizePixel=0; b.ClearTextOnFocus=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    local bs=Instance.new("UIStroke",b); bs.Color=Color3.fromRGB(80,40,130); bs.Thickness=1
    b.FocusLost:Connect(function()
        local n=tonumber(b.Text)
        if n and n>=1 and n<=14 then
            Config.Area=math.floor(n); b.Text=tostring(Config.Area)
            if RE then local r=RE:FindFirstChild("LoadPosition"); if r then pcall(function() r:FireServer(Config.Area) end) end end
        else b.Text=tostring(Config.Area) end
    end)
end

local function mkToggle(name, ord, key)
    local f=Instance.new("Frame",CC); f.Size=UDim2.new(1,-6,0,26); f.BackgroundColor3=Color3.fromRGB(24,24,30)
    f.BorderSizePixel=0; f.LayoutOrder=ord
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
    local l=Instance.new("TextLabel",f); l.Text=name; l.Font=Enum.Font.Gotham; l.TextSize=13
    l.TextColor3=Color3.fromRGB(210,210,220); l.Size=UDim2.new(0.8,0,1,0); l.Position=UDim2.new(0,10,0,0)
    l.BackgroundTransparency=1; l.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextButton",f); b.Text=""; b.Size=UDim2.new(0,20,0,20); b.Position=UDim2.new(1,-28,0,3)
    b.BackgroundColor3=Color3.fromRGB(30,30,38); b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
    local st=Instance.new("UIStroke",b); st.Color=Color3.fromRGB(60,60,75); st.Thickness=1
    local ck=Instance.new("TextLabel",b); ck.Text=""; ck.Font=Enum.Font.GothamBold; ck.TextSize=14
    ck.TextColor3=Color3.fromRGB(130,255,130); ck.Size=UDim2.new(1,0,1,0); ck.BackgroundTransparency=1
    b.MouseButton1Click:Connect(function()
        Config[key]=not Config[key]; ck.Text=Config[key] and "✓" or ""
        b.BackgroundColor3=Config[key] and Color3.fromRGB(20,60,20) or Color3.fromRGB(30,30,38)
        st.Color=Config[key] and Color3.fromRGB(50,170,50) or Color3.fromRGB(60,60,75)
        f.BackgroundColor3=Config[key] and Color3.fromRGB(20,28,20) or Color3.fromRGB(24,24,30)
    end)
end

-- Build UI
mkArea(0)
mkSep(1,"— COMBAT —")
mkToggle("Auto Shoot + Drone",2,"AutoShoot")
mkSep(3,"— ECONOMY —")
mkToggle("Collect Cash",4,"CollectCash")
mkToggle("Upgrade All",5,"UpgradeAll")
mkToggle("Auto Rebirth",6,"AutoRebirth")
mkSep(7,"— BRAINROTS —")
mkToggle("Auto Fuse (Best)",8,"AutoFuse")
mkSep(9,"— REWARDS —")
mkToggle("Auto Claim All",10,"AutoClaim")

-- Right Ctrl toggle
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode==Enum.KeyCode.RightControl then SG.Enabled=not SG.Enabled end
end)

-- ════════════════════════════════════
-- GAME LOGIC (all safe, can't crash GUI)
-- ════════════════════════════════════
task.spawn(function()
    -- find remotes
    for i=1,60 do
        pcall(function()
            local s=game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
            local p=s and s:FindFirstChild("Packages")
            local n=p and p:FindFirstChild("Net")
            if n then RE=n:FindFirstChild("RE"); RF=n:FindFirstChild("RF") end
        end)
        if RE then break end
        task.wait(0.5)
    end

    -- find game folders
    pcall(function()
        GF=workspace:FindFirstChild("GameFolder")
        local rt=GF and GF:FindFirstChild("RunTime")
        BF=rt and rt:FindFirstChild("Brainrot")
        DF=rt and rt:FindFirstChild("Drone")
    end)

    local function fire(n,...) if RE then local r=RE:FindFirstChild(n); if r then pcall(function() r:FireServer(...) end) end end end
    local function invoke(n,...) if RF then local r=RF:FindFirstChild(n); if r then pcall(function() r:InvokeServer(...) end) end end end

    -- FAST LOOP: shooting (0.2s)
    task.spawn(function()
        while Running do task.wait(0.2)
            if Config.AutoShoot and RE then
                fire("EquipBestBrainrot")
                pcall(function()
                    if BF then for _,b in pairs(BF:GetChildren()) do local p=b:FindFirstChildWhichIsA("BasePart"); if p then fire("BrainrotAttack",b); fire("BrainrotAttack",p.Position); fire("BrainrotAttack",b,p.Position) end end end
                    local bm=GF and GF:FindFirstChild("BrainrotModels"); if bm then for _,b in pairs(bm:GetChildren()) do local p=b:FindFirstChildWhichIsA("BasePart"); if p then fire("BrainrotAttack",b); fire("BrainrotAttack",p.Position) end end end
                    local cb=workspace:FindFirstChild("ClientBalloon"); if cb then for _,b in pairs(cb:GetChildren()) do fire("BalloonHit",b) end end
                end)
                fire("DroneCreate",Config.Area); fire("DroneCreate")
                pcall(function() if DF then for _,d in pairs(DF:GetChildren()) do fire("DroneHit",d) end end end)
                for i=1,10 do fire("PlaceBrainrot",i) end
            end
        end
    end)

    -- MEDIUM LOOP: economy (1s)
    task.spawn(function()
        while Running do task.wait(1)
            if Config.CollectCash then fire("ClaimGold"); fire("DroneClaim"); invoke("DroneCapture"); invoke("DroneRequest") end
            if Config.UpgradeAll then
                for i=1,20 do fire("ShotLevelUp"); fire("ShieldLevelUp"); fire("DroneLevelUp") end
                for i=1,30 do fire("UpgradeBrainrot",i) end
                invoke("ChargeShield"); for i=1,10 do fire("UnlockSlot",i) end; fire("EquipBestBrainrot")
            end
        end
    end)

    -- SLOW LOOP: rebirth, fuse, claims (3s)
    task.spawn(function()
        while Running do task.wait(3)
            if Config.AutoRebirth then fire("RebirthUp"); fire("RebirthUp",true) end
            if Config.AutoFuse then for i=1,10 do invoke("FuseBrainrot"); invoke("FuseBrainrot",i) end; fire("EquipBestBrainrot") end
            if Config.AutoClaim then invoke("ClaimDailyReward"); invoke("ClaimGroupReward"); invoke("ClaimOnlineReward"); invoke("ClaimFriendJoin"); invoke("ClaimFriendPotion"); invoke("SeasonClaimReward"); fire("SeasonClaimPlayTime"); invoke("ExclusivesPackClaim"); fire("OpenLuckyBox"); fire("UsePotion") end
        end
    end)
end)

SG.Destroying:Connect(function() Running=false end)
