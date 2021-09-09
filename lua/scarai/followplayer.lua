local AI = {}
AI.Title = "#tool.caraispawner.follow_player"
AI.Author = "Sakarias88"

AI.CollisionTimer = CurTime()
AI.ColReverseTimer = CurTime()
AI.whiskerHit = false
AI.KeepTargetDistance = 400
AI.TargetDeadDistance = 200

function AI:Think() --Runs 5 times per sec

	if self.Owner:IsConnectedToSCar() then

	
		if self.CollisionTimer < CurTime() then
		
		
			if IsValid(self.Owner.SpawnedBy) then
				self.Owner:SetTarget( self.Owner.SpawnedBy )
			end
		
			local SCar = self.Owner:GetSCar()
		
			if self.Owner:HasTarget() then
			
				local target = self.Owner:GetTarget()
				local dist = SCar:GetPos():Distance( target:GetPos() )
				
				local leftOrRight, frontOrRear = self.Owner:GetTargetSide()
		
				if dist > (self.KeepTargetDistance + self.TargetDeadDistance) then
					SCar:HandBrakeOff()
					
					self.Owner:SetFace( "happy" )
					
					if frontOrRear == 1 then			
						SCar:GoForward()
					else
						SCar:GoBack()			
					end
					
					self.Owner:UseTurning()
					
				elseif dist > self.KeepTargetDistance && dist < (self.KeepTargetDistance + self.TargetDeadDistance) then
					self.Owner.LowSpeedCounter = 0
					SCar:GoNeutral()
					SCar:NotTurning()
					SCar:HandBrakeOn()
					self.Owner:SetFace( "neutral" )
				elseif dist < self.KeepTargetDistance then
					SCar:HandBrakeOff()
					
					self.Owner:SetFace( "sad" )
					
					if frontOrRear == 1 then			
						SCar:GoBack()
						self.Owner:UseInvertedTurning() 
					else
						SCar:GoForward()
						self.Owner:UseTurning() 
					end			
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
		end
	end
end

function AI:CarCollide( data, phys )
	self.Owner:SetFaceTime( "sorry", 3 )
end

--Whiskers
function AI:LeftWhiskerHit()
	self.whiskerHit = true
end

function AI:RightWhiskerHit()
	self.whiskerHit = true
end

SCarAiHandler:registerAI( AI )