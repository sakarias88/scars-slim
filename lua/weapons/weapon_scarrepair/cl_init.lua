include("shared.lua")
SWEP.CustomWorldModel = ClientsideModel("models/props_c17/tools_wrench01a.mdl", RENDERGROUP_OPAQUE)
SWEP.CustomWorldModel:SetNoDraw( true )

function SWEP:DrawWorldModel()
	if self.Owner and self.Owner != NULL then
	
		local attach = self.Owner:LookupAttachment("anim_attachment_rh")
		
		local PosAng = {}
		if attach == 0 then
			PosAng.Pos = Vector(0,0,0)
			PosAng.Ang = Angle(0,0,0)
		else
			PosAng = self.Owner:GetAttachment( attach )
		end	
	
		self:SetRenderOrigin( PosAng.Pos  )
		PosAng.Ang:RotateAroundAxis(PosAng.Ang:Forward(), 90)
		self:SetRenderAngles(PosAng.Ang)
	end
	
	self:DrawModel()
end