local C=require(game.ReplicatedStorage.Modules.Config)
local U=require(game.ReplicatedStorage.Modules.Util)
local B={}

local function part(m,n,size,p,color,material,shape)
 local v=U.Part(m,n,size,p,color,material or Enum.Material.SmoothPlastic)
 if shape then v.Shape=shape end
 v.CanCollide=false
 return v
end
local function ball(m,n,size,p,color,material)return part(m,n,size,p,color,material,Enum.PartType.Ball)end
local function wedge(m,n,size,p,color,rotation)
 local v=part(m,n,size,p,color,Enum.Material.SmoothPlastic,Enum.PartType.Wedge)
 if rotation then v.Orientation=rotation end
 return v
end
local function face(m,p,headSize,fur,eyeColor)
 -- Chibi face (session 17): oversized round eyes with a shine dot and pink
 -- blush cheeks, like the chibi reference sheet — big expressive eyes are
 -- the look. Eye size scales with the head, so every character reads chibi.
 -- The front of the head is at -Z (p.Z - headSize.Z*.51); a smaller z is
 -- further OUT, so the pupil (front-.2) sits on top of the white (front-.08).
 local front=p.Z-headSize.Z*.51
 local eyeW=headSize.X*.32;local eyeH=headSize.Y*.38
 for _,side in ipairs({-1,1}) do
  ball(m,"EyeWhite",Vector3.new(eyeW,eyeH,.2),p+Vector3.new(side*headSize.X*.21,.28,front-.08),Color3.new(1,1,1))
  ball(m,"Pupil",Vector3.new(eyeW*.5,eyeH*.55,.12),p+Vector3.new(side*headSize.X*.21,.22,front-.2),eyeColor or Color3.fromRGB(45,38,55),Enum.Material.Neon)
  ball(m,"EyeShine",Vector3.new(eyeW*.2,eyeH*.2,.06),p+Vector3.new(side*headSize.X*.21-eyeW*.12,.42,front-.28),Color3.new(1,1,1),Enum.Material.Neon)
  ball(m,"Blush",Vector3.new(eyeW*.42,eyeH*.26,.1),p+Vector3.new(side*headSize.X*.36,-.32,front-.1),Color3.fromRGB(255,150,170),Enum.Material.Neon)
 end
 ball(m,"Nose",Vector3.new(headSize.X*.13,.3,.2),p+Vector3.new(0,-.27,front-.12),fur)
end
local function feet(m,p,color,spread)
 for _,side in ipairs({-1,1}) do
  ball(m,"Leg",Vector3.new(.72,1.25,.75),p+Vector3.new(side*spread,-1.55,0),color)
  part(m,"Sneaker",Vector3.new(1.15,.55,1.55),p+Vector3.new(side*spread,-2.1,-.35),side<0 and Color3.fromRGB(255,70,100) or Color3.fromRGB(65,190,255),Enum.Material.SmoothPlastic)
 end
end
local function shark(m,p,c,g)
 local body=wedge(m,"SharkBody",Vector3.new(5.5,3.5,4.7),p,c,Vector3.new(0,0,90));m.PrimaryPart=body
 ball(m,"SharkHead",Vector3.new(3.9,3.5,3.6),p+Vector3.new(0,1.25,-.3),c);face(m,p+Vector3.new(0,1.25,-.3),Vector3.new(3.9,3.5,3.6),Color3.fromRGB(250,245,225))
 wedge(m,"DorsalFin",Vector3.new(1.7,2,.65),p+Vector3.new(0,2.45,.6),g)
 for _,s in ipairs({-1,1}) do wedge(m,"PectoralFin",Vector3.new(2.5,.55,1.3),p+Vector3.new(s*2,-.15,.2),g,Vector3.new(0,0,s*16)) end
 wedge(m,"TailFin",Vector3.new(2.4,2.2,.7),p+Vector3.new(0,.1,3),c)
 feet(m,p,Color3.fromRGB(50,70,120),1.25)
