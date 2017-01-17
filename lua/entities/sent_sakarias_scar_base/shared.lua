
ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "SCarBase"
ENT.Author			= "Sakarias88"
ENT.Category 		= "Sakarias88"
ENT.Contact    		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= "" 

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:IsScar()
	return true
end

local VehicleMeta = FindMetaTable("Entity")
local OldIsVehicle = VehicleMeta.IsVehicle

function VehicleMeta:IsVehicle()
	return self.IsScar and self:IsScar() or OldIsVehicle(self)
end
