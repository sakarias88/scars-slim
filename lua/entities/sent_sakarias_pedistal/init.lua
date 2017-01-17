--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.EntOwner = NULL
ENT.VisualPed = NULL
ENT.TrafficLight = NULL
ENT.TrafficLight2 = NULL
ENT.VisaulPedTop = NULL
ENT.Pedistal = NULL
ENT.StabilisationProp = NULL
ENT.AngTest = 0
ENT.IsShowingTrafficLights = false

ENT.Tsprite1 = NULL
ENT.Tsprite2 = NULL

ENT.LastCol = ""


------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr ) 
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_Sakarias_Pedistal" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
	ent:SetCarOwner(ply)
 	ent:Activate() 
	return ent 
	
end

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/sawblade001a.mdl" )
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	phys:SetMass(10)
	
	self.StabilisationProp = ents.Create( "prop_physics" )
	self.StabilisationProp:SetModel("models/props_junk/sawblade001a.mdl")		
	self.StabilisationProp:SetPos(self:GetPos() )	
	self.StabilisationProp:SetAngles(self:GetAngles())
	self.StabilisationProp:SetColor(Color(255,255,255,0))
	self.StabilisationProp:Spawn()
	self.StabilisationProp:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )	
	self.StabilisationProp:GetPhysicsObject():SetMass(10)
	self.StabilisationProp:SetNotSolid( true )
	self.StabilisationProp:DrawShadow( false )
	construct.SetPhysProp( self.Owner,  self.StabilisationProp, 0, nil, { GravityToggle = 1, Material = "rubber" })	

	
	self.VisualPed = ents.Create( "prop_dynamic")
	self.VisualPed:SetModel("models/props_c17/truss02d.mdl")
	self.VisualPed:Spawn()
	self.VisualPed:SetParent( self )
	self.VisualPed:SetLocalPos( Vector(0,0,100) )
	self.VisualPed:SetLocalAngles( Angle(0,0,0) ) 

	local pos = Vector(0,0,20) 
	local ang = Angle(-90,0,-90)	
	
	if self.LORR == nil then
		SCarsReportError("Pedistals left or right value (LORR) is not initiated!")
		self.LORR = 1
	end
	
	pos.z = pos.z * self.LORR
	ang.p = ang.p * self.LORR
	
	
	self.TrafficLight = ents.Create( "prop_dynamic")
	self.TrafficLight:SetModel("models/props_c17/Traffic_Light001a.mdl")
	self.TrafficLight:Spawn()
	self.TrafficLight:SetParent( self.VisualPed )
	self.TrafficLight:SetLocalPos( pos )
	self.TrafficLight:SetLocalAngles( ang ) 
	self.TrafficLight:SetColor(Color(255,255,255,0))

	self.TrafficLight2 = ents.Create( "prop_dynamic")
	self.TrafficLight2:SetModel("models/props_c17/Traffic_Light001a.mdl")
	self.TrafficLight2:Spawn()
	self.TrafficLight2:SetParent( self.VisualPed )
	self.TrafficLight2:SetLocalPos( pos + Vector(0,120,0) )
	self.TrafficLight2:SetLocalAngles( ang ) 	
	self.TrafficLight2:SetColor(Color(255,255,255,0))
	
	self.VisaulPedTop = ents.Create( "prop_dynamic")
	self.VisaulPedTop:SetModel("models/props_c17/truss02d.mdl")
	self.VisaulPedTop:Spawn()
	self.VisaulPedTop:SetParent( self )
	self.VisaulPedTop:SetLocalPos( Vector(0,0,245) )
	self.VisaulPedTop:SetLocalAngles( Angle(0,90,0) ) 
	
	constraint.Weld( self, self.StabilisationProp, 0, 0, 0, 0 )
	constraint.Keepupright( self.StabilisationProp, Angle(0,0,0) , 0, 5000)		
end



-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
	
end
-------------------------------------------THINK
function ENT:Think()
	
	if !self:WasValidEnt(self.StabilisationProp) then
		self:Remove()
		return
	end

	self:UpdatePedistalDir()
end

function ENT:Use( activator, caller )	
	if self:WasValidEnt( self.EntOwner ) then
		self.EntOwner:Use( activator, caller )	
	end
end

function ENT:PhysicsUpdate( physics )	
	
	
	--if self:WasValidEnt(self.StabilisationProp) then
	--	self.StabilisationProp:GetPhysicsObject():SetVelocity( self.StabilisationProp:GetPhysicsObject():GetVelocity() * 0.9 )
	--end
end


function ENT:SetEntityOwner( ent )
	self.EntOwner = ent
end

function ENT:SetSecondPedistal( ent )
	self.Pedistal = ent
end

function ENT:WasValidEnt( ent )
	if ent != NULL && IsValid( ent ) then
		return true
	end

	return false
end


