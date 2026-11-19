local E={};local activeNotifies={};function E.Init()
 local rem=game:GetService("ReplicatedStorage"):WaitForChild("Remotes");rem.Notify.OnClientEvent:Connect(function(msg,rarity)
  -- Notifications live at the TOP of the screen, stacked below the event
  -- banner (banner spans y 82..146), never in the middle: the first sits
  -- at y=158, each further one 70px lower. Centre-screen stays clear.
  local p=game.Players.LocalPlayer;local gui=Instance.new("ScreenGui");gui.Name="Celebration";gui.ResetOnSpawn=false;gui.Parent=p:WaitForChild("PlayerGui");local t=Instance.new("TextLabel");t.Size=UDim2.fromOffset(560,64);t.Position=UDim2.new(.5,-280,0,158+#activeNotifies*70);t.BackgroundColor3=Color3.fromRGB(35,28,55);t.Text=msg;t.TextColor3=Color3.fromRGB(255,220,90);t.TextStrokeTransparency=.3;t.Font=Enum.Font.GothamBlack;t.TextScaled=true;local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=9;limit.MaxTextSize=18;limit.Parent=t;t.Parent=gui;Instance.new("UICorner",t).CornerRadius=UDim.new(0,16);table.insert(activeNotifies,t);task.delay(3,function()local i=table.find(activeNotifies,t);if i then table.remove(activeNotifies,i) end;for j,label in ipairs(activeNotifies) do label.Position=UDim2.new(.5,-280,0,158+(j-1)*70) end;gui:Destroy()end)
  local sound=Instance.new("Sound");sound.SoundId="rbxasset://sounds/electronicpingshort.wav";sound.Volume=.6;sound.Parent=workspace;pcall(function()sound:Play()end);game:GetService("Debris"):AddItem(sound,3)
 end)
 rem.WorldEvent.OnClientEvent:Connect(function(name,description,endsAt)
  local player=game.Players.LocalPlayer;local gui=player:WaitForChild("PlayerGui"):FindFirstChild("WorldEventBanner")
  if not name or name=="" then if gui then gui:Destroy() end;return end
  if not gui then gui=Instance.new("ScreenGui");gui.Name="WorldEventBanner";gui.ResetOnSpawn=false;gui.Parent=player.PlayerGui end
  local label=gui:FindFirstChild("Banner")
  if not label then
   label=Instance.new("TextLabel");label.Name="Banner";label.Size=UDim2.fromOffset(620,64);label.Position=UDim2.new(.5,-310,0,82);label.BackgroundColor3=Color3.fromRGB(39,26,68);label.TextColor3=Color3.fromRGB(255,232,120);label.Font=Enum.Font.GothamBlack;label.TextScaled=true;label.Parent=gui
   Instance.new("UICorner",label).CornerRadius=UDim.new(0,14);local cap=Instance.new("UITextSizeConstraint");cap.MinTextSize=10;cap.MaxTextSize=20;cap.Parent=label
   local barBack=Instance.new("Frame");barBack.Name="ProgressBack";barBack.Size=UDim2.new(1,-28,0,10);barBack.Position=UDim2.new(0,14,0,69);barBack.BackgroundColor3=Color3.fromRGB(25,22,38);barBack.BorderSizePixel=0;barBack.Parent=gui;Instance.new("UICorner",barBack).CornerRadius=UDim.new(1,0)
   local fill=Instance.new("Frame");fill.Name="ProgressFill";fill.Size=UDim2.fromScale(1,1);fill.BackgroundColor3=Color3.fromRGB(90,235,150);fill.BorderSizePixel=0;fill.Parent=barBack;Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
  end
  local label=gui:FindFirstChild("Banner");local fill=gui:FindFirstChild("ProgressFill",true);local started=workspace:GetServerTimeNow()
  task.spawn(function()while gui.Parent and workspace:GetServerTimeNow()<endsAt do local now=workspace:GetServerTimeNow();label.Text=string.format("%s  •  %s  •  %ds",name,description,math.max(0,math.ceil(endsAt-now)));if fill then fill.Size=UDim2.new(math.clamp((endsAt-now)/math.max(1,endsAt-started),0,1),0,1,0) end;task.wait(.25)end;if gui.Parent then gui:Destroy() end end)
 end)
end;return E
