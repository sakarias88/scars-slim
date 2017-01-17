AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


ENT.SpawnedBy = NULL
ENT.MaxHealth = 50
ENT.WheelHealth = 50

ENT.Rim = NULL
ENT.CanTakeDamage = 1
ENT.Owner = NULL
ENT.TireModel = nil

ENT.CollideDelay = CurTime()
ENT.CollideAddTime = 0.5

ENT.DecoyWheel = NULL
ENT.IsDestroyed = false
ENT.IsFlat = false

ENT.IsSmoking = false
ENT.LastSmokeTime = CurTime()
ENT.DmgHitPos = NULL

ENT.CollisionDetected = false
ENT.ColDelay = CurTime()
------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )

 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos ) 		
	ent:SetTrigger( true )
	self.SpawnedBy = ply
 	ent:Spawn()
 	ent:Activate()
	return ent 
	
end

function ENT:Initialize()

	if !self.TireModel then
		self.TireModel = "models/Splayn/chevy66_wheel.mdl"
	end

	self:SetModel( self.TireModel )
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	--//Sphere code
	--local radi = self:OBBMaxs().y - self:OBBMins().y
	--self:PhysicsInitSphere(radi)
	--self:SetCollisionBounds(Vector(-radi,-radi,-radi),Vector(radi,radi,radi))	
	--//		
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	
	
	
	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then 
		phys:Wake() 
		phys:SetMass(15)
		phys:EnableDrag(false)
	end
	
	construct.SetPhysProp( self.SpawnedBy,  self, 0, nil, { GravityToggle = 1, Material = "jeeptire" })
	self.WheelHealth = self.MaxHealth 

	if IsValid(self.SCarOwner) && (self.Steer == 1 or self.Steer == -1) then
		self.DecoyWheel = ents.Create( "prop_physics" )
		self.DecoyWheel:SetModel(self.TireModel)	
		self.DecoyWheel:Spawn()	
		self.DecoyWheel:Activate()
		self.DecoyWheel:SetParent( self )
		self.DecoyWheel:SetLocalPos(Vector(0,0,0))
		self.DecoyWheel:SetLocalAngles( Angle(0,0,0) )	
		self.DecoyWheel:SetNotSolid( true )
		self.DecoyWheel:SetColor(Color(0,0,0,0))
		
		self.ColDelay = CurTime() + 1
		
		local effectdata = EffectData()
		effectdata:SetEntity( self.DecoyWheel )
		util.Effect( "carspawn", effectdata, true, true )	
		
		self:SetNetworkedBool("shouldDrawTheWheel", false)
	else
		local effectdata = EffectData()
		effectdata:SetEntity( self )
		util.Effect( "carspawn", effectdata, true, true )		
	
		self:SetNetworkedBool("shouldDrawTheWheel", true)
	end


	self:SetNetworkedBool( "IsColliding", false )
end

function ENT:SetCanTakeDamage( CanTakeDamage )
	self.CanTakeDamage = CanTakeDamage
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
	
	if !IsValid(self.Rim) then
		self.CollideDelay = CurTime() + self.CollideAddTime
	end

end


function ENT:PhysicsUpdate( phys )

	--Rotating the decoy wheel
	if self.IsDestroyed == false && (self.Steer == 1 or self.Steer == -1) && IsValid(self.SCarOwner) && IsValid(self.DecoyWheel) then
		local moveAng = 45 * (self.SCarOwner.RealSteerForce / self.SCarOwner.SteerForce)
		if self.Steer == -1 then moveAng = moveAng * -1 end
		local ang = self:GetAngles()
		ang:RotateAroundAxis( self.SCarOwner:GetUp() , moveAng )
		self.DecoyWheel:SetAngles( ang )
	end
end

