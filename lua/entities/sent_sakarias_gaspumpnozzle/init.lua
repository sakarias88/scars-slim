--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_Sakarias_GasPumpNozzle" )
	ent:SetPos( SpawnPos ) 
	self.SpawnedBy = ply
 	ent:Spawn()
 	ent:Activate() 
	
	return ent 
	
end

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/prison_pipefaucet001a.mdl" )
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
end



-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity

	local dont = 0
	if string.find( ent:GetClass( ), "sent_sakarias_carwheel" ) or string.find( ent:GetClass( ), "sent_sakarias_carwheel_punked" ) or ent.IsDestroyed == 1 then
		dont = 1
	end
	
	if string.find( ent:GetClass( ), "sent_sakarias_car" ) && dont == 0 then
		ent:Refuel()
		self:EmitSound("ambient/water/rain_drip2.wav", 100, 100)
	end
	
end
-------------------------------------------THINK
function ENT:Think()


end
