--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.maxS = NULL
ENT.minS = NULL
ENT.EntOwner = NULL
ENT.rot = Angle(0,0,0)

function ENT:Initialize()

	self:SetColor(Color(255,255,255,0))
	
	if self.width == nil then
		SCarsReportError("You forgot to set the check detectors width!")
		self.width = 10
	end
	
	self.width = self.width * 0.9
    self.maxS = Vector(20, (self.width/2) , 245)
    self.minS = Vector(-20, -(self.width/2), -245)


    self:PhysicsInitBox(self.minS,self.maxS)

	
 	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:EnableCollisions( false )
		phys:EnableGravity( false )
	end	

	self:SetTrigger( true )
	self:SetNotSolid( true )

	self.maxS:Rotate(self.rot)
	self.minS:Rotate(self.rot)	
	
   self:SetCollisionBounds(self.minS,self.maxS)
end



-------------------------------------------THINK
function ENT:Think()
	self:GetPhysicsObject():Wake()
end

function ENT:StartTouch(ent)
	if (ent:IsVehicle() or string.find(ent:GetClass(), "sent_sakarias_car_")) && self.EntOwner != NULL && IsValid(self.EntOwner) then
		self.EntOwner:CarEntered( ent )
	end
end

function ENT:Touch(ent)
	if (ent:IsVehicle() or string.find(ent:GetClass(), "sent_sakarias_car_")) && self.EntOwner != NULL && IsValid(self.EntOwner) then
		self.EntOwner:CarInside( ent )
	end
end

function ENT:SetEntityOwner( ent )
	self.EntOwner = ent
end