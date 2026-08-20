--[[
    BRAINROT SNIPER ULTIMATE (Classic UI with Debug Logging)
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
    local RE, RF, GF, BF, DF

    -- Remove old GUI
    local old = CoreGui:FindFirstChild("BSGUI")
    if old then
        local okDel, delErr = pcall(function() old:Destroy() end)
        if not okDel then
            -- if destroy fails, rename it so we don't conflict
            old.Name = "BSGUI_OLD"
        end
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
    MF.Draggable = true

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

    ab.FocusLost:Connect(function()
        local n = tonumber(ab.Text)
        if n and n >= 1 and n <= 14 then
            Config.Area = math.floor(n)
            ab.Text = tostring(Config.Area)
            if RE then
                local r = RE:FindFirstChild("LoadPosition")
                if r then pcall(function() r:FireServer(Config.Area) end) end
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

    -- Game Logic Spawn
    task.spawn(function()
        -- Scan for remotes
        for i = 1, 60 do
            pcall(function()
                local s = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
                local p = s and s:FindFirstChild("Packages")
                local n = p and p:FindFirstChild("Net")
                if n then
                    RE = n:FindFirstChild("RE")
                    RF = n:FindFirstChild("RF")
                end
            end)
            if RE then break end
            task.wait(0.5)
        end

        -- Scan folders
        pcall(function()
            GF = workspace:FindFirstChild("GameFolder")
            local rt = GF and GF:FindFirstChild("RunTime")
            BF = rt and rt:FindFirstChild("Brainrot")
            DF = rt and rt:FindFirstChild("Drone")
        end)

        local function fire(n, ...)
            if RE then
                local r = RE:FindFirstChild(n)
                if r then pcall(function() r:FireServer(...) end) end
            end
        end

        local function invoke(n, ...)
            if RF then
                local r = RF:FindFirstChild(n)
                if r then pcall(function() r:InvokeServer(...) end) end
            end
        end

        -- Loops
        task.spawn(function()
            while Running do
                task.wait(0.25)
                if Config.AutoShoot and RE then
                    fire("EquipBestBrainrot")
                    pcall(function()
                        if BF then
                            for _, b in pairs(BF:GetChildren()) do
                                local p = b:FindFirstChildWhichIsA("BasePart")
                                if p then
                                    fire("BrainrotAttack", b)
                                    fire("BrainrotAttack", p.Position)
                                    fire("BrainrotAttack", b, p.Position)
                                end
                            end
                        end
                        local bm = GF and GF:FindFirstChild("BrainrotModels")
                        if bm then
                            for _, b in pairs(bm:GetChildren()) do
                                local p = b:FindFirstChildWhichIsA("BasePart")
                                if p then
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
                    end)
                    fire("DroneCreate", Config.Area)
                    fire("DroneCreate")
                    pcall(function()
                        if DF then
                            for _, d in pairs(DF:GetChildren()) do
                                fire("DroneHit", d)
                            end
                        end
                    end)
                    for i = 1, 10 do fire("PlaceBrainrot", i) end
                end
            end
        end)

        task.spawn(function()
            while Running do
                task.wait(1)
                if Config.CollectCash then
                    fire("ClaimGold")
                    fire("DroneClaim")
                    invoke("DroneCapture")
                    invoke("DroneRequest")
                end
                if Config.UpgradeAll then
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
                end
            end
        end)

        task.spawn(function()
            while Running do
                task.wait(3.5)
                if Config.AutoRebirth then
                    fire("RebirthUp")
                    fire("RebirthUp", true)
                end
                if Config.AutoFuse then
                    for i = 1, 10 do
                        invoke("FuseBrainrot")
                        invoke("FuseBrainrot", i)
                    end
                    fire("EquipBestBrainrot")
                end
                if Config.AutoClaim then
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
