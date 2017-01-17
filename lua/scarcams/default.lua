local Cam = {}
Cam.Name = "Default"

function Cam:Init()
end

function Cam:FirstPerson(ply, position, angles, fov, SCar, veh)	
	local elf = SCarViewManager

	if elf.curView == 1 then
		elf.transPos =  (position + elf.realOffsetPosI) - elf.savePos
		elf.transAng = Angle(0,0,0)
		elf.startTime = CurTime()
	end

	elf.curView = 2

	
	local ang = ply:GetAimVector()
	elf.posOffsetI = elf.posOffsetI + (elf.oldSpeed - SCar:GetVelocity()	) * 0.02
	elf.oldSpeed = SCar:GetVelocity()	

	local dot = SCar:GetForward():Dot(SCar:GetVelocity():GetNormalized())
	local addAng = SCar:GetForward() - SCar:GetVelocity():GetNormalized()

	local moveSpeed = 0.02
	
	if dot < 0 then 
		--dot = -dot 

		addAng.x = 0
		addAng.y = 0
		addAng.z = 0
	end	
	
	local smoothing = (SCar:GetVelocity():Length() / 100)
	smoothing =  math.Clamp( smoothing, 0, 1 )			
	
	addAng = addAng * -smoothing * dot

	elf.realAddAng.x = math.Approach( elf.realAddAng.x, addAng.x, (addAng.x - elf.realAddAng.x) * moveSpeed)
	elf.realAddAng.y = math.Approach( elf.realAddAng.y, addAng.y, (addAng.y - elf.realAddAng.y) * moveSpeed)
	elf.realAddAng.z = math.Approach( elf.realAddAng.z, addAng.z, (addAng.z - elf.realAddAng.z) * moveSpeed)		

	ang = (ang + elf.realAddAng)
	ang:Normalize()
	
	local testAng = angles:Forward():Angle()

	moveSpeed = 0.04
	elf.posOffsetI.x = math.Approach( elf.posOffsetI.x, 0, -elf.posOffsetI.x * moveSpeed)
	elf.posOffsetI.y = math.Approach( elf.posOffsetI.y, 0, -elf.posOffsetI.y * moveSpeed)
	elf.posOffsetI.z = math.Approach( elf.posOffsetI.z, 0, -elf.posOffsetI.z * moveSpeed)		
	
	moveSpeed = 0.1
	if (elf.startTime + elf.endTime) > CurTime() then
		moveSpeed = 0
		elf.posOffsetI = Vector(0,0,0)
		smoothing = 1
		
		local percent = ((elf.startTime + elf.endTime) - CurTime()) / elf.endTime
		percent = percent * percent
		elf.realOffsetPosI.x = -elf.transPos.x * percent
		elf.realOffsetPosI.y = -elf.transPos.y * percent
		elf.realOffsetPosI.z = -elf.transPos.z * percent


		if elf.transAng.p > 180 then 
			angles.p = angles.p + elf.transAng.p + ((360 - elf.transAng.p) * (1 - percent)) 
			elf.saveTransAng.p = ((360 - elf.transAng.p) * (1 - percent)) 
		else
			angles.p = angles.p + elf.transAng.p * percent
			elf.saveTransAng.p = elf.transAng.p * percent
		end
		
		if elf.transAng.y > 180 then
			angles.y = angles.y + elf.transAng.y + ((360 - elf.transAng.y) * (1 - percent)) 
			elf.saveTransAng.y = elf.transAng.y * percent	
		elseif elf.transAng.y < -180 then
			angles.y = angles.y + elf.transAng.y - ((360 + elf.transAng.y) * (1 - percent)) 			
		else
			angles.y = angles.y + elf.transAng.y * percent
			elf.saveTransAng.y = elf.transAng.y * percent				
		end
	else
		elf.transAng = angles - elf.veh:GetAngles()
		elf.realOffsetPosI.x = math.Approach( elf.realOffsetPosI.x, elf.posOffsetI.x, (elf.posOffsetI.x - elf.realOffsetPosI.x) * moveSpeed)
		elf.realOffsetPosI.y = math.Approach( elf.realOffsetPosI.y, elf.posOffsetI.y, (elf.posOffsetI.y - elf.realOffsetPosI.y) * moveSpeed)
		elf.realOffsetPosI.z = math.Approach( elf.realOffsetPosI.z, elf.posOffsetI.z, (elf.posOffsetI.z - elf.realOffsetPosI.z) * moveSpeed)		
	end
		
	elf.newPos = position + elf.realOffsetPosI * smoothing
	
	return elf.newPos, angles, fov
end

