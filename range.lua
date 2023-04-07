-- Define the regular range value
local regularRange = 20

-- Define a global variable to indicate whether the regular range is enabled or not
local regularRangeEnabled = true

-- Define the function to double the range when a player is close to someone
function DoubleRangeOnClose(player, range)
   local nearbyPlayers = game:GetService("Players"):GetPlayers()
   for _, otherPlayer in ipairs(nearbyPlayers) do
      if otherPlayer ~= player and (otherPlayer.Character and player.Character) then
         local distance = (otherPlayer.Character.Torso.Position - player.Character.Torso.Position).magnitude
         if distance < range then
            return range * 2
         end
      end
   end
   return range
end

-- Define the keybind for enabling/disabling the regular range
local toggleRegularRangeKey = Enum.KeyCode.j

-- Define the function to handle the keybind event
function OnKeyPressed(inputObject, gameProcessedEvent)
   if not gameProcessedEvent and inputObject.KeyCode == toggleRegularRangeKey then
      regularRangeEnabled = not regularRangeEnabled
   end
end

-- Connect the key press event to the function
game:GetService("UserInputService").InputBegan:Connect(OnKeyPressed)

-- Example usage
while true do
   local player = game.Players.LocalPlayer
   local range = regularRangeEnabled and DoubleRangeOnClose(player, regularRange) or regularRange
   print("Range:", range)
   wait(1)
end
