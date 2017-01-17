--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.OwnerEnt = NULL
ENT.TriggerFunction = NULL
ENT.id = 0
ENT.UseDel = CurTime()

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_Sakarias_RaceHandlerButton" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	return ent 
	
end

function ENT:Initialize()
	
	self:SetModel("models/props_c17/playgroundTick-tack-toe_block01a.mdl")
	
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then 
		phys:Wake() 
		phys:EnableMotion( false )
		phys:EnableCollisions( false )
		phys:EnableGravity( false )	
	end	

	--self:SetNotSolid( true )
	self:DrawShadow( false )
	
	self:SetColor(Color(255, 0, 0, 0))
	
	self:SetNetworkedString( "ButtonText", "ERROR" )
end

function ENT:Use( act, cal )	

	if self.UseDel < CurTime() && act:IsPlayer() && self.OwnerEnt != NULL && IsValid( self.OwnerEnt ) then
		self.UseDel = CurTime() + 0.5
		
		local dist = self:GetPos():Distance( act:GetShootPos() )
		local dr = (self:GetPos() - act:GetShootPos()):GetNormalized():Dot( act:GetAimVector() )
		
		if dr > 0.98 && dist < 100 then
			self.OwnerEnt:TriggerFunc( self.id , act )
		end
	end

end

function ENT:Think()
end

function ENT:OnRemove()
	
end

function ENT:SetButtonText( str )
	self:SetNetworkedString( "ButtonText", str )
end

function ENT:SetOwnerEnt( ent )
	self.OwnerEnt = ent
end

function ENT:SetTriggerFunction( TrigFunc, id )
	self.TriggerFunction = TrigFunc
	self.id = id
end