local HUD={}
function HUD.Init()
 local function capText(control,size) local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=8;limit.MaxTextSize=size;limit.Parent=control end
 local p=game.Players.LocalPlayer;local gui=Instance.new("ScreenGui");gui.Name="WorldHUD";gui.ResetOnSpawn=false;gui.Parent=p:WaitForChild("PlayerGui")
 local bar=Instance.new("Frame");bar.Size=UDim2.fromOffset(570,58);bar.Position=UDim2.fromOffset(18,16);bar.BackgroundColor3=Color3.fromRGB(24,27,45);bar.BackgroundTransparency=.12;bar.Parent=gui;Instance.new("UICorner",bar).CornerRadius=UDim.new(0,14)
 local text=Instance.new("TextLabel");text.Name="Stats";text.Size=UDim2.new(1,-20,1,0);text.Position=UDim2.fromOffset(10,0);text.BackgroundTransparency=1;text.Text="💰 $500     💎 0     ⭐ Lv 1     🔥 0";text.TextColor3=Color3.new(1,1,1);text.Font=Enum.Font.GothamBold;text.TextScaled=true;text.Parent=bar;capText(text,18)
 local menu=Instance.new("TextButton");menu.Size=UDim2.fromOffset(128,52);menu.Position=UDim2.new(1,-145,0,18);menu.Text="☰  MENU";menu.Font=Enum.Font.GothamBlack;menu.TextScaled=true;menu.BackgroundColor3=Color3.fromRGB(45,48,78);menu.TextColor3=Color3.new(1,1,1);menu.Parent=gui;capText(menu,17);Instance.new("UICorner",menu).CornerRadius=UDim.new(0,12)
 local rem=game:GetService("ReplicatedStorage"):WaitForChild("Remotes");local state
 rem.State.OnClientEvent:Connect(function(s)state=s;text.Text=string.format("💰 $%s   +$%s/s    💎 %s   ⭐ Lv %s   🔥 %s",tostring(s.Cash),tostring(s.Income),tostring(s.Gems),tostring(s.Level),tostring(s.Rebirths))end)
 local function openPanel(title,rows,scroll)
  local old=gui:FindFirstChild("InfoPanel");if old then old:Destroy()end
  local f=Instance.new("Frame");f.Name="InfoPanel";f.Size=UDim2.fromOffset(460,470);f.Position=UDim2.new(1,-480,0,82);f.BackgroundColor3=Color3.fromRGB(25,28,50);f.Parent=gui;Instance.new("UICorner",f).CornerRadius=UDim.new(0,14)
  local head=Instance.new("TextLabel");head.Size=UDim2.new(1,-55,0,48);head.Position=UDim2.fromOffset(12,3);head.BackgroundTransparency=1;head.Text=title;head.TextColor3=Color3.fromRGB(255,215,100);head.Font=Enum.Font.GothamBlack;head.TextScaled=true;head.Parent=f;capText(head,18)
  local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(38,38);close.Position=UDim2.new(1,-43,0,8);close.Text="×";close.TextScaled=true;close.Parent=f;capText(close,20);close.Activated:Connect(function()f:Destroy()end)
  local list=Instance.new(scroll and "ScrollingFrame" or "Frame");list.Size=UDim2.new(1,-20,1,-62);list.Position=UDim2.fromOffset(10,54);list.BackgroundTransparency=1;list.Parent=f
  if scroll then list.CanvasSize=UDim2.new(0,0,0,#rows*48);list.ScrollBarThickness=8 end
  for i,row in ipairs(rows)do local b=Instance.new("TextButton");b.Size=UDim2.new(1,-6,0,42);b.Position=UDim2.fromOffset(3,(i-1)*47);b.Text=row.text;b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextScaled=true;b.BackgroundColor3=Color3.fromRGB(58,65,100);b.Parent=list;capText(b,15);Instance.new("UICorner",b).CornerRadius=UDim.new(0,8);if row.click then b.Activated:Connect(row.click)else b.Active=false end end
 end
 menu.Activated:Connect(function()
  local old=gui:FindFirstChild("MenuPanel");if old then old:Destroy();return end
  local f=Instance.new("Frame");f.Name="MenuPanel";f.Size=UDim2.fromOffset(250,360);f.Position=UDim2.new(1,-275,0,80);f.BackgroundColor3=Color3.fromRGB(25,28,50);f.Parent=gui;Instance.new("UICorner",f).CornerRadius=UDim.new(0,14)
  for i,name in ipairs({"Shop","Brainrots / Index","Quests","Map","Leaderboard","Vehicles","Gem Shop","Home"})do local b=Instance.new("TextButton");b.Size=UDim2.new(1,-20,0,40);b.Position=UDim2.fromOffset(10,8+(i-1)*43);b.Text=name;b.Font=Enum.Font.GothamBold;b.TextScaled=true;b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(58,65,100);b.Parent=f;capText(b,15);Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
   b.Activated:Connect(function()
    if name=="Home" then rem.Travel:InvokeServer("Home");return end
    local rows={}
    if name=="Shop" then rem.Travel:InvokeServer("Market");local config=require(game.ReplicatedStorage.Modules.Config);for _,e in ipairs(config.Catalogue)do if not e.PremiumOnly then local gate=e.Rarity=="SECRET" and "Volcano" or e.Rarity=="DIVINE" and "Secret Dimension" or nil;local gateText="AVAILABLE";if gate then local zone;for _,z in ipairs(config.Zones)do if z.Name==gate then zone=z end end;gateText=state and state.UnlockedZones and state.UnlockedZones[gate] and "UNLOCKED" or ("LOCKED • "..gate.." / $"..zone.Requirement.." / Lv "..zone.Level.." / Reb "..zone.Rebirths) end;table.insert(rows,{text=string.format("%s • %s • $%d • +$%d/s • %s",e.Name,e.Rarity,e.Price,e.Income,gateText),click=function()rem.BuyBrainrot:InvokeServer(e.Id)end})end end
    elseif name=="Vehicles" then local config=require(game.ReplicatedStorage.Modules.Config);for _,v in ipairs(config.Vehicles)do local owned=state and state.Vehicles and state.Vehicles[v.Id];table.insert(rows,{text=v.Id.." • $"..v.Price..(owned and " • OWNED • SPAWN" or " • BUY"),click=function()rem.BuyVehicle:InvokeServer(v.Id)end})end
    elseif name=="Gem Shop" then local config=require(game.ReplicatedStorage.Modules.Config);for _,u in ipairs(config.GemUpgrades)do table.insert(rows,{text=u.Name.." • 💎 "..u.Price,click=function()rem.GemPurchase:InvokeServer(u.Id)end})end;for _,e in ipairs(config.PremiumBrainrots)do table.insert(rows,{text=e.Name.." • "..e.Rarity.." • +$"..e.Income.."/s • 💎 "..e.Price,click=function()rem.GemPurchase:InvokeServer(e.Id)end})end
    elseif name=="Brainrots / Index" then local config=require(game.ReplicatedStorage.Modules.Config);local owned=state and state.OwnedIds or {};for _,e in ipairs(config.Catalogue)do table.insert(rows,{text=owned[e.Id] and (e.Name.."  •  "..e.Rarity.."  •  +$"..e.Income.."/s") or "???  •  LOCKED"})end;openPanel("BRAINROT INDEX  •  "..tostring(state and state.DiscoveredCount or 0).." / "..tostring(config.IndexSize).." DISCOVERED",rows,true);return
    elseif name=="Quests" then local quests=state and state.Quests or {};local owned=state and state.OwnedIds or {};local rare=false;for id in pairs(owned)do if require(game.ReplicatedStorage.Modules.Config).Catalogue[id].Rarity=="RARE" then rare=true end end;local progress={first=(state and state.Owned or 0)>0,rare=rare,million=(state and state.TotalEarned or 0)>=1000000,upgrade=(state and state.BaseLevel or 1)>1,collect25=(state and state.Owned or 0)>=25};for _,q in ipairs({{"first","Buy your first Brainrot"},{"rare","Purchase a Rare Brainrot"},{"million","Earn $1,000,000 total"},{"upgrade","Upgrade your base"},{"collect25","Collect 25 Brainrots"}})do local id,label=q[1],q[2];local status=quests[id] and "CLAIMED" or progress[id] and "READY • CLAIM" or "IN PROGRESS";table.insert(rows,{text=label.."  •  "..status,click=progress[id] and not quests[id] and function()rem.QuestClaim:InvokeServer(id)end or nil})end
    elseif name=="Map" then for _,z in ipairs({"Starter City","Italian Village","Neon City","Luxury District","Volcano","Sky Islands","Secret Dimension"})do table.insert(rows,{text="TRAVEL  •  "..z,click=function()rem.Travel:InvokeServer(z)end})end
    else for _,s in ipairs({"Cash","Income","Brainrots","Rebirths"})do local key=s=="Brainrots" and "Owned" or s;local v=state and state[key] or "—";table.insert(rows,{text=s.."  •  "..tostring(v)})end end
    openPanel(name,rows,true)
   end)
  end
 end)
 return gui
end
return HUD
