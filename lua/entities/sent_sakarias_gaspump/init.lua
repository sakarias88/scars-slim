AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.PlaceEnt = NULL
ENT.DoRepos = false

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	 
 	local ent = ents.Create( "sent_Sakarias_GasPump" )
	ent:SetPos( SpawnPos ) 
	ent.SpawnedBy = ply
 	ent:Spawn()
 	ent:Activate() 
 	 
	return ent 
end

function ENT:Initialize()

	self:SetModel("models/props_wasteland/gaspump001a.mdl")
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetSolid(SOLID_VPHYSICS)	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	self:ReCreateNozzle()
end
function ENT:PhysicsCollide( data, phys ) 

	ent = data.HitEntity
	
	if string.find(ent:GetClass( ), "sent_sakarias_gaspumpnozzle" ) then
		self.DoRepos = true
	end
end

function ENT:RepositionNozzle()

	if self.PlaceEnt == nil or self.PlaceEnt == NULL or !IsValid(self.PlaceEnt) then
		self:ReCreateNozzle()
		return
	end	

	local Position = self:GetPos()+((self:GetRight()*20)+(self:GetUp()*45))
	local EntAng = self:GetAngles()		

	self.PlaceEnt:SetPos(Position)
	self.PlaceEnt:SetAngles(Angle(0, 0, 90)+EntAng)
	self.PlaceEnt:GetPhysicsObject():SetVelocity( self:GetPhysicsObject():GetVelocity() )
	self.PlaceEnt:GetPhysicsObject():AddAngleVelocity( self.PlaceEnt:GetPhysicsObject():GetAngleVelocity() * -1 )
	
	constraint.Weld( self, self.PlaceEnt, 0, 0, 1000)
end

function ENT:ReCreateNozzle()
	local Position = self:GetPos()+((self:GetRight()*20)+(self:GetUp()*45))
	local EntAng = self:GetAngles()
	
	self.PlaceEnt = ents.Create( "sent_Sakarias_GasPumpNozzle" )	
	self.PlaceEnt:SetPos(Position)
	self.PlaceEnt:SetColor(Color(0, 0, 0, 255))		
	self.PlaceEnt:SetAngles(Angle(0, 0, 90)+EntAng)
	self.PlaceEnt.SpawnedBy = nil
	self.PlaceEnt:Spawn()	

	constraint.Rope( self, self.PlaceEnt, 0, 0, Vector(0,-18,56), Vector(0,-7,0), 0, 200, 0, 3, "cable/cable2")
	constraint.Weld( self, self.PlaceEnt, 0, 0, 1000)
end

function ENT:Think()

	if self.DoRepos == true then
		self.DoRepos = false
		self:RepositionNozzle()
	end

	if self.PlaceEnt == nil or self.PlaceEnt == NULL or !IsValid(self.PlaceEnt) then
		self:RepositionNozzle()
	end	
	
end

--If the gas pump is removed it will also remove the pipefaucet.
function ENT:OnRemove()
	if self.PlaceEnt:IsValid() then
		self.PlaceEnt:Remove()
	end
end