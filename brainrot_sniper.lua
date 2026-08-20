--[[
    BRAINROT SNIPER — Xeno Executor
    oil up gng. shit aint tuff bro.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local Config = {
    Area = 12,
    AutoShoot = false,
    CollectCash = false,
    UpgradeAll = false,
    AutoRebirth = false
}

local Running = true

-- Utility functions
local function getGF() return workspace:FindFirstChild("GameFolder") end
local function getRT() local gf = getGF() return gf and gf:FindFirstChild("RunTime") end
local function getBF() local rt = getRT() return rt and rt:FindFirstChild("Brainrot") end

local function getRemote(name, className)
    className = className or "RemoteEvent"
    local net = ReplicatedStorage:FindFirstChild("Shared")
    net = net and net:FindFirstChild("Packages")
    net = net and net:FindFirstChild("Net")
    if net then
        local folder = className == "RemoteEvent" and "RE" or "RF"
        local rFolder = net:FindFirstChild(folder)
        if rFolder then
            return rFolder:FindFirstChild(name)
        end
    end
    return nil
end

local function fire(name, ...)
    local r = getRemote(name, "RemoteEvent")
    if r then
        pcall(function() r:FireServer(...) end)
    end
end

local function invoke(name, ...)
    local r = getRemote(name, "RemoteFunction")
    if r then
        local res
        pcall(function() res = r:InvokeServer(...) end)
        return res
    end
end

local function getAreaPart(areaNum)
    local gf = getGF()
    if not gf then return nil end

    -- 1. Try BasePart
    local bp = gf:FindFirstChild("BasePart")
    if bp then
        local p = bp:FindFirstChild(tostring(areaNum))
        if p and p:IsA("BasePart") then return p end
    end

    -- 2. Try TPFolder
    local tp = gf:FindFirstChild("TPFolder")
    local f = tp and tp:FindFirstChild(tostring(areaNum))
    if f then
        local p = f:FindFirstChildWhichIsA("BasePart", true)
        if p then return p end
    end

    -- 3. Try BrainrotHidePos
    local hp = gf:FindFirstChild("BrainrotHidePos")
    local h = hp and hp:FindFirstChild(tostring(areaNum))
    if h then
        local p = h:FindFirstChildWhichIsA("BasePart", true)
        if p then return p end
    end
    return nil
end

local function getPlayerBase()
    local gf = getGF()
    local pp = gf and gf:FindFirstChild("PlayerPlace")
    if not pp then return nil end

    for _, base in ipairs(pp:GetChildren()) do
        if base:FindFirstChild("YourBaseAtt") or base.Name:find(tostring(LP.UserId)) then
            return base
        end
        for _, child in ipairs(base:GetChildren()) do
            if child.Name:find(tostring(LP.UserId)) then
                return base
            end
        end
    end
    return nil
end

local function getBaseCFrame()
    local base = getPlayerBase()
    if base then
        local att = base:FindFirstChild("YourBaseAtt") or base:FindFirstChild("BaseAtt", true)
        if att then
            return CFrame.new(att.WorldPosition) + Vector3.new(0, 3, 0)
        end
        local floor = base:FindFirstChild("Floor") or base:FindFirstChildWhichIsA("BasePart", true)
        if floor then
            return floor.CFrame + Vector3.new(0, 3, 0)
        end
    end
    
    local spawnLoc = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildWhichIsA("SpawnLocation")
    if spawnLoc then
        return spawnLoc.CFrame + Vector3.new(0, 5, 0)
    end
    return nil
end

local function getClosestBrainrot()
    local char = LP.Character or workspace:FindFirstChild(LP.Name)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest, dist = nil, math.huge
    local bf = getBF()
    local bm = getGF() and getGF():FindFirstChild("BrainrotModels")

    local targets = {}
    if bf then
        for _, b in ipairs(bf:GetChildren()) do table.insert(targets, b) end
    end
    if bm then
        for _, b in ipairs(bm:GetChildren()) do table.insert(targets, b) end
    end

    for _, b in ipairs(targets) do
        local p = b:FindFirstChildWhichIsA("BasePart")
        if p then
            local d = (p.Position - hrp.Position).Magnitude
            if d < dist then
                closest = b
                dist = d
            end
        end
    end
    return closest
end

-- Teleport to area
local function teleportToArea(areaNum)
    local target = getAreaPart(areaNum)
    local char = LP.Character or workspace:FindFirstChild(LP.Name)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if target and hrp then
        pcall(function()
            if target:IsA("Model") then
                hrp.CFrame = target:GetPivot() + Vector3.new(0, 5, 0)
            else
                hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
            end
        end)
        return true
    end
    return false
end

-- Auto Shoot Loop Cycle
local function doAutoShoot()
    local areaNum = Config.Area
    if not teleportToArea(areaNum) then return end
    task.wait(0.4) -- Wait for load

    fire("EquipBestBrainrot")

    -- Shoot target in range
    for i = 1, 5 do
        local target = getClosestBrainrot()
        if target then
            local p = target:FindFirstChildWhichIsA("BasePart")
            if p and (p.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 350 then
                fire("BrainrotAttack", target)
                fire("BrainrotAttack", p.Position)
                fire("BrainrotAttack", target, p.Position)
            end
        end
        task.wait(0.2)
    end

    -- Return to base spawn
    local baseCF = getBaseCFrame()
    local char = LP.Character or workspace:FindFirstChild(LP.Name)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and baseCF then
        hrp.CFrame = baseCF
    end
    task.wait(0.4)

    -- Send Drone
    fire("DroneCreate", areaNum)
    fire("DroneCreate")
end

-- Collect Cash
local function collectCash()
    fire("ClaimGold")
    fire("DroneClaim")
    invoke("DroneCapture")
    invoke("DroneRequest")

    local base = getPlayerBase()
    if base then
        local ac = base:FindFirstChild("AutoCollect")
        local part = ac and ac:FindFirstChild("BasePart") or ac
        if part and part:IsA("BasePart") then
            local char = LP.Character or workspace:FindFirstChild(LP.Name)
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if firetouchinterest then
                    firetouchinterest(hrp, part, 0)
                    task.wait()
                    firetouchinterest(hrp, part, 1)
                else
                    local oldCF = hrp.CFrame
                    hrp.CFrame = part.CFrame
                    task.wait(0.1)
                    hrp.CFrame = oldCF
                end
            end
        end
    end
end

-- Upgrade All (Stats + Tycoon Buttons)
local function buyUpgrades()
    -- Remotes
    for i = 1, 10 do
        fire("ShotLevelUp")
        fire("ShieldLevelUp")
        fire("DroneLevelUp")
    end
    for i = 1, 30 do
        fire("UpgradeBrainrot", i)
    end
    invoke("ChargeShield")
    for i = 1, 10 do
        fire("UnlockSlot", i)
    end
    fire("EquipBestBrainrot")

    -- Tycoon buttons
    local base = getPlayerBase()
    if base and base:FindFirstChild("Places") then
        local char = LP.Character or workspace:FindFirstChild(LP.Name)
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, place in ipairs(base.Places:GetChildren()) do
                local btn = place:FindFirstChild("BasePart") or place:FindFirstChildWhichIsA("BasePart", true)
                if btn then
                    if firetouchinterest then
                        firetouchinterest(hrp, btn, 0)
                        task.wait()
                        firetouchinterest(hrp, btn, 1)
                    else
                        local oldCF = hrp.CFrame
                        hrp.CFrame = btn.CFrame
                        task.wait(0.05)
                        hrp.CFrame = oldCF
                    end
                end
            end
        end
    end
end

-- GUI BUILDER
local old = CoreGui:FindFirstChild("BSGUI")
if old then pcall(function() old:Destroy() end) end

local SG = Instance.new("ScreenGui")
SG.Name = "BSGUI"
SG.Parent = CoreGui

local MF = Instance.new("Frame", SG)
MF.Size = UDim2.new(0, 260, 0, 280)
MF.Position = UDim2.new(0.02, 0, 0.25, 0)
MF.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MF.BorderSizePixel = 1
MF.BorderColor3 = Color3.fromRGB(120, 60, 200)
MF.Active = true

local TB = Instance.new("Frame", MF)
TB.Size = UDim2.new(1, 0, 0, 35)
TB.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TB.BorderSizePixel = 1
TB.BorderColor3 = Color3.fromRGB(120, 60, 200)

local TL = Instance.new("TextLabel", TB)
TL.Text = "  ⚡ BRAINROT SNIPER (V2)"
TL.Font = Enum.Font.SourceSansBold
TL.TextSize = 16
TL.TextColor3 = Color3.fromRGB(200, 160, 255)
TL.Size = UDim2.new(1, -40, 1, 0)
TL.BackgroundTransparency = 1
TL.TextXAlignment = Enum.TextXAlignment.Left

local MB = Instance.new("TextButton", TB)
MB.Text = "[-]"
MB.Font = Enum.Font.SourceSansBold
MB.TextSize = 16
MB.TextColor3 = Color3.fromRGB(180, 180, 180)
MB.Size = UDim2.new(0, 30, 0, 30)
MB.Position = UDim2.new(1, -35, 0, 2)
MB.BackgroundTransparency = 1

local isMin = false
MB.MouseButton1Click:Connect(function()
    isMin = not isMin
    MF.Size = isMin and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 280)
    MB.Text = isMin and "[+]" or "[-]"
end)

local CC = Instance.new("Frame", MF)
CC.Size = UDim2.new(1, -20, 1, -45)
CC.Position = UDim2.new(0, 10, 0, 40)
CC.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", CC)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Area select
local ar = Instance.new("Frame", CC)
ar.Size = UDim2.new(1, 0, 0, 28)
ar.BackgroundTransparency = 1
ar.LayoutOrder = 0

local al = Instance.new("TextLabel", ar)
al.Text = "Select Area (1-50):"
al.Font = Enum.Font.SourceSans
al.TextSize = 15
al.TextColor3 = Color3.fromRGB(220, 220, 220)
al.Size = UDim2.new(0.65, 0, 1, 0)
al.BackgroundTransparency = 1
al.TextXAlignment = Enum.TextXAlignment.Left

local ab = Instance.new("TextBox", ar)
ab.Text = tostring(Config.Area)
ab.Font = Enum.Font.SourceSansBold
ab.TextSize = 15
ab.TextColor3 = Color3.fromRGB(255, 255, 255)
ab.Size = UDim2.new(0, 50, 0, 22)
ab.Position = UDim2.new(1, -55, 0, 3)
ab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ab.BorderSizePixel = 1
ab.BorderColor3 = Color3.fromRGB(120, 60, 200)

ab.FocusLost:Connect(function()
    local n = tonumber(ab.Text)
    if n and n >= 1 and n <= 50 then
        Config.Area = math.floor(n)
        ab.Text = tostring(Config.Area)
        fire("LoadPosition", Config.Area)
        teleportToArea(Config.Area)
    else
        ab.Text = tostring(Config.Area)
    end
end)

local function makeToggle(name, ord, key)
    local row = Instance.new("Frame", CC)
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundTransparency = 1
    row.LayoutOrder = ord

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = name
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 15
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Size = UDim2.new(0.75, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", row)
    btn.Text = "[   ]"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -45, 0, 2)
    btn.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        if Config[key] then
            btn.Text = "[ X ]"
            btn.TextColor3 = Color3.fromRGB(150, 255, 150)
        else
            btn.Text = "[   ]"
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
end

makeToggle("Auto Shoot + Drone", 1, "AutoShoot")
makeToggle("Collect Cash", 2, "CollectCash")
makeToggle("Upgrade All", 3, "UpgradeAll")
makeToggle("Auto Rebirth", 4, "AutoRebirth")

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        SG.Enabled = not SG.Enabled
    end
end)

-- Dragging
local dragging, dragInput, dragStart, startPos
TB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MF.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TB.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Execution loops
task.spawn(function()
    while Running do
        task.wait(1)
        if Config.AutoShoot then
            pcall(doAutoShoot)
            task.wait(1.5)
        end
    end
end)

task.spawn(function()
    while Running do
        task.wait(1)
        if Config.CollectCash then pcall(collectCash) end
        if Config.UpgradeAll then pcall(buyUpgrades) end
    end
end)

task.spawn(function()
    while Running do
        task.wait(3.5)
        if Config.AutoRebirth then
            pcall(function()
                fire("RebirthUp")
                fire("RebirthUp", true)
            end)
        end
    end
end)

SG.Destroying:Connect(function() Running = false end)
print("Brainrot Sniper script loaded successfully!")
