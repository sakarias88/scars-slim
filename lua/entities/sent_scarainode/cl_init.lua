include("shared.lua")

function ENT:Initialize()
	self:SetCustomCollisionCheck(true)
end

function ENT:Draw()
	self:DrawModel()
end
