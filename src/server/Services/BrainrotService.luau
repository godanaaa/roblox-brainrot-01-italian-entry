local C=require(game.ReplicatedStorage.Modules.Config);local U=require(game.ReplicatedStorage.Modules.Util);local B={}
function B.Create(parent,entry,pos)
 local model=Instance.new("Model");model.Name=entry.Name;model.Parent=parent;local col=C.Rarities[entry.Rarity].Color
 local body=U.Part(model,"Body",Vector3.new(5,4,4),pos,col,Enum.Material.SmoothPlastic);local head=U.Part(model,"Head",Vector3.new(3,3,3),pos+Vector3.new(0,3,0),col);head.Shape=Enum.PartType.Ball
 local feature=U.Part(model,"Signature",Vector3.new(1,5,1),pos+Vector3.new(2.2,3,0),Color3.fromRGB(255,245,120),Enum.Material.Neon);feature.Shape=Enum.PartType.Ball
 U.Part(model,"EyeL",Vector3.new(.45,.6,.3),pos+Vector3.new(-.7,3.2,-1.42),Color3.new(1,1,1),Enum.Material.Neon);U.Part(model,"EyeR",Vector3.new(.45,.6,.3),pos+Vector3.new(.7,3.2,-1.42),Color3.new(1,1,1),Enum.Material.Neon)
 U.Label(head,entry.Name.."\n"..entry.Rarity.."  +$"..entry.Income.."/s",col)
 task.spawn(function() local origin=pos;while model.Parent do local t=os.clock();body.Position=origin+Vector3.new(0,math.sin(t*2)*.45,0);head.Position=origin+Vector3.new(0,3+math.sin(t*2)*.45,0);feature.Position=origin+Vector3.new(2.2,3+math.sin(t*2)*.45,0);task.wait(.08) end end)
 return model
end
return B
