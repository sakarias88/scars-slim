include("shared.lua")

local matFire            = Material( "effects/fire_cloud1" )
local matHeatWave        = Material( "sprites/heatwave" )
local matLight           = Material( "SCarMisc/lightBeam" )


ENT.RenderGroup 		= RENDERGROUP_BOTH


ENT.Emitter = NULL;

ENT.TempPos = NULL
ENT.TempParticle = NULL

ENT.TurboStageOn = 0
ENT.TurboFadeDelay = CurTime()
ENT.TurboFadeAddDelay = 0.5

ENT.LightCol = Color(0,0,0,0)
ENT.LightState = 0


ENT.Swish = NULL
ENT.LastAng = Angle(0,0,0)
ENT.CurAng = Angle(0,0,0)
ENT.curDiff = Angle(0,0,0)
ENT.AngDiff = 0
ENT.StartP = 20
ENT.addP = 150
ENT.addV = 6
ENT.CurVol = 0
ENT.SwishPercent = 0
ENT.ShouldDraw = true
ENT.FrontLightCol = Color(0,0,0)


ENT.NeonStayTime = 0
ENT.NeonFadeTime = 0
ENT.NeonCol1 = Color(0,0,0,0)
ENT.NeonCol2 = Color(0,0,0,0)
ENT.NeonSize = 150

ENT.NeonStage = 0
ENT.NeonDelay = 0

ENT.NeonPer = 0
ENT.NeonInvPer = 0
ENT.NeonLight = nil

ENT.CheckMaterialDelay = 0
ENT.CheckMaterialTime = 2

function ENT:Setup()
	self:SetPredictable( false )
	self.Emitter=ParticleEmitter(self:GetPos())
	

	local mx, mn = self:GetRenderBounds()
	self:SetRenderBounds( mn + Vector(0,0,128), mx, 0 )	
	
	self.Seed = math.Rand( 0, 10000 )
	
	if !self.FrontLightColor then
		self.FrontLightColor = "220 220 160" --RGB
	end	
	
	local expl = string.Explode( " ", self.FrontLightColor )
	self.LightCol.r = expl[1]
	self.LightCol.g = expl[2]
	self.LightCol.b = expl[3]
	
	self.Swish   = CreateSound(self,"weapons/iceaxe/iceaxe_swing1.wav")	
	self.LastAng = self:GetAngles()
	
	
	if !self.FrontLightColor then
		self.FrontLightColor = "220 220 160" --RGB
	end	
	
	local expl = string.Explode(" ", self.FrontLightColor)
	self.FrontLightCol = Color(expl[1],expl[2],expl[3],150)
end

function ENT:Cl_BaseThink()

	if self.SpecialThink then
		self:SpecialThink()
	end

	if self:GetNetworkedBool( "SCarIsOn" ) then
		--[[
		--Test code for adding special effects depending on the surface properties
		if SCarClientData["scar_adapteffects"] and self.CheckMaterialDelay < CurTime() then
			self.CheckMaterialDelay = CurTime() + self.CheckMaterialTime
			local traceData = {}
			traceData.start = self:GetPos() + Vector(0,0,500)
			traceData.start.z = LocalPlayer():GetPos().z
			traceData.endpos = traceData.start - Vector(0,0,5000)
			traceData.filter = self.Entity
			local trace = util.TraceLine(traceData)
			local MatType = trace.MatType 
			
			if trace.Hit and IsValid(trace.Entity) then
				Msg("Class: "..trace.Entity:GetClass().."\n")
			end
			
			Msg("MatType: "..MatType.."\n")
		end	
		--]]
		
		if	SCarClientData["scar_swosheffect"] == true then
			self.CurAng = self:GetAngles()
			self.curDiff = self.CurAng:Up() - self.LastAng:Up()
			self.curDiff = self.curDiff / FrameTime()
			self.AngDiff = self.curDiff:Length() * 0.6
			self.LastAng = self.CurAng

			if self.AngDiff > 1.5 then
				self.AngDiff = (self.AngDiff-1.5) / 30
				self.AngDiff = math.Clamp(self.AngDiff,0,1)
				if !self.Swish:IsPlaying() then
					self.Swish:Play()
				end
				self.Swish:ChangePitch( self.StartP + self.addP * self.AngDiff , 0.1)
				
				self.CurVol =  self.AngDiff * self.addV
				self.CurVol = math.Clamp(self.CurVol,0,1)
				self.Swish:ChangeVolume( self.CurVol, 0 )
			elseif self.Swish:IsPlaying() then
				self.Swish:Stop()
			end
		end
		self.Emitter = ParticleEmitter( self:GetPos() )
		for i = 1, self.NrOfExhausts do
			
			self.TempPos = self:GetPos() + self:GetForward() * self.ExhaustPos[i].x + self:GetRight() * self.ExhaustPos[i].y + self:GetUp() * self.ExhaustPos[i].z
			self.TempParticle = self.Emitter:Add( "particles/smokey", self.TempPos )
			self.TempParticle:SetVelocity( self:GetForward() * math.Rand(0, -50) + Vector(math.Rand(10, -10),math.Rand(10, -10),math.Rand(10, -10)) + self:GetVelocity() )
			self.TempParticle:SetDieTime( 0.5 )
			self.TempParticle:SetStartAlpha( 50 )
			self.TempParticle:SetStartSize( 1 )
			self.TempParticle:SetEndSize( 5 )
			self.TempParticle:SetEndAlpha( 0 )
			self.TempParticle:SetRoll( math.Rand( -0.2, 0.2 ) )
			self.TempParticle:SetColor( 150, 150, 150, 255 )
			
		end
		self.Emitter:Finish()
	end
	
	self:SetNetworkedBool( "FadeChange", true)
