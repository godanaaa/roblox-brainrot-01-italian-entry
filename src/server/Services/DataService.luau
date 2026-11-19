local DSS=game:GetService("DataStoreService");local store=DSS:GetDataStore("IBW_Player_v1");local Data={Profiles={}}
local function fresh() return {Cash=500,Gems=0,Level=1,XP=0,Rebirths=0,BaseLevel=1,Owned={},Quests={},TotalEarned=0,Discovered={},Vehicles={},GemUpgrades={},UnlockedZones={}} end
function Data.Load(player) local d;pcall(function() d=store:GetAsync("u"..player.UserId) end);if type(d)~="table" then d=fresh() end;for k,v in pairs(fresh()) do if d[k]==nil then d[k]=v end end;Data.Profiles[player]=d;return d end
function Data.Save(player) local d=Data.Profiles[player];if d then pcall(function() store:SetAsync("u"..player.UserId,d) end) end end
function Data.Get(player) return Data.Profiles[player] end
function Data.Remove(player) Data.Save(player);Data.Profiles[player]=nil end
return Data
