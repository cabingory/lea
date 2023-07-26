local lea = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/petxmr/lea/main/source.lua"))()
local window = lea:Begin("Hello, world!")

local boolean = window:CreateBoolean({
    Name = "Boolean",
    Value = false,
    OnChanged = function(v) 
        print(v)
    end
})

local button = window:CreateButton({
    Name = "Button",
    OnClick = function() 
        window:set("Boolean", not window:get("Boolean"))
    end
})

local slider = window:CreateSlider({
    Name = "Slider"
    Value = 16
    Range = {16, 300}
    OnChanged = function(v) 
        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = v
    end
})
