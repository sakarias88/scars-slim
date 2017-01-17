AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.NextNode = NULL
ENT.PrevNode = NULL

ENT.Light = NULL
ENT.ToRed = false
ENT.RedDel = CurTime()
ENT.UpdateDel = CurTime()
ENT.TrackID = nil

ENT.TurnPercent = 0
ENT.DistToPrevNode = 0
ENT.IsCalibrated = 0
ENT.IRNode = true



function ENT:SpawnFunction( ply, tr )
 
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( self.Classname )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	self.target = ply
	return ent 
	
end

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/TrafficCone001a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
	
	self.Light = ents.Create("env_sprite")
	self.Light:SetPos( self:GetPos() + self:GetUp() * 20 )	
	self.Light:SetKeyValue( "renderfx", "14" )
	self.Light:SetKeyValue( "model", "sprites/glow1.vmt")
	self.Light:SetKeyValue( "scale","0.6")
	self.Light:SetKeyValue( "spawnflags","1")
	self.Light:SetKeyValue( "angles","0 0 0")
	self.Light:SetKeyValue( "rendermode","9")
	self.Light:SetKeyValue( "renderamt", "250" )
	self.Light:SetKeyValue( "rendercolor", "0 255 0" )				
	self.Light:Spawn()
	self.Light:SetParent( self )	
	
end
-------------------------------------------USE
function ENT:Use( activator, caller )	

end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity

end
-------------------------------------------PHYSICS
function ENT:PhysicsUpdate( physics )	
	
	
	
end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

end
-------------------------------------------THINK
function ENT:Think()

	if self.ToRed == true && self.RedDel < CurTime() then
		self.Light:Remove()
		self.ToRed = false

		self.Light = ents.Create("env_sprite")
		self.Light:SetPos( self:GetPos() + self:GetUp() * 20 )	
		self.Light:SetKeyValue( "renderfx", "14" )
		self.Light:SetKeyValue( "model", "sprites/glow1.vmt")
		self.Light:SetKeyValue( "scale","1.0")
		self.Light:SetKeyValue( "spawnflags","1")
		self.Light:SetKeyValue( "angles","0 0 0")
		self.Light:SetKeyValue( "rendermode","9")
		self.Light:SetKeyValue( "renderamt", "250" )
		self.Light:SetKeyValue( "rendercolor", "0 255 0" )				
		self.Light:Spawn()
		self.Light:SetParent( self )			
	end
	
end
-------------------------------------------ON REMOVE
function ENT:OnRemove()

	if self.TrackID then
		RemoveNodeOnTrack( self.TrackID, self )
	end
	

end

function ENT:GetNextNode()

	if self.ToRed == false then
	
		self.ToRed = true
		self.RedDel = CurTime() + 2
		self.Light:Remove()
		
		self.Light = ents.Create("env_sprite")
		self.Light:SetPos( self:GetPos() + self:GetUp() * 20 )	
		self.Light:SetKeyValue( "renderfx", "14" )
		self.Light:SetKeyValue( "model", "sprites/glow1.vmt")
		self.Light:SetKeyValue( "scale","1.0")
		self.Light:SetKeyValue( "spawnflags","1")
		self.Light:SetKeyValue( "angles","0 0 0")
		self.Light:SetKeyValue( "rendermode","9")
		self.Light:SetKeyValue( "renderamt", "250" )
		self.Light:SetKeyValue( "rendercolor", "255 0 0" )				
		self.Light:Spawn()
		self.Light:SetParent( self )			
	end


	return self.NextNode
end

function ENT:GetPrevNode()

	if self.ToRed == false then
	
		self.ToRed = true
		self.RedDel = CurTime() + 2
		self.Light:Remove()
		
		self.Light = ents.Create("env_sprite")
		self.Light:SetPos( self:GetPos() + self:GetUp() * 20 )	
		self.Light:SetKeyValue( "renderfx", "14" )
		self.Light:SetKeyValue( "model", "sprites/glow1.vmt")
		self.Light:SetKeyValue( "scale","1.0")
		self.Light:SetKeyValue( "spawnflags","1")
		self.Light:SetKeyValue( "angles","0 0 0")
		self.Light:SetKeyValue( "rendermode","9")
		self.Light:SetKeyValue( "renderamt", "250" )
		self.Light:SetKeyValue( "rendercolor", "255 0 0" )				
		self.Light:Spawn()
		self.Light:SetParent( self )			
	end

	return self.PrevNode
end

function ENT:UpdateSpeedLimitations()
	
	if self.UpdateDel < CurTime() && IsValid(self.NextNode) && IsValid(self.PrevNode) then
		
		local v1 = self.PrevNode:GetPos() - self:GetPos()
		local v2 = self:GetPos() - self.NextNode:GetPos()
	
		v1:Normalize()
		v2:Normalize()
		
		local dot = v1:DotProduct(v2)
		dot = (dot + 1) / 2
		
		if dot < 0 then dot = dot * -1 end

		self.TurnPercent = dot
		self.DistToPrevNode = self:GetPos():Distance( self.PrevNode:GetPos() )		
	end
end