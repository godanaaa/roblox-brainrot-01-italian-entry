local ReplicatedStorage=game:GetService("ReplicatedStorage")
local folder=ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder");folder.Name="Remotes";folder.Parent=ReplicatedStorage
local names={"Play","BuyBrainrot","UpgradeBase","Collect","Rebirth","QuestClaim","Travel","State","Notify","BuyVehicle","GemPurchase"}
for _,name in ipairs(names) do if not folder:FindFirstChild(name) then local class=(name=="State" or name=="Notify") and "RemoteEvent" or "RemoteFunction";local r=Instance.new(class);r.Name=name;r.Parent=folder end end
return folder
