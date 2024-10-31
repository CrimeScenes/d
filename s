local VirtualInputManager = game:GetService("VirtualInputManager")

if getgenv().Forbidden.Configuration.FPSUnlock.IsEnabled then
    setfpscap(999)
end

if getgenv().Forbidden.Configuration.ConsoleCleaner.Activate then
    VirtualInputManager:SendKeyEvent(true, "F9", 0, game) 
    wait() 
    VirtualInputManager:SendKeyEvent(false, "F9", 0, game)

    game.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "MainView" and descendant.Parent.Name == "DevConsoleUI" then
            task.wait()
            local Descendant = descendant.Parent.Parent.Parent
            Descendant.Enabled = false
        end
    end)

    coroutine.resume(coroutine.create(function()
        while task.wait() do 
            pcall(function()
                if not game:GetService("CoreGui"):FindFirstChild("DevConsoleUI", true):FindFirstChild("MainView") then
                    VirtualInputManager:SendKeyEvent(true, "F9", 0, game)
                    wait()
                    VirtualInputManager:SendKeyEvent(false, "F9", 0, game)
                end
            end)
        end
    end))
end

if getgenv().Forbidden.Features.Settings.RainbowBars then
    local players = game:GetService("Players")
    local run_service = game:GetService("RunService")

    local function rainbow_bars()
        local hue = (tick() % 10) / 10
        local main_gui = players.LocalPlayer.PlayerGui:FindFirstChild("MainScreenGui")
        if main_gui then
            local energy_bar = main_gui.Bar:FindFirstChild("Energy") and main_gui.Bar.Energy.bar
            local armor_bar = main_gui.Bar:FindFirstChild("Armor") and main_gui.Bar.Armor.bar
            local hp_bar = main_gui.Bar:FindFirstChild("HP") and main_gui.Bar.HP.bar
            if energy_bar and armor_bar and hp_bar then
                -- Set background color of bars to a rainbow effect
                energy_bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                armor_bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                hp_bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            end
        end
    end

    run_service.RenderStepped:Connect(rainbow_bars)
end



if getgenv().Forbidden.Features.Settings.StretchRes then
    local Camera = workspace.CurrentCamera
    if getgenv().gg_scripters == nil then
        getgenv().gg_scripters = true -- Prevent multiple connections
        game:GetService("RunService").RenderStepped:Connect(function()
            -- Adjusting the camera CFrame based on the StretchFactor from the new table structure
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Forbidden.Features.Configurations.Resolution.StretchFactor, 0, 0, 0, 1)
        end)
    end
end

-- Function to handle the keybind and rejoin the server
local function onKeyPress(input, gameProcessed)
    -- Check if the key is pressed and the game is not processing another input
    if input.KeyCode == getgenv().Forbidden.Rejoin.Keybind.ActivateKey and not gameProcessed then
        if getgenv().Forbidden.Rejoin.Enabled then  -- Check if the rejoin feature is enabled.
            if getgenv().Forbidden.Rejoin.Delay.UseDelay then  -- Check if delay is enabled.
                task.wait(getgenv().Forbidden.Rejoin.Delay.Duration)  -- Wait for the specified duration.
            end
            
            -- Rejoin the same server
            print("Rejoining the game...")  -- You can also use a message to indicate action taken.
            local placeId = game.PlaceId  -- Get the current game's Place ID
            local teleportService = game:GetService("TeleportService")  -- Access the teleport service
            teleportService:Teleport(placeId, game.Players.LocalPlayer)  -- Rejoin the same server
        end
    end
end




local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Function to perform the spin
local function performSpin()
    if getgenv().Forbidden.Spin.Enabled then  -- Check if spin is enabled
        -- Calculate how many frames to rotate the camera
        for i = 1, math.floor(getgenv().Forbidden.Spin.Motion.Degree / getgenv().Forbidden.Spin.Motion.Speed) do
            -- Spin the camera by the defined angle each frame
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(getgenv().Forbidden.Spin.Motion.Speed), 0)
            RunService.Heartbeat:Wait()  -- Wait for the next frame
        end
    end
end

-- Listen for input and trigger spin when the keybind is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then  -- Ignore input if it's being processed by a GUI
        if input.KeyCode == getgenv().Forbidden.Spin.Keybind then
            performSpin()
        end
    end
end)


