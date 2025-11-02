-- XModded Premium GUI (LocalScript para executor)
-- Cole em um executor de Roblox (Synapse, KRNL, etc.)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 5)
local savedCFrame = nil

-- Helper para criar instâncias com propriedades
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k ~= "Parent" then obj[k] = v end
        end
        if props.Parent then obj.Parent = props.Parent end
    end
    return obj
end

-- Destroy any existing gui named XModdedPremium (para evitar duplicatas)
if player:FindFirstChild("PlayerGui") then
    local existing = player.PlayerGui:FindFirstChild("XModdedPremiumGui")
    if existing then existing:Destroy() end
end

-- ScreenGui
local screenGui = new("ScreenGui", {Name = "XModdedPremiumGui", ResetOnSpawn = false})
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Loading screen
local loadingFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(1,0,1,0),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BorderSizePixel = 0
})

local titleLabel = new("TextLabel", {
    Parent = loadingFrame,
    Size = UDim2.new(0.5,0,0,40),
    Position = UDim2.new(0.5, -150, 0, 20),
    BackgroundTransparency = 1,
    Text = "XModded Premium",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextStrokeTransparency = 0.6,
    TextXAlignment = Enum.TextXAlignment.Center
})

-- efeito RGB lento (vai mudando o TextColor3 com o tempo)
spawn(function()
    while loadingFrame.Parent do
        local hue = (tick() % 8) / 8 -- ciclo de 8s
        titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        wait(0.03)
    end
end)