function Cam:ThirdPerson(ply, position, angles, fov, SCar, veh)	
	local elf = SCarViewManager

	local dst = 0
	--SCar.ViewDistUp is sometimes nil when the server lags for some odd reason
	if SCar.ViewDistUp then
		dst = SCar.ViewDistUp
	end
	
	local pos = SCar:GetPos() + Vector(0,0,dst)

	if elf.curView == 2 then
		elf.transPos =  (position + elf.realOffsetPosO) - elf.savePos + ( veh:GetPos() - SCar:GetPos() )
		elf.transAng = Angle(0,0,0)
		elf.startTime = CurTime()
		elf.zSmooth = 0
		elf.lastZ = pos.z
	end

	elf.curView = 1

	local ang = ply:GetAimVector()
	local speed = SCar:GetVelocity():Length()
	local vel = SCar:GetVelocity()		
	elf.posOffsetO = elf.posOffsetO + (elf.oldSpeed - vel) * 0.2
	elf.oldSpeed = vel

	elf.zSmooth = elf.zSmooth + (elf.lastZ - pos.z) * 0.2
	elf.zSmooth = math.Approach( elf.zSmooth, 0, -elf.zSmooth * 0.02)
	elf.lastZ = pos.z
	pos.z = elf.zSmooth + pos.z
	
	local dot = SCar:GetForward():Dot(SCar:GetVelocity():GetNormalized())
	local addAng = SCar:GetForward() - SCar:GetVelocity():GetNormalized()

	local moveSpeed = 0.02
	
	
	if dot < 0 and SCarClientData["scar_autoreversecam"] == true then 
		dot = -dot 
		moveSpeed = 0.01
	end	
	
	local smoothing = (speed / 100)
	smoothing =  math.Clamp( smoothing, 0, 1 )			
	
	addAng = addAng * -smoothing * dot * 1.1
	elf.realAddAng.x = math.Approach( elf.realAddAng.x, addAng.x, (addAng.x - elf.realAddAng.x) * moveSpeed)
	elf.realAddAng.y = math.Approach( elf.realAddAng.y, addAng.y, (addAng.y - elf.realAddAng.y) * moveSpeed)
	elf.realAddAng.z = math.Approach( elf.realAddAng.z, addAng.z, (addAng.z - elf.realAddAng.z) * moveSpeed)	
	
	ang = (ang + elf.realAddAng)
	ang:Normalize()
	
	--This is to fixes a but that sometimes happens when the server lags
	dst = 0
	if SCar.ViewDist then
		dst = SCar.ViewDist
	end
	
	elf.newPos = pos + ang * (dst + (speed / 15)) *-1
	angles = ang:Angle()
	
	moveSpeed = 0.02
	elf.posOffsetO.x = math.Approach( elf.posOffsetO.x, 0, -elf.posOffsetO.x * moveSpeed)
	elf.posOffsetO.y = math.Approach( elf.posOffsetO.y, 0, -elf.posOffsetO.y * moveSpeed)
	elf.posOffsetO.z = math.Approach( elf.posOffsetO.z, 0, -elf.posOffsetO.z * moveSpeed)		
	
	local per = 1
	if (elf.startTime + elf.endTime) > CurTime() then
		elf.realAddAng = Vector(0,0,0)
		smoothing = 1
		moveSpeed = 0
		elf.newPos = Vector(0,0,0)
		local newAng = Angle(0,0,0)
		
		
		local percent = ((elf.startTime + elf.endTime) - CurTime()) / elf.endTime
		percent = percent * percent
		per = (1 - percent)
		local addpos = elf.transPos * percent

		
		if elf.transAng.p > 180 then 
			newAng.p = angles.p + elf.transAng.p + ((360 - elf.transAng.p) * (1 - percent)) 
			elf.saveTransAng.p = ((360 - elf.transAng.p) * (1 - percent)) 
		else
			newAng.p = angles.p + elf.transAng.p * percent
			elf.saveTransAng.p = elf.transAng.p * percent
		end
		
		if elf.transAng.y > 180 then
			newAng.y = angles.y + elf.transAng.y + ((360 - elf.transAng.y) * (1 - percent)) 
			elf.saveTransAng.y = elf.transAng.y * percent	
		elseif elf.transAng.y < -180 then
			newAng.y = angles.y + elf.transAng.y - ((360 + elf.transAng.y) * (1 - percent)) 			
		else
			newAng.y = angles.y + elf.transAng.y * percent
			elf.saveTransAng.y = elf.transAng.y * percent				
		end	
		
		newAng = (newAng:Forward() + elf.realAddAng)
		newAng:Normalize()
		
		angles = newAng:Angle()
		elf.newPos = pos + addpos + (newAng * (SCar.ViewDist + (speed / 15)) *-1 * (1 - percent))
		elf.realOffsetPosO = Vector(0,0,0)
		elf.posOffsetO = Vector(0,0,0)
	else
	
		moveSpeed = 0.1
		elf.realOffsetPosO.x = math.Approach( elf.realOffsetPosO.x, elf.posOffsetO.x, (elf.posOffsetO.x - elf.realOffsetPosO.x) * moveSpeed)
		elf.realOffsetPosO.y = math.Approach( elf.realOffsetPosO.y, elf.posOffsetO.y, (elf.posOffsetO.y - elf.realOffsetPosO.y) * moveSpeed)
		elf.realOffsetPosO.z = math.Approach( elf.realOffsetPosO.z, elf.posOffsetO.z, (elf.posOffsetO.z - elf.realOffsetPosO.z) * moveSpeed)			
	end
	
	elf.newPos = elf.newPos + elf.realOffsetPosO * smoothing * per

	local Trace = {}
	Trace.start = pos
	Trace.endpos = elf.newPos
	Trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine(Trace)
	
	if tr.Hit then
		elf.newPos = tr.HitPos + tr.HitNormal * 10
	end
	
	return elf.newPos, angles, fov
end

function Cam:MenuElements(Panel)

end

SCarViewManager:RegisterCam(Cam)