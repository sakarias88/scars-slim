include("shared.lua")
SWEP.righModel = ClientsideModel("models/props_c17/tools_wrench01a.mdl", RENDERGROUP_OPAQUE)
SWEP.righModel:SetNoDraw( true )
SWEP.righModel:SetModelScale(0.2, 0)


SWEP.LastPos = Vector(0,0,0)
SWEP.Posdiff = Vector(0,0,0)

SWEP.LastPosSkull = Vector(0,0,0)
SWEP.PosdiffSkull = Vector(0,0,0)

function SWEP:ViewModelDrawn( ) 

	local vm = self.Owner:GetViewModel()
	local bm = vm:GetBoneMatrix(0)
	local pos =  bm:GetTranslation()
	local ang =  bm:GetAngles()	
		
	
	--Drawing original model
	local normal = Vector(1,0,0)
	local origin = Vector(0,0,0)
	local distance = normal:Dot( origin )
	
	local oldEnableClipping = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, distance )
	self:DrawModel()
	render.PopCustomClipPlane()
	render.EnableClipping( oldEnableClipping )
	
	if self.skullModel and self.Owner and self.Owner != NULL then
	
		

		bm = vm:GetBoneMatrix(vm:LookupBone("Bip01_L_Finger3"))
		pos =  bm:GetTranslation()
		ang =  bm:GetAngles()	
		
		
		self.Posdiff = self.Posdiff + (self.LastPos - pos)
		self.Posdiff = self.Posdiff + Vector(0,0,-2)
		self.LastPos = pos

		self.Posdiff.x = math.Approach( self.Posdiff.x, 0, -self.Posdiff.x * FrameTime() * 10)
		self.Posdiff.y = math.Approach( self.Posdiff.y, 0, -self.Posdiff.y * FrameTime() * 10)
		self.Posdiff.z = math.Approach( self.Posdiff.z, 0, -self.Posdiff.z * FrameTime() * 10)	
		
		
		local movAng = self.Posdiff
		movAng = movAng:Angle()
		
		pos = pos + vm:GetUp() * 1 + vm:GetRight() * 4 + vm:GetForward() * 0.5
		ang = movAng
		ang:RotateAroundAxis(ang:Up(), -90)
		ang.p = 0
		pos = pos + movAng:Right() * -1.5
		
		
		--Skull
		local scullPos = Vector(0,0,0)
		local scullAng = Angle(0,0,0)
		
		scullPos = pos + movAng:Right() * -1.8
		
		self.PosdiffSkull = self.PosdiffSkull + (self.LastPosSkull - scullPos) * 50
		self.PosdiffSkull = self.PosdiffSkull + Vector(0,0,-2)
		self.LastPosSkull = scullPos
		
		self.PosdiffSkull.x = math.Approach( self.PosdiffSkull.x, 0, -self.PosdiffSkull.x * FrameTime() * 2)
		self.PosdiffSkull.y = math.Approach( self.PosdiffSkull.y, 0, -self.PosdiffSkull.y * FrameTime() * 2)
		self.PosdiffSkull.z = math.Approach( self.PosdiffSkull.z, 0, -self.PosdiffSkull.z * FrameTime() * 2)		
		
		movAng = self.PosdiffSkull
		movAng = movAng:Angle()	
		scullAng = movAng
		
	
		self.righModel:SetPos(pos)
		self.righModel:SetAngles(ang)
		self.righModel:DrawModel()

		self.skullModel:SetPos(scullPos)
		self.skullModel:SetAngles(scullAng)
		self.skullModel:DrawModel()
	
	end
end