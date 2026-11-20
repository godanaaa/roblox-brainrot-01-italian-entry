local U=require(game.ReplicatedStorage.Modules.Util)
local C=require(game.ReplicatedStorage.Modules.Config)
local B=require(script.Parent.BrainrotService)
local Data=require(script.Parent.DataService)
local Coin=require(script.Parent.CoinService)
local Base={Plots={}}
local palettes={Color3.fromRGB(255,190,120),Color3.fromRGB(115,190,255),Color3.fromRGB(200,120,255),Color3.fromRGB(255,220,120),Color3.fromRGB(90,240,220),Color3.fromRGB(255,100,150),Color3.fromRGB(150,220,125),Color3.fromRGB(255,155,185)}
local function part(parent,n,s,p,c,m)
 return U.Part(parent,n,s,p,c,m)
end
local function attach(part,action,callback)
 local prompt=Instance.new("ProximityPrompt");prompt.ActionText=action;prompt.ObjectText=action;prompt.HoldDuration=.35;prompt.Parent=part;prompt.Triggered:Connect(callback)
end
local function fence(plot,p)
 local white=Color3.fromRGB(248,244,222)
 for _,side in ipairs({-1,1}) do
  for i=0,12 do local z=-52+i*8
   part(plot,"Picket",Vector3.new(1,8,1),p+Vector3.new(side*72,5,z),white,Enum.Material.Wood)
  end
  part(plot,"FenceRail",Vector3.new(2,2,112),p+Vector3.new(side*72,4,0),white,Enum.Material.Wood)
  part(plot,"FenceRail",Vector3.new(2,2,112),p+Vector3.new(side*72,8,0),white,Enum.Material.Wood)
 end
 for _,z in ipairs({-56,56}) do
  for i=0,15 do local x=-72+i*9
   if not (z==-56 and math.abs(x)<13) then part(plot,"Picket",Vector3.new(1,8,1),p+Vector3.new(x,5,z),white,Enum.Material.Wood) end
  end
  part(plot,"FenceRail",Vector3.new(144,2,2),p+Vector3.new(0,4,z),white,Enum.Material.Wood)
  part(plot,"FenceRail",Vector3.new(144,2,2),p+Vector3.new(0,8,z),white,Enum.Material.Wood)
 end
end
-- Extra plot slots for the dynamic builder, in the order they are used.
-- Row A extends the z=900 row west by one (the east end hits the
-- RollingHills past x=1100, and the west end grazes one at x=-1060);
-- row B is a second row at z=1030, clear of the Secret slab
-- (x -140..140), the Secret road (x=290), the z=1100 south-edge
-- barriers, the Sky ramp and every residence. Small landscape items
-- (palms, trees, stones, wildflowers) inside a new yard are cleared by
-- Base.ClearYard, the session-12 precedent for trees in base yards.
-- Hills are never built on. 10 static + 11 dynamic = 21 plots.
local extraSlots={
 Vector3.new(-880,0,900),
 Vector3.new(500,0,1030),Vector3.new(680,0,1030),Vector3.new(860,0,1030),
 Vector3.new(1040,0,1030),Vector3.new(1220,0,1030),
 Vector3.new(-320,0,1030),Vector3.new(-500,0,1030),Vector3.new(-680,0,1030),
 Vector3.new(-860,0,1030),Vector3.new(-1040,0,1030),
}
local clearable={TreeTrunk=true,TreeCrown=true,PalmTrunk=true,PalmCrown=true,PalmFrond=true,GardenStone=true,Wildflower=true}
function Base.ClearYard(x,z)
 for _,o in ipairs(workspace:GetDescendants()) do
  if clearable[o.Name] and o:IsA("BasePart") and math.abs(o.Position.X-x)<=77 and math.abs(o.Position.Z-z)<=62 then o:Destroy() end
 end
