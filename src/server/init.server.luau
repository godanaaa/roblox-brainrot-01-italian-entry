local function safeRequire(moduleScript,label)
 local ok,value=pcall(require,moduleScript)
 if not ok then warn("[IBW] require failed for "..label..": "..tostring(value));return nil end
 return value
end
local function safeInit(label,callback)
 local ok,err=pcall(callback)
 if not ok then warn("[IBW] Init '"..label.."' failed at part/line: "..tostring(err)) else warn("[IBW] Init '"..label.."' completed") end
 return ok
end
local Remotes=safeRequire(game.ReplicatedStorage.Modules.Remotes,"Remotes")
local Services=script:WaitForChild("Services")
local Data=safeRequire(Services.DataService,"DataService") or {Get=function() return nil end,Load=function() return nil end,Save=function() end,Remove=function() end}
local Base
-- Install Play before loading other services, building the map, or initializing anything.
if Remotes then
 Remotes.Play.OnServerInvoke=function(p)
  local dataOk,dataErr=pcall(function() if not Data.Get(p) then Data.Load(p) end end)
  if not dataOk then warn("[IBW] Play data initialization failed for "..p.Name..": "..tostring(dataErr)) end
  if Base then local ok,err=pcall(function() if not Base.Get(p) then Base.Claim(p) end end);if not ok then warn("[IBW] Play Base.Claim failed for "..p.Name..": "..tostring(err)) end end
  if not p.Character then local ok,err=pcall(function() p:LoadCharacter() end);if not ok then warn("[IBW] Play LoadCharacter failed for "..p.Name..": "..tostring(err)) end end
  task.wait(.2)
  if p.Character then local ok,err=pcall(function() p.Character:PivotTo(CFrame.new(0,8,0)) end);if not ok then warn("[IBW] Play plaza spawn failed for "..p.Name..": "..tostring(err)) end end
  return true
 end
