local U=require(game.ReplicatedStorage.Modules.Util);local C=require(game.ReplicatedStorage.Modules.Config)
local Map={}
local function model(name) local m=Instance.new("Model");m.Name=name;m.Parent=workspace;return m end
local function building(parent,name,pos,color,w,h,d,sign)
 local m=Instance.new("Model");m.Name=name;m.Parent=parent;U.Part(m,"Facade",Vector3.new(w,h,d),pos+Vector3.new(0,h/2,0),color,Enum.Material.SmoothPlastic);U.Part(m,"Roof",Vector3.new(w+3,3,d+3),pos+Vector3.new(0,h+1.5,0),Color3.fromRGB(45,48,67),Enum.Material.Slate)
 for x=-w/2+5,w/2-3,8 do U.Part(m,"Window",Vector3.new(3,4,.4),pos+Vector3.new(x,h*.6,d/2+.3),Color3.fromRGB(120,225,255),Enum.Material.Neon) end
 if sign then U.Label(m.Facade,sign,Color3.new(1,1,1)) end;return m
end
function Map.Build()
 local root=model("ItalianBrainrotWorld")
 local function district(name,build)
  local ok,err=xpcall(build,debug.traceback)
  if not ok then warn("[IBW] Map district '"..name.."' failed at part/line: "..tostring(err)) else warn("[IBW] Map district '"..name.."' built") end
 end
 district("ground + roads",function()
 for ix=-1,1,2 do for iz=-1,1,2 do local ground=U.Part(root,"WorldGround_"..ix.."_"..iz,Vector3.new(1300,8,1100),Vector3.new(ix*650,-5,iz*550),Color3.fromRGB(92,190,105),Enum.Material.Grass);ground.Locked=true end end
 -- connected urban street grid, sidewalks and ring highway
 for x=-1000,1000,200 do U.Part(root,"Avenue",Vector3.new(26,1,1900),Vector3.new(x,0,0),Color3.fromRGB(48,54,68),Enum.Material.Asphalt);U.Part(root,"Walkway",Vector3.new(8,1.2,1900),Vector3.new(x-18,.15,0),Color3.fromRGB(224,211,181));U.Part(root,"Walkway",Vector3.new(8,1.2,1900),Vector3.new(x+18,.15,0),Color3.fromRGB(224,211,181)) end
 for z=-900,900,200 do U.Part(root,"Boulevard",Vector3.new(1900,1,26),Vector3.new(0,.1,z),Color3.fromRGB(48,54,68),Enum.Material.Asphalt) end
 for _,s in ipairs({-1,1}) do for seg=1,2 do local x=(seg==1 and -550 or 550);U.Part(root,"HighwayRing_"..s.."_"..seg,Vector3.new(1100,2,32),Vector3.new(x,1,s*1000),Color3.fromRGB(35,39,51),Enum.Material.Asphalt) end;U.Part(root,"HighwayRamp",Vector3.new(32,2,2000),Vector3.new(s*1100,1,0),Color3.fromRGB(35,39,51),Enum.Material.Asphalt) end
 for i=1,16 do local a=i*math.pi/8;local x,z=math.cos(a)*180,math.sin(a)*180;local p=U.Part(root,"RoundaboutIsland",Vector3.new(68,3,68),Vector3.new(x,1,z),Color3.fromRGB(45,190,160),Enum.Material.Grass);p.Shape=Enum.PartType.Cylinder;U.Part(root,"Fountain",Vector3.new(18,18,18),Vector3.new(x,12,z),Color3.fromRGB(80,220,255),Enum.Material.Neon).Shape=Enum.PartType.Ball end
 local plaza=U.Part(root,"SpawnPlaza",Vector3.new(180,2,180),Vector3.new(0,2,0),Color3.fromRGB(255,218,142));U.Label(plaza,"BENVENUTI!  •  CENTRAL PIAZZA",Color3.fromRGB(90,40,100))
 building(root,"QuestCenter",Vector3.new(-90,0,-120),Color3.fromRGB(255,160,70),60,42,45,"QUEST CENTER")
 building(root,"Bank",Vector3.new(90,0,-120),Color3.fromRGB(80,190,130),65,48,45,"BANCA")
 building(root,"Dealership",Vector3.new(-140,0,130),Color3.fromRGB(70,190,255),80,35,55,"MOTORI")
 building(root,"PremiumShop",Vector3.new(130,0,120),Color3.fromRGB(190,85,255),60,40,45,"GEM PALACE")
 end)
 district("market",function()
 -- marketplace is its own destination, with colored halls
 local market=model("BrainrotMarketplace");U.Part(market,"MarketFloor",Vector3.new(280,4,220),Vector3.new(0,1,430),Color3.fromRGB(35,35,58),Enum.Material.Marble)
 U.Label(U.Part(market,"MarketSign",Vector3.new(100,8,4),Vector3.new(0,30,320),Color3.fromRGB(255,80,175),Enum.Material.Neon),"BRAINROT BAZAAR",Color3.new(1,1,1))
 for i=1,8 do local x=-112+(i-1)*32;local rarity=({"COMMON","UNCOMMON","RARE","EPIC","LEGENDARY","MYTHIC","SECRET","DIVINE"})[i];local col=C.Rarities[rarity].Color;building(market,rarity.."Hall",Vector3.new(x,3,485),col,27,18,70,rarity) end
 end)
 district("nature",function()
 -- canal, bridge, tunnel, lakeshore/beach, hills, forest, mountain silhouettes
 U.Part(root,"Canal",Vector3.new(2000,3,100),Vector3.new(0,-1,720),Color3.fromRGB(40,180,230),Enum.Material.Glass)
 U.Part(root,"CanalBridge",Vector3.new(190,7,145),Vector3.new(0,4,720),Color3.fromRGB(205,177,132),Enum.Material.Concrete)
 U.Part(root,"TunnelMound",Vector3.new(220,55,95),Vector3.new(-580,25,-720),Color3.fromRGB(93,102,116),Enum.Material.Rock);U.Part(root,"Tunnel",Vector3.new(54,30,98),Vector3.new(-580,12,-720),Color3.fromRGB(15,18,30),Enum.Material.Slate)
 U.Part(root,"Lake",Vector3.new(390,3,310),Vector3.new(800,-1,-750),Color3.fromRGB(55,190,235),Enum.Material.Glass)
 U.Part(root,"Beach",Vector3.new(420,3,90),Vector3.new(800,1,-560),Color3.fromRGB(255,219,140),Enum.Material.Sand)
 for i=1,10 do local x=-1000+i*90;local z=500+math.sin(i)*60;local hill=U.Part(root,"Hill",Vector3.new(140,80,130),Vector3.new(x,32,z),Color3.fromRGB(74,170,94),Enum.Material.Grass);hill.Shape=Enum.PartType.Ball end
 for i=1,80 do local x=-1050+(i%10)*70;local z=640+math.floor(i/10)*60;local trunk=U.Part(root,"TreeTrunk",Vector3.new(5,16,5),Vector3.new(x,8,z),Color3.fromRGB(120,76,40),Enum.Material.Wood);local crown=U.Part(root,"TreeCrown",Vector3.new(21,24,21),Vector3.new(x,24,z),Color3.fromRGB((i%2==0) and 50 or 40,190,(i%3)*35),Enum.Material.Grass);crown.Shape=Enum.PartType.Ball end
 for i=1,12 do local x=-1100+i*100;local m=U.Part(root,"Mountain",Vector3.new(170,190,170),Vector3.new(x,85,-1030),Color3.fromRGB(112,130,150),Enum.Material.Rock);m.Shape=Enum.PartType.Ball end
 end)
 district("zones",function()
 -- village/industrial/luxury landmarks, residential blocks, street lights and colorful signs
 for i,zone in ipairs(C.Zones) do local pos=zone.Position;building(root,zone.Name.."District",pos+Vector3.new(0,0,100),zone.Color,125,65,90,zone.Name:upper()) end
 -- High contrast endgame districts have clear arrival platforms and visible landmarks.
 local volcano=U.Part(root,"VolcanoRim",Vector3.new(250,14,250),Vector3.new(-1100,5,-800),Color3.fromRGB(49,42,50),Enum.Material.Rock);volcano.Shape=Enum.PartType.Cylinder
 local lava=U.Part(root,"LavaLake",Vector3.new(115,4,115),Vector3.new(-1100,14,-800),Color3.fromRGB(255,70,30),Enum.Material.Neon);lava.Shape=Enum.PartType.Cylinder
 for i=1,7 do local x=-1200+(i%3)*85;local z=-890+math.floor(i/3)*75;building(root,"MythicForge"..i,Vector3.new(x,15,z),Color3.fromRGB(170,49,65),36,25,30,"MYTHIC FORGE") end
 for i=1,5 do local pos=Vector3.new(960+(i%2)*115,94,730+math.floor(i/2)*105);local island=U.Part(root,"SkyIsland",Vector3.new(95,10,78),pos,Color3.fromRGB(100,205,145),Enum.Material.Grass);island.Shape=Enum.PartType.Cylinder;U.Part(root,"SkyBridge",Vector3.new(110,5,12),pos+Vector3.new(80,4,30),Color3.fromRGB(245,195,100),Enum.Material.Wood) end
 for i=1,6 do building(root,"DivineSanctum"..i,Vector3.new(-160+(i-1)*64,2,1190),Color3.fromRGB(135,55,190),48,36,42,"DIVINE") end
 for _,zone in ipairs(C.Zones) do local pad=U.Part(root,zone.Name.."TravelPad",Vector3.new(25,2,25),zone.Position+Vector3.new(0,2,-70),zone.Color,Enum.Material.Neon);U.Label(pad,zone.Name.."  •  $"..zone.Requirement,Color3.new(1,1,1));pad:SetAttribute("ZoneName",zone.Name);local prompt=Instance.new("ProximityPrompt");prompt.ActionText="TRAVEL • $"..zone.Requirement.." • LV "..zone.Level.." • REBIRTH "..zone.Rebirths;prompt.ObjectText=zone.Name;prompt.Parent=pad end
 for i=1,22 do local x=-900+(i%11)*180;local z=-500+math.floor(i/11)*850;building(root,"Residence_"..i,Vector3.new(x,0,z),Color3.fromHSV((i*.071)%1,.45,.95),52,24+(i%3)*6,48) end
 end)
 district("city",function()
 for i=1,10 do local x=-900+i*90;local light=U.Part(root,"StreetLamp",Vector3.new(2,24,2),Vector3.new(x,12,-200),Color3.fromRGB(60,60,75),Enum.Material.Metal);U.Part(root,"LampGlow",Vector3.new(7,1,7),light.Position+Vector3.new(0,12,0),Color3.fromRGB(255,235,140),Enum.Material.Neon) end
 -- recognizable city services and playful landmarks anchor exploration
 building(root,"Trattoria Bellissimo",Vector3.new(-320,0,160),Color3.fromRGB(245,105,90),72,30,52,"TRATTORIA • PASTA & PIZZA")
 building(root,"Gelateria",Vector3.new(320,0,-150),Color3.fromRGB(100,220,235),55,26,45,"GELATO!")
 building(root,"Benzina Station",Vector3.new(640,0,120),Color3.fromRGB(250,210,65),80,18,65,"BENZINA • FULL SERVICE")
 building(root,"Factory Corner",Vector3.new(-820,0,-250),Color3.fromRGB(125,135,150),110,38,100,"OFFICINA INDUSTRIALE")
 for _,z in ipairs({-200,200,600}) do for _,x in ipairs({-400,0,400}) do
  local signal=U.Part(root,"TrafficLight",Vector3.new(2,15,2),Vector3.new(x+19,8,z+19),Color3.fromRGB(40,43,55),Enum.Material.Metal)
  for j=1,3 do U.Part(root,"SignalLamp",Vector3.new(3,3,2),signal.Position+Vector3.new(0,6-j*3,0),({Color3.fromRGB(255,60,60),Color3.fromRGB(255,205,50),Color3.fromRGB(60,255,110)})[j],Enum.Material.Neon) end
  for k=1,5 do U.Part(root,"CrosswalkStripe",Vector3.new(3,.25,24),Vector3.new(x-20+k*5,1,z+20),Color3.fromRGB(245,245,245)) end
 end end
 local statue=U.Part(root,"TralaleroStatue",Vector3.new(18,42,18),Vector3.new(0,25,-250),Color3.fromRGB(70,160,255),Enum.Material.Neon);statue.Shape=Enum.PartType.Ball;U.Label(statue,"TRALALERO TRALALA",Color3.fromRGB(255,220,70))
 local park=U.Part(root,"PalmPark",Vector3.new(180,2,120),Vector3.new(450,1,260),Color3.fromRGB(90,205,120),Enum.Material.Grass);U.Label(park,"GIARDINO DELLE STELLE",Color3.fromRGB(255,255,255))
 -- three physical travel beacons; server handler checks the destination and moves the character
 for _,entry in ipairs({{"PLAZZA FAST TRAVEL",Vector3.new(0,3,85),Color3.fromRGB(80,220,255),"City"},{"BAZAAR FAST TRAVEL",Vector3.new(0,3,300),Color3.fromRGB(255,80,180),"Market"}}) do
  local pad=U.Part(root,entry[1],Vector3.new(16,2,16),entry[2],entry[3],Enum.Material.Neon);local prompt=Instance.new("ProximityPrompt");prompt.ActionText="TRAVEL";prompt.ObjectText=entry[1];prompt.Parent=pad;pad:SetAttribute("TravelTarget",entry[4])
 end
 end)
 local descendants=#root:GetDescendants()
 local missing={}
 for _,required in ipairs({"WorldGround_-1_-1","WorldGround_-1_1","WorldGround_1_-1","WorldGround_1_1","SpawnPlaza","Avenue","HighwayRing_-1_1"}) do if not root:FindFirstChild(required,true) then table.insert(missing,required) end end
 if not workspace:FindFirstChild("BrainrotMarketplace") then table.insert(missing,"BrainrotMarketplace") end
 if descendants<100 or #missing>0 then warn("[IBW] WORLD SELF-CHECK FAILED: descendants="..descendants..", missing="..table.concat(missing,", ")) else warn("[IBW] WORLD SELF-CHECK PASSED: "..descendants.." descendants; ground tiles, roads, plaza, and marketplace exist") end
 return root
end
return Map
