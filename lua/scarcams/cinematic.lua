local Cam = {}
Cam.Name = "Cinematic"

Cam.CamChangeDel = CurTime()
Cam.CurCam = 1
Cam.LastCam = 1
Cam.NrOfCams = 7
Cam.CamFuncs = {}

Cam.LookPos = Vector(0,0,0)

Cam.newAng = Angle(0,0,0)
Cam.newPos = Vector(0,0,0)

function Cam:Init()
end

function Cam:FirstPerson(ply, pos, ang, fov, SCar, veh)	
	return Cam:CinematicFunc(ply, pos, ang, fov, SCar, veh)
end

function Cam:ThirdPerson(ply, pos, ang, fov, SCar, veh)	
	return Cam:CinematicFunc(ply, pos, ang, fov, SCar, veh)
end

Cam.CamFuncs[1] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(1,3)
	end

	self.newPos = ply:EyePos() + SCar:GetForward() * 40
	self.newAng = SCar:GetForward() * -1
	self.newAng = self.newAng:Angle()
	return self.newPos, self.newAng, fov
end


Cam.CamFuncs[2] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(3,5)
		self.LookPos = SCar:GetPos() + Vector( math.random(-500,500) ,math.random(-500,500),math.random(-100,100))
		
		
		local Trace = {}
		Trace.start = SCar:GetPos()
		Trace.endpos = self.LookPos
		Trace.mask = MASK_NPCWORLDSTATIC
		local tr = util.TraceLine(Trace)
		
		if tr.Hit then
			self.LookPos = tr.HitPos + tr.HitNormal * 10
		end				
	end

	self.newAng = SCar:GetPos() - self.LookPos
	self.newAng = self.newAng:Angle()
	
	local Trace = {}
	Trace.start = SCar:GetPos()
	Trace.endpos = self.LookPos
	Trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine(Trace)
	
	if tr.Hit then
		self.CamChangeDel = 0
	end		
	
	
	
	return self.LookPos, self.newAng, fov
end


Cam.CamFuncs[3] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(3,5)
		self.LookPos = SCar:GetPos() + SCar:GetForward() * 500 + Vector( math.random(-50,50) ,math.random(-50,50),math.random(-50,50) )
		
		
		local Trace = {}
		Trace.start = SCar:GetPos()
		Trace.endpos = self.LookPos
		Trace.mask = MASK_NPCWORLDSTATIC
		local tr = util.TraceLine(Trace)
		
		if tr.Hit then
			self.LookPos = tr.HitPos + tr.HitNormal * 10
		end				
	end

	self.newAng = SCar:GetPos() - self.LookPos
	self.newAng = self.newAng:Angle()
	
	local Trace = {}
	Trace.start = SCar:GetPos()
	Trace.endpos = self.LookPos
	Trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine(Trace)
	
	if tr.Hit then
		self.CamChangeDel = 0
	end		
	
	
	
	return self.LookPos, self.newAng, fov
end

Cam.CamFuncs[4] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(2,4)
	end

	self.newPos = SCar:GetPos() + Vector(0,0, 500)
	
	local Trace = {}
	Trace.start = SCar:GetPos()
	Trace.endpos = self.newPos
	Trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine(Trace)
	
	if tr.Hit then
		self.newPos = tr.HitPos + tr.HitNormal * 10
	end		
	
	self.newAng = Angle(90,0,0)
	
	return self.newPos, self.newAng, fov
end

Cam.CamFuncs[5] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(3,5)
	end
	
	self.newPos = SCar:GetPos() + SCar:GetForward() * (SCar.WheelInfo[1].Pos.x - 40) + SCar:GetRight() * (SCar.WheelInfo[1].Pos.y - 30) + SCar:GetUp() * (SCar.WheelInfo[1].Pos.z + 20)
	self.newAng = SCar:GetForward():Angle()
	return self.newPos, self.newAng, fov
end

Cam.CamFuncs[6] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(2,4)
	end

	self.newPos = SCar:GetPos() + SCar:GetForward() * SCar.effectPos.x + SCar:GetRight() * SCar.effectPos.y + SCar:GetUp() * (SCar.effectPos.z + 5)
	self.newAng = SCar:GetForward():Angle()
	return self.newPos, self.newAng, fov
end

Cam.CamFuncs[7] = function(self, ply, pos, ang, fov, SCar, veh, change)	

	if change then
		self.CamChangeDel = CurTime() + math.random(2,4)
	end

	self.newPos = SCar:GetPos() + SCar:GetForward() * SCar.effectPos.x + SCar:GetRight() * SCar.effectPos.y + SCar:GetUp() * (SCar.effectPos.z + 5)
	self.newAng = SCar:GetForward() * -1
	self.newAng = self.newAng:Angle()
	return self.newPos, self.newAng, fov
end


function Cam:CinematicFunc(ply, pos, ang, fov, SCar, veh)	

	if self.CamChangeDel < CurTime() then
		self.CurCam = math.random(1, self.NrOfCams)
		return self.CamFuncs[self.CurCam]( self, ply, pos, ang, fov, SCar, veh, true)
	end

	
	return self.CamFuncs[self.CurCam]( self, ply, pos, ang, fov, SCar, veh, false)	
end

function Cam:MenuElements(Panel)
end

SCarViewManager:RegisterCam(Cam)