end
local function bombardiro(m,p,c,g)
 local body=part(m,"CrocodileBomberBody",Vector3.new(7,2.7,3),p,c);m.PrimaryPart=body
 local snout=part(m,"LongCrocSnout",Vector3.new(3.2,1.25,2.2),p+Vector3.new(0,-.25,-2.25),Color3.fromRGB(95,190,75));ball(m,"Nostril",Vector3.new(.4,.3,.35),snout.Position+Vector3.new(0,.7,-.7),Color3.fromRGB(35,80,40))
 ball(m,"PilotHead",Vector3.new(3.2,3.0,3.0),p+Vector3.new(0,1.1,-.7),Color3.fromRGB(100,200,85));face(m,p+Vector3.new(0,1.1,-.7),Vector3.new(3.2,3.0,3.0),Color3.fromRGB(100,200,85))
 for _,s in ipairs({-1,1}) do part(m,"BomberWing",Vector3.new(5.2,.45,1.9),p+Vector3.new(s*1.8,.15,.4),Color3.fromRGB(190,205,215),Enum.Material.Metal);for i=1,3 do wedge(m,"CrocodileTooth",Vector3.new(.48,.65,.5),p+Vector3.new(-1.1+i*.55,-.82,-2.65),Color3.new(1,1,1),Vector3.new(0,0,180)) end
  local prop=part(m,"Propeller",Vector3.new(.3,2.8,.28),p+Vector3.new(s*4.2,.35,.55),g,Enum.Material.Metal);prop.Orientation=Vector3.new(0,0,32)
 end
 wedge(m,"Tail",Vector3.new(1.3,1.3,2.5),p+Vector3.new(0,.2,2.6),c);ball(m,"Cockpit",Vector3.new(1.7,1.4,1.4),p+Vector3.new(0,1.85,.45),Color3.fromRGB(75,210,255),Enum.Material.Glass)
end
local function tung(m,p,c,g)
 local log=part(m,"WoodenLogBody",Vector3.new(3.2,5.2,3.2),p,Color3.fromRGB(151,94,48),Enum.Material.Wood,Enum.PartType.Cylinder);log.Orientation=Vector3.new(0,0,90);m.PrimaryPart=log
 part(m,"BarkStripe",Vector3.new(3.25,.25,3.25),p+Vector3.new(0,.8,0),Color3.fromRGB(105,62,35),Enum.Material.Wood)
 ball(m,"LogFace",Vector3.new(2.5,2.5,2.3),p+Vector3.new(0,1.05,-1.1),Color3.fromRGB(185,125,70));face(m,p+Vector3.new(0,1.05,-1.1),Vector3.new(2.5,2.5,2.3),Color3.fromRGB(185,125,70))
 local bat=part(m,"BaseballBat",Vector3.new(.7,4.8,.7),p+Vector3.new(3,0,-.3),Color3.fromRGB(130,77,38),Enum.Material.Wood);bat.Orientation=Vector3.new(0,0,-28);ball(m,"BatKnob",Vector3.new(1,1,1),bat.Position+Vector3.new(0,-2.5,0),g,Enum.Material.Neon)
 for _,s in ipairs({-1,1}) do part(m,"LogArm",Vector3.new(.65,2,.65),p+Vector3.new(s*2,-.3,0),Color3.fromRGB(151,94,48),Enum.Material.Wood) end
end
local function cappuccina(m,p,c,g)
 local torso=ball(m,"TutuTorso",Vector3.new(2.3,2.3,2.1),p+Vector3.new(0,-.5,0),Color3.fromRGB(255,220,235));m.PrimaryPart=torso
 local cup=part(m,"CappuccinoCupHead",Vector3.new(3.2,3.3,3),p+Vector3.new(0,2,-.1),Color3.fromRGB(245,229,201),Enum.Material.Ceramic,Enum.PartType.Cylinder);cup.Orientation=Vector3.new(0,0,90)
 ball(m,"Foam",Vector3.new(3.1,1.05,2.9),p+Vector3.new(0,3.65,-.1),Color3.fromRGB(255,250,230));ball(m,"LatteHeart",Vector3.new(.8,.32,.2),p+Vector3.new(0,3.95,-.95),Color3.fromRGB(160,105,65))
 face(m,p+Vector3.new(0,2,-.1),Vector3.new(3.2,3.3,3),Color3.fromRGB(245,229,201))
 for i=1,10 do local a=i*math.pi/5;ball(m,"TutuTulle",Vector3.new(1.35,.65,1.15),p+Vector3.new(math.cos(a)*1.55,-.75,math.sin(a)*1.25),g,Enum.Material.Neon) end
 for _,s in ipairs({-1,1}) do part(m,"BallerinaArm",Vector3.new(.55,2.1,.55),p+Vector3.new(s*1.45,.15,0),Color3.fromRGB(255,220,235)) end
 feet(m,p,Color3.fromRGB(245,210,220),.55)
