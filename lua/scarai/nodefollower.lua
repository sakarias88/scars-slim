local AI = {}
AI.Title = "#tool.caraispawner.node_follow"
AI.Author = "Sakarias88"

function AI:Think() --Runs 5 times per sec

	if self.Owner:HasTarget() && self.Owner:IsConnectedToSCar() then

		local node = self.Owner:GetTarget()
		local SCar = self.Owner:GetSCar()
		
		local SCarVel = SCar:GetPhysicsObject():GetVelocity():Length()
		local maxSpeed = 2000
		local nodeMaxSpeed = node.TurnPercent * maxSpeed
		local distToNode = SCar:GetPos():Distance( node:GetPos() )
	
		local ArriveTime = distToNode / SCarVel
		local BrakeTime = SCarVel / (SCar.BreakForce / 4)
	
		if ArriveTime > BrakeTime then
			SCar:HandBrakeOff()
			self.Owner:MoveToTarget( true, 200 )
		else
			self.Owner:MoveToTarget( false, 200 )
			
			if SCar.DriveActionStatus != -1 then
				SCar:GoBack()
				SCar:NotTurning()
			end
		end
	
		if distToNode < 200 then
			self.Owner:SetTarget( node:GetNextNode() )
		end
	
	elseif self.Owner:IsConnectedToSCar() then--Search for target
	
		local SCar = self.Owner:GetSCar()
		local nodeToSelect = NULL
		local minDist = 99999999
	
		for k, v in pairs(ents.FindInSphere( SCar:GetPos(), 200 )) do
			if v:GetClass() == "sent_scarainode" then
				local dist = SCar:GetPos():Distance( v:GetPos() )
				
				if dist < minDist then
					minDist = dist
					nodeToSelect = v
				end
			end
		end
		
		
		if nodeToSelect != NULL then
			self.Owner:SetTarget( nodeToSelect )
		end
	end
end

SCarAiHandler:registerAI( AI )