local C=require(game.ReplicatedStorage.Modules.Config)
local U=require(game.ReplicatedStorage.Modules.Util)
local B={}

local shapes={"wide","tall","round","blocky"}
local accessories={"antenna","crown","glasses","wings","cape","tire","sword","sneakers","tutu","fin"}
local function part(model,name,size,offset,color,material,shape)
 local p=U.Part(model,name,size,offset,color,material)
 if shape then p.Shape=shape end
 return p
end

function B.Create(parent,entry,pos)
 local model=Instance.new("Model")
 model.Name=entry.Name
 model.Parent=parent
 local id=math.max(1,tonumber(entry.Id) or 1)
 local rarity=C.Rarities[entry.Rarity]
 local glow=rarity and rarity.Color or Color3.fromRGB(255,220,70)
 local bodyColors={Color3.fromRGB(255,115,90),Color3.fromRGB(65,210,220),Color3.fromRGB(255,195,65),Color3.fromRGB(175,110,255),Color3.fromRGB(105,225,130)}
 local bodyColor=bodyColors[(id-1)%#bodyColors+1]
 local shape=shapes[(id-1)%#shapes+1]
 local scale=0.86+((id*7)%4)*0.06
 local bw,bh,bd=5*scale,4*scale,4*scale
 if shape=="wide" then bw=5.7*scale;bh=3.5*scale elseif shape=="tall" then bw=4.2*scale;bh=4.8*scale elseif shape=="round" then bw=4.6*scale;bh=4.2*scale;bd=4.4*scale end
 local body=part(model,"Body",Vector3.new(bw,bh,bd),pos,bodyColor,Enum.Material.SmoothPlastic,shape=="round" and Enum.PartType.Ball or nil)
 model.PrimaryPart=body
 part(model,"RarityTrim",Vector3.new(bw+.18,.28,bd+.18),pos+Vector3.new(0,bh*.36,0),glow,Enum.Material.Neon)
 local accent=({Color3.fromRGB(255,224,132),Color3.fromRGB(255,110,155),Color3.fromRGB(100,245,215),Color3.fromRGB(255,255,240),Color3.fromRGB(75,95,145),Color3.fromRGB(255,145,55)})[(id-1)%6+1]
 -- Two-tone belly, short limbs and a character-specific back detail give each silhouette more life.
 part(model,"BellyPatch",Vector3.new(bw*.62,bh*.54,.16),pos+Vector3.new(0,-.1,-bd*.51),accent,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 for _,side in ipairs({-1,1}) do
  part(model,"Arm",Vector3.new(.78,1.9,.82),pos+Vector3.new(side*(bw*.5+.13),-.15,0),bodyColor,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  part(model,"Hand",Vector3.new(.78,.72,.78),pos+Vector3.new(side*(bw*.5+.15),-.95,-.04),accent,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  part(model,"Leg",Vector3.new(.92,1.15,1),pos+Vector3.new(side*(bw*.27),-bh*.57,0),Color3.fromRGB(75,65,100),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  part(model,"Cheek",Vector3.new(.42,.25,.12),pos+Vector3.new(side*.96,bh*.63,-bd*.7),Color3.fromRGB(255,125,145),Enum.Material.Neon,Enum.PartType.Ball)
 end
 local motif=(id-1)%4
 if motif==0 then for i=-1,1 do part(model,"BodyStripe",Vector3.new(.16,bh*.72,.12),pos+Vector3.new(i*bw*.22,0,-bd*.52),glow,Enum.Material.Neon) end
 elseif motif==1 then for i=1,3 do part(model,"BodySpot",Vector3.new(.5,.5,.15),pos+Vector3.new((i-2)*.8,.3,-bd*.52),accent,Enum.Material.SmoothPlastic,Enum.PartType.Ball) end
 elseif motif==2 then part(model,"ChestEmblem",Vector3.new(1.1,1.1,.18),pos+Vector3.new(0,.1,-bd*.54),glow,Enum.Material.Neon,Enum.PartType.Ball)
 else part(model,"Scarf",Vector3.new(bw*.76,.5,bd*.72),pos+Vector3.new(0,bh*.37,0),accent,Enum.Material.SmoothPlastic) end
 local tailColor=motif==3 and accent or glow
 part(model,"Tail",Vector3.new(.8,1.8,.8),pos+Vector3.new(0,-.25,bd*.58),tailColor,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 local headSize=Vector3.new(4.15*scale,4.05*scale,3.7*scale)
 local head=part(model,"Head",headSize,pos+Vector3.new(0,bh*.5+1.65*scale,0),bodyColor,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 local faceZ=-headSize.Z*.48
 local eyeSize=.52+((id+1)%3)*.11
 local eyeGap=.58+((id*3)%4)*.12
 local faceStyle=(id-1)%4
 for _,side in ipairs({-1,1}) do
  local eyeHeight=faceStyle==2 and eyeSize*.72 or eyeSize*1.25
  local eye=part(model,"Eye",Vector3.new(eyeSize,eyeHeight,.2),head.Position+Vector3.new(side*eyeGap,0,faceZ),Color3.new(1,1,1),Enum.Material.SmoothPlastic,faceStyle==3 and Enum.PartType.Ball or nil)
  if faceStyle~=2 then part(model,"Pupil",Vector3.new(.22,.34,.12),eye.Position+Vector3.new(0,-.03,-.13),faceStyle==3 and Color3.fromRGB(50,50,100) or Color3.fromRGB(60,45,70),Enum.Material.Neon,Enum.PartType.Ball) end
  if faceStyle==1 then part(model,"Brow",Vector3.new(.72,.17,.15),eye.Position+Vector3.new(-side*.08,.48,-.09),Color3.fromRGB(70,38,55),Enum.Material.SmoothPlastic) end
  if faceStyle==3 then part(model,"EyeSparkle",Vector3.new(.16,.16,.12),eye.Position+Vector3.new(-.12,.12,-.15),Color3.new(1,1,1),Enum.Material.Neon,Enum.PartType.Ball) end
 end
 local mouthColor=Color3.fromRGB(70,35,45)
 if faceStyle==0 then part(model,"Smile",Vector3.new(.78,.25,.2),head.Position+Vector3.new(0,-.78*scale,faceZ-.03),mouthColor,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 elseif faceStyle==1 then part(model,"Frown",Vector3.new(.72,.18,.2),head.Position+Vector3.new(0,-.82*scale,faceZ-.03),mouthColor,Enum.Material.SmoothPlastic)
 elseif faceStyle==2 then part(model,"SleepyMouth",Vector3.new(.24,.32,.2),head.Position+Vector3.new(0,-.82*scale,faceZ-.03),mouthColor,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 else part(model,"StarMouth",Vector3.new(.46,.46,.2),head.Position+Vector3.new(0,-.8*scale,faceZ-.03),Color3.fromRGB(255,105,155),Enum.Material.Neon,Enum.PartType.Ball) end
 local accessory=accessories[(id-1)%#accessories+1]
 local top=head.Position.Y+headSize.Y*.52
 if accessory=="antenna" then
  part(model,"Antenna",Vector3.new(.24,1.15,.24),Vector3.new(pos.X,top+.55,pos.Z),glow,Enum.Material.Neon)
  part(model,"AntennaTip",Vector3.new(.7,.7,.7),Vector3.new(pos.X,top+1.15,pos.Z),glow,Enum.Material.Neon,Enum.PartType.Ball)
 elseif accessory=="crown" then
  part(model,"Crown",Vector3.new(2.4,.55,1.8),Vector3.new(pos.X,top+.2,pos.Z),Color3.fromRGB(255,210,55),Enum.Material.Metal)
 elseif accessory=="glasses" then
  part(model,"Glasses",Vector3.new(1.65,.28,.2),head.Position+Vector3.new(0,0,faceZ-.13),Color3.fromRGB(35,40,55),Enum.Material.Metal)
 elseif accessory=="wings" then
  for _,side in ipairs({-1,1}) do part(model,"Wing",Vector3.new(1.25,1.8,.4),pos+Vector3.new(side*(bw*.5+.45),.5,0),glow,Enum.Material.Neon,Enum.PartType.Ball) end
 elseif accessory=="cape" then
  part(model,"Cape",Vector3.new(math.min(2.8,bw*.55),2.6,.35),pos+Vector3.new(0,-.3,bd*.5+.12),glow,Enum.Material.SmoothPlastic)
 elseif accessory=="tire" then
  local tire=part(model,"TireProp",Vector3.new(2.4,2.4,.55),pos+Vector3.new(-bw*.55,.2,0),Color3.fromRGB(35,38,45),Enum.Material.Rubber,Enum.PartType.Cylinder);tire.Orientation=Vector3.new(90,0,0)
 elseif accessory=="sword" then
  part(model,"SwordGrip",Vector3.new(.32,1,.32),pos+Vector3.new(bw*.62,.3,0),Color3.fromRGB(125,75,40),Enum.Material.Wood)
  part(model,"SwordBlade",Vector3.new(.45,2.4,.28),pos+Vector3.new(bw*.62,1.8,0),Color3.fromRGB(180,240,255),Enum.Material.Metal)
 elseif accessory=="sneakers" then
  for _,side in ipairs({-1,1}) do part(model,"Sneaker",Vector3.new(1.5,.75,1.8),pos+Vector3.new(side*(bw*.42),-.15,-.15),side<0 and Color3.fromRGB(255,70,90) or Color3.fromRGB(65,190,255),Enum.Material.SmoothPlastic) end
 elseif accessory=="tutu" then
  for i=1,8 do local a=i*math.pi/4;part(model,"Tutu",Vector3.new(1.25,.42,1),pos+Vector3.new(math.cos(a)*1.45,-.05,math.sin(a)*1.2),glow,Enum.Material.Neon) end
 else
  part(model,"SharkFin",Vector3.new(1.25,1.8,.65),pos+Vector3.new(0,bh*.5+1.1,bd*.25),glow,Enum.Material.SmoothPlastic,Enum.PartType.Wedge)
 end
 -- A second deterministic wardrobe/prop layer makes even shared silhouettes read as distinct characters.
 local wardrobe=(id*7)%5
 if wardrobe==0 then
  part(model,"Beret",Vector3.new(2.6,.7,2.2),Vector3.new(pos.X,top+.35,pos.Z),accent,Enum.Material.Fabric,Enum.PartType.Ball)
  part(model,"BeretBadge",Vector3.new(.45,.45,.18),Vector3.new(pos.X,top+.37,pos.Z-1),glow,Enum.Material.Neon,Enum.PartType.Ball)
 elseif wardrobe==1 then
  part(model,"Vest",Vector3.new(bw*.68,bh*.72,.22),pos+Vector3.new(0,.05,-bd*.54),accent,Enum.Material.Fabric)
  part(model,"Belt",Vector3.new(bw*.78,.28,.24),pos+Vector3.new(0,-.58,-bd*.57),Color3.fromRGB(70,45,35),Enum.Material.Leather)
 elseif wardrobe==2 then
  part(model,"Backpack",Vector3.new(1.8,2.1,1.2),pos+Vector3.new(0,.15,bd*.62),Color3.fromRGB(190,90,60),Enum.Material.Fabric)
  part(model,"PackBadge",Vector3.new(.65,.65,.18),pos+Vector3.new(0,.2,bd*.85),glow,Enum.Material.Neon,Enum.PartType.Ball)
 elseif wardrobe==3 then
  part(model,"ChefHat",Vector3.new(2.1,1.2,2),Vector3.new(pos.X,top+.52,pos.Z),Color3.fromRGB(255,250,235),Enum.Material.Fabric,Enum.PartType.Ball)
  part(model,"ChefBand",Vector3.new(2.2,.28,2.1),Vector3.new(pos.X,top+.2,pos.Z),accent,Enum.Material.Neon)
 else
  part(model,"ShoulderCape",Vector3.new(bw*.88,1.5,bd*.72),pos+Vector3.new(0,.95,bd*.6),accent,Enum.Material.Fabric)
  part(model,"CapePin",Vector3.new(.55,.55,.2),pos+Vector3.new(0,1.35,-bd*.57),glow,Enum.Material.Neon,Enum.PartType.Ball)
 end
 local label=U.Label(head,entry.Name.."\n"..entry.Rarity.."  $"..entry.Price.."  +$"..entry.Income.."/s",Color3.new(1,1,1))
 label.StudsOffset=Vector3.new(0,headSize.Y*.5+2.5,0)
 local startPivot=model:GetPivot()
 task.spawn(function()
  local began=os.clock()
  while model.Parent do
   local t=os.clock()-began
   local target=CFrame.new(pos+Vector3.new(0,math.sin(t*2)*.28,0))*CFrame.Angles(0,t*.35,0)*CFrame.new(-pos)*startPivot
   model:PivotTo(target)
   task.wait(.08)
  end
 end)
 return model
end
return B
