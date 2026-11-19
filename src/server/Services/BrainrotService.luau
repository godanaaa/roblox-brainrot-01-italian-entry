local C=require(game.ReplicatedStorage.Modules.Config)
local U=require(game.ReplicatedStorage.Modules.Util)
local B={}

local shapes={"wide","tall","round","blocky"}
local accessories={"antenna","crown","glasses","wings","cape"}
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
 local headSize=Vector3.new(2.65*scale,2.6*scale,2.55*scale)
 local head=part(model,"Head",headSize,pos+Vector3.new(0,bh*.5+1.15*scale,0),bodyColor,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 local faceZ=-headSize.Z*.48
 local eyeSize=.34+((id+1)%3)*.11
 local eyeGap=.38+((id*3)%4)*.12
 part(model,"EyeL",Vector3.new(eyeSize,eyeSize*1.25,.18),head.Position+Vector3.new(-eyeGap,0,faceZ),Color3.new(1,1,1),Enum.Material.Neon)
 part(model,"EyeR",Vector3.new(eyeSize,eyeSize*1.25,.18),head.Position+Vector3.new(eyeGap,0,faceZ),Color3.new(1,1,1),Enum.Material.Neon)
 part(model,"Mouth",Vector3.new(.48+((id+2)%3)*.12,.16,.18),head.Position+Vector3.new(0,-.52*scale,faceZ-.03),Color3.fromRGB(70,35,45),Enum.Material.SmoothPlastic)
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
 else
  part(model,"Cape",Vector3.new(math.min(2.8,bw*.55),2.6,.35),pos+Vector3.new(0,-.3,bd*.5+.12),glow,Enum.Material.SmoothPlastic)
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
