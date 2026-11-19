local E={Active=nil}
local events={
 {Name="GOLDEN HOUR",Description="2× passive income",Income=2},
 {Name="BRAINROT RAIN",Description="25% off marketplace purchases",Discount=.25},
 {Name="MEME RUSH",Description="3× passive income burst",Income=3},
}
function E.GetIncomeMultiplier() return E.Active and E.Active.Income or 1 end
function E.GetDiscount() return E.Active and E.Active.Discount or 0 end
function E.Init(remotes)
 local Shop=require(script.Parent.ShopService)
 task.spawn(function()
  local index=0
  while true do
   -- Give a fresh Studio session time to see one event; later cycles retain the 180s rest.
   task.wait(index==0 and 25 or 180)
   index=index%#events+1
   local event=events[index];local finish=workspace:GetServerTimeNow()+75
   E.Active=event
   Shop.RefreshMarketPrices()
   for _,p in ipairs(game.Players:GetPlayers()) do remotes.WorldEvent:FireClient(p,event.Name,event.Description,finish) end
   task.wait(75)
   E.Active=nil
   Shop.RefreshMarketPrices()
   for _,p in ipairs(game.Players:GetPlayers()) do remotes.WorldEvent:FireClient(p,"","",0) end
  end
 end)
end
return E