end
local function banana(m,p,c,g)
 local yellow=Color3.fromRGB(255,221,48);local body=ball(m,"BananaCore",Vector3.new(2.7,3.2,2.5),p,yellow);m.PrimaryPart=body
 for i=1,5 do local t=(i-1)/4;ball(m,"CurvedBanana",Vector3.new(2.15,2.6,2.1),p+Vector3.new(math.sin(t*math.pi)*1.4,math.cos(t*math.pi)*.75,(t-.5)*2.3),yellow) end
 ball(m,"ChimpFace",Vector3.new(2.4,2.15,1.5),p+Vector3.new(0,.15,-1.05),Color3.fromRGB(116,70,45));face(m,p+Vector3.new(0,.25,-1.45),Vector3.new(2.4,2.15,1.5),Color3.fromRGB(116,70,45))
 for _,s in ipairs({-1,1}) do ball(m,"ChimpEar",Vector3.new(1.05,1.1,.7),p+Vector3.new(s*1.35,.75,-.8),Color3.fromRGB(116,70,45));ball(m,"ChimpArm",Vector3.new(.75,2,.75),p+Vector3.new(s*1.5,-.8,0),Color3.fromRGB(116,70,45)) end
 part(m,"BananaStem",Vector3.new(.55,.9,.55),p+Vector3.new(0,2,0),Color3.fromRGB(76,145,50),Enum.Material.Grass)
end
local function lirili(m,p,c,g)
 local trunk=part(m,"CactusElephantBody",Vector3.new(3.4,4.6,3.2),p,Color3.fromRGB(69,177,91),Enum.Material.Grass);m.PrimaryPart=trunk
 for _,s in ipairs({-1,1}) do part(m,"CactusArm",Vector3.new(1.35,2.8,1.35),p+Vector3.new(s*2,1,0),Color3.fromRGB(69,177,91),Enum.Material.Grass);for i=1,5 do wedge(m,"CactusSpine",Vector3.new(.28,.85,.28),p+Vector3.new(s*(1.45+i%2*.8),-1+i*.48,-.4),Color3.new(1,1,1)) end end
 ball(m,"ElephantHead",Vector3.new(3,2.8,2.8),p+Vector3.new(0,2.7,-.3),Color3.fromRGB(95,190,115));face(m,p+Vector3.new(0,2.7,-.3),Vector3.new(3,2.8,2.8),Color3.fromRGB(95,190,115))
 local nose=part(m,"ElephantTrunk",Vector3.new(1.05,2.5,1.05),p+Vector3.new(0,1.1,-1.85),Color3.fromRGB(95,190,115),Enum.Material.Grass,Enum.PartType.Cylinder);nose.Orientation=Vector3.new(0,0,-18)
 for _,s in ipairs({-1,1}) do ball(m,"ElephantEar",Vector3.new(2.1,2.5,.45),p+Vector3.new(s*2,2.8,-.2),Color3.fromRGB(120,205,125)) end
end
local function patapim(m,p,c,g)
 local tree=part(m,"TreeTrunk",Vector3.new(2.5,6,2.5),p,Color3.fromRGB(110,75,43),Enum.Material.Wood);m.PrimaryPart=tree
 for _,s in ipairs({-1,1}) do part(m,"TreeBranch",Vector3.new(1.1,3.5,1.1),p+Vector3.new(s*1.8,2,0),Color3.fromRGB(110,75,43),Enum.Material.Wood);ball(m,"LeafCanopy",Vector3.new(3,2.8,3),p+Vector3.new(s*2.4,3.5,0),Color3.fromRGB(70,175,85),Enum.Material.Grass) end
 local monkey=ball(m,"ProboscisMonkey",Vector3.new(3.4,3.2,2.8),p+Vector3.new(0,2.5,-.65),Color3.fromRGB(145,82,57));face(m,p+Vector3.new(0,2.5,-.65),Vector3.new(3.4,3.2,2.8),Color3.fromRGB(145,82,57))
 local nose=part(m,"LongMonkeyNose",Vector3.new(.8,2.7,.8),monkey.Position+Vector3.new(0,-.6,-1.5),Color3.fromRGB(190,105,87),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder);nose.Orientation=Vector3.new(0,0,20)
 for _,s in ipairs({-1,1}) do ball(m,"MonkeyFoot",Vector3.new(1.2,.8,1.4),p+Vector3.new(s*1.4,-2.1,-.4),Color3.fromRGB(100,60,48)) end
