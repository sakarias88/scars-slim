AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--ents
ENT.ConnectedCar = nil
ENT.AI = nil
ENT.target = nil

--Steering
ENT.LeftOrRight = 0
ENT.FrontOrRear = 0
ENT.SteeringAccuracy = 30 -- 1 = most accurate

--collision detection
ENT.lastSpeed = 0
ENT.LowSpeedCounter = 0

--Whiskers
ENT.LeftWhiskerPos = Vector(0,0,0)
ENT.RightWhiskerPos = Vector(0,0,0)
ENT.FrontWhiskerPos = Vector(0,0,0)
ENT.RearWhiskerPos = Vector(0,0,0)
ENT.WhiskerLength = 200
ENT.UsingWhiskers = false

--Misc
ENT.GoToPosPosition = NULL
ENT.distanceComplete = 0

ENT.GoToPos = false
ENT.MoveAwayPos = false
ENT.GoToTarget = false
ENT.MoveAwayTarget = false

ENT.CurrentFace = "SCarMisc/AIfaces/neutral"
ENT.OldFace = "SCarMisc/AIfaces/neutral"
ENT.FaceTime = CurTime()
ENT.UseTempFace = false
ENT.CurFaceName = "neutral"
ENT.OldFaceName = "neutral"
ENT.ShouldLookAtTarget = true
ENT.SCarGroup = true

function ENT:SpawnFunction( ply, tr )
 
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( self.Classname )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	return ent 
	
end

function ENT:Initialize()
	
	self:SetModel( "models/props_lab/monitor02.mdl" )
	self:SetMaterial( self.CurrentFace )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
	self.IsAi = true
end

-------------------------------------------PHYSICS
function ENT:PhysicsUpdate( physics )	
	self:LookAtTarget()
	
	if self.AI then
		self.AI:FastThink()
	end
	
	--self:UpdateGoToPosition()
	--self:UpdateMoveToTarget()
	--self:UpdateFace()
end

-------------------------------------------THINK
function ENT:Think()
	self:GetPhysicsObject():Wake()
	
	self:UpdateCheckIfStuck()
	self:UpdateWhiskers()

	if self.AI then
		self.AI:Think()
	end	
	
	self:UpdateGoToPosition()
	self:UpdateMoveToTarget()
	self:UpdateFace()	
end
-------------------------------------------ON REMOVE
function ENT:OnRemove()

	if IsValid( self.ConnectedCar ) then
		self.ConnectedCar.AIController = nil
	end
end

function ENT:IsPlayer()
	return false
end

function ENT:RemoveCarConnection()
	self:SetParent( NULL )
	self.ConnectedCar.AIController = nil
	self.ConnectedCar = nil
end

function ENT:OnTakeDamage( dmg )
	if self.AI != nil && self.AI != NULL && self.AI then
		self.AI:OnTakeDamage( dmg )
	end
end
	
function ENT:CarCollide( data, phys )

	if self.AI != nil && self.AI != NULL && self.AI then
		self.AI:CarCollide( data, phys )
	end
	
end

function ENT:PlayerEnteredSCar( activator )

	if self.AI != nil && self.AI != NULL && self.AI then

		self.AI:PlayerEnteredSCar( activator )
	end

end

function ENT:ConnectToCar( scar )

	if IsValid( scar ) && IsValid( scar.Seats[1] ) && scar.AIController == nil then

		if IsValid( self.ConnectedCar ) then
			self:RemoveCarConnection()
		end
		
		scar.AIController = self
		self.ConnectedCar = scar
		
		self:SetPos( self.ConnectedCar.Seats[1]:GetPos() + Vector(0,0,15) )
		self:SetParent( self.ConnectedCar )
		self:SetLocalAngles( Angle(0,0,0) )

		
		local maxs = self.ConnectedCar:OBBMaxs()
		local mins = self.ConnectedCar:OBBMins()
		

		local pos = self:GetPos()
		pos.x = 500

		self.RightWhiskerPos.x = maxs.x
		self.RightWhiskerPos.y = maxs.y
		self.RightWhiskerPos.z = maxs.z		

		self.LeftWhiskerPos.x = maxs.x
		self.LeftWhiskerPos.y = maxs.y
		self.LeftWhiskerPos.z = maxs.z			

		self.FrontWhiskerPos.x = maxs.x
		self.FrontWhiskerPos.y = maxs.y
		self.FrontWhiskerPos.z = maxs.z	
		
		self.RearWhiskerPos.x = maxs.x
		self.RearWhiskerPos.y = maxs.y
		self.RearWhiskerPos.z = maxs.z			
		
	
		
		self.RightWhiskerPos.z = 0
		
		self.LeftWhiskerPos.z = 0
		self.LeftWhiskerPos.y = self.LeftWhiskerPos.y * -1
		
		self.FrontWhiskerPos.y = 0
		self.FrontWhiskerPos.z = 0

		self.RearWhiskerPos.x = mins.x
		self.RearWhiskerPos.y = 0
		self.RearWhiskerPos.z = 0		
	end
