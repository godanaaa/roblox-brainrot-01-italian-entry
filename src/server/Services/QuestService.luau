local C=require(game.ReplicatedStorage.Modules.Config);local D=require(script.Parent.DataService);local Q={}
function Q.Claim(p,id) local d=D.Get(p);if not d or d.Quests[id] then return false end;local q;for _,v in ipairs(C.Quests) do if v.Id==id then q=v end end;if not q then return false end
 local ok=(id=="first" and #d.Owned>=1) or (id=="buy3" and #d.Owned>=3) or (id=="visit3" and (function() local n=0;for _ in pairs(d.UnlockedZones or {}) do n+=1 end;return n>=3 end)()) or (id=="rare" and (function()for _,n in ipairs(d.Owned) do if C.Catalogue[n].Rarity=="RARE" then return true end end return false end)()) or (id=="million" and d.TotalEarned>=1000000) or (id=="upgrade" and d.BaseLevel>1) or (id=="collect25" and #d.Owned>=25);if not ok then return false end;d.Quests[id]=true;d.Cash+=q.Cash;d.Gems+=q.Gems;return true
end
return Q