local progressOuter = new("Frame", {
    Parent = loadingFrame,
    Size = UDim2.new(0.6,0,0,28),
    Position = UDim2.new(0.5, -180, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    BorderSizePixel = 0
})
local progressFill = new("Frame", {
    Parent = progressOuter,
    Size = UDim2.new(0,0,1,0),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.fromRGB(0,170,255),
    BorderSizePixel = 0
})
local progressText = new("TextLabel", {
    Parent = progressOuter,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "0%",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(240,240,240)
})

local skipButton = new("TextButton", {
    Parent = loadingFrame,
    Size = UDim2.new(0,80,0,30),
    Position = UDim2.new(0.5, 110, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(60,60,60),
    Text = "SKIP",
    Font = Enum.Font.GothamBold,
    TextSize = 14
})

local loading = true
local progress = 0

-- Função para atualizar UI do progresso
local function setProgress(p)
    progress = math.clamp(p, 0, 100)
    progressFill:TweenSize(UDim2.new(progress/100,0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    progressText.Text = string.format("%d%%", math.floor(progress))
end

-- Skip
skipButton.MouseButton1Click:Connect(function()
    loading = false
    setProgress(100)
end)

-- Simula carregamento 0 -> 100 (pode ser pulado por 'skip')
spawn(function()
    while loading and progress < 100 do
        wait(0.03 + math.random()*0.02) -- variação para parecer natural
        local inc = 0.5 + math.random()*1.2
        setProgress(progress + inc)
    end
    setProgress(100)
    wait(0.2)
    -- inicia a interface principal
    loadingFrame:Destroy()
    -- cria a GUI principal
    -- (feito abaixo)
end)

-- Função para criar a interface principal (sera chamada após o loading)
local function createMainGui()
    local main = new("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0,420,0,140),
        Position = UDim2.new(0.5, -210, 0.15, 0),
        BackgroundColor3 = Color3.fromRGB(18,18,18),
        BorderSizePixel = 0,
        Name = "MainFrame"
    })
    local uic = new("UICorner", {Parent = main, CornerRadius = UDim.new(0,12)})

    local header = new("TextLabel", {
        Parent = main,
        Size = UDim2.new(1,0,0,36),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text = "XModded Premium",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextColor3 = Color3.fromRGB(255,255,255),
        Padding = nil
    })
    header.Position = UDim2.new(0,12,0,0)

    -- Efeito RGB lento no header (texto)
    spawn(function()
        while main.Parent do
            local hue = (tick() % 10) / 10 -- ciclo de 10s
            header.TextColor3 = Color3.fromHSV(hue, 1, 1)
            wait(0.02)
        end
    end)

    -- Subtitulo informativo
    local subtitle = new("TextLabel", {
        Parent = main,
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0,12,0,36),
        BackgroundTransparency = 1,
        Text = "RGB lento  •  By XModded",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(180,180,180)
    })

    -- Botões
    local saveBtn = new("TextButton", {
        Parent = main,
        Size = UDim2.new(0,140,0,36),
        Position = UDim2.new(0,12,0,64),
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        Text = "Salvar posição",
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })
    new("UICorner", {Parent = saveBtn, CornerRadius = UDim.new(0,8)})

    local instantBtn = new("TextButton", {
        Parent = main,
        Size = UDim2.new(0,140,0,36),
        Position = UDim2.new(0,164,0,64),
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        Text = "Instant Steal",
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })
    new("UICorner", {Parent = instantBtn, CornerRadius = UDim.new(0,8)})

    local infoLabel = new("TextLabel", {
        Parent = main,
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0,12,0,108),
        BackgroundTransparency = 1,
        Text = "Nenhuma posição salva.",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(200,200,200)
    })

    -- Função de confirmação visual (pequeno efeito)
    local function flashInfo(msg)
        infoLabel.Text = msg
        -- fade out menssagem depois de 2s
        spawn(function()
            wait(2.2)
            if infoLabel and infoLabel.Parent then
                infoLabel.Text = tostring(savedCFrame and "Posição salva." or "Nenhuma posição salva.")
            end
        end)
    end

    -- Salvar posição
    saveBtn.MouseButton1Click:Connect(function()
        char = player.Character or player.CharacterAdded:Wait()
        hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
        if hrp then
            savedCFrame = hrp.CFrame
            flashInfo("Posição salva.")
        else
            flashInfo("Erro: HumanoidRootPart não encontrado.")
        end
    end)

    -- Instant Steal (teleporte/voo rápido)
    instantBtn.MouseButton1Click:Connect(function()
        if not savedCFrame then
            flashInfo("Nenhuma posição salva para ir.")
            return
        end

        char = player.Character or player.CharacterAdded:Wait()
        hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if not hrp or not humanoid then
            flashInfo("Erro: personagem não pronto.")
            return
        end

        -- Desativa scripts de movimento do personagem temporariamente para evitar conflitos
        local originalPlatformStand = humanoid.PlatformStand
        humanoid.PlatformStand = true

        -- Cria tween para "voar" até a posição salva
        local distance = (hrp.Position - savedCFrame.Position).Magnitude
        local time = math.clamp(distance / 150, 0.12, 0.9) -- velocidade ajustada (maior = mais devagar)
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local goal = {CFrame = savedCFrame * CFrame.new(0, 3, 0)} -- sobe 3 studs antes de pousar

        local success, err = pcall(function()
            TweenService:Create(hrp, tweenInfo, goal):Play()
        end)
        -- caso tween não funcione (alguns servers bloqueiam), fallback para set CFrame direto
        if not success then
            hrp.CFrame = savedCFrame + Vector3.new(0,3,0)
        end

        -- espera o tempo do tween e depois reativa controles
        spawn(function()
            wait(time + 0.08)
            if humanoid and humanoid.Parent then
                humanoid.PlatformStand = originalPlatformStand
            end
            flashInfo("Chegou na posição salva.")
        end)
    end)

    -- Drag para mover a janela
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = UDim2.new(0, (dragInput.Position.X - dragStart.X), 0, (dragInput.Position.Y - dragStart.Y))
            main.Position = startPos + delta
        end
    end)
end

-- Observa o PlayerGui para criar a main gui após o loading terminar
spawn(function()
    while screenGui.Parent and not screenGui:FindFirstChild("MainFrame") do
        if not loading and not player.PlayerGui:FindFirstChild("XModdedPremiumGui"):FindFirstChildWhichIsA("Frame") then
            -- createMainGui() será chamada depois que o loadingFrame for destruído
            createMainGui()
            break
        end
        wait(0.1)
    end
end)

-- Caso o loadingFrame seja destruído pelo loop de loading, criamos a main GUI
loadingFrame.AncestryChanged:Connect(function(_, parent)
    if not parent then
        -- small delay para garantir que a tela sumiu
        wait(0.05)
        if screenGui and screenGui.Parent then
            -- evita duplicatas
            if not screenGui:FindFirstChild("MainFrame") then
                createMainGui()
            end
        end
    end
end)
