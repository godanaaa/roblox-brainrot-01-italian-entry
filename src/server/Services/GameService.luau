local D=require(script.Parent.DataService)
local Base=require(script.Parent.BaseService)
local C=require(game.ReplicatedStorage.Modules.Config)
local Game={}
function Game.Init(remotes)
 for _,obj in ipairs(workspace:GetDescendants()) do
  if obj:IsA("ProximityPrompt") and obj.Parent:GetAttribute("TravelTarget") then
   obj.Triggered:Connect(function(p)local target=obj.Parent:GetAttribute("TravelTarget");if not p.Character then return end;if target=="Market" then p.Character:PivotTo(CFrame.new(0,12,300)) else p.Character:PivotTo(CFrame.new(0,12,0)) end end)
  elseif obj:IsA("ProximityPrompt") and obj.Parent:GetAttribute("ZoneName") then
   obj.Triggered:Connect(function(p)local name=obj.Parent:GetAttribute("ZoneName");local d=D.Get(p);if not d then return end;for _,z in ipairs(C.Zones)do if z.Name==name then if d.Cash<z.Requirement or d.BaseLevel<(z.Level or 1) or d.Rebirths<(z.Rebirths or 0) then remotes.Notify:FireClient(p,"LOCKED • Requires $"..z.Requirement..", Base Lv "..z.Level..", Rebirth "..z.Rebirths,"LOCKED");return end;d.UnlockedZones[name]=true;if p.Character then p.Character:PivotTo(CFrame.new(z.Position+Vector3.new(0,8,0)))end end end end)
  end
 end
 remotes.Play.OnServerInvoke=function(p)if not D.Get(p)then D.Load(p)end;if not Base.Get(p)then Base.Claim(p)end;if not p.Character then p:LoadCharacter()end;task.wait(.2);if p.Character then p.Character:PivotTo(CFrame.new(0,8,0))end;return true end
end
return Game
