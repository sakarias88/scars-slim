local AI = {}
AI.Title = "Follow Player Car Keys"
AI.Author = "Sakarias88"
AI.IsState = true 

AI.CollisionTimer = CurTime()
AI.ColReverseTimer = CurTime()
AI.whiskerHit = false
AI.KeepTargetDistance = 400
AI.Fails = 0

function AI:Init()
	if self.Owner:IsConnectedToSCar() then
		local SCar = self.Owner:GetSCar()
		SCar:DoUnlockEffect()
	end
end

function AI:Think()

	if self.Owner:IsConnectedToSCar() then

		local SCar = self.Owner:GetSCar()
		if self.CollisionTimer < CurTime() then
		
		
			if IsValid(self.Owner.SpawnedBy) then
				self.Owner:SetTarget( self.Owner.SpawnedBy )
			end
		
			
		
			if self.Owner:HasTarget() then
			
				local target = self.Owner:GetTarget()
				local dist = SCar:GetPos():Distance( target:GetPos() )
				
				local leftOrRight, frontOrRear = self.Owner:GetTargetSide()
		
				if dist > self.KeepTargetDistance then
					SCar:HandBrakeOff()
					
					local vel = SCar:GetPhysicsObject():GetVelocity():Length()
					
					if vel < 300 then
						if frontOrRear == 1 then			
							SCar:GoForward()
						else
							SCar:GoBack()			
						end						
					elseif vel > 300 and vel < 400 then
						SCar:GoNeutral()
					else
						if frontOrRear == 1 then			
							SCar:GoBack()
						else
							SCar:GoForward()			
						end							
					end
					
			
					
					self.Owner:UseTurning()	
				else
					self:KillOperation( SCar, true )
					return
				end	
			else
				SCar:GoNeutral()
				SCar:NotTurning()
			end		
		
		
		else
			local SCar = self.Owner:GetSCar()
		
			if self.ColReverseTimer > CurTime() then
				SCar:GoBack()
				
				self.Owner:UseInvertedTurning()
			elseif self.CollisionTimer > CurTime() then
				SCar:GoForward()
				
				if self.whiskerHit then
					self.Owner:UseTurning()
					self.whiskerHit = false
				end
			end	
		end	
	
	
		if self.CollisionTimer < CurTime()&& self.Owner:HasTarget() && self.Owner:IsStuck() then
			self.CollisionTimer = CurTime() + 2
			self.ColReverseTimer = CurTime() + 0.7
			self.Fails = self.Fails + 1
			
			if self.Fails > 3 then
				self:KillOperation( SCar, false )
				return			
			end
			
		end
	end
end

function AI:KillOperation( SCar, unlock )
	SCar:GoNeutral()
	SCar:NotTurning()
	SCar:HandBrakeOn()
	self.Owner:SetFace( "neutral" )
	self.Owner:Remove()
	
	if unlock then
		SCar:UnLock( false )
	end
	
	timer.Create( "SCarSomeAiTimer"..SCar:EntIndex(), 1, 1, function()
		if SCar != nil and SCar !=  NULL and IsValid(SCar) then
			SCar:DoLockEffect()
		end
	end )
end

function AI:PlayerEnteredSCar( player )
	self:KillOperation( SCar, false )
end

--Whiskers
function AI:LeftWhiskerHit()
	self.whiskerHit = true
end

function AI:RightWhiskerHit()
	self.whiskerHit = true
end

SCarAiHandler:registerAI( AI )