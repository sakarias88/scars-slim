
local function makeExit( ply, pos, veh )
	ply:SetPos(pos)
	ply:SetVelocity( veh:GetVelocity() * 0.8)
	ply:SetEyeAngles( (veh:GetPos() - ply:GetPos()):Angle() )
end


local function CheckIfCanExit(ply, veh, SCar, id)
	
	if veh != NULL && IsValid(veh) && SCar != NULL && IsValid(SCar) then
		local seat = nil
		local leftRight = 0
		local maxs = SCar:OBBMaxs()
		local mins = SCar:OBBMins()
		local leng = (maxs.y - mins.y) * 2
		local plyLeng = (ply:OBBMaxs().y - ply:OBBMins().y)
			
		for i = id, SCar.NrOfSeats + id do
			local slot = i % (SCar.NrOfSeats + 1)
		
			if SCar.SeatPos[slot] && SCar.SeatPos[slot].y then
		
				--Check for specific exits
				if SCar.NrOfExits and SCar.Exits then
					for exID = 1, SCar.NrOfExits do
						if SCar.Exits[exID] then
							local vec = SCar:GetPos() + SCar:GetForward() * SCar.Exits[exID].x + SCar:GetRight() * SCar.Exits[exID].y + SCar:GetUp() * SCar.Exits[exID].z 
							local traceCheckCloseObj = {}
							traceCheckCloseObj.start = vec
							traceCheckCloseObj.endpos = vec
							traceCheckCloseObj.filter = ply
							traceCheckCloseObj.mins = ply:OBBMins()
							traceCheckCloseObj.maxs = ply:OBBMaxs()
							traceCheckCloseObj.mask = MASK_PLAYERSOLID
							traceCheckCloseObj.filter = { SCar, SCar.Seats, SCar.Wheels, SCar.StabilizerProp, ply, SCar.ExitFilter }
							local trClose = util.TraceHull( traceCheckCloseObj )				
							
							if !trClose.Hit then
								return vec
							end
						end
					end
				end
		
		
		
				if SCar.SeatPos[slot].y > 0 then
					leftRight = 1
				else
					leftRight = -1
				end	
				
				local trace = {}
				trace.start = veh:GetPos()
				trace.endpos = veh:GetPos() + (SCar:GetRight() * leng * leftRight )
				trace.filter = { SCar, SCar.Seats, SCar.Wheels, SCar.StabilizerProp, ply }
				local tr = util.TraceLine( trace )
				
				trace.start = tr.HitPos
				trace.endpos = veh:GetPos()
				trace.filter = ply
				local tr = util.TraceLine( trace )		
				
				--Check for objects close to the door. Fixes so we can't go through walls.
				local traceCheckCloseObj = {}
				traceCheckCloseObj.start = tr.HitPos
				traceCheckCloseObj.endpos = tr.HitPos
				traceCheckCloseObj.filter = ply
				traceCheckCloseObj.mins = ply:OBBMins()
				traceCheckCloseObj.maxs = ply:OBBMaxs()
				traceCheckCloseObj.mask = MASK_PLAYERSOLID
				traceCheckCloseObj.filter = { SCar, SCar.Seats, SCar.Wheels, SCar.StabilizerProp, ply }
				local trClose = util.TraceHull( traceCheckCloseObj )				
				
				if !trClose.Hit then
					local traceH = {}
					traceH.start = tr.HitPos + (SCar:GetRight() * plyLeng * leftRight )
					traceH.endpos = tr.HitPos + (SCar:GetRight() * plyLeng * leftRight )
					traceH.filter = ply
					traceH.mins = ply:OBBMins()
					traceH.maxs = ply:OBBMaxs()
					traceH.mask = MASK_PLAYERSOLID
					local trH = util.TraceHull( traceH )			

					if !trH.Hit then
						return trH.HitPos
					end	
				end				
			end
		end
	end
	return nil
end

function CustomSCarVehicleExits(ply, veh)

	if veh.IsScarSeat == true then
		
		if ply:GetViewEntity():GetClass() != "gmod_cameraprop" then
			ply:SetViewEntity(ply)
		end	
	
		local pos = CheckIfCanExit(ply, veh, veh.EntOwner, veh.SeatPosID )
		
		if pos != nil then
			makeExit( ply, pos, veh )
		end
	end
end
hook.Add("PlayerLeaveVehicle", "CustomSCarVehicleExits", CustomSCarVehicleExits)