end

function ENT:AutoLookAtTarget( lookAt )
	self.ShouldLookAtTarget = lookAt
end

function ENT:LookAtTarget()

	if self.ShouldLookAtTarget == true and IsValid( self.target ) && IsValid( self.ConnectedCar ) then

		--Make the AI look at the target
		local lookAng =  self.target:GetPos() - self:GetPos()
		local carAng = self.ConnectedCar:GetAngles()
		lookAng = lookAng:Angle()
		lookAng.p = carAng.p
		lookAng.r = carAng.r
		
		self:SetAngles( lookAng )

	end
	
end

function ENT:LookAtPosition( pos )
	if IsValid( self.ConnectedCar ) then

		--Make the AI look at the target
		local lookAng =  pos - self:GetPos()

		self:SetAngles( lookAng:GetNormalized():Angle() )
	end
end

function ENT:UpdateWhiskers()

	if self.UsingWhiskers and IsValid( self.ConnectedCar ) then
		local frontOffset = self.WhiskerLength
		local rightOffset = self.WhiskerLength
		local frontOffset2 = self.WhiskerLength
		
		--Right Whisker
		local pos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * self.RightWhiskerPos.x  + self.ConnectedCar:GetRight() * self.RightWhiskerPos.y + self.ConnectedCar:GetUp() * self.RightWhiskerPos.z
		local endPos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * (self.RightWhiskerPos.x + frontOffset)  + self.ConnectedCar:GetRight() * (self.RightWhiskerPos.y + rightOffset) + self.ConnectedCar:GetUp() * self.RightWhiskerPos.z		
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = endPos
		tracedata.filter = { self, self.ConnectedCar , self.ConnectedCar.Seats, self.ConnectedCar.Wheels, self.ConnectedCar.StabilizerProp}
		local trace = util.TraceLine(tracedata)
		
		if trace.Hit then
			self.AI:RightWhiskerHit()
			self.LeftOrRight = -1
		end		

		--Left Whisker
		local pos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * self.LeftWhiskerPos.x  + self.ConnectedCar:GetRight() * self.LeftWhiskerPos.y + self.ConnectedCar:GetUp() * self.LeftWhiskerPos.z
		local endPos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * (self.LeftWhiskerPos.x + frontOffset)  + self.ConnectedCar:GetRight() * (self.LeftWhiskerPos.y + (rightOffset * -1)) + self.ConnectedCar:GetUp() * self.LeftWhiskerPos.z		
		
		tracedata.start = pos
		tracedata.endpos = endPos
		tracedata.filter = { self, self.ConnectedCar , self.ConnectedCar.Seats, self.ConnectedCar.Wheels, self.ConnectedCar.StabilizerProp}
		local trace = util.TraceLine(tracedata)
		
		if trace.Hit then
			self.AI:LeftWhiskerHit()
			self.LeftOrRight = 1		
		end

		
		--Front Whisker
		local pos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * self.FrontWhiskerPos.x  + self.ConnectedCar:GetRight() * self.FrontWhiskerPos.y + self.ConnectedCar:GetUp() * self.FrontWhiskerPos.z
		local endPos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * (self.FrontWhiskerPos.x + frontOffset2)  + self.ConnectedCar:GetRight() * self.FrontWhiskerPos.y + self.ConnectedCar:GetUp() * self.FrontWhiskerPos.z		
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = endPos
		tracedata.filter = { self, self.ConnectedCar , self.ConnectedCar.Seats, self.ConnectedCar.Wheels, self.ConnectedCar.StabilizerProp}
		local trace = util.TraceLine(tracedata)
		
		if trace.Hit then
			self.AI:FrontWhiskerHit()
			self.FrontOrRear = 1		
		end				

		--Rear Whisker
		local pos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * self.RearWhiskerPos.x  + self.ConnectedCar:GetRight() * self.RearWhiskerPos.y + self.ConnectedCar:GetUp() * self.RearWhiskerPos.z
		local endPos = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * (self.RearWhiskerPos.x + frontOffset2 * -1)  + self.ConnectedCar:GetRight() * self.RearWhiskerPos.y + self.ConnectedCar:GetUp() * self.RearWhiskerPos.z		
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = endPos
		tracedata.filter = { self, self.ConnectedCar , self.ConnectedCar.Seats, self.ConnectedCar.Wheels, self.ConnectedCar.StabilizerProp}
		local trace = util.TraceLine(tracedata)
		
		if trace.Hit then
			self.AI:RearWhiskerHit()
			self.FrontOrRear = -1		
		end	
	else
		self.LeftOrRight = 0
		self.FrontOrRear = 0
	end