if getgenv().Forbidden.AntiLock.Settings.Enable then
    getgenv().worddot = false
    getgenv().key = tostring(getgenv().Forbidden.AntiLock.Settings.KeyBind.Name):lower()
    getgenv().X = getgenv().Forbidden.AntiLock.Velocity.X
    getgenv().Y = getgenv().Forbidden.AntiLock.Velocity.Y
    getgenv().Z = getgenv().Forbidden.AntiLock.Velocity.Z

    -- Function to send a notification
    local function sendNotification(title, text)
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2 -- Notification duration in seconds
        })
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().worddot then
            local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(getgenv().X, getgenv().Y, getgenv().Z)
            game:GetService("RunService").RenderStepped:Wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel
        end
    end)

    game:GetService("Players").LocalPlayer:GetMouse().KeyDown:Connect(function(keyPressed)
        if keyPressed == getgenv().key then
            pcall(function()
                getgenv().worddot = not getgenv().worddot -- Toggle worddot state
                if getgenv().worddot then
                    sendNotification("Toggle Notification", "On")
                else
                    sendNotification("Toggle Notification", "Off")
                end
            end)
        end
    end)
end



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local lastClickTime = 0
local isToggled = false

function Forlorn.mouse1click(x, y, delay)
    x = x or 0
    y = y or 0
    delay = delay or 0.05

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, false)
    task.wait(delay)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, false)

    UserInputService.MouseIconEnabled = true
end

function Forlorn.sendMouseEvent(x, y, button, isPressed)
    x = x or 0
    y = y or 0
    button = button or 0

    VirtualInputManager:SendMouseButtonEvent(x, y, button, isPressed, game, false)
    UserInputService.MouseIconEnabled = true
end

function Forlorn.mouse1press(x, y)
    Forlorn.sendMouseEvent(x, y, 0, true)
end

function Forlorn.mouse1release(x, y)
    Forlorn.sendMouseEvent(x, y, 0, false)
end

local function getMousePosition()
    local mouse = UserInputService:GetMouseLocation()
    return mouse.X, mouse.Y
end

local function isWithinBoxFOV(position)
    local screenPos = Camera:WorldToViewportPoint(position)
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fovHeight = getgenv().Forbidden.TriggerBot.Settings.BoxFOVSize.Height * 100
    local fovWidth = getgenv().Forbidden.TriggerBot.Settings.BoxFOVSize.Width * 100

    return (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude <= math.sqrt((fovHeight / 2)^2 + (fovWidth / 2)^2)
end

local function getPredictedPosition(character)
    local primaryPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
    if primaryPart then
        local velocity = primaryPart.Velocity
        local predictionMultiplier = getgenv().Forbidden.TriggerBot.Settings.Preds.PredictionMultiplier
        local timeToPredict = 0.1

        return primaryPart.Position + (velocity * predictionMultiplier * timeToPredict)
    end
    return nil
end

local function TriggerBotAction()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local currentTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if getgenv().Forbidden.TriggerBot.Settings.Preds.Safety.IgnoreKnife and 
                   (currentTool and (currentTool.Name:lower() == "knife" or currentTool.Name:lower() == "katana")) then
                    continue
                end

                local bestPart, closestDistance = nil, math.huge
                for _, partName in ipairs(getgenv().Forbidden.TriggerBot.Settings.Parts) do
                    local part = player.Character:FindFirstChild(partName)
                    if part then
                        local distance = (part.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                        if distance < closestDistance and isWithinBoxFOV(part.Position) then
                            closestDistance, bestPart = distance, part
                        end
                    end
                end

                if bestPart then
                    local predictedPosition = getPredictedPosition(player.Character)
                    if predictedPosition and isWithinBoxFOV(predictedPosition) and os.clock() - lastClickTime >= getgenv().Forbidden.TriggerBot.Settings.Cooldown then
                        lastClickTime = os.clock()
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:IsA("Tool") then
                            local shootFunction = tool:FindFirstChild("Fire")
                            if shootFunction and shootFunction:IsA("RemoteEvent") then
                                shootFunction:FireServer(player.Character)
                            else
                                local mouseX, mouseY = getMousePosition()
                                Forlorn.mouse1press(mouseX, mouseY)
                                Forlorn.mouse1release(mouseX, mouseY)
                            end
                            return
                        end
                    end
                end
            end
        end
    end
end

local function handleShootingMode()
    if getgenv().Forbidden.TriggerBot.Settings.Mode == "toggle" then
        isToggled = not isToggled
    else
        RunService:BindToRenderStep("TriggerBotHold", Enum.RenderPriority.Input.Value, TriggerBotAction)
    end
end

-- Detect player's jump and perform the shooting action
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Jumping:Connect(function(isJumping)
        if isJumping and isToggled then
            TriggerBotAction()
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == getgenv().Forbidden.TriggerBot.Keybinds.Shoot then
        handleShootingMode()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == getgenv().Forbidden.TriggerBot.Keybinds.Shoot then
        if getgenv().Forbidden.TriggerBot.Settings.Mode == "hold" then
            RunService:UnbindFromRenderStep("TriggerBotHold")
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Forbidden.TriggerBot.Settings.Mode == "hold" and UserInputService:IsKeyDown(getgenv().Forbidden.TriggerBot.Keybinds.Shoot) then
        TriggerBotAction()
    end
end)














local Player = game:GetService("Players").LocalPlayer
local SpeedGlitch = false

-- Listen for key presses
Player:GetMouse().KeyDown:Connect(function(Key)
    -- Check if the macro is enabled
    if getgenv().Forbidden.Macro.Settings.IsEnabled then
        -- Check if the pressed key matches the defined MacroKey
        if Key == tostring(getgenv().Forbidden.Macro.Settings.MacroKey.Name):lower() then
            SpeedGlitch = not SpeedGlitch
            if SpeedGlitch then
                repeat 
                    game:GetService("RunService").Heartbeat:wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", true, game)
                    game:GetService("RunService").Heartbeat:wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", false, game)
                    game:GetService("RunService").Heartbeat:wait()
                until not SpeedGlitch
            end
        end
    end
end)


-- Function to send a visual notification
local function sendNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = getgenv().Forbidden.ModCheck.NotificationDuration
    })
