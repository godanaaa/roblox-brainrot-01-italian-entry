local C=require(game.ReplicatedStorage.Modules.Config)
local Data=require(script.Parent.DataService)
local Base=require(script.Parent.BaseService)
local Coin=require(script.Parent.CoinService)
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Vehicles={Active={}}

local function spec(id) for _,v in ipairs(C.Vehicles) do if v.Id==id then return v end end end
local function makeVehicle(player,v)
 local m=Instance.new("Model");m.Name=player.Name.."_"..v.Id
 local body=Instance.new("Part");body.Name="Chassis";body.Size=v.Id=="Scooter" and Vector3.new(5,2,8) or Vector3.new(9,3,15);body.Color=v.Color;body.Material=Enum.Material.SmoothPlastic;body.Anchored=false;body.Parent=m
 local seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.CFrame=body.CFrame*CFrame.new(0,2,0);seat.MaxSpeed=v.Speed;seat.Torque=9000;seat.TurnSpeed=math.deg(v.Turn);seat.Anchored=false;seat.Parent=m
 local weld=Instance.new("WeldConstraint");weld.Part0=body;weld.Part1=seat;weld.Parent=body
 for i=1,4 do local wheel=Instance.new("Part");wheel.Name="Wheel";wheel.Shape=Enum.PartType.Cylinder;wheel.Size=Vector3.new(2,2,1);wheel.Color=Color3.fromRGB(28,30,38);wheel.Material=Enum.Material.Rubber;wheel.Anchored=false;wheel.CFrame=body.CFrame*CFrame.new((i%2==0 and 1 or -1)*4,-1.2,(i<=2 and -5 or 5))*CFrame.Angles(0,0,math.pi/2);wheel.Parent=m;local w=Instance.new("WeldConstraint");w.Part0=body;w.Part1=wheel;w.Parent=body end
 m.PrimaryPart=body
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
-- Same shape as makeVehicle (chassis + seat + 4 wheels, same sizes and
-- colours) but anchored and never driven, so it can sit on a display pad.
-- The seat is inert (MaxSpeed/Torque 0) and every part is anchored.
function Vehicles.BuildDisplayModel(v)
 local m=Instance.new("Model");m.Name="Display_"..v.Id
 local body=Instance.new("Part");body.Name="Chassis";body.Size=v.Id=="Scooter" and Vector3.new(5,2,8) or Vector3.new(9,3,15);body.Color=v.Color;body.Material=Enum.Material.SmoothPlastic;body.Anchored=true;body.Parent=m
 local seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.CFrame=body.CFrame*CFrame.new(0,2,0);seat.MaxSpeed=0;seat.Torque=0;seat.TurnSpeed=0;seat.Anchored=true;seat.Parent=m
 local weld=Instance.new("WeldConstraint");weld.Part0=body;weld.Part1=seat;weld.Parent=body
 for i=1,4 do local wheel=Instance.new("Part");wheel.Name="Wheel";wheel.Shape=Enum.PartType.Cylinder;wheel.Size=Vector3.new(2,2,1);wheel.Color=Color3.fromRGB(28,30,38);wheel.Material=Enum.Material.Rubber;wheel.Anchored=true;wheel.CFrame=body.CFrame*CFrame.new((i%2==0 and 1 or -1)*4,-1.2,(i<=2 and -5 or 5))*CFrame.Angles(0,0,math.pi/2);wheel.Parent=m;local w=Instance.new("WeldConstraint");w.Part0=body;w.Part1=wheel;w.Parent=body end
 m.PrimaryPart=body
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
