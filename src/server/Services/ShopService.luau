local C=require(game.ReplicatedStorage.Modules.Config)
local D=require(script.Parent.DataService)
local Coin=require(script.Parent.CoinService)
local Base=require(script.Parent.BaseService)
local B=require(script.Parent.BrainrotService)
local Events=require(script.Parent.EventService)
local U=require(game.ReplicatedStorage.Modules.Util)
local Shop={}
local tiers={1,1.5,2,3,5,8,12}
local offers={
 {"COMMON","UNCOMMON","RARE"},{"UNCOMMON","RARE","EPIC"},{"RARE","EPIC"},
 {"EPIC","LEGENDARY"},{"LEGENDARY","MYTHIC"},{"MYTHIC","SECRET"},{"MYTHIC","SECRET","DIVINE"},
}
local function allowed(rarity,list) for _,v in ipairs(list) do if rarity==v then return true end end return false end
-- Session 17: pick up to k entries spread across a market's combined offer
-- bands (all rarities in the offer list), distinct, so a market's set is a
-- tight curated sample of that zone's offers. If the combined band has
-- fewer than k entries (the Secret zone only has 10 SECRET+DIVINE in the
-- whole catalogue), it returns all of them — no duplicates.
local function pickOffers(rarities,k)
 local band={};for _,e in ipairs(C.Catalogue) do if e.Id<=100 and allowed(e.Rarity,rarities) then table.insert(band,e) end end
 local out={};local n=math.min(k,#band)
 for i=1,n do local idx=math.floor((i-1)*(#band-1)/math.max(1,n-1))+1;table.insert(out,band[idx]) end
 return out
end
-- Session 17: a picket fence rectangle around a zone market, white posts +
-- two rails, with one entrance gap on the side facing the zone anchor.
-- baseY is the ground the fence stands on (anchor Y - 1: the stall stands
-- sit 1 stud into it, so the fence base matches the walking surface).
local function fenceMarket(parent,cx,baseY,cz,halfW,halfD,gapSide,gapHalf)
 local function post(x,z) local p=Instance.new("Part");p.Name="MarketFencePost";p.Size=Vector3.new(1,4,1);p.Position=Vector3.new(x,baseY+2,z);p.Anchored=true;p.Color=Color3.fromRGB(245,245,240);p.Material=Enum.Material.SmoothPlastic;p.Parent=parent end
 local function rail(cx2,cz2,len,angle) local r=Instance.new("Part");r.Name="MarketFenceRail";r.Size=Vector3.new(len,.35,.35);r.Position=Vector3.new(cx2,baseY+2.6,cz2);r.Anchored=true;r.Color=Color3.fromRGB(245,245,240);r.Material=Enum.Material.SmoothPlastic;r.CFrame=CFrame.new(cx2,baseY+2.6,cz2)*CFrame.Angles(0,angle,0);r.Parent=parent end
 local function side(x1,z1,x2,z2,gapAt,gapHalf2)
  local dx,dz=x2-x1,z2-z1;local len=math.sqrt(dx*dx+dz*dz);local n=math.max(2,math.floor(len/8))
  -- Interior posts only (i=1..n-1); the 4 corners are posted once below,
  -- so no two posts share a spot and z-fight.
  for i=1,n-1 do local t=i/n;local x=x1+dx*t;local z=z1+dz*t
   if not gapAt or math.abs((x1==x2 and z or x)-gapAt)>gapHalf2 then post(x,z) end
  end
  local function railSeg(ax,az,bx,bz) local mx,my=(ax+bx)/2,(az+bz)/2;local l=math.sqrt((bx-ax)^2+(bz-az)^2);if l>1 then rail(mx,my,l,-math.atan2(bz-az,bx-ax)) end end
  if gapAt then
   -- split the rails around the gap
   if x1==x2 then railSeg(x1,z1,x1,gapAt-gapHalf2);railSeg(x1,gapAt+gapHalf2,x1,z2) else railSeg(x1,z1,gapAt-gapHalf2,z1);railSeg(gapAt+gapHalf2,z1,x2,z2) end
  else railSeg(x1,z1,x2,z2) end
 end
 side(cx-halfW,cz-halfD,cx+halfW,cz-halfD,(gapSide=="S") and cx or nil,gapHalf)
 side(cx-halfW,cz+halfD,cx+halfW,cz+halfD,(gapSide=="N") and cx or nil,gapHalf)
 side(cx-halfW,cz-halfD,cx-halfW,cz+halfD,(gapSide=="W") and cz or nil,gapHalf)
 side(cx+halfW,cz-halfD,cx+halfW,cz+halfD,(gapSide=="E") and cz or nil,gapHalf)
 post(cx-halfW,cz-halfD);post(cx+halfW,cz-halfD);post(cx-halfW,cz+halfD);post(cx+halfW,cz+halfD)
end
local function marketPrice(e,multiplier)
 local base=math.floor(e.Price*multiplier+.5)
 return math.floor(base*(1-Events.GetDiscount())+.5)
end
local function addStall(parent,e,position,name,zoneName,multiplier,remotes)
 local stand=Instance.new("Part");stand.Name=name;stand.Size=Vector3.new(14,2,14);stand.Position=position;stand.Anchored=true;stand.Color=C.Rarities[e.Rarity].Color;stand.Material=Enum.Material.Neon;stand.Parent=parent
 local trim=Instance.new("Part");trim.Name="RarityGlow";trim.Size=Vector3.new(14.4,.3,14.4);trim.Position=stand.Position+Vector3.new(0,1.05,0);trim.Anchored=true;trim.CanCollide=false;trim.Color=stand.Color;trim.Material=Enum.Material.Neon;trim.Parent=parent
 local price=math.floor(e.Price*multiplier+.5)
 if not zoneName then price=marketPrice(e,multiplier) end
 local actionText=(zoneName and (string.upper(zoneName).." ×"..multiplier.." • ") or "").."BUY  $"..price
 local objectText=e.Name.." • "..e.Rarity.." • +$"..e.Income.."/s"
 if not zoneName and (e.Rarity=="SECRET" or e.Rarity=="DIVINE") then
  local lockedZone=e.Rarity=="SECRET" and "Volcano" or "Secret Dimension"
  local requirement
  for _,zone in ipairs(C.Zones) do if zone.Name==lockedZone then requirement=zone;break end end
  if requirement then
   actionText=string.upper(lockedZone).." LOCK"
   objectText=objectText.." • Requires Base Lv "..requirement.Level.." + Rebirth "..requirement.Rebirths
  end
 end
 -- The buy prompt is created FIRST, before the brainrot model: a model
 -- build failure must never eat the prompt (a stall with no prompt cannot
 -- be bought from at all). E is the buy key; the prompt shows within 16
 -- studs with a clear line of sight not required.
 local prompt=Instance.new("ProximityPrompt");prompt.Name="PurchasePrompt";prompt.ActionText=actionText;prompt.ObjectText=objectText;prompt.HoldDuration=.4;prompt.MaxActivationDistance=16;prompt.RequiresLineOfSight=false;prompt.KeyboardKeyCode=Enum.KeyCode.E;prompt.Parent=stand
 stand:SetAttribute("BasePrice",e.Price);stand:SetAttribute("PriceMultiplier",multiplier);stand:SetAttribute("ZonePurchase",zoneName~=nil)
 if zoneName then stand:SetAttribute("ZoneName",zoneName);stand:SetAttribute("BrainrotId",e.Id);stand:SetAttribute("PriceMultiplier",multiplier) end
 prompt.Triggered:Connect(function(p) Shop.Buy(p,e.Id,remotes,zoneName) end)
 local modelOk,modelErr=pcall(function() B.Create(parent,e,stand.Position+Vector3.new(0,2.6,0)) end)
 if not modelOk then warn("[IBW] Brainrot model failed for "..e.Name.." (stall "..name.." keeps its buy prompt): "..tostring(modelErr)) end
 if zoneName then local labelOk,labelErr=pcall(function() U.Label(stand,string.upper(zoneName).." ×"..multiplier.."\n"..e.Name.."  $"..price,Color3.new(1,1,1)) end);if not labelOk then warn("[IBW] Stall label failed for "..name..": "..tostring(labelErr)) end end
 return prompt
end
function Shop.RefreshMarketPrices()
 local market=workspace:FindFirstChild("BrainrotMarketplace");if not market then return end
 for _,stand in ipairs(market:GetChildren()) do
  if stand:GetAttribute("ZonePurchase")~=true and stand:GetAttribute("BasePrice") then
   local prompt=stand:FindFirstChild("PurchasePrompt");local id=tonumber(stand.Name:match("Display(%d+)"));local e=id and C.Catalogue[id]
   if prompt and e then
    local price=marketPrice(e,stand:GetAttribute("PriceMultiplier") or 1);local discount=Events.GetDiscount();prompt.ActionText="BUY  $"..price..(discount>0 and "  • SALE" or "")
    -- The brainrot model is parented to the market folder, not the stand.
    local character=market:FindFirstChild(e.Name);local gui=character and character:FindFirstChild("WorldLabel",true);local label=gui and gui:FindFirstChildOfClass("TextLabel")
    if label then label.Text=e.Name.."\n"..e.Rarity..(discount>0 and "  •  "..math.floor(discount*100).."% OFF" or "").."\n$"..price.."  +$"..e.Income.."/s" end
   end
  end
 end
end
function Shop.Init(remotes)
 local market=workspace:FindFirstChild("BrainrotMarketplace");local floor=market and market:FindFirstChild("MarketFloor");if not floor then warn("[IBW] Shop.Init: no MarketFloor, no stalls built");return end
 local built,failed=0,0
 -- Session 17: the central Bazaar holds ~20 brainrots (its own map's offers:
 -- COMMON/UNCOMMON/RARE, 7+7+6), NOT the whole 100-entry catalogue. A tight
 -- curated set in a 4x5 grid, centred on the floor. "Display<id>" naming is
 -- kept so RefreshMarketPrices can still find the catalogue id. One bad
 -- stall must never kill the whole market: each addStall is guarded.
 local marketEntries=pickOffers(offers[1],20)
 for i,e in ipairs(marketEntries) do
  local col=(i-1)%4;local row=math.floor((i-1)/4)
  local x=-30+col*20;local z=540+row*20
  local ok,err=pcall(function() addStall(market,e,Vector3.new(x,4,z),"Display"..e.Id,nil,1,remotes) end)
  if ok then built+=1 else failed+=1;warn("[IBW] Market stall "..i.." ("..e.Name..") failed: "..tostring(err)) end
 end
 local anchors={Vector3.new(270,0,-130),Vector3.new(-880,0,350),Vector3.new(850,0,-350),Vector3.new(900,0,650),Vector3.new(-900,0,-750),Vector3.new(1075,100,730),Vector3.new(0,0,1080)}
 -- Sky's market centre is shifted 10 studs south of its stall anchor: the
 -- 4x5 grid's north row would otherwise sit under the Sky travel pad
 -- (1100,102,780), hiding the brainrot inside the pad.
 local marketCenters={anchors[1],anchors[2],anchors[3],anchors[4],anchors[5],Vector3.new(1075,100,720),anchors[7]}
 local folder=Instance.new("Folder");folder.Name="ZoneBrainrotStalls";folder.Parent=workspace
 for zi,zone in ipairs(C.Zones) do
  local mult=tiers[zi];local list=offers[zi];local center=marketCenters[zi]
  -- Session 17: EVERY zone gets its own marketplace — ~20 brainrots (that
  -- zone's rarity offers, spread across the combined offer band), in a 4x5
  -- grid centred on the zone's market centre, inside a fenced enclosure
  -- with a sign and one entrance facing the zone anchor. No longer just 4
  -- stalls standing in the open. The Secret zone's offers include MYTHIC
  -- (the catalogue only holds 5 SECRET + 5 DIVINE entries, so MYTHIC fills
  -- its market to 20); Sky holds 19 (all 14 MYTHIC + all 5 SECRET).
  local entries=pickOffers(list,20)
  for i,entry in ipairs(entries) do
   local col=(i-1)%4;local row=math.floor((i-1)/4)
   local pos=Vector3.new(center.X-30+col*20,center.Y,center.Z-40+row*20)
   local ok,err=pcall(function() addStall(folder,entry,pos,zone.Name:gsub(" ","").."Stall"..i,zone.Name,mult,remotes) end)
   if ok then built+=1 else failed+=1;warn("[IBW] Zone stall "..zone.Name.." #"..i.." ("..entry.Name..") failed: "..tostring(err)) end
  end
  -- Fence the market: white picket fence, one 24-stud entrance on the side
  -- facing the zone anchor (where the player arrives from).
  local dx=zone.Position.X-center.X;local dz=zone.Position.Z-center.Z
  local gapSide=(math.abs(dx)>math.abs(dz)) and (dx<0 and "W" or "E") or (dz<0 and "S" or "N")
  fenceMarket(folder,center.X,center.Y-1,center.Z,50,60,gapSide,12)
  local sign=Instance.new("Part");sign.Name=zone.Name.."MarketSign";sign.Size=Vector3.new(22,7,1)
  if gapSide=="N" then sign.Position=Vector3.new(center.X,center.Y+6,center.Z+62) elseif gapSide=="S" then sign.Position=Vector3.new(center.X,center.Y+6,center.Z-62) elseif gapSide=="E" then sign.Position=Vector3.new(center.X+52,center.Y+6,center.Z);sign.Orientation=Vector3.new(0,90,0) else sign.Position=Vector3.new(center.X-52,center.Y+6,center.Z);sign.Orientation=Vector3.new(0,90,0) end
  sign.Anchored=true;sign.Color=zone.Color;sign.Material=Enum.Material.Neon;sign.Parent=folder
  U.Label(sign,zone.Name:upper().." MARKET  •  "..#entries.." BRAINROTS",Color3.new(1,1,1))
 end
 local prompts=0;for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("ProximityPrompt") and o.Name=="PurchasePrompt" then prompts+=1 end end
 warn("[IBW] Shop built: "..built.." stalls ("..failed.." failed), "..prompts.." buy prompts live — cheapest market Brainrot is $"..(C.Catalogue[1] and C.Catalogue[1].Price or "?").." vs $500 starting cash")
end
function Shop.Buy(p,id,remotes,zoneName)
 local d=D.Get(p);local e=C.Catalogue[id];if not d then remotes.Notify:FireClient(p,"PURCHASE FAILED • Player data is still loading. Try again shortly.","LOCKED");return false end;if not e or id>100 then warn("[IBW] Rejected invalid marketplace item from "..p.Name..": "..tostring(id));remotes.Notify:FireClient(p,"PURCHASE FAILED • This listing is unavailable.","LOCKED");return false end
 local multiplier=1
 if zoneName then
  local zoneIndex,zone
  for i,z in ipairs(C.Zones) do if z.Name==zoneName then zoneIndex=i;zone=z;break end end
  if not zone or not (d.UnlockedZones and d.UnlockedZones[zoneName]) then
   if zone then remotes.Notify:FireClient(p,"LOCKED • Unlock "..zoneName.." first: $"..zone.Requirement..", Base Lv "..zone.Level..", Rebirth "..zone.Rebirths,"LOCKED") end
   return false
  end
  if not allowed(e.Rarity,offers[zoneIndex]) then remotes.Notify:FireClient(p,"PURCHASE FAILED • This Brainrot is not offered in this zone.","LOCKED");return false end
  multiplier=tiers[zoneIndex]
 end
 local price=math.floor(e.Price*multiplier+.5)
 if not zoneName then price=marketPrice(e,multiplier) end
 local requiredZone=e.Rarity=="SECRET" and "Volcano" or e.Rarity=="DIVINE" and "Secret Dimension" or nil
 if requiredZone and not (d.UnlockedZones and d.UnlockedZones[requiredZone]) then local gate;for _,z in ipairs(C.Zones)do if z.Name==requiredZone then gate=z end end
  if gate then remotes.Notify:FireClient(p,"LOCKED • Unlock "..requiredZone.." first: $"..gate.Requirement..", Base Lv "..gate.Level..", Rebirth "..gate.Rebirths,"LOCKED") end;return false end
 local slots=C.Upgrades[d.BaseLevel].Slots+((d.GemUpgrades and d.GemUpgrades.BaseSlots) and 5 or 0)
 if #d.Owned>=slots then remotes.Notify:FireClient(p,"PURCHASE FAILED • Your Brainrot storage is full. Upgrade your base or storage.","LOCKED");return false end
 if not Coin.TrySpend(p,price) then remotes.Notify:FireClient(p,"PURCHASE FAILED • You need $"..price.." for this Brainrot.","LOCKED");return false end
 table.insert(d.Owned,id);d.Discovered[id]=true;local plot=Base.Get(p);if plot then Base.Rebuild(plot,d.BaseLevel,p) end
 local stall=zoneName and workspace:FindFirstChild("ZoneBrainrotStalls") or workspace:FindFirstChild("BrainrotMarketplace")
 local soundParent
 if stall and zoneName then for _,candidate in ipairs(stall:GetChildren()) do if candidate:GetAttribute("ZoneName")==zoneName and candidate:GetAttribute("BrainrotId")==id then soundParent=candidate;break end end elseif stall then soundParent=stall:FindFirstChild("Display"..id) end
 if soundParent then pcall(function()
  local Debris=game:GetService("Debris")
  local speeds={COMMON=1,UNCOMMON=1.08,RARE=1.16,EPIC=1.24,LEGENDARY=1.34,MYTHIC=1.45,SECRET=1.58,DIVINE=1.72}
  local sound=Instance.new("Sound");sound.Name="BrainrotPurchase";sound.SoundId="rbxasset://sounds/electronicpingshort.wav";sound.Volume=.8;sound.PlaybackSpeed=speeds[e.Rarity] or 1;sound.Parent=soundParent;Debris:AddItem(sound,4);sound:Play()
  local hasHighLayer=e.Rarity=="LEGENDARY" or e.Rarity=="MYTHIC" or e.Rarity=="SECRET" or e.Rarity=="DIVINE"
  if hasHighLayer then task.delay(.12,function() pcall(function() local layer=Instance.new("Sound");layer.Name="BrainrotPurchaseHighLayer";layer.SoundId="rbxasset://sounds/electronicpingshort.wav";layer.Volume=.55;layer.PlaybackSpeed=(speeds[e.Rarity] or 1)*1.22;layer.Parent=soundParent;Debris:AddItem(layer,4);layer:Play() end) end) end
 end) end
 remotes.Notify:FireClient(p,"PURCHASED "..e.Name.."!  •  $"..price,e.Rarity);return true
end
return Shop
