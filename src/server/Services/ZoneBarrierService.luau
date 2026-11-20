-- ZoneBarrierService.luau (sessions 20 + 25)
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
--
-- SESSION 25 — the walk-around gap (Ryan, BUILD 24: "the barriers into
-- the cities are not working even worse i can just enter into the shops
-- of every zone"). ROOT CAUSE, verified against the code: the road gates
-- are 20-stud walls standing on open ground. Each zone slab is 280 wide,
-- so a player simply walks around the wall on the grass and reaches the
-- market — the gate only ever blocked the road itself. The 0.5s sweep
-- cannot catch a walk-around: its catch window is a ~2.8-stud strip the
-- player crosses in ~0.18s between ticks. Two more holes the audit found:
-- (1) the markets sit OUTSIDE their slabs (Italian market x -920..-840
-- vs its slab -840..-560; Neon market x 810..890 vs its slab 560..840;
-- Volcano market x -940..-860 vs its slab -1240..-960), so fencing the
-- slab edges would not have protected the shops anyway; (2) Volcano's
-- road enters through the slab's SOUTH edge (-1000,-660) with no gate at
-- all, while its gate sits on the EAST edge (-960,-800) — and that gate's
-- ApproachDir was inverted, so the old sweep would have bounced a locked
-- player TOWARD the market. A perimeter fence was rejected: the
-- slab+market regions are different L-shapes per zone, and the Sky ramp
-- can be boarded from the side past any base fence. Instead the service
-- enforces the zone boundary directly (see zoneBoxes below): a player
-- inside a zone's box who has never unlocked it is ejected to the zone's
-- road-gate approach. That closes every entry path — walk-around,
-- tailgating, ramp side-boarding — with one mechanism, and it preserves
-- the existing semantics: leaving is always allowed, and a player who
-- unlocked a zone and then spent below its gate is never ejected (the
-- flag is permanent; only entry checks the live gate).
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
-- Session 25: zone-intrusion boxes. Each box covers the zone's slab AND
-- its market (the markets sit outside their slabs — see the header), so
-- the box is the zone, not the slab. The gate-side edge is pulled 2 studs
-- INSIDE the gate line, so a player can reach and touch the road gate
-- (and be flagged if unlocked) before ever entering the box — the sweep
-- never fires on a player standing at the gate. Eject is the zone's
-- road-gate approach point: on the road, outside the box. Sky has no
-- ground box (a player on the ground under the floating islands is not
-- IN Sky Islands): its box is the island volume only (y 85..120), so a
-- player who jumps the ramp rail is ejected once the ramp climbs past
-- y=85, ~35 studs before the island. Starter City has no gate and no box.
local zoneBoxes={}
local function box(zoneName,minX,maxX,minY,maxY,minZ,maxZ,eject)
 local zone=gateFor(zoneName)
 if zone then table.insert(zoneBoxes,{zoneName=zoneName,zone=zone,minX=minX,maxX=maxX,minY=minY,maxY=maxY,minZ=minZ,maxZ=maxZ,eject=eject}) end
end
box("Italian Village",-920,-560,-5,30,310,590,Vector3.new(-700,3,296))
box("Neon City",562,890,-5,30,-540,-260,Vector3.new(548,3,-300))
box("Luxury District",660,940,-5,30,512,790,Vector3.new(800,3,498))
box("Volcano",-1240,-860,-5,30,-940,-662,Vector3.new(-1000,3,-648))
box("Sky Islands",940,1260,85,120,660,960,Vector3.new(1160,3,488))
box("Secret Dimension",-140,138,-5,30,1000,1200,Vector3.new(152,3,1050))
function ZoneBarriers.Init(remotes)
 local barriers={}
 local lastNotify={}
 local function notifyLockedFor(zone,player)
  local key=player.UserId.."|"..zone.Name
  if os.clock()-(lastNotify[key] or 0)<NOTIFY_COOLDOWN then return end
  lastNotify[key]=os.clock()
  remotes.Notify:FireClient(player,string.format("LOCKED • Requires $%s, Base Lv %d, Rebirth %d",tostring(zone.Requirement),zone.Level,zone.Rebirths),"LOCKED")
 end
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
  notifyLockedFor(barrier.Zone,player)
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
 -- through while the barrier was open for someone else, and (session 25)
 -- eject any player inside a zone's box who has never unlocked it. A
 -- player inside the box who PASSES the live gate is flagged in instead
 -- of ejected — they met the requirement, so the gate check is the same
 -- either way, and the flag is what Shop.Buy needs. Only players within
 -- 12 studs of a barrier and on its zone side are bounced back, so a
 -- player who entered legitimately and is walking around the zone is
 -- never touched.
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
   for _,player in ipairs(game.Players:GetPlayers()) do
    local d=D.Get(player)
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if d and hrp then
     local p=hrp.Position
     for _,zoneBox in ipairs(zoneBoxes) do
      if p.X>=zoneBox.minX and p.X<=zoneBox.maxX and p.Y>=zoneBox.minY and p.Y<=zoneBox.maxY and p.Z>=zoneBox.minZ and p.Z<=zoneBox.maxZ then
       if not (d.UnlockedZones and d.UnlockedZones[zoneBox.zoneName]) then
        if isUnlocked(d,zoneBox.zone) then
         d.UnlockedZones=d.UnlockedZones or {}
         d.UnlockedZones[zoneBox.zoneName]=true
        else
         hrp.CFrame=CFrame.new(zoneBox.eject)
         notifyLockedFor(zoneBox.zone,player)
        end
       end
       break
      end
     end
    end
   end
  end
 end)
 warn("[IBW] ZoneBarrierService: "..#barriers.." zone barriers live, "..#zoneBoxes.." zone-intrusion boxes live")
end
return ZoneBarriers