end


local specificUserIDs = {
    [4500691458] = "KTBGzz",  
    [1010631422] = "wokeupinanewhonda",  
    [6022880874] = "walkmetohelI",  
    [7431710086] = "36mgs",  
    [1135986996] = "n3cyAGB",  
    [698436742] = "fundbanks",  
    [3243100360] = "k0n1f",  
    [519444067] = "KaisfamousW",  
    [310874784] = "Xxsavage0kingxX",  
    [1690694106] = "iwan2go",  
    [2020261481] = "starwept",  
    [91659435] = "9inefold",  
    [401212532] = "firingmymag",  
    [1983384554] = "ruzinedd",  
    [927562193] = "0ny1e",  
    [30838516] = "x4op",  
    [1926407929] = "matsdead",  
    [3625704837] = "Kanekiwin334",   
    [7291734931] = "CactusCorleo",  
    [254100071] = "braidenenenenenenene",  
    [546448638] = "xhxshii",  
    [4663391922] = "sonlileo",  
    [1286238321] = "igetextremelyjealous",  
    [2662546553] = "Xzetso",  
    [2447729742] = "baboesss",  
    [2755167654] = "wDouradoo",  
    [932544] = "yo6",  
    [2488577014] = "Vpcoq",  
    [1018801293] = "k4mt",  
    [456419] = "Builderdad",  
}

-- Function to check for mod joins
game:GetService("Players").PlayerAdded:Connect(function(player)
    if getgenv().Forbidden.ModCheck.Enabled then
        local userId = player.UserId
        if specificUserIDs[userId] then
            -- User is a specific mod
            sendNotification("Mod Alert", specificUserIDs[userId] .. " has joined your game!")

            if getgenv().Forbidden.ModCheck.KickIfModJoined then
                -- Kick the player with a specific message
                game.Players.LocalPlayer:Kick("A mod joined lol: " .. specificUserIDs[userId] .. " joined.")
            end
        end
    end
end)

local UserInputService = game:GetService("UserInputService")

-- Connect the InputBegan event to listen for key presses
UserInputService.InputBegan:Connect(function(input)
    -- Check if the Panic System is enabled
    if getgenv().Forbidden.PanicSystem.Settings.IsActive then
        -- Check if the pressed key matches the defined ActivationKey
        if input.KeyCode == Enum.KeyCode[getgenv().Forbidden.PanicSystem.Settings.ActivationKey] then
            local customMessage = getgenv().Forbidden.PanicSystem.Config.Message
            local localPlayer = game.Players.LocalPlayer
            
            -- Kick the player with the custom message
            localPlayer:Kick(customMessage)
        end
    end
end)



