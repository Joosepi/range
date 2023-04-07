-- Define the desired field of view (FOV) value
local fovValue = 45

-- Define the player's team
local player = game:GetService("Players").LocalPlayer
local playerTeam = player.TeamColor

-- Set the FOV of the player's camera
game:GetService("Workspace").CurrentCamera.FieldOfView = fovValue

-- Define the function to predict hits
function PredictHits(opponent)
    -- Check if the opponent is on the opposite team
    if opponent.TeamColor ~= playerTeam then
        -- Get the opponent's character model and R6 body parts
        local opponentChar = opponent.Character
        local head = opponentChar and opponentChar:FindFirstChild("Head")
        local torso = opponentChar and opponentChar:FindFirstChild("Torso")
        -- Check if the opponent has an R6 character model and is within the FOV
        if head and torso then
            local camera = game:GetService("Workspace").CurrentCamera
            local headScreenPos, headOnScreen = camera:WorldToScreenPoint(head.Position)
            local torsoScreenPos, torsoOnScreen = camera:WorldToScreenPoint(torso.Position)
            if headOnScreen and headScreenPos.Z > 0 and torsoOnScreen and torsoScreenPos.Z > 0 then
                local fov = math.rad(camera.FieldOfView)
                local screenSize = Vector2.new(game:GetService("GuiService"):GetScreenResolution())
                local screenCenter = screenSize / 2
                local headScreenDiff = headScreenPos - screenCenter
                local torsoScreenDiff = torsoScreenPos - screenCenter
                local fovRatio = math.tan(fov / 2) / (screenSize.x / 2)
                if headScreenDiff.magnitude <= fovRatio * screenCenter.magnitude and torsoScreenDiff.magnitude <= fovRatio * screenCenter.magnitude then
                    -- Increase the prediction chances of hitting the opponent
                    return true, 1.5 -- increased prediction chance by 50%
                end
            end
        end
    end
    return false, 1 -- default prediction chance
end

-- Example usage
while true do
    local opponents = game:GetService("Players"):GetPlayers()
    for _, opponent in ipairs(opponents) do
        if opponent ~= player and opponent.Character and opponent.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            local isOpponentInFov, predictionChanger = PredictHits(opponent)
            if isOpponentInFov then
                print("Opponent is in FOV and on opposite team! Increase prediction chances by " .. (predictionChanger - 1) * 100 .. "%!")
            end
        end
    end
    wait(1)
end