end

function ENT:UpdateTargetSide()

	if IsValid( self.ConnectedCar ) then
		
		local pos = Vector(0,0,0)
	
		
		if IsValid( self.target ) && self.GoToPos == false && self.MoveAwayPos == false then
			pos = self.target:GetPos()
		elseif self.GoToPos == true or self.MoveAwayPos == true then
			pos = self.GoToPosPosition
		else
			self.LeftOrRight = 0
			self.FrontOrRear = 0
			return false
		end
	
	
		local leftDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetRight() * -100
		leftDist = leftDist:Distance( pos ) 

		local rightDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetRight() * 100
		rightDist = rightDist:Distance( pos ) 		
		
		local diff = (leftDist - rightDist)


		local forwardDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * 100
		forwardDist = forwardDist:Distance( pos ) 

		local rearDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * -100
		rearDist = rearDist:Distance( pos ) 			
			
			

				
		
		if diff > (self.SteeringAccuracy) or diff < (self.SteeringAccuracy * -1) then
			if leftDist >  rightDist then
				self.LeftOrRight = 1
			else
				self.LeftOrRight = -1
			end	
		else
			self.LeftOrRight = 0
		end		

		if (forwardDist - 20) < rearDist then
			self.FrontOrRear = 1
		else
			self.FrontOrRear = -1
		end

	end
end

function ENT:UpdateCheckIfStuck()

	if IsValid( self.ConnectedCar ) && IsValid( self.target ) && self.ConnectedCar.IsOn == true && self.ConnectedCar.Fuel > 0 then
	
		local curVel = self.ConnectedCar:GetPhysicsObject():GetVelocity():Length()
		local diff = curVel - self.lastSpeed
		self.lastSpeed = curVel
		
		if curVel < 100 then
			self.LowSpeedCounter = self.LowSpeedCounter + 1
		else
			self.LowSpeedCounter = 0
		end
			
	end
end

-----AI HELP FUNCS
function ENT:UseWhiskers( use )
	self.UsingWhiskers = use
end

function ENT:SetWhiskerLength( length )
	self.WhiskerLength = length
end

function ENT:SetTarget( newTarget )
	self.target = newTarget
end

function ENT:SetAI( newAI )
	self.AI = newAI
	self.AI:Init()
end


function ENT:IsStuck()  -- Returns true when the  AI thiks it's stuck.
	if self.LowSpeedCounter > 5 then return true end
	
	return false
end

function ENT:HasTarget() --Returns true if the AI has a target
	return IsValid( self.target )
end

function ENT:IsConnectedToSCar() --Returns true if the ai is connected to a scar
	return IsValid( self.ConnectedCar )
end

function ENT:GetTarget() --Returns the target
	return self.target
end

function ENT:GetSCar() --Returns the SCar
	return self.ConnectedCar
end

function ENT:TargetIsNode() --Returns true if the target is a node

	if self:HasTarget() && self.target:GetClass() == "sent_scarainode" then
		return true
	end
	
	return false
end

function ENT:GetTargetSide() -- Returns two integers. The first one is which side of the car the target is located and the second integer says if it's in front or behind the SCar
	self:UpdateTargetSide()
	return self.LeftOrRight, self.FrontOrRear
end


function ENT:GetPositionSide( pos )
	if IsValid( self.ConnectedCar ) then
	
		local lr = 0
		local fb = 0
	
		local leftDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetRight() * -100
		leftDist = leftDist:Distance( pos ) 

		local rightDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetRight() * 100
		rightDist = rightDist:Distance( pos ) 		
		
		local diff = (leftDist - rightDist)


		local forwardDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * 100
		forwardDist = forwardDist:Distance( pos ) 

		local rearDist = self.ConnectedCar:GetPos() + self.ConnectedCar:GetForward() * -100
		rearDist = rearDist:Distance( pos ) 			
			
			

				
		
		if diff > (self.SteeringAccuracy) or diff < (self.SteeringAccuracy * -1) then
			if leftDist >  rightDist then
				lr = 1
			else
				lr = -1
			end	
		end		

		if (forwardDist - 20) < rearDist then
			fb = 1
		else
			fb = -1
		end

		
		return lr, fb
	end
	
	return 0,0
