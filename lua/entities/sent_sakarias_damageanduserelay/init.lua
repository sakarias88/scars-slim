AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = nil
ENT.EntOwner = nil

function ENT:Initialize()
	
	if self.Model == nil then
		SCarsReportError("Damage and use relay model was nil! Forgot to set the model?")
		self.Model = "models/props_c17/oildrum001.mdl"
	end
	
	self:SetModel( self.Model )
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
end


function ENT:PhysicsCollide( data, phys ) 
	if self.EntOwner then
		self.EntOwner:PhysicsCollide( data, phys ) 
	end
end

function ENT:Use( activator, caller )	
	if IsValid(self.EntOwner) then
		self.EntOwner:Use( activator, caller, 0, 0 )
	end
end

function ENT:OnTakeDamage(dmg)
	if self.EntOwner then
		self.EntOwner:OnTakeDamage(dmg)
	end
end