function ENT:UpdatePedistalDir()

	self:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity()*-0.1 )

	if self:WasValidEnt( self.Pedistal ) then
		local dir = self:GetPos() - self.Pedistal:GetPos()
		local ang2 = dir:Angle() + Angle(0,90,0)
		ang2.r = ang2.p
		ang2.p = 0
		self.VisaulPedTop:SetAngles( ang2 )
		 
		--Reposition
		self.VisaulPedTop:SetLocalPos( Vector(0,0,245) + self:WorldToLocalAngles( dir:Angle() ):Forward() * -150 ) 
		
		local ang = dir
		ang.z = 0
		ang = ang:Angle() + Angle(0,0,90)
		self.VisualPed:SetAngles( ang  )
	end
end

function ENT:OnRemove()

	if self:WasValidEnt( self.VisaulPedTop ) then
		self.VisaulPedTop:Remove()
	end

	if self:WasValidEnt( self.VisualPed ) then
		self.VisualPed:Remove()
	end
	
	if self:WasValidEnt( self.StabilisationProp ) then
		self.StabilisationProp:Remove()
	end	
end

function ENT:ShowTrafficLights( show )

	if self.IsShowingTrafficLights != show then
		self.IsShowingTrafficLights = show

		if show == false then
			self.TrafficLight:SetColor(Color(255,255,255,0))
			self.TrafficLight2:SetColor(Color(255,255,255,0))
		else
			self.TrafficLight:SetColor(Color(255,255,255,255))
			self.TrafficLight2:SetColor(Color(255,255,255,255))		
		end
	
	end
end

function ENT:ShowNothing()
	self.LastCol = ""
	if self.Tsprite1 != NULL then
		self.Tsprite1:Remove()
		self.Tsprite1 = NULL
	end
	
	if self.Tsprite2 != NULL then
		self.Tsprite2:Remove()
		self.Tsprite2 = NULL
	end	
end

function ENT:ShowRed()
	if self.IsShowingTrafficLights == true then
		self:ReCreateSprites( "255 0 0" )
		self.Tsprite1:SetLocalPos( Vector(4,0,12) )
		self.Tsprite2:SetLocalPos( Vector(4,0,12) )
	end
end

function ENT:ShowYellow()
	if self.IsShowingTrafficLights == true then
		self:ReCreateSprites( "255 255 0" )
		self.Tsprite1:SetLocalPos( Vector(4,0,0) )
		self.Tsprite2:SetLocalPos( Vector(4,0,0) )
	end
end

function ENT:ShowGreen()
	if self.IsShowingTrafficLights == true then
		self:ReCreateSprites( "0 255 0" )
		self.Tsprite1:SetLocalPos( Vector(4,0,-12) )
		self.Tsprite2:SetLocalPos( Vector(4,0,-12) )
	end
end

function ENT:ReCreateSprites( col )

	if self.LastCol != col then
		self.LastCol = col

		if self.Tsprite1 != NULL then
			self.Tsprite1:Remove()
			self.Tsprite1 = NULL
		end
		
		if self.Tsprite2 != NULL then
			self.Tsprite2:Remove()
			self.Tsprite2 = NULL
		end	

		self.Tsprite1 = ents.Create("env_sprite")
		self.Tsprite1:SetKeyValue( "renderfx", "14" )
		self.Tsprite1:SetKeyValue( "model", "sprites/glow1.vmt")
		self.Tsprite1:SetKeyValue( "scale","0.5")
		self.Tsprite1:SetKeyValue( "spawnflags","1")
		self.Tsprite1:SetKeyValue( "angles","0 0 0")
		self.Tsprite1:SetKeyValue( "rendermode","9")
		self.Tsprite1:SetKeyValue( "renderamt", "255")
		self.Tsprite1:SetKeyValue( "rendercolor", col )				
		self.Tsprite1:Spawn()
		self.Tsprite1:SetParent( self.TrafficLight )
		
		self.Tsprite2 = ents.Create("env_sprite")
		self.Tsprite2:SetKeyValue( "renderfx", "14" )
		self.Tsprite2:SetKeyValue( "model", "sprites/glow1.vmt")
		self.Tsprite2:SetKeyValue( "scale","0.5")
		self.Tsprite2:SetKeyValue( "spawnflags","1")
		self.Tsprite2:SetKeyValue( "angles","0 0 0")
		self.Tsprite2:SetKeyValue( "rendermode","9")
		self.Tsprite2:SetKeyValue( "renderamt", "255")
		self.Tsprite2:SetKeyValue( "rendercolor", col )				
		self.Tsprite2:Spawn()
		self.Tsprite2:SetParent( self.TrafficLight2 )		
	end
end

function ENT:SetCarOwner(ply)
	SCarSetObjOwner(self.SpawnedBy, self)
	SCarSetObjOwner(self.SpawnedBy, self.StabilisationProp)
	SCarSetObjOwner(self.SpawnedBy, self.VisualPed)
	SCarSetObjOwner(self.SpawnedBy, self.TrafficLight)
	SCarSetObjOwner(self.SpawnedBy, self.TrafficLight2)
	SCarSetObjOwner(self.SpawnedBy, self.VisaulPedTop)
end

