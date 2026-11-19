local D=require(script.Parent.DataService);local I={};function I.Count(p)local d=D.Get(p);local n=0;if d then for _ in pairs(d.Discovered) do n+=1 end end;return n end;return I
