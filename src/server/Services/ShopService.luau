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
 {"EPIC","LEGENDARY"},{"LEGENDARY","MYTHIC"},{"MYTHIC","SECRET"},{"SECRET","DIVINE"},
}
local function allowed(rarity,list) for _,v in ipairs(list) do if rarity==v then return true end end return false end
local function marketPrice(e,multiplier)
 local base=math.floor(e.Price*multiplier+.5)
 return math.floor(base*(1-Events.GetDiscount())+.5)
end
local function addStall(parent,e,position,name,zoneName,multiplier,remotes)
 local stand=Instance.new("Part");stand.Name=name;stand.Size=Vector3.new(14,2,14);stand.Position=position;stand.Anchored=true;stand.Color=C.Rarities[e.Rarity].Color;stand.Material=Enum.Material.Neon;stand.Parent=parent
 local trim=Instance.new("Part");trim.Name="RarityGlow";trim.Size=Vector3.new(14.4,.3,14.4);trim.Position=stand.Position+Vector3.new(0,1.05,0);trim.Anchored=true;trim.CanCollide=false;trim.Color=stand.Color;trim.Material=Enum.Material.Neon;trim.Parent=parent
 B.Create(parent,e,stand.Position+Vector3.new(0,2.6,0))
 local price=math.floor(e.Price*multiplier+.5)
 if not zoneName then price=marketPrice(e,multiplier) end
 if zoneName then U.Label(stand,string.upper(zoneName).." ×"..multiplier.."\n"..e.Name.."  $"..price,Color3.new(1,1,1)) end
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
 local prompt=Instance.new("ProximityPrompt");prompt.Name="PurchasePrompt";prompt.ActionText=actionText;prompt.ObjectText=objectText;prompt.HoldDuration=.4;prompt.MaxActivationDistance=12;prompt.Parent=stand
 stand:SetAttribute("BasePrice",e.Price);stand:SetAttribute("PriceMultiplier",multiplier);stand:SetAttribute("ZonePurchase",zoneName~=nil)
 if zoneName then stand:SetAttribute("ZoneName",zoneName);stand:SetAttribute("BrainrotId",e.Id);stand:SetAttribute("PriceMultiplier",multiplier) end
 prompt.Triggered:Connect(function(p) Shop.Buy(p,e.Id,remotes,zoneName) end)
end
function Shop.RefreshMarketPrices()
 local market=workspace:FindFirstChild("BrainrotMarketplace");if not market then return end
 for _,stand in ipairs(market:GetChildren()) do
  if stand:GetAttribute("ZonePurchase")~=true and stand:GetAttribute("BasePrice") then
   local prompt=stand:FindFirstChild("PurchasePrompt");local id=tonumber(stand.Name:match("Display(%d+)"));local e=id and C.Catalogue[id]
   if prompt and e then
    local price=marketPrice(e,stand:GetAttribute("PriceMultiplier") or 1);local discount=Events.GetDiscount();prompt.ActionText="BUY  $"..price..(discount>0 and "  • SALE" or "")
    local character=stand:FindFirstChild(e.Name);local gui=character and character:FindFirstChild("WorldLabel",true);local label=gui and gui:FindFirstChildOfClass("TextLabel")
    if label then label.Text=e.Name.."\n"..e.Rarity..(discount>0 and "  •  "..math.floor(discount*100).."% OFF" or "").."\n$"..price.."  +$"..e.Income.."/s" end
   end
  end
 end
end
function Shop.Init(remotes)
 local market=workspace:FindFirstChild("BrainrotMarketplace");local floor=market and market:FindFirstChild("MarketFloor");if not floor then return end
 for i,e in ipairs(C.Catalogue) do if i<=100 then local x=-125+((i-1)%8)*35;local z=384+math.floor((i-1)/8)*34;addStall(market,e,Vector3.new(x,4,z),"Display"..i,nil,1,remotes) end end
 local anchors={Vector3.new(270,0,-130),Vector3.new(-880,0,350),Vector3.new(850,0,-350),Vector3.new(900,0,650),Vector3.new(-900,0,-750),Vector3.new(1075,100,730),Vector3.new(0,0,1080)}
 local folder=Instance.new("Folder");folder.Name="ZoneBrainrotStalls";folder.Parent=workspace
 for zi,zone in ipairs(C.Zones) do
  local mult=tiers[zi];local list=offers[zi];local choices={}
  for _,e in ipairs(C.Catalogue) do if e.Id<=100 and allowed(e.Rarity,list) then table.insert(choices,e) end end
  for j=1,4 do
   local entry=choices[math.floor((j-1)*(#choices-1)/3)+1]
   if entry then local dx=({-27,-9,9,27})[j];local centerY=anchors[zi].Y;local pos=Vector3.new(anchors[zi].X+dx,centerY,anchors[zi].Z)
    addStall(folder,entry,pos,zone.Name:gsub(" ","").."Stall"..j,zone.Name,mult,remotes)
   end
  end
 end
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
