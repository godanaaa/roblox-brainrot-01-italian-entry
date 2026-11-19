local DSS=game:GetService("DataStoreService");local store
local ok, result=pcall(function() return DSS:GetDataStore("IBW_Player_v1") end)
if ok then store=result else warn("[IBW] DataStore unavailable; using memory-only profiles: "..tostring(result)) end
local memory={}
local Data={Profiles={}}
local function fresh() return {Cash=500,Gems=0,Level=1,XP=0,Rebirths=0,BaseLevel=1,Owned={},Quests={},TotalEarned=0,Discovered={},Vehicles={},GemUpgrades={},UnlockedZones={}} end
function Data.Load(player) local d;local key="u"..player.UserId;if store then local readOk,value=pcall(function() return store:GetAsync(key) end);if readOk then d=value else warn("[IBW] DataStore load failed: "..tostring(value)) end else d=memory[key] end;if type(d)~="table" then d=fresh() end;for k,v in pairs(fresh()) do if d[k]==nil then d[k]=v end end;Data.Profiles[player]=d;return d end
function Data.Save(player) local d=Data.Profiles[player];if d then local key="u"..player.UserId;if store then local saveOk,err=pcall(function() store:SetAsync(key,d) end);if not saveOk then warn("[IBW] DataStore save failed: "..tostring(err));memory[key]=d end else memory[key]=d end end end
function Data.Get(player) return Data.Profiles[player] end
function Data.Remove(player) Data.Save(player);Data.Profiles[player]=nil end
return Data
