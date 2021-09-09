local AI = {}
AI.Title = "#tool.caraispawner.derby"
AI.Author = "Sakarias88"

AI.CollisionTimer = CurTime()
AI.ColReverseTimer = CurTime()
AI.whiskerHit = false

AI.MoveAwayTime = CurTime()
AI.SwitchTargetTime = CurTime()
AI.WasMovingAway = false

function AI:Init()
	 self.Owner:SetTarget(nil)
end

function AI:Think()

	if self.Owner:IsConnectedToSCar() then

		local SCar = self.Owner:GetSCar()
		if self.CollisionTimer < CurTime() && self.MoveAwayTime < CurTime() then

			self.Owner:MoveAwayFromTarget( false, 1000 )
			local targ = self.Owner:GetTarget()
			
			--Search for target
			if (self.SwitchTargetTime < CurTime()) or self.WasMovingAway == true or (self.Owner:HasTarget() && !targ:HasDriver()) then
				self:GetNewTarget()
				self.SwitchTargetTime = CurTime() + math.Rand(5,20)
			end
			
			if self.Owner:HasTarget() then
				SCar:HandBrakeOff()
				self.Owner:MoveToTarget( true, 0 )
			else
				SCar:GoNeutral()
				SCar:NotTurning()
				self.SwitchTargetTime = 0
			end		
		else
			self.Owner:MoveAwayFromTarget( false, 1000 )
			self.Owner:MoveToTarget( false, 0 )
			
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

			if self.MoveAwayTime > CurTime() && self.CollisionTimer < CurTime() then
				self.Owner:MoveAwayFromTarget( true, 1000 )
			end
		end	
	
	
		if self.CollisionTimer < CurTime() && self.Owner:IsStuck() then
			self.CollisionTimer = CurTime() + 2
			self.ColReverseTimer = CurTime() + 0.7	
		end
	end
end

function AI:GetNewTarget()
	local SCar = self.Owner:GetSCar()
	allEnts = ents.FindInSphere( SCar:GetPos(), 1000 )

	for k,v in ipairs( allEnts ) do
		--We have found a new target!
		if v != SCar && v.Base == "sent_sakarias_scar_base" && v:HasDriver() && v.CarHealth > 0 then
			self.Owner:SetTarget( v )
			break
		end
	end
end

function AI:CarCollide( data, phys )
	local ent = data.HitEntity
	local targ = self.Owner:GetTarget()
	
	if self.Owner:GetTarget() != ent && ent.Base == "sent_sakarias_scar_base" && ent:HasDriver() then
		self.Owner:SetTarget( ent )
		self.MoveAwayTime = CurTime() + 2
		self.WasMovingAway = true
		self.SwitchTargetTime = 0
	end
end

function AI:LeftWhiskerHit()
	self.whiskerHit = true
end

function AI:RightWhiskerHit()
	self.whiskerHit = true
end

SCarAiHandler:registerAI( AI )