if getgenv().Forbidden.Configuration.IntroSettings.ShowIntro then
    local soundId = "rbxassetid://6174439869"  -- Replace with your desired sound asset ID
    local ImageIdfr = "rbxassetid://13903798344"  -- Corrected decal asset ID

    -- Load the sound
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 10

    local Intro = {
        Intro = Instance.new("ScreenGui"),
        Anchored_Frame = Instance.new("Frame"),
        ImageLabel = Instance.new("ImageLabel")
    }

    -- Tween function for resizing elements
    function Tween(Object, Size1, Size2, Size3, Size4, Speed)
        Object:TweenSize(UDim2.new(Size1, Size2, Size3, Size4), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Speed, true)
    end

    -- Setup the GUI
    Intro.Intro.Name = "Intro"
    Intro.Intro.Parent = game.CoreGui
    Intro.Intro.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Intro.Anchored_Frame.Name = "Anchored_Frame"
    Intro.Anchored_Frame.Parent = Intro.Intro
    Intro.Anchored_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Intro.Anchored_Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Intro.Anchored_Frame.BackgroundTransparency = 1.000
    Intro.Anchored_Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Intro.Anchored_Frame.Size = UDim2.new(0, 400, 0, 400)  -- Static frame size for the image

    -- Set up the image label
    Intro.ImageLabel.Parent = Intro.Anchored_Frame
    Intro.ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    Intro.ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Intro.ImageLabel.BackgroundTransparency = 1.000
    Intro.ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    Intro.ImageLabel.Size = UDim2.new(1, 0, 1, 0)  -- Full size image label
    Intro.ImageLabel.Image = ImageIdfr  -- Assign the image ID
    Intro.ImageLabel.ImageTransparency = 1  -- Start invisible for animation

    -- Tween the image in
    local BlurEffect = Instance.new("BlurEffect", game.Lighting)
    BlurEffect.Size = 0

    -- Blur effect fade-in
    for i = 0, 24, 1 do
        wait()
        BlurEffect.Size = i
    end

    -- Play the sound
    sound.Parent = game.Workspace
    sound:Play()

    -- Tween in the image and make it visible
    Tween(Intro.ImageLabel, 1, 0, 1, 0, 1)  -- Expand image size
    for i = 1, 0, -0.05 do
        wait(0.05)
        Intro.ImageLabel.ImageTransparency = i  -- Fade-in the image
    end

    -- Wait for the intro to be displayed
    wait(4)

    -- Tween the image out and blur away
    Tween(Intro.Anchored_Frame, 0, 0, 0, 0, 1)

    -- Blur effect fade-out
    for i = 24, 1, -1 do
        wait()
        BlurEffect.Size = i
    end

    -- Clean up
    wait(1)
    Intro.Intro:Destroy()
    BlurEffect:Destroy()
end






if getgenv().Forbidden.Memory.Settings.Enable == true then
    local Memory

    game:GetService("RunService").RenderStepped:Connect(function()
        pcall(function()
            for i, v in pairs(game:GetService("CoreGui").RobloxGui.PerformanceStats:GetChildren()) do
                if v.Name == "PS_Button" then
                    if v.StatsMiniTextPanelClass.TitleLabel.Text == "Mem" then
                        v.StatsMiniTextPanelClass.ValueLabel.Text = tostring(Memory) .. " MB"
                    end
                end
            end
        end)

        pcall(function()
            if game:GetService("CoreGui").RobloxGui.PerformanceStats["PS_Viewer"].Frame.TextLabel.Text == "Memory" then
                for i, v in pairs(game:GetService("CoreGui").RobloxGui.PerformanceStats["PS_Viewer"].Frame:GetChildren()) do
                    if v.Name == "PS_DecoratedValueLabel" and string.find(v.Label.Text, 'Current') then
                        v.Label.Text = "Current: " .. Memory .. " MB"
                    end
                    if v.Name == "PS_DecoratedValueLabel" and string.find(v.Label.Text, 'Average') then
                        v.Label.Text = "Average: " .. Memory .. " MB"
                    end
                end
            end
        end)

        pcall(function()
            game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.DevConsoleUI.TopBar.LiveStatsModule["MemoryUsage_MB"].Text = math.round(tonumber(Memory)) .. " MB"
        end)
    end)

    task.spawn(function()
        while task.wait(1) do
            local minMemory = getgenv().Forbidden.Memory.Configuration.Start
            local maxMemory = getgenv().Forbidden.Memory.Configuration.End
            Memory = tostring(math.random(minMemory, maxMemory)) .. "." .. tostring(math.random(10, 99))
        end
    end)
end




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera

local Circle = Drawing.new("Circle")
Circle.Color = Color3.new(1, 1, 1)
Circle.Thickness = 1
Circle.Filled = false



local function UpdateFOV()
    if not Circle then return end

    Circle.Visible = Forbidden.CamLock.Normal.Radius_Visibility
    Circle.Radius = Forbidden.CamLock.Normal.Radius
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + game:GetService("GuiService"):GetGuiInset().Y)
end


RunService.RenderStepped:Connect(UpdateFOV)

