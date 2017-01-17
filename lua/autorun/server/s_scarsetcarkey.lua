concommand.Add( "SetSCarPlayerSCarKey", function( ply, com, args )
	ply.ScarSpecialKeyInput[SCarKeys.KeyVarTransTable[math.floor(tonumber(args[1]))]] = math.floor(tonumber(args[2]))
end)

function SCarKeys:KeyDown(ply, key)
	if ply and key and ply.ScarSpecialKeyInput[key] and ply.ScarSpecialKeyInput[key] == 2 then return true end
	return false
end

function SCarKeys:KeyWasReleased(ply, key)
	if ply and key and ply.ScarSpecialKeyInput[key] and ply.ScarSpecialKeyInput[key] == 3 then return true end
	return false
end

function SCarKeys:KeyWasPressed(ply, key)
	if ply and key and ply.ScarSpecialKeyInput[key] and ply.ScarSpecialKeyInput[key] >= 2 then return true end
	return false
end

function SCarKeys:KillKey(ply, key)
	if ply and key and ply.ScarSpecialKeyInput[key] then 
		ply.ScarSpecialKeyInput[key] = 0
	end
end


-----------------Mouse input
local function AddDefaultMousePos( ply ) 

	ply.SCarMouseMoveX = 0
	ply.SCarMouseMoveY = 0	
end
hook.Add("PlayerInitialSpawn", "SCarMouseSetDefaultValues", AddDefaultMousePos)

concommand.Add( "SetSCarMouseMovementX", function( ply, com, args )
	if(args[1]) then
		ply.SCarMouseMoveX = tonumber(args[1])
	end
end)

concommand.Add( "SetSCarMouseMovementY", function( ply, com, args )
	if(args[1]) then
		ply.SCarMouseMoveY = tonumber(args[1])
	end
end)