-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)
	if self.IsDestroyed == false && self.CanTakeDamage == 1  then
		local attacker = dmg:GetAttacker( )
		
		local Damage = dmg:GetDamage()
		self.WheelHealth = self.WheelHealth - Damage
		
		self.DmgHitPos = dmg:GetDamagePosition()
	end
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

	
		--The tire is destroyed
		if self.CanTakeDamage == 1 && self.WheelHealth <= 0 && self.IsDestroyed == false  then
		
			self.IsDestroyed = true
			
			if self.Rim != NULL && IsValid(self.Rim) then
				self.Rim.IsDestroyed = true
				self.Rim:SetNetworkedBool( "IsColliding", false )
			end
			
			if IsValid(self.SCarOwner) && self.WheelID && self.WheelID != NULL && self.WheelID != nil then		
				if self.SCarOwner.HandBrakeConstraints[self.WheelID] && self.SCarOwner.HandBrakeConstraints[self.WheelID] != NULL then
					self.SCarOwner.HandBrakeConstraints[self.WheelID]:Remove()
				end			

				if self.SCarOwner.WheelAxis[self.WheelID] && self.SCarOwner.WheelAxis[self.WheelID] != NULL then
					self.SCarOwner.WheelAxis[self.WheelID]:Remove()
				end	
			end	

			if IsValid(self.DecoyWheel) then
				self.DecoyWheel:SetLocalAngles( Angle(0,0,0) )
			end		
		end
		
		self:UpdateSmoke()


		if self.CanTakeDamage == 1 && ((self.MaxHealth > self.WheelHealth) && self.IsFlat == false) then
			self.IsFlat = true
			
			self:SetNetworkedBool( "shouldSmoke", false )

			local pos = self:GetPos()
			
			if self.DmgHitPos != NULL then
				pos = self.DmgHitPos
			end			
			
			local effectdata = EffectData()
			effectdata:SetStart( pos )
			effectdata:SetOrigin( pos )
			util.Effect( "GlassImpact", effectdata )			
			
			self:EmitSound("tire/flatTire.wav", 70,math.random(50,150))	
			
			self:SetNotSolid( true )

			local oldAng = self:GetAngles()
			local oldPos = self:GetPos()
			local oldCarAng = self.SCarOwner:GetAngles()
			local oldVel = self:GetPhysicsObject():GetVelocity()
			local oldAngVel = self:GetPhysicsObject():GetAngleVelocity()
			local oldCarVel = self.SCarOwner:GetPhysicsObject():GetVelocity()
			local oldCarAngVel = self.SCarOwner:GetPhysicsObject():GetAngleVelocity()
			
			self:SetAngles(Angle(0,0,0))
			self.SCarOwner:SetAngles(Angle(0,0,0))
			
			--Spawning rim
			self.Rim = ents.Create( "sent_sakarias_carwheel_punked" )		
			self.Rim:SetOwner( self.Owner )	
			self.Rim.SCarOwner = self.SCarOwner
			self.Rim.OwnerEnt = self
			self.Rim.IsDestroyed = self.IsDestroyed
			self.Rim.WheelID = self.WheelID
			self.Rim:Spawn()
			self.Rim:Activate()
			self.Rim:GetPhysicsObject():SetMass( self:GetPhysicsObject():GetMass() )
			self.Rim:SetCarOwner( self.SpawnedBy )
			

			if self.IsDestroyed == false then
				self.Rim:SetPos( self.SCarOwner:GetPos() + (self.SCarOwner:GetForward() * self.Pos.x) + (self.SCarOwner:GetRight() * self.Pos.y) + (self.SCarOwner:GetUp() * (self.Pos.z+self.AddHeight)))
			
				if self.Side == false then
					self.Rim:SetAngles( self.SCarOwner:GetAngles() + Angle(0,180,0)+ Angle(0,90,0) )
					self.SCarOwner.WheelAxis[self.WheelID] = constraint.Axis( self.Rim, self.SCarOwner, 0, 0, Vector(0,1,0) , self.Pos, 0, 0, 0, 0 )
				else
					self.Rim:SetAngles( self.SCarOwner:GetAngles() + Angle(0,90,0) )
					self.SCarOwner.WheelAxis[self.WheelID] = constraint.Axis( self.Rim, self.SCarOwner, 0, 0, Vector(0,-1,0) , self.Pos, 0, 0, 0, 0 )
				end	
			end
		
			oldAng:RotateAroundAxis(oldAng:Up(), 90)
			self.Rim:SetAngles(oldAng)
			self.Rim:SetPos(oldPos)
			self.SCarOwner:SetAngles(oldCarAng)
			self:SetParent(self.Rim)
			self:GetPhysicsObject():EnableMotion(true)
			self:SetLocalAngles( Angle(0,270,0) )
			self.Rim:GetPhysicsObject():SetVelocity(oldVel)
			self.Rim:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity() * -1 + oldAngVel)
			self:GetPhysicsObject():SetVelocity(oldVel)
			self:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity() * -1 + oldAngVel)
			self.SCarOwner:GetPhysicsObject():SetVelocity(oldCarVel)
			self.SCarOwner:GetPhysicsObject():AddAngleVelocity( self.SCarOwner:GetPhysicsObject():GetAngleVelocity() * -1 + oldCarAngVel)

		
			
			if IsValid(self.DecoyWheel) then
				self.DecoyWheel:SetLocalAngles( Angle(0,0,0) )
			end
		
			if IsValid( self.SCarOwner ) then
				constraint.NoCollide( self.SCarOwner, self.Rim, 0, 0 )
			end
		
			self.Rim:SetCarOwner( self.SpawnedBy )
			self:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )			
		end
		
		if self.ColDelay < CurTime() and IsValid(self.DecoyWheel) then
			self.ColDelay = CurTime() + 1
			if self.DecoyWheel:GetMaterial() != self:GetMaterial() then
				self.DecoyWheel:SetMaterial( self:GetMaterial() )
			end
			
			if self.DecoyWheel:GetSkin() != self:GetSkin() then
				self.DecoyWheel:SetSkin( self:GetSkin() )
			end
						
			self.DecoyWheel:SetColor(self:GetColor())
		end	
	end
