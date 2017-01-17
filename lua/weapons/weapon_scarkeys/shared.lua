SWEP.Author   			= "Sakarias88"
SWEP.Contact        	= ""
SWEP.Purpose        	= ""
SWEP.Instructions   	= ""
SWEP.Spawnable      	= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel = Model( "models/weapons/v_slam.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_slam.mdl" )

if ( SERVER ) then 
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
else
	SWEP.PrintName			= "SCar keys"			
	SWEP.Author				= "Sakarias88"
	SWEP.Category			= "SCars"
	SWEP.DrawCrosshair 		= true
	SWEP.DrawAmmo			= false
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 60
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/scarkeys")
end


SWEP.UseDel = CurTime()
SWEP.skullModel = nil
SWEP.RandModels = {"models/Gibs/HGIBS.mdl", "models/props_combine/breenbust.mdl", "models/props_vehicles/carparts_wheel01a.mdl", "models/props_c17/doll01.mdl", "models/Roller.mdl", "models/props_phx/misc/soccerball.mdl", "models/props_vehicles/van001a_physics.mdl", "models/props_vehicles/apc_tire001.mdl", "models/props_junk/gascan001a.mdl", "models/props_junk/metalgascan.mdl"}
SWEP.ModelScales = {0.2, 0.35, 0.07, 0.5, 0.30, 0.30, 0.12, 0.045, 0.1, 0.1}

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType( "normal" )
	else
		local rand = math.random(1, table.Count(self.RandModels))
		rand = 10;
		self.skullModel = ClientsideModel(	self.RandModels[rand] , RENDERGROUP_OPAQUE)
		self.skullModel:SetNoDraw( true )
	
		self.skullModel:SetModelScale(self.ModelScales[rand], 0)		
	end
end

function SWEP:Think()

end

function SWEP:PrimaryAttack()
	if self.UseDel < CurTime() then
		self.UseDel = CurTime() + 1
		self:DoLock( true )
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
		self:EmitSound("buttons/lightswitch2.wav", 30)
	end
end

function SWEP:SecondaryAttack()
	if self.UseDel < CurTime() then
		self.UseDel = CurTime() + 1
		self:DoLock( false )
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
		self:EmitSound("buttons/lightswitch2.wav", 30)
	end
end

function SWEP:DoTrace()
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 10000)
	trace.filter = { self.Owner, self.Weapon }
	local tr = util.TraceLine( trace )
	
	return tr
end

function SWEP:Reload()

	if self.UseDel < CurTime() then
		self.UseDel = CurTime() + 1
		local tr = self:DoTrace()
		
		local dist = tr.HitPos:Distance( self.Owner:GetPos() )
		
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
		self:EmitSound("buttons/lightswitch2.wav", 30)		
		
		if tr.Hit and dist > 300 then
		

		
			if not(string.find( tr.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
			if string.find( tr.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( tr.Entity:GetClass( ), "sent_sakarias_carwheel_punked" ) or tr.Entity.IsDestroyed == 1 then return false end

			local scar = tr.Entity
			
			if (SERVER) and scar:PlayerCanUseLock(self.Owner) and !scar:HasDriver() then
			
			local ai = SCarAiHandler:GetAiByName( "Follow Player Car Keys" )
			local ply = self:GetOwner()
			
			if ai == nil then return false end
			
				local AiEnt = ents.Create( "sent_aiscarcontroller" )
				AiEnt:SetColor(Color(0,0,0,0))
				AiEnt:SetNoDraw( true )
				AiEnt:SetPos( tr.HitPos )
				AiEnt:SetAngles( tr.HitNormal:Angle() )
				AiEnt.SpawnedBy = ply
				
				
				ai.Owner = AiEnt 
				ai.SpawnedBy = ply
				
				AiEnt:Spawn()
				AiEnt:ConnectToCar( scar )
				AiEnt:SetAI( ai )
			end
		end
	end
end


function SWEP:DoLock( lockUnLock )

	local tr = self:DoTrace()
	
	if tr.Hit then
		if not(string.find( tr.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
		if string.find( tr.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( tr.Entity:GetClass( ), "sent_sakarias_carwheel_punked" ) or tr.Entity.IsDestroyed == 1 then return false end

		local scar = tr.Entity
		
		if (SERVER) and scar:PlayerCanUseLock(self.Owner ) then
		
			if lockUnLock == true then
				scar:Lock( true )
			else
				scar:UnLock( true )
			end
		end
	end
end
----------------------------HOLSTER
function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW ) 
	return true
end

SWEP.Primary.Delay				= 0
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= 0
SWEP.Primary.NumShots			= 0
SWEP.Primary.Cone				= 0	
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= true
SWEP.Primary.Ammo         		= "none"
SWEP.Secondary.Delay			= 0
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 0
SWEP.Secondary.NumShots			= 0
SWEP.Secondary.Cone		  		= 0
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic   		= true
SWEP.Secondary.Ammo         	= "none"