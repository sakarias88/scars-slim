local AI = {}
AI.Title = "#tool.caraispawner.stay_away"
AI.Author = "Sakarias88"

AI.CollisionTimer = CurTime()
AI.ColReverseTimer = CurTime()
AI.whiskerHit = false

AI.KeepTargetDistance = 4000

function AI:Init()
	self.Owner:SetTarget( self.Owner.SpawnedBy )
	
	if self.Owner:IsConnectedToSCar() then
		self.Owner:MoveAwayFromTarget( true, 4000 )
	end	
end

SCarAiHandler:registerAI( AI )