end
local function vaca(m,p,c,g)
 local body=ball(m,"SaturnCowBody",Vector3.new(4.4,3.1,3),p,Color3.fromRGB(245,240,220));m.PrimaryPart=body
 ball(m,"CowHead",Vector3.new(3.2,3.1,2.8),p+Vector3.new(0,1.8,-.25),Color3.fromRGB(245,240,220));face(m,p+Vector3.new(0,1.8,-.25),Vector3.new(3.2,3.1,2.8),Color3.fromRGB(240,130,150))
 for _,s in ipairs({-1,1}) do ball(m,"CowSpot",Vector3.new(1.45,1.1,.25),p+Vector3.new(s*1.2,.4,-1.45),Color3.fromRGB(55,48,55));ball(m,"CowHorn",Vector3.new(.55,1,.55),p+Vector3.new(s*1.1,3.5,-.1),Color3.fromRGB(245,225,175));part(m,"CowLeg",Vector3.new(.65,1.6,.65),p+Vector3.new(s*1.3,-1.8,0),Color3.fromRGB(245,240,220)) end
 local ring=part(m,"SaturnRing",Vector3.new(7.5,.38,7.5),p+Vector3.new(0,1.1,0),g,Enum.Material.Neon,Enum.PartType.Cylinder);ring.Orientation=Vector3.new(0,0,24)
end
local function frigo(m,p,c,g)
 local fridge=part(m,"FridgeCamelBody",Vector3.new(3.4,5,3.1),p,Color3.fromRGB(190,232,238),Enum.Material.Metal);m.PrimaryPart=fridge
 part(m,"FridgeDoor",Vector3.new(2.9,4.7,.18),p+Vector3.new(0,0,-1.62),Color3.fromRGB(220,246,248),Enum.Material.Metal);part(m,"FridgeHandle",Vector3.new(.18,1.5,.18),p+Vector3.new(1,-.2,-1.8),g,Enum.Material.Metal)
 for _,s in ipairs({-1,1}) do ball(m,"CamelHump",Vector3.new(1.8,1.9,1.8),p+Vector3.new(s*.95,2.8,.3),Color3.fromRGB(183,125,73));part(m,"CamelLeg",Vector3.new(.6,2,.6),p+Vector3.new(s*1.1,-3.2,.4),Color3.fromRGB(183,125,73)) end
 ball(m,"CamelHead",Vector3.new(2.9,2.8,2.8),p+Vector3.new(0,2.4,-1.5),Color3.fromRGB(195,139,83));face(m,p+Vector3.new(0,2.4,-1.5),Vector3.new(2.9,2.8,2.8),Color3.fromRGB(195,139,83));part(m,"CamelNeck",Vector3.new(1,2.7,1),p+Vector3.new(0,1,-1.1),Color3.fromRGB(195,139,83))
