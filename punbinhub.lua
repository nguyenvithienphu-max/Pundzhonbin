--// =====================================================
--// PUNBIN HUB FULL | Blox Fruits
--// Auto Farm ALL SEA | Auto Level (Sea 1)
--// Auto Boss (near) | Auto Haki | Auto Skill
--// =====================================================

repeat task.wait() until game:IsLoaded()

--// SERVICES
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

--// GLOBAL FLAGS
_G.AutoFarm = false
_G.AutoLevel = false
_G.AutoBoss = false
_G.AutoHaki = false
_G.AutoSkill = false

--// CHARACTER
local function GetChar()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    return char, hrp, hum
end

--// ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PunbinHubFULL"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,320)
main.Position = UDim2.new(0.04,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(28,28,28)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,42)
title.Text = "🔥 PUNBIN HUB FULL 🔥"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function MakeBtn(text, y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.85,0,0,40)
    b.Position = UDim2.new(0.075,0,0,y)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(190,60,60)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local btnFarm  = MakeBtn("Auto Farm (ALL SEA)", 60)
local btnLevel = MakeBtn("Auto Level (Sea 1)", 110)
local btnBoss  = MakeBtn("Auto Boss (Near)", 160)
local btnHaki  = MakeBtn("Auto Haki", 210)
local btnSkill = MakeBtn("Auto Skill (Z/X/C)", 260)

local function Toggle(btn, flagName)
    _G[flagName] = not _G[flagName]
    btn.Text = btn.Text:match("^(.-):") .. (_G[flagName] and ": ON" or ": OFF")
    btn.BackgroundColor3 = _G[flagName] and Color3.fromRGB(60,200,60) or Color3.fromRGB(190,60,60)
end

btnFarm.MouseButton1Click:Connect(function() Toggle(btnFarm, "AutoFarm") end)
btnLevel.MouseButton1Click:Connect(function() Toggle(btnLevel, "AutoLevel") end)
btnBoss.MouseButton1Click:Connect(function() Toggle(btnBoss, "AutoBoss") end)
btnHaki.MouseButton1Click:Connect(function() Toggle(btnHaki, "AutoHaki") end)
btnSkill.MouseButton1Click:Connect(function() Toggle(btnSkill, "AutoSkill") end)

--// ================= HELPERS =================
local function GetNearestEnemy(isBoss)
    local _, hrp = GetChar()
    local best, dist = nil, math.huge
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if (not isBoss) or (isBoss and v.Name:lower():find("boss")) then
                local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    best = v
                end
            end
        end
    end
    return best
end

--// SEA 1 AUTO LEVEL TARGET (đơn giản, ổn định)
local function GetSea1EnemyByLevel()
    local lv = Player.Data.Level.Value
    if lv < 50 then return "Bandit"
    elseif lv < 120 then return "Monkey"
    elseif lv < 300 then return "Pirate"
    elseif lv < 700 then return "Galley Pirate"
    else return nil end
end

local function ClickAttack()
    VirtualUser:Button1Down(Vector2.new(0,0))
    VirtualUser:Button1Up(Vector2.new(0,0))
end

--// ================= LOOPS =================
-- Auto Farm ALL SEA
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoFarm then
                local _, hrp = GetChar()
                local e = GetNearestEnemy(false)
                if e then
                    hrp.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0,0,4)
                    e.HumanoidRootPart.Size = Vector3.new(60,60,60)
                    e.HumanoidRootPart.Transparency = 1
                    e.HumanoidRootPart.CanCollide = false
                    ClickAttack()
                end
            end
        end)
    end
end)

-- Auto Level (Sea 1)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoLevel then
                local name = GetSea1EnemyByLevel()
                if name then
                    for _,e in pairs(workspace.Enemies:GetChildren()) do
                        if e.Name == name and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                            local _, hrp = GetChar()
                            hrp.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0,0,4)
                            e.HumanoidRootPart.Size = Vector3.new(55,55,55)
                            e.HumanoidRootPart.Transparency = 1
                            e.HumanoidRootPart.CanCollide = false
                            ClickAttack()
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Boss (Near)
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoBoss then
                local _, hrp = GetChar()
                local boss = GetNearestEnemy(true)
                if boss then
                    hrp.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0,0,6)
                    ClickAttack()
                end
            end
        end)
    end
end)

-- Auto Haki
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.AutoHaki then
                if not Player.Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

-- Auto Skill Z/X/C
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.AutoSkill then
                for _,k in pairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C}) do
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, k, false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, k, false, game)
                end
            end
        end)
    end
end)
