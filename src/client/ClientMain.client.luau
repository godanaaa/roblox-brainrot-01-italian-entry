local Players=game:GetService("Players");local p=Players.LocalPlayer
local function init(name)
 local ok,err=pcall(function()require(script.Parent[name]).Init()end);if not ok then warn("[IBW] "..name.." Init failed safely: "..tostring(err))end
end
-- Menu is created first and independently guarded; missing characters/world never prevent its appearance.
init("MenuController")
for _,name in ipairs({"HUDController","InteractionController","EffectsController","ProximityLabels"})do init(name)end
