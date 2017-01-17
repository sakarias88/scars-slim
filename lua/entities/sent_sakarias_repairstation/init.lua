--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.PutItOnPlace = 0 
ENT.ToolDelay = CurTime()

ENT.ToolList = {}
ENT.nrOfTools = 0

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	 
 	local ent = ents.Create( "sent_Sakarias_RepairStation" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
 	 
	return ent 
 	 
end

function ENT:Initialize()

	self:SetModel("models/props_lab/partsbin01.mdl")
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetSolid(SOLID_VPHYSICS)	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	self.ToolList = {}
	
end

function ENT:Use( activator, caller )	
	if self.ToolDelay < CurTime() then
		self.ToolDelay = CurTime() + 2
		
		local Position = self:GetPos() + self:GetForward() * 10
		local EntAng = self:GetAngles()
		
		local tool = ents.Create( "sent_Sakarias_RepairStationTool" )	
		tool:SetPos(Position)
		tool:SetColor(Color(0, 0, 0, 255))		
		tool:SetAngles(Angle(0, 0, 90)+EntAng)
		tool:Spawn()	
		self.nrOfTools = self.nrOfTools + 1
		self.ToolList[self.nrOfTools] = tool
	end
end

function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity	
	if string.find(ent:GetClass( ), "sent_sakarias_repairstationtool" ) and ent.ToolDelay and ent.ToolDelay < CurTime()  then
		ent:Remove()
	end
end

function ENT:OnRemove()

	for i = 1, self.nrOfTools do
		if self.ToolList[i]:IsValid() then
			self.ToolList[i]:Remove()
		end
	end
end
