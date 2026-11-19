-- Session 18: owner-only in-game admin. The published place has no
-- command bar, so the place owner controls the game from the in-game chat.
-- ONLY the place owner can use it: every command verifies the speaker
-- against the game's creator (game.CreatorId / game.CreatorType) ON THE
-- SERVER before doing anything — never a hardcoded name, so it works for
-- Ryan's account (rkobeast544) whichever place he publishes to. A
-- non-owner typing these commands gets NOTHING: no response, no effect,
-- no error shown. Admin only ever touches the OWNER's own profile; other
-- players, the economy and the zone gates are unchanged for everyone else.
local C=require(game.ReplicatedStorage.Modules.Config)
local D=require(script.Parent.DataService)
local Base=require(script.Parent.BaseService)
local Admin={}
local function isOwner(p)
 -- Unpublished Studio test: the Rojo-built file carries no place
 -- metadata, so CreatorId is 0 and no creator is on record. A published
 -- place always has a real CreatorId, so this fallback can only fire in
 -- Studio — the testing player is the owner there (Ryan testing the file
 -- before he publishes it). It is not a live-game hole: a live server
 -- always has a real CreatorId, and anyone running the file locally
 -- already has the source.
 if game.CreatorId==0 then return true end
 local creatorType=game.CreatorType
 if creatorType==Enum.CreatorType.User then
  return p.UserId==game.CreatorId
 elseif creatorType==Enum.CreatorType.Group then
  local ok,rank=pcall(function() return p:GetRankInGroup(game.CreatorId) end)
  return ok and rank==255
 end
 return false
end
local function fmt(n)
 local s=tostring(math.floor(n));local out=""
 while #s>3 do out=","..s:sub(-3)..out;s=s:sub(1,-4) end
 return "$"..s..out
end
local function help(remotes,p)
 remotes.Notify:FireClient(p,"ADMIN • :cash N • :gems N • :level N • :rebirth N","COMMON")
 remotes.Notify:FireClient(p,"ADMIN • :unlock • :tp <zone> • :give <name or id>","COMMON")
 remotes.Notify:FireClient(p,"ADMIN • Zones: Starter, Italian, Neon, Luxury, Volcano, Sky, Secret","COMMON")
end
local function findZone(query)
 local q=string.lower(query or "")
 if q=="" then return nil end
 for _,zone in ipairs(C.Zones) do if string.lower(zone.Name)==q then return zone end end
 for _,zone in ipairs(C.Zones) do if string.find(string.lower(zone.Name),q,1,true) then return zone end end
 return nil
end
local function findBrainrot(query)
 local q=string.lower(query or "")
 if q=="" then return nil end
 local id=tonumber(q)
 if id and C.Catalogue[id] then return C.Catalogue[id] end
 for _,e in ipairs(C.Catalogue) do if string.lower(e.Name)==q then return e end end
 for _,e in ipairs(C.Catalogue) do if string.find(string.lower(e.Name),q,1,true) then return e end end
 return nil
end
local function slotsFor(d)
 return C.Upgrades[d.BaseLevel].Slots+((d.GemUpgrades and d.GemUpgrades.BaseSlots) and 5 or 0)
