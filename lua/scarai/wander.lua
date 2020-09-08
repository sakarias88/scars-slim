local AI = {}
AI.Title = "#tool.caraispawner.wander"
AI.Author = "Sakarias88"

AI.whiskerHit = false
AI.ColReverseTimer = CurTime()
AI.CollisionTimer = CurTime()
AI.ChangeWaypointTimer = CurTime()
AI.WayPointTime = 15

function AI:Init()
	self.Owner:UseWhiskers( true )
end

function AI:FastThink()

	if self.Owner:IsConnectedToSCar() then
	
		local SCar = self.Owner:GetSCar()
	
		if self.ColReverseTimer > CurTime() then
			self.Owner:GoToPosition( false, NULL, 200 )
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
end

function AI:Think()
	if !IsValid( self.Owner ) or !self.Owner:IsConnectedToSCar() then return false end
	
	if (self.Owner:HasCompletedGoToPosition() or self.ChangeWaypointTimer < CurTime()) && self.CollisionTimer < CurTime() then

		local pos = Vector(math.Rand( -2000, 2000 ) , math.Rand( -2000, 2000 ) , 0 ) + self.Owner:GetPos()
	
		if self.Owner:HasTarget() then
			local target = self.Owner:GetTarget()
			pos = target:GetPos()
		end
		
		self.Owner:GoToPosition(true, pos, 200 )
		self.ChangeWaypointTimer = CurTime() + self.WayPointTime
	end

	if self.Owner:IsStuck() then
		self.CollisionTimer = CurTime() + 2
		self.ColReverseTimer = CurTime() + 0.7	
	end
end

function AI:CarCollide( data, phys )

	if self.Owner:IsConnectedToSCar() then
		self.Owner:GoToPosition( false, NULL, 200 )
	end
end

--Whiskers
function AI:LeftWhiskerHit()
	self.whiskerHit = true
end

function AI:RightWhiskerHit()
	self.whiskerHit = true
end

SCarAiHandler:registerAI( AI )