end
function Base.BuildPlot()
 local slot=extraSlots[#Base.Plots-9]
 if not slot then return nil end
 local i=#Base.Plots+1
 local m=Instance.new("Model");m.Name="Plot"..i;m.Parent=Base.Folder
 local plot={Index=i,Model=m,Owner=nil,Position=slot,Style=((i-1)%8)+1}
 Base.Plots[i]=plot
 part(m,"Yard",Vector3.new(150,2,120),slot+Vector3.new(0,1,0),Color3.fromRGB(95,190,100),Enum.Material.Grass)
 Base.ClearYard(slot.X,slot.Z)
 warn("[IBW] Built extra base plot "..i.." at "..tostring(slot))
 return plot
end
function Base.Init()
 local folder=Instance.new("Folder");folder.Name="PlayerBases";folder.Parent=workspace
 Base.Folder=folder
 for i=1,10 do
  local x;if i<=8 then x=-700+(i-1)*180 else x=560+(i-8)*180 end
  local z=900;local m=Instance.new("Model");m.Name="Plot"..i;m.Parent=folder
  Base.Plots[i]={Index=i,Model=m,Owner=nil,Position=Vector3.new(x,0,z),Style=((i-1)%8)+1}
  part(m,"Yard",Vector3.new(150,2,120),Vector3.new(x,1,z),Color3.fromRGB(95,190,100),Enum.Material.Grass)
  Base.ClearYard(x,z)
 end
end
function Base.Claim(player)
 if Base.Get(player) then return Base.Get(player) end
 local d=Data.Get(player)
 local level=(d and d.BaseLevel) or 1
 local function take(plot)
  local ok,err=xpcall(function() Base.Rebuild(plot,level,player) end,debug.traceback)
  if not ok then warn("[IBW] Base.Claim failed for "..player.Name.." at part/line: "..tostring(err));return nil end
  plot.Owner=player
  if d then d.BasePlot=plot.Index end
  return plot
 end
 -- 1. The player's own persisted plot: the same base across rejoins.
 if d and d.BasePlot and d.BasePlot>0 then
  local own=Base.Plots[d.BasePlot]
  if own and not own.Owner then return take(own) end
 end
 -- 2. First free plot.
 for _,plot in ipairs(Base.Plots) do if not plot.Owner then return take(plot) end end
 -- 3. No free plot: build one dynamically. Never share, never baseless.
 local plot=Base.BuildPlot()
 if plot then return take(plot) end
 warn("[IBW] Base.Claim found no available plot for "..player.Name)
 return nil
end
function Base.Rebuild(plot,level,player)
 local m=plot.Model
 for _,o in ipairs(m:GetChildren()) do if o.Name~="Yard" then o:Destroy() end end
 plot.Level=level
 local p=plot.Position;local scale=1+(level-1)*.16;local w=38*scale;local h=20*scale;local d=30*scale;local front=-d/2
 local wall=palettes[plot.Style or 1];local trim=Color3.fromHSV(((plot.Style or 1)*.117)%1,.62,.98);local ivory=Color3.fromRGB(255,239,203)
 fence(m,p)
 -- Four wall planes leave a real, walkable doorway in the front wall.
 part(m,"InteriorFloor",Vector3.new(w-2,.5,d-2),p+Vector3.new(0,2.3,0),Color3.fromRGB(255,239,207),Enum.Material.WoodPlanks)
 local winY=2+h*.64;local lowH=winY-3-2;local highH=2+h-(winY+3)
 part(m,"RearWallLower",Vector3.new(w,lowH,1),p+Vector3.new(0,2+lowH/2,d/2),wall,Enum.Material.SmoothPlastic)
 part(m,"RearWallUpper",Vector3.new(w,highH,1),p+Vector3.new(0,winY+3+highH/2,d/2),wall,Enum.Material.SmoothPlastic)
 local outerW=w/2-(w*.29+3.5);local centerW=2*(w*.29-3.5)
 for _,x in ipairs({-(w/2+w*.29+3.5)/2,(w/2+w*.29+3.5)/2}) do part(m,"RearWallSide",Vector3.new(outerW,h,1),p+Vector3.new(x,2+h/2,d/2),wall,Enum.Material.SmoothPlastic) end
 part(m,"RearWallCenter",Vector3.new(centerW,h,1),p+Vector3.new(0,2+h/2,d/2),wall,Enum.Material.SmoothPlastic)
 part(m,"LeftWall",Vector3.new(1,h,d),p+Vector3.new(-w/2,2+h/2,0),wall,Enum.Material.SmoothPlastic)
 part(m,"RightWall",Vector3.new(1,h,d),p+Vector3.new(w/2,2+h/2,0),wall,Enum.Material.SmoothPlastic)
 part(m,"FrontLeft",Vector3.new((w-9)/2,h,1),p+Vector3.new(-(w+9)/4,2+h/2,front),wall,Enum.Material.SmoothPlastic)
 part(m,"FrontRight",Vector3.new((w-9)/2,h,1),p+Vector3.new((w+9)/4,2+h/2,front),wall,Enum.Material.SmoothPlastic)
 part(m,"FrontHeader",Vector3.new(9,h-12,1),p+Vector3.new(0,8+h/2,front),wall,Enum.Material.SmoothPlastic)
 part(m,"DoorLintel",Vector3.new(9,2,1),p+Vector3.new(0,13,front),trim,Enum.Material.Wood)
 -- Bright, open interior with visible furniture, windows, and a doorway light.
 for _,x in ipairs({-w*.29,w*.29}) do local win=part(m,"Window",Vector3.new(7,6,.35),p+Vector3.new(x,winY,d/2+.2),Color3.fromRGB(135,232,255),Enum.Material.Glass);win.Transparency=.38;win.CanCollide=false;part(m,"WindowSill",Vector3.new(8,1,1),win.Position+Vector3.new(0,-3.5,0),ivory,Enum.Material.Wood) end
 part(m,"TableTop",Vector3.new(10,1,6),p+Vector3.new(0,6,2),Color3.fromRGB(180,112,65),Enum.Material.Wood)
 for _,x in ipairs({-3.5,3.5}) do for _,z in ipairs({0,4}) do part(m,"TableLeg",Vector3.new(.8,3,.8),p+Vector3.new(x,4.2,z),Color3.fromRGB(115,72,50),Enum.Material.Wood) end end
 part(m,"Bed",Vector3.new(8,2,12),p+Vector3.new(w*.27,3.5,5),Color3.fromRGB(115,173,240),Enum.Material.Fabric)
 part(m,"BedHeadboard",Vector3.new(9,5,1),p+Vector3.new(w*.27,5,11),trim,Enum.Material.Wood)
 local lamp=part(m,"InteriorLamp",Vector3.new(3,1,3),p+Vector3.new(0,2+h-2,0),Color3.fromRGB(255,245,190),Enum.Material.Neon);local light=Instance.new("PointLight");light.Brightness=1.5;light.Range=26;light.Color=Color3.fromRGB(255,240,190);light.Parent=lamp
 -- Distinct stepped roof silhouette, chimney, porch, and trim grow with house level.
 part(m,"RoofMain",Vector3.new(w+5,3,d+5),p+Vector3.new(0,2+h+1.5,0),Color3.fromRGB(50,45,75),Enum.Material.Slate)
 for _,side in ipairs({-1,1}) do local roof=part(m,"RoofSlope",Vector3.new(w*.54,3,d+8),p+Vector3.new(side*w*.25,2+h+4,0),Color3.fromRGB(65,48+(plot.Style%3)*12,86),Enum.Material.Slate);roof.Shape=Enum.PartType.Wedge;roof.CFrame=CFrame.new(roof.Position)*CFrame.Angles(0,0,side*math.rad(18)) end
 part(m,"Chimney",Vector3.new(5,13,5),p+Vector3.new(w*.3,2+h+8,-d*.22),Color3.fromRGB(190,92,75),Enum.Material.Brick)
 for tier=2,level do local cornice=part(m,"LevelTrim",Vector3.new(w+2,1.2,d+2),p+Vector3.new(0,2+2+(tier-1)*3.2,d*.36),trim,Enum.Material.Wood);cornice.CanCollide=false end
 part(m,"Porch",Vector3.new(17,1,10),p+Vector3.new(0,2.5,-d/2-5),ivory,Enum.Material.Wood)
 for _,x in ipairs({-7,7}) do part(m,"PorchPost",Vector3.new(1,10,1),p+Vector3.new(x,7,-d/2-8),trim,Enum.Material.Wood) end
 part(m,"EmpireSign",Vector3.new(72,7,2),p+Vector3.new(0,2+h+7,d/2+2),trim,Enum.Material.Neon)
 U.Label(m.EmpireSign,(player and string.upper(player.DisplayName) or "PLAYER").."'S BRAINROT EMPIRE",Color3.new(1,1,1))
 local pad=part(m,"CollectPad",Vector3.new(18,2,18),p+Vector3.new(-52,2,0),Color3.fromRGB(60,255,150),Enum.Material.Neon);U.Label(pad,"COLLECT INCOME",Color3.new(1,1,1))
 attach(pad,"COLLECT",function(who) if who==player then local data=Data.Get(who);if data then local amount=0;for _,id in ipairs(data.Owned)do local e=C.Catalogue[id];if e then amount+=e.Income end end;local boost=(data.GemUpgrades and data.GemUpgrades.DoubleIncome) and 2 or 1;local events=require(script.Parent.EventService);local payout=math.floor(amount*5*(1+data.Rebirths*.25)*boost*events.GetIncomeMultiplier());Coin.Add(who,payout);game.ReplicatedStorage.Remotes.Notify:FireClient(who,"INCOME COLLECTED • +$"..payout,"COMMON") end end end)
 local upgrade=part(m,"UpgradeStation",Vector3.new(17,3,17),p+Vector3.new(52,2,0),Color3.fromRGB(255,185,40),Enum.Material.Neon);U.Label(upgrade,"BASE UPGRADE  •  E",Color3.new(1,1,1))
 attach(upgrade,"UPGRADE",function(who) if who==player then local data=Data.Get(who);if not data then return end;local notify=game.ReplicatedStorage.Remotes.Notify;if data.BaseLevel>=6 then notify:FireClient(who,"BASE MAXED • Your empire is at its highest house tier.","LOCKED");return end;local nextLevel=data.BaseLevel+1;local cost=C.Upgrades[nextLevel].Cost;if Coin.TrySpend(who,cost) then data.BaseLevel=nextLevel;Base.Rebuild(plot,nextLevel,who);notify:FireClient(who,"BASE UPGRADED • Your home has expanded to level "..nextLevel.."!","RARE") else notify:FireClient(who,"UPGRADE FAILED • You need $"..cost.." for the next house tier.","LOCKED") end end end)
 local home=part(m,"HomeTravel",Vector3.new(12,2,12),p+Vector3.new(-53,2,-39),Color3.fromRGB(80,220,255),Enum.Material.Neon);U.Label(home,"CITY FAST TRAVEL",Color3.new(1,1,1));home:SetAttribute("TravelTarget","City")
 local garage=part(m,"Garage",Vector3.new(24,14,28),p+Vector3.new(48,7,-28),Color3.fromRGB(90,130,200));U.Label(garage,"GARAGE",Color3.new(1,1,1))
 local owned=player and Data.Get(player) and Data.Get(player).Owned or {}
 for i,id in ipairs(owned) do local idx=(i-1)%6;local row=math.floor((i-1)/6);local pos=p+Vector3.new(-39+idx*15,3,33+row*15);local entry=C.Catalogue[id]
  local color=entry and C.Rarities[entry.Rarity] and C.Rarities[entry.Rarity].Color or Color3.fromRGB(255,220,90)
  local disc=part(m,"DisplayPad",Vector3.new(12,1,12),pos,color,Enum.Material.Neon);disc.Shape=Enum.PartType.Cylinder;disc.CFrame=CFrame.new(pos)*CFrame.Angles(0,0,math.rad(90))
  local ring=part(m,"DisplayRing",Vector3.new(13,.35,13),pos+Vector3.new(0,.6,0),color,Enum.Material.Neon);ring.Shape=Enum.PartType.Cylinder;ring.CFrame=CFrame.new(ring.Position)*CFrame.Angles(0,0,math.rad(90))
  if entry then
   local char=B.Create(m,entry,pos+Vector3.new(0,2.2,0))
   if char then
    local gui=char:FindFirstChild("WorldLabel",true);local text=gui and gui:FindFirstChildOfClass("TextLabel")
    if gui then gui.Size=UDim2.fromOffset(250,66);gui.StudsOffset=Vector3.new(0,7.5,0) end
    if text then text.Text=entry.Rarity.."\n"..entry.Name.."\n+$"..entry.Income.." / sec";text.TextColor3=color end
   end
   local plaque=part(m,"DisplayInfo",Vector3.new(11,.35,2),pos+Vector3.new(0,1.4,-6),color,Enum.Material.Neon)
   U.Label(plaque,entry.Rarity.."  •  "..entry.Name.."\n+$"..entry.Income.." / sec",Color3.new(1,1,1))
  end
 end
end
function Base.Get(player) for _,plot in ipairs(Base.Plots) do if plot.Owner==player then return plot end end end
function Base.Release(p) local plot=Base.Get(p);if plot then plot.Owner=nil;Base.Rebuild(plot,1,nil) end end
return Base
