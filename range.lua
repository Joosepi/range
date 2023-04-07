-- Define the regular range value
local regularRange = 10

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

-- Example usage
while true do
   local player = game.Players.LocalPlayer
   local range = DoubleRangeOnClose(player, regularRange)
   print("Range:", range)
   wait(1)
end
