
SWEP.Author   			= "Sakarias88"
SWEP.Contact        	= ""
SWEP.Purpose        	= ""
SWEP.Instructions   	= ""
SWEP.Spawnable      	= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel = Model( "models/weapons/v_slam.mdl" )
SWEP.WorldModel = Model( "models/props_junk/gascan001a.mdl" )

SWEP.DoAnim = false

if ( SERVER ) then 
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
else
	SWEP.PrintName			= "SCar fuel"			
	SWEP.Author				= "Sakarias88"
	SWEP.Category			= "SCars"
	SWEP.DrawCrosshair 		= true
	SWEP.DrawAmmo			= true
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.ViewModelFOV		= 10
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/scarrefuel")
end

SWEP.Primary.Delay				= 0.2
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= 1
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone				= 0.2	
SWEP.Primary.ClipSize        	= -1
SWEP.Primary.DefaultClip    	= -1
SWEP.Primary.Automatic        	= true
SWEP.Primary.Ammo            	= "none"
SWEP.Secondary.Delay			= 0
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 0
SWEP.Secondary.NumShots			= 0
SWEP.Secondary.Cone		  		= 0
SWEP.Secondary.ClipSize        	= -1
SWEP.Secondary.DefaultClip   	= -1
SWEP.Secondary.Automatic    	= false
SWEP.Secondary.Ammo            	= "none"


SWEP.UseDel = CurTime()
SWEP.DripSound = NULL

SWEP.RegenDel = CurTime()
SWEP.UpdateTargetDel = CurTime()
SWEP.Target = nil

function SWEP:Initialize()
	self.DripSound = CreateSound(self.Weapon,"ambient/water/leak_1.wav")	

    self:InstallDataTable()
   	self:DTVar( "Float", 0, "Fuel" )
	
	self:SetWeaponHoldType( "smg" )
	if SERVER then
		self.dt.Fuel = 100;
	end
	
	if (CLIENT) then
		self:SetModelScale(0.7, 0)
	end
end

function SWEP:GetTarget()

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 70)
	trace.filter = { self.Owner, self.Weapon }
	local tr = util.TraceLine( trace )
	
	if !tr.Hit or not(string.find( tr.Entity:GetClass( ), "sent_sakarias_car" )) or string.find( tr.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( tr.Entity:GetClass( ), "sent_sakarias_carwheel_punked" ) or tr.Entity.IsDestroyed == 1 then return nil end	
	

	return tr.Entity
end

SWEP.OldFuel = 100
SWEP.CheckFuelDel = 0
SWEP.CanDoFuel = false
function SWEP:Think()

	if self.UpdateTargetDel < CurTime() and self.Owner:KeyDown( IN_ATTACK ) then
		self.Target = self:GetTarget()
		self.UpdateTargetDel = CurTime() + 0.5
	end


	if CLIENT then
	
		if self.CheckFuelDel < CurTime() then
			self.CheckFuelDel = CurTime() + 0.5
			
			if self.dt.Fuel < self.OldFuel then
				self.CanDoFuel = true
			else
				self.CanDoFuel = false
			end
			self.OldFuel = self.dt.Fuel
		end
	
		if self.Owner:KeyDown( IN_ATTACK ) and self.dt.Fuel > 0 and self.Target and self.CanDoFuel then
		
			if self.DoAnim == false then
				self.DripSound:Play()
			end
			
			self.DoAnim = true	
			
			self.DripSound:ChangePitch( 80 +  (1 - (self.dt.Fuel * 0.01)) * 40 , 0.1)
		
			
		else
			if self.DoAnim == true then
				self.DripSound:Stop()
			end
			
			self.DoAnim = false
		end
	end



	if( SERVER ) then
		if self.RegenDel < CurTime() then
			self.dt.Fuel = math.min( 100, self.dt.Fuel + 1 )
			self.RegenDel = self.RegenDel + 1
		end
	end
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.02 )
	
	if (SERVER) and self.Target then
	
		if self.Target.Fuel >= self.Target.MaxFuel then
			self.Target = nil
			return
		end
	
		self.RegenDel = CurTime() + 1
		
		if self.dt.Fuel > 0 then
			self:TakePrimaryAmmo( 0.4 )
		end
		
		self.Target.Fuel = self.Target.Fuel + 30
		self.Target.Fuel = math.Clamp(self.Target.Fuel,0,self.Target.MaxFuel)
	end
end

function SWEP:Holster()
	self.DoAnim = false
	self.DripSound:Stop()
	return true
end

function SWEP:Deploy()
	return true
end

if (CLIENT) then
function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 

	self.AmmoDisplay.Draw            = true;
	self.AmmoDisplay.PrimaryClip      = self.dt.Fuel;
	self.AmmoDisplay.PrimaryAmmo      = -1;
	self.AmmoDisplay.SecondaryClip    = -1;
	self.AmmoDisplay.SecondaryAmmo    = -1;
 
	return self.AmmoDisplay
end
end

if (SERVER) then
function SWEP:TakePrimaryAmmo( ammo )
	self.dt.Fuel = math.max( 0, self.dt.Fuel - ammo );
end
end