local function ClosestPlrFromMouse()
    local Target, Closest = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local Position, OnScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if Circle.Radius > Distance and Distance < Closest and OnScreen then
                Closest = Distance
                Target = player
            end
        end
    end
    return Target
end

-- Function to get closest body part of a character
local function GetClosestBodyPart(character)
    local ClosestDistance = math.huge
    local BodyPart = nil

    if character and character:IsDescendantOf(game.Workspace) then
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local Position, OnScreen = Camera:WorldToScreenPoint(part.Position)
                if OnScreen then
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if Circle.Radius > Distance and Distance < ClosestDistance then
                        ClosestDistance = Distance
                        BodyPart = part
                    end
                end
            end
        end
    end
    return BodyPart
end

-- Key event to start/stop targeting
Mouse.KeyDown:Connect(function(Key)
    if Key:lower() == Forbidden.CamLock.Normal.Keybind:lower() then
        if Forbidden.CamLock.Normal.Enabled then
            if Forbidden.CamLock.Normal.mode == "toggle" then
                IsTargeting = not IsTargeting
                if IsTargeting then
                    TargetPlayer = ClosestPlrFromMouse()
                else
                    TargetPlayer = nil
                end
            elseif Forbidden.CamLock.Normal.mode == "hold" then
                IsTargeting = true
                TargetPlayer = ClosestPlrFromMouse()
            end
        end
    end
end)

