local E={};function E.Init()
 local rem=game:GetService("ReplicatedStorage"):WaitForChild("Remotes");rem.Notify.OnClientEvent:Connect(function(msg,rarity)
  local p=game.Players.LocalPlayer;local gui=Instance.new("ScreenGui");gui.Name="Celebration";gui.ResetOnSpawn=false;gui.Parent=p:WaitForChild("PlayerGui");local t=Instance.new("TextLabel");t.Size=UDim2.fromOffset(620,80);t.Position=UDim2.new(.5,-310,.2,0);t.BackgroundColor3=Color3.fromRGB(35,28,55);t.Text=msg;t.TextColor3=Color3.fromRGB(255,220,90);t.TextStrokeTransparency=.3;t.Font=Enum.Font.GothamBlack;t.TextScaled=true;local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=9;limit.MaxTextSize=22;limit.Parent=t;t.Parent=gui;Instance.new("UICorner",t).CornerRadius=UDim.new(0,16);task.delay(3,function()gui:Destroy()end)
  local sound=Instance.new("Sound");sound.SoundId="rbxasset://sounds/electronicpingshort.wav";sound.Volume=.6;sound.Parent=workspace;pcall(function()sound:Play()end);game:GetService("Debris"):AddItem(sound,3)
 end)
end;return E
