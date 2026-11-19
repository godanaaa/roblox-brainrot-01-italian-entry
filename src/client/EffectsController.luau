local E={};function E.Init()
 local rem=game:GetService("ReplicatedStorage"):WaitForChild("Remotes");rem.Notify.OnClientEvent:Connect(function(msg,rarity)
  local p=game.Players.LocalPlayer;local gui=Instance.new("ScreenGui");gui.Name="Celebration";gui.ResetOnSpawn=false;gui.Parent=p:WaitForChild("PlayerGui");local t=Instance.new("TextLabel");t.Size=UDim2.fromOffset(620,80);t.Position=UDim2.new(.5,-310,.2,0);t.BackgroundColor3=Color3.fromRGB(35,28,55);t.Text=msg;t.TextColor3=Color3.fromRGB(255,220,90);t.TextStrokeTransparency=.3;t.Font=Enum.Font.GothamBlack;t.TextScaled=true;local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=9;limit.MaxTextSize=22;limit.Parent=t;t.Parent=gui;Instance.new("UICorner",t).CornerRadius=UDim.new(0,16);task.delay(3,function()gui:Destroy()end)
  local sound=Instance.new("Sound");sound.SoundId="rbxasset://sounds/electronicpingshort.wav";sound.Volume=.6;sound.Parent=workspace;pcall(function()sound:Play()end);game:GetService("Debris"):AddItem(sound,3)
 end)
 rem.WorldEvent.OnClientEvent:Connect(function(name,description,endsAt)
  local player=game.Players.LocalPlayer;local gui=player:WaitForChild("PlayerGui"):FindFirstChild("WorldEventBanner")
  if not name or name=="" then if gui then gui:Destroy() end;return end
  if not gui then gui=Instance.new("ScreenGui");gui.Name="WorldEventBanner";gui.ResetOnSpawn=false;gui.Parent=player.PlayerGui end
  local label=gui:FindFirstChild("Banner")
  if not label then label=Instance.new("TextLabel");label.Name="Banner";label.Size=UDim2.fromOffset(520,68);label.Position=UDim2.new(.5,-260,0,94);label.BackgroundColor3=Color3.fromRGB(39,26,68);label.TextColor3=Color3.fromRGB(255,232,120);label.Font=Enum.Font.GothamBlack;label.TextScaled=true;label.Parent=gui;Instance.new("UICorner",label).CornerRadius=UDim.new(0,14);local cap=Instance.new("UITextSizeConstraint");cap.MinTextSize=10;cap.MaxTextSize=20;cap.Parent=label end
  task.spawn(function()while gui.Parent and workspace:GetServerTimeNow()<endsAt do label.Text=string.format("🌟 %s  •  %s  •  %ds",name,description,math.max(0,math.ceil(endsAt-workspace:GetServerTimeNow())));task.wait(.25)end;if gui.Parent then gui:Destroy() end end)
 end)
end;return E