end


function ENT:UseTurning( turnPercent ) -- Will turn left if the target is at the SCars left side and right if the target is at the SCars right side
	if self.LeftOrRight == 1 then
		self.ConnectedCar:TurnRight( turnPercent )
	elseif self.LeftOrRight == -1 then
		self.ConnectedCar:TurnLeft( turnPercent )
	else
		self.ConnectedCar:NotTurning()
	end
end


function ENT:UseInvertedTurning( turnPercent ) -- Will turn right if the target is at the SCars left side and turn left if the target is at the SCars right side

	if self.LeftOrRight == 1 then
		self.ConnectedCar:TurnLeft( turnPercent )
	elseif self.LeftOrRight == -1 then
		self.ConnectedCar:TurnRight( turnPercent )
	else
		self.ConnectedCar:NotTurning()
	end
end

function ENT:GoToPosition( move , pos, distanceComplete )

	if move == true && pos != nil && pos != NULL && distanceComplete != nil && distanceComplete != NULL then

		self.GoToPos = move
		self.GoToPosPosition = pos
		self.distanceComplete = distanceComplete
		
		self.GoToTarget = false
		self.MoveAwayTarget = false
		self.MoveAwayPos = false
	else
		self.GoToPos = false
	end
end

function ENT:MoveAwayFromPos( move, pos, distanceComplete ) 

	if move == true && pos != nil && pos != NULL && distanceComplete != nil && distanceComplete != NULL then

		self.MoveAwayPos = move
		self.GoToPosPosition = pos
		self.distanceComplete = distanceComplete
		
		
		self.GoToTarget = false
		self.GoToPos = false
		self.MoveAwayTarget = false
	else
		self.MoveAwayPos = false
	end

end


function ENT:UpdateGoToPosition()

	if (self.GoToPos == true or self.MoveAwayPos == true) && IsValid( self.ConnectedCar ) then
		

		self:UpdateTargetSide()
		local dist = self.ConnectedCar:GetPos():Distance( self.GoToPosPosition ) 
		
		if self.GoToPos == true then
		
			if dist <= self.distanceComplete then 
				self.GoToPos = false
			else

				local maxSpeed = 1000
			
				if self.FrontOrRear == 1 then
				

					if self.ConnectedCar:GetPhysicsObject():GetVelocity():Length() < maxSpeed then
						self.ConnectedCar:GoForward()
					elseif self.ConnectedCar.DriveActionStatus != -1 then 
						self.ConnectedCar:GoBack()
					end
					
					self:UseTurning()

				else
					self.ConnectedCar:GoBack()
					self:UseInvertedTurning()		
				end		
				
			end
		
		elseif self.MoveAwayPos == true then

			if dist < self.distanceComplete then
			
				self.ConnectedCar:HandBrakeOff()
				
				if self.FrontOrRear == 1 then			
					self.ConnectedCar:GoBack()
					self:UseTurning()
				else
					self.ConnectedCar:GoForward()	
					self:UseInvertedTurning()
				end
			else
				self.ConnectedCar:HandBrakeOn()
				self.ConnectedCar:GoNeutral()
				self.ConnectedCar:NotTurning()	
				self.LowSpeedCounter = 0
			end
		
		end
		
	end
end

function ENT:MoveToTarget( move, distanceComplete )

	if self.target != NULL && self.target != nil && IsValid( self.target ) then
		self.GoToTarget = move
		
		if self.GoToTarget == true then
			self.distanceComplete = distanceComplete


			self.GoToPos = false
			self.MoveAwayTarget = false
			self.MoveAwayPos = false
		end
	else
		self.GoToTarget = false
	end
end

function ENT:UpdateMoveToTarget()
	
	if (self.GoToTarget == true or self.MoveAwayTarget == true) && self.target != NULL && self.target != nil && IsValid( self.target ) && IsValid( self.ConnectedCar ) then

		self:UpdateTargetSide()
		local dist = self.ConnectedCar:GetPos():Distance( self.target:GetPos() ) 
		
		if self.GoToTarget == true then
			
			if dist <= self.distanceComplete then 
				self.GoToTarget = false
			else		
			
				if self.FrontOrRear == 1 then
					self.ConnectedCar:GoForward()
					self:UseTurning()
				else
					self.ConnectedCar:GoBack()
					self:UseInvertedTurning()		
				end	
			end
			
		elseif self.MoveAwayTarget == true then


			if dist < self.distanceComplete then
			
				self.ConnectedCar:HandBrakeOff()
				
				if self.FrontOrRear == 1 then			
					self.ConnectedCar:GoBack()
					self:UseTurning()
				else
					self.ConnectedCar:GoForward()	
					self:UseInvertedTurning()
				end
			else
				self.ConnectedCar:HandBrakeOn()
				self.ConnectedCar:GoNeutral()
				self.ConnectedCar:NotTurning()	
				self.LowSpeedCounter = 0
			end
		
		end
	else
		self.GoToTarget = false
		self.MoveAwayTarget = false
	end
