-- Session 17: a rebirth cost $1,000,000 x (rebirths+1). The old gates
-- required Rebirth 1-3 to visit the later zones, so a rebirth was a wall
-- (the first rebirth alone cost $1M). The genre norm is $25K for the
-- first rebirth; now it is $25,000 x (rebirths+1) — $25k, then $50k, then
-- $75k — so a rebirth is a mid-game goal, not an endgame wall. The +25%
-- income per rebirth level is unchanged.
local D=require(script.Parent.DataService);local R={};function R.Try(p) local d=D.Get(p);local cost=25000*(d and (d.Rebirths+1) or 1);if not d or d.Cash<cost then return false end;d.Cash-=cost;d.Rebirths+=1;return true end;return R
