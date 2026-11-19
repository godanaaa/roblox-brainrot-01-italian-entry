local C=require(game.ReplicatedStorage.Modules.Config);local I={};function I.Init()
 local CAS=game:GetService("ContextActionService");local rem=game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
 local function bind(key,act) CAS:BindAction("IBW_"..act,function(_,state)if state==Enum.UserInputState.Begin then if act=="Shop"then rem.Travel:InvokeServer("Market")elseif act=="Home"then rem.Travel:InvokeServer("Home")end end;return Enum.ContextActionResult.Sink end,false,key)end
 bind(Enum.KeyCode.B,"Shop");bind(Enum.KeyCode.H,"Home")
end;return I
