local Util={}
function Util.Part(parent,name,size,position,color,material)
 local p=Instance.new("Part"); p.Name=name;p.Size=size;p.Position=position;p.Anchored=true;p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
-- Session 19: stall labels are narrower (150x40) and show only within 16
-- studs, so neighbouring stalls' labels stop overlapping and clipping at
-- the screen edges. Defaults (190x48, 24 studs) are unchanged for signs,
-- landmarks, travel pads and base plaques.
function Util.Label(part,text,color,w,h,maxDist)
 local gui=Instance.new("BillboardGui");gui.Name="WorldLabel";gui.Size=UDim2.fromOffset(w or 190,h or 48);gui.StudsOffset=Vector3.new(0,4,0);gui.AlwaysOnTop=true;gui.MaxDistance=maxDist or 24;gui.Parent=part
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextColor3=color or Color3.new(1,1,1);t.TextStrokeTransparency=.25;t.Font=Enum.Font.GothamBlack;t.TextScaled=true;local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=8;limit.MaxTextSize=18;limit.Parent=t;t.Parent=gui;return gui
end
function Util.Round(n) return math.floor(n+0.5) end
return Util
