local D=require(script.Parent.DataService)
local Base=require(script.Parent.BaseService)
local C=require(game.ReplicatedStorage.Modules.Config)
local Game={}
function Game.Init(remotes)
 local function connectTravel(prompt,target)
  prompt.Triggered:Connect(function(player)
   local destination=target
   if destination=="City" then destination="Starter City" end
   local callback=remotes.Travel and remotes.Travel.OnServerInvoke
   if not callback then
    warn("[IBW] Travel prompt has no authoritative handler for "..tostring(destination))
    remotes.Notify:FireClient(player,"TRAVEL FAILED • Travel service is not ready. Try again.","LOCKED")
    return
   end
   local ok,result=pcall(callback,player,destination)
   if not ok then
    warn("[IBW] Travel prompt failed for "..player.Name.." to "..tostring(destination)..": "..tostring(result))
    remotes.Notify:FireClient(player,"TRAVEL FAILED • The destination could not be reached. Try again.","LOCKED")
   end
  end)
 end
 for _,obj in ipairs(workspace:GetDescendants()) do
  if obj:IsA("ProximityPrompt") then
   local target=obj.Parent:GetAttribute("ZoneName") or obj.Parent:GetAttribute("TravelTarget")
   if target then connectTravel(obj,target) end
  end
 end
 -- Play is installed once by init.server after every service is loaded, so the
 -- guarded handler remains authoritative and always targets the central plaza.
end
return Game
