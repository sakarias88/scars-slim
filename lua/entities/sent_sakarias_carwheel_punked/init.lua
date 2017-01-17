AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.SpawnedBy = NULL
ENT.Owner = NULL
ENT.entOwner = NULL

ENT.CollideDelay = CurTime()
ENT.CollideAddTime = 0.5
ENT.IsPlayingScrapeSound = false
ENT.ScrapeSound = NULL

ENT.CollisionDetected = false
ENT.IsSparkling = false
ENT.ShouldSparkleDelay = CurTime()

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_sakarias_carwheel_punked" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	self.SpawnedBy = ply
	return ent 
	
end

function ENT:Initialize()

	self:SetModel( "models/props_c17/pulleywheels_small01.mdl" )
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(255,255,255,0))
	self:SetNoDraw( true )
	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	construct.SetPhysProp( self.SpawnedBy,  self, 0, nil, { GravityToggle = 1, Material = "brakingrubbertire" })
	self.ScrapeSound = CreateSound(self,"physics/metal/canister_scrape_smooth_loop1.wav")

	self:SetNetworkedBool( "IsColliding", false )
	self:SetNetworkedBool( "shouldSparkle", false )
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	self.CollideDelay = CurTime() + self.CollideAddTime
end

-------------------------------------------THINK
function ENT:Think()

	if self.IsDestroyed == false then
		if self:IsColliding() && self.CollisionDetected == false then
			self.CollisionDetected = true
			self:SetNetworkedBool( "IsColliding", true )
		elseif !self:IsColliding() && self.CollisionDetected == true then
			self.CollisionDetected = false
			self:SetNetworkedBool( "IsColliding", false )
		end
	end
	
	if self.IsSparkling == true && self.ShouldSparkleDelay < CurTime() then
		self.IsSparkling = false
		self:SetNetworkedBool( "shouldSparkle", false )
	end

end

function ENT:OnTakeDamage(dmg)

	if IsValid(self.OwnerEnt) then
		local Damage = dmg:GetDamage()
		local attacker = dmg:GetAttacker( )
		self.OwnerEnt:GiveDamage(Damage, attacker)
	end
	
end

function ENT:OnRemove()
	--self.ScrapeSound:Stop()
end

function ENT:RecreateWheelSounds()
	--self.ScrapeSound = CreateSound(self.Entity,"physics/metal/canister_scrape_smooth_loop1.wav")	
end

function ENT:ChangeOneWheel( model, physMat, useOldPos)
	if self.IsDestroyed == false && self.OwnerEnt != NULL && IsValid(self.OwnerEnt) then
		self.OwnerEnt:ChangeOneWheel( model, physMat, useOldPos)
	end
end

function ENT:EmitSparkles()

	self.ShouldSparkleDelay = CurTime() + 0.2

	if self.IsSparkling == false then
		self.IsSparkling = true
		self:SetNetworkedBool( "shouldSparkle", true )
	end
end

function ENT:IsColliding()

	if self.CollideDelay > CurTime() then
		return true
	end
	
	return false
end

function ENT:SetCarOwner( ply )
	SCarSetObjOwner( ply, self, true )
end