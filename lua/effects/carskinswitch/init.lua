AddCSLuaFile("shared.lua")

local matWireFrame  = Material( "models/wireframe" )

EFFECT.Time = 0.2
EFFECT.LifeTime = CurTime()

EFFECT.percent = 0
EFFECT.highPer = 0
EFFECT.height = 0
EFFECT.mins = 0
EFFECT.maxs = 0
EFFECT.AddDist = 0.1
EFFECT.Skin1 = 1
EFFECT.Skin2 = 1
EFFECT.Col = Color(0,0,0,0)

function EFFECT:Init( data )

	if render.GetDXLevel() <= 90 then return false end

    self.LifeTime = CurTime() + self.Time
    
    self.ParentEntity = data:GetEntity()
	local startVec = data:GetStart()
	
	self.Skin1 = startVec.x
	self.Skin2 = startVec.y
	
    if !IsValid(self.ParentEntity) then return end
    
	
	self.mins = self.ParentEntity:OBBMins()
	self.maxs = self.ParentEntity:OBBMaxs()
	self.height = self.maxs.x - self.mins.x

	self.Col = self.ParentEntity:GetColor()

	
	self.Col.r = self.Col.r / 255
	self.Col.g = self.Col.g / 255
	self.Col.b = self.Col.b / 255
	self.Col.a = self.Col.a / 255
	
    self:SetModel( self.ParentEntity:GetModel() )    
    self:SetPos( self.ParentEntity:GetPos() )
    self:SetAngles( self.ParentEntity:GetAngles() )
    self:SetParent( self.ParentEntity )
	self:SetSkin(self.ParentEntity:GetSkin())
	self:SetColor( self.Col )
	self.ParentEntity:SetNoDraw(true)

end


function EFFECT:Think( )

	if !IsValid(self.ParentEntity) or render.GetDXLevel() <= 90 then return false end

	if self.highPer <= 0 then
		self.ParentEntity:SetNoDraw(false)
		return false
	else
		return true
	end  
end

function EFFECT:SCarSetMaterial( mat )
	render.MaterialOverride( mat )
end

function EFFECT:Render()
	
	if !IsValid(self.ParentEntity) then return false end
	
	if render.GetDXLevel() <= 90 or self.Failed then return false end

	self.ParentEntity:SetNoDraw(true)
	
	self.percent = (self.LifeTime - CurTime()) / self.Time
	self.highPer = self.percent + self.AddDist
	self.percent = math.Clamp( self.percent, 0, 1 )
	self.highPer = math.Clamp( self.highPer, 0, 1 )

	--Drawing the old skin
	local normal = self.ParentEntity:GetForward() * -1
	local origin = self.ParentEntity:GetPos() + self.ParentEntity:GetForward() * (self.maxs.x - ( self.height * self.highPer ))
	local distance = normal:Dot( origin )
	
	local oldEnableClipping = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, distance )
	self:SetSkin(self.Skin2)
	render.SetColorModulation( self.Col.r, self.Col.g, self.Col.b )
	render.SetBlend( self.Col.a )
	self:DrawModel()
	render.PopCustomClipPlane()
	
	--Draw the wireframe
	self:SCarSetMaterial( matWireFrame )
		normal = self.ParentEntity:GetForward()
		distance = normal:Dot( origin )
		render.PushCustomClipPlane( normal, distance )
		
		local normal2 = self.ParentEntity:GetForward() * -1
		local origin2 = self.ParentEntity:GetPos() + self.ParentEntity:GetForward() * (self.maxs.x - ( self.height * self.percent ))
		local distance2 = normal2:Dot( origin2 )
		render.PushCustomClipPlane( normal2, distance2 )
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
		self:DrawModel()
		
		render.PopCustomClipPlane()
		render.PopCustomClipPlane()	
	self:SCarSetMaterial( 0 )
	
	--Draw the new skin
	normal2 = self.ParentEntity:GetForward()
	distance2 = normal2:Dot( origin2 )
	render.PushCustomClipPlane( normal2, distance2 )	
	
	self:SetSkin(self.Skin1)
	render.SetColorModulation( self.Col.r, self.Col.g, self.Col.b )
	render.SetBlend( self.Col.a )
	self:DrawModel()
	render.PopCustomClipPlane()
	
	render.EnableClipping( oldEnableClipping )
end