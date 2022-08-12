--[[
    Etomi developed by BrownZombie and nate.
]]--

local modes = {
    Silent = 0,
    Camera = 1,
    Mouse = 2
}

local settings = {
    -- init local settings
    lock = {
        enabled = false,
        visibleonly = false,
        part = "HumanoidRootPart",
        mode = modes["Silent"],
        predict = false,
        prediction = 0.1337
    },
    fakemacro = {
        enabled = false,
        speed = 10
    },
    autorob = {
        placeholder = false
        -- TODO: add auto rob features
    }
}

-- set global settings
getgenv().settings = settings

function getServices()
    return game:GetService("Workspace"), game:GetService("ReplicatedStorage"), game:GetService("Players"), game:GetService("Players").LocalPlayer, game:GetService("Workspace").CurrentCamera, game:GetService("UserInputService")
end

local workspace, repl, players, localplayer, camera, uis = getServices()
local mouse = localplayer:GetMouse()
local target

function closestPlayer()
    local closest
    local dist = math.huge
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localplayer and
        player.Character and
        player.Character:FindFirstChild("Humanoid") and
        player.Character:FindFirstChild(getgenv().settings.lock.part) then
            local cameravector = camera:WorldToViewportPoint(player.Character.PrimaryPart.Position)
            local distance = (Vector2.new(cameravector.X, cameravector.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
            if distance < dist then
                dist = distance
                closest = player
            end
        end
    end
    return closest
end

local oldindex
oldindex = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local args = {...}
    if not checkcaller() and 
    settings.lock.enabled and 
    getnamecallmethod() == "FireServer" and
    args[2] == "UpdateMousePos" then
        -- Change third argument mousepos to target position
        print("awreasome")
        args[3] = target.Character[getgenv().settings.lock.part].Position + 0.053 + target.Character[getgenv().settings.lock.part].Velocity * getgenv().settings.lock.prediction
    end
    return oldindex(unpack(args))
end))

-- main()

uis.InputBegan:Connect(function(input, processed) 
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.C then
            if getgenv().settings.lock.enabled then
                target = closestPlayer()
            else
                target = nil
            end
            print(target)
            getgenv().settings.lock.enabled = not getgenv().settings.lock.enabled
        end
    end
end)

-- gui
function createGUI()
    -- TODO: orion library code here

end

-- hooks
