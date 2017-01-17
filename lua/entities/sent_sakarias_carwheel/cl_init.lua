include("shared.lua")


ENT.Heat = 0
ENT.LastSmokeTime = CurTime()
ENT.IsSmoking = false
ENT.WheelSkid = NULL
ENT.HeatLevel = 0

ENT.CollideDelay = CurTime()
ENT.CollideAddTime = 0.5

ENT.HeatLevel = 0
ENT.HeatExplodeLevel = 20
ENT.MinSmokeSpeed = 700
ENT.ShouldSmoke = false

ENT.UpdateHeatDel = CurTime()
ENT.Emitter = nil
ENT.ShouldDraw = true
ENT.vel = Vector(0,0,0)
ENT.velLength = 0
ENT.dot = 0
ENT.pitch = 0

ENT.scar = nil
ENT.val = 0
ENT.particle = nil

function ENT:Initialize()
	self.Emitter=ParticleEmitter(self:GetPos())
	self.WheelSkid = CreateSound(self,"tire/skid.wav")
end



function ENT:Think()

	

	self.vel = self:GetVelocity()
	self.velLength = self.vel:Length()
	
	
	if self.velLength > self.MinSmokeSpeed then
		self.dot = self.vel:GetNormalized():DotProduct( self:GetRight() )

		if (self.dot < -0.5 && self.dot > -0.8) or (self.dot > 0.5 && self.dot < 0.8) then
			self:EmitSmoke()
		end
	end	
	
	self:UpdateSmoke()
	
	--While the tire is skidding we have to adjust the skid sound
	if self.IsSmoking == true then
		self.pitch = self:GetVelocity():Length() / 15
		self.pitch =  math.Clamp( self.pitch, 0, 200 )
		self.WheelSkid:ChangePitch( self.pitch + 50 , 0.1)	
	end		
	
	
end

function ENT:EmitSmoke()
	
	if self:IsColliding() then
		self.LastSmokeTime = CurTime() + 0.2

		if self.IsSmoking == false then
			self.IsSmoking = true

			self.WheelSkid:Play()
			self.WheelSkid:ChangeVolume( 5, 0 )		
		end
	end
	
end


function ENT:UpdateSmoke()

	self.ShouldSmoke = self:GetNetworkedBool("shouldSmoke")

	if self.ShouldSmoke == true then
		self:EmitSmoke()
	end

	if self.UpdateHeatDel < CurTime() then
		
		self.UpdateHeatDel = CurTime() + 0.2
		if self.IsSmoking == true then
			self.HeatLevel = self.HeatLevel + 40 * FrameTime()
		else
			self.HeatLevel = self.HeatLevel - 60 * FrameTime()
		end
		
		self.HeatLevel = math.Clamp( self.HeatLevel, 0, self.HeatExplodeLevel )
	end
	
	
	if (!self:IsColliding() or self.LastSmokeTime < CurTime()) && self.IsSmoking == true then
		self.IsSmoking = false
	end
	
	if self.IsSmoking == false then
		if self.WheelSkid and self.WheelSkid.Stop then
			self.WheelSkid:Stop()
		else
			self:Initialize()
		end
		
	end

end

function ENT:IsColliding()
	return self:GetNetworkedBool("IsColliding")	
end

function ENT:SetDoDraw( draw )

	if draw == false and self.ShouldDraw == true then

		self.ShouldDraw = draw
	elseif draw == true and self.ShouldDraw == false then
		self.ShouldDraw = draw
	end
end

function ENT:Draw()


	if self.ShouldDraw then
		local shouldDrawWheel = self:GetNetworkedBool("shouldDrawTheWheel", false)
		
		if shouldDrawWheel != false then
			self:DrawModel()
		end
		
		if self.IsSmoking == true then
			self.scar = self:GetNetworkedEntity("SCarEnt")
			
			if IsValid(self.scar) then

				self.Emitter = ParticleEmitter( self:GetPos() )
				self.val = (self.HeatLevel / self.HeatExplodeLevel)
			
				self.particle = self.Emitter:Add( "particles/smokey", self:GetPos() + Vector(0, 0, -10))
				self.particle:SetVelocity( self.scar:GetForward() * math.Rand(0, -150))
				self.particle:SetDieTime( 0.5 + self.val * 2)
				self.particle:SetStartAlpha( self.val * 100 )
				self.particle:SetStartSize( math.Rand( 10*self.val, 50*self.val ) )
				self.particle:SetEndSize( math.Rand( 50*self.val, 100*self.val ) )
				self.particle:SetEndAlpha( 0 )
				self.particle:SetRoll( math.Rand( -0.2, 0.2 ) )
				self.particle:SetColor( 255,255,255,255)
				self.particle:SetAirResistance( 5 );	 
				self.Emitter:Finish()
			end
		end
	end
end 

function ENT:OnRemove()
	self.WheelSkid:Stop()
end
