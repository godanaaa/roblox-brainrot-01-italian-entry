local U=require(game.ReplicatedStorage.Modules.Util);local C=require(game.ReplicatedStorage.Modules.Config)
local Map={}
local function model(name) local m=Instance.new("Model");m.Name=name;m.Parent=workspace;return m end
local function building(parent,name,pos,color,w,h,d,sign)
 -- Facade starts 1 stud below the stated ground level so the building
 -- meets its ground instead of floating 1 stud above it (the old code
 -- put the facade base at pos.y, one stud above the walking surface).
 local m=Instance.new("Model");m.Name=name;m.Parent=parent;U.Part(m,"Facade",Vector3.new(w,h,d),pos+Vector3.new(0,h/2-1,0),color,Enum.Material.SmoothPlastic);U.Part(m,"Roof",Vector3.new(w+3,3,d+3),pos+Vector3.new(0,h+0.5,0),Color3.fromRGB(45,48,67),Enum.Material.Slate)
 for x=-w/2+5,w/2-3,8 do U.Part(m,"Window",Vector3.new(3,4,.4),pos+Vector3.new(x,h*.6-1,d/2+.3),Color3.fromRGB(120,225,255),Enum.Material.Neon) end
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
 -- Flat walking ground: every road, sidewalk and water strip is an inlay
 -- whose top sits at y=-0.95 (a hair above the ground tiles at y=-1, so
 -- nothing z-fights and nothing steps up). The old raised strips (avenues
 -- +1.5, boulevards +1.6, highway +3, plaza +4) were the ridges players
 -- felt underfoot on every straight walk.
 for x=-1000,1000,200 do U.Part(root,"Avenue",Vector3.new(26,1,1900),Vector3.new(x,-1.45,0),Color3.fromRGB(48,54,68),Enum.Material.Asphalt);U.Part(root,"Walkway",Vector3.new(8,1.2,1900),Vector3.new(x-18,-1.55,0),Color3.fromRGB(224,211,181));U.Part(root,"Walkway",Vector3.new(8,1.2,1900),Vector3.new(x+18,-1.55,0),Color3.fromRGB(224,211,181)) end
 for z=-900,900,200 do U.Part(root,"Boulevard",Vector3.new(1900,1,26),Vector3.new(0,-1.45,z),Color3.fromRGB(48,54,68),Enum.Material.Asphalt) end
 for _,s in ipairs({-1,1}) do for seg=1,2 do local x=(seg==1 and -550 or 550);U.Part(root,"HighwayRing_"..s.."_"..seg,Vector3.new(1100,2,32),Vector3.new(x,-1.95,s*1000),Color3.fromRGB(35,39,51),Enum.Material.Asphalt) end;U.Part(root,"HighwayRamp",Vector3.new(32,2,2000),Vector3.new(s*1100,-1.95,0),Color3.fromRGB(35,39,51),Enum.Material.Asphalt) end
 for i=1,16 do local a=i*math.pi/8;local x,z=math.cos(a)*180,math.sin(a)*180;local p=U.Part(root,"RoundaboutIsland",Vector3.new(68,3,68),Vector3.new(x,-2.45,z),Color3.fromRGB(45,190,160),Enum.Material.Grass);p.Shape=Enum.PartType.Cylinder;U.Part(root,"Fountain",Vector3.new(18,18,18),Vector3.new(x,8.05,z),Color3.fromRGB(80,220,255),Enum.Material.Neon).Shape=Enum.PartType.Ball end
 local plaza=U.Part(root,"SpawnPlaza",Vector3.new(180,2,180),Vector3.new(0,-1.9,0),Color3.fromRGB(255,218,142));U.Label(plaza,"BENVENUTI!  •  CENTRAL PIAZZA",Color3.fromRGB(90,40,100))
 building(root,"QuestCenter",Vector3.new(-90,0,-120),Color3.fromRGB(255,160,70),60,42,45,"QUEST CENTER")
 building(root,"Bank",Vector3.new(90,0,-120),Color3.fromRGB(80,190,130),65,48,45,"BANCA")
 building(root,"Dealership",Vector3.new(-140,0,130),Color3.fromRGB(70,190,255),80,35,55,"MOTORI")
 building(root,"PremiumShop",Vector3.new(130,0,120),Color3.fromRGB(190,85,255),60,40,45,"GEM PALACE")
 end)
 district("market",function()
 -- marketplace is its own destination, with colored halls
 -- Session 20: the Bazaar floor is trimmed at the north end (280x580 ->
 -- 280x420, z 480..900). The old north forecourt (z 320..540) was 220
 -- studs of empty floor between the entrance and the first stall row;
 -- the entrance, signs, ramp and north glass walls all move south to
 -- z=480, 60 studs north of the stalls. The halls (z=860), south wall,
 -- east entrance gap (z 580..620) and east/west walls' south ends do NOT
 -- move. The floor still covers the stalls (z 540..620) and the halls.
 local market=model("BrainrotMarketplace");U.Part(market,"MarketFloor",Vector3.new(280,4,420),Vector3.new(0,1,690),Color3.fromRGB(35,35,58),Enum.Material.Marble)
 U.Label(U.Part(market,"MarketSign",Vector3.new(100,8,4),Vector3.new(0,30,480),Color3.fromRGB(255,80,175),Enum.Material.Neon),"BRAINROT BAZAAR",Color3.new(1,1,1))
 for i=1,8 do local x=-112+(i-1)*32;local rarity=({"COMMON","UNCOMMON","RARE","EPIC","LEGENDARY","MYTHIC","SECRET","DIVINE"})[i];local col=C.Rarities[rarity].Color;building(market,rarity.."Hall",Vector3.new(x,3,860),col,27,18,70,rarity) end
 -- Session 17: the Bazaar is now an ENCLOSED space, not an open field of
 -- stalls. Glass walls (12 tall, sitting on the floor top y=3) run around
 -- the whole floor, with two clear entrances: NORTH (a 40-stud gap
 -- at x -20..20, aligned with the MarketNorthRamp) and EAST (a 40-stud gap
 -- at z 580..620). The halls at z=860 sit inside the south wall.
 local function glassWall(name,size,pos) local w=U.Part(market,name,size,pos,Color3.fromRGB(180,230,255),Enum.Material.Glass);w.Transparency=.4;w.CanCollide=true;return w end
 glassWall("GlassWallNorthA",Vector3.new(120,12,.5),Vector3.new(-80,9,480))
 glassWall("GlassWallNorthB",Vector3.new(120,12,.5),Vector3.new(80,9,480))
 glassWall("GlassWallSouth",Vector3.new(280,12,.5),Vector3.new(0,9,900))
 glassWall("GlassWallEastA",Vector3.new(.5,12,100),Vector3.new(140,9,530))
 glassWall("GlassWallEastB",Vector3.new(.5,12,280),Vector3.new(140,9,760))
 glassWall("GlassWallWest",Vector3.new(.5,12,420),Vector3.new(-140,9,690))
 U.Label(U.Part(market,"MarketEntranceSign",Vector3.new(60,6,2),Vector3.new(0,16,480),Color3.fromRGB(255,80,175),Enum.Material.Neon),"BAZAAR  •  ENTER",Color3.new(1,1,1))
 end)
 district("nature",function()
 -- canal, bridge, tunnel, lakeshore/beach, hills, forest, mountain silhouettes
 -- Water and sand are flush inlays (top y=-0.95, a hair above the ground
 -- tiles) — the old tops at y=+0.5/+2.5 were ridges across the walking
 -- surface. The bridge is lowered so its top is a walkable 4.5-stud step.
 U.Part(root,"Canal",Vector3.new(2000,3,100),Vector3.new(0,-2.45,720),Color3.fromRGB(40,180,230),Enum.Material.Glass)
 U.Part(root,"CanalBridge",Vector3.new(190,7,145),Vector3.new(0,0,720),Color3.fromRGB(205,177,132),Enum.Material.Concrete)
 U.Part(root,"TunnelMound",Vector3.new(220,55,95),Vector3.new(-580,25,-720),Color3.fromRGB(93,102,116),Enum.Material.Rock);U.Part(root,"Tunnel",Vector3.new(54,30,98),Vector3.new(-580,12,-720),Color3.fromRGB(15,18,30),Enum.Material.Slate)
 U.Part(root,"Lake",Vector3.new(390,3,310),Vector3.new(800,-2.45,-750),Color3.fromRGB(55,190,235),Enum.Material.Glass)
 U.Part(root,"Beach",Vector3.new(420,3,90),Vector3.new(800,-2.45,-560),Color3.fromRGB(255,219,140),Enum.Material.Sand)
 for i=1,10 do local x=-1000+i*90;local z=500+math.sin(i)*60;local hill=U.Part(root,"Hill",Vector3.new(140,80,130),Vector3.new(x,39,z),Color3.fromRGB(74,170,94),Enum.Material.Grass);hill.Shape=Enum.PartType.Ball end
 -- Rounded outer-belt terrain keeps the roads, travel pads, stalls, and plots level.
 local hills={}
 for _,side in ipairs({-1,1}) do for _,xAbs in ipairs({1182,1228}) do for _,z in ipairs({270,470,670,870}) do
  local x=side*xAbs;local hill=U.Part(root,"RollingHill",Vector3.new(94,58,92),Vector3.new(x,28,z),Color3.fromRGB(75+(z%3)*4,174,96),Enum.Material.Grass);hill.Shape=Enum.PartType.Ball
  hills[#hills+1]={x=x,z=z,rx=47,rz=46}
 end end end
 -- Four decorative rings per side, with ramp positions filtered explicitly.
 local palmCount=0
 for _,side in ipairs({-1,1}) do for _,xAbs in ipairs({940,1060}) do for _,z in ipairs({250,470,690,910}) do
  local x=side*xAbs;local onRamp=math.abs(x)>=1084 and math.abs(x)<=1116
  if not onRamp then
   palmCount+=1;local trunk=U.Part(root,"PalmTrunk",Vector3.new(5,24,5),Vector3.new(x,11,z),Color3.fromRGB(137,91,52),Enum.Material.Wood);trunk.Shape=Enum.PartType.Cylinder
   local crown=U.Part(root,"PalmCrown",Vector3.new(18,12,18),Vector3.new(x,25,z),Color3.fromRGB(53,177,105),Enum.Material.Grass);crown.Shape=Enum.PartType.Ball
   for leaf=1,4 do local angle=leaf*math.pi/2;local frond=U.Part(root,"PalmFrond",Vector3.new(20,1.3,4),Vector3.new(x+math.cos(angle)*6,28,z+math.sin(angle)*6),Color3.fromRGB(70,198,112),Enum.Material.Grass);frond.CFrame=CFrame.new(frond.Position)*CFrame.Angles(0,-angle,math.rad(-12)) end
  end
 end end end
 local stoneCount=0
 for _,x in ipairs({-1020,-940,940,1020}) do for _,z in ipairs({270,470,670,870}) do
  local clear=true
  for _,hill in ipairs(hills) do local value=((x-hill.x)/hill.rx)^2+((z-hill.z)/hill.rz)^2;if value<=1 then clear=false;break end end
  if clear then stoneCount+=1;local stone=U.Part(root,"GardenStone",Vector3.new(8,6,7),Vector3.new(x,2,z),Color3.fromRGB(145,151,133),Enum.Material.Rock);stone.Shape=Enum.PartType.Ball end
 end end
 local movedFlowers=0
 for i=1,48 do local x=-1270+(i%12)*42;local z=330+math.floor(i/12)*145;if math.abs(x)==1102 then x=-1040;movedFlowers+=1 end;local flower=U.Part(root,"Wildflower",Vector3.new(3,3,3),Vector3.new(x,0.5,z),Color3.fromHSV((i*.13)%1,.7,1),Enum.Material.Neon);flower.Shape=Enum.PartType.Ball end
 warn("[IBW] Outer landscape: "..#hills.." rolling hills, "..palmCount.." palms, "..stoneCount.." clear stones, 48 wildflowers")
 local skippedYardTrees=0
 for i=1,80 do local x=-1050+(i%10)*70;local z=640+math.floor(i/10)*60;local inBaseYard=false;if z>=840 and z<=960 then for plot=1,8 do local plotX=-700+(plot-1)*180;if math.abs(x-plotX)<=70 then inBaseYard=true;break end end end;if inBaseYard then skippedYardTrees+=1 else local trunk=U.Part(root,"TreeTrunk",Vector3.new(5,16,5),Vector3.new(x,7,z),Color3.fromRGB(120,76,40),Enum.Material.Wood);local crown=U.Part(root,"TreeCrown",Vector3.new(21,24,21),Vector3.new(x,23,z),Color3.fromRGB((i%2==0) and 50 or 40,190,(i%3)*35),Enum.Material.Grass);crown.Shape=Enum.PartType.Ball end end
 warn("[IBW] Placement fixes: "..skippedYardTrees.." yard trees skipped, "..movedFlowers.." ramp flowers shifted")
 for i=1,12 do local x=-1100+i*100;local m=U.Part(root,"Mountain",Vector3.new(170,190,170),Vector3.new(x,94,-1030),Color3.fromRGB(112,130,150),Enum.Material.Rock);m.Shape=Enum.PartType.Ball end
 end)
 district("zones",function()
 -- village/industrial/luxury landmarks, residential blocks, street lights and colorful signs
 for i,zone in ipairs(C.Zones) do local pos=zone.Position;building(root,zone.Name.."District",pos+Vector3.new(0,0,100),zone.Color,125,65,90,zone.Name:upper()) end
 -- Each destination gets a different skyline marker, built from simple original Parts.
 local starter=Vector3.new(145,0,95)
 local tower=U.Part(root,"StarterClockTower",Vector3.new(18,72,18),starter+Vector3.new(0,35,0),Color3.fromRGB(255,190,65),Enum.Material.Brick)
 U.Part(root,"ClockTowerCap",Vector3.new(28,10,28),tower.Position+Vector3.new(0,40,0),Color3.fromRGB(235,82,90),Enum.Material.Slate)
 U.Label(tower,"PIAZZA CLOCKTOWER",Color3.new(1,1,1))
 local village=Vector3.new(-555,0,560)
 for _,side in ipairs({-1,1}) do local arch=U.Part(root,"VillageBellArch",Vector3.new(8,48,8),village+Vector3.new(side*24,23,0),Color3.fromRGB(245,222,165),Enum.Material.Brick); U.Part(root,"ArchSpan",Vector3.new(56,8,10),village+Vector3.new(0,46,0),Color3.fromRGB(220,75,67),Enum.Material.Brick); U.Part(root,"ArchFoot",Vector3.new(15,5,16),arch.Position+Vector3.new(0,-21.5,0),Color3.fromRGB(110,190,110),Enum.Material.Slate) end
 local neon=Vector3.new(850,0,-180)
 for i=1,3 do local sign=U.Part(root,"NeonSkylineSign",Vector3.new(5,72-i*12,5),neon+Vector3.new((i-2)*20,35-i*6,0),({Color3.fromRGB(255,65,190),Color3.fromRGB(50,235,255),Color3.fromRGB(185,95,255)})[i],Enum.Material.Neon); U.Part(root,"NeonSignBar",Vector3.new(24,3,2),sign.Position+Vector3.new(0,15,0),sign.Color,Enum.Material.Neon) end
 U.Label(U.Part(root,"NeonCrown",Vector3.new(4,4,4),neon+Vector3.new(0,68,0),Color3.fromRGB(255,220,75),Enum.Material.Neon),"NEON CROWN",Color3.new(1,1,1))
 local luxury=Vector3.new(950,0,555)
 local fountain=U.Part(root,"LuxuryFountainBasin",Vector3.new(62,5,62),luxury+Vector3.new(0,1.5,0),Color3.fromRGB(60,205,230),Enum.Material.Marble); fountain.Shape=Enum.PartType.Cylinder
 local fountainCore=U.Part(root,"LuxuryFountainSpire",Vector3.new(12,38,12),luxury+Vector3.new(0,23,0),Color3.fromRGB(255,225,130),Enum.Material.Marble)
 for i=1,4 do local orb=U.Part(root,"FountainOrb",Vector3.new(10,10,10),fountainCore.Position+Vector3.new(math.cos(i*math.pi/2)*19,10,math.sin(i*math.pi/2)*19),Color3.fromRGB(120,245,255),Enum.Material.Neon); orb.Shape=Enum.PartType.Ball end
 local sky=Vector3.new(1085,100,900)
 for i=1,3 do local cloud=U.Part(root,"SkyCloudIsland",Vector3.new(76-i*8,15,60-i*5),sky+Vector3.new((i-2)*72,math.sin(i)*15,(i-2)*45),Color3.fromRGB(235,250,255),Enum.Material.SmoothPlastic); cloud.Shape=Enum.PartType.Ball; U.Part(root,"IslandGrassCap",Vector3.new(64-i*7,6,49-i*4),cloud.Position+Vector3.new(0,9,0),Color3.fromRGB(90,220,155),Enum.Material.Grass) end
 local secret=Vector3.new(80,0,1125)
 for i=1,8 do local angle=i*math.pi/4;local pillar=U.Part(root,"RiftPillar",Vector3.new(5,30+(i%3)*7,5),secret+Vector3.new(math.cos(angle)*27,16,math.sin(angle)*27),Color3.fromRGB(180,80,255),Enum.Material.Neon); U.Part(root,"RiftRune",Vector3.new(9,2,2),pillar.Position+Vector3.new(0,7,0),Color3.fromRGB(85,245,255),Enum.Material.Neon) end
 local portal=U.Part(root,"SecretRiftPortal",Vector3.new(8,48,42),secret+Vector3.new(0,24,0),Color3.fromRGB(220,70,255),Enum.Material.Neon);portal.Shape=Enum.PartType.Cylinder;portal.Orientation=Vector3.new(0,0,90);portal.Transparency=.15;portal.CanCollide=false;U.Label(portal,"RIFT OF THE UNKNOWN",Color3.new(1,1,1))
 -- High contrast endgame districts have clear arrival platforms and visible landmarks.
 -- The Volcano rim is VISUAL ONLY (CanCollide off): it is a solid cylinder
 -- 250 wide spanning y -2..12, and the anchor (-1100,0,-800) and the
 -- VolcanoAnchorLanding (top y=-1) sit INSIDE it. With collision on, a
 -- player teleporting to Volcano arrives embedded in solid rock and cannot
 -- move. With collision off the player lands on the landing inside the
 -- crater, under the lava ceiling (lava spans y 12..16, 13 studs above
 -- the landing), and walks out through the rim wall onto open ground.
 local volcano=U.Part(root,"VolcanoRim",Vector3.new(250,14,250),Vector3.new(-1100,5,-800),Color3.fromRGB(49,42,50),Enum.Material.Rock);volcano.Shape=Enum.PartType.Cylinder;volcano.CanCollide=false
 local lava=U.Part(root,"LavaLake",Vector3.new(115,4,115),Vector3.new(-1100,14,-800),Color3.fromRGB(255,70,30),Enum.Material.Neon);lava.Shape=Enum.PartType.Cylinder
 local volcanoLanding=U.Part(root,"VolcanoAnchorLanding",Vector3.new(42,2,38),Vector3.new(-1100,-2,-800),Color3.fromRGB(49,42,50),Enum.Material.Rock)
 local peak=U.Part(root,"VolcanoPeak",Vector3.new(128,150,128),Vector3.new(-1100,74,-955),Color3.fromRGB(73,54,57),Enum.Material.Rock);peak.Shape=Enum.PartType.Wedge;peak.Orientation=Vector3.new(0,45,0)
 local crown=U.Part(root,"LavaPeakCrown",Vector3.new(34,20,34),Vector3.new(-1100,151,-955),Color3.fromRGB(255,91,38),Enum.Material.Neon);crown.Shape=Enum.PartType.Ball;U.Label(crown,"ERUZIONE PEAK",Color3.new(1,1,1))
 for i=1,7 do local x=-1200+(i%3)*85;local z=-890+math.floor(i/3)*75;building(root,"MythicForge"..i,Vector3.new(x,0,z),Color3.fromRGB(170,49,65),36,25,30,"MYTHIC FORGE") end
 for i=1,5 do local pos=Vector3.new(960+(i%2)*115,94,730+math.floor(i/2)*105);local island=U.Part(root,"SkyIsland",Vector3.new(95,10,78),pos,Color3.fromRGB(100,205,145),Enum.Material.Grass);island.Shape=Enum.PartType.Cylinder;U.Part(root,"SkyBridge",Vector3.new(110,5,12),pos+Vector3.new(80,4,30),Color3.fromRGB(245,195,100),Enum.Material.Wood) end
 for i=1,6 do building(root,"DivineSanctum"..i,Vector3.new(-160+(i-1)*64,2,1190),Color3.fromRGB(135,55,190),48,36,42,"DIVINE") end
 -- Arrival platforms stand 1 stud proud of the zone inlay (top y=0, a
 -- walkable step); travel-pad footings now meet the pad bottom exactly
 -- (footing top y=1 = pad bottom y=1 — the old 2-stud gap is closed).
 for _,zone in ipairs(C.Zones) do local landing=U.Part(root,zone.Name.."ArrivalPlatform",Vector3.new(42,2,38),zone.Position+Vector3.new(0,-1,0),zone.Color,Enum.Material.Concrete);landing.Transparency=.12;local pad=U.Part(root,zone.Name.."TravelPad",Vector3.new(25,2,25),zone.Position+Vector3.new(0,2,-70),zone.Color,Enum.Material.Neon);U.Label(pad,zone.Name.."  •  $"..zone.Requirement,Color3.new(1,1,1));pad:SetAttribute("ZoneName",zone.Name);local footing=U.Part(root,zone.Name.."TravelPadFooting",Vector3.new(27,2,27),zone.Position+Vector3.new(0,0,-70),zone.Color,Enum.Material.Concrete);pad:SetAttribute("ZoneName",zone.Name);local prompt=Instance.new("ProximityPrompt");prompt.ActionText="TRAVEL • $"..zone.Requirement.." • LV "..zone.Level.." • REBIRTH "..zone.Rebirths;prompt.ObjectText=zone.Name;prompt.MaxActivationDistance=16;prompt.RequiresLineOfSight=false;prompt.Parent=pad end
 -- The Sky travel pad sits in the gap between the SkyIsland rows (z 730
 -- and 835): a slab under it closes the hole so the footing has ground.
 local skySlab=U.Part(root,"SkyPadIsland",Vector3.new(30,10,30),Vector3.new(1100,94,780),Color3.fromRGB(100,205,145),Enum.Material.Grass);skySlab.Shape=Enum.PartType.Cylinder
 -- DESIGN EVERY WORLD: each zone gets a distinct ground inlay (140x140,
 -- top y=-0.95, flush with the roads) in its own colour/material plus
 -- themed props that sit ON the ground (bottoms at the walking surface),
 -- so every zone reads at a glance and none looks empty or unfinished.
 local inlayMaterials={Enum.Material.SmoothPlastic,Enum.Material.Cobblestone,Enum.Material.Neon,Enum.Material.Marble,Enum.Material.Slate,Enum.Material.SmoothPlastic,Enum.Material.Neon}
 for zi,zone in ipairs(C.Zones) do local pos=zone.Position;local gy=pos.Y-1
  local inlay=U.Part(root,zone.Name.."GroundInlay",Vector3.new(140,1,140),pos+Vector3.new(0,-0.45,0),zone.Color,inlayMaterials[zi]);inlay.Transparency=.25
  local function prop(name,size,offset,color,material,shape) local p=U.Part(root,name,size,pos+offset,color,material);if shape then p.Shape=shape end;return p end
  if zone.Name=="Starter City" then
   for _,sx in ipairs({-1,1}) do for _,sz in ipairs({-1,1}) do local lamp=prop("StarterLamp",Vector3.new(2,10,2),Vector3.new(sx*60,gy+5,sz*40),Color3.fromRGB(60,60,75),Enum.Material.Metal);prop("StarterLampGlow",Vector3.new(6,6,6),Vector3.new(sx*60,gy+11,sz*40),Color3.fromRGB(255,235,140),Enum.Material.Neon,Enum.PartType.Ball) end end
   for _,sx in ipairs({-1,1}) do prop("StarterBench",Vector3.new(10,2,4),Vector3.new(sx*40,gy+1,60),Color3.fromRGB(150,90,40),Enum.Material.Wood);prop("StarterBenchBack",Vector3.new(10,4,1),Vector3.new(sx*40,gy+3,62),Color3.fromRGB(150,90,40),Enum.Material.Wood) end
  elseif zone.Name=="Italian Village" then
   for _,off in ipairs({Vector3.new(-55,0,55),Vector3.new(55,0,55),Vector3.new(0,0,-55)}) do local trunk=prop("OliveTrunk",Vector3.new(4,12,4),off+Vector3.new(0,gy+6,0),Color3.fromRGB(120,76,40),Enum.Material.Wood);prop("OliveCrown",Vector3.new(16,12,16),off+Vector3.new(0,gy+16,0),Color3.fromRGB(110,160,60),Enum.Material.Grass,Enum.PartType.Ball) end
   local well=prop("VillageWell",Vector3.new(12,6,12),Vector3.new(45,gy+3,-45),Color3.fromRGB(180,170,150),Enum.Material.Concrete);well.Shape=Enum.PartType.Cylinder;prop("WellRoof",Vector3.new(16,2,16),Vector3.new(45,gy+6,-45),Color3.fromRGB(220,75,67),Enum.Material.Slate)
  elseif zone.Name=="Neon City" then
   for _,off in ipairs({Vector3.new(-50,0,0),Vector3.new(50,0,0),Vector3.new(0,0,50)}) do local strip=prop("NeonStrip",Vector3.new(30,0.2,2),off+Vector3.new(0,gy+0.1,0),Color3.fromRGB(255,65,190),Enum.Material.Neon) end
   for _,off in ipairs({Vector3.new(-60,0,-50),Vector3.new(60,0,50),Vector3.new(-60,0,50)}) do local pylon=prop("NeonPylon",Vector3.new(4,26,4),off+Vector3.new(0,gy+13,0),Color3.fromRGB(50,235,255),Enum.Material.Neon) end
  elseif zone.Name=="Luxury District" then
   for _,off in ipairs({Vector3.new(-55,0,-55),Vector3.new(55,0,-55),Vector3.new(-55,0,55),Vector3.new(55,0,55)}) do local pillar=prop("GoldPillar",Vector3.new(6,20,6),off+Vector3.new(0,gy+10,0),Color3.fromRGB(255,215,0),Enum.Material.Metal);pillar.Shape=Enum.PartType.Cylinder end
   prop("RedCarpet",Vector3.new(20,0.2,60),Vector3.new(0,gy+0.1,0),Color3.fromRGB(200,30,60),Enum.Material.Fabric)
   for _,off in ipairs({Vector3.new(-35,0,0),Vector3.new(35,0,0)}) do prop("Topiary",Vector3.new(10,10,10),off+Vector3.new(0,gy+5,0),Color3.fromRGB(40,160,70),Enum.Material.Grass,Enum.PartType.Ball) end
  elseif zone.Name=="Volcano" then
   for _,off in ipairs({Vector3.new(-60,0,60),Vector3.new(60,0,60),Vector3.new(-60,0,-60),Vector3.new(60,0,-60)}) do prop("EmberRock",Vector3.new(9,9,9),off+Vector3.new(0,gy+4.5,0),Color3.fromRGB(90,30,20),Enum.Material.Rock,Enum.PartType.Ball) end
   for _,off in ipairs({Vector3.new(-35,0,35),Vector3.new(35,0,-35)}) do local spike=prop("ObsidianSpike",Vector3.new(6,14,6),off+Vector3.new(0,gy+7,0),Color3.fromRGB(25,20,35),Enum.Material.Slate);spike.Shape=Enum.PartType.Wedge end
  elseif zone.Name=="Sky Islands" then
   for _,off in ipairs({Vector3.new(-55,0,55),Vector3.new(55,0,-55),Vector3.new(0,0,55)}) do prop("CloudPuff",Vector3.new(16,10,16),off+Vector3.new(0,gy+5,0),Color3.fromRGB(235,250,255),Enum.Material.SmoothPlastic,Enum.PartType.Ball) end
   for _,off in ipairs({Vector3.new(-40,0,-40),Vector3.new(40,0,40)}) do prop("SkyStar",Vector3.new(6,6,6),off+Vector3.new(0,gy+3,0),Color3.fromRGB(255,220,75),Enum.Material.Neon,Enum.PartType.Ball) end
  elseif zone.Name=="Secret Dimension" then
   for _,off in ipairs({Vector3.new(-50,0,50),Vector3.new(50,0,-50),Vector3.new(50,0,50)}) do local crystal=prop("RiftCrystal",Vector3.new(6,14,6),off+Vector3.new(0,gy+7,0),Color3.fromRGB(180,80,255),Enum.Material.Neon);crystal.Orientation=Vector3.new(0,45,0) end
   for _,off in ipairs({Vector3.new(-35,0,-35),Vector3.new(35,0,35)}) do local rune=prop("RuneCircle",Vector3.new(24,0.5,24),off+Vector3.new(0,gy+0.15,0),Color3.fromRGB(85,245,255),Enum.Material.Neon);rune.Shape=Enum.PartType.Cylinder end
  end
 end
 for i=1,22 do local x=-900+(i%11)*180;local z=-500+math.floor(i/11)*850;building(root,"Residence_"..i,Vector3.new(x,0,z),Color3.fromHSV((i*.071)%1,.45,.95),52,24+(i%3)*6,48) end
 end)
 district("zoneroads",function()
 -- Session 20: WALKABLE ROUTES between cities + INVISIBLE BARRIERS.
 -- Before this session the only way between cities was the Map or a
 -- travel pad. Now every zone is also reachable on foot from Starter
 -- City on a 16-stud cobble road (flush inlay, top y=-0.9, gold edge
 -- strips so the route reads clearly), with a signpost at each branch.
 -- All routes were checked against every building footprint with a
 -- half-width-8 clearance audit; the only real blocker was the Bank on
 -- the Starter-market spur, which routes around it to the east.
 -- Landings, anchors, stalls and markets do NOT move; Map travel and
 -- travel pads work exactly as before.
 local roads=model("ZoneRoads")
 local function road(name,x1,z1,x2,z2)
  -- one axis-aligned leg; the road is a flush cobble inlay (1 thick,
  -- centre y=-1.4, top y=-0.9, 0.05 above the ground/avenue inlays so
  -- it never z-fights) with a 1-stud gold strip along each edge.
  local len=math.max(math.abs(x2-x1),math.abs(z2-z1))
  local cx,cz=(x1+x2)/2,(z1+z2)/2
  local horizontal=z1==z2
  local size=horizontal and Vector3.new(len,1,16) or Vector3.new(16,1,len)
  U.Part(roads,name,size,Vector3.new(cx,-1.4,cz),Color3.fromRGB(205,177,132),Enum.Material.Cobblestone)
  local edge=horizontal and Vector3.new(len,0.2,1) or Vector3.new(1,0.2,len)
  local off=horizontal and Vector3.new(0,0,7.5) or Vector3.new(7.5,0,0)
  U.Part(roads,name.."EdgeA",edge,Vector3.new(cx,-0.95,cz)+off,Color3.fromRGB(212,175,55),Enum.Material.Metal)
  U.Part(roads,name.."EdgeB",edge,Vector3.new(cx,-0.95,cz)-off,Color3.fromRGB(212,175,55),Enum.Material.Metal)
 end
 -- shared trunks out of the Starter plaza (plaza edge at +/-90)
 road("TrunkE",90,0,1000,0) -- east trunk: Luxury, Sky, Secret
 road("TrunkW",-90,0,-1000,0) -- west trunk: Volcano
 road("TrunkN",0,-90,0,290) -- south trunk (avenue): Italian
 -- Italian Village: south on the avenue, west along z=290, stub to the slab
 road("ItalianW",0,290,-700,290)
 road("ItalianS",-700,290,-700,310)
 -- Neon City: east along z=-80, north on x=200, east along z=-300 to the slab
 road("NeonE1",90,-80,200,-80)
 road("NeonN",200,-80,200,-300)
 road("NeonE2",200,-300,560,-300)
 -- Luxury District: east on the trunk, south on x=800 to the slab
 road("LuxuryS1",800,0,800,300)
 road("LuxuryS2",800,300,800,510)
 -- Volcano: west on the trunk, north on x=-1000, east along z=-800 to the slab
 road("VolcanoN1",-1000,0,-1000,-300)
 road("VolcanoN2",-1000,-300,-1000,-800)
 road("VolcanoE",-1000,-800,-960,-800)
 -- Sky Islands: east on the trunk, south on x=1000, east along z=500 to the ramp
 road("SkyS",1000,0,1000,500)
 road("SkyE",1000,500,1160,500)
 -- Secret Dimension: east on the trunk, south on x=290, west along z=1050 to the slab
 road("SecretS1",290,0,290,300)
 road("SecretS2",290,300,290,1050)
 road("SecretW",290,1050,140,1050)
 -- Starter-market spur: around the Bank (which blocks a direct z=-130
 -- run) to the market's west entrance gap at (220,-130)
 road("StarterMkt1",90,-60,200,-60)
 road("StarterMkt2",200,-60,200,-130)
 road("StarterMkt3",200,-130,220,-130)
 -- Sky ramp: the Sky Islands slab floats at y=99, so the ground road ends
 -- at the ramp base (1160,500) and a 21.8deg cobble ramp climbs 100 studs
 -- to the main island (landing at 1160,750, top flush with the island).
 -- The ramp runs EAST of the Sky market island (which ends at x=1145),
 -- and its side rails keep a player from walking off the edge.
 local rampLen=math.sqrt(250*250+100*100)
 local ramp=U.Part(roads,"SkyRamp",Vector3.new(16,2,rampLen),Vector3.new(1160,48,625),Color3.fromRGB(205,177,132),Enum.Material.Cobblestone)
 ramp.CFrame=CFrame.new(1160,48,625)*CFrame.Angles(math.rad(-21.8),0,0)
 for _,side in ipairs({-1,1}) do
  local rail=U.Part(roads,"SkyRampRail"..(side<0 and "W" or "E"),Vector3.new(1,4,rampLen),Vector3.new(0,0,0),Color3.fromRGB(212,175,55),Enum.Material.Metal)
  rail.CFrame=ramp.CFrame*CFrame.new(side*7.5,3,0)
 end
 -- signposts at each branch, so a player on foot can read where a road goes
 local function signpost(name,pos,text)
  U.Part(roads,name.."Post",Vector3.new(2,8,2),pos+Vector3.new(0,3,0),Color3.fromRGB(120,72,20),Enum.Material.Wood)
  U.Label(U.Part(roads,name,Vector3.new(56,10,2),pos+Vector3.new(0,8,0),Color3.fromRGB(255,220,120),Enum.Material.Wood),text,Color3.new(0.15,0.1,0.05))
 end
 signpost("SignItalian",Vector3.new(12,0,60),"TO ITALIAN VILLAGE")
 signpost("SignNeon",Vector3.new(190,0,-70),"TO NEON CITY")
 signpost("SignLuxury",Vector3.new(810,0,10),"TO LUXURY DISTRICT")
 signpost("SignVolcano",Vector3.new(-1010,0,10),"TO VOLCANO")
 signpost("SignSky",Vector3.new(1010,0,10),"TO SKY ISLANDS")
 signpost("SignSecret",Vector3.new(300,0,10),"TO SECRET DIMENSION")
 signpost("SignStarterMkt",Vector3.new(100,0,-70),"TO STARTER MARKET")
 -- ZONE BARRIERS: one invisible (transparent, CanCollide) wall across
 -- each zone's road entrance. ZoneBarrierService (server) enforces them:
 -- a locked player is stopped and shown the gate requirements; an
 -- unlocked player walks through (the barrier opens for 3s and the zone
 -- is marked unlocked, so its stalls can be bought from). ApproachDir
 -- points from the zone back toward the road (the direction a player is
 -- bounced when they are on the zone side while locked).
 local function zoneBarrier(name,zoneName,pos,size,approach)
  local b=U.Part(roads,name,size,pos,Color3.fromRGB(255,255,255),Enum.Material.SmoothPlastic)
  b.Transparency=1;b.CanCollide=true;b.CanQuery=true
  b:SetAttribute("ZoneName",zoneName);b:SetAttribute("ApproachDir",approach)
  return b
 end
 zoneBarrier("ZoneBarrier_Italian","Italian Village",Vector3.new(-700,5,308),Vector3.new(20,12,1),Vector3.new(0,0,-1))
 zoneBarrier("ZoneBarrier_Neon","Neon City",Vector3.new(560,5,-300),Vector3.new(1,12,20),Vector3.new(-1,0,0))
 zoneBarrier("ZoneBarrier_Luxury","Luxury District",Vector3.new(800,5,510),Vector3.new(20,12,1),Vector3.new(0,0,-1))
 zoneBarrier("ZoneBarrier_Volcano","Volcano",Vector3.new(-960,5,-800),Vector3.new(1,12,20),Vector3.new(1,0,0))
 zoneBarrier("ZoneBarrier_Sky","Sky Islands",Vector3.new(1160,5,500),Vector3.new(20,12,1),Vector3.new(0,0,-1))
 zoneBarrier("ZoneBarrier_Secret","Secret Dimension",Vector3.new(140,5,1050),Vector3.new(1,12,20),Vector3.new(1,0,0))
 -- WORLD-EDGE BARRIERS: invisible walls around the whole world so a
 -- player can never walk off a slab and fall into the void. The south
 -- edge steps out to z=1200 around the Secret slab (z 1000..1200),
 -- which is the only slab that pokes past the ground tiles (z=1100).
 local function edgeBarrier(name,size,pos)
  local w=U.Part(roads,name,size,pos,Color3.fromRGB(255,255,255),Enum.Material.SmoothPlastic)
  w.Transparency=1;w.CanCollide=true;w.CanQuery=true
  return w
 end
 edgeBarrier("WorldEdge_North",Vector3.new(2600,20,1),Vector3.new(0,9,-1100))
 edgeBarrier("WorldEdge_West",Vector3.new(1,20,2200),Vector3.new(-1300,9,0))
 edgeBarrier("WorldEdge_East",Vector3.new(1,20,2200),Vector3.new(1300,9,0))
 edgeBarrier("WorldEdge_SouthW",Vector3.new(1160,20,1),Vector3.new(-720,9,1100))
 edgeBarrier("WorldEdge_SouthE",Vector3.new(1160,20,1),Vector3.new(720,9,1100))
 edgeBarrier("WorldEdge_SouthSecret",Vector3.new(280,20,1),Vector3.new(0,9,1200))
 edgeBarrier("WorldEdge_SouthConnW",Vector3.new(1,20,100),Vector3.new(-140,9,1150))
 edgeBarrier("WorldEdge_SouthConnE",Vector3.new(1,20,100),Vector3.new(140,9,1150))
 end)
 district("landscapes",function()
 -- Session 17 JOB 1: every zone sits on its OWN landscape, not the shared
 -- flat green ground with a 140x140 inlay. Each zone gets a large ground
 -- slab (280x280, top y=-0.9, flush with the roads) in its own ground
 -- colour/material, plus terrain features that read at a glance. The slab
 -- is under the zone inlay (inlay top y=0.05), the arrival platform
 -- (top y=0) and the travel-pad footing (bottom y=-1, embedded 0.1 into
 -- the slab) — nothing floats, nothing is buried. Anchors, pads, platforms
 -- and stall positions do NOT move.
 local function slab(name,size,pos,color,material) local s=U.Part(root,name,size,pos,color,material);return s end
 -- Starter City: paved piazza stone.
 slab("StarterLandscape",Vector3.new(280,1,280),Vector3.new(0,-1.4,0),Color3.fromRGB(200,190,170),Enum.Material.Cobblestone)
 for _,sx in ipairs({-1,1}) do for _,sz in ipairs({-1,1}) do local planter=U.Part(root,"PiazzaPlanter",Vector3.new(14,4,14),Vector3.new(sx*100,-0.9+2,sz*100),Color3.fromRGB(150,140,120),Enum.Material.Concrete);U.Part(root,"PlanterBloom",Vector3.new(10,6,10),planter.Position+Vector3.new(0,4,0),Color3.fromRGB(255,120,180),Enum.Material.Grass).Shape=Enum.PartType.Ball end end
 for _,z in ipairs({-85,85}) do U.Part(root,"PiazzaBorder",Vector3.new(170,1,4),Vector3.new(0,-1.4,z),Color3.fromRGB(120,115,105),Enum.Material.Slate) end
 for _,x in ipairs({-85,85}) do U.Part(root,"PiazzaBorder",Vector3.new(4,1,170),Vector3.new(x,-1.4,0),Color3.fromRGB(120,115,105),Enum.Material.Slate) end
 -- Italian Village: warm terracotta ground, cobbled lane, cottages.
 slab("VillageLandscape",Vector3.new(280,1,280),Vector3.new(-700,-1.4,450),Color3.fromRGB(205,170,120),Enum.Material.Cobblestone)
 U.Part(root,"VillageLane",Vector3.new(280,1,8),Vector3.new(-700,-1.35,580),Color3.fromRGB(150,120,90),Enum.Material.Cobblestone)
 for _,c in ipairs({Vector3.new(-820,0,520),Vector3.new(-580,0,320)}) do building(root,"VillageCottage",c,Color3.fromRGB(245,220,180),30,18,26,"CASA") end
 -- Neon City: dark night ground, glowing grid (skips the platform/pad
 -- columns and rows so no neon strip runs under a landing).
 slab("NeonLandscape",Vector3.new(280,1,280),Vector3.new(700,-1.4,-400),Color3.fromRGB(20,22,35),Enum.Material.Slate)
 for _,z in ipairs({-520,-440,-360,-280}) do U.Part(root,"NeonGridStrip",Vector3.new(280,.2,2),Vector3.new(700,-0.85,z),Color3.fromRGB(255,65,190),Enum.Material.Neon) end
 for _,x in ipairs({580,660,740,820}) do U.Part(root,"NeonGridStrip",Vector3.new(2,.2,280),Vector3.new(x,-0.85,-400),Color3.fromRGB(50,235,255),Enum.Material.Neon) end
 for _,a in ipairs({Vector3.new(580,0,-280),Vector3.new(820,0,-520)}) do local arch=U.Part(root,"NeonArch",Vector3.new(4,22,4),a+Vector3.new(0,10,0),Color3.fromRGB(185,95,255),Enum.Material.Neon);U.Part(root,"NeonArchTop",Vector3.new(24,3,3),a+Vector3.new(0,21,0),Color3.fromRGB(185,95,255),Enum.Material.Neon) end
 -- Luxury District: white marble ground, gold trim, statues.
 slab("LuxuryLandscape",Vector3.new(280,1,280),Vector3.new(800,-1.4,650),Color3.fromRGB(240,235,225),Enum.Material.Marble)
 for _,z in ipairs({510,790}) do U.Part(root,"GoldTrim",Vector3.new(280,1,3),Vector3.new(800,-1.35,z),Color3.fromRGB(255,215,0),Enum.Material.Metal) end
 for _,s in ipairs({Vector3.new(670,0,780),Vector3.new(930,0,520)}) do local ped=U.Part(root,"MarbleStatuePedestal",Vector3.new(10,6,10),s+Vector3.new(0,2,0),Color3.fromRGB(245,245,240),Enum.Material.Marble);U.Part(root,"MarbleStatue",Vector3.new(6,14,6),ped.Position+Vector3.new(0,9,0),Color3.fromRGB(255,215,0),Enum.Material.Metal).Shape=Enum.PartType.Ball end
 -- Volcano: black basalt ground, lava flows radiating outside the rim
 -- (rim radius 125; flows at radius ~135, clear of the platform and pad),
 -- obsidian boulders and ash mounds just outside the rim.
 slab("VolcanoLandscape",Vector3.new(280,1,280),Vector3.new(-1100,-1.4,-800),Color3.fromRGB(30,28,32),Enum.Material.Slate)
 for _,f in ipairs({Vector3.new(-965,-800),Vector3.new(-1235,-800),Vector3.new(-1100,-665),Vector3.new(-1100,-935)}) do local flow=U.Part(root,"LavaFlow",Vector3.new(24,.4,5),Vector3.new(f.X,-0.7,f.Y),Color3.fromRGB(255,90,30),Enum.Material.Neon);if f.X==-1100 then flow.Size=Vector3.new(5,.4,24) end end
 for _,b in ipairs({Vector3.new(-1200,-700),Vector3.new(-1000,-700),Vector3.new(-1200,-900),Vector3.new(-1000,-900)}) do local rock=U.Part(root,"ObsidianBoulder",Vector3.new(12,10,12),Vector3.new(b.X,4,b.Y),Color3.fromRGB(25,20,35),Enum.Material.Slate);rock.Shape=Enum.PartType.Ball end
 for _,m in ipairs({Vector3.new(-1150,-680),Vector3.new(-1050,-920)}) do local ash=U.Part(root,"AshMound",Vector3.new(18,6,18),Vector3.new(m.X,2,m.Y),Color3.fromRGB(120,115,110),Enum.Material.Sand);ash.Shape=Enum.PartType.Ball end
 -- Sky Islands: a big floating island (top y=99, matching the island tops)
 -- plus clouds and two satellite islands — the zone is IN the sky, not on
 -- the ground. The market island slab gives the Sky market solid ground.
 local skyDisc=U.Part(root,"SkyMainIsland",Vector3.new(200,8,200),Vector3.new(1100,95,850),Color3.fromRGB(100,205,145),Enum.Material.Grass);skyDisc.Shape=Enum.PartType.Cylinder
 for _,c in ipairs({Vector3.new(1010,86,780),Vector3.new(1190,88,920),Vector3.new(1020,84,920),Vector3.new(1180,86,780)}) do local cloud=U.Part(root,"SkyCloud",Vector3.new(30,14,30),c,Color3.fromRGB(235,250,255),Enum.Material.SmoothPlastic);cloud.Shape=Enum.PartType.Ball end
 for _,s in ipairs({Vector3.new(950,92,780),Vector3.new(1250,92,920)}) do local isl=U.Part(root,"SkySatelliteIsland",Vector3.new(60,6,60),s,Color3.fromRGB(100,205,145),Enum.Material.Grass);isl.Shape=Enum.PartType.Cylinder end
 local mktIsland=U.Part(root,"SkyMarketIsland",Vector3.new(140,10,120),Vector3.new(1075,94,730),Color3.fromRGB(100,205,145),Enum.Material.Grass);mktIsland.Shape=Enum.PartType.Cylinder
 -- Secret Dimension: dark purple rift ground. The slab is 280x200 centred
 -- on the anchor (z 1000..1200) so it never overlaps the base plots, which
 -- end at z=960. Floating shards and dark spires at the corners, clear of
 -- the market grid, the platform and the pad.
 slab("SecretLandscape",Vector3.new(280,1,200),Vector3.new(0,-1.4,1100),Color3.fromRGB(40,25,60),Enum.Material.Slate)
 for _,s in ipairs({Vector3.new(-120,1020),Vector3.new(120,1020),Vector3.new(-120,1180)}) do U.Part(root,"DarkSpire",Vector3.new(6,26,6),s+Vector3.new(0,12,0),Color3.fromRGB(90,40,160),Enum.Material.Neon) end
 for _,s in ipairs({Vector3.new(80,12,1050),Vector3.new(-80,14,1150)}) do local shard=U.Part(root,"FloatingShard",Vector3.new(8,14,8),s,Color3.fromRGB(180,80,255),Enum.Material.Neon);shard.Shape=Enum.PartType.Wedge;shard.Orientation=Vector3.new(0,45,0) end
 end)
 district("city",function()
 for i=1,10 do local x=-900+i*90;local light=U.Part(root,"StreetLamp",Vector3.new(2,24,2),Vector3.new(x,11,-200),Color3.fromRGB(60,60,75),Enum.Material.Metal);U.Part(root,"LampGlow",Vector3.new(7,1,7),light.Position+Vector3.new(0,12,0),Color3.fromRGB(255,235,140),Enum.Material.Neon) end
 -- recognizable city services and playful landmarks anchor exploration
 building(root,"Trattoria Bellissimo",Vector3.new(-320,0,160),Color3.fromRGB(245,105,90),72,30,52,"TRATTORIA • PASTA & PIZZA")
 building(root,"Gelateria",Vector3.new(320,0,-150),Color3.fromRGB(100,220,235),55,26,45,"GELATO!")
 building(root,"Benzina Station",Vector3.new(640,0,120),Color3.fromRGB(250,210,65),80,18,65,"BENZINA • FULL SERVICE")
 building(root,"Factory Corner",Vector3.new(-820,0,-250),Color3.fromRGB(125,135,150),110,38,100,"OFFICINA INDUSTRIALE")
 for _,z in ipairs({-200,200,600}) do for _,x in ipairs({-400,0,400}) do
  local signal=U.Part(root,"TrafficLight",Vector3.new(2,15,2),Vector3.new(x+19,6.5,z+19),Color3.fromRGB(40,43,55),Enum.Material.Metal)
  for j=1,3 do U.Part(root,"SignalLamp",Vector3.new(3,3,2),signal.Position+Vector3.new(0,6-j*3,0),({Color3.fromRGB(255,60,60),Color3.fromRGB(255,205,50),Color3.fromRGB(60,255,110)})[j],Enum.Material.Neon) end
  for k=1,5 do U.Part(root,"CrosswalkStripe",Vector3.new(3,.25,24),Vector3.new(x-20+k*5,-1.025,z+20),Color3.fromRGB(245,245,245)) end
 end end
 local statue=U.Part(root,"TralaleroStatue",Vector3.new(18,42,18),Vector3.new(0,20,-250),Color3.fromRGB(70,160,255),Enum.Material.Neon);statue.Shape=Enum.PartType.Ball;U.Label(statue,"TRALALERO TRALALA",Color3.fromRGB(255,220,70))
 local park=U.Part(root,"PalmPark",Vector3.new(180,2,120),Vector3.new(450,-1.95,260),Color3.fromRGB(90,205,120),Enum.Material.Grass);U.Label(park,"GIARDINO DELLE STELLE",Color3.fromRGB(255,255,255))
 -- North ramp into the market: the market floor top is y=3, the ground is
 -- y=-1, so a 4-stud step. A 16-stud ramp at -14deg (top meets the floor
 -- at z=320 and the ground at z=304) makes the entry smooth.
 -- Session 20: moved south to z=472 so its top meets the trimmed Bazaar
 -- floor's north edge (z=480); the ramp's bottom is at z=464 on the ground.
 local ramp=U.Part(root,"MarketNorthRamp",Vector3.new(280,0.5,16),Vector3.new(0,0.75,472),Color3.fromRGB(205,177,132),Enum.Material.Concrete);ramp.CFrame=CFrame.new(0,0.75,472)*CFrame.Angles(math.rad(-14),0,0)
 -- three physical travel beacons; server handler checks the destination and moves the character
 for _,entry in ipairs({{"PLAZZA FAST TRAVEL",Vector3.new(0,0,85),Color3.fromRGB(80,220,255),"City"},{"BAZAAR FAST TRAVEL",Vector3.new(0,0,300),Color3.fromRGB(255,80,180),"Market"}}) do
  local pad=U.Part(root,entry[1],Vector3.new(16,2,16),entry[2],entry[3],Enum.Material.Neon);local prompt=Instance.new("ProximityPrompt");prompt.ActionText="TRAVEL";prompt.ObjectText=entry[1];prompt.MaxActivationDistance=16;prompt.RequiresLineOfSight=false;prompt.Parent=pad;pad:SetAttribute("TravelTarget",entry[4])
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