end
local function giraffa(m,p,c,g)
 local body=ball(m,"GiraffeBody",Vector3.new(3.4,3,2.8),p,Color3.fromRGB(255,190,65));m.PrimaryPart=body
 local neck=part(m,"LongGiraffeNeck",Vector3.new(1.6,5.5,1.6),p+Vector3.new(0,3.1,0),Color3.fromRGB(255,190,65));ball(m,"GiraffeHead",Vector3.new(3.0,2.5,2.6),neck.Position+Vector3.new(0,3,-.1),Color3.fromRGB(255,190,65));face(m,neck.Position+Vector3.new(0,3,-.1),Vector3.new(3.0,2.5,2.6),Color3.fromRGB(255,190,65))
 for _,s in ipairs({-1,1}) do part(m,"GiraffeLeg",Vector3.new(.65,2,.65),p+Vector3.new(s*1.05,-2,0),Color3.fromRGB(255,190,65));ball(m,"GiraffeSpot",Vector3.new(.9,.8,.22),p+Vector3.new(s*1.05,.45,-1.35),Color3.fromRGB(155,83,35));part(m,"Ossicone",Vector3.new(.35,1,.35),neck.Position+Vector3.new(s*.75,4,0),Color3.fromRGB(255,190,65)) end
 ball(m,"SpaceHelmet",Vector3.new(3.4,2.8,3),neck.Position+Vector3.new(0,3,.05),Color3.fromRGB(100,220,255),Enum.Material.Glass)
 for i=1,4 do ball(m,"OrbitStar",Vector3.new(.48,.48,.48),p+Vector3.new(math.cos(i*math.pi/2)*3,2+((i%2)*2),math.sin(i*math.pi/2)*3),g,Enum.Material.Neon) end
end
local function boneca(m,p,c,g)
 local tire=part(m,"TireRing",Vector3.new(5.4,1.3,5.4),p+Vector3.new(0,-1,0),Color3.fromRGB(34,38,43),Enum.Material.Rubber,Enum.PartType.Cylinder);tire.Orientation=Vector3.new(0,0,90);m.PrimaryPart=tire
 local hub=part(m,"TireHub",Vector3.new(2.4,.35,2.4),p+Vector3.new(0,-.25,0),Color3.fromRGB(125,135,145),Enum.Material.Metal,Enum.PartType.Cylinder);hub.Orientation=Vector3.new(0,0,90)
 ball(m,"FrogBody",Vector3.new(3.5,2.7,2.7),p+Vector3.new(0,1.5,-.2),Color3.fromRGB(90,210,90));ball(m,"FrogHead",Vector3.new(3.1,2.4,2.8),p+Vector3.new(0,2.7,-.45),Color3.fromRGB(90,220,95));face(m,p+Vector3.new(0,2.7,-.45),Vector3.new(3.1,2.4,2.8),Color3.fromRGB(90,220,95))
 for _,s in ipairs({-1,1}) do ball(m,"FrogEyeBump",Vector3.new(1.1,1.3,1),p+Vector3.new(s*.9,4,-.4),Color3.fromRGB(90,220,95));ball(m,"FrogFoot",Vector3.new(1.5,.65,1.7),p+Vector3.new(s*1.75,.25,-.5),Color3.fromRGB(65,175,70)) end
end
local function trippi(m,p,c,g)
 local body=ball(m,"BearFishBody",Vector3.new(4.1,3.7,3.5),p,Color3.fromRGB(187,125,80));m.PrimaryPart=body
 ball(m,"BearHead",Vector3.new(3.6,3.2,3.1),p+Vector3.new(0,2,-.3),Color3.fromRGB(187,125,80));face(m,p+Vector3.new(0,2,-.3),Vector3.new(3.6,3.2,3.1),Color3.fromRGB(187,125,80))
 for _,s in ipairs({-1,1}) do ball(m,"BearEar",Vector3.new(1.2,1.2,.8),p+Vector3.new(s*1.25,3.45,-.2),Color3.fromRGB(187,125,80));part(m,"BearArm",Vector3.new(.9,2.2,1),p+Vector3.new(s*2,-.35,0),Color3.fromRGB(187,125,80)) end
 local tail=part(m,"FishTail",Vector3.new(2.7,2.5,.65),p+Vector3.new(0,.1,2.2),Color3.fromRGB(60,190,220),Enum.Material.SmoothPlastic,Enum.PartType.Wedge);tail.Orientation=Vector3.new(0,180,0)
 for i=1,3 do wedge(m,"TailFin",Vector3.new(.6,2,.45),p+Vector3.new((i-2)*.65,.1,3),g,Vector3.new(0,0,(i-2)*16)) end