-- Function to check if the player is aligned with the camera
local function IsAlignedWithCamera(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local cameraPosition = Camera.CFrame.Position
        local direction = (targetPosition - cameraPosition).unit

        local targetDirection = (Camera.CFrame.LookVector).unit

        return direction:Dot(targetDirection) > 0.9 -- Check alignment (cosine similarity)
    end
    return false
end

-- TriggerBot functionality
RunService.RenderStepped:Connect(function()
    if TriggerBotEnabled and IsTargeting and TargetPlayer then
        if IsAlignedWithCamera(TargetPlayer) then
            -- Fire your trigger bot action here
            -- Example: Fire a weapon
            print("TriggerBot activated on: " .. TargetPlayer.Name)
        end
    end
end)

-- CamLock update camera position based on the targeted player
RunService.RenderStepped:Connect(function()
    if IsTargeting and TargetPlayer and TargetPlayer.Character then
        local BodyPart
        if Forbidden.CamLock.Normal.ClosestPart then
            BodyPart = GetClosestBodyPart(TargetPlayer.Character)
        else
            BodyPart = TargetPlayer.Character:FindFirstChild(Forbidden.CamLock.Normal.HitPart)
        end

        if BodyPart then
            local predictedPosition
            if Forbidden['CamLock'].Normal.Resolver then
                local humanoid = TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local moveDirection = humanoid.MoveDirection
                    predictedPosition = BodyPart.Position + (moveDirection * Forbidden['CamLock'].Normal.Prediction)
                end
            else
                local targetVelocity = TargetPlayer.Character.HumanoidRootPart.Velocity
                predictedPosition = BodyPart.Position + (targetVelocity * Forbidden['CamLock'].Normal.Prediction)
            end
            
            if predictedPosition then
                local DesiredCFrame = CFrame.new(Camera.CFrame.Position, predictedPosition)

                if Forbidden.CamLock.Normal.SmoothnessEnabled then
                    Camera.CFrame = Camera.CFrame:Lerp(DesiredCFrame, Forbidden.CamLock.Normal.Smoothness)
                else
                    Camera.CFrame = DesiredCFrame
                end
            end
        end
    end
end)


local G                   = game
local Run_Service         = G:GetService("RunService")
local Players             = G:GetService("Players")
local UserInputService    = G:GetService("UserInputService")
local Local_Player        = Players.LocalPlayer
local Mouse               = Local_Player:GetMouse()
local Current_Camera      = G:GetService("Workspace").CurrentCamera
local Replicated_Storage  = G:GetService("ReplicatedStorage")
local StarterGui          = G:GetService("StarterGui")
local Workspace           = G:GetService("Workspace")

-- // Variables // --
local Target = nil
local V2 = Vector2.new
local Fov = Drawing.new("Circle")
local holdingMouseButton = false
local lastToolUse = 0
local FovParts = {}

-- // Game Load Check // --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- // Game Settings // --
local Games = {
    [2788229376] = {Name = "Da Hood", Argument = "UpdateMousePosI2", Remote = "MainEvent", BodyEffects = "K.O",},
    [16033173781] = {Name = "Da Hood Macro", Argument = "UpdateMousePosI2", Remote = "MainEvent", BodyEffects = "K.O",},
    [7213786345] = {Name = "Da Hood VC", Argument = "UpdateMousePosI", Remote = "MainEvent", BodyEffects = "K.O",},
    [9825515356] = {Name = "Hood Customs", Argument = "GetPing", Remote = "MainEvent"},
    [5602055394] = {Name = "Hood Modded", Argument = "MousePos", Remote = "Bullets"},
    [17403265390] = {Name = "Da Downhill [PS/Xbox]", Argument = "MOUSE", Remote = "MAINEVENT"},
    [132023669786646] = {Name = "Da Bank", Argument = "MOUSE", Remote = "MAINEVENT"},
    [84366677940861] = {Name = "Da Uphill", Argument = "MOUSE", Remote = "MAINEVENT"},
    [14487637618] = {Name = "Da Hood Bot Aim Trainer", Argument = "MOUSE", Remote = "MAINEVENT"},
    [11143225577] = {Name = "1v1 Hood Aim Trainer", Argument = "UpdateMousePos", Remote = "MainEvent"},
    [14413712255] = {Name = "Hood Aim", Argument = "MOUSE", Remote = "MAINEVENT"},
    [14472848239] = {Name = "Moon Hood", Argument = "MoonUpdateMousePos", Remote = "MainEvent"},
    [15186202290] = {Name = "Da Strike", Argument = "MOUSE", Remote = "MAINEVENT"},
    [17319408836] = {Name = "OG Da Hood", Argument = "UpdateMousePos", Remote = "MainEvent", BodyEffects = "K.O",},
    [17780567699] = {Name = "Meko Hood", Argument = "UpdateMousePos", Remote = "MainEvent", BodyEffects = "K.O",},
    [73033159436035] = {Name = "Da Craft", Argument = "UpdateMousePos", Remote = "MainEvent", BodyEffects = "K.O",},
    [139379854239480] = {Name = "Dee Hood", Argument = "UpdateMousePos", Remote = "MainEvent", BodyEffects = "K.O",},
    [85317083713029] = {Name = "Da kitty", Argument = "UpdateMousePos", Remote = "MainEvent", BodyEffects = "K.O",},
}

local gameId = game.PlaceId
local gameSettings = Games[gameId]

if not gameSettings then
    Players.LocalPlayer:Kick("Unsupported game")
    return
end

local RemoteEvent = gameSettings.Remote
local Argument = gameSettings.Argument
local BodyEffects = gameSettings.BodyEffects or "K.O"

-- // Update Detection // --
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local MainEvent           = ReplicatedStorage:FindFirstChild(RemoteEvent)

if not MainEvent then
    Players.LocalPlayer:Kick("Are you sure this is the correct game?")
    return
end

local function isArgumentValid(argumentName)
    return argumentName == Argument
end

local argumentToCheck = Argument

if isArgumentValid(argumentToCheck) then
    MainEvent:FireServer(argumentToCheck) 
else
    Players.LocalPlayer:Kick("stupid monkey")
end

-- // Clear FOV Parts // --
local function clearFovParts()
    for _, part in pairs(FovParts) do
        part:Remove()
    end
    FovParts = {}
end

-- // Update FOV Function // --
local function updateFov()
    local settings = getgenv().Forbidden.Silent.Normal.FovSettings
    clearFovParts()

    -- Only show FOV if targeting is enabled
    if IsTargeting then
        if settings.FovShape == "Square" then
            local halfSize = settings.FovRadius / 2
            local corners = {
                V2(Mouse.X - halfSize, Mouse.Y - halfSize),
                V2(Mouse.X + halfSize, Mouse.Y - halfSize),
                V2(Mouse.X + halfSize, Mouse.Y + halfSize),
                V2(Mouse.X - halfSize, Mouse.Y + halfSize)
            }
            for i = 1, 4 do
                local line = Drawing.new("Line")
                line.Visible = settings.FovVisible
                line.From = corners[i]
                line.To = corners[i % 4 + 1]
                line.Color = settings.FovColor
                line.Thickness = settings.FovThickness
                line.Transparency = settings.FovTransparency
                table.insert(FovParts, line)
            end
        elseif settings.FovShape == "Triangle" then
            local points = {
                V2(Mouse.X, Mouse.Y - settings.FovRadius),
                V2(Mouse.X + settings.FovRadius * math.sin(math.rad(60)), Mouse.Y + settings.FovRadius * math.cos(math.rad(60))),
                V2(Mouse.X - settings.FovRadius * math.sin(math.rad(60)), Mouse.Y + settings.FovRadius * math.cos(math.rad(60)))
            }
            for i = 1, 3 do
                local line = Drawing.new("Line")
                line.Visible = settings.FovVisible
                line.From = points[i]
                line.To = points[i % 3 + 1]
                line.Color = settings.FovColor
                line.Thickness = settings.FovThickness
                line.Transparency = settings.FovTransparency
                table.insert(FovParts, line)
            end
        else  -- Default to Circle
            Fov.Visible = settings.FovVisible
            Fov.Radius = settings.FovRadius
            Fov.Position = V2(Mouse.X, Mouse.Y + (G:GetService("GuiService"):GetGuiInset().Y))
            Fov.Color = settings.FovColor
            Fov.Thickness = settings.FovThickness
            Fov.Transparency = settings.FovTransparency
            Fov.Filled = settings.Filled
            if settings.Filled then
                Fov.Transparency = settings.FillTransparency
            end
        end
    else
        Fov.Visible = false  -- Hide FOV when not targeting
    end
end

-- // Notification Function // --
local function sendNotification(title, text, icon)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = icon,
        Duration = 5
    })
