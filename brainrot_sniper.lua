--[[
    BRAINROT SNIPER — Xeno Executor
    oil up gng
]]
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

local Config = {Area=12, AutoShoot=false, CollectCash=false, UpgradeAll=false, AutoRebirth=false}
local Running = true

local function findRemote(name, cls)
    cls = cls or "RemoteEvent"
    for _,v in pairs(RS:GetDescendants()) do
        if v:IsA(cls) and v.Name:lower():find(name:lower()) then return v end
    end
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA(cls) and v.Name:lower():find(name:lower()) then return v end
    end
end

local function teleportArea(n)
    local r = findRemote("area") or findRemote("teleport") or findRemote("travel")
    if r then r:FireServer(n) return end
    local a = workspace:FindFirstChild("Areas") or workspace:FindFirstChild("Zones") or workspace:FindFirstChild("Map")
    if a then
        for _,c in pairs(a:GetChildren()) do
            if c.Name:find(tostring(n)) then
                local t = c:FindFirstChild("Spawn") or c:FindFirstChildWhichIsA("BasePart")
                if t and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart.CFrame = t.CFrame + Vector3.new(0,5,0)
                end
                break
            end
        end
    end
end

local function doShoot()
    local r = findRemote("shoot") or findRemote("fire") or findRemote("attack") or findRemote("hit")
    local ef = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Targets") or workspace:FindFirstChild("Brainrots")
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if r and ef then
        local best,bd = nil,math.huge
        for _,e in pairs(ef:GetChildren()) do
            local p = e:FindFirstChildWhichIsA("BasePart") or e:FindFirstChild("HumanoidRootPart")
            if p then local d=(hrp.Position-p.Position).Magnitude; if d<bd then bd=d;best=e end end
        end
        if best then
            pcall(function() r:FireServer(best) end)
            local tp = best:FindFirstChildWhichIsA("BasePart")
            if tp then pcall(function() r:FireServer(tp.Position) end); pcall(function() r:FireServer(best,tp.Position) end) end
        end
    else
        pcall(function()
            local vs = workspace.CurrentCamera.ViewportSize
            VIM:SendMouseButtonEvent(vs.X/2,vs.Y/2,0,true,game,1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(vs.X/2,vs.Y/2,0,false,game,1)
        end)
    end
end

local function doCash()
    local r = findRemote("collect") or findRemote("pickup") or findRemote("claim") or findRemote("cash")
    if r then pcall(function() r:FireServer() end) end
    local df = workspace:FindFirstChild("Drops") or workspace:FindFirstChild("Cash") or workspace:FindFirstChild("Coins") or workspace:FindFirstChild("Loot")
    if df then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local orig = hrp.CFrame
        for _,d in pairs(df:GetChildren()) do
            local p = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
            if p then pcall(function() hrp.CFrame=p.CFrame; task.wait(); firetouchinterest(hrp,p,0); task.wait(); firetouchinterest(hrp,p,1) end) end
        end
        pcall(function() hrp.CFrame=orig end)
    end
end

local function doUpgrade()
    local r = findRemote("upgrade") or findRemote("buy") or findRemote("level")
    if r then
        for _,s in pairs({"Damage","Range","FireRate","Speed","Power","damage","range","firerate","speed","power",1,2,3,4,5,6,7,8,9,10}) do
            pcall(function() r:FireServer(s) end)
            pcall(function() r:FireServer(s,1) end)
        end
    end
end

local function doRebirth()
    local r = findRemote("rebirth") or findRemote("prestige") or findRemote("reset")
    if r then pcall(function() r:FireServer() end); pcall(function() r:FireServer("Rebirth") end); pcall(function() r:FireServer(true) end) end
end

-- ══════ GUI ══════
local old = LP.PlayerGui:FindFirstChild("BSGUI"); if old then old:Destroy() end
local SG = Instance.new("ScreenGui"); SG.Name="BSGUI"; SG.ResetOnSpawn=false; SG.Parent=LP.PlayerGui

local MF = Instance.new("Frame"); MF.Size=UDim2.new(0,260,0,240); MF.Position=UDim2.new(0.02,0,0.3,0)
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
local min=false; MB.MouseButton1Click:Connect(function() min=not min; MF.Size=min and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,240); MB.Text=min and "▶" or "▼" end)

local C=Instance.new("Frame",MF); C.Size=UDim2.new(1,-20,1,-45); C.Position=UDim2.new(0,10,0,40); C.BackgroundTransparency=1
Instance.new("UIListLayout",C).Padding=UDim.new(0,6)

-- Area row
local ar=Instance.new("Frame",C); ar.Size=UDim2.new(1,0,0,30); ar.BackgroundTransparency=1; ar.LayoutOrder=0
local al=Instance.new("TextLabel",ar); al.Text="Select Area"; al.Font=Enum.Font.Gotham; al.TextSize=14; al.TextColor3=Color3.fromRGB(220,220,220)
al.Size=UDim2.new(0.6,0,1,0); al.BackgroundTransparency=1; al.TextXAlignment=Enum.TextXAlignment.Left
local ab=Instance.new("TextBox",ar); ab.Text=tostring(Config.Area); ab.Font=Enum.Font.GothamBold; ab.TextSize=14; ab.TextColor3=Color3.fromRGB(255,255,255)
ab.Size=UDim2.new(0,50,0,26); ab.Position=UDim2.new(1,-55,0,2); ab.BackgroundColor3=Color3.fromRGB(40,40,50); ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,4)
ab.FocusLost:Connect(function() local n=tonumber(ab.Text); if n and n>=1 then Config.Area=math.floor(n); ab.Text=tostring(Config.Area); teleportArea(Config.Area) else ab.Text=tostring(Config.Area) end end)

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
task.spawn(function() while Running and task.wait(0.1) do if Config.AutoShoot then pcall(doShoot) end end end)
task.spawn(function() while Running and task.wait(1) do
    if Config.CollectCash then pcall(doCash) end
    if Config.UpgradeAll then pcall(doUpgrade) end
    if Config.AutoRebirth then pcall(doRebirth) end
end end)

SG.Destroying:Connect(function() Running=false end)
UIS.InputBegan:Connect(function(i,g) if not g and i.KeyCode==Enum.KeyCode.RightControl then SG.Enabled=not SG.Enabled end end)
print("[BRAINROT SNIPER] loaded — Right Ctrl to toggle GUI")