end
-- Session 17: four more signature builders, from the chibi reference sheet —
-- the coffee cup with a sword, the watermelon with a gorilla face, the bread
-- loaf, and the shrimp-cat. Same chibi rules: oversized head, big eyes, the
-- signature item built into the body.
local function assassino(m,p,c,g)
 local cup=part(m,"CoffeeCupBody",Vector3.new(3.4,4.2,3.2),p,Color3.fromRGB(60,45,40),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder);m.PrimaryPart=cup
 part(m,"CupLid",Vector3.new(3.6,.8,3.4),p+Vector3.new(0,2.4,0),Color3.fromRGB(240,235,225),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder)
 ball(m,"CupFace",Vector3.new(3.0,2.6,2.6),p+Vector3.new(0,.4,-.6),Color3.fromRGB(250,245,235));face(m,p+Vector3.new(0,.4,-.6),Vector3.new(3.0,2.6,2.6),Color3.fromRGB(250,245,235))
 part(m,"SwordBlade",Vector3.new(.5,4.5,.18),p+Vector3.new(2.6,1.2,0),Color3.fromRGB(220,225,235),Enum.Material.Metal)
 part(m,"SwordHilt",Vector3.new(1.4,.4,.4),p+Vector3.new(2.6,-1.1,0),Color3.fromRGB(150,100,50),Enum.Material.Wood)
 part(m,"AssassinArm",Vector3.new(.6,2,.6),p+Vector3.new(2.2,-.5,0),Color3.fromRGB(60,45,40))
 feet(m,p,Color3.fromRGB(60,45,40),1.1)
end
local function watermelon(m,p,c,g)
 local melon=ball(m,"WatermelonBody",Vector3.new(4.6,4.2,4.4),p,Color3.fromRGB(60,180,80));m.PrimaryPart=melon
 for _,s in ipairs({-1,1}) do ball(m,"MelonStripe",Vector3.new(.5,3.8,3.6),p+Vector3.new(s*1.6,.1,0),Color3.fromRGB(30,130,50),Enum.Material.Grass) end
 ball(m,"GorillaFace",Vector3.new(3.2,2.8,2.4),p+Vector3.new(0,.3,-1.2),Color3.fromRGB(120,75,45));face(m,p+Vector3.new(0,.3,-1.2),Vector3.new(3.2,2.8,2.4),Color3.fromRGB(120,75,45))
 for _,s in ipairs({-1,1}) do ball(m,"GorillaEar",Vector3.new(1,1.1,.7),p+Vector3.new(s*1.7,.9,-1),Color3.fromRGB(120,75,45));part(m,"MelonBoot",Vector3.new(1.3,.9,2),p+Vector3.new(s*1.2,-2.2,-.3),Color3.fromRGB(150,95,50),Enum.Material.SmoothPlastic) end
end
local function crostino(m,p,c,g)
 local loaf=part(m,"BreadLoafBody",Vector3.new(3.6,3.4,2.8),p,Color3.fromRGB(220,165,90),Enum.Material.SmoothPlastic);m.PrimaryPart=loaf
 ball(m,"CrustTop",Vector3.new(3.4,1.2,2.6),p+Vector3.new(0,1.9,0),Color3.fromRGB(245,205,130))
 ball(m,"BreadFace",Vector3.new(3.0,2.4,2.2),p+Vector3.new(0,.2,-.9),Color3.fromRGB(250,220,160));face(m,p+Vector3.new(0,.2,-.9),Vector3.new(3.0,2.4,2.2),Color3.fromRGB(250,220,160))
 for _,s in ipairs({-1,1}) do part(m,"BreadArm",Vector3.new(.6,1.8,.6),p+Vector3.new(s*2,-.3,0),Color3.fromRGB(220,165,90)) end
 feet(m,p,Color3.fromRGB(220,165,90),1.0)
