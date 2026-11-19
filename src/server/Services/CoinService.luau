local Data=require(script.Parent.DataService);local Coin={}
function Coin.Add(p,n) local d=Data.Get(p);if not d then return end;d.Cash+=math.floor(n);d.TotalEarned+=math.max(0,math.floor(n));d.XP+=math.max(1,math.floor(n/100));if d.XP>=d.Level*100 then d.XP=0;d.Level+=1 end end
function Coin.TrySpend(p,n) local d=Data.Get(p);if not d or d.Cash<n then return false end;d.Cash-=n;return true end
return Coin
