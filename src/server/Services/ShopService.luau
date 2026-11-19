local C=require(game.ReplicatedStorage.Modules.Config);local D=require(script.Parent.DataService);local Coin=require(script.Parent.CoinService);local Base=require(script.Parent.BaseService);local B=require(script.Parent.BrainrotService);local Shop={}
function Shop.Init(remotes)
 local market=workspace:FindFirstChild("BrainrotMarketplace");local root=market and market:FindFirstChild("MarketFloor");if not root then return end
 for i,e in ipairs(C.Catalogue) do if i<=100 then local x=-125+((i-1)%8)*35;local z=380+math.floor((i-1)/8)*34;local stand=Instance.new("Part");stand.Name="Display"..i;stand.Size=Vector3.new(14,2,14);stand.Position=Vector3.new(x,5,z);stand.Anchored=true;stand.Color=C.Rarities[e.Rarity].Color;stand.Material=Enum.Material.Neon;stand.Parent=market;B.Create(market,e,stand.Position+Vector3.new(0,5,0));local prompt=Instance.new("ProximityPrompt");local lockedZone=e.Rarity=="SECRET" and "Volcano" or e.Rarity=="DIVINE" and "Secret Dimension" or nil;local requirement="";if lockedZone then for _,zone in ipairs(C.Zones)do if zone.Name==lockedZone then requirement=" • Requires "..lockedZone.." (Base Lv "..zone.Level..", Rebirth "..zone.Rebirths..")" end end end;prompt.ActionText=lockedZone and (lockedZone.." LOCK") or ("BUY  $"..e.Price);prompt.ObjectText=e.Name.." • +$"..e.Income.."/s"..requirement;prompt.HoldDuration=.4;prompt.MaxActivationDistance=12;prompt.Parent=stand
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
 remotes.Notify:FireClient(p,"PURCHASED "..e.Name.."!",e.Rarity);return true
end
return Shop