end
function Admin.Init(remotes)
 local function onChatted(p,msg)
  -- Owner check FIRST, before any parsing: a non-owner gets nothing.
  if not isOwner(p) then return end
  if type(msg)~="string" or msg:sub(1,1)~=":" then return end
  local ok,err=pcall(function()
   local cmd,rest=msg:match("^:(%S+)%s*(.*)$")
   if not cmd then help(remotes,p);return end
   cmd=string.lower(cmd);rest=rest or ""
   local d=D.Get(p)
   if not d then d=D.Load(p) end
   if not d then remotes.Notify:FireClient(p,"ADMIN • Your player data is still loading. Try again shortly.","LOCKED");return end
   if cmd=="help" then help(remotes,p);return end
   if cmd=="cash" then
    local n=tonumber(rest)
    if not n then remotes.Notify:FireClient(p,"ADMIN • Usage: :cash <amount>","LOCKED");return end
    d.Cash=math.clamp(math.floor(n),0,999999999)
    remotes.Notify:FireClient(p,"ADMIN • Cash set to "..fmt(d.Cash),"RARE");return
   end
   if cmd=="gems" then
    local n=tonumber(rest)
    if not n then remotes.Notify:FireClient(p,"ADMIN • Usage: :gems <amount>","LOCKED");return end
    d.Gems=math.clamp(math.floor(n),0,999999)
    remotes.Notify:FireClient(p,"ADMIN • Gems set to "..d.Gems,"RARE");return
   end
   if cmd=="level" then
    local n=tonumber(rest)
    if not n then remotes.Notify:FireClient(p,"ADMIN • Usage: :level <number>","LOCKED");return end
    d.Level=math.clamp(math.floor(n),1,999)
    remotes.Notify:FireClient(p,"ADMIN • Level set to "..d.Level,"RARE");return
   end
   if cmd=="rebirth" then
    local n=tonumber(rest)
    if not n then remotes.Notify:FireClient(p,"ADMIN • Usage: :rebirth <number>","LOCKED");return end
    d.Rebirths=math.clamp(math.floor(n),0,99)
    remotes.Notify:FireClient(p,"ADMIN • Rebirths set to "..d.Rebirths,"RARE");return
   end
   if cmd=="unlock" then
    d.Cash=25000000;d.Level=99;d.BaseLevel=6;d.Rebirths=3
    for _,zone in ipairs(C.Zones) do d.UnlockedZones[zone.Name]=true end
    local plot=Base.Get(p);if plot then Base.Rebuild(plot,6,p) end
    remotes.Notify:FireClient(p,"ADMIN • All zones unlocked • $25,000,000 • Base Lv 6 • Rebirth 3","RARE");return
   end
   if cmd=="tp" then
    local zone=findZone(rest)
    if not zone then
     remotes.Notify:FireClient(p,"ADMIN • Unknown zone — try one of these:","LOCKED")
     remotes.Notify:FireClient(p,"ADMIN • Starter, Italian, Neon, Luxury, Volcano, Sky, Secret","COMMON");return
    end
    local character=p.Character
    if not character or not character.Parent then remotes.Notify:FireClient(p,"ADMIN • Character is not ready yet. Try again.","LOCKED");return end
    d.UnlockedZones[zone.Name]=true
    local destination=zone.Position
    if zone.Name=="Secret Dimension" then destination+=Vector3.new(0,0,-25) end
    character:PivotTo(CFrame.new(destination+Vector3.new(0,8,0)))
    remotes.Notify:FireClient(p,"ADMIN • Teleported to "..zone.Name,"RARE");return
   end
   if cmd=="give" then
    local e=findBrainrot(rest)
    if not e then remotes.Notify:FireClient(p,"ADMIN • No Brainrot matches '"..rest.."'","LOCKED");return end
    local slots=slotsFor(d)
    if #d.Owned>=slots then remotes.Notify:FireClient(p,"ADMIN • Base is full ("..slots.." slots) — upgrade your base.","LOCKED");return end
    table.insert(d.Owned,e.Id);d.Discovered[e.Id]=true
    local plot=Base.Get(p);if plot then Base.Rebuild(plot,d.BaseLevel,p) end
    remotes.Notify:FireClient(p,"ADMIN • Gave you "..e.Name.." • +$"..e.Income.."/s",e.Rarity);return
   end
   remotes.Notify:FireClient(p,"ADMIN • Unknown command ':"..cmd.."'","LOCKED")
   help(remotes,p)
  end)
  if not ok then warn("[IBW] Admin command failed for "..p.Name..": "..tostring(err)) end
 end
 game.Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(msg) onChatted(p,msg) end) end)
 for _,p in ipairs(game.Players:GetPlayers()) do p.Chatted:Connect(function(msg) onChatted(p,msg) end) end
 warn("[IBW] Admin ready: owner-only chat commands (:cash :gems :level :rebirth :unlock :tp :give :help)")
end
return Admin
