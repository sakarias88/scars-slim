
local function SCarDoNotCollideWithNodes( ent1, ent2 )
	if (ent1.IRNode and ent2.SCarGroup) or (ent1.SCarGroup and ent2.IRNode) then
		return false
	end 
end
hook.Add( "ShouldCollide", "SCarDoNotCollideWithNodes", SCarDoNotCollideWithNodes )