end

function ENT:MoveAwayFromTarget( move, distanceComplete )

	if self.target != NULL && self.target != nil && IsValid( self.target ) then
		self.MoveAwayTarget = move

		if self.MoveAwayTarget == true then
			self.distanceComplete = distanceComplete
			
			self.GoToTarget = false
			self.GoToPos = false
			self.MoveAwayPos = false		
		end
	else
		self.MoveAwayTarget = false
	end
end


function ENT:HasCompletedMoveToTarget()

	if self.GoToTarget == false then
		return true
	end
	
	return false
end

function ENT:HasCompletedGoToPosition()
	if self.GoToPos == false then
		return true
	end
	
	return false
end

function ENT:SetFace( face )

	face = string.lower( face )

	if self.UseTempFace == false && self.CurFaceName != face then

		self.OldFaceName = self.CurFaceName
		self.CurFaceName = face
		
		self.FaceTime = CurTime()

		if face == "neutral" then
			self.CurrentFace = "SCarMisc/AIfaces/neutral"
			
		elseif face == "angry" then
			self.CurrentFace = "SCarMisc/AIfaces/angry"
			
		elseif face == "annoyed" then
			self.CurrentFace = "SCarMisc/AIfaces/annoyed"	
			
		elseif face == "happy" then
			self.CurrentFace = "SCarMisc/AIfaces/happy"	
			
		elseif face == "sad" then
			self.CurrentFace = "SCarMisc/AIfaces/sad"	
			
		elseif face == "sorry" then
			self.CurrentFace = "SCarMisc/AIfaces/sorry"	
			
		elseif face == "veryangry" then
			self.CurrentFace = "SCarMisc/AIfaces/veryangry"	
			
		elseif face == "veryhappy" then
			self.CurrentFace = "SCarMisc/AIfaces/veryhappy"	
			
		elseif face == "verysad" then
			self.CurrentFace = "SCarMisc/AIfaces/verysad"	
			
		elseif face == "dead" then
			self.CurrentFace = "SCarMisc/AIfaces/dead"					
		end
		
		self:SetMaterial( self.CurrentFace )
	
	elseif self.UseTempFace == true && face != self.OldFaceName then
		
		self.OldFaceName = face 

	end



end

function ENT:SetFaceTime( face, timeToUseFace )

	face = string.lower( face )

	if  self.CurFaceName != face then
	
		if self.UseTempFace == false then
			self.OldFaceName = self.CurFaceName
		end

		self.CurFaceName = face
		self.UseTempFace = true
		self.FaceTime = CurTime() + timeToUseFace

		if face == "neutral" then
			self.CurrentFace = "SCarMisc/AIfaces/neutral"
			
		elseif face == "angry" then
			self.CurrentFace = "SCarMisc/AIfaces/angry"
			
		elseif face == "annoyed" then
			self.CurrentFace = "SCarMisc/AIfaces/annoyed"	
			
		elseif face == "happy" then
			self.CurrentFace = "SCarMisc/AIfaces/happy"	
			
		elseif face == "sad" then
			self.CurrentFace = "SCarMisc/AIfaces/sad"	
			
		elseif face == "sorry" then
			self.CurrentFace = "SCarMisc/AIfaces/sorry"	
			
		elseif face == "veryangry" then
			self.CurrentFace = "SCarMisc/AIfaces/veryangry"	
			
		elseif face == "veryhappy" then
			self.CurrentFace = "SCarMisc/AIfaces/veryhappy"	
			
		elseif face == "verysad" then
			self.CurrentFace = "SCarMisc/AIfaces/verysad"	
			
		elseif face == "dead" then
			self.CurrentFace = "SCarMisc/AIfaces/dead"				
		end
		
		self:SetMaterial( self.CurrentFace )
	end
end

function ENT:UpdateFace()

	if self.UseTempFace == true && self.FaceTime < CurTime() then
		self.UseTempFace = false
		self:SetFace( self.OldFaceName )
	end
end