end
local Config=safeRequire(game.ReplicatedStorage.Modules.Config,"Config") or {Catalogue={},Upgrades={},Zones={}}
Base=safeRequire(Services.BaseService,"BaseService") or {Init=function() end,Claim=function() end,Get=function() end,Release=function() end}
local Game=safeRequire(Services.GameService,"GameService")
local Map=safeRequire(Services.MapBuilder,"MapBuilder")
local Shop=safeRequire(Services.ShopService,"ShopService")
local Coin=safeRequire(Services.CoinService,"CoinService") or {Add=function() end}
local Quest=safeRequire(Services.QuestService,"QuestService")
local Rebirth=safeRequire(Services.RebirthService,"RebirthService")
local Events=safeRequire(Services.EventService,"EventService")
local Leaderboard=safeRequire(Services.LeaderboardService,"LeaderboardService")
local Vehicle=safeRequire(Services.VehicleService,"VehicleService")
local Premium=safeRequire(Services.PremiumService,"PremiumService")
if Map then safeInit("Map.Build",function() Map.Build() end) end
safeInit("Base.Init",function()
 Base.Init()
 for _,p in ipairs(game.Players:GetPlayers()) do
  if not Data.Get(p) then Data.Load(p) end
  Base.Claim(p)
 end
end)
if Shop and Remotes then safeInit("Shop.Init",function() Shop.Init(Remotes) end) end
if Game and Remotes then safeInit("Game.Init",function() Game.Init(Remotes) end) end
if Vehicle and Remotes then safeInit("Vehicle.Init",function() Vehicle.Init(Remotes) end) end
if Premium and Remotes then safeInit("Premium.Init",function() Premium.Init(Remotes) end) end
if Events and Remotes then safeInit("Events.Init",function() Events.Init(Remotes) end) end
if Leaderboard then safeInit("Leaderboard.Init",function() Leaderboard.Init() end) end
local function state(p) local d=Data.Get(p);if not d then return end;local income=0;local ownedIds={};for _,id in ipairs(d.Owned) do local e=Config.Catalogue[id];if e then income+=e.Income;ownedIds[id]=true end end;local discovered=0;for _ in pairs(ownedIds)do discovered+=1 end;local boost=d.GemUpgrades and d.GemUpgrades.DoubleIncome and 2 or 1;return {Cash=d.Cash,Gems=d.Gems,Level=d.Level,XP=d.XP,Rebirths=d.Rebirths,BaseLevel=d.BaseLevel,Owned=#d.Owned,DiscoveredCount=discovered,OwnedIds=ownedIds,Quests=d.Quests,TotalEarned=d.TotalEarned,Vehicles=d.Vehicles,GemUpgrades=d.GemUpgrades,UnlockedZones=d.UnlockedZones,Income=income*(1+d.Rebirths*.25)*boost} end
if Remotes then
Remotes.UpgradeBase.OnServerInvoke=function(p) local d=Data.Get(p);if not d or d.BaseLevel>=6 then return false end;local nextL=d.BaseLevel+1;local cost=Config.Upgrades[nextL].Cost;if d.Cash<cost then return false end;d.Cash-=cost;d.BaseLevel=nextL;local plot=Base.Get(p);if plot then Base.Rebuild(plot,nextL,p) end;return true end
Remotes.Collect.OnServerInvoke=function(p) local d=Data.Get(p);if not d then return 0 end;local total=0;for _,id in ipairs(d.Owned) do local e=Config.Catalogue[id];if e then total+=e.Income end end;local boost=d.GemUpgrades and d.GemUpgrades.DoubleIncome and 2 or 1;total=math.floor(total*(1+d.Rebirths*.25)*boost);Coin.Add(p,total*5);return total*5 end
Remotes.Rebirth.OnServerInvoke=Rebirth.Try;Remotes.QuestClaim.OnServerInvoke=Quest.Claim;Remotes.BuyBrainrot.OnServerInvoke=function(p,id)return Shop.Buy(p,id,Remotes)end
Remotes.Travel.OnServerInvoke=function(p,where) local d=Data.Get(p);if not d then return false end;if where=="Home" then local plot=Base.Get(p);if plot and p.Character then p.Character:PivotTo(CFrame.new(plot.Position+Vector3.new(0,8,0)));return true end;return false end;for _,zone in ipairs(Config.Zones)do if zone.Name==where then if d.Cash<zone.Requirement or d.BaseLevel<(zone.Level or 1) or d.Rebirths<(zone.Rebirths or 0) then Remotes.Notify:FireClient(p,"LOCKED • Requires $"..zone.Requirement..", Base Lv "..zone.Level..", Rebirth "..zone.Rebirths,"LOCKED");return false end;d.UnlockedZones[where]=true;if p.Character then p.Character:PivotTo(CFrame.new(zone.Position+Vector3.new(0,8,0))) end;return true end end;if where=="Market" and p.Character then p.Character:PivotTo(CFrame.new(0,12,300));return true end;return false end
 game.Players.PlayerAdded:Connect(function(p) Data.Load(p);Base.Claim(p);p.CharacterAdded:Connect(function(c)task.wait(.2);if c then c:PivotTo(CFrame.new(0,8,0))end end) end)
 game.Players.PlayerRemoving:Connect(function(p)Base.Release(p);Data.Remove(p)end)
 task.spawn(function()while true do task.wait(1);for _,p in ipairs(game.Players:GetPlayers())do local d=Data.Get(p);if d then local income=0;for _,id in ipairs(d.Owned)do local e=Config.Catalogue[id];if e then income+=e.Income end end;local boost=d.GemUpgrades and d.GemUpgrades.DoubleIncome and 2 or 1;local earned=math.floor(income*(1+d.Rebirths*.25)*boost);Coin.Add(p,earned);if d.GemUpgrades and d.GemUpgrades.AutoCollect then d.AutoCollectTimer=(d.AutoCollectTimer or 0)+1;if d.AutoCollectTimer>=5 then d.AutoCollectTimer=0;Coin.Add(p,earned*5)end end;Remotes.State:FireClient(p,state(p))end end end end)
 game:BindToClose(function()for _,p in ipairs(game.Players:GetPlayers())do Data.Save(p)end end)
end
