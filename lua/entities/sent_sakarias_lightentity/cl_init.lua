include('shared.lua')

ENT.SCar = nil
ENT.BrakeState = 0
function ENT:Think()

	if	SCarClientData["scar_usepointlights"] == true then

		self.SCar = self:GetNWEntity( "ParentEnt", NULL )

		if self.SCar != NULL then
			self.BrakeState = self.SCar:GetNWInt( "BrakeState", 0 )
			if self.BrakeState != 0 then
			
				local light = DynamicLight( self:EntIndex() )
				if self.BrakeState == 1 then
					light.Pos = self:GetPos()
					light.r = 150
					light.g = 0
					light.b = 0
					light.Brightness = 1
					light.Size = 150
					light.Decay = 500
					light.DieTime = CurTime() + 0.2
				elseif self.BrakeState == 2 then
					light.Pos = self:GetPos()
					light.r = 150
					light.g = 150
					light.b = 150
					light.Brightness = 1
					light.Size = 150
					light.Decay = 500
					light.DieTime = CurTime() + 0.2	
				end
			end
		end
	end
end