end

-------------------------------------------ON REMOVE
function ENT:OnRemove()

	if self.DecoyWheel and IsValid(self.DecoyWheel) then
		self.DecoyWheel:Remove()
	end

	if IsValid(self.Rim) then
		self.Rim:Remove()
	end
	
end

function ENT:IsColliding()

	if IsValid(self.Rim) then
		return self.Rim:IsColliding()
	end

	if self.CollideDelay > CurTime() then
		return true
	end
	
	return false
end

function ENT:UpdateSmoke()

	if self.IsFlat == false then
		if (!self:IsColliding() or self.LastSmokeTime < CurTime()) && self.IsSmoking == true then
			self.IsSmoking = false
			self:SetNetworkedBool( "shouldSmoke", false )
		end
	end
end

function ENT:EmitSmoke()
	
	if self:IsColliding() then
		self.LastSmokeTime = CurTime() + 0.2
		
		if self.IsSmoking == false && self.IsFlat == false then
			self.IsSmoking = true
			self:SetNetworkedBool( "shouldSmoke", true )	
		end
	end
	
	if self.Rim != NULL && IsValid(self.Rim) then
		self.Rim:EmitSparkles()
	end
end

function ENT:GiveDamage( damage, attacker )
	if self.IsDestroyed == false && self.CanTakeDamage == 1  then
		if !IsValid(self.SCarOwner) or IsValid(self.SCarOwner) && (self.SCarOwner:GetDriver():IsPlayer() && attacker != self.SCarOwner:GetDriver() or !self.SCarOwner:GetDriver():IsPlayer()) then
			self.WheelHealth = self.WheelHealth - damage
		end
		
	end
end

--When a new player joins the server we will have to recreate all sounds or they won't hear them
function ENT:RecreateWheelSounds()
	if self.Rim != NULL && IsValid(self.Rim) then
		self.Rim:RecreateWheelSounds()
	end
end

function ENT:ApplySpinForce( force )
	if self.IsFlat == false then
		self:GetPhysicsObject():AddAngleVelocity( Vector(0, force , 0 ) )
	elseif self.Rim != NULL && IsValid(self.Rim) then
		self.Rim:GetPhysicsObject():AddAngleVelocity( Vector(force * 2, 0, 0 ) )
	end
end

function ENT:ChangeOneWheel( model, physMat, useOldPos)
	if self.IsDestroyed == false && self.SCarOwner != NULL && IsValid(self.SCarOwner) then
		self.SCarOwner:ChangeOneWheel( self.WheelID, model, physMat, useOldPos)
	end
end

function ENT:ApplyTurnForce( vecForce )
	if self.WheelHealth > 0 then
		if self.IsFlat == false then
			self:GetPhysicsObject():ApplyForceCenter( vecForce )
		elseif self.Rim != NULL && IsValid(self.Rim) then
			self.Rim:GetPhysicsObject():ApplyForceCenter( vecForce )
		end
	end
end

function ENT:SetCarOwner( ply )
	SCarSetObjOwner( ply, self, true )
	if self.Rim and self.Rim != NULL then SCarSetObjOwner( ply, self.Rim, true ) end
end