end

function ENT:Think()
	self:Cl_BaseThink()
end


function ENT:SetDoDraw( draw )

	if draw == false and self.ShouldDraw == true then
		for i = 1, self.NrOfWheels do
			local wheel = self:GetNetworkedEntity("SCarWheel"..i)
			
			if IsValid(wheel) then
				wheel:SetDoDraw( false )
			end
		end
		self.ShouldDraw = draw
	elseif draw == true and self.ShouldDraw == false then
		for i = 1, self.NrOfWheels do
			local wheel = self:GetNetworkedEntity("SCarWheel"..i)
			if IsValid(wheel) then
				wheel:SetDoDraw( true )
			end
		end	
		self.ShouldDraw = draw
	end
end

function ENT:Cl_BaseDraw()

	if self.ShouldDraw then
		self:DrawModel()
		if self:GetNetworkedBool( "SCarIsOn" ) && self:GetNetworkedBool( "SCarTurboIsOn" ) && self.TurboStageOn == 0 then
			self.TurboStageOn = 1
			self.TurboFadeDelay = CurTime() + self.TurboFadeAddDelay
		elseif !self:GetNetworkedBool( "SCarTurboIsOn" ) && self.TurboStageOn == 1 then
			self.TurboStageOn = 2
			self.TurboFadeDelay = CurTime() + self.TurboFadeAddDelay
		elseif self.TurboStageOn == 2 && self.TurboFadeDelay < CurTime() then
			self.TurboStageOn = 0
		end

		if self.TurboStageOn == 1 or self.TurboStageOn == 2 then
		
			local per = ((self.TurboFadeDelay - CurTime()) / self.TurboFadeAddDelay)
			if self.TurboStageOn == 1 then
				per = 1 - per
			end
			per = math.Clamp(per, 0, 1)
			
			

			local vNormal = self:GetForward() * -1
			local scroll = self.Seed + (CurTime() * -10)
			local Scale = self:GetVelocity():Length()
			Scale = Scale / 500
			Scale = math.Clamp(Scale, 0, 1) * per
			
			for i = 1, self.NrOfExhausts do
			
				local vOffset = self:GetPos() + self:GetForward() * self.ExhaustPos[i].x + self:GetRight() * self.ExhaustPos[i].y + self:GetUp() * self.ExhaustPos[i].z
				
			
				render.SetMaterial( matFire )
				render.StartBeam( 3 )
					render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
					render.AddBeam( vOffset + vNormal * 15 * Scale, 8 * Scale, scroll + 1, Color( 255, 255, 255, 128) )
					render.AddBeam( vOffset + vNormal * 37 * Scale, 8 * Scale, scroll + 3, Color( 255, 255, 255, 0) )
				render.EndBeam()
				
				scroll = scroll * 0.5
				
				render.UpdateRefractTexture()
				render.SetMaterial( matHeatWave )
				render.StartBeam( 3 )
					render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
					render.AddBeam( vOffset + vNormal * 8 * Scale, 8 * Scale, scroll + 2, Color( 255, 255, 255, 255) )
					render.AddBeam( vOffset + vNormal * 32 * Scale, 12 * Scale, scroll + 5, Color( 0, 0, 0, 0) )
				render.EndBeam()
				
				scroll = scroll * 1.3

				render.SetMaterial( matFire )
				render.StartBeam( 3 )
					render.AddBeam( vOffset, 8 * Scale, scroll, Color( 0, 0, 255, 128) )
					render.AddBeam( vOffset + vNormal * 15 * Scale, 4 * Scale, scroll + 1, Color( 0, 0, 255, 128) )
					render.AddBeam( vOffset + vNormal * 37 * Scale, 4 * Scale, scroll + 3, Color( 0, 0, 255, 0) )
				render.EndBeam()	
			end
		end

		if self:GetNetworkedBool( "HeadlightsOn" ) then
			local parent = nil
			for i = 1, self.NrOfFrontLights do
				parent = self:GetNetworkedEntity( "SCar_CL_FrontLightParent_"..i)
				
				if !IsValid(parent) then
					parent = self
				end
				
				local pos = parent:GetPos() + parent:GetForward() * self.FrontLightsPos[i].x + parent:GetRight() * self.FrontLightsPos[i].y + parent:GetUp() * self.FrontLightsPos[i].z

				local viewdiff = (pos-EyePos())
				local viewdir = viewdiff:GetNormal()
				local dot = parent:GetRight():Dot(EyeVector())
				
				if dot < 0 then dot = -dot end
				
				render.SetMaterial( matLight )
				render.DrawBeam( pos, pos + parent:GetForward() * 200, 130, 1, 0.01, Color( self.LightCol.r, self.LightCol.g, self.LightCol.b, 20 * dot ) )
			end
		end		
		
		if self:GetNetworkedBool( "SCarIsOn" ) then


			
			----Neon lights
			self.NeonStayTime = self:GetNetworkedFloat( "NeonStayTime" )
			self.NeonFadeTime = self:GetNetworkedFloat( "NeonFadeTime" )
			self.NeonSize = self:GetNetworkedFloat( "NeonSize" )
			
			if (self.NeonStayTime > 0 or self.NeonFadeTime > 0) and self.NeonSize > 0 then

				self.NeonCol1.r = self:GetNetworkedFloat( "NeonCol1r" )
				self.NeonCol1.g = self:GetNetworkedFloat( "NeonCol1g" )
				self.NeonCol1.b = self:GetNetworkedFloat( "NeonCol1b" )

				self.NeonCol2.r = self:GetNetworkedFloat( "NeonCol2r" )
				self.NeonCol2.g = self:GetNetworkedFloat( "NeonCol2g" )
				self.NeonCol2.b = self:GetNetworkedFloat( "NeonCol2b" )

				
				if self.NeonDelay < CurTime() then
					self.NeonStage = self.NeonStage + 1
					
					if self.NeonStage > 3 then self.NeonStage = 0 end
					
					if self.NeonStage == 0 or self.NeonStage == 2 then
						self.NeonDelay = CurTime() + self.NeonStayTime
					else
						self.NeonDelay = CurTime() + self.NeonFadeTime
					end
				end


		
				if self.NeonStage == 0 then
					self.NeonPer = 1
					self.NeonInvPer = 0				
				else
					self.NeonPer = 0
					self.NeonInvPer = 1				
				end
		
				if self.NeonStage == 1 or self.NeonStage == 3 then
					self.NeonPer = (self.NeonDelay - CurTime()) / self.NeonFadeTime
					if self.NeonStage == 3 then
						self.NeonPer = 1 - self.NeonPer
					end
				end

				self.NeonInvPer = 1 - self.NeonPer

				self.NeonLight = DynamicLight( self:EntIndex() )
				self.NeonLight.Pos = self:GetPos()			
				self.NeonLight.r = self.NeonCol1.r * self.NeonPer + self.NeonCol2.r * self.NeonInvPer
				self.NeonLight.g = self.NeonCol1.g * self.NeonPer + self.NeonCol2.g * self.NeonInvPer
				self.NeonLight.b = self.NeonCol1.b * self.NeonPer + self.NeonCol2.b * self.NeonInvPer
				self.NeonLight.Brightness = 4
				self.NeonLight.Size = self.NeonSize
				self.NeonLight.Decay = 500
				self.NeonLight.DieTime = CurTime() + 0.2	
		
			end			
				
			
		end
		
		if self.SpecialDraw then
			self:SpecialDraw()
		end
	end
end

function ENT:Draw()
	self:Cl_BaseDraw()
end

--I know this might look weird setting them on clientside but this fixes some things when saving the car.
function ENT:PrepareCarForSave()
	self:SetNetworkedBool( "SCarIsOn", false ) 
	self:SetNetworkedBool( "HeadlightsOn", false ) 	
	self:SetNetworkedBool( "SCarTurboIsOn", false )
end

function ENT:OnRemove()
	if self.SpecialRemove then
		self:SpecialRemove()
	end	
end

function ENT:GetVehicleHealth()
	return self:GetNetworkedFloat( "VehicleHealth" )
end