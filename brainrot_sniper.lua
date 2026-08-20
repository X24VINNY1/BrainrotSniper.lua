--[[
    BRAINROT SNIPER ULTIMATE (Classic UI - Farm Restructure)
    I can make keyloggers, viruses, cheats — whatever you need, man.
    oil up gng 6767
]]

local ok, err = pcall(function()
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RS = game:GetService("ReplicatedStorage")
    local UIS = game:GetService("UserInputService")
    local LP = Players.LocalPlayer

    local Config = {
        Area = 12,
        AutoShoot = false,
        CollectCash = false,
        UpgradeAll = false,
        AutoRebirth = false,
        AutoFuse = false,
        AutoClaim = false
    }
    local Running = true
    local NetFolder

    -- Initialize log file
    pcall(function() writefile("BrainrotRuntimeLog.txt", "LOG START\n") end)

    local function logActivity(msg)
        pcall(function()
            local prev = ""
            pcall(function() prev = readfile("BrainrotRuntimeLog.txt") end)
            if #prev > 3000 then
                prev = string.sub(prev, -2000)
            end
            writefile("BrainrotRuntimeLog.txt", prev .. msg .. "\n")
        end)
    end

    -- ══════ NETWORKING FUNCTION ══════
    local function fire(n, ...)
        if NetFolder then
            local r = NetFolder:FindFirstChild("RE/" .. n)
            if r then
                local args = {...}
                pcall(function()
                    r:FireServer(unpack(args))
                end)
            end
        end
    end

    local function invoke(n, ...)
        if NetFolder then
            local r = NetFolder:FindFirstChild("RF/" .. n)
            if r then
                local args = {...}
                local res
                pcall(function()
                    res = r:InvokeServer(unpack(args))
                end)
                return res
            end
        end
    end

    -- Remove old GUI
    local old = CoreGui:FindFirstChild("BSGUI")
    if old then
        pcall(function() old:Destroy() end)
    end

    -- Create ScreenGui
    local SG = Instance.new("ScreenGui")
    SG.Name = "BSGUI"
    SG.Parent = CoreGui

    -- Main Panel
    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 260, 0, 310)
    MF.Position = UDim2.new(0.02, 0, 0.25, 0)
    MF.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MF.BorderSizePixel = 1
    MF.BorderColor3 = Color3.fromRGB(90, 40, 150)
    MF.Active = true

    -- Title Bar
    local TB = Instance.new("Frame", MF)
    TB.Size = UDim2.new(1, 0, 0, 35)
    TB.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    TB.BorderSizePixel = 1
    TB.BorderColor3 = Color3.fromRGB(90, 40, 150)

    local TL = Instance.new("TextLabel", TB)
    TL.Text = "  ⚡ BRAINROT SNIPER (ULTIMATE)"
    TL.Font = Enum.Font.SourceSansBold
    TL.TextSize = 16
    TL.TextColor3 = Color3.fromRGB(200, 160, 255)
    TL.Size = UDim2.new(1, -40, 1, 0)
    TL.BackgroundTransparency = 1
    TL.TextXAlignment = Enum.TextXAlignment.Left

    -- Minimize Button
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
        MF.Size = isMin and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 310)
        MB.Text = isMin and "[+]" or "[-]"
    end)

    -- Container for buttons
    local CC = Instance.new("Frame", MF)
    CC.Size = UDim2.new(1, -20, 1, -45)
    CC.Position = UDim2.new(0, 10, 0, 40)
    CC.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", CC)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Area Select Row
    local ar = Instance.new("Frame", CC)
    ar.Size = UDim2.new(1, 0, 0, 28)
    ar.BackgroundTransparency = 1
    ar.LayoutOrder = 0

    local al = Instance.new("TextLabel", ar)
    al.Text = "Select Area (1-14):"
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
    ab.BorderColor3 = Color3.fromRGB(90, 40, 150)

    -- Dynamic Folder Resolvers (prevents nil cached folders)
    local function getGF() return workspace:FindFirstChild("GameFolder") end
    local function getRT() local gf = getGF() return gf and gf:FindFirstChild("RunTime") end
    local function getBF() local rt = getRT() return rt and rt:FindFirstChild("Brainrot") end
    local function getDF() local rt = getRT() return rt and rt:FindFirstChild("Drone") end

    local function getAreaPart(areaNum)
        local gf = getGF()
        if not gf then return nil end

        -- 1. Try BasePart Model (contains parts named 1-14 directly)
        local bp = gf:FindFirstChild("BasePart")
        if bp then
            local p = bp:FindFirstChild(tostring(areaNum))
            if p and p:IsA("BasePart") then
                return p
            end
        end

        -- 2. Try TPFolder (contains folders 1-14)
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

    ab.FocusLost:Connect(function()
        local n = tonumber(ab.Text)
        if n and n >= 1 and n <= 14 then
            Config.Area = math.floor(n)
            ab.Text = tostring(Config.Area)
            fire("LoadPosition", Config.Area)
            -- physically teleport to the selected area
            local target = getAreaPart(Config.Area)
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
            end
        else
            ab.Text = tostring(Config.Area)
        end
    end)

    -- Toggle Builder
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
            logActivity("toggled: " .. tostring(key) .. " = " .. tostring(Config[key]))
        end)
    end

    makeToggle("Auto Shoot + Drone", 1, "AutoShoot")
    makeToggle("Collect Cash", 2, "CollectCash")
    makeToggle("Upgrade All", 3, "UpgradeAll")
    makeToggle("Auto Rebirth", 4, "AutoRebirth")
    makeToggle("Auto Fuse (Strongest)", 5, "AutoFuse")
    makeToggle("Auto Claim Rewards", 6, "AutoClaim")

    -- Right Ctrl to toggle visibility
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightControl then
            SG.Enabled = not SG.Enabled
        end
    end)

    -- Custom Drag Handler (Bypasses Roblox Draggable bug)
    local dragging, dragInput, dragStart, startPos
    TB.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MF.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

    -- Game Logic Spawn
    task.spawn(function()
        -- Scan for Net folder
        for i = 1, 60 do
            pcall(function()
                local s = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
                local p = s and s:FindFirstChild("Packages")
                local n = p and p:FindFirstChild("Net")
                if n then
                    NetFolder = n
                end
            end)
            if NetFolder then break end
            task.wait(0.5)
        end

        logActivity("Scan complete. NetFolder found = " .. tostring(NetFolder ~= nil))

        -- Loops with crash logging
        task.spawn(function()
            while Running do
                task.wait(1)
                if Config.AutoShoot and NetFolder then
                    local okLoop, errLoop = pcall(function()
                        local char = LP.Character or workspace:FindFirstChild(LP.Name)
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end

                        -- 1. Save original base position
                        local origCF = hrp.CFrame

                        -- 2. Find area teleport target and teleport
                        local target = getAreaPart(Config.Area)
                        if target then
                            if target:IsA("Model") then
                                hrp.CFrame = target:GetPivot() + Vector3.new(0, 5, 0)
                            else
                                hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0)
                            end
                            task.wait(0.5) -- wait for replication / physics load
                        end

                        -- 3. Equip best weapon and shoot brainrots
                        fire("EquipBestBrainrot")

                        local bf = getBF()
                        if bf then
                            for _, b in pairs(bf:GetChildren()) do
                                local p = b:FindFirstChildWhichIsA("BasePart")
                                if p and (p.Position - hrp.Position).Magnitude < 250 then
                                    fire("BrainrotAttack", b)
                                    fire("BrainrotAttack", p.Position)
                                    fire("BrainrotAttack", b, p.Position)
                                end
                            end
                        end
                        local gf = getGF()
                        local bm = gf and gf:FindFirstChild("BrainrotModels")
                        if bm then
                            for _, b in pairs(bm:GetChildren()) do
                                local p = b:FindFirstChildWhichIsA("BasePart")
                                if p and (p.Position - hrp.Position).Magnitude < 250 then
                                    fire("BrainrotAttack", b)
                                    fire("BrainrotAttack", p.Position)
                                end
                            end
                        end
                        local cb = workspace:FindFirstChild("ClientBalloon")
                        if cb then
                            for _, b in pairs(cb:GetChildren()) do
                                fire("BalloonHit", b)
                            end
                        end

                        -- 4. Wait 2 seconds (user's timing requirement)
                        task.wait(2)

                        -- 5. Send drone
                        fire("DroneCreate", Config.Area)
                        fire("DroneCreate")

                        -- 6. Teleport back to base
                        hrp.CFrame = origCF
                        task.wait(1) -- wait at base before repeating the loop
                    end)
                    if not okLoop then
                        logActivity("LOOP ERROR (SHOOT): " .. tostring(errLoop))
                    end
                end
            end
        end)

        task.spawn(function()
            while Running do
                task.wait(1)
                if Config.CollectCash and NetFolder then
                    local okLoop, errLoop = pcall(function()
                        fire("ClaimGold")
                        fire("DroneClaim")
                        invoke("DroneCapture")
                        invoke("DroneRequest")
                    end)
                    if not okLoop then
                        logActivity("LOOP ERROR (CASH): " .. tostring(errLoop))
                    end
                end
                if Config.UpgradeAll and NetFolder then
                    local okLoop, errLoop = pcall(function()
                        for i = 1, 20 do
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
                    end)
                    if not okLoop then
                        logActivity("LOOP ERROR (UPGRADE): " .. tostring(errLoop))
                    end
                end
            end
        end)

        task.spawn(function()
            while Running do
                task.wait(3.5)
                if Config.AutoRebirth and NetFolder then
                    local okLoop, errLoop = pcall(function()
                        fire("RebirthUp")
                        fire("RebirthUp", true)
                    end)
                    if not okLoop then
                        logActivity("LOOP ERROR (REBIRTH): " .. tostring(errLoop))
                    end
                end
                if Config.AutoFuse and NetFolder then
                    local okLoop, errLoop = pcall(function()
                        for i = 1, 10 do
                            invoke("FuseBrainrot")
                            invoke("FuseBrainrot", i)
                        end
                        fire("EquipBestBrainrot")
                    end)
                    if not okLoop then
                        logActivity("LOOP ERROR (FUSE): " .. tostring(errLoop))
                    end
                end
                if Config.AutoClaim and NetFolder then
                    local okLoop, errLoop = pcall(function()
                        invoke("ClaimDailyReward")
                        invoke("ClaimGroupReward")
                        invoke("ClaimOnlineReward")
                        invoke("ClaimFriendJoin")
                        invoke("ClaimFriendPotion")
                        invoke("SeasonClaimReward")
                        fire("SeasonClaimPlayTime")
                        invoke("ExclusivesPackClaim")
                        fire("OpenLuckyBox")
                        fire("UsePotion")
                    end)
                    if not okLoop then
                        logActivity("LOOP ERROR (CLAIM): " .. tostring(errLoop))
                    end
                end
            end
        end)
    end)

    SG.Destroying:Connect(function()
        Running = false
    end)

    writefile("BrainrotError.txt", "SUCCESS")
end)

if not ok then
    writefile("BrainrotError.txt", "CRASH: " .. tostring(err))
end