end

-- // Knock Check // --
local function Death(Plr)
    if Plr.Character and Plr.Character:FindFirstChild("BodyEffects") then
        local bodyEffects = Plr.Character.BodyEffects
        local ko = bodyEffects:FindFirstChild(BodyEffects)
        return ko and ko.Value
    end
    return false
end

-- // Grab Check // --
local function Grabbed(Plr)
    return Plr.Character and Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
end

-- // Check if Part in Fov and Visible // --
local function isPartInFovAndVisible(part)
    -- Ensure CamLock is active and there is a target
    if not getgenv().Forbidden.CamLock.Normal.Enabled or not IsTargeting or not TargetPlayer then
        return false
    end

    local screenPoint, onScreen = Current_Camera:WorldToScreenPoint(part.Position)
    local distance = (V2(screenPoint.X, screenPoint.Y) - V2(Mouse.X, Mouse.Y)).Magnitude
    return onScreen and distance <= getgenv().Forbidden.Silent.Normal.FovSettings.FovRadius
end


-- // Check if Part Visible // --
local function isPartVisible(part)
    if not getgenv().Forbidden.Silent.Normal.WallCheck then 
        return true
    end
    local origin = Current_Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local ray = Ray.new(origin, direction)
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {Local_Player.Character, part.Parent})
    return hit == part or not hit
end

-- // Get Closest Hit Point on Part // --
local function GetClosestHitPoint(character)
    local closestPart = nil
    local closestPoint = nil
    local shortestDistance = math.huge

    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and isPartInFovAndVisible(part) and isPartVisible(part) then
            local screenPoint, onScreen = Current_Camera:WorldToScreenPoint(part.Position)
            local distance = (V2(screenPoint.X, screenPoint.Y) - V2(Mouse.X, Mouse.Y)).Magnitude

            if distance < shortestDistance then
                closestPart = part
                closestPoint = part.Position
                shortestDistance = distance
            end
        end
    end

    return closestPart, closestPoint
end

-- // Get Velocity Function // --
local OldPredictionY = getgenv().Forbidden.Silent.Normal.Prediction
local function GetVelocity(player, part)
    if player and player.Character then
        local velocity = player.Character[part].Velocity
        if velocity.Y < -30 and getgenv().Forbidden.Silent.Normal.Resolver then
            getgenv().Forbidden.Silent.Normal.Prediction = 0
            return velocity
        elseif velocity.Magnitude > 50 and getgenv().Forbidden.Silent.Normal.Resolver then
            return player.Character:FindFirstChild("Humanoid").MoveDirection * 16
        else
            getgenv().Forbidden.Silent.Normal.Prediction = OldPredictionY
            return velocity
        end
    end
    return Vector3.new(0, 0, 0)
end

-- // Get Closest Player // --
local function GetClosestPlr()
    local closestTarget = nil
    local maxDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player ~= Local_Player and not Death(player) then  -- KO check using Death function
            local closestPart, closestPoint = GetClosestHitPoint(player.Character)
            if closestPart and closestPoint then
                local screenPoint = Current_Camera:WorldToScreenPoint(closestPoint)
                local distance = (V2(screenPoint.X, screenPoint.Y) - V2(Mouse.X, Mouse.Y)).Magnitude
                if distance < maxDistance then
                    maxDistance = distance
                    closestTarget = player
                end
            end
        end
    end

    -- Automatically deselect target if they are dead or knocked
    if closestTarget and Death(closestTarget) then
        return nil
    end

    return closestTarget
