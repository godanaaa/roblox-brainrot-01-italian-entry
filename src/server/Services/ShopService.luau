local C=require(game.ReplicatedStorage.Modules.Config);local D=require(script.Parent.DataService);local Coin=require(script.Parent.CoinService);local Base=require(script.Parent.BaseService);local B=require(script.Parent.BrainrotService);local Shop={}
function Shop.Init(remotes)
 local market=workspace:FindFirstChild("BrainrotMarketplace");local root=market and market:FindFirstChild("MarketFloor");if not root then return end
 for i,e in ipairs(C.Catalogue) do if i<=100 then local x=-125+((i-1)%8)*35;local z=384+math.floor((i-1)/8)*34;local stand=Instance.new("Part");stand.Name="Display"..i;stand.Size=Vector3.new(14,2,14);stand.Position=Vector3.new(x,4,z);stand.Anchored=true;stand.Color=C.Rarities[e.Rarity].Color;stand.Material=Enum.Material.Neon;stand.Parent=market;local trim=Instance.new("Part");trim.Name="RarityGlow";trim.Size=Vector3.new(14.4,.3,14.4);trim.Position=stand.Position+Vector3.new(0,1.05,0);trim.Anchored=true;trim.CanCollide=false;trim.Color=stand.Color;trim.Material=Enum.Material.Neon;trim.Parent=market;B.Create(market,e,stand.Position+Vector3.new(0,2.6,0));local prompt=Instance.new("ProximityPrompt");local lockedZone=e.Rarity=="SECRET" and "Volcano" or e.Rarity=="DIVINE" and "Secret Dimension" or nil;local requirement="";if lockedZone then for _,zone in ipairs(C.Zones)do if zone.Name==lockedZone then requirement=" • Requires "..lockedZone.." (Base Lv "..zone.Level..", Rebirth "..zone.Rebirths..")" end end end;prompt.ActionText=lockedZone and (lockedZone.." LOCK") or ("BUY  $"..e.Price);prompt.ObjectText=e.Name.." • +$"..e.Income.."/s"..requirement;prompt.HoldDuration=.4;prompt.MaxActivationDistance=12;prompt.Parent=stand
  prompt.Triggered:Connect(function(p) Shop.Buy(p,i,remotes) end) end
 end
end
function Shop.Buy(p,id,remotes)
 local d=D.Get(p);local e=C.Catalogue[id];if not d or not e or id>100 then return false end
 local requiredZone=e.Rarity=="SECRET" and "Volcano" or e.Rarity=="DIVINE" and "Secret Dimension" or nil
 if requiredZone and not (d.UnlockedZones and d.UnlockedZones[requiredZone]) then local gate;for _,z in ipairs(C.Zones)do if z.Name==requiredZone then gate=z end end
  if gate then remotes.Notify:FireClient(p,"LOCKED • Unlock "..requiredZone.." first: $"..gate.Requirement..", Base Lv "..gate.Level..", Rebirth "..gate.Rebirths,"LOCKED") end;return false end
 local slots=C.Upgrades[d.BaseLevel].Slots+((d.GemUpgrades and d.GemUpgrades.BaseSlots) and 5 or 0)
 if #d.Owned>=slots or not Coin.TrySpend(p,e.Price) then return false end
 table.insert(d.Owned,id);d.Discovered[id]=true;local plot=Base.Get(p);if plot then Base.Rebuild(plot,d.BaseLevel,p) end
 local stand=workspace:FindFirstChild("BrainrotMarketplace") and workspace.BrainrotMarketplace:FindFirstChild("Display"..id)
 if stand then
  pcall(function()
   local Debris=game:GetService("Debris")
   local speeds={COMMON=1,UNCOMMON=1.08,RARE=1.16,EPIC=1.24,LEGENDARY=1.34,MYTHIC=1.45,SECRET=1.58,DIVINE=1.72};local sound=Instance.new("Sound");sound.Name="BrainrotPurchase";sound.SoundId="rbxasset://sounds/electronicpingshort.wav";sound.Volume=.8;sound.PlaybackSpeed=speeds[e.Rarity] or 1.1;sound.Parent=stand;Debris:AddItem(sound,4);sound:Play()
   local tiers={LEGENDARY=true,MYTHIC=true,SECRET=true,DIVINE=true}
   if tiers[e.Rarity] then task.delay(.12,function() pcall(function() local note=Instance.new("Sound");note.Name="RarePurchaseNote";note.SoundId="rbxasset://sounds/electronicpingshort.wav";note.Volume=.55;note.PlaybackSpeed=(speeds[e.Rarity] or 1.1)*1.22;note.Parent=stand;Debris:AddItem(note,4);note:Play() end) end) end
  end)
 end
 remotes.Notify:FireClient(p,"PURCHASED "..e.Name.."!",e.Rarity);return true
end
return Shop
