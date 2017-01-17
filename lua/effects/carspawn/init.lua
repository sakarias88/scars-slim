AddCSLuaFile("shared.lua")

local matWireFrame  = Material( "models/wireframe" )

EFFECT.Time = 1
EFFECT.LifeTime = CurTime()

EFFECT.percent = 0
EFFECT.invPer = 0
EFFECT.highPer = 0
EFFECT.height = 0
EFFECT.mins = 0
EFFECT.maxs = 0
EFFECT.AddDist = 0.2
EFFECT.ParticleDiff = Vector(0,0,0)
EFFECT.Emitter = nil
EFFECT.Size = 0
EFFECT.CurParticleEmit = 0

function EFFECT:Init( data )
	if render.GetDXLevel() <= 90 then return false end

    self.LifeTime = CurTime() + self.Time
    self.ParentEntity = data:GetEntity()
    if !IsValid(self.ParentEntity) then return end
    
	self.Emitter = ParticleEmitter( self.ParentEntity:GetPos() )
	
	self.mins = self.ParentEntity:OBBMins()
	self.maxs = self.ParentEntity:OBBMaxs()
	self.height = self.maxs.z - self.mins.z
	self.ParticleDiff = self.maxs - self.mins / 2
	self.ParticleDiff.x = self.ParticleDiff.x * 0.8
	self.ParticleDiff.y = self.ParticleDiff.y * 0.8
	
	self.Size = self.ParticleDiff.x + self.ParticleDiff.y 
	self.Size = self.Size / 100
	
	if !self.ParentEntity:GetModel() then return end --//Some people manage to get models with no models
	
    self:SetModel( self.ParentEntity:GetModel() )    
    self:SetPos( self.ParentEntity:GetPos() )
    self:SetAngles( self.ParentEntity:GetAngles() )
    self:SetParent( self.ParentEntity )
	local skin = self.ParentEntity:GetSkin()
	if !skin then skin = 0 end
	self:SetSkin(self.ParentEntity:GetSkin())
	self.ParentEntity:SetColor(Color(0,0,0,0))
	self.ParentEntity:SetNoDraw( true )
	self.Emitter=ParticleEmitter(self:GetPos())
end


function EFFECT:Think( )
	if render.GetDXLevel() <= 90 then return false end

    if !IsValid(self.ParentEntity) then return false end

	if self.highPer <= 0 then
		self.ParentEntity:SetColor(Color(255,255,255,255))
		self.ParentEntity:SetNoDraw( false )
		self.Emitter:Finish()
		return false
	else
		return true
	end 
end

function EFFECT:SCarSetMaterial( mat )
	render.MaterialOverride( mat )
end

function EFFECT:Render()

	if render.GetDXLevel() <= 90 then return false end
 
	if self.ParentEntity == NULL then return false end
 
	self.percent = (self.LifeTime - CurTime()) / self.Time
	self.highPer = self.percent + self.AddDist
	self.percent = math.Clamp( self.percent, 0, 1 )
	self.highPer = math.Clamp( self.highPer, 0, 1 )

	--Drawing original model
	local normal = self.ParentEntity:GetUp() * -1
	local origin = self.ParentEntity:GetPos() + self.ParentEntity:GetUp() * (self.maxs.z - ( self.height * self.highPer ))
	local distance = normal:Dot( origin )
	
	local oldEnableClipping = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, distance )
	self:DrawModel()
	render.PopCustomClipPlane()
	
	
	--Drawing wire frame
	self:SCarSetMaterial( matWireFrame )

	normal = self.ParentEntity:GetUp()
	distance = normal:Dot( origin )
	render.PushCustomClipPlane( normal, distance )
	
	local normal2 = self.ParentEntity:GetUp() * -1
	local origin2 = self.ParentEntity:GetPos() + self.ParentEntity:GetUp() * (self.maxs.z - ( self.height * self.percent ))
	local distance2 = normal2:Dot( origin2 )
	render.PushCustomClipPlane( normal2, distance2 )
	
	self:DrawModel()
	
	render.PopCustomClipPlane()
	render.PopCustomClipPlane()

	
	self:SCarSetMaterial( 0 )
	
	render.EnableClipping( oldEnableClipping )
	
	self.CurParticleEmit = self.CurParticleEmit + self.Size
	while self.CurParticleEmit > 1 do
		self.CurParticleEmit = self.CurParticleEmit - 1
		local height = math.Rand(0, 300)
		local randPos = self.ParentEntity:GetForward() * math.Rand( -self.ParticleDiff.x, self.ParticleDiff.x ) + self.ParentEntity:GetRight() * math.Rand( -self.ParticleDiff.y, self.ParticleDiff.y ) 
		
		local particle = self.Emitter:Add( "sprites/gmdm_pickups/light", self.ParentEntity:GetPos() + randPos + self.ParentEntity:GetUp() *  (self.maxs.z - ( self.height * self.highPer )))
		particle:SetVelocity( Vector(0,0, 0.2 * (self.maxs.z - ( self.height * self.highPer ))))
		particle:SetDieTime(0.5)
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( math.Rand( 1, 5 ) )
		particle:SetEndSize( math.Rand( 5, 10 ) )
		particle:SetEndAlpha( 0 )
		particle:SetRoll( math.Rand( -0.2, 0.2 ) )	
		particle:SetAirResistance( 10 )	 
	end
end