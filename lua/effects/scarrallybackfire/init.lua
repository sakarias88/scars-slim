

EFFECT.matFire            = Material( "effects/fire_cloud1" )
EFFECT.matHeatWave        = Material( "sprites/heatwave" )

EFFECT.Ent = nil
EFFECT.LocPos = Vector(0,0,0)
EFFECT.tmpPos = Vector(0,0,0)
EFFECT.Time = 0.4
EFFECT.scroll = 0
EFFECT.lengthScale = 0
EFFECT.Scale = 1
EFFECT.Dir = Vector(0,0,0)
EFFECT.Length = 0

function EFFECT:Init( data )
	
	self.LifeTime = CurTime() + self.Time
	self.Ent = data:GetEntity()
	self.LocPos = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Length = data:GetMagnitude()

    if !IsValid(self.Ent) then self.Failed = true return end
	
	self.tmpPos = self.Ent:GetPos() + self.Ent:GetForward() * self.LocPos.x + self.Ent:GetRight() * self.LocPos.y + self.Ent:GetUp() * self.LocPos.z
	self:SetRenderBoundsWS( self.tmpPos, self.tmpPos + self.Ent:GetForward() * -100 )
	
	
end

function EFFECT:Think()
	if !IsValid(self.Ent) or CurTime() > self.LifeTime then return false end
	return true
end

function EFFECT:Render()

	if self.Ent == NULL then return false end
	
	self.tmpPos = self.Ent:GetPos() + self.Ent:GetForward() * self.LocPos.x + self.Ent:GetRight() * self.LocPos.y + self.Ent:GetUp() * self.LocPos.z
	self.Dir = self.Ent:GetForward() 
	self.Dir = self.Dir:GetNormalized() * -1 * self.Length
	
	self.scroll = (self.LifeTime - CurTime()) / self.Time
	self.lengthScale = self.scroll * 2 - 1
	
	if self.lengthScale > 0 then
		self.lengthScale = 1 - self.lengthScale
	else
		self.lengthScale = 1 + self.lengthScale
	end
	self.lengthScale = 1
	
	self.scroll = self.scroll * 10
	self.lengthScale = self.lengthScale * self.Scale
	
	render.SetMaterial( self.matFire )
	render.StartBeam( 3 )
		render.AddBeam( self.tmpPos, 8 * self.lengthScale, self.scroll, Color( 0, 0, 255, 128) )
		render.AddBeam( self.tmpPos + self.Dir * 15 * self.lengthScale, 8 * self.lengthScale, self.scroll + 1, Color( 255, 255, 255, 128) )
		render.AddBeam( self.tmpPos + self.Dir * 37 * self.lengthScale, 8 * self.lengthScale, self.scroll + 3, Color( 255, 255, 255, 0) )
	render.EndBeam()
	
	self.scroll = self.scroll * 0.5
	
	render.UpdateRefractTexture()
	render.SetMaterial( self.matHeatWave )
	render.StartBeam( 3 )
		render.AddBeam( self.tmpPos, 8 * self.lengthScale, self.scroll, Color( 0, 0, 255, 128) )
		render.AddBeam( self.tmpPos + self.Dir * 8 * self.lengthScale, 8 * self.lengthScale, self.scroll + 2, Color( 255, 255, 255, 255) )
		render.AddBeam( self.tmpPos + self.Dir * 32 * self.lengthScale, 12 * self.lengthScale, self.scroll + 5, Color( 0, 0, 0, 0) )
	render.EndBeam()
	
	self.scroll = self.scroll * 1.3

	render.SetMaterial( self.matFire )
	render.StartBeam( 3 )
		render.AddBeam( self.tmpPos, 8 * self.lengthScale, self.scroll, Color( 0, 0, 255, 128) )
		render.AddBeam( self.tmpPos + self.Dir * 15 * self.lengthScale, 4 * self.lengthScale, self.scroll + 1, Color( 0, 0, 255, 128) )
		render.AddBeam( self.tmpPos + self.Dir * 37 * self.lengthScale, 4 * self.lengthScale, self.scroll + 3, Color( 0, 0, 255, 0) )
	render.EndBeam()	

	
end


