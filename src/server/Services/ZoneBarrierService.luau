-- ZoneBarrierService.luau (session 20)
-- Enforces the invisible zone barriers built by MapBuilder ("zoneroads"
-- district): one transparent, CanCollide wall across each zone's road
-- entrance. (The world-edge walls need no service — they are always
-- solid.) The gate is the SAME live check as the Map travel handler in
-- init.server.luau: cash >= zone.Requirement AND BaseLevel >= zone.Level
-- AND Rebirths >= zone.Rebirths.
-- Behaviour on touch:
--  * Unlocked player (either side): the zone is marked unlocked
--    (d.UnlockedZones — the same flag the travel handler sets, and the
--    one Shop.Buy requires for zone stalls), and the barrier opens
--    (CanCollide=false) for 3s so the player can walk through.
--  * Locked player on the approach side (trying to enter): the barrier
--    stays solid and the player gets the LOCKED notify with the gate
--    requirements (same format as the travel handler), throttled to once
--    per 3s per player per barrier so it does not spam.
--  * Locked player on the zone side (trying to LEAVE — e.g. they entered
--    while unlocked, then spent below the gate): leaving is always
--    allowed, so the barrier opens with no notify.
-- A 0.5s Heartbeat sweep catches the one hole the touch handler cannot:
-- a locked player who walks through while the barrier is open for an
-- unlocked player ahead of them. Only players within 12 studs of a
-- barrier and on its zone side are bounced back, so a player who
-- entered legitimately and is walking around the zone is never touched.
local D=require(script.Parent.DataService)
local C=require(game.ReplicatedStorage.Modules.Config)
local ZoneBarriers={}
local OPEN_TIME=3
local NOTIFY_COOLDOWN=3
local SWEEP_RADIUS=12
local function gateFor(zoneName)
 for _,z in ipairs(C.Zones) do if z.Name==zoneName then return z end end
 return nil
end
local function isUnlocked(d,zone)
 return d.Cash>=zone.Requirement and d.BaseLevel>=(zone.Level or 1) and d.Rebirths>=(zone.Rebirths or 0)
end
function ZoneBarriers.Init(remotes)
 local barriers={}
 local lastNotify={}
 local function openFor(barrier,seconds)
  local part=barrier.Part
  barrier.OpenUntil=os.clock()+seconds
  part.CanCollide=false
  task.delay(seconds,function()
   if os.clock()>=barrier.OpenUntil then part.CanCollide=true end
  end)
 end
 local function bounceBack(barrier,hrp)
  hrp.CFrame=CFrame.new(barrier.Part.Position+barrier.Approach*10+Vector3.new(0,3,0))
 end
 local function notifyLocked(barrier,player)
  local key=player.UserId.."|"..barrier.Zone.Name
  if os.clock()-(lastNotify[key] or 0)<NOTIFY_COOLDOWN then return end
  lastNotify[key]=os.clock()
  remotes.Notify:FireClient(player,string.format("LOCKED • Requires $%s, Base Lv %d, Rebirth %d",tostring(barrier.Zone.Requirement),barrier.Zone.Level,barrier.Zone.Rebirths),"LOCKED")
 end
 for _,obj in ipairs(workspace:GetDescendants()) do
  if obj:IsA("BasePart") and obj.Name:match("^ZoneBarrier_") then
   local zoneName=obj:GetAttribute("ZoneName")
   local approach=obj:GetAttribute("ApproachDir")
   local zone=zoneName and gateFor(zoneName)
   if zone and approach then
    local barrier={Part=obj,Zone=zone,Approach=approach,OpenUntil=0}
    table.insert(barriers,barrier)
    obj.Touched:Connect(function(hit)
     local player=game.Players:GetPlayerFromCharacter(hit.Parent)
     if not player then return end
     local d=D.Get(player)
     if not d then return end
     local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
     if not hrp then return end
     local onZoneSide=(hrp.Position-obj.Position):Dot(approach)<0
     if isUnlocked(d,zone) then
      d.UnlockedZones=d.UnlockedZones or {}
      d.UnlockedZones[zoneName]=true
      openFor(barrier,OPEN_TIME)
     elseif onZoneSide then
      -- leaving is always allowed, even if the gate no longer passes
      openFor(barrier,OPEN_TIME)
     else
      notifyLocked(barrier,player)
     end
    end)
   else
    warn("[IBW] ZoneBarrier '"..obj.Name.."' has no matching zone or ApproachDir attribute: "..tostring(zoneName))
   end
  end
 end
 -- Heartbeat sweep (see header): bounce a locked player who slipped
 -- through while the barrier was open for someone else.
 task.spawn(function()
  while true do
   task.wait(0.5)
   for _,barrier in ipairs(barriers) do
    for _,player in ipairs(game.Players:GetPlayers()) do
     local d=D.Get(player)
     local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
     if d and hrp then
      local toPlayer=hrp.Position-barrier.Part.Position
      if toPlayer.Magnitude<SWEEP_RADIUS and toPlayer:Dot(barrier.Approach)<-2 and not isUnlocked(d,barrier.Zone) then
       bounceBack(barrier,hrp)
       notifyLocked(barrier,player)
      end
     end
    end
   end
  end
 end)
 warn("[IBW] ZoneBarrierService: "..#barriers.." zone barriers live")
end
return ZoneBarriers
