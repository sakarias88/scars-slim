AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.GasPumps = {}
ENT.GasPumpPos = {Vector(256,-14,8), Vector(0,-14,8), Vector(-256,-14,8)}
------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	 
 	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos ) 
	ent.SpawnedBy = ply
 	ent:Spawn()
 	ent:Activate()
	
	return ent 
end

function ENT:Initialize()

	self:SetModel("models/gas_station/gas_station.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	self.GasPumps = {}
	
	SCarSetObjOwner(self.SpawnedBy, self)
	
	for i = 1, 3 do
		self.GasPumps[i] = ents.Create("sent_sakarias_gaspump")
		self.GasPumps[i]:SetPos( self:GetPos() + self:GetForward() * self.GasPumpPos[i].x + self:GetRight() * self.GasPumpPos[i].y + self:GetUp() * self.GasPumpPos[i].z)
		self.GasPumps[i]:SetAngles(self:GetAngles())
		self.GasPumps[i].SpawnedBy = self.SpawnedBy
		self.GasPumps[i]:Spawn()
		constraint.Weld( self, self.GasPumps[i], 0, 0, 0)
		constraint.NoCollide( self, self.GasPumps[i], 0, 0 )
	end
	
	
end

function ENT:Think()
	for i = 1, 3 do
		if !self.GasPumps[i] or self.GasPumps[i] == NULL or !IsValid( self.GasPumps[i] ) then
			self:Remove()
		end
	end
end

function ENT:OnRemove()
	for i = 1, 3 do
		if self.GasPumps[i] and self.GasPumps[i] != NULL and IsValid( self.GasPumps[i] ) then
			self.GasPumps[i]:Remove()
		end
	end
end
