local CGUI = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Client = game:GetService("Players").LocalPlayer

local version = "1.0b1"
local base64encode = (syn and syn.crypt.base64.encode) or crypt.base64encode

local InterfaceName = base64encode(tostring(Client.Name))
local Interface = game:GetObjects("rbxassetid://14193090516")[1]

Interface.Name = InterfaceName

if gethui() then 
    for i, v in ipairs(gethui():GetChildren()) do 
        if v.Name == InterfaceName then
            v:Destroy()
        end
    end

    Interface.Parent = gethui()
elseif syn.protect_gui then
    for i, v in ipairs(CGUI:GetChildren()) do 
        if v.Name == InterfaceName then
            v:Destroy()
        end
    end

    Interface.Parent = CGUI
    syn.protect_gui(Interface)
else
    for i, v in ipairs(CGUI:GetChildren()) do 
        if v.Name == InterfaceName then
            v:Destroy()
        end
    end

    Interface.Parent = CGUI
end

local InterfaceManager = {}

function InterfaceManager:Begin(title: string) 
    local Window = Interface:WaitForChild("Window")
    local Title = Window:WaitForChild("Container"):WaitForChild("Title")
    local Templates = Window:WaitForChild("Container"):WaitForChild("Components"):WaitForChild("Templates")

    Title.Text = title

    Title:WaitForChild("Close").MouseEnter:Connect(function()
        TS:Create(Title:WaitForChild("Close"), TweenInfo.new(.2), {ImageColor3=Color3.fromRGB(67, 67, 67)}):Play()
    end)

    Title:WaitForChild("Close").MouseLeave:Connect(function()
        TS:Create(Title:WaitForChild("Close"), TweenInfo.new(.2), {ImageColor3=Color3.fromRGB(44, 44, 44)}):Play()
    end)

    Title:WaitForChild("Close").MouseButton1Click:Connect(function()
        if gethui() then 
            for i, v in ipairs(gethui():GetChildren()) do 
                if v.Name == InterfaceName then
                    v:Destroy()
                end
            end
        elseif syn.unprotect_gui then
            for i, v in ipairs(CGUI:GetChildren()) do 
                if v.Name == InterfaceName then
                    syn.unprotect_gui(v)
                    v:Destroy()
                end
            end
        else
            for i, v in ipairs(CGUI:GetChildren()) do 
                if v.Name == InterfaceName then
                    v:Destroy()
                end
            end
        end
    end)

    local ComponentHandler = {}
    local Components = {}

    function ComponentHandler:set(name: string, v: any) 
        for i, v in ipairs(Components) do 
            if v.Name == name then
                v.Value = v
                v.update()
            end
        end
    end

    function ComponentHandler:get(name: string) 
        for i, v in ipairs(Components) do 
            if v.Name == name then
                return v.Value
            end
        end
    end

    function ComponentHandler:CreateBoolean(options: table) 
        options = options or {
            Name = options.Name,
            Value = options.Value,
            OnChanged = options.OnChanged
        }

        local booleanDebounce = false
        local booleanComp = Templates:WaitForChild("Boolean"):Clone()
        booleanComp.Parent = Window:WaitForChild("Container"):WaitForChild("Components")
        booleanComp.Visible = true
        booleanComp:WaitForChild("Name").Text = options.Name

        options.update = function()
            if options.Value then
                TS:Create(booleanComp:WaitForChild("Display"), TweenInfo.new(.2, Enum.EasingStyle.Linear), {BackgroundColor3=Color3.fromRGB(60, 63, 65)}):Play()
                TS:Create(booleanComp:WaitForChild("Display")
                    :WaitForChild("State"), TweenInfo.new(.2, Enum.EasingStyle.Cubic), {BackgroundColor3=Color3.fromRGB(119, 126, 130),Position=UDim2.new(1,-18,0.5,0)}):Play()
            else
                TS:Create(booleanComp:WaitForChild("Display"), TweenInfo.new(.2, Enum.EasingStyle.Linear), {BackgroundColor3=Color3.fromRGB(25, 26, 27)}):Play()
                TS:Create(booleanComp:WaitForChild("Display")
                    :WaitForChild("State"), TweenInfo.new(.2, Enum.EasingStyle.Cubic), {BackgroundColor3=Color3.fromRGB(77, 81, 84),Position=UDim2.new(0,4,0.5,0)}):Play()
            end
        end

        booleanComp:WaitForChild("Display"):WaitForChild("OnMouse").MouseButton1Click:Connect(function()
            if not booleanDebounce then
                booleanDebounce = true

                options.Value = not options.Value
                options.update()
                
                local suc, req = pcall(options.OnChanged, options.Value)
                if req then
                    error("Lea Callback Error: " .. req)
                end

                task.wait(.2)
                booleanDebounce = false
            end
        end)

        table.insert(Components, options)
    end

    function ComponentHandler:CreateButton(options: table) 
        options = options or {
            Name = options.Name,
            OnClick = options.OnClick
        }

        local buttonDebounce = false
        local buttonComponent = Templates:WaitForChild("Button"):Clone()
        buttonComponent.Parent = Window:WaitForChild("Container"):WaitForChild("Components")
        buttonComponent.Visible = true
        buttonComponent:WaitForChild("Name").Text = options.Name
        buttonComponent:WaitForChild("Name").ZIndex = 2
        buttonComponent.ClipsDescendants = true

        local function update(x, y) 
            local clickEffect = Instance.new("Frame", buttonComponent)
            clickEffect.BackgroundTransparency = 0
            clickEffect.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
            clickEffect.Size = UDim2.new(0, 10, 0, 10)
            clickEffect.AnchorPoint = Vector2.new(0.5, 0.5)
            clickEffect.Position = UDim2.new(0, x - buttonComponent.AbsolutePosition.X, 0.5, 0)
            clickEffect.ZIndex = 1
            clickEffect.Visible = true
        
            local clickEffectRadius = Instance.new("UICorner", clickEffect)
            clickEffectRadius.CornerRadius = UDim.new(1, 0)
        
            local tweenInfo = TweenInfo.new(1)
            local tween = TS:Create(clickEffect, tweenInfo, {BackgroundTransparency = 1, Size = UDim2.new(0, 100, 0, 100)})
            tween:Play()
        
            tween.Completed:Connect(function()
                clickEffect:Destroy()
            end)
        end

        buttonComponent:WaitForChild("OnMouse").MouseButton1Down:Connect(function(x, y)
            if not buttonDebounce then
                buttonDebounce = true
                local suc, req = pcall(options.OnClick)
                if req then
                    error("Lea Callback Error: " .. req)
                end
                local mpos = UIS:GetMouseLocation()
                update(mpos.X, mpos.Y)
                task.wait(.1)
                buttonDebounce = false
            end
        end)

    end

    function ComponentHandler:CreateSlider(options: table) 
        options = options or {
            Name = options.Name,        --> string
            Value = options.Value,      --> number
            Range = options.Range,      --> table: {min, max}
            OnChanged = options.OnChanged   --> function: -> value
        }

        local sliderDragging = false
        local sliderComponent = Templates:WaitForChild("Slider"):Clone()
        sliderComponent.Parent = Window:WaitForChild("Container"):WaitForChild("Components")
        sliderComponent.Visible = true
        sliderComponent:WaitForChild("Name").Text = options.Name

        local context = sliderComponent:WaitForChild("Context")
        context.AnchorPoint = Vector2.new(0.5, 0)

        local parentFrame = sliderComponent:WaitForChild("ParentFrame")
        local sliderFill = parentFrame:WaitForChild("FillFrame")
        
        local function updateContext(display: string, moving: boolean, x_position: number) 
            if moving then
                context:WaitForChild("Name").Text = display
                context.Size = UDim2.new(0,context:WaitForChild("Name").TextBounds.X + 10, 0, 20)
                TS:Create(context, TweenInfo.new(.2), {Position=UDim2.new(0,x_position-parentFrame.AbsolutePosition.X, 0.2, 0)}):Play()
            end
        end

        local function showContext(show: boolean) 
            TS:Create(context, TweenInfo.new(.2),{BackgroundTransparency=(show and 0.5 or 1)}):Play()
            TS:Create(context:WaitForChild("UIStroke"), TweenInfo.new(.2),{Transparency=(show and 0 or 1)}):Play()
            TS:Create(context:WaitForChild("Name"), TweenInfo.new(.2),{TextTransparency=(show and 0 or 1)}):Play()
        end

        local function updateSliderValue(value: number) 
            local range = options.Range or {0, 1}
            local min, max = range[1], range[2]
            value = math.clamp(value, min, max)
            local percentage = (value - min) / (max - min)

            local tweenInfo = TweenInfo.new(0.2)
            TS:Create(sliderFill, tweenInfo, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()

            if options.OnChanged then
                local suc, req = pcall(options.OnChanged, value)
                if req then
                    error("Lea Callback Error: " .. req)
                end
            end
        end

        parentFrame:WaitForChild("OnMouse").MouseButton1Down:Connect(function()
            if not sliderDragging then
                sliderDragging = true
                showContext(true)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input.UserInputType.Name == "MouseMovement" and sliderDragging then
                local mousepos = input.Position.X
                local left = parentFrame.AbsolutePosition.X
                local right = left + parentFrame.AbsoluteSize.X
                mousepos = math.clamp(mousepos, left, right)
                local new = (mousepos - left) / (right - left) * (options.Range[2] - options.Range[1]) + options.Range[1]

                updateSliderValue(new)
                updateContext(string.format("%.0f",new), true, mousepos)
            end
        end)

        UIS.InputBegan:Connect(function(input)
            if input.UserInputType.Name == "MouseButton1" and sliderDragging then
                local mousepos = input.Position.X
                local left = parentFrame.AbsolutePosition.X
                local right = left + parentFrame.AbsoluteSize.X
                mousepos = math.clamp(mousepos, left, right)
                local new = (mousepos - left) / (right - left) * (options.Range[2] - options.Range[1]) + options.Range[1]
                
                updateSliderValue(new)
                updateContext(string.format("%.0f",new), true, mousepos)
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType.Name == "MouseButton1" and sliderDragging then
                sliderDragging = false
                showContext(false)
            end
        end)

        table.insert(Components, options)
    end

    task.defer(function()
        local windowDragging = false
        local windowInput = nil
        local windowStart = nil
        local startPos = nil

        local function update(input) 
            local delta = input.Position - windowStart
            local new = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

            TS:Create(Window, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=new}):Play()
        end

        Title.InputBegan:Connect(function(input)
            if input.UserInputType.Name == "MouseButton1" and not windowDragging then
                windowDragging = true
                windowStart = input.Position
                startPos = Window.Position

                input.Changed:Connect(function()
                    if input.UserInputState.Name == "End" then
                        windowDragging = false
                    end
                end)
            end
        end)

        Title.InputChanged:Connect(function(input)
            if input == windowInput and windowDragging then
                update(input)
            end
        end)
    end)

    return ComponentHandler
end

return InterfaceManager