end


-- // Toggle Feature // --
local function toggleFeature()
    getgenv().Forbidden.Silent.Normal.Enabled = not getgenv().Forbidden.Silent.Normal.Enabled
    local status = getgenv().Forbidden.Silent.Normal.Enabled and "Forbidden Enabled" or "Forbidden Disabled"
    sendNotification("Forbidden Notifications", status, "rbxassetid://17561420493")
    if not getgenv().Forbidden.Silent.Normal.Enabled then
        Fov.Visible = false
        clearFovParts()
    end
end

-- // Convert Keybind to KeyCode // --
local function getKeyCodeFromString(key)
    return Enum.KeyCode[key]
end

-- // Keybind Listener // --
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouseButton = true
        local closestPlayer = GetClosestPlayer()

        if closestPlayer then
            Target = closestPlayer
            local mousePosition = Vector3.new(Mouse.X, Mouse.Y, 0)

            local remoteEvent = Replicated_Storage:FindFirstChild(RemoteEvent) -- Find the RemoteEvent
            if remoteEvent then
                -- Ensure Argument is defined before using it
                if Argument then
                    local success, err = pcall(function()
                        remoteEvent:FireServer(Argument, mousePosition)
                    end)
                    if not success then
                        print("Error firing RemoteEvent: ", err) -- Log error without showing in console
                    end
                else
                    print("Argument is nil!") -- Log warning without showing in console
                end
            else
                print("RemoteEvent not found!") -- Log warning without showing in console
            end
        end
    end
end)




UserInputService.InputEnded:Connect(function(input, isProcessed)
    if input.KeyCode == Enum.KeyCode[Forbidden.CamLock.Normal.Keybind:upper()] and Forbidden.CamLock.Normal.mode == "hold" then
        holdingMouseButton = false
        IsTargeting = false  -- Stop targeting when the key is released
        TargetPlayer = nil  -- Clear the target
    end
end)


-- Main Loop
-- Main Loop
Run_Service.RenderStepped:Connect(function()
    if getgenv().Forbidden.Silent.Normal.Enabled and IsTargeting then  -- Only work when CamLock is engaged
        updateFov()  -- Call updateFov to refresh visibility
        Target = GetClosestPlr()  -- Get the closest player instead of using a static Target variable
        
        if Target and Target.Character then
            if Death(Target) then
                -- If the target is dead, un-target
                Target = nil
                IsTargeting = false  -- Stop targeting without notification
                return
            end

            local closestPart, closestPoint = GetClosestHitPoint(Target.Character)
            if closestPart and closestPoint then
                local velocity = GetVelocity(Target, closestPart.Name)
                Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Forbidden.Silent.Normal.Prediction)
            end
        end
    else
        Fov.Visible = false  -- Ensure FOV is hidden if not targeting
    end
end)



-- // Delayed Loop // --
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Forbidden.Silent.Normal.Enabled then
            Target = GetClosestPlr()
            Fov.Visible = IsTargeting and getgenv().Forbidden.Silent.Normal.FovSettings.FovVisible  -- Update visibility based on targeting
        end
    end
end)





-- // Hook Tool Activation // --
local function HookTool(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            if Target and Target.Character and tick() - lastToolUse > 0.1 then  -- Debounce for 0.1 seconds
                lastToolUse = tick()
                local closestPart, closestPoint = GetClosestHitPoint(Target.Character)
                if closestPart and closestPoint then
                    local velocity = GetVelocity(Target, closestPart.Name)
                    Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Forbidden.Silent.Normal.Prediction)
                end
            end
        end)
    end
end

local function onCharacterAdded(character)
    character.ChildAdded:Connect(HookTool)
    for _, tool in pairs(character:GetChildren()) do
        HookTool(tool)
    end
end

Local_Player.CharacterAdded:Connect(onCharacterAdded)
if Local_Player.Character then
    onCharacterAdded(Local_Player.Character)
end

if getgenv().Forbidden.Adjustment.Checks.NoGroundShots == true then
    local function CheckNoGroundShots(Plr)
        if getgenv().Forbidden.Adjustment.Checks.NoGroundShots and Plr.Character:FindFirstChild("Humanoid") and Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            pcall(function()
                local TargetVelv5 = Plr.Character:FindFirstChild(getgenv().Forbidden.Silent.Normal and getgenv().Forbidden.Silent.Normal)
                if TargetVelv5 then
                    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.2), TargetVelv5.Velocity.Z)
                    TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.2), TargetVelv5.Velocity.Z)
                end
            end)
        end
    end
end
