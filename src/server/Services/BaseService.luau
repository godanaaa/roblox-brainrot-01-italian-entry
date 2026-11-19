local U=require(game.ReplicatedStorage.Modules.Util);local C=require(game.ReplicatedStorage.Modules.Config);local B=require(script.Parent.BrainrotService);local Base={Plots={}}
local Data=require(script.Parent.DataService);local Coin=require(script.Parent.CoinService)
local function attach(part,action,callback) local prompt=Instance.new("ProximityPrompt");prompt.ActionText=action;prompt.ObjectText=action;prompt.HoldDuration=.35;prompt.Parent=part;prompt.Triggered:Connect(callback) end
local function part(parent,n,s,p,c,m)return U.Part(parent,n,s,p,c,m)end
function Base.Init()
 local folder=Instance.new("Folder");folder.Name="PlayerBases";folder.Parent=workspace
 for i=1,8 do local x=-700+(i-1)*180;local z=900;local m=Instance.new("Model");m.Name="Plot"..i;m.Parent=folder;Base.Plots[i]={Model=m,Owner=nil,Position=Vector3.new(x,0,z)}
 part(m,"Yard",Vector3.new(150,2,120),Vector3.new(x,1,z),Color3.fromRGB(95,190,100),Enum.Material.Grass)
 end
end
function Base.Claim(player)
 for _,plot in ipairs(Base.Plots) do if not plot.Owner then plot.Owner=player;Base.Rebuild(plot,1,player);return plot end end
end
function Base.Rebuild(plot,level,player)
 local m=plot.Model;for _,o in ipairs(m:GetChildren()) do if o.Name~="Yard" then o:Destroy() end end;plot.Level=level;local p=plot.Position;local scale=1+(level-1)*.22
 part(m,"House",Vector3.new(38*scale,22*scale,30*scale),p+Vector3.new(0,11*scale,0),({Color3.fromRGB(255,190,120),Color3.fromRGB(115,190,255),Color3.fromRGB(200,120,255),Color3.fromRGB(255,220,120),Color3.fromRGB(90,240,220),Color3.fromRGB(255,100,150)})[level],Enum.Material.SmoothPlastic)
 part(m,"Roof",Vector3.new(42*scale,4,34*scale),p+Vector3.new(0,23*scale,0),Color3.fromRGB(50,45,75),Enum.Material.Slate)
 local sign=part(m,"EmpireSign",Vector3.new(72,7,2),p+Vector3.new(0,25,27),Color3.fromRGB(255,190,55),Enum.Material.Neon);U.Label(sign,(player and string.upper(player.DisplayName) or "PLAYER").."'S BRAINROT EMPIRE",Color3.new(1,1,1))
 local pad=part(m,"CollectPad",Vector3.new(18,2,18),p+Vector3.new(-52,2,0),Color3.fromRGB(60,255,150),Enum.Material.Neon);U.Label(pad,"COLLECT INCOME",Color3.new(1,1,1));attach(pad,"COLLECT",function(who) if who==player then local d=Data.Get(who);if d then local amount=0;for _,id in ipairs(d.Owned)do local e=C.Catalogue[id];if e then amount+=e.Income end end;local boost=(d.GemUpgrades and d.GemUpgrades.DoubleIncome) and 2 or 1;Coin.Add(who,amount*5*(1+d.Rebirths*.25)*boost) end end end)
 local upgrade=part(m,"UpgradeStation",Vector3.new(17,3,17),p+Vector3.new(52,2,0),Color3.fromRGB(255,185,40),Enum.Material.Neon);U.Label(upgrade,"BASE UPGRADE  •  E",Color3.new(1,1,1));attach(upgrade,"UPGRADE",function(who) if who==player then local d=Data.Get(who);if d and d.BaseLevel<6 then local nextLevel=d.BaseLevel+1;local cost=C.Upgrades[nextLevel].Cost;if Coin.TrySpend(who,cost) then d.BaseLevel=nextLevel;Base.Rebuild(plot,nextLevel,who) end end end end)
 local home=part(m,"HomeTravel",Vector3.new(12,2,12),p+Vector3.new(0,2,-48),Color3.fromRGB(80,220,255),Enum.Material.Neon);U.Label(home,"CITY FAST TRAVEL",Color3.new(1,1,1));home:SetAttribute("TravelTarget","City")
 local garage=part(m,"Garage",Vector3.new(24,14,28),p+Vector3.new(48,7,-28),Color3.fromRGB(90,130,200));U.Label(garage,"GARAGE",Color3.new(1,1,1))
 local owned=player and require(script.Parent.DataService).Get(player).Owned or {};for i,id in ipairs(owned) do local idx=(i-1)%8;local row=math.floor((i-1)/8);local pos=p+Vector3.new(-52+idx*15,3,38+row*14);part(m,"DisplayPlatform",Vector3.new(12,2,12),pos,Color3.fromRGB(70,75,105),Enum.Material.Metal);local entry=C.Catalogue[id];if entry then B.Create(m,entry,pos+Vector3.new(0,4,0)) end end
end
function Base.Get(player) for _,plot in ipairs(Base.Plots) do if plot.Owner==player then return plot end end end
function Base.Release(p) local plot=Base.Get(p);if plot then plot.Owner=nil;Base.Rebuild(plot,1,nil) end end
return Base
