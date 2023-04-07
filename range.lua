-- Define the desired field of view (FOV) value
local fovValue = 100

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
        local upperTorso = opponentChar and opponentChar:FindFirstChild("UpperTorso")
        -- Check if the opponent has an R6 character model and is within the FOV
        if upperTorso then
            local camera = game:GetService("Workspace").CurrentCamera
            local screenPos, onScreen = camera:WorldToScreenPoint(upperTorso.Position)
            if onScreen and screenPos.Z > 0 then
                local fov = math.rad(camera.FieldOfView)
                local screenSize = Vector2.new(game:GetService("GuiService"):GetScreenResolution())
                local screenCenter = screenSize / 2
                local screenDiff = screenPos - screenCenter
                local fovRatio = math.tan(fov / 2) / (screenSize.x / 2)
                if screenDiff.magnitude <= fovRatio * screenCenter.magnitude then
                    -- Calculate the prediction chance of hitting the opponent based on the screen difference
                    local predictionChance = 1 - (screenDiff.magnitude / (fovRatio * screenCenter.magnitude))
                    return predictionChance
                end
            end
        end
    end
    return 0
end

-- Example usage
while true do
    local opponents = game:GetService("Players"):GetPlayers()
    for _, opponent in ipairs(opponents) do
        if opponent ~= player and opponent.Character and opponent.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            local predictionChance = PredictHits(opponent)
            if predictionChance > 0 then
                print(string.format("Opponent is in FOV and on opposite team! Prediction chance: %.2f%%", predictionChance * 100))
            end
        end
    end
    wait(1)
end
