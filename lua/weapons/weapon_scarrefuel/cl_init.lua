include("shared.lua")
SWEP.CustomWorldModel = ClientsideModel("models/props_junk/gascan001a.mdl", RENDERGROUP_OPAQUE)
SWEP.CustomWorldModel:SetModelScale(0.7, 0)
SWEP.CustomWorldModel:SetNoDraw( true )

SWEP.CustomViewModel = ClientsideModel("models/props_junk/gascan001a.mdl", RENDERGROUP_OPAQUE)
SWEP.CustomViewModel:SetNoDraw( true )
SWEP.AnimProgress = 0
SWEP.AnimProgress2 = 0
SWEP.PosAng = {}
SWEP.PosAng.Pos = Vector(0,0,0)
SWEP.PosAng.Ang = Angle(0,0,0)	
function SWEP:DrawWorldModel()

	if self.Owner and self.Owner != NULL  then
		if self.DoAnim then
			self.AnimProgress2 = self.AnimProgress2 + FrameTime() * 5
		else
			self.AnimProgress2 = self.AnimProgress2 - FrameTime() * 5
		end
		
		self.AnimProgress2 = math.Clamp(self.AnimProgress2,0,1)

		self:SetModelScale(0.7, 0)
		local fuelPer = (1-(self.dt.Fuel * 0.01)) * self.AnimProgress2
		
		local attach = self.Owner:LookupAttachment("anim_attachment_rh")

		if attach != 0 then
			self.PosAng = self.Owner:GetAttachment( attach )
			
			if !self.PosAng.Pos then
				self.PosAng.Pos = Vector(0,0,0)
			end
			
			if !self.PosAng.Ang then
				self.PosAng.Ang = Angle(0,0,0)
			end
		end			

		self:SetRenderOrigin(self.PosAng.Pos + self.PosAng.Ang:Forward() * 7 + self.PosAng.Ang:Up() * - 5)
		self.PosAng.Ang:RotateAroundAxis(self.PosAng.Ang:Up(), 90)

		self.PosAng.Ang:RotateAroundAxis(self.PosAng.Ang:Forward(), 100 * fuelPer)
		self:SetRenderAngles( self.PosAng.Ang )
	end
	self:DrawModel()	
end

function SWEP:ViewModelDrawn( ) 
	self:DrawModel()
	if self.Owner and self.Owner != NULL then
		local vm = self.Owner:GetViewModel()

		local bm = vm:GetBoneMatrix(0)
		local pos =  bm:GetTranslation()
		local ang =  bm:GetAngles()	
		
		pos = pos + ang:Up() * 200 --Forward
		pos = pos + ang:Right() * 4 --Up
		pos = pos + ang:Forward() * -15 --Right
		ang:RotateAroundAxis(ang:Forward(), -100)
		ang:RotateAroundAxis(ang:Up(), 15)
		
		
		if self.DoAnim then
			self.AnimProgress = self.AnimProgress + FrameTime() * 5
		else
			self.AnimProgress = self.AnimProgress - FrameTime() * 5
		end
		
		self.AnimProgress = math.Clamp(self.AnimProgress,0,1)
		
		
		if self.AnimProgress > 0 then
			
			local fuelPer = (1-(self.dt.Fuel * 0.01)) * self.AnimProgress
			pos = pos + ang:Up() * (7 * self.AnimProgress + 4 * fuelPer)
			ang:RotateAroundAxis(ang:Forward(), 70 * self.AnimProgress + 40 * fuelPer)
			ang:RotateAroundAxis(ang:Right(), -10 * self.AnimProgress - 2 * fuelPer)	
		end
		

		

		self.CustomViewModel:SetPos(pos)
		self.CustomViewModel:SetAngles(ang)
		self.CustomViewModel:DrawModel()
	end

end

function SWEP:GetEmitter( Pos, b3D )

	if ( self.Emitter ) then	
		if ( self.EmitterIs3D == b3D && self.EmitterTime > CurTime() ) then
			return self.Emitter
		end
	end
	
	self.Emitter = ParticleEmitter( Pos, b3D )
	self.EmitterIs3D = b3D
	self.EmitterTime = CurTime() + 2
	return self.Emitter

end