end
local function gamberetta(m,p,c,g)
 local body=ball(m,"ShrimpBody",Vector3.new(3.6,3.4,3.2),p,Color3.fromRGB(255,140,70));m.PrimaryPart=body
 for i=1,3 do ball(m,"ShrimpSegment",Vector3.new(3.0-i*.5,2.8-i*.4,2.6-i*.4),p+Vector3.new(0,.3+i*.3,1.2+i*.8),Color3.fromRGB(255,160,90)) end
 ball(m,"ShrimpHead",Vector3.new(3.2,2.8,2.8),p+Vector3.new(0,.6,-1.2),Color3.fromRGB(255,150,80));face(m,p+Vector3.new(0,.6,-1.2),Vector3.new(3.2,2.8,2.8),Color3.fromRGB(255,150,80))
 for _,s in ipairs({-1,1}) do ball(m,"CatEar",Vector3.new(.9,1.2,.6),p+Vector3.new(s*1.1,2.2,-1.1),Color3.fromRGB(255,150,80));wedge(m,"TailFan",Vector3.new(1.2,1.8,.4),p+Vector3.new(s*.9,1.8,3.4),Color3.fromRGB(255,120,60),Vector3.new(0,0,s*20)) end
 for _,s in ipairs({-1,1}) do part(m,"ShrimpLeg",Vector3.new(.5,1.2,.5),p+Vector3.new(s*1.1,-1.9,0),Color3.fromRGB(255,140,70)) end
end

local signature={
 ["Tralalero Tralala"]=shark,["Bombardiro Crocodilo"]=bombardiro,["Tung Tung Tung Sahur"]=tung,
 ["Ballerina Cappuccina"]=cappuccina,["Chimpanzini Bananini"]=banana,["Lirili Larila"]=lirili,
 ["Brr Brr Patapim"]=patapim,["La Vaca Saturno Saturnita"]=vaca,["Frigo Camelo"]=frigo,
 ["Giraffa Celeste"]=giraffa,["Boneca Ambalabu"]=boneca,["Trippi Troppi"]=trippi,
 ["Cappuccino Assassino"]=assassino,["Gorillo Watermelondrillo"]=watermelon,
 ["Crostino Motorello"]=crostino,["Trombetta Gamberetta"]=gamberetta,
}
local function fallback(m,p,c,g,id,name)
 local form=(id-1)%8
 if form==0 then
  local b=ball(m,"RoundCritter",Vector3.new(4.4,4.2,4.1),p,c);m.PrimaryPart=b;ball(m,"OversizedHead",Vector3.new(3.7,3.6,3.5),p+Vector3.new(0,2.3,-.25),c);face(m,p+Vector3.new(0,2.3,-.25),Vector3.new(3.7,3.6,3.5),c);for s=-1,1,2 do wedge(m,"EarOrHorn",Vector3.new(1.3,2,.8),p+Vector3.new(s*2.3,2.6,0),g) end
 elseif form==1 then
  local b=part(m,"LongAnimalBody",Vector3.new(6.5,2.5,3),p,c);m.PrimaryPart=b;ball(m,"AnimalHead",Vector3.new(2.8,2.8,2.7),p+Vector3.new(0,1.3,-2),c);face(m,p+Vector3.new(0,1.3,-2),Vector3.new(2.8,2.8,2.7),c);wedge(m,"Tail",Vector3.new(1.3,1.4,2),p+Vector3.new(0,.5,2.5),g);feet(m,p,c,1.7)
 elseif form==2 then
  local b=part(m,"TallCreatureBody",Vector3.new(3.4,5.8,3.2),p,c);m.PrimaryPart=b;ball(m,"CreatureHead",Vector3.new(3.4,3,3),p+Vector3.new(0,3.2,0),c);face(m,p+Vector3.new(0,3.2,0),Vector3.new(3.4,3,3),c);for s=-1,1,2 do part(m,"LongArm",Vector3.new(.65,3,.65),p+Vector3.new(s*2,-.1,0),c) end
 elseif form==3 then
  local b=part(m,"Shell",Vector3.new(4.7,3.2,4.7),p,c,Enum.Material.SmoothPlastic,Enum.PartType.Cylinder);b.Orientation=Vector3.new(0,0,90);m.PrimaryPart=b;ball(m,"ShellTop",Vector3.new(4.2,2.4,4.2),p+Vector3.new(0,1,0),g);ball(m,"CreatureHead",Vector3.new(2.7,2.5,2.7),p+Vector3.new(0,1.1,-2),c);face(m,p+Vector3.new(0,1.1,-2),Vector3.new(2.7,2.5,2.7),c)
 elseif form==4 then
  local b=part(m,"BirdBody",Vector3.new(3.4,4.5,3),p,c,Enum.Material.SmoothPlastic,Enum.PartType.Ball);m.PrimaryPart=b;ball(m,"BirdHead",Vector3.new(3.4,3.2,3.2),p+Vector3.new(0,2.4,0),c);face(m,p+Vector3.new(0,2.4,0),Vector3.new(3.4,3.2,3.2),c);for s=-1,1,2 do wedge(m,"Wing",Vector3.new(2.5,1,.9),p+Vector3.new(s*2,.2,0),g);part(m,"BirdLeg",Vector3.new(.4,1.5,.4),p+Vector3.new(s*.8,-2.5,0),g) end
 elseif form==5 then
  local b=part(m,"FoodMachineBody",Vector3.new(4,5,3.3),p,c,Enum.Material.Metal);m.PrimaryPart=b;part(m,"DisplayWindow",Vector3.new(3,.55,.15),p+Vector3.new(0,1.2,-1.72),g,Enum.Material.Neon);part(m,"ControlPanel",Vector3.new(1.4,1.4,.18),p+Vector3.new(1,-.8,-1.72),Color3.fromRGB(45,50,65),Enum.Material.Metal);face(m,p+Vector3.new(0,2.0,-1.6),Vector3.new(2.6,2.0,1),c);for s=-1,1,2 do ball(m,"MachineWheel",Vector3.new(1,1,1),p+Vector3.new(s*1.5,-2,0),Color3.fromRGB(40,45,50),Enum.Material.Rubber) end
 elseif form==6 then
  local b=ball(m,"BlobBody",Vector3.new(4.5,3.8,4.2),p,c);m.PrimaryPart=b;for i=1,5 do local a=i*math.pi*2/5;ball(m,"BlobSpikes",Vector3.new(1.25,1.25,1.25),p+Vector3.new(math.cos(a)*2.2,1+((i%2)*.6),math.sin(a)*2.2),g) end;face(m,p+Vector3.new(0,.3,-1.9),Vector3.new(2.8,2.6,1.6),c)
 else
  local b=part(m,"RocketCreature",Vector3.new(3.2,5.8,3.2),p,c,Enum.Material.Metal,Enum.PartType.Cylinder);b.Orientation=Vector3.new(0,0,90);m.PrimaryPart=b;ball(m,"Porthole",Vector3.new(1.8,1.8,.4),p+Vector3.new(0,.4,-1.75),g,Enum.Material.Glass);face(m,p+Vector3.new(0,1.2,-1.55),Vector3.new(2.4,2.0,1),c);for s=-1,1,2 do wedge(m,"RocketFin",Vector3.new(1.7,2,.55),p+Vector3.new(s*1.55,-1.5,0),g,Vector3.new(0,0,s*18)) end;wedge(m,"NoseCone",Vector3.new(2,1.8,2),p+Vector3.new(0,3,0),g)
 end
 local labelName=name
 return labelName
