EFFECT.Vel = Vector(0,0,0)
EFFECT.Pos = Vector(0,0,0)
EFFECT.Parent = nil
EFFECT.part = nil
EFFECT.emitter = nil
EFFECT.LiveTime = 0

EFFECT.TimeToDie = CurTime()
EFFECT.TmpPos = 0
EFFECT.TmpPer = 0
EFFECT.DoDie = false

EFFECT.UpdateDel = CurTime()
EFFECT.EmitterUpdateDel = 0.1

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.Parent = data:GetEntity()
	self.TimeToDie = CurTime()
	self.LiveTime = data:GetScale()
end

function EFFECT:Think()
	if self.DoDie or !IsValid(self.Parent) then return false end
	
	if self.UpdateDel < CurTime() then
		self.UpdateDel = CurTime() + self.EmitterUpdateDel
		self.TmpPer = (CurTime() - self.TimeToDie) / self.LiveTime
		self.TmpPos = self.Parent:GetPos() + self.Parent:GetForward() * self.Pos.x + self.Parent:GetRight() * self.Pos.y + self.Parent:GetUp() * self.Pos.z
		self:DoParticles()
		self:DoLight()
	end

	return true

end

function EFFECT:DoLight()
	local dlight = DynamicLight( self.Parent:EntIndex() )		
	
	dlight.Pos = self.TmpPos
	dlight.r = 150 * self.TmpPer
	dlight.g = 150 * self.TmpPer
	dlight.b = 255
	dlight.Brightness = 3
	dlight.Decay = 1024 * 5
	dlight.Size = 512
	dlight.DieTime = CurTime() + 2
		
end

function EFFECT:DoParticles()
	
	
	if self.TmpPer > 1 then
		self.DoDie = true
	end	
	
	self.Vel = self.Parent:GetVelocity()
	
	
	self.emitter = ParticleEmitter( self.TmpPos )
	
	for i = 0, (100*self.TmpPer) do
		
		self.part = self.emitter:Add( "sprites/gmdm_pickups/light", self.TmpPos )
		if (self.part) then
			
			local randVel = VectorRand() - self:GetForward()
			
			self.part:SetVelocity( self.Vel +  randVel * math.Rand(0,2000))
			
			self.part:SetLifeTime( 0 )
			self.part:SetDieTime( math.Rand(0.1*self.TmpPer,1*self.TmpPer) )
			
			self.part:SetStartAlpha( 250 )
			self.part:SetEndAlpha( 250 )
			
			self.part:SetStartSize( math.Rand(10*self.TmpPer,60*self.TmpPer) )
			self.part:SetEndSize( 0 )
			
			self.part:SetColor(100+100*self.TmpPer,100+100*self.TmpPer,255,255)
	

			self.part:SetLighting( true )
			self.part:SetCollide( true )
			self.part:SetBounce( 0.5 )
		end
	end
	
	self.emitter:Finish()
end

function EFFECT:Render()
end