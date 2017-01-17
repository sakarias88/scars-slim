SWEP.Author   			= "Sakarias88"
SWEP.Contact        	= ""
SWEP.Purpose        	= ""
SWEP.Instructions   	= ""
SWEP.Spawnable      	= true
SWEP.AdminSpawnable 	= true


SWEP.ViewModel = Model( "models/weapons/v_grenade.mdl" )
SWEP.WorldModel = Model( "models/props_c17/tools_wrench01a.mdl" )

if ( SERVER ) then 
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
else
	SWEP.PrintName			= "SCar repair"			
	SWEP.Author				= "Sakarias88"
	SWEP.Category			= "SCars"
	SWEP.DrawCrosshair 		= true
	SWEP.DrawAmmo			= false
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 60
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/scarrepair")
end

SWEP.UseDel = CurTime()

function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" )
end


function SWEP:PrimaryAttack()
	if self.UseDel < CurTime() then
		self.UseDel = CurTime() + 2
		
		
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Owner:DoAttackEvent( )	
		if (SERVER) then
			local tool = ents.Create( "sent_Sakarias_RepairStationTool" )	
			tool:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 10)
			tool:SetAngles(self.Owner:EyeAngles())
			tool:Spawn()
			tool:SetOwner( self.Owner )
			tool:Fire("kill", "", 5)
			tool:GetPhysicsObject():ApplyForceCenter( self.Owner:GetVelocity() + self.Owner:GetAimVector() * 5000)
			tool:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)))		
			tool:GetPhysicsObject():SetMass(1)

			self.Weapon:EmitSound("weapons/slam/throw.wav", 100, math.random(90,110) )
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW ) 
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