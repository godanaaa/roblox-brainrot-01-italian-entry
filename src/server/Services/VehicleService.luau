local C=require(game.ReplicatedStorage.Modules.Config)
local Data=require(script.Parent.DataService)
local Base=require(script.Parent.BaseService)
local Coin=require(script.Parent.CoinService)
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Vehicles={Active={}}

local function spec(id) for _,v in ipairs(C.Vehicles) do if v.Id==id then return v end end end

-- Session 25: vehicles that read as real vehicles, not a single box.
-- One shared builder serves BOTH the drivable model (makeVehicle) and the
-- showroom display (BuildDisplayModel), so the pad and the driven car are
-- the same shape by construction. Local space: forward is -Z, the origin
-- is the chassis centre, and every wheel's bottom sits at y=-2.2 — so a
-- display placed at y=3.2 rests its wheels on the pad top (y=1), and a
-- driven spawn settles on the ground. All parts are welded to the
-- chassis (the PrimaryPart); the Heartbeat driver moves the model with
-- PivotTo on the chassis, exactly as before. Prices, purchase validation
-- and spawn behaviour are unchanged; only the shapes are new.
-- Wheels are true round discs: a cylinder's axis is Y, so Size
-- (diameter, thickness, diameter) rotated 90deg about Z puts the axle
-- along X and the round face in the Y-Z plane. (The old (2,2,1) wheels
-- were elliptical — 2 tall, 1 long.) Cars are open-top roadsters: the
-- driver sits in the cabin with the head above the body line, so no roof
-- ever intersects the seated character; the Car keeps a roof panel over
-- the rear seats only.
local DARK=Color3.fromRGB(28,30,38)
local GLASS=Color3.fromRGB(135,232,255)
local WHITE=Color3.fromRGB(245,245,240)
local GOLD=Color3.fromRGB(255,215,0)
local function buildVehicleModel(v,anchored,drivable)
 local m=Instance.new("Model");m.Name="Vehicle_"..v.Id
 local function add(name,size,offset,color,material,shape,rot)
  local p=Instance.new("Part");p.Name=name;p.Size=size;p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;p.Anchored=anchored
  if shape then p.Shape=shape end
  p.CFrame=CFrame.new(offset)*(rot or CFrame.new())
  p.Parent=m
  return p
 end
 local chassis
 local function weldAll()
  for _,p in ipairs(m:GetChildren()) do
   if p:IsA("BasePart") and p~=chassis then local w=Instance.new("WeldConstraint");w.Part0=chassis;w.Part1=p;w.Parent=chassis end
  end
 end
 local function wheel(x,z,diameter,thickness,hubColor)
  local wh=add("Wheel",Vector3.new(diameter,thickness,diameter),Vector3.new(x,-2.2+diameter/2,z),DARK,Enum.Material.Rubber,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  add("Hubcap",Vector3.new(diameter*0.55,thickness+0.15,diameter*0.55),Vector3.new(x,-2.2+diameter/2,z),hubColor or Color3.fromRGB(200,200,210),Enum.Material.Metal,Enum.PartType.Cylinder,CFrame.Angles(0,0,math.pi/2))
  return wh
 end
 local function lights(frontY)
  add("HeadlightL",Vector3.new(1.6,0.7,0.3),Vector3.new(-2.5,frontY,-7.1),WHITE,Enum.Material.Neon)
  add("HeadlightR",Vector3.new(1.6,0.7,0.3),Vector3.new(2.5,frontY,-7.1),WHITE,Enum.Material.Neon)
  add("TaillightL",Vector3.new(1.6,0.7,0.3),Vector3.new(-2.5,frontY,7.1),Color3.fromRGB(255,40,40),Enum.Material.Neon)
  add("TaillightR",Vector3.new(1.6,0.7,0.3),Vector3.new(2.5,frontY,7.1),Color3.fromRGB(255,40,40),Enum.Material.Neon)
 end
 local function glassWindows(cabinW,cabinY,cabinZ,cabinD)
  add("Windshield",Vector3.new(cabinW-0.5,1.5,0.3),Vector3.new(0,cabinY,cabinZ-cabinD/2+0.1),GLASS,Enum.Material.Glass,nil,CFrame.Angles(math.rad(-18),0,0)).Transparency=.35
  add("WindowL",Vector3.new(0.3,1.3,cabinD-2),Vector3.new(-cabinW/2,cabinY,cabinZ),GLASS,Enum.Material.Glass).Transparency=.35
  add("WindowR",Vector3.new(0.3,1.3,cabinD-2),Vector3.new(cabinW/2,cabinY,cabinZ),GLASS,Enum.Material.Glass).Transparency=.35
  add("RearWindow",Vector3.new(cabinW-1,1.3,0.3),Vector3.new(0,cabinY,cabinZ+cabinD/2-0.1),GLASS,Enum.Material.Glass).Transparency=.35
 end
 local seat
 if v.Id=="Scooter" then
  chassis=add("Chassis",Vector3.new(4,0.8,7),Vector3.new(0,-1.2,0),v.Color)
  add("RearBody",Vector3.new(3.5,1.5,3),Vector3.new(0,-0.5,2),v.Color)
  add("FrontColumn",Vector3.new(1,3.5,1),Vector3.new(0,0.5,-3),DARK)
  add("Handlebar",Vector3.new(5,0.6,0.6),Vector3.new(0,2.2,-3),DARK)
  add("GripL",Vector3.new(1.2,0.7,0.7),Vector3.new(-2.4,2.2,-3),DARK)
  add("GripR",Vector3.new(1.2,0.7,0.7),Vector3.new(2.4,2.2,-3),DARK)
  add("FrontFender",Vector3.new(2.2,0.5,2.5),Vector3.new(0,0.1,-3.1),v.Color)
  add("Headlight",Vector3.new(1,0.8,0.5),Vector3.new(0,0.9,-3.5),WHITE,Enum.Material.Neon)
  add("Taillight",Vector3.new(1,0.6,0.4),Vector3.new(0,0.4,3.7),Color3.fromRGB(255,40,40),Enum.Material.Neon)
  wheel(0,-3,2,1,WHITE)
  wheel(0,3,2,1,WHITE)
  seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(2.5,1,3);seat.CFrame=CFrame.new(0,0.8,1.5)
 elseif v.Id=="Car" then
  chassis=add("Chassis",Vector3.new(8,1.4,14),Vector3.new(0,-0.8,0),v.Color)
  add("Hood",Vector3.new(8,0.8,4),Vector3.new(0,-0.5,-5),v.Color,nil,nil,CFrame.Angles(math.rad(-12),0,0))
  add("Cabin",Vector3.new(7,2,6.5),Vector3.new(0,1.0,0.5),v.Color)
  glassWindows(7,1.1,0.5,6.5)
  add("RearRoof",Vector3.new(7,0.5,2),Vector3.new(0,2.2,2.75),v.Color)
  add("BumperF",Vector3.new(8.5,0.8,0.8),Vector3.new(0,-1.0,-7.2),DARK)
  add("BumperR",Vector3.new(8.5,0.8,0.8),Vector3.new(0,-1.0,7.2),DARK)
  add("Grille",Vector3.new(5,0.8,0.3),Vector3.new(0,-0.6,-7.1),DARK)
  add("MirrorL",Vector3.new(0.8,0.5,0.5),Vector3.new(-4.2,0.8,-2),DARK)
  add("MirrorR",Vector3.new(0.8,0.5,0.5),Vector3.new(4.2,0.8,-2),DARK)
  lights(-0.3)
  wheel(-4.5,-5,3,1)
  wheel(4.5,-5,3,1)
  wheel(-4.5,5,3,1)
  wheel(4.5,5,3,1)
  seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.CFrame=CFrame.new(0,0.6,0.5)
 elseif v.Id=="Supercar" then
  chassis=add("Chassis",Vector3.new(9,1,14),Vector3.new(0,-1.0,0),v.Color)
  add("Nose",Vector3.new(9,1,5),Vector3.new(0,-0.8,-5),v.Color,nil,nil,CFrame.Angles(math.rad(-15),0,0))
  add("Cabin",Vector3.new(6,1.6,6),Vector3.new(0,0.5,1),v.Color)
  glassWindows(6,0.7,1,6)
  add("Spoiler",Vector3.new(8,0.4,2),Vector3.new(0,1.8,6.5),DARK)
  add("SpoilerStrutL",Vector3.new(0.5,1.5,0.5),Vector3.new(-2.5,1.0,6.5),DARK)
  add("SpoilerStrutR",Vector3.new(0.5,1.5,0.5),Vector3.new(2.5,1.0,6.5),DARK)
  add("SkirtL",Vector3.new(0.5,0.6,12),Vector3.new(-4.6,-1.2,0),DARK)
  add("SkirtR",Vector3.new(0.5,0.6,12),Vector3.new(4.6,-1.2,0),DARK)
  local glow=add("Underglow",Vector3.new(8,0.3,13),Vector3.new(0,-1.6,0),Color3.fromRGB(80,240,255),Enum.Material.Neon);glow.CanCollide=false
  add("HeadlightL",Vector3.new(2.5,0.4,0.3),Vector3.new(-2.2,-0.6,-7.1),WHITE,Enum.Material.Neon)
  add("HeadlightR",Vector3.new(2.5,0.4,0.3),Vector3.new(2.2,-0.6,-7.1),WHITE,Enum.Material.Neon)
  add("TaillightBar",Vector3.new(7,0.5,0.3),Vector3.new(0,-0.6,7.1),Color3.fromRGB(255,40,40),Enum.Material.Neon)
  wheel(-4.7,-5,3.2,1.4,GOLD)
  wheel(4.7,-5,3.2,1.4,GOLD)
  wheel(-4.7,5,3.2,1.4,GOLD)
  wheel(4.7,5,3.2,1.4,GOLD)
  seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.CFrame=CFrame.new(0,0.3,1)
 else -- TralaleroMobile: the shark car. Blue body, toothy grin, shark
  -- eyes on the hood, dorsal fin on the cabin, tail fin at the rear,
  -- gold band (Tralalero's chain) and white sneaker rims.
  chassis=add("Chassis",Vector3.new(8,1.5,14),Vector3.new(0,-0.7,0),v.Color)
  add("Snout",Vector3.new(7,1.2,3),Vector3.new(0,-0.5,-6.5),v.Color,nil,nil,CFrame.Angles(math.rad(-12),0,0))
  add("Mouth",Vector3.new(6,0.8,0.3),Vector3.new(0,-1.0,-7.1),DARK)
  for i=-2,2 do add("Tooth",Vector3.new(0.8,0.6,0.3),Vector3.new(i*1.2,-0.7,-7.2),WHITE) end
  add("EyeL",Vector3.new(1.2,1.2,1.2),Vector3.new(-2,0.3,-5.5),WHITE,nil,Enum.PartType.Ball)
  add("EyeR",Vector3.new(1.2,1.2,1.2),Vector3.new(2,0.3,-5.5),WHITE,nil,Enum.PartType.Ball)
  add("PupilL",Vector3.new(0.6,0.6,0.6),Vector3.new(-2,0.3,-6.15),DARK,nil,Enum.PartType.Ball)
  add("PupilR",Vector3.new(0.6,0.6,0.6),Vector3.new(2,0.3,-6.15),DARK,nil,Enum.PartType.Ball)
  add("Cabin",Vector3.new(7,1.8,6),Vector3.new(0,0.8,0.5),v.Color)
  glassWindows(7,0.9,0.5,6)
  add("GoldBand",Vector3.new(7.2,0.4,6.2),Vector3.new(0,0.0,0.5),GOLD,Enum.Material.Metal)
  add("DorsalFin",Vector3.new(0.6,2.5,3.5),Vector3.new(0,2.6,1),Color3.fromRGB(40,150,220),nil,nil,CFrame.Angles(math.rad(-15),0,0))
  add("TailFin",Vector3.new(0.6,2,2.5),Vector3.new(0,1.6,7),Color3.fromRGB(40,150,220),nil,nil,CFrame.Angles(math.rad(20),0,0))
  add("TailFluke",Vector3.new(5,0.4,2),Vector3.new(0,2.4,7.2),Color3.fromRGB(40,150,220))
  lights(-0.3)
  wheel(-4.5,-5,3,1,WHITE)
  wheel(4.5,-5,3,1,WHITE)
  wheel(-4.5,5,3,1,WHITE)
  wheel(4.5,5,3,1,WHITE)
  seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.CFrame=CFrame.new(0,0.5,0.5)
 end
 seat.MaxSpeed=drivable and v.Speed or 0
 seat.Torque=drivable and 9000 or 0
 seat.TurnSpeed=drivable and math.deg(v.Turn) or 0
 seat.Anchored=anchored
 seat.Parent=m
 weldAll()
 m.PrimaryPart=chassis
 return m
end
local function makeVehicle(player,v)
 local m=buildVehicleModel(v,false,true)
 m.Name=player.Name.."_"..v.Id
 local seat=m:FindFirstChild("DriverSeat")
 local plot=Base.Get(player);local garage=plot and plot.Model:FindFirstChild("Garage");local spawn=garage and (garage.Position+Vector3.new(0,-4,20)) or Vector3.new(-140,4,130)
 m:PivotTo(CFrame.new(spawn));m.Parent=workspace
 Vehicles.Active[player]=m
 seat:GetPropertyChangedSignal("Occupant"):Connect(function()
  if seat.Occupant then local occupant=Players:GetPlayerFromCharacter(seat.Occupant.Parent);if occupant~=player then seat.Occupant.Sit=false;task.defer(function()m:Destroy()end) end
  else task.delay(3,function()if m.Parent and not seat.Occupant then if Vehicles.Active[player]==m then Vehicles.Active[player]=nil end;m:Destroy()end end) end
 end)
 return m
end
-- Session 23: a static display copy of a vehicle for the showroom pads.
-- Same builder as makeVehicle (session 25: real shaping, not a box), but
-- anchored and never driven, so it can sit on a display pad. The seat is
-- inert (MaxSpeed/Torque 0) and every part is anchored.
function Vehicles.BuildDisplayModel(v)
 local m=buildVehicleModel(v,true,false)
 m.Name="Display_"..v.Id
 return m
end
function Vehicles.Buy(player,id)
 local d=Data.Get(player);local v=spec(id);if not d or not v or not d.Vehicles[id] then return false end
 if Vehicles.Active[player] then Vehicles.Active[player]:Destroy();Vehicles.Active[player]=nil end
 return makeVehicle(player,v)~=nil
end
function Vehicles.Purchase(player,id)
 local d=Data.Get(player);local v=spec(id);if not d or not v or d.Vehicles[id] or not Coin.TrySpend(player,v.Price) then return false end
 d.Vehicles[id]=true;return Vehicles.Buy(player,id)
end
function Vehicles.Init(remotes)
 remotes.BuyVehicle.OnServerInvoke=function(p,id)local d=Data.Get(p);if d and d.Vehicles[id] then return Vehicles.Buy(p,id) end;return Vehicles.Purchase(p,id) end
 local dealer=workspace:FindFirstChild("ItalianBrainrotWorld") and workspace.ItalianBrainrotWorld:FindFirstChild("Dealership")
 local sign=dealer and dealer:FindFirstChild("Facade");if sign then local prompt=Instance.new("ProximityPrompt");prompt.ActionText="MOTORI SHOWROOM";prompt.ObjectText="MOTORI DEALERSHIP";prompt.Parent=sign;prompt.Triggered:Connect(function(p) remotes.Notify:FireClient(p,"Walk into the MOTORI SHOWROOM next door to see and buy vehicles — or use MENU > VEHICLES. Owned vehicles spawn at your base garage.","INFO") end) end
 -- Session 23: the physical vehicle store. Each showroom pad carries a
 -- "PurchasePrompt" (the GameService travel scan skips that name, so E
 -- never teleports the player) with a VehicleId attribute. The prompt
 -- reuses the same server-side validation as the Vehicles menu:
 -- Vehicles.Purchase (cash check, ownership saved to the profile).
 -- Owned: pressing E spawns the vehicle instead. Every outcome is
 -- notified visibly — a silent failed purchase is never acceptable.
 local showroom=workspace:FindFirstChild("ItalianBrainrotWorld") and workspace.ItalianBrainrotWorld:FindFirstChild("VehicleShowroom")
 if showroom then
  for _,pad in ipairs(showroom:GetChildren()) do
   local prompt=pad:FindFirstChild("PurchasePrompt")
   local id=prompt and prompt:GetAttribute("VehicleId")
   local v=id and spec(id)
   if prompt and v then
    prompt.Triggered:Connect(function(p)
     local d=Data.Get(p)
     if not d then remotes.Notify:FireClient(p,"PURCHASE FAILED • Player data is still loading. Try again shortly.","LOCKED");return end
     if d.Vehicles[id] then
      if Vehicles.Buy(p,id) then remotes.Notify:FireClient(p,v.Id.." • Already owned — spawned at your garage!","INFO") else remotes.Notify:FireClient(p,"SPAWN FAILED • Your vehicle could not be spawned. Try again.","LOCKED") end
      return
     end
     if d.Cash<v.Price then remotes.Notify:FireClient(p,"PURCHASE FAILED • You need $"..v.Price.." for this vehicle.","LOCKED");return end
     if Vehicles.Purchase(p,id) then remotes.Notify:FireClient(p,"PURCHASED "..v.Id.."!  •  $"..v.Price,"INFO") else remotes.Notify:FireClient(p,"PURCHASE FAILED • This vehicle is unavailable.","LOCKED") end
    end)
   end
  end
 end
 Players.PlayerRemoving:Connect(function(p)if Vehicles.Active[p] then Vehicles.Active[p]:Destroy();Vehicles.Active[p]=nil end end)
 -- Keep motion server-authoritative while preserving VehicleSeat steering input.
 RunService.Heartbeat:Connect(function(dt) for p,m in pairs(Vehicles.Active) do local seat=m and m:FindFirstChild("DriverSeat");local body=m and m.PrimaryPart;if not seat or not body or not m.Parent then Vehicles.Active[p]=nil else local occupant=seat.Occupant;if occupant and Players:GetPlayerFromCharacter(occupant.Parent)==p then local v=spec(string.match(m.Name,"_(.+)$"));if v then local turn=seat.SteerFloat*v.Turn*dt;local move=seat.ThrottleFloat*v.Speed*dt;local cf=body.CFrame*CFrame.Angles(0,turn,0)*CFrame.new(0,0,-move);m:PivotTo(cf) end end end end end)
end
return Vehicles
