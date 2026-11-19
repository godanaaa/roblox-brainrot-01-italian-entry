local C=require(game.ReplicatedStorage.Modules.Config)
local D=require(script.Parent.DataService)
local Base=require(script.Parent.BaseService)
local Premium={}
function Premium.Purchase(player,id)
 local d=D.Get(player);if not d then return false end
 for _,u in ipairs(C.GemUpgrades) do if u.Id==id then if d.GemUpgrades[id] or d.Gems<u.Price then return false end;d.Gems-=u.Price;d.GemUpgrades[id]=true;return true end end
 for _,e in ipairs(C.PremiumBrainrots) do if e.Id==id then local slots=C.Upgrades[d.BaseLevel].Slots+((d.GemUpgrades.BaseSlots) and 5 or 0);if d.Gems<e.Price or #d.Owned>=slots then return false end;d.Gems-=e.Price;table.insert(d.Owned,e.Id);d.Discovered[e.Id]=true;local plot=Base.Get(player);if plot then Base.Rebuild(plot,d.BaseLevel,player) end;return true end end
 return false
end
function Premium.Init(remotes)
 remotes.GemPurchase.OnServerInvoke=Premium.Purchase
 local world=workspace:FindFirstChild("ItalianBrainrotWorld");local palace=world and world:FindFirstChild("PremiumShop");local sign=palace and palace:FindFirstChild("Facade")
 if sign then local p=Instance.new("ProximityPrompt");p.ActionText="OPEN GEM SHOP";p.ObjectText="GEM PALACE • QUEST GEMS ONLY";p.Parent=sign;p.Triggered:Connect(function(player)remotes.Notify:FireClient(player,"Use MENU > GEM SHOP to redeem quest gems.","INFO")end) end
end
return Premium