end

function B.Create(parent,entry,pos)
 local model=Instance.new("Model");model.Name=entry.Name;model.Parent=parent
 local id=math.max(1,tonumber(entry.Id) or 1)
 local rarity=C.Rarities[entry.Rarity];local glow=rarity and rarity.Color or Color3.fromRGB(255,220,70)
 local palette={Color3.fromRGB(255,115,90),Color3.fromRGB(65,210,220),Color3.fromRGB(255,195,65),Color3.fromRGB(175,110,255),Color3.fromRGB(105,225,130),Color3.fromRGB(220,120,190),Color3.fromRGB(130,170,255),Color3.fromRGB(185,125,70)}
 local bodyColor=palette[(id-1)%#palette+1]
 if signature[entry.Name] then signature[entry.Name](model,pos,bodyColor,glow) else fallback(model,pos,bodyColor,glow,id,entry.Name) end
 local label=U.Label(model.PrimaryPart,entry.Name.."\n$"..entry.Price.."  +$"..entry.Income.."/s",Color3.new(1,1,1),150,40,16);label.StudsOffset=Vector3.new(0,4,0)
 local startPivot=model:GetPivot()
 task.spawn(function()
  local began=os.clock()
  while model.Parent do local t=os.clock()-began;model:PivotTo(CFrame.new(pos+Vector3.new(0,math.sin(t*2)*.24,0))*CFrame.Angles(0,t*.22,0)*CFrame.new(-pos)*startPivot);task.wait(.08) end
 end)
 return model
end
return B
