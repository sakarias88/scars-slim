AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Seats = {}
ENT.SeatWelds = {}
ENT.Wheels = {}
ENT.WheelAxis = {}
ENT.HandBrakeConstraints = {}

ENT.WheelsPhys = {}
ENT.WheelsModel = {}
ENT.WheelsHeight = {}
ENT.TurningWheels = {}
ENT.NrOfTurningWheels = 0
ENT.TorqueWheels = {}
ENT.NrOfTorqueWheels = 0

--//Car specifications
ENT.MaxSpeed = 1500
ENT.Acceleration = 3000

ENT.SteerForce = 5
ENT.SteerResponse = 0.3
ENT.RealSteerForce = 0
ENT.MaxSteerForce = 0

ENT.BreakForce = 2000

ENT.ReverseForce = 1000
ENT.ReverseMaxSpeed = 200



ENT.NrOfGears = 5

ENT.SoftnesFront = 0
ENT.SoftnesRear = 0
ENT.DefaultSoftnesFront = 20
ENT.DefaultSoftnesRear = 20

ENT.HeightFront = 0
ENT.HeightRear = 0

ENT.AntiSlide = 10
ENT.AutoStraighten = 0

ENT.HydraulicHeight = 0
ENT.HydraulicActive = 0

ENT.Stabilisation = 2000

--//Health
ENT.IgnorePhysDamage = 0
ENT.CarHealth = 200
ENT.CarMaxHealth = 200
ENT.DamageLevel = 0
ENT.TakeHealthDel = CurTime()
ENT.CanTakeDamage = 1
ENT.CanTakeWheelDamage = 1

--//Gear
ENT.Gear = 1
ENT.OldGear = 1
ENT.ChangeGearDel = CurTime()

--//Engine sound
ENT.Pitch = 0
ENT.RealPitch = 0
ENT.RevScale = 0

--//Fuel
ENT.Fuel = 20000
ENT.FuelPercent = 1
ENT.MaxFuel = 20000
ENT.FuelConsumption = 2
ENT.UsesFuelConsumption = 1
ENT.UpdateFuelDel = CurTime()

--//Lights
ENT.FrontLights = {}
ENT.FrontLightsCentre = {}
ENT.FrontLightsRt = {}
ENT.RearLights = {}
ENT.IncreaseRearLightCol = 0
ENT.IncreaseFrontLightCol = false
ENT.switchLightDelay = CurTime()

--//Status
ENT.DriveStatus = 0
ENT.DriveActionStatus = 0
ENT.HandBrake = false
ENT.HandBrakeDel = CurTime()
ENT.IsOn = false
ENT.AutoTurnOn = false
ENT.AboutToTurnOn = false
ENT.TurnStatus = 0

ENT.UsingBrake = false
ENT.GearIsNeutral = false
ENT.EngineIsRevving = false
ENT.DoRepair = false
ENT.IsBurningOut = false
ENT.BurnOutLockedWheels = false
ENT.CarIsLocked = false
ENT.Throttle = 1

--//Sounds
ENT.TurnOnSoundDir = "car/engineStart.wav"
ENT.TurnOffSoundDir = "vehicles/v8/v8_stop1.wav"
ENT.TurboStartSoundDir = "car/nosstart.wav"
ENT.TurboOffSoundDir = "car/nosstop.wav"
ENT.TurboOngoingSoundDir = ""
ENT.StartSound   = NULL
ENT.OffSound   = NULL	
ENT.Skid = NULL
ENT.TurboStartSound = NULL
ENT.TurboStopSound = NULL
ENT.FireSound = NULL
ENT.Horn = NULL
ENT.HornSound = "scarhorns/horn 1.wav"
ENT.HornDelay = 0

--//Stabilizer
ENT.StabilizerProp = NULL
ENT.StabilizerConstaint = NULL
ENT.Stabilisation = 2000
ENT.FlipDelay = CurTime()
ENT.FlipPos = Vector(0,0,0)
ENT.IsFlipping = false

--//Effects
ENT.FireEffect = NULL
ENT.DamageEffect = NULL

--//HydraulicToggles
ENT.HydraulicsToggleSep = {}
ENT.HydraulicsToggle = false
ENT.UsingHydraulics = false


--//Misc
ENT.SaveDamagedCol = Color(255,255,255,255)
ENT.SteerPercent = 0
ENT.OldSteerPercent = 0
ENT.RevPercent = 0
ENT.DriverExited = false
ENT.AcceptedWaterLevel = 1

ENT.ImpactDelay = 0
ENT.IsSaved = false
ENT.physMat = "rubber"
ENT.TurnOnDelay = CurTime()
ENT.AIController = nil
ENT.SwitchViewAddDelay = 1
ENT.SwitchViewDelay = 0
ENT.LastBurnOut = CurTime()
ENT.ReleaseHandbrakeTime = CurTime()
ENT.MaxRev = 150
ENT.MinRev = 40
ENT.GearRevSpace = 250 - (ENT.MaxRev + ENT.MinRev)
ENT.RealMaxRev = ENT.MaxRev + ENT.MinRev + ENT.GearRevSpace
ENT.GearRevChange = 0
ENT.WheelTorqTraction = 0
ENT.WheelTurnTraction = 0
ENT.UpdatePhys = CurTime()
ENT.MaxTurnPercent = 1
ENT.SlowAngVel = false


--Turbo1
ENT.TurboTime = CurTime()
ENT.UseTurbo = CurTime()
ENT.TurboOn = false
ENT.TurboEffect = 2
ENT.TurboDuration = 4
ENT.TurboDelay = 10

--Turbo2
ENT.TurboStartTime = CurTime()
ENT.TurboEndTime = CurTime()


ENT.UsePaceSetter = false
ENT.PaceSetterSpeed = 0
ENT.LastPaceSetterSpeed = 0
ENT.canDoBurnout = true

ENT.RadioName = ""
ENT.RadioURL = ""
ENT.AutoRemoveDel = NULL

--Neon lights
ENT.NeonSize = 150
ENT.NeonFadeTime = 0
ENT.NeonStayTime = 0
ENT.NeonCol1 = Color(0,0,0,0)
ENT.NeonCol2 = Color(0,0,0,0)
ENT.SCarGroup = true

ENT.PhysDT = 0
ENT.PhysLastTime = 0
ENT.StabiliserOffset = Vector(0,0,20)

function ENT:Setup()
	--//Just to be sure.
	self.DefaultSound = string.lower(self.DefaultSound)
	self.CarModel = string.lower(self.CarModel)
	self.TireModel = string.lower(self.TireModel)
	self.HornSound = string.lower(self.HornSound)
	
	self:SetModel(self.CarModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(Color(255,255,255,255))
	self:Activate()
	
    local phys = self:GetPhysicsObject()
	if IsValid(phys) then 
		phys:Wake() 
		phys:SetMass(self.CarMass)
		phys:EnableDrag(false)	
		phys:SetBuoyancyRatio( 0.025 )
	end

	construct.SetPhysProp( self.Owner,  self, 0, nil, { GravityToggle = 1, Material = "metal" })

	self.Seats = {}
	self.SeatWelds = {}
	self.Wheels = {}
	self.WheelAxis = {}
	self.HandBrakeConstraints = {}
	self.FrontLights = {}
	self.FrontLightsCentre = {}
	self.FrontLightsRt = {}
	self.RearLights = {}
	self.HydraulicsToggleSep = {}
	self.HydraulicsToggleSep[1] = false
	self.HydraulicsToggleSep[2] = false
	self.HydraulicsToggleSep[3] = false
	self.HydraulicsToggleSep[4] = false
	self.NoCollideWheelConstraints = {}
	
	self.WheelsPhys = {}
	self.WheelsModel = {}
	self.WheelsHeight = {}
	self.TurningWheels = {}
	self.TorqueWheels = {}	
	
	self:SetNetworkedBool( "SCarIsOn", false )
	self:SetNetworkedBool( "SCarTurboIsOn", false )
	self:SetNetworkedBool( "HeadlightsOn", false )
	self:SetNetworkedInt( "BrakeState", 0 )
	
	if !self.FrontLightColor then
		ply:PrintMessage( HUD_PRINTTALK, "SCAR TEMPLATE ERROR: FrontLightColor not defined. Using default")
		self.FrontLightColor = "220 220 160" --RGB
	end
	
	--//Seats
	for i = 1, self.NrOfSeats do
	
		if self.SeatPos[i] then
			self.Seats[i] = ents.Create("prop_vehicle_prisoner_pod")  
			self.Seats[i]:SetModel( "models/nova/airboat_seat.mdl" ) 
			self.Seats[i]:SetPos( self:GetPos() + (self:GetForward() * self.SeatPos[i].x) + (self:GetRight() * self.SeatPos[i].y) + (self:GetUp() * self.SeatPos[i].z))
			
			local addAng = Angle(0,0,0)
			
			if self.SeatAngOffset and self.SeatAngOffset[i] then
				addAng = self.SeatAngOffset[i]
			end
			
			self.Seats[i]:SetAngles(self:GetAngles() + Angle(0,-90,0) + addAng)
			self.Seats[i]:SetKeyValue("limitview", "0") 
			self.Seats[i]:SetColor(Color(255,255,255,0))

			self.Seats[i]:Spawn()  
			self.Seats[i]:Activate()
			self.Seats[i]:GetPhysicsObject():EnableGravity(false)
			self.Seats[i]:GetPhysicsObject():SetMass(1)
			self.Seats[i]:SetNotSolid( true )
			self.Seats[i]:GetPhysicsObject():EnableDrag(false)	
			self.Seats[i]:DrawShadow( false )
			self.Seats[i]:SetNoDraw( true )
			self.Seats[i].SCarGroup = true
			self.Seats[i].IsScarSeat = true			
			
			self.Seats[i]:SetNetworkedInt("SCarSeat", i)
			self.Seats[i]:SetNetworkedInt("SCarThirdPersonView", 0)
			self.Seats[i]:SetNetworkedEntity("SCarEnt", self)
			
			
			self.Seats[i].EntOwner = self
			self.Seats[i].SeatPosID = i
			self.Seats[i].DrivingAnimType = self.AnimType
			
			self.Seats[i].HandleAnimation = nil
			
			
			self.SeatWelds[i] = constraint.Weld( self, self.Seats[i], 0, 0, 0, true )
		else
			ply:PrintMessage( HUD_PRINTTALK, "SCAR TEMPLATE ERROR: SEAT position on slot nr "..i.." was not valid\n")
		end
	end

	--//Wheels
	for i = 1, self.NrOfWheels do
	
		if self.WheelInfo[i] && self.WheelInfo[i].Pos && (self.WheelInfo[i].Side == false or self.WheelInfo[i].Side == true) && (self.WheelInfo[i].Torq == true or self.WheelInfo[i].Torq == false) then
			self.Wheels[i] = ents.Create( "sent_sakarias_carwheel" )		
			self.Wheels[i]:SetPos( self:GetPos() + (self:GetForward() * self.WheelInfo[i].Pos.x) + (self:GetRight() * self.WheelInfo[i].Pos.y) + (self:GetUp() * self.WheelInfo[i].Pos.z))
		
			if self.WheelInfo[i].Side == false then
				self.Wheels[i]:SetAngles( self:GetAngles() + Angle(0,180,0) )
			else
				self.Wheels[i]:SetAngles( self:GetAngles() )
			end
			
			if self.WheelInfo[i].Model then
				self.WheelsModel[i] = self.WheelInfo[i].Model
			end
			
			if !self.WheelsModel[i] then
				self.WheelsModel[i] = self.TireModel
			end

			self.Wheels[i].SCarOwner = self	
			self.Wheels[i].TireModel = self.WheelsModel[i]
			self.Wheels[i].physMat = self.physMat				
			self.Wheels[i].Steer = self.WheelInfo[i].Steer
			self.Wheels[i].Side = self.WheelInfo[i].Side		
			self.Wheels[i].Pos = self.WheelInfo[i].Pos
			self.Wheels[i].AddHeight = 0
			self.Wheels[i].WheelID = i
			self.Wheels[i]:Spawn()
			self.Wheels[i]:Activate()
			self.Wheels[i]:GetPhysicsObject():EnableDrag(false)	
			self.Wheels[i]:SetNetworkedEntity("SCarEnt", self)
			self.Wheels[i].SCarGroup = true
			
			self.WheelsPhys[i] = self.physMat
			
			self.WheelsHeight[i] = 0
			
			if i == 1 or i == 2 then
				self.Wheels[i]:GetPhysicsObject():SetMass(self.DefaultSoftnesFront)
			elseif i == 3 or i == 4 then
				self.Wheels[i]:GetPhysicsObject():SetMass(self.DefaultSoftnesRear)
			else
				self.Wheels[i]:GetPhysicsObject():SetMass( (self.DefaultSoftnesRear + self.DefaultSoftnesFront) / 2 )
			end
 
			
			if self.WheelInfo[i].Side == false then
				self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,1,0) , self.WheelInfo[i].Pos, 0, 0, 1, 0 )
			else
				self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,-1,0) , self.WheelInfo[i].Pos, 0, 0, 1, 0 )
			end
			
			
			self:SetNetworkedEntity("SCarWheel"..i, self.Wheels[i])
		else
			ply:PrintMessage( HUD_PRINTTALK, "SCAR TEMPLATE ERROR: WHEEL info on slot nr "..i.." was not valid\n")
		end
	end
	
	
	--Attaching lights
	for i = 1, self.NrOfRearLights do
		if self.RearLightsPos[i] then
			local light = ents.Create( "sent_sakarias_lightentity" )
			light.SCarOwner = self
			light:SetPos( self:GetPos() + (self:GetForward() * self.RearLightsPos[i].x) + (self:GetRight() * self.RearLightsPos[i].y) + (self:GetUp() * self.RearLightsPos[i].z))
			light:Spawn()
			light:SetParent( self )
			--light:SetLocalPos(self.RearLightsPos[i])
			light:SetNetworkedEntity( "ParentEnt", self )
		end
	end

	
	--Stabilizer
	self:CheckStabiliserOffset()
	self:CreateStabilizer()
	
	constraint.Weld( self, self.StabilizerProp, 0, 0, 0, true )
	self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, Angle(0,0,0) , 0, self.Stabilisation)


	--Nocolliding all wheels
	for i = 1, self.NrOfWheels do
		if IsValid( self.Wheels[i] ) then
			constraint.NoCollide( self, self.Wheels[i], 0, 0 )
			for j = i + 1, self.NrOfWheels do
				if IsValid( self.Wheels[j] ) then
					constraint.NoCollide( self.Wheels[j], self.Wheels[i], 0, 0 )
				end
			end
		end
	end	

	
	--Setting a random skin
	local skins = self:SkinCount()	
	if skins != 1 then
		local currentskin = self:GetSkin()
		newskin = math.random(skins)
		self:SetSkin(newskin)
	end	
	
	
	self.RevScale = (self.MaxSpeed / self.NrOfGears)
	
	self:GetAllTorqWheels()
	self:GetAllTurningWheels()

	--Sounds	
	if !self.HornSound then
		self.HornSound = "scarhorns/horn 1.wav"
	end
	
	if !self.EngineEffectName then
		self.EngineEffectName = "Default"
	end
	

	self:RefreshSounds()


	local effectdata = EffectData()
	effectdata:SetEntity( self )
	util.Effect( "carspawn", effectdata, true, true )	
		
	self:SetNetworkedFloat( "NeonCol1r", 0 )
	self:SetNetworkedFloat( "NeonCol1g", 0 )
	self:SetNetworkedFloat( "NeonCol1b", 0 )
	self:SetNetworkedFloat( "NeonCol2r", 0 )
	self:SetNetworkedFloat( "NeonCol2g", 0 )
	self:SetNetworkedFloat( "NeonCol2b", 0 )
	self:SetNetworkedFloat( "NeonStayTime", 0 )
	self:SetNetworkedFloat( "NeonFadeTime", 0 )
	self:SetNetworkedFloat( "NeonSize", 0 )


	self.GearRevChange = self.GearRevSpace / self.NrOfGears
	self:UpdateVehicleHealthShared()
end



-------------------------------------------USE
function ENT:Use( activator, caller )	

	if activator:IsPlayer() && (!activator.EnterSCarDel or activator.EnterSCarDel < CurTime()) then
		if self.CarIsLocked == false && self:WaterLevel() <= self.AcceptedWaterLevel && !self:IsDestroyed() then

			activator.EnterSCarDel = CurTime() + 1
			activator.SwapSeatDelay = CurTime() + 1
			local seatNum = self:GetNextEmptySeat( 1 )
		
			if self.IsSaved == true then
				self.IsSaved = false
				self:RefreshSounds()
			end

			if seatNum != 0 then

				local diff = Vector(0,0,0)
				local view = activator:GetNetworkedInt( "SCarThirdPersonView" )
				local eyes = activator:GetAttachment( activator:LookupAttachment("eyes") )
				local eyePos = activator:GetPos()
				if eyes then
					eyePos = eyes.Pos
				end
				
				if view == 1 then	
					diff = eyePos - self.Seats[seatNum]:GetPos()
				else
					diff = (self.Seats[seatNum]:GetPos() + Vector(0,0,30)) - eyePos	
				end
				
				if !activator.ScarSpecialKeyInput then
					activator.ScarSpecialKeyInput = {}
					
					for i = 1, SCarKeys.NrOfBoundKeyEvents do
						activator.ScarSpecialKeyInput[SCarKeys.KeyVarTransTable[i]] = 0
					end
				end
				
				activator:EnterVehicle( self.Seats[seatNum] )
				self:SendView_MovePos( diff, self.Seats[seatNum]:GetAngles(), activator )
				activator:SetEyeAngles( Angle(0,90,0) )

				if seatNum == 1 then
					if SCarGetFastConvar["scar_carautoenter"] == 1 then
						self:StartCar()
					end
				end

				--SendRadio info
				if seatNum != 1 and self:HasDriver() and !self:HasAIDriver() then
					local radName = self.RadioName
					local radURL = self.RadioURL
				
					timer.Create( "SCarSetRadioInfoTimer"..self:EntIndex(), 1, 1, function()
						if self.SendRadioInfo then
							self:SendRadioInfo( radName, radURL, activator )
						end
					end )
				elseif seatNum == 1 then
					self.RadioName = ""
					self.RadioURL = ""
					
					self:SendHUD_Rev( ( self.MaxSpeed / self.NrOfGears ), activator )
					self:SendHUD_RevReverse( self.ReverseMaxSpeed, activator )
					self:SendHUD_RevForward( self.MaxSpeed, activator )
					
					self:Send_UseNosRegenTime( 0,  activator )
					self:Send_UseNosTime( 0,  activator )
					self:Send_UseNos( false, activator )						
				end 
				
				if IsValid( self.AIController ) then
					self.AIController:PlayerEnteredSCar( activator )
				end				
				
					
				
				if !activator.SCarThirdPView then
					activator.SCarThirdPView = 0
				end
			end
		elseif self.CarIsLocked == true then
			activator.EnterSCarDel = CurTime() + 1
			activator.SwapSeatDelay = CurTime() + 1	
			self:EmitSound("doors/door_locked2.wav")
		end
	end
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	local ent = data.HitEntity
	

	local difference = data.OurOldVelocity:Length() - phys:GetVelocity():Length()
	
	if difference > 200 then
		local ranSound = math.random(1,4)	
		
	
		if self.CanTakeDamage == 1 and self.IgnorePhysDamage <= 0 then
			local damage = difference / 50 * GetConVarNumber( "scar_damagescale" )
			if string.find( ent:GetClass(), "sent_sakarias_car_" ) then
			
				local myDamageRatio = ent:GetPhysicsObject():GetMass() / self:GetPhysicsObject():GetMass()
				local notMyDamageRatio = self:GetPhysicsObject():GetMass() / ent:GetPhysicsObject():GetMass()
				local myDamage = damage * 0.25 * myDamageRatio
				local notMyDamage = damage * 0.75 * notMyDamageRatio
				

				if self.CanTakeDamage == 1 then
					self.CarHealth = self.CarHealth - myDamage	
				end
				
				if ent.CarHealth && ent.CanTakeDamage == 1 then
					ent.CarHealth = ent.CarHealth - notMyDamage
				end
			else
				self.CarHealth = self.CarHealth - damage
			end
			self:UpdateVehicleHealthShared()
		end
		
		if self.ImpactDelay < CurTime() then
			self.ImpactDelay = CurTime() + 0.5
		
			if difference < 500 then
				self:EmitSound("vehicles/v8/vehicle_impact_medium"..ranSound..".wav",80,math.random(80,120))
			elseif difference >= 500 then
				self:EmitSound("vehicles/v8/vehicle_impact_heavy"..ranSound..".wav",80,math.random(80,120))			
			end		
			
			self:ShakePlayers( difference )
		end
	end
	
	if IsValid( self.AIController ) then
		self.AIController:CarCollide( data, phys )
	end
	
end
-------------------------------------------PHYSICS
function ENT:PhysicsUpdate( physics )	
	
	if self.UpdatePhys > RealTime() then
		local phys = NULL
		local velVec = NULL
		local vel = NULL
		local dir = NULL
		
		if (self.DriveStatus > 0 or self.RealSteerForce != 0) or self:HasDriver() or self.IsOn then
			phys = self:GetPhysicsObject()
			velVec = phys:GetVelocity()
			vel = velVec:Length()
			dir = velVec:GetNormalized():DotProduct(self:GetForward())	
		end
		
		if self:HasDriver() then
			local driver = self:GetDriver()
			
			if self:HasDriver() and driver:IsPlayer() then

				if driver:KeyDown( IN_FORWARD ) && !driver:KeyDown( IN_BACK ) then
					self:GoForward( 1 )
					self.UsePaceSetter = false
				elseif driver:KeyDown( IN_BACK ) && !driver:KeyDown( IN_FORWARD ) then
					self:GoBack( 1 )
					self.UsePaceSetter = false
				elseif driver:KeyDown( IN_BACK ) and driver:KeyDown( IN_FORWARD ) then
					
					self.UsePaceSetter = false
					
					if vel < 500 then
						self:DoBurnout( 1000, true )
					else
						self:DoBurnout( 1000, false )
					end
					
				elseif self.UsePaceSetter == false then
					self:GoNeutral()
				end

				if driver:KeyDown( IN_SPEED ) && self.FlipDelay < CurTime() && !driver:KeyDown( IN_JUMP ) then
					self.UsePaceSetter = false

					if SCarGetFastConvar["scar_continuousturbo"] == 1 then
						self:InitiateTurbo()
					elseif SCarGetFastConvar["scar_continuousturbo"] == 0 then
						self:StartTurbo()
					end
				elseif SCarGetFastConvar["scar_continuousturbo"] == 0 then
					self:EndTurbo()
				end
				
				
				if driver:KeyDown( IN_MOVELEFT ) && !driver:KeyDown( IN_MOVERIGHT ) then
					self:TurnLeft()
				elseif driver:KeyDown( IN_MOVERIGHT ) && !driver:KeyDown( IN_MOVELEFT ) then
					self:TurnRight()
				else
					self:NotTurning()
				end		
				
				if driver:KeyDown( IN_JUMP ) && !driver:KeyDown( IN_SPEED ) then
					self:HandBrakeOn()
					self.UsePaceSetter = false
				else
					self:HandBrakeOff()
				end


				if SCarKeys:KeyDown(driver, "ToggleHydraulics") then
					self:ToggleHydraulics()
					SCarKeys:KillKey(driver, "ToggleHydraulics")
				end			

			
				if SCarKeys:KeyDown(driver, "Horn") then
					self:HornOn()
				else 
					self:HornOff()
				end
							
				if self.WheelTorqTraction == 0 && self.WheelTurnTraction == 0 && SCarKeys:KeyDown(driver, "FlipCar") then
					self:FlipCar()
					SCarKeys:KillKey(driver, "FlipCar")
				else
					SCarKeys:KillKey(driver, "FlipCar")
				end

				self:UpdateHydaulics( driver )
			end	
			
			--This value is for the steering animation on CL
			self.SteerPercent = self.RealSteerForce / self.MaxSteerForce
			if self.OldSteerParam != self.SteerPercent and IsValid(self.Seats[1]) then
				self.OldSteerPercent = self.SteerPercent
				for i = 1, self.NrOfSeats do
					if IsValid(self.Seats[i]) then
						local driver = self.Seats[i]:GetDriver()
						if IsValid(driver) then
							self:SendAnim_TurnParam( self.SteerPercent, self.Seats[1]:EntIndex(), driver )						
						end
					end
				end
			end				
		else
			self:GoNeutral()
			self:NotTurning()
		end
		
		if self.IsOn then
			if self:HasFuel() then
				self:UpdateTurboEffect()
				self:CalculateEngineRev( vel, dir )
			end			
		end
		
		if (self.DriveStatus >= 0 or self.RealSteerForce != 0) && velVec != NULL then
			
			local phys = self:GetPhysicsObject()
		
			self:ApplyEngineForces( phys, velVec, vel, dir )
			self:ApplyTurningForces( phys, velVec, vel, dir )
			self:ApplyMiscForces( phys, velVec, vel, dir )
		end
		
		
		self:UpdateTurning()
		
		if self.SpecialThink then
			self:SpecialThink()
		end	
		
		self:UpdateFlip()
		self.PhysDT = CurTime()-self.PhysLastTime
		self.PhysLastTime = CurTime()
	end
end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

	local Damage = 	0
	local attacker = dmg:GetAttacker( )
	self:TakePhysicsDamage(dmg)
	
	if attacker != self:GetDriver() then
		if dmg:IsExplosionDamage() then
			Damage = dmg:GetDamage()
		else
			Damage = (dmg:GetDamage()) / 4
		end
		
		if self.CanTakeDamage == 1 then
			self.CarHealth = self.CarHealth - Damage * GetConVarNumber( "scar_damagescale" )
			self:UpdateVehicleHealthShared()
		end
	end
	
	if IsValid( self.AIController ) then
		self.AIController:OnTakeDamage( dmg )
	end	

end
-------------------------------------------THINK
function ENT:Think()
	
	self.UpdatePhys = RealTime() + 0.5
	
	--Fixes so you can't enter the vehicle while trying to exit it.
	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
		
			local driver = self.Seats[i]:GetDriver()
			if IsValid(driver) then
				driver.EnterSCarDel = CurTime() + 1
			end
		end
	end
	
	if self:HasDriver() or self.IsOn then
		self:GetPhysicsObject():Wake()
		
		if self:HasDriver() then
			self.DriverExited = false
		end
	elseif self.DriverExited == false then
		self.DriverExited = true
		self:DriverExitsCar( self:GetDriver() )
	end
	
	if self.AutoRemoveDel != NULL and self.AutoRemoveDel < CurTime() then
		self:Remove()
	end
		
	if self.CarHealth <= 0 and self.AutoRemoveDel == NULL then
		local delay = GetConVarNumber( "scar_removedelay" )
	
		if delay and delay != 0 then
			self.AutoRemoveDel = CurTime() + delay
		end			
	elseif self.AutoRemoveDel != NULL and self.CarHealth > 0 then
		self.AutoRemoveDel = NULL
	elseif self.AutoRemoveDel != NULL and self.AutoRemoveDel < CurTime() then
		self:Remove()
	end
	
	--Sending HUD user messages
	if self:HasDriver() then

		--Updating the hud if the engine is revving
		if self.EngineIsRevving == false and self.IsOn == true and ((self.HandBrake == true && (self.DriveStatus == 1 or self.DriveStatus == 2)) or self.IsBurningOut == true or ( (self.DriveActionStatus == 1 or self.DriveActionStatus == -1) &&  self.WheelTurnTraction == 0))  then
			self.EngineIsRevving = true
			self:SendHUD_Revving( true, self:GetDriver() )
		elseif self.EngineIsRevving == true and (self.IsOn == false or !((self.HandBrake == true && (self.DriveStatus == 1 or self.DriveStatus == 2)) or self.IsBurningOut == true or ( (self.DriveActionStatus == 1 or self.DriveActionStatus == -1) &&  self.WheelTurnTraction == 0))) then
			self.EngineIsRevving = false
			self:SendHUD_Revving( false, self:GetDriver() )
		end
	
		--Updating the hud when the car is using the brake
		if self.DriveActionStatus == -2 && self.UsingBrake == false && ( self.HandBrake == false or self.IsBurningOut == false ) then
			self.UsingBrake = true
			self:SendHUD_Gear( -2 , self:GetDriver() )
		elseif self.UsingBrake == true && self.DriveActionStatus != -2 then
			self.UsingBrake = false
			self:SendHUD_Gear( self.OldGear , self:GetDriver() )
		end
		
		--Updating the hud when we have neutral gear
		if self.GearIsNeutral == false && self.DriveStatus == 0 then
			self.GearIsNeutral = true
			self:SendHUD_Neutral( self.GearIsNeutral, self:GetDriver() )
		elseif self.GearIsNeutral == true && self.DriveStatus != 0 then
			self.GearIsNeutral = false
			self:SendHUD_Neutral( self.GearIsNeutral, self:GetDriver() )
		end	
		
		self:UpdateLights()
		self:UpdateMaxSteerForce()
		self:UpdateWheelTorqTractionStatus()
		self:UpdateWheelTurnTractionStatus()	
		self:UpdatePaceSetter( self:GetPhysicsObject():GetVelocity():Length() )
	else
		self:AutoDeployHandBrake( 150 )
	end
	
	
	--Turn off the car if we don't have any fuel, health or if the car is submerged
	if self.IsOn and (self:WaterLevel() > self.AcceptedWaterLevel or self.Fuel <= 0 or self.CarHealth <= 0 ) then
		self:TurnOffCar()	
		self.AutoTurnOn = true
	end
	
	if self:HasDriver() then

		local driver = self:GetDriver()
	
		if (self.AutoTurnOn == true or !driver:IsPlayer()) and self.IsOn == false then
			self:StartCar()
			self.AutoTurnOn = false		
		end		
		
		--If the driver is a player (can be an AI sometimes)
		if driver:IsPlayer() then
			if SCarKeys:KeyWasReleased(driver, "CarOnOff") then
				self:ToggleCarOnOff()
				SCarKeys:KillKey(driver, "CarOnOff")
			end
			
			if SCarKeys:KeyWasReleased(driver, "HoldSpeeed") then
				SCarKeys:KillKey(driver, "HoldSpeeed")
				self:HoldSpeed()
			end
			
			if SCarKeys:KeyWasReleased(driver, "KickOutPassengers") then
				SCarKeys:KillKey(driver, "KickOutPassengers")

				if self:KickOutPassengers() then
					self:EmitSound("car/hydraulics.wav",100,100)
				end
			end
		end		
		
		
	elseif !self:HasDriver() and SCarGetFastConvar["scar_carautoleave"] == 1 then
		self:TurnOffCar()
		self.AutoTurnOn = false
	elseif !self:HasDriver() and SCarGetFastConvar["scar_carautoleave"] == 0 then
		self:GoNeutral()
		self:NotTurning()
	end	


	self:UpdateHealthAndEffects()
	self:AdjustKeepUpRightConstraint()
	self:CheckThirdPersonViewToggle()
	self:CheckSwapToNextSeat()
	self:UpdateBurnout()
end
-------------------------------------------ON REMOVE
function ENT:OnRemove()

	SCarGearExhaustHandler:KillEffect( self.EngineEffectName, self )

	self:TurnOffCar()

	if IsValid( self.StabilizerProp ) then
		self.StabilizerProp:Remove()
	end
	
	for i = 1, self.NrOfWheels do
		if IsValid(self.Wheels[i]) then
			self.Wheels[i]:Remove()
		end
	end

	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
		
			local driver = self.Seats[i]:GetDriver()
			if driver:IsPlayer() then
				driver:ExitVehicle()
			end
		end	
	end	
	
	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			self.Seats[i]:Remove()
		end	
	end
	
	
	if IsValid( self.DamageEffect ) then
		self.DamageEffect:Remove()
	end

	if IsValid( self.FireEffect ) then
		self.FireEffect:Remove()
	end	
	
	--Turn off all sounds
	self:SafeStopSound(self.StartSound)
	self:SafeStopSound(self.OffSound)
	self:SafeStopSound(self.Skid)	
	self:SafeStopSound(self.TurboStartSound)	
	self:SafeStopSound(self.TurboStopSound)	
	self:SafeStopSound(self.FireSound)	

	if self.SpecialRemove then
		self:SpecialRemove()
	end	
end

------------------------------------------------MISC FUNCS
function ENT:HoldSpeed()

	if self.UsePaceSetter == true then
		self.UsePaceSetter = false
	else
		self.PaceSetterSpeed = self:GetPhysicsObject():GetVelocity():Length()
		self.UsePaceSetter = true	
	end
end

function ENT:UpdatePaceSetter( vel )

	if self.UsePaceSetter == true then
		local diffspeed = (vel - self.LastPaceSetterSpeed)
		self.LastPaceSetterSpeed = vel
		if (vel + diffspeed) < self.PaceSetterSpeed then
			local per = ( self.PaceSetterSpeed - vel ) / 200
			per = math.Clamp(per,0,1)
			self:GoForward( per )
		elseif vel > (self.PaceSetterSpeed + 200) then
			self:GoBack(1)
		else --Soft brake
			self:GetPhysicsObject():ApplyForceCenter( self:GetForward() * - 100 )
			self:GoNeutral()
		end					
	end
end


function ENT:GetNextEmptySeat( start )

	for i = start, (self.NrOfSeats + start) do
	
		local slot = i % (self.NrOfSeats + 1)
		
		if slot != 0 && IsValid( self.Seats[slot] ) && self.Seats[slot]:GetDriver() == NULL && !( slot == 1 && IsValid(self.AIController)) then
			return slot
		end
	end

	return 0
end

function ENT:CheckSwapToNextSeat()

	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			local driver = self.Seats[i]:GetDriver()

			if driver:IsPlayer() && driver:KeyDown( IN_WALK ) && (!driver.SwapSeatDelay or driver.SwapSeatDelay < CurTime()) then
				driver.SwapSeatDelay = CurTime() + 1			
				local seatNum = self:GetNextEmptySeat( i )

				if seatNum != 0 then
				
					local view = driver:GetNetworkedInt( "SCarThirdPersonView" )
					local diff =  self.Seats[seatNum]:GetPos() - driver:GetVehicle():GetPos()
					local eyeAng = driver:GetAimVector():Angle()
					
					driver.rm_ExitingVehicle = true --//RagMod conflict fix
					driver:ExitVehicle()
					driver:EnterVehicle( self.Seats[seatNum] )
					driver.rm_ExitingVehicle = false --//RagMod conflict fix
					
					if seatNum == 1 then
						if SCarGetFastConvar["scar_carautoenter"] == 1 then
							self:StartCar()
						end		
					end					
					
					
					if view && view == 0 then
						driver:SetEyeAngles( Angle(0,90,0) )
						self:SendView_MovePos( diff, self.Seats[seatNum]:GetAngles(), driver )
					else
						eyeAng.r = 0
						local vehAng = driver:GetVehicle():GetAngles()
						vehAng.r = 0
						driver:SetEyeAngles( eyeAng - vehAng )
					end
					
					
					
					self:SendHUD_Rev( ( self.MaxSpeed / self.NrOfGears ), driver )
					self:SendHUD_RevReverse( self.ReverseMaxSpeed, driver )
					self:SendHUD_RevForward( self.MaxSpeed, driver )	
	
	
					self:Send_UseNosRegenTime( self.TurboDelay,  driver )
					self:Send_UseNosTime( self.TurboDuration,  driver )
					self:Send_UseNos( false, driver )
					
					if GetConVarNumber("scar_thirdpersonview") == 0 then
						driver.SCarThirdPView = 0
					end
			
					driver:SetNetworkedInt( "SCarThirdPersonView", driver.SCarThirdPView )
				end
			end
		end
	end
end

function ENT:HasDriver()

	if IsValid( self.Seats[1] ) && self.Seats[1]:GetDriver() != NULL or IsValid(self.AIController) then
	
		if IsValid(self.AIController) then
			self.RadioName = ""
			self.RadioURL = ""		
		end

		return true
	end
	
	return false
end

function ENT:GetPassengers()
	local pass = {}
	local nr = 0
	
	for i = 1, self.NrOfSeats do
		if IsValid( self.Seats[i] ) && self.Seats[i]:GetDriver() != NULL then
			nr = nr + 1 
			pass[nr] = self.Seats[i]:GetDriver()
		end
	end
	
	return nr, pass
end

function ENT:HasAIDriver()
	return IsValid(self.AIController)
end

function ENT:HasFuel()

	if self.Fuel > 0 then return true end
	return false

end

function ENT:IsDestroyed()

	if self.CarHealth <= 0 then
		return true
	end
	
	return false
end



function ENT:StartCar()

	if self.AboutToTurnOn == false and self:HasDriver() && self.IsOn == false && self.Fuel > 0 && self.CarHealth > 0 && self:WaterLevel() <= self.AcceptedWaterLevel then
		self:EmitSound(self.TurnOnSoundDir,70)
		self.AboutToTurnOn = true
		timer.Create( "ScarStartTimer"..self:EntIndex(), 1.2, 1, function()
			if self and self.HasDriver && self:HasDriver() && self.IsOn == false && self.Fuel > 0 && self.CarHealth > 0 && self:WaterLevel() <= self.AcceptedWaterLevel	then
				self:TurnOnCar()
				self.AutoTurnOn = false
			end
			self.AboutToTurnOn = false
		end )			
	end
end

function ENT:DriverExitsCar( ply )
	SCarKeys:KillKey(driver, "Horn")
	self:SafeStopSound(self.Horn)
	self:AutoDeployHandBrake( 150 )
end

function ENT:TurnOnCar()
	

	if self.IsOn == false && self:HasDriver() then

		self:SendHUD_IsOn( true, self:GetDriver() )
		self:SetNetworkedBool( "SCarIsOn", true )
		
		SCarGearExhaustHandler:InitEffect( self.EngineEffectName, self )
		
		--Sounds
		self:RefreshSounds()	
	
		for i = 1, self.NrOfWheels do
			if IsValid(self.Wheels[i]) && self.Wheels[i].IsDestroyed == false then
				self.Wheels[i]:RecreateWheelSounds()
			end
		end

		if self:HasAIDriver() then
			self:ForceRemoveHandBrake()
		end
	
		self.TurboTime = 0
		self.UseTurbo = 0	
		self.TurboOn = false
		self.TurboTime = 0
		self.TurboEndTime = self.TurboDuration	
		self.Pitch = self.MinRev
		self.RealPitch = self.MinRev
	
		self.IsOn = true
		self.StartSound:Stop()
		self.StartSound:Play()
		
		local ang = self:GetAngles()		
		ang.p = ang.p + 180


		self:FrontLightsOn( self.FrontLightColor, "150", false )
		self:RearLightsOn( "255 0 0", "150" )
		self:SetNetworkedInt( "BrakeState", 0 )
		
		if IsValid(self.Seats[1]) then
			local driver = self.Seats[1]:GetDriver()
			if IsValid(driver) then
				self:SendAnim_TurnParam( 0, self.Seats[1]:EntIndex(), driver )
				
				if self.UsesFuelConsumption == 1 then
					self:SendHUD_Fuel( self.Fuel , self:GetDriver() )
				else
					self:SendHUD_Fuel( 20000 , self:GetDriver() )
				end
	
			end
		end
		
	end

end

function ENT:TurnOffCar()

	if self.IsOn == true then
		self.UsePaceSetter = false
		self:SetNetworkedBool( "SCarIsOn", false )
		self:SendHUD_IsOn( false, self:GetDriver() )
		self.IsOn = false
		self.AutoTurnOn = false
		self.StartSound:Stop()
		self.OffSound:Stop()
		self.OffSound:Play()
		self:EndTurbo()
		
		self.HornDelay = 0
		self.RevPercent = 0
		SCarGearExhaustHandler:KillEffect( self.EngineEffectName, self )
		
		--Resetting turbo
		self.UseTurbo = CurTime()
		self.TurboStopSound:Stop()	
		self.TurboStartSound:Stop()	

		if self.TurboOn == true then
			self:SetNetworkedBool( "SCarTurboIsOn", false )	
		end
		self.TurboOn = false	
		
		self:FrontLightsOff()
		self:RearLightsOff()
			

		self:SetNetworkedInt( "BrakeState", 0 )
	end
end

function ENT:ToggleCarOnOff()
	if self.IsOn == true then
		self:TurnOffCar()
	else
		self:StartCar()
	end
end


function ENT:GetDriver()

	if IsValid(self.AIController) then
		return self.AIController
	elseif IsValid( self.Seats[1] ) then
		return self.Seats[1]:GetDriver()
	end

	return nil
end

function ENT:GoForward( thrott )

	if thrott then
		self.Throttle = thrott
	else
		self.Throttle = 1
	end
	
	self.DriveStatus = 1
end

function ENT:GoBack( thrott )

	if thrott then
		self.Throttle = thrott
	else
		self.Throttle = 1
	end
	
	self.DriveStatus = 2
end

function ENT:GoNeutral()
	self.DriveStatus = 0
	self.DriveActionStatus = 0
end

function ENT:UpdateMaxSteerForce()

	local forceScale = 1 - ((self:GetPhysicsObject():GetVelocity():Length() / self.MaxSpeed) * 0.8) + (0.8 * (self.AutoStraighten / 50))
	self.MaxSteerForce = forceScale * self.SteerForce
end

function ENT:TurnLeft( turnPercent )
	
	if !turnPercent then
		self.MaxTurnPercent = 1
	else
		self.MaxTurnPercent = turnPercent
		if self.MaxTurnPercent < 0 then
			self.MaxTurnPercent = -self.MaxTurnPercent
		end
	end
	
	self.TurnStatus = 1
end

function ENT:TurnRight( turnPercent )

	if !turnPercent then
		self.MaxTurnPercent = 1
	else
		self.MaxTurnPercent = turnPercent
		if self.MaxTurnPercent < 0 then
			self.MaxTurnPercent = -self.MaxTurnPercent
		end		
	end

	self.TurnStatus = -1
end

function ENT:NotTurning()
	self.TurnStatus = 0
	self.MaxTurnPercent = 1
end

function ENT:UpdateTurning()

	local mul = 1
	
	if self.TurnStatus == 1 then
		if self.RealSteerForce < 0 then mul = 3 end
		
	elseif self.TurnStatus == -1 then
		if self.RealSteerForce > 0 then mul = 3 end
	end
	
	if self.TurnStatus == 1 or self.TurnStatus == -1 then
	
		if self.UsingHydraulics == false then
			self.RealSteerForce = math.Approach( self.RealSteerForce, (self.MaxSteerForce * self.TurnStatus * self.MaxTurnPercent) , (self.SteerResponse * self.TurnStatus * mul) )	
		else
			self:NotTurning()		
		end	
	end	
	
	
	if self.TurnStatus == 0 then
	
		if self.RealSteerForce < 0 then
			self.RealSteerForce = math.Approach( self.RealSteerForce, 0 , self.SteerResponse * 2 )
		elseif self.RealSteerForce > 0 then
			self.RealSteerForce = math.Approach( self.RealSteerForce, 0 , (self.SteerResponse * -2) )
		end	
	end
	

end

function ENT:HandBrakeOn()
	local vel = self:GetPhysicsObject():GetVelocity():Length()
	
	if self.HandBrakeDel < CurTime() && self.HandBrake == false && self.IsBurningOut == false && !self:IsDestroyed() && self.UsingHydraulics == false then
		self.HandBrake = true
		
		--Telling the hud that we are using the handbrake
		self:SendHUD_Gear( -3 , self:GetDriver() )

		if vel > 300 and (self.WheelTorqTraction > 0 or self.WheelTurnTraction > 0) then
			self.Skid:Stop()
			self.Skid:Play()
		end

		for i = 1, self.NrOfWheels do	
			if IsValid(self.Wheels[i]) && self.Wheels[i].IsDestroyed == false then

				if self.Wheels[i].IsFlat == false then
					self.HandBrakeConstraints[i] = constraint.Weld( self.Wheels[i], self, 0, 0, 0, false )
				elseif IsValid(self.Wheels[i].Rim) then
					self.HandBrakeConstraints[i] = constraint.Weld( self.Wheels[i].Rim, self, 0, 0, 0, false )
				end
			end	
		end
	end
	
	if self.HandBrake == true && vel < 100 then
		self.Skid:Stop()
	end
	
end

function ENT:HandBrakeOff()
	
	if self.HandBrake == true then

		self.HandBrake = false
		self.IncreaseRearLightCol = 1
		
		self.Skid:Stop()
		
		self.ReleaseHandbrakeTime = CurTime() + 3
		
		--Telling the hud to set the gear
		self:SendHUD_Gear( self.OldGear , self:GetDriver() )

		for i = 1, self.NrOfWheels do
		
			if self.HandBrakeConstraints[i] && self.HandBrakeConstraints[i] != NULL then
				self.HandBrakeConstraints[i]:Remove()
			end
		end
	end	
end

function ENT:AutoDeployHandBrake( minVel )
	if !self.HandBrake and !self:IsDestroyed() and self:GetPhysicsObject():IsValid() and self:GetPhysicsObject():GetVelocity():Length() < minVel and self.AboutToTurnOn == false and !self:HasDriver() and SCarGetFastConvar["scar_autodeployhandbrake"]  == 1 then
		self:HandBrakeOn()
	end
end

function ENT:ForceRemoveHandBrake()

	if self.HandBrake == true then
		self:SendHUD_Gear( self.OldGear , self:GetDriver() )
	end

	self.HandBrakeDel = CurTime() + 1
	
	self.HandBrake = false
	self.IncreaseRearLightCol = 0
	
	if self.IsOn == true then
		self:RearLightsOn( "255 0 0", "150" )	
	end
	
	self:SetNetworkedInt( "BrakeState", 0 )
			
	for i = 1, self.NrOfWheels do
	
		if self.HandBrakeConstraints[i] && self.HandBrakeConstraints[i] != NULL && IsValid(self.HandBrakeConstraints[i]) then
			self.HandBrakeConstraints[i]:Remove()
		end
	end
end

function ENT:UpdateHealthAndEffects()

	if self.DoRepair == true then
		self:Repair()
		self.DoRepair = false
	end

	--Effects	
	if self.CarHealth < self.CarMaxHealth && self.effectPos then
		
		if self.CarHealth < 100 && self.DamageLevel == 0 then
			self.DamageLevel = 1

			if IsValid(self.DamageEffect) then
				self.DamageEffect:Remove()
			end			
			
			self.DamageEffect = ents.Create("env_smokestack")
			self.DamageEffect:SetPos(self:GetPos() + (self:GetForward() * self.effectPos.x) + (self:GetRight() * self.effectPos.y) + (self:GetUp() * self.effectPos.z))
			self.DamageEffect:SetKeyValue("InitialState", "1")
			self.DamageEffect:SetKeyValue("WindAngle", "0 0 0")
			self.DamageEffect:SetKeyValue("WindSpeed", "0")
			self.DamageEffect:SetKeyValue("rendercolor", "170 170 170")
			self.DamageEffect:SetKeyValue("renderamt", "170")
			self.DamageEffect:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
			self.DamageEffect:SetKeyValue("BaseSpread", "10")
			self.DamageEffect:SetKeyValue("SpreadSpeed", "5")
			self.DamageEffect:SetKeyValue("Speed", "100")
			self.DamageEffect:SetKeyValue("StartSize", "50")
			self.DamageEffect:SetKeyValue("EndSize", "10" )
			self.DamageEffect:SetKeyValue("roll", "10" )
			self.DamageEffect:SetKeyValue("Rate", "10" )
			self.DamageEffect:SetKeyValue("JetLength", "50" )
			self.DamageEffect:SetKeyValue("twist", "5" )

			//Spawn smoke
			self.DamageEffect:Spawn()
			self.DamageEffect:SetParent(self)
			self.DamageEffect:Activate()	
			
			
		
		elseif self.CarHealth < 50 && self.DamageLevel == 1 then
			self.DamageLevel = 2
			
			if IsValid(self.DamageEffect) then
				self.DamageEffect:Remove()
			end
			
			self.DamageEffect = ents.Create("env_smokestack")
			self.DamageEffect:SetPos(self:GetPos() + (self:GetForward() * self.effectPos.x) + (self:GetRight() * self.effectPos.y) + (self:GetUp() * self.effectPos.z))
			self.DamageEffect:SetKeyValue("InitialState", "1")
			self.DamageEffect:SetKeyValue("WindAngle", "0 0 0")
			self.DamageEffect:SetKeyValue("WindSpeed", "0")
			self.DamageEffect:SetKeyValue("rendercolor", "10 10 10")
			self.DamageEffect:SetKeyValue("renderamt", "170")
			self.DamageEffect:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
			self.DamageEffect:SetKeyValue("BaseSpread", "10")
			self.DamageEffect:SetKeyValue("SpreadSpeed", "5")
			self.DamageEffect:SetKeyValue("Speed", "100")
			self.DamageEffect:SetKeyValue("StartSize", "50")
			self.DamageEffect:SetKeyValue("EndSize", "10")
			self.DamageEffect:SetKeyValue("roll", "10")
			self.DamageEffect:SetKeyValue("Rate", "100")
			self.DamageEffect:SetKeyValue("JetLength", "50")
			self.DamageEffect:SetKeyValue("twist", "5")

			//Spawn smoke
			self.DamageEffect:Spawn()
			self.DamageEffect:SetParent(self)
			self.DamageEffect:Activate()		
			
			

		elseif self.CarHealth < 25 && self.DamageLevel == 2 then
			self.DamageLevel = 3
			
			self.DamageEffect:Remove()
			
			self.FireSound:Stop()
			self.FireSound:Play()
			
			self.FireEffect = ents.Create( "env_fire_trail" )
			self.FireEffect:SetPos(self:GetPos() + (self:GetForward() * self.effectPos.x) + (self:GetRight() * self.effectPos.y) + (self:GetUp() * self.effectPos.z))
			self.FireEffect:Spawn()
			self.FireEffect:SetParent(self)
			
			
		elseif self.CarHealth <= 0 && self.DamageLevel == 3 then
			self.DamageLevel = 4

			--Explosion
			local expl = ents.Create("env_explosion")
			expl:SetPos(self:GetPos())
			expl:Spawn()
			expl:Fire("explode","",0)
		
			--Explosion damage
			util.BlastDamage( self, self, self:GetPos(), 300, 200)			
			
			--Physics explosion
			local FireExp = ents.Create("env_physexplosion")
			FireExp:SetPos(self:GetPos())
			FireExp:SetParent(self)
			FireExp:SetKeyValue("magnitude", 40)
			FireExp:SetKeyValue("radius", 300)
			FireExp:SetKeyValue("spawnflags", "1")
			FireExp:Spawn()
			FireExp:Fire("Explode", "", 0)
			FireExp:Fire("kill", "", 0)
			
			--Shake
			local shake = ents.Create( "env_shake" )
			shake:SetPos( self:GetPos() )
			shake:SetKeyValue( "amplitude", 1500 )
			shake:SetKeyValue( "radius", 1000  )
			shake:SetKeyValue( "frequency", "250" )
			shake:SetKeyValue( "duration", "2.0" )
			shake:SetKeyValue( "amplitude", 1500 )
			shake:SetKeyValue( "spawnflags", "4" )
			shake:Spawn()
			shake:Fire( "StartShake", "", 0 )				
			
			self.SaveDamagedCol = self:GetColor()
			self:SetColor(Color(50,50,50,255))
			
			local effect = EffectData()
            effect:SetOrigin(self:GetPos())
			effect:SetStart(self:GetPos())
			effect:SetScale(750)
			effect:SetMagnitude(200)
			effect:SetNormal(self:GetUp())
			util.Effect("ThumperDust", effect)		
			
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetStart( Vector(0,0,0) )
			util.Effect( "scardestruction_explosion", effectdata )				

			--Kill players
			for i = 1, self.NrOfSeats do
				
				if IsValid( self.Seats[i] ) then
					local driver = self.Seats[i]:GetDriver()
					
					if IsValid(driver) and driver:IsPlayer() then
						local hp = driver:Health() - 100;
						local armor = driver:Armor() - 100;
						
						--ply:SetHealth won't update the health properly. Can have -10 health and still be alive.
						driver:Fire("sethealth", ""..math.Clamp(hp,0,10000000), 0)
						driver:SetArmor( math.Clamp(armor,0,10000000) )			
						driver:ExitVehicle()
					end
				end
			end
			
			--Launch car up in the air
			self:GetPhysicsObject():SetVelocity( self:GetPhysicsObject():GetVelocity() + Vector(0,0,math.Rand( 50, 300 )))
			
			--Let the wheels go
			self:ForceRemoveHandBrake()
			
			for i = 1, self.NrOfWheels do
				if IsValid( self.Wheels[i] ) and self.Wheels[i].IsDestroyed == false and IsValid(self.Wheels[i]) then
					self.Wheels[i]:GetPhysicsObject():SetVelocity( self:GetPhysicsObject():GetVelocity() +  Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * math.Rand( 1, 1000 ) )
				end
			end
		end	
	end

	--Drain Health
	if self.DamageLevel == 3 && self.TakeHealthDel < CurTime() then
		self.CarHealth = self.CarHealth - 3
		self.TakeHealthDel = CurTime() + 1	
		self:UpdateVehicleHealthShared()
	end	
	
end

function ENT:ApplyEngineForces( phys, velVec, vel, dir )

	if self.ReleaseHandbrakeTime > CurTime() && self.Gear == 0 && vel < 100 && self.RealPitch > self.MaxRev && self:GetDriver():IsPlayer() && (self:GetDriver():KeyDown( IN_FORWARD ) or self:GetDriver():KeyDown( IN_BACK )) then
		self:DoBurnout( 2000, false )
	end
	

	if !self:IsDestroyed() && self.UsingHydraulics == false then
	
		if self.DriveStatus > 0 && self.HandBrake == false then
			
			if self.IsBurningOut == false then
			
				local force = self:GetForward()
				local spinForce = vel
				spinForce = math.Clamp(spinForce,0,500)
				
				if self.DriveStatus == 1 then --Brake or forward
					--Checking if we should brake or go forward
					if dir < 0 && vel > 40 then --BRAKE
						force = force * self.BreakForce
						self.DriveActionStatus = -2
					elseif self.IsOn == true && vel < self.MaxSpeed && self:HasFuel() then --FORWARD
						force = force * self.Acceleration 
						
						self.DriveActionStatus = 1		
					
						--Making the wheels spin forward
						self:SpinTorqWheels( 500 - spinForce )
						
						--Are We Using Turbo?
						if self.TurboOn == true then
							force = force * self.TurboEffect
							SCarGearExhaustHandler:TurboThink( self.EngineEffectName, self )							
						end
					end

				else --Brake or reverse
					--Checking if we should brake or go in reverse
					if dir > 0.9 && vel > 10 then --BRAKE
						force = force * self.BreakForce * -1.5
						self.DriveActionStatus = -2
					elseif self.IsOn == true && vel < self.ReverseMaxSpeed && self:HasFuel() then --REVERSE
						force = force * self.ReverseForce * -1
						self.DriveActionStatus = -1
						
						--Making the wheels spin backwards
						self:SpinTorqWheels( -(500 - spinForce) )
						
						--Are We Using Turbo?
						if self.TurboOn == true then
							force = force * self.TurboEffect
							SCarGearExhaustHandler:TurboThink( self.EngineEffectName, self )
						end				
					end
					
				end

				force = force * self.WheelTorqTraction * self.Throttle
				
				local v = force:Length()
				phys:ApplyForceCenter( force )
			end

			--Air
			if  SCarGetFastConvar["scar_aircontrol"] == 1 and vel > 200 && (self.WheelTorqTraction + self.WheelTurnTraction) == 0 then
				if self.DriveStatus == 1 then
					phys:AddAngleVelocity( Vector(0, -3, 0 ))
				else
					phys:AddAngleVelocity( Vector(0, 3, 0 ))
				end	
			end
		elseif self.HandBrake == true then
			
		
			phys:ApplyForceCenter( velVec:GetNormalized() * -2000 * (1 - math.Clamp((vel / 1000),0,1)) * math.Clamp((vel / 200),0,1) * self.WheelTorqTraction)
		end
		
		
	end
	
end

function ENT:ApplyTurningForces( phys, velVec, vel, dir )
	
	
	--New Wheel steering
	if self.WheelTurnTraction > 0 then
		local force = self:GetRight() * self.RealSteerForce * dir * self.WheelTurnTraction * phys:GetMass() * -0.4 
		
		for i = 1, self.NrOfTurningWheels do
			if IsValid(self.TurningWheels[i]) then
				self.TurningWheels[i]:ApplyTurnForce( force * self.WheelInfo[self.TurningWheels[i].WheelID].Steer )
			end
		end	
	end
	
	--Air
	if SCarGetFastConvar["scar_aircontrol"] == 1 and (self.WheelTorqTraction + self.WheelTurnTraction) == 0 then
		phys:AddAngleVelocity( Vector(-5 * self.TurnStatus, 0, 0 ))
	end

end

function ENT:ApplyMiscForces( phys, velVec, vel, dir )


	if self.HandBrake == false && self.IsBurningOut == false && (self.AntiSlide > 0 or self.AutoStraighten > 0) && !self:IsDestroyed() then	
		local wheelMul = ( ( self.WheelTorqTraction + self.WheelTurnTraction ) * 0.5 )
		
		--Anti slide
		if self.AntiSlide > 0 and vel > 50 then
			local dotmul = velVec:GetNormalized():Dot(self:GetRight())
			local sum = self.AntiSlide * dotmul * wheelMul
			
			if sum < 0 then
				sum = sum * -1
			end
			
			--Taking the slide force and converts it to forward force
			---------------------- Removing the sideway force ---------------------------------Adding forward force------------
			phys:ApplyForceCenter( self:GetRight() * self.AntiSlide * dotmul * wheelMul * -300 + self:GetForward() * sum * 100 ) 			
		end				

		--Auto Straighten
		if self.AutoStraighten > 0 then
		
			local velDir = velVec:GetNormalized()
			local velPercent = vel / self.MaxSpeed
			
			local destPos = self:GetPos() + velDir * 500
			local lDist = (self:GetPos() + self:GetRight() * -50):Distance(destPos)	
			local rDist = (self:GetPos() + self:GetRight() * 50):Distance(destPos)	 
			local force = lDist - rDist
			
			if force < 0 then
				force  = force * -1
			end		

			if lDist > rDist then
				phys:AddAngleVelocity( Vector(0,0, -0.01) * force * wheelMul * velPercent * self.AutoStraighten )
			else
				phys:AddAngleVelocity( Vector(0,0, 0.01) * force * wheelMul * velPercent * self.AutoStraighten)	
			end				
		end	
	end
	
end

--Can use small ammounts of turbo

function ENT:StartTurbo()

	if self.TurboDuration > 0 and self.TurboEffect > 0 and self.TurboOn == false and self.UseTurbo < CurTime() and self.IsOn == true then
		self.TurboOn = true
		
		SCarGearExhaustHandler:TurboOn( self.EngineEffectName, self )
		
		--local tm = (CurTime() - self.TurboEndTime)
		local tm = (CurTime() - self.TurboEndTime) * 0.5
		tm = math.Clamp(tm,0,self.TurboDuration)
		self.TurboTime = CurTime() + tm
		self:SetNetworkedBool( "SCarTurboIsOn", true )
		self.TurboStartSound:Stop()		
		self.TurboStartSound:Play()	
		
		local per = 1 - tm / self.TurboDuration

		local driver = self:GetDriver()
		self:Send_UseContNos( false, driver )
		self:Send_UseNosTime( tm,  driver )
		self:Send_UseNosRegenTime( per,  driver )
		self:Send_UseNos( true, driver )		
			
	end
end

function ENT:EndTurbo()
	if self.TurboOn == true then
		self.TurboOn = false
		SCarGearExhaustHandler:TurboOff( self.EngineEffectName, self )
		
		self:SetNetworkedBool( "SCarTurboIsOn", false )
		local tm = (self.TurboTime - CurTime())
		self.TurboEndTime = CurTime() - tm 
		self.TurboStartSound:Stop()
		self.TurboStopSound:Stop()
		self.TurboStopSound:Play()
		
		local driver = self:GetDriver()
		
		tm = self.TurboDuration - tm
		local per = 1-(tm / (self.TurboDuration))
		

		self:Send_UseContNos( false, driver )
		self:Send_UseNosTime( tm*2,  driver )
		self:Send_UseNosRegenTime( per,  driver )
		self:Send_UseNos( false, driver )	

		if self.UseTurbo < CurTime() then self.UseTurbo = CurTime() + 1 end
		
	end
end

---All turbo used in one go
function ENT:InitiateTurbo()

	if self.TurboDuration > 0 and self.TurboEffect > 0 and self.TurboTime < CurTime() && self.IsOn == true then

		self.TurboTime = CurTime() + self.TurboDuration + self.TurboDelay
		self.UseTurbo = CurTime() + self.TurboDuration

		self.TurboOn = true
		self:SetNetworkedBool( "SCarTurboIsOn", true )
		
		self.TurboStartSound:Stop()		
		self.TurboStartSound:Play()
		
		if self:GetDriver() and self:GetDriver():IsPlayer() then
			local driver = self:GetDriver()
			self:Send_UseContNos( true, driver )
			self:Send_UseNosRegenTime( self.TurboDelay,  driver )
			self:Send_UseNosTime( self.TurboDuration,  driver )
			self:Send_UseNos( true, driver )
		end
	end
end
				
		
function ENT:UpdateTurboEffect()

	if SCarGetFastConvar["scar_continuousturbo"] == 1 then
		if self.TurboOn == true && ( self.UseTurbo < CurTime() or self.IsOn == false ) then
			self.UseTurbo = CurTime()
			self.TurboOn = false
			self:SetNetworkedBool( "SCarTurboIsOn", false )
			self.TurboStartSound:Stop()
			self.TurboStopSound:Stop()
			self.TurboStopSound:Play()
			
			if self:GetDriver() and self:GetDriver():IsPlayer() then
				local driver = self:GetDriver()
				self:Send_UseContNos( true, driver )
				self:Send_UseNosRegenTime( self.TurboDelay,  driver )
				self:Send_UseNosTime( self.TurboDuration,  driver )
				self:Send_UseNos( false, driver )
			end
		end
	elseif self.TurboOn == true and SCarGetFastConvar["scar_continuousturbo"] == 0 then
		if self.TurboTime < CurTime() then
			self.UseTurbo = CurTime() + 2
			self:EndTurbo()
		end
	end


end

function ENT:HornOn()
	if !self.Horn:IsPlaying() then
		self.Horn:Play()
		self.HornDelay = CurTime() + SoundDuration( self.HornSound )
	end
end

function ENT:HornOff()
	if self.Horn:IsPlaying() and self.HornDelay < CurTime() then
		self.Horn:Stop()
	end
end


function ENT:CalculateEngineRev( vel, dir )

	if ( self.HandBrake == true && (self.DriveStatus == 1 or self.DriveStatus == 2)) or self.IsBurningOut == true or ( (self.DriveActionStatus == 1 or self.DriveActionStatus == -1) &&  self.WheelTurnTraction == 0) then --HandBrake rev
		self.RealPitch = math.Approach( self.RealPitch, self.RealMaxRev , 2 )
	elseif self.DriveActionStatus == 1 then --Forward
		self.Pitch = ((vel % self.RevScale) / self.RevScale) * self.MaxRev + self.MinRev + self.GearRevChange * (self.Gear+1)

		self.RealPitch = math.Approach( self.RealPitch, self.Pitch , ((self.Pitch - self.RealPitch) *0.1) )
		if vel > self.MaxSpeed then
			self.RealPitch = (self.MaxRev + self.MinRev + self.GearRevChange * (self.Gear+1))
		end		
		
	elseif self.DriveActionStatus == -1 then --Reverse
		self.Pitch = ( vel / self.ReverseMaxSpeed ) * self.MaxRev + self.MinRev
		self.RealPitch = math.Approach( self.RealPitch, self.Pitch , ((self.Pitch - self.RealPitch) / 5) )
		
		if vel > self.ReverseMaxSpeed then
			self.RealPitch = (self.MaxRev + self.MinRev )
		end		
		
	elseif self.DriveActionStatus == 0 or self.DriveActionStatus == -2 then --Neutral / Brake
		self.RealPitch = math.Approach( self.RealPitch, self.MinRev , 1 )	
	end

	
	--Changeing engine pitch
	self.RealPitch = math.Clamp( self.RealPitch, self.MinRev, self.RealMaxRev ) --Just to be sure
	
	self.StartSound:ChangePitch( self.RealPitch, self.PhysDT )
	SCarGearExhaustHandler:EffectChangePitch( self.EngineEffectName, self, self.PhysDT )
	
	--Reduce fuel amount depending on the engine rev
	self.RevPercent = (self.RealPitch / self.RealMaxRev)

	if self.UsesFuelConsumption == 1 then
		self.Fuel = self.Fuel - (self.RevPercent * self.FuelConsumption)
		self.FuelPercent = self.Fuel / self.MaxFuel

		if self.UpdateFuelDel < CurTime() then
			self.UpdateFuelDel = CurTime() + 0.5
			self:SendHUD_Fuel( self.Fuel , self:GetDriver() )
		end
	end

	--Calculating Gear	
	if self.DriveActionStatus != 0 && self.ChangeGearDel < CurTime() && self.DriveActionStatus != -2 && self.HandBrake == false && self.IsBurningOut == false then
		
		if self.DriveActionStatus == -1 then
			self.Gear = self.DriveActionStatus
		else
			self.Gear = math.floor( vel / ( self.MaxSpeed / self.NrOfGears ) )
		end
		
		if self.Gear > self.NrOfGears - 1 then 
			self.Gear = self.NrOfGears - 1
		end
		
		if self.Gear != self.OldGear then
			
			self.OldGear = self.Gear
			self.ChangeGearDel = CurTime() + 0.5
			SCarGearExhaustHandler:UseEffect( self.EngineEffectName, self )
			
			self:SendHUD_Gear( self.Gear, self:GetDriver() )
		end
	end		
	
	

end

----------------------------LIGHTS
function ENT:UpdateLights()
	if self.IsOn == true then
		if self.IncreaseRearLightCol == 0 then
			if self.HandBrake == true or self.IsBurningOut == true or self.DriveActionStatus == -2 then --Brake lights on
				self.IncreaseRearLightCol = 1
				self:RearLightsOn( "255 0 0", "200" )
				self:SetNetworkedInt( "BrakeState", 1 )
			
			elseif self.DriveActionStatus == -1 then --Reverse lights on
				self.IncreaseRearLightCol = 2
				self:RearLightsOn( "255 255 255", "150" )
				self:SetNetworkedInt( "BrakeState", 2 )
			end
		else

			if self.IncreaseRearLightCol == 1 && !(self.HandBrake == true or self.IsBurningOut == true or self.DriveActionStatus == -2) then  --Return brake lights to normal
				self.IncreaseRearLightCol = 0
				self:RearLightsOn( "255 0 0", "150" )	
				self:SetNetworkedInt( "BrakeState", 0 )
			elseif self.IncreaseRearLightCol == 2 && self.DriveActionStatus != -1 then --Return reverse lights to normal
				self:RearLightsOn( "255 0 0", "150" )
				self.IncreaseRearLightCol = 0
				self:SetNetworkedInt( "BrakeState", 0 )
			end
		end

		local driver = self:GetDriver()

		if driver:IsPlayer() and SCarKeys:KeyWasReleased(driver, "ToggleHeadlights") && self.switchLightDelay < CurTime() then
			
			if self.IncreaseFrontLightCol == false then
				self.IncreaseFrontLightCol = true
				self:FrontLightsOn( self.FrontLightColor, "255", true )
			else
				self.IncreaseFrontLightCol = false
				self:FrontLightsOn( self.FrontLightColor, "150", false )
			end

			self.switchLightDelay = CurTime() + 0.5
			SCarKeys:KillKey(driver, "ToggleHeadlights")	
			
			self:EmitSound("buttons/button1.wav")
		end	
	end
end

function ENT:FrontLightsOn( col, alpha, rtOn )

	--Creating Front Lights
	for i = 1, self.NrOfFrontLights do
		if self.FrontLightsPos[i] then

			local parent = self
			local ignore = false
			
			if self.FrontLightsParent and IsValid(self.FrontLightsParent[i]) then
				parent = self.FrontLightsParent[i]
				self:SetNetworkedEntity( "SCar_CL_FrontLightParent_"..i, parent)
			end
		
			--Sprites
			if IsValid( self.FrontLights[i] ) then
				self.FrontLights[i]:Remove()
			end			
	
			if IsValid( self.FrontLightsCentre[i] ) then
				self.FrontLightsCentre[i]:Remove()
			end		
			
			if IsValid( self.FrontLightsRt[i] ) then
				self.FrontLightsRt[i]:Remove()
			end		

			if !ignore then
				self.FrontLights[i] = ents.Create("env_sprite")
				self.FrontLights[i]:SetPos( parent:GetPos() + (parent:GetForward() * self.FrontLightsPos[i].x ) + ( parent:GetRight() * self.FrontLightsPos[i].y ) + ( parent:GetUp() * self.FrontLightsPos[i].z ) )	
				self.FrontLights[i]:SetKeyValue( "renderfx", "14" )
				self.FrontLights[i]:SetKeyValue( "model", "sprites/glow1.vmt")
				self.FrontLights[i]:SetKeyValue( "scale","1.0")
				self.FrontLights[i]:SetKeyValue( "spawnflags","1")
				self.FrontLights[i]:SetKeyValue( "angles","0 0 0")
				self.FrontLights[i]:SetKeyValue( "rendermode","9")
				self.FrontLights[i]:SetKeyValue( "renderamt", alpha)
				self.FrontLights[i]:SetKeyValue( "rendercolor", col )				
				self.FrontLights[i]:Spawn()
				self.FrontLights[i]:SetParent( parent )	

				self.FrontLightsCentre[i] = ents.Create("env_sprite")
				self.FrontLightsCentre[i]:SetPos( parent:GetPos() + (parent:GetForward() * self.FrontLightsPos[i].x ) + ( parent:GetRight() * self.FrontLightsPos[i].y ) + ( parent:GetUp() * self.FrontLightsPos[i].z ) )	
				self.FrontLightsCentre[i]:SetKeyValue( "renderfx", "14" )
				self.FrontLightsCentre[i]:SetKeyValue( "model", "sprites/glow1.vmt")
				self.FrontLightsCentre[i]:SetKeyValue( "scale","0.5")
				self.FrontLightsCentre[i]:SetKeyValue( "spawnflags","1")
				self.FrontLightsCentre[i]:SetKeyValue( "angles","0 0 0")
				self.FrontLightsCentre[i]:SetKeyValue( "rendermode","9")
				self.FrontLightsCentre[i]:SetKeyValue( "renderamt", alpha)
				self.FrontLightsCentre[i]:SetKeyValue( "rendercolor", "255 255 255" )				
				self.FrontLightsCentre[i]:Spawn()
				self.FrontLightsCentre[i]:SetParent( parent )	

				--Rt
				if rtOn == true && GetConVarNumber("scar_usert") == 1 then
					self:SetNetworkedBool( "HeadlightsOn", true )
					self.FrontLightsRt[i] = ents.Create( "env_projectedtexture" )
					self.FrontLightsRt[i]:SetParent( parent )
					self.FrontLightsRt[i]:SetLocalPos( self.FrontLightsPos[i] )
					self.FrontLightsRt[i]:SetLocalAngles( Angle(10,0,0) )
					self.FrontLightsRt[i]:SetKeyValue( "enableshadows", 1 )
					self.FrontLightsRt[i]:SetKeyValue( "LightWorld", 1 )		
					self.FrontLightsRt[i]:SetKeyValue( "farz", 2048 )
					self.FrontLightsRt[i]:SetKeyValue( "nearz", 65 )
					self.FrontLightsRt[i]:SetKeyValue( "lightfov", 50 )
					self.FrontLightsRt[i]:SetKeyValue( "lightcolor", "255 255 255" )
					self.FrontLightsRt[i]:Spawn()
					self.FrontLightsRt[i]:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
					self.FrontLightsRt[i].IsScarRT = true
				else
					self:SetNetworkedBool( "HeadlightsOn", false )
				end
			end
		else
			ply:PrintMessage( HUD_PRINTTALK, "SCAR TEMPLATE ERROR: FRONT LIGHT position on slot nr "..i.." was not valid\n")
		end
	end

end

function ENT:FrontLightsOff()

	self.IncreaseFrontLightCol = false
	self:SetNetworkedBool( "HeadlightsOn", false )
	
	--Removing front lights
	for i = 1, self.NrOfFrontLights do
		if IsValid( self.FrontLights[i] ) then
			self.FrontLights[i]:Remove()
		end		
		
		if IsValid( self.FrontLightsCentre[i] ) then
			self.FrontLightsCentre[i]:Remove()
		end			
		
		if IsValid( self.FrontLightsRt[i] ) then
			self.FrontLightsRt[i]:Remove()
		end		
	end
end


function ENT:RearLightsOn( col, alpha )

	--Creating Rear Light Sprites
	for i = 1, self.NrOfRearLights do
		if self.RearLightsPos[i] then
		
			local parent = self
		
			if self.RearLightsParent and IsValid(self.RearLightsParent[i]) then
				parent = self.RearLightsParent[i]
			end		
		
			if IsValid( self.RearLights[i] ) then
				self.RearLights[i]:Remove()
			end	

			self.RearLights[i] = ents.Create("env_sprite")
			self.RearLights[i]:SetPos( parent:GetPos() + (parent:GetForward() * self.RearLightsPos[i].x ) + ( parent:GetRight() * self.RearLightsPos[i].y ) + ( parent:GetUp() * self.RearLightsPos[i].z ) )	
			self.RearLights[i]:SetKeyValue( "renderfx", "14" )
			self.RearLights[i]:SetKeyValue( "model", "sprites/glow1.vmt")
			self.RearLights[i]:SetKeyValue( "scale","1.0")
			self.RearLights[i]:SetKeyValue( "spawnflags","1")
			self.RearLights[i]:SetKeyValue( "angles","0 0 0")
			self.RearLights[i]:SetKeyValue( "rendermode","9")
			self.RearLights[i]:SetKeyValue( "renderamt", alpha)
			self.RearLights[i]:SetKeyValue( "rendercolor", col )				
			self.RearLights[i]:Spawn()
			self.RearLights[i]:SetParent( parent )	
		
		else
			ply:PrintMessage( HUD_PRINTTALK, "SCAR TEMPLATE ERROR: REAR LIGHT position on slot nr "..i.." was not valid\n")			
		end
	end

end

function ENT:RearLightsOff()
	--Removing rear lights
	self.IncreaseRearLightCol = 0
	for i = 1, self.NrOfRearLights do
		if IsValid( self.RearLights[i] ) then
			self.RearLights[i]:Remove()
		end		
	end
end


function ENT:UpdateBurnout()
	
	if self.LastBurnOut < CurTime() && self.IsBurningOut == true then
		self.IsBurningOut = false
		self:SendHUD_Gear( self.OldGear , self:GetDriver() )
		
		if self.BurnOutLockedWheels == true then
			self:ForceRemoveHandBrake()
		end
		
		self.BurnOutLockedWheels = false
	end
	
end

function ENT:DoBurnout( spinForce, shouldLockWheels )

	if self.HandBrake == false && self.IsOn == true and self.canDoBurnout then
	
		self.LastBurnOut = CurTime() + 0.2
		
		if self.IsBurningOut == false then
			self.IsBurningOut = true
			self:SendHUD_Gear( -2 , self:GetDriver() )

			--if self:GetPhysicsObject():GetVelocity():Length() < 200 then
			if shouldLockWheels then
				self.BurnOutLockedWheels = true
				
				for i = 1, self.NrOfWheels do
					if IsValid(self.Wheels[i]) && self.WheelInfo[i].Torq == false then
						self.HandBrakeConstraints[i] = constraint.Weld( self.Wheels[i], self, 0, 0, 0, false )
					end
				end
			end
		end
		
		local wheelMul = 0
		for i = 1, self.NrOfTorqueWheels do
			if IsValid(self.TorqueWheels[i]) && self.TorqueWheels[i].IsDestroyed == false then
				self.TorqueWheels[i]:EmitSmoke()
				
				if self.TorqueWheels[i].Side == true then
					wheelMul = 1
				else
					wheelMul = -1
				end
				self.TorqueWheels[i]:ApplySpinForce( spinForce * wheelMul )		
			end
		end		
	end
end

function ENT:SpinTorqWheels( force )

	--Positive force =  Forward
	--Negative force =  Backwards

	local wheelMul = 0
	for i = 1, self.NrOfTorqueWheels do
		if IsValid(self.TorqueWheels[i]) && self.TorqueWheels[i].IsDestroyed == false then
			
			if self.TorqueWheels[i].Side == true then
				wheelMul = 1
			else
				wheelMul = -1
			end
			self.TorqueWheels[i]:ApplySpinForce( force * wheelMul )
		end
	end
end

--HUD and other UserMessages
function ENT:Send_UseNos( nos, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetUseNosFromServer", ply )
			umsg.Bool( nos )
		umsg.End()
	end
end

function ENT:Send_UseContNos( contNos, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetUseContNosFromServer", ply )
			umsg.Bool( contNos )
		umsg.End()
	end
end

function ENT:Send_UseNosTime( nosTime,  ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "GetNosTimeFromServer", ply )
			umsg.Float( nosTime )
		umsg.End()
	end
end

function ENT:Send_UseNosRegenTime( nosRegenTime,  ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "GetNosRegenTimeFromServer", ply )
			umsg.Float( nosRegenTime )
		umsg.End()
	end
end



function ENT:SendAnim_TurnParam( turn, vehid, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetTurnParamFromServer", ply )
			umsg.Float( turn )
			umsg.Short( vehid )
		umsg.End()
	end
end

function ENT:SendRadioInfo( radioName, radioURL, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "GetSCarRadioFromServer", ply )
			umsg.String( radioName.."¤"..radioURL )
		umsg.End()
	end
end

--HUD user messages
function ENT:SendView_MovePos( vec, ang, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SetHeadPosFromServerCalcView", ply )
			umsg.Vector( vec )
			umsg.Angle( ang )
		umsg.End()
	end
end

function ENT:SendHUD_IsOn( IsOn, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetIsOnFromServer", ply )
			umsg.Bool( IsOn )
		umsg.End()
	end
end

function ENT:SendHUD_Gear( gear, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetGearFromServer", ply )
			umsg.Short( gear )
		umsg.End()
	end
end

function ENT:SendHUD_Rev( rev, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetEngineRevFromServer", ply )
			umsg.Long( rev )
		umsg.End()
	end
end

function ENT:SendHUD_RevReverse( rev, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetEngineRevReverseFromServer", ply )
			umsg.Long( rev )
		umsg.End()
	end
end

function ENT:SendHUD_RevForward( rev, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetEngineRevForwardFromServer", ply )
			umsg.Long( rev )
		umsg.End()
	end
end

function ENT:SendHUD_Fuel( fuel, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetFuelFromServer", ply )
			umsg.Long( fuel )
		umsg.End()
	end
end

function ENT:SendHUD_Neutral( neutral, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetNeutralFromServer", ply )
			umsg.Bool( neutral )
		umsg.End()
	end
end

function ENT:SendHUD_Revving( rev, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SCarGetRevvingFromServer", ply )
			umsg.Bool( rev )
		umsg.End()
	end
end


function ENT:CheckThirdPersonViewToggle()

	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			local driver = self.Seats[i]:GetDriver()
			
			if driver:IsPlayer() and SCarKeys:KeyWasReleased(driver, "ToggleView") and	self.SwitchViewDelay < CurTime() then
				self.SwitchViewDelay = CurTime() + self.SwitchViewAddDelay
				SCarKeys:KillKey(driver, "ToggleView")
				
				
				if driver:GetViewEntity():GetClass() != "gmod_cameraprop" then

					if driver.SCarThirdPView == 1 then
						driver.SCarThirdPView = 0
					else
						driver.SCarThirdPView = 1
					end
					
					if GetConVarNumber("scar_thirdpersonview") == 0 then
						driver.SCarThirdPView = 0
					end
					
					
					driver:SetNetworkedInt( "SCarThirdPersonView", driver.SCarThirdPView )
				end				
			end		

		end
	end
end

function ENT:UpdateWheelTorqTractionStatus()
	self.WheelTorqTraction = 0
	
	for i = 1, self.NrOfTorqueWheels do
		if IsValid(self.TorqueWheels[i]) && self.TorqueWheels[i]:IsColliding() && self.TorqueWheels[i].IsDestroyed == false then
			self.WheelTorqTraction = self.WheelTorqTraction + (1 / self.NrOfTorqueWheels)
		end
	end
	
end

function ENT:UpdateWheelTurnTractionStatus()
	self.WheelTurnTraction = 0
	
	for i = 1, self.NrOfTurningWheels do
		if IsValid(self.TurningWheels[i]) && self.TurningWheels[i]:IsColliding() && self.TurningWheels[i].IsDestroyed == false then
			self.WheelTurnTraction = self.WheelTurnTraction + (1 / self.NrOfTurningWheels)
		end
	end
	
end

function ENT:GetAllTorqWheels()
	self.TorqueWheels = {}
	self.NrOfTorqueWheels = 0
	for i = 1, self.NrOfWheels do
		if IsValid(self.Wheels[i]) && self.WheelInfo[i].Torq == true then
			self.NrOfTorqueWheels = self.NrOfTorqueWheels + 1
			self.TorqueWheels[self.NrOfTorqueWheels] = self.Wheels[i]
		end
	end
end

function ENT:GetAllTurningWheels()
	self.TurningWheels = {}
	self.NrOfTurningWheels = 0
	for i = 1, self.NrOfWheels do
		if IsValid(self.Wheels[i]) && (self.WheelInfo[i].Steer == 1 or self.WheelInfo[i].Steer == -1) then
			self.NrOfTurningWheels = self.NrOfTurningWheels + 1
			self.TurningWheels[self.NrOfTurningWheels] = self.Wheels[i]
		end
	end
end

function ENT:FlipCar()
	
	local vel = self:GetPhysicsObject():GetVelocity():Length()

	if self.FlipDelay < CurTime() && vel < 200 then
		self.FlipDelay = CurTime() + 2
		self.FlipPos = self:GetPos() + Vector(0,0,100)
		self.IsFlipping = false
	end
end

function ENT:UpdateFlip()
	if self.FlipDelay > CurTime() then --Flip the car
	
		if self.IsFlipping == false then
			self.IsFlipping = true
			
			if IsValid( self.StabilizerConstaint ) then
				self.StabilizerConstaint:Remove()
			end			
			
			self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, Angle(0,0,0) , 0, (self:GetPhysicsObject():GetMass() * 1000))
		end
		
		local force = self.FlipPos.z - self:GetPos().z
	
		if force < 0 then force = 0 end
		
		
		local vel = self:GetPhysicsObject():GetVelocity()
		vel.z = 0
		self:GetPhysicsObject():ApplyForceCenter( Vector(0,0,1) * force * self:GetPhysicsObject():GetMass() / 5 + vel * -0.1)
		
		self:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity()*-0.1 )
	end
end

function ENT:AdjustKeepUpRightConstraint()
	
	local newStabilisation = self.Stabilisation * ( ( self.WheelTorqTraction + self.WheelTurnTraction ) / 2 )	
	
	if self.FlipDelay < CurTime() then	
		self.SlowAngVel = 0
		if IsValid( self.StabilizerConstaint ) then
			self.StabilizerConstaint:Remove()
			self.SlowAngVel = 1
		end	
		
		if newStabilisation > 0 && self.IsOn == true && self:HasDriver() then
			
			local trace = {}
			trace.start = self:GetPos() + self:GetUp() * self.SeatPos[1].z
			trace.endpos = self:GetPos() + (self:GetUp() * -500)
			trace.filter =  { self, self.Seats, self.Wheels }
			local tr = util.TraceLine( trace )	

			local newAng = tr.HitNormal:Angle()
			newAng.pitch = newAng.pitch + 90
			
			self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, newAng , 0, newStabilisation)
			self.SlowAngVel = 2
		end
	
		if self.SlowAngVel == 1 and IsValid(self:GetPhysicsObject()) then
			self:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity() * -0.9)
		end
	
	end
	
end

function ENT:ToggleHydraulics()

	if self.HydraulicActive == 1 && self.HandBrake == false then

	
		self:EmitSound("car/hydraulics.wav",50,math.random(50,150))
	
		for i = 1, self.NrOfWheels do	
			self:SetWheelHydraulics( i, self.HydraulicsToggle )
		end
		
		if self.HydraulicsToggle == true then
			self.HydraulicsToggle = false
		else
			self.HydraulicsToggle = true
		end	
	end
end

function ENT:SetGearEffect( geff )

	if self.IsOn == true then
		SCarGearExhaustHandler:KillEffect( self.EngineEffectName, self )
	end
	
	self.EngineEffectName = geff
	
	if self.IsOn == true then
		SCarGearExhaustHandler:InitEffect( self.EngineEffectName, self )
	end	
	
end


function ENT:SetWheelHydraulics( i, ExtendOrRetract )
	
	if IsValid( self.Wheels[i] ) && !self.Wheels[i].HydraulicsState == ExtendOrRetract && self.Wheels[i].IsDestroyed == false then
		
		local wheel = self.Wheels[i]
		local addAng = Angle(0,0,0)
		if wheel.IsFlat and IsValid(wheel.Rim) then
			wheel = wheel.Rim
			addAng = Angle(0,90,0)
		end
		
		local carVel = self:GetPhysicsObject():GetVelocity()
	
		local ang = self:GetAngles()
		self:SetAngles(Angle( 0, 0, 0 ))
		
		if self.WheelAxis[i]:IsValid() then
			self.WheelAxis[i]:Remove()
		end

		local height = 0	
	
		if self.NrOfWheels > 4 or i == 1 or i == 2 then
			height = self.HeightFront
		else	
			height = self.HeightRear
		end
	
		local wheelVel = wheel:GetPhysicsObject():GetVelocity()
		local newPos = Vector(0,0,0)
		local oldPos = wheel:GetPos()
		local oldAng = wheel:GetAngles()
				
		
		if ExtendOrRetract == true then
			newPos = self.WheelInfo[i].Pos + Vector(0,0, (height + self.HydraulicHeight))
		else
			newPos = self.WheelInfo[i].Pos + Vector(0,0,height)		
		end

		
		wheel:SetPos( self:GetPos() + (self:GetForward() * newPos.x) + (self:GetRight() * newPos.y) + (self:GetUp() * newPos.z))
		
		if self.WheelInfo[i].Side == false then
			wheel:SetAngles( self:GetAngles() + Angle(0,180,0) + addAng )
		else
			wheel:SetAngles( self:GetAngles() + addAng)
		end				
		
		if self.WheelInfo[i].Side == false then
			self.WheelAxis[i] = constraint.Axis( wheel, self, 0, 0, Vector(0,1,0) , newPos, 0, 0, 1, 0 )
		else
			self.WheelAxis[i] = constraint.Axis( wheel, self, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 1, 0 )	
		end	
		
		
		wheel:SetPos( oldPos )
		wheel:SetAngles( oldAng )	
		wheel:GetPhysicsObject():SetVelocity( wheelVel )
		
		self:SetAngles( ang )
		self:GetPhysicsObject():SetVelocity( carVel )

		self.Wheels[i].HydraulicsState = ExtendOrRetract
		
		return true
	end
	
	return false
end

function ENT:Alive()
	if self.CarHealth > 0 then return true end
	return false
end

function ENT:UpdateHydaulics( driver )

	
	if self.HydraulicActive == 1 && self.NrOfWheels <= 4 && SCarKeys:KeyDown(driver, "Hydraulics") && self.HandBrake == false then
	
		self.UsingHydraulics = true
	
			self.HydraulicsToggleSep[1] = true --Front Left wheel
			self.HydraulicsToggleSep[2] = true --Front Right wheel
			self.HydraulicsToggleSep[3] = true --Rear Left wheel
			self.HydraulicsToggleSep[4] = true --Rear Right wheel	
		
		if driver:KeyDown( IN_FORWARD ) && !driver:KeyDown( IN_BACK ) && driver:KeyDown( IN_MOVELEFT ) && !driver:KeyDown( IN_MOVERIGHT ) then --Forward left
			self.HydraulicsToggleSep[1] = false
			
		elseif driver:KeyDown( IN_FORWARD ) && !driver:KeyDown( IN_BACK ) && !driver:KeyDown( IN_MOVELEFT ) && driver:KeyDown( IN_MOVERIGHT ) then --Forward right
			self.HydraulicsToggleSep[2] = false
			
		elseif !driver:KeyDown( IN_FORWARD ) && driver:KeyDown( IN_BACK ) && driver:KeyDown( IN_MOVELEFT ) && !driver:KeyDown( IN_MOVERIGHT ) then --Back left
			self.HydraulicsToggleSep[3] = false
			
		elseif !driver:KeyDown( IN_FORWARD ) && driver:KeyDown( IN_BACK ) && !driver:KeyDown( IN_MOVELEFT ) && driver:KeyDown( IN_MOVERIGHT ) then --Back right
			self.HydraulicsToggleSep[4] = false
			
		elseif driver:KeyDown( IN_FORWARD ) && !driver:KeyDown( IN_BACK ) && !driver:KeyDown( IN_MOVELEFT ) && !driver:KeyDown( IN_MOVERIGHT ) then --Forward
			self.HydraulicsToggleSep[1] = false
			self.HydraulicsToggleSep[2] = false
			
		elseif !driver:KeyDown( IN_FORWARD ) && driver:KeyDown( IN_BACK ) && !driver:KeyDown( IN_MOVELEFT ) && !driver:KeyDown( IN_MOVERIGHT ) then --Back
			self.HydraulicsToggleSep[3] = false
			self.HydraulicsToggleSep[4] = false
			
		elseif !driver:KeyDown( IN_FORWARD ) && !driver:KeyDown( IN_BACK ) && driver:KeyDown( IN_MOVELEFT ) && !driver:KeyDown( IN_MOVERIGHT ) then --Left
			self.HydraulicsToggleSep[1] = false
			self.HydraulicsToggleSep[3] = false
		elseif !driver:KeyDown( IN_FORWARD ) && !driver:KeyDown( IN_BACK ) && !driver:KeyDown( IN_MOVELEFT ) && driver:KeyDown( IN_MOVERIGHT ) then --Right
			self.HydraulicsToggleSep[2] = false
			self.HydraulicsToggleSep[4] = false		
		end

		
		local makeSound = false
		local change = false
		
		for i = 1, 4 do	
			if self.HydraulicsToggle == true then
				if self.HydraulicsToggleSep[i] == true then
					self.HydraulicsToggleSep[i] = false
				else
					self.HydraulicsToggleSep[i] = true
				end
			end
			
			change = self:SetWheelHydraulics( i, self.HydraulicsToggleSep[i])
			
			if change == true then
				makeSound = true
			end
		end	
		
		if makeSound == true then
			self:EmitSound("car/hydraulics.wav",50,math.random(50,150))
		end
			
	else
		self.UsingHydraulics = false
	end
	
end

---------------------------STOOL FUNCS

function ENT:SetBreakForce(BreakForce)
	self.BreakForce = BreakForce
end

function ENT:SetReverseForce(ReverseForce)
	self.ReverseForce = ReverseForce
end

function ENT:SetReverseMaxSpeed(ReverseMaxSpeed)
	self.ReverseMaxSpeed = ReverseMaxSpeed
end

function ENT:SetTurboEffect(TurboEffect)
	self.TurboEffect = TurboEffect
end

function ENT:SetAcceleration(Acceleration)
	self.Acceleration = Acceleration
end

function ENT:SetSteerForce(SteerForce)
	self.SteerForce = SteerForce
end

function ENT:SetMaxSpeed(MaxSpeed)
	self.MaxSpeed = MaxSpeed
	
	self.RevScale = (self.MaxSpeed / self.NrOfGears)
end	

function ENT:SetNrOfGears(NrOfGears)
	self.NrOfGears = NrOfGears
	
	if self.NrOfGears < 1 then
		self.NrOfGears = 1
	end
	
	self.RevScale = (self.MaxSpeed / self.NrOfGears)
	self.GearRevChange = self.GearRevSpace / self.NrOfGears
end

function ENT:SetHornSound( HornSound )
	self.HornSound = HornSound
	
	if self.Horn and self.Horn.Stop then
		self.Horn:Stop()   
	end
	
	self.Horn = CreateSound(self,self.HornSound)
end


function ENT:SetEngineSound( DefaultSound )
	self.DefaultSound = DefaultSound
	
	self.StartSound:Stop()

	if string.find( self.DefaultSound, "%." ) == nil then
		self.StartSound = CreateAdvancedSCarSound( self, self.DefaultSound )
	else
		self.StartSound = CreateSound(self, self.DefaultSound)	
	end
	
	if self:HasDriver() then
		self.StartSound:Play()
	end
end

function ENT:SetSoftnesAll( SoftnesAll )
	self.SoftnesFront = SoftnesAll
	self.SoftnesRear = SoftnesAll

	local mass = self.DefaultSoftnesFront + self.SoftnesFront
	
	if mass < 1 then
		mass = 1
	end	

	for i = 1, self.NrOfWheels do	
		if IsValid(self.Wheels[i]) && self.Wheels[i].IsDestroyed == false then
			self.Wheels[i]:GetPhysicsObject():SetMass( mass )
		end
	end
end

function ENT:SetSoftnesFront(SoftnesFront)
	self.SoftnesFront = SoftnesFront
	
	
	if self.NrOfWheels > 4 then
		self:SetSoftnesAll( self.SoftnesFront )
	else
	
		local mass = self.DefaultSoftnesFront + self.SoftnesFront
		
		if mass < 1 then
			mass = 1
		end	
		
		for i = 1, 2 do	
			if IsValid(self.Wheels[i]) && self.Wheels[i].IsDestroyed == false then
				self.Wheels[i]:GetPhysicsObject():SetMass( mass )
			end
		end
	end	
	

end

function ENT:SetSoftnesRear(SoftnesRear)
	self.SoftnesRear = SoftnesRear
	
	
	if self.NrOfWheels > 4 then
		self:SetSoftnesAll( self.SoftnesFront )
	else
	
		local mass = self.DefaultSoftnesRear + self.SoftnesRear
		
		if mass < 1 then
			mass = 1
		end
	
		for i = 3, 4 do	
			if IsValid(self.Wheels[i]) && self.Wheels[i].IsDestroyed == false then
				self.Wheels[i]:GetPhysicsObject():SetMass( mass )
			end
		end	
	end
end

function ENT:SetHeightOne( id, height )
	self:ForceRemoveHandBrake()
	
	local ang = self:GetAngles()
	self:SetAngles(Angle( 0, 0, 0 ))
	
	local newPos = Vector(0,0,0)
	local oldPos = Vector(0,0,0)
	local oldAng = Angle(0,0,0)

	self.HeightFront = HeightAll
	self.HeightRear = HeightAll

	if self.WheelAxis[id]:IsValid() then
		self.WheelAxis[id]:Remove()
	end
	
	if IsValid( self.Wheels[id] ) && self.Wheels[id].IsDestroyed == false then
		newPos = self.WheelInfo[id].Pos + Vector(0,0,self.HeightFront)
		oldPos = self.Wheels[id]:GetPos()
		oldAng = self.Wheels[id]:GetAngles()
		
		self.Wheels[id]:SetPos( self:GetPos() + (self:GetForward() * newPos.x) + (self:GetRight() * newPos.y) + (self:GetUp() * newPos.z))
		
		if self.WheelInfo[id].Side == false then
			self.Wheels[id]:SetAngles( self:GetAngles() + Angle(0,180,0) )
		else
			self.Wheels[id]:SetAngles( self:GetAngles() )
		end				
		
		if self.WheelInfo[id].Side == false then
			self.WheelAxis[id] = constraint.Axis( self.Wheels[id], self, 0, 0, Vector(0,1,0) , newPos, 0, 0, 1, 0 )
		else
			self.WheelAxis[id] = constraint.Axis( self.Wheels[id], self, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 1, 0 )
		end	
		
		self.Wheels[id].WheelAxisConstraint = self.WheelAxis[id]
		
		self.Wheels[id]:SetPos( oldPos )
		self.Wheels[id]:SetAngles( oldAng )	
	end

	
	self:SetAngles( ang )
end

function ENT:SetHeightAll( HeightAll )

	self:ForceRemoveHandBrake()
	
	local ang = self:GetAngles()
	self:SetAngles(Angle( 0, 0, 0 ))
	
	local newPos = Vector(0,0,0)
	local oldPos = Vector(0,0,0)
	local oldAng = Angle(0,0,0)

	self.HeightFront = HeightAll
	self.HeightRear = HeightAll
	for i = 1, self.NrOfWheels do	
		
		if self.WheelAxis[i]:IsValid() then
			self.WheelAxis[i]:Remove()
		end
		
		if IsValid( self.Wheels[i] ) && self.Wheels[i].IsDestroyed == false then
			newPos = self.WheelInfo[i].Pos + Vector(0,0,self.HeightFront)
			oldPos = self.Wheels[i]:GetPos()
			oldAng = self.Wheels[i]:GetAngles()
			
			self.Wheels[i].AddHeight = self.HeightFront
			self.Wheels[i]:SetPos( self:GetPos() + (self:GetForward() * newPos.x) + (self:GetRight() * newPos.y) + (self:GetUp() * newPos.z))
			
			if self.WheelInfo[i].Side == false then
				self.Wheels[i]:SetAngles( self:GetAngles() + Angle(0,180,0) )
			else
				self.Wheels[i]:SetAngles( self:GetAngles() )
			end				
			
			if self.WheelInfo[i].Side == false then
				self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,1,0) , newPos, 0, 0, 1, 0 )
			else
				self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 1, 0 )
			end	
			
			self.Wheels[i].WheelAxisConstraint = self.WheelAxis[i]
			
			self.Wheels[i]:SetPos( oldPos )
			self.Wheels[i]:SetAngles( oldAng )	
		end
		
		self.WheelsHeight[i] = HeightAll
	end	
	
	self:SetAngles( ang )
end

function ENT:SetHeightFront(HeightFront)
	self.HeightFront = HeightFront

	
	if self.NrOfWheels > 4 then
		self:SetHeightAll( self.HeightFront )
	else

		self:ForceRemoveHandBrake()
		
		local ang = self:GetAngles()
		self:SetAngles(Angle( 0, 0, 0 ))
		
		local newPos = Vector(0,0,0)
		local oldPos = Vector(0,0,0)
		local oldAng = Angle(0,0,0)	
		
		for i = 1, 2 do	
			if self.WheelAxis[i] and self.WheelAxis[i]:IsValid() then
				self.WheelAxis[i]:Remove()
			end
			
			if IsValid( self.Wheels[i] ) && self.Wheels[i].IsDestroyed == false then
				newPos = self.WheelInfo[i].Pos + Vector(0,0,self.HeightFront)
				oldPos = self.Wheels[i]:GetPos()
				oldAng = self.Wheels[i]:GetAngles()
				
				self.Wheels[i].AddHeight = self.HeightFront
				self.Wheels[i]:SetPos( self:GetPos() + (self:GetForward() * newPos.x) + (self:GetRight() * newPos.y) + (self:GetUp() * newPos.z))
				
				if self.WheelInfo[i].Side == false then
					self.Wheels[i]:SetAngles( self:GetAngles() + Angle(0,180,0) )
				else
					self.Wheels[i]:SetAngles( self:GetAngles() )
				end				
				
				if self.WheelInfo[i].Side == false then
					self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,1,0) , newPos, 0, 0, 1, 0 )
				else
					self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 1, 0 )	
				end	
				
				self.Wheels[i].WheelAxisConstraint = self.WheelAxis[i]
				
				self.Wheels[i]:SetPos( oldPos )
				self.Wheels[i]:SetAngles( oldAng )	
			end
			
			self.WheelsHeight[i] = HeightFront
		end	
		
		self:SetAngles( ang )		
	end
end

function ENT:SetHeightRear(HeightRear)
	self.HeightRear = HeightRear
	
	if self.NrOfWheels > 4 then
		self:SetHeightAll( self.HeightFront )
	else

		self:ForceRemoveHandBrake()
		
		local ang = self:GetAngles()
		self:SetAngles(Angle( 0, 0, 0 ))
		
		local newPos = Vector(0,0,0)
		local oldPos = Vector(0,0,0)
		local oldAng = Angle(0,0,0)	
		
		for i = 3, 4 do	
			if self.WheelAxis[i] and self.WheelAxis[i] != NULL and self.WheelAxis[i]:IsValid() then
				self.WheelAxis[i]:Remove()
			end

			if IsValid( self.Wheels[i] ) && self.Wheels[i].IsDestroyed == false then
				newPos = self.WheelInfo[i].Pos + Vector(0,0,HeightRear)
				oldPos = self.Wheels[i]:GetPos()
				oldAng = self.Wheels[i]:GetAngles()
				
				self.Wheels[i].AddHeight = self.HeightRear
				self.Wheels[i]:SetPos( self:GetPos() + (self:GetForward() * newPos.x) + (self:GetRight() * newPos.y) + (self:GetUp() * newPos.z))
				
				if self.WheelInfo[i].Side == false then
					self.Wheels[i]:SetAngles( self:GetAngles() + Angle(0,180,0) )
				else
					self.Wheels[i]:SetAngles( self:GetAngles() )
				end				
				
				if self.WheelInfo[i].Side == false then
					self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,1,0) , newPos, 0, 0, 1, 0 )
				else
					self.WheelAxis[i] = constraint.Axis( self.Wheels[i], self, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 1, 0 )
				end	
				
				self.Wheels[i].WheelAxisConstraint = self.WheelAxis[i]
				
				self.Wheels[i]:SetPos( oldPos )
				self.Wheels[i]:SetAngles( oldAng )	
			end
			self.WheelsHeight[i] = HeightRear
		end	
		
		self:SetAngles( ang )			
	end
end

function ENT:ChangeOneWheel( ID, model, physMat, useOldPos)

	self.WheelsPhys[ID] = physMat
	self.WheelsModel[ID] = model
	self:ChangeWheel( self.TireModel , self.physMat, useOldPos, false )
	
end

function ENT:ChangeWheelAll( model, physMat, useOldPos, isRepair)

	for i = 1, self.NrOfWheels do
		if physMat then
			self.WheelsPhys[i] = physMat
		end
		
		if model then
			self.WheelsModel[i] = model
		end
	end
	
	self:ChangeWheel( model , physMat, useOldPos, isRepair )
end

function ENT:WheelsAreDamaged()
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] == NULL or !IsValid(self.Wheels[i]) or self.Wheels[i].IsFlat == true then
			return true
		end
	end
	return false
end

function ENT:ChangeWheel( model , physMat, useOldPos, isRepair )
	
	if model then
		self.TireModel = model
	end
	
	if physMat then
		self.physMat = physMat
	end
	
	local oldPos = Vector(0,0,0)
	local oldAng = Angle(0,0,0)
	local newPos = Vector(0,0,0)
	local obb1 = 0
	local obb2 = 0
	self:ForceRemoveHandBrake()
	
	local length = {}
	
	local change = false
	local angleFail = false
	
	for i = 1, self.NrOfWheels do
	
		length[i] = 0
	 

		if self.Wheels[i] == NULL or !IsValid(self.Wheels[i]) or self.Wheels[i].IsFlat == true or (isRepair == false && self.Wheels[i].TireModel != self.WheelsModel[i] or self.Wheels[i].physMat != self.WheelsPhys[i]) then

			change = true
		
			if self.WheelAxis[i] and self.WheelAxis[i]:IsValid() then
				self.WheelAxis[i]:Remove()
			end		
			
			if IsValid(self.Wheels[i]) then	
				if self.Wheels[i].IsFlat == false then
					local obbtemp = self.Wheels[i]:OBBMaxs( )
					obb1 = obbtemp.z
				else
					obb1 = 0
				end
			
				self.Wheels[i]:Remove()
				self.Wheels[i] = nil
			else
				obb1 = 0
			end
			
			angleFail = false
			
			if IsValid(self.Wheels[i]) && useOldPos == true && self.Wheels[i].IsFlat == false then
				oldPos = self.Wheels[i]:GetPos()
				oldAng = self.Wheels[i]:GetAngles()			
			elseif self.WheelInfo[i].Pos or useOldPos == false then
				oldPos = ( self:GetPos() + (self:GetForward() * self.WheelInfo[i].Pos.x) + (self:GetRight() * self.WheelInfo[i].Pos.y) + (self:GetUp() * self.WheelInfo[i].Pos.z))
				oldAng = Angle(0,0,0)
				angleFail = true
			end	
			
			if self.WheelInfo[i] && self.WheelInfo[i].Pos && (self.WheelInfo[i].Side == false or self.WheelInfo[i].Side == true) && (self.WheelInfo[i].Torq == true or self.WheelInfo[i].Torq == false) then
				
				if angleFail == true then
					if self.WheelInfo[i].Side == false then
						oldAng = self:GetAngles() + Angle(0,180,0)
					else
						oldAng = self:GetAngles()
					end				
				end

				self.Wheels[i] = ents.Create( "sent_sakarias_carwheel" )		
				self.Wheels[i]:SetPos( oldPos )
				self.Wheels[i]:SetAngles( oldAng )
				self.Wheels[i].SCarOwner = self	

				self.Wheels[i].TireModel = self.WheelsModel[i]
				self.Wheels[i].physMat = self.WheelsPhys[i]	


				self.WheelsPhys[i] = self.Wheels[i].physMat
				self.WheelsModel[i] = self.Wheels[i].TireModel
				self.Wheels[i].Steer = self.WheelInfo[i].Steer
				self.Wheels[i].Side = self.WheelInfo[i].Side
				self.Wheels[i].Pos = self.WheelInfo[i].Pos	
				self.Wheels[i].WheelID = i

				self.Wheels[i]:Spawn()	
				self.Wheels[i]:Activate()
				self.Wheels[i]:SetNetworkedEntity("SCarEnt", self)
				self:SetNetworkedEntity("SCarWheel"..i, self.Wheels[i])

	
				local obbtemp = self.Wheels[i]:OBBMaxs( )
				obb2 = obbtemp.z

				if obb1 != 0 then
					length[i] = obb2 - obb1
				else
					length[i] = obb2 * 2
				end
				construct.SetPhysProp( self.Owner,  self.Wheels[i], 0, nil, { GravityToggle = 1, Material = self.Wheels[i].physMat })
			end
		end
	end
	
	
	if change == true then
	if self.NrOfWheels > 4 then
		self:SetHeightAll( self.HeightFront )
		self:SetSoftnesAll( self.SoftnesFront )	
	else
		self:SetHeightFront( self.HeightFront )	
		self:SetHeightRear( self.HeightRear )

		self:SetSoftnesFront( self.SoftnesFront )
		self:SetSoftnesRear( self.SoftnesRear )
	end

	
	--Nocolliding all wheels
	for i = 1, self.NrOfWheels do
		if IsValid( self.Wheels[i] ) then
			constraint.NoCollide( self, self.Wheels[i], 0, 0 )
			for j = i + 1, self.NrOfWheels do
				if IsValid( self.Wheels[j] ) then
					constraint.NoCollide( self.Wheels[j], self.Wheels[i], 0, 0 )
				end
			end
			
			local tempPos = self.Wheels[i]:GetPos()
			tempPos.z = tempPos.z + length[i] + 5
			self.Wheels[i]:SetPos( tempPos )
		end
	end	
	
	self:GetAllTorqWheels()
	self:GetAllTurningWheels()	
	end
	
	self:SetWheelOwner( self.SpawnedBy )
end

function ENT:SetSuspensionAddHeight( SuspensionAddHeight )
	self.HydraulicHeight = SuspensionAddHeight
end

function ENT:SetHydraulicActive( Active )
	self.HydraulicActive = Active
end

function ENT:SetTurboDuration( TurboDuration )
	self.TurboDuration  = TurboDuration
end

function ENT:SetTurboDelay( TurboDelay )
	self.TurboDelay = TurboDelay
end

function ENT:SetCarHealth( CarHealth )
	self.CarMaxHealth = CarHealth
	self:Repair()
end

function ENT:IsDamaged()
	if self.CarHealth < self.CarMaxHealth then
		return true
	end
	
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] == NULL or !IsValid(self.Wheels[i]) or self.Wheels[i].IsFlat == true then
			return true
		end
	end
end

function ENT:Repair()

	if self.CarHealth > 0 and self.DamageLevel < 4 then
		self.SaveDamagedCol = self:GetColor()
	end

	if self:IsDamaged() then
		
		self.CarHealth = self.CarMaxHealth
		self.DamageLevel = 0
		
		if IsValid( self.DamageEffect ) then
			self.DamageEffect:Remove()
		end

		if IsValid( self.FireEffect ) then
			self.FireEffect:Remove()
		end	
		
		self:ChangeWheel( self.TireModel , self.physMat, true, true )
		self.FireSound:Stop()
		self:SetColor(self.SaveDamagedCol)
		self:UpdateVehicleHealthShared()
	end
end

function ENT:SetCanTakeDamage( CanTakeDamage, CanTakeWheelDamage )

	self.CanTakeDamage = CanTakeDamage
	self.CanTakeWheelDamage = CanTakeWheelDamage
	
	for i = 1, self.NrOfWheels do
		if IsValid(self.Wheels[i]) then
			self.Wheels[i]:SetCanTakeDamage( self.CanTakeWheelDamage )
		end
	end
end

function ENT:SetFuelConsumptionUse( FuelConsumptionUse )
	self.UsesFuelConsumption = FuelConsumptionUse	
end

function ENT:SetFuelConsumption( FuelConsumption )
	self.FuelConsumption = FuelConsumption	
end

function ENT:Refuel()
	self.Fuel = self.MaxFuel
end


function ENT:SetSteerResponse( SteerResponse )
	self.SteerResponse = SteerResponse
end

function ENT:SetStabilisation( Stabilisation )
	self.Stabilisation = Stabilisation
	
	if IsValid(self.StabilizerConstaint) then
		self.StabilizerConstaint:Remove()
	end
	
	local EntAng = self:GetAngles()
	
	if !IsValid(self.StabilizerProp) then
		SCarsReportError("SetStabilisation: Stabiliser wasn't valid. Trying to solve...")
		self:CreateStabilizer()	
		
		if IsValid(self.StabilizerProp) then
			SCarsReportError("\tStabilizer solved!")
		else
			SCarsReportError("\tUnable to solve stabilizer issue.")
		end
	end

	local StabAng = self.StabilizerProp:GetAngles()
	self:SetAngles(Angle( 0, 0, 0 ))	
	self.StabilizerProp:SetAngles(Angle( 0, 0, 0 ))	
	self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, Angle(0,0,0) , 0, self.Stabilisation)	
	self:SetAngles(EntAng)
	self.StabilizerProp:SetAngles(StabAng)				
end

function ENT:SetAntiSlide( AntiSlide )
	self.AntiSlide = AntiSlide
end

function ENT:SetAutoStraighten( AutoStraighten )
	self.AutoStraighten = AutoStraighten
end

function ENT:UpdateAllCharacteristics()

	if !game.SinglePlayer() and GetConVarNumber( "scar_carcharlimitation" ) == 1 then

		local NewAcceleration = GetConVarNumber("scar_acceleration")
		local NewMaxSpeed = GetConVarNumber("scar_maxspeed")
		local NewTurboEffect = GetConVarNumber("scar_turborffect")
		local NewTurboDuration = GetConVarNumber("scar_turboduration")
		local NewTurboDelay = GetConVarNumber("scar_turbodelay")
		local NewReverseForce = GetConVarNumber("scar_reverseforce")
		local NewReverseMaxSpeed = GetConVarNumber("scar_reversemaxspeed")
		local NewBreakEfficiency = GetConVarNumber("scar_breakEfficiency")
		local NewSteerForce = GetConVarNumber("scar_steerforce")
		local NewSteerResponse = GetConVarNumber("scar_steerresponse")
		local NewStabilisation = GetConVarNumber("scar_stabilisation")
		local NewNrOfGears = GetConVarNumber("scar_nrofgears")
		local NewuseRT = GetConVarNumber("scar_usert")
		local NewThirdPersonView = GetConVarNumber("scar_thirdpersonview")
		local NewFuelConsumptionUse = GetConVarNumber("scar_fuelconsumptionuse")
		local NewFuelConsumption = GetConVarNumber("scar_fuelconsumption")
		local NewHydraulicActive = GetConVarNumber("scar_allowHydraulics") 
		local NewCarHealth = GetConVarNumber("scar_maxhealth") 
		local NewCanTakeDamage = GetConVarNumber("scar_cardamage") 
		local NewCanTakeWheelDamage = GetConVarNumber("scar_tiredamage") 	
		local NewMaxAntiSlide = GetConVarNumber("scar_maxantislide")
		local NewMaxAutoStraighten = GetConVarNumber("scar_maxautostraighten")
		local NewMaxHydraulics = GetConVarNumber("scar_maxhydheight")
		
		if self.Acceleration > NewAcceleration then
			self.Acceleration = NewAcceleration
		end
		
		if self.MaxSpeed > NewMaxSpeed then
			self.MaxSpeed = NewMaxSpeed
			self.RevScale = (self.MaxSpeed / self.NrOfGears)
		end
		
		if self.TurboEffect > NewTurboEffect then
			self.TurboEffect = NewTurboEffect	
		end
		
		if self.TurboDuration > NewTurboDuration then
			self.TurboDuration = NewTurboDuration
		end
		
		if self.TurboDelay < NewTurboDelay then
			self.TurboDelay = NewTurboDelay
		end
		
		if self.ReverseForce > NewReverseForce then
			self.ReverseForce = NewReverseForce
		end
		
		if self.ReverseMaxSpeed > NewReverseMaxSpeed then
			self.ReverseMaxSpeed = NewReverseMaxSpeed 
		end
		
		if self.BreakForce > NewBreakEfficiency then
			self.BreakForce = NewBreakEfficiency
		end
		
		if self.SteerForce > NewSteerForce then
			self.SteerForce	= NewSteerForce
		end
		
		if self.SteerResponse > NewSteerResponse then
			self.SteerResponse = NewSteerResponse
		end
		
		if self.Stabilisation > NewStabilisation then
			self.Stabilisation = NewStabilisation	
		end
		
		if self.NrOfGears > NewNrOfGears then
			self.NrOfGears = NewNrOfGears
			self.RevScale = (self.MaxSpeed / self.NrOfGears)
		end
		
		if NewuseRT == 0 && self.useRT == 1 then
			self.useRT  = 0			
		end

		
		if self.AntiSlide > NewMaxAntiSlide then
			self.AntiSlide = NewMaxAntiSlide	
		end	

		if self.AutoStraighten > NewMaxAutoStraighten then
			self.AutoStraighten = NewMaxAutoStraighten
		end	

		if NewFuelConsumptionUse == 0 && self.UsesFuelConsumption == 0 then
			self.UsesFuelConsumption = 1			
		end
		
		if self.FuelConsumption < NewFuelConsumption then
			self.FuelConsumption = NewFuelConsumption		
		end
		
		if NewHydraulicActive == 0 && self.HydraulicActive == 1 then
			self.HydraulicActive = NewHydraulicActive	
		end
		
		if self.CarMaxHealth > NewCarHealth then
			self.CarHealth = NewCarHealth
			self.CarMaxHealth = NewCarHealth
			self:UpdateVehicleHealthShared()
		end
		
		if NewCanTakeDamage == 0 && self.CanTakeDamage == 0 then
			self.CanTakeDamage = 1
		end
		
		
		self.HydraulicHeight = math.Clamp(self.HydraulicHeight, 5, NewMaxHydraulics)
		
		if NewCanTakeWheelDamage == 0 && self.CanTakeWheelDamage == 0 then
			self.CanTakeWheelDamage = 1
			
			for i = 1, self.NrOfWheels do
				if IsValid(self.Wheels[i]) then
					self.Wheels[i]:SetCanTakeDamage( self.CanTakeWheelDamage )
				end
			end		
			
		end
	end
end

function ENT:Reposition()
	self:CheckStabiliserOffset()
	
	if !IsValid(self.StabilizerProp) then
		SCarsReportError("Reposition: Stabiliser wasn't valid. Trying to solve...")
		self:CreateStabilizer()
		
		if IsValid(self.StabilizerProp) then
			SCarsReportError("\tStabilizer solved!")
		else
			SCarsReportError("\tUnable to solve stabilizer issue.")
		end
	end
	
	self.StabilizerProp:SetPos(self:GetPos() + self.StabiliserOffset.x * self:GetForward() + self.StabiliserOffset.y * self:GetRight() + self.StabiliserOffset.z * self:GetUp() )	
	self.StabilizerProp:SetAngles(self:GetAngles())			
	
	for i = 1, self.NrOfWheels do
	
		if self.Wheels && self.Wheels[i] && self.WheelInfo[i] && self.WheelInfo[i].Pos && (self.WheelInfo[i].Side == false or self.WheelInfo[i].Side == true) && (self.WheelInfo[i].Torq == true or self.WheelInfo[i].Torq == false) then
		
			self.Wheels[i]:SetPos( self:GetPos() + (self:GetForward() * self.WheelInfo[i].Pos.x) + (self:GetRight() * self.WheelInfo[i].Pos.y) + (self:GetUp() * self.WheelInfo[i].Pos.z))
			if self.WheelInfo[i].Side == false then
				self.Wheels[i]:SetAngles( self:GetAngles() + Angle(0,180,0) )
			else
				self.Wheels[i]:SetAngles( self:GetAngles() )
			end
		end
	end

	for i = 1, self.NrOfSeats do
		if self.SeatPos[i] and self.Seats[i] then
			if self.SeatPos[i] then
				self.Seats[i]:SetPos( self:GetPos() + (self:GetForward() * self.SeatPos[i].x) + (self:GetRight() * self.SeatPos[i].y) + (self:GetUp() * self.SeatPos[i].z))
				self.Seats[i]:SetAngles(self:GetAngles() + Angle(0,-90,0))
			end	
		else
			SCarsReportError("Couldn't reposition steat nr "..self.NrOfSeats..". BAD SEAT NUMBER!", 255)
			SCarsReportError("Please send me som info when it happened and what you did!", 255)
			SCarsReportError("This shouldn't happen unless someone have done something bad with a car base.", 255)
		end
	end	
	
	if self.SpecialReposition then
		self:SpecialReposition()
	end

	
end

function ENT:RemoveAIController()
	if IsValid( self.AIController ) then
		self.AIController:RemoveCarConnection()
	end
end

function ENT:SetCarOwner( ply )
	SCarSetObjOwner(ply, self)
	
	for i = 1, self.NrOfSeats do
		SCarSetObjOwner(ply, self.Seats[i], true)
	end

	self:SetWheelOwner( ply )
	
	SCarSetObjOwner(ply, self.StabilizerProp, true )
end

function ENT:CPPIGetOwner()
	return self.SpawnedBy
end

function ENT:SetWheelOwner( ply )
	if ply and self.Wheels then
		for i = 1, self.NrOfWheels do
			if IsValid(self.Wheels[i]) then
				self.Wheels[i]:SetCarOwner( ply )
			else
				SCarsReportError("Couldn't set wheel owner on wheel nr "..i.."! Odd, you broke something?", 150)
			end
		end
	else
		SCarsReportError("Couldn't set wheel owner of SCars!", 150)
	end
end

function ENT:ShakePlayers( mag )
	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			local driver = self.Seats[i]:GetDriver()
			if driver:IsPlayer() then
				--Shake
				local shake = ents.Create( "env_shake" )
				shake:SetPos( driver:GetPos() + self.Seats[i]:GetUp() * 20)
				shake:SetKeyValue( "amplitude", mag * 10 )
				shake:SetKeyValue( "radius", 40  )
				shake:SetKeyValue( "frequency", "250" )
				shake:SetKeyValue( "duration", mag * 0.001 )
				shake:SetKeyValue( "amplitude", mag * 10 )
				shake:SetKeyValue( "spawnflags", "4" )
				shake:Spawn()
				shake:Fire( "StartShake", "", 0 )				
			end		
		end
	end
end

function ENT:AddOwnerShip(ply, ent)
	
	--Why haven't Garry fixed prop protection yet?
	--Should be standard
	--Oh well.

	--Simple prop protection
	if SPropProtection then
		SPropProtection.PlayerMakePropOwner(ply, ent)
	end
	
	--ASS prop protection
	ent:SetNetworkedEntity("ASS_Owner", ply)
	ent:SetVar( "ASS_Owner", ply )
	ent:SetVar("ASS_OwnerOverride", true)

	--Falcos prop protection
	ent.Owner = ply
	ent.OwnerID = ply:SteamID()
	
	--UPS prop protection
	gamemode.Call( "UPSAssignOwnership", ply, ent )	
	
end

function ENT:PlayerCanUseLock( ply )
	if self.SpawnedBy == ply then return true end
	return false
end

function ENT:IsLocked()
	return self.CarIsLocked
end

function ENT:DoLockEffect()
	self:EmitSound("car/CarLock.wav")

	self:FrontLightsOn( "255 255 0", "200", false )
	self:RearLightsOn( "255 255 0", "200" )
	
	timer.Create( "SCarLockTimerOne"..self:EntIndex(), 0.1, 1, function()
		if self.FrontLightsOn then
			self:FrontLightsOn( "255 255 0", "0", false )
			self:RearLightsOn( "255 255 0", "0" )
		
			
			timer.Create( "SCarLockTimerTwo"..self:EntIndex(), 0.1, 1, function()
				if self.FrontLightsOn then
					self:FrontLightsOn( "255 255 0", "200", false )
					self:RearLightsOn( "255 255 0", "200" )
					
					
					timer.Create( "SCarLockTimerThree"..self:EntIndex(), 0.1, 1, function()
						if self.FrontLightsOn then
							self:FrontLightsOn( "255 255 0", "0", false )
							self:RearLightsOn( "255 255 0", "0" )
						end
					end )
				end
			end )
		end
	end )	
end

function ENT:DoUnlockEffect()
	self:EmitSound("car/CarUnLock.wav")
	
	
	self:FrontLightsOn( "255 255 0", "200", false )
	self:RearLightsOn( "255 255 0", "200" )
	
	timer.Create( "SCarLockTimerOne"..self:EntIndex(), 0.1, 1, function()
		if self.FrontLightsOn then
			self:FrontLightsOn( "255 255 0", "0", false )
			self:RearLightsOn( "255 255 0", "0" )
		end
	end )
end

function ENT:Lock( useEffects )
	if self.CarIsLocked == false then
		self.CarIsLocked = true
		
		if useEffects then
			self:DoLockEffect()
		end
	end
end

function ENT:UnLock( useEffects )
	if self.CarIsLocked == true then
		self.CarIsLocked = false
		
		if useEffects then
			self:DoUnlockEffect()
		end
	end
end

function ENT:PreEntityCopy()
	self:Repair()
	--PreEntityCopy runs before the entity is copied
	--It runs after it have copied all constraints and props
	--We tell it to not copy certain props and that's why i have to save the id's so i can remove them later
	local dupeInfo = {}
	dupeInfo.removeId = {}
	local nr = 1

	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			dupeInfo.removeId[nr] = self.Seats[i]:EntIndex()
			nr = nr + 1
		end		
	end
		
	for i = 1, self.NrOfWheels do
		if IsValid(self.Wheels[i]) then
			dupeInfo.removeId[nr] = self.Wheels[i]:EntIndex()
			--Msg("Saved remove info Wheels "..i.." | "..dupeInfo.removeId[nr].."\n")
			nr = nr + 1
		end
	end
	
	dupeInfo.removeId[nr] = self.StabilizerProp:EntIndex()	

	--Saving information so we can make an exact copy
	local col = {}
	col = self:GetColor()

	dupeInfo.BreakForce 			= self.BreakForce
	dupeInfo.ReverseForce 			= self.ReverseForce
	dupeInfo.ReverseMaxSpeed 		= self.ReverseMaxSpeed
	dupeInfo.TurboEffect 			= self.TurboEffect
	dupeInfo.Acceleration 			= self.Acceleration
	dupeInfo.SteerForce 			= self.SteerForce
	dupeInfo.MaxSpeed 				= self.MaxSpeed
	dupeInfo.NrOfGears 				= self.NrOfGears
	dupeInfo.DefaultSound 			= self.DefaultSound
	dupeInfo.HornSound 				= self.HornSound
	dupeInfo.SoftnesFront 			= self.SoftnesFront
	dupeInfo.SoftnesRear 			= self.SoftnesRear
	dupeInfo.HeightFront 			= self.HeightFront
	dupeInfo.HeightRear 			= self.HeightRear
	dupeInfo.TireModel 				= self.TireModel
	dupeInfo.physMat 				= self.physMat
	dupeInfo.HydraulicHeight 		= self.HydraulicHeight
	dupeInfo.HydraulicActive 		= self.HydraulicActive
	dupeInfo.TurboDuration 			= self.TurboDuration
	dupeInfo.TurboDelay 			= self.TurboDelay
	dupeInfo.CarMaxHealth 			= self.CarMaxHealth
	dupeInfo.CanTakeDamage 			= self.CanTakeDamage
	dupeInfo.CanTakeWheelDamage 	= self.CanTakeWheelDamage
	dupeInfo.UsesFuelConsumption 	= self.UsesFuelConsumption
	dupeInfo.FuelConsumption 		= self.FuelConsumption
	dupeInfo.Fuel 					= self.Fuel
	dupeInfo.SteerResponse 			= self.SteerResponse
	dupeInfo.Stabilisation 			= self.Stabilisation
	dupeInfo.AntiSlide 				= self.AntiSlide
	dupeInfo.AutoStraighten 		= self.AutoStraighten
	dupeInfo.carMaterial			= self:GetMaterial()
	dupeInfo.skin					= self:GetSkin()
	dupeInfo.colr					= col.r
	dupeInfo.colg					= col.g
	dupeInfo.colb					= col.b
	dupeInfo.cola					= col.a
	dupeInfo.nrOfWheels				= self.NrOfWheels
	dupeInfo.NeonStayTime			= self.NeonStayTime
	dupeInfo.NeonFadeTime			= self.NeonFadeTime
	
	dupeInfo.NeonCol1_r				= self.NeonCol1.r
	dupeInfo.NeonCol1_g				= self.NeonCol1.g
	dupeInfo.NeonCol1_b				= self.NeonCol1.b
	
	dupeInfo.NeonCol2_r				= self.NeonCol2.r
	dupeInfo.NeonCol2_g				= self.NeonCol2.g
	dupeInfo.NeonCol2_b				= self.NeonCol2.b
	
	dupeInfo.NeonSize				= self.NeonSize
	dupeInfo.EngineEffectName		= self.EngineEffectName	

	
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] and self.Wheels[i] != NULL and IsValid(self.Wheels[i]) then
		
			dupeInfo["wheel_"..i.."_physMat"] = self.WheelsPhys[i]
			dupeInfo["wheel_"..i.."_model"]   	= self.WheelsModel[i]
			dupeInfo["wheel_"..i.."_material"] 	= self.Wheels[i]:GetMaterial()
			dupeInfo["wheel_"..i.."_skin"] 	= self.Wheels[i]:GetSkin()
			
			local col = {}
			col = self:GetColor()
	
			dupeInfo["wheel_"..i.."_colr"] = col.r
			dupeInfo["wheel_"..i.."_colg"] = col.g
			dupeInfo["wheel_"..i.."_colb"] = col.b
			dupeInfo["wheel_"..i.."_cola"] = col.a
		end
	end
	duplicator.StoreEntityModifier(self, "SCarDupeInfos", dupeInfo)
end



function ENT:PostEntityPaste( ply, ent, crEnt )
	--Removing all the seats and wheels the duplicator copied
	for k, v in pairs( ent.EntityMods.SCarDupeInfos.removeId ) do
		if crEnt[v] and crEnt[v] != NULL and IsValid(crEnt[v]) then
			crEnt[v]:Remove()
			--Msg("Removing stuff "..v.."\n")	
		end
	end

	local inf = ent.EntityMods.SCarDupeInfos

	self:SetBreakForce(inf.BreakForce)
	self:SetReverseForce(inf.ReverseForce )
	self:SetReverseMaxSpeed(inf.ReverseMaxSpeed)
	self:SetTurboEffect(inf.TurboEffect)
	self:SetAcceleration(inf.Acceleration)
	self:SetSteerForce(inf.SteerForce)
	self:SetMaxSpeed(inf.MaxSpeed)
	self:SetNrOfGears(inf.NrOfGears)
	self:SetEngineSound(inf.DefaultSound)
	self:SetHornSound( inf.HornSound )
	
	self:SetSoftnesFront(inf.SoftnesFront)
	self:SetSoftnesRear(inf.SoftnesRear)
	self:SetHeightFront(inf.HeightFront)
	self:SetHeightRear(inf.HeightRear)

	self:SetSuspensionAddHeight( inf.HydraulicHeight )
	self:SetHydraulicActive( inf.HydraulicActive )
	self:SetTurboDuration( inf.TurboDuration )
	self:SetTurboDelay( inf.TurboDelay )
	self:SetCarHealth( inf.CarMaxHealth )
	self:SetCanTakeDamage( inf.CanTakeDamage, inf.CanTakeWheelDamage )
	self:SetFuelConsumptionUse( inf.UsesFuelConsumption )
	self:SetFuelConsumption( inf.FuelConsumption )
	self:SetSteerResponse( inf.SteerResponse )
	self:SetStabilisation( inf.Stabilisation )
	self:SetAntiSlide( inf.AntiSlide )
	self:SetAutoStraighten( inf.AutoStraighten )
	
	self:SetMaterial( inf.carMaterial )
	self:SetSkin( inf.skin )
	
	self:SetColor( Color(inf.colr, inf.colg, inf.colb, inf.cola) )
	
	self.EngineEffectName = inf.EngineEffectName	
	--//Some people manage to get the some color values to be nil.
	--//No idea how.
	if inf.NeonCol1_r == nil then inf.NeonCol1_r = 0; SCarsReportError("NeonCol1_r was nil. How!? Solved.", 255); end
	if inf.NeonCol1_g == nil then inf.NeonCol1_g = 0; SCarsReportError("NeonCol1_g was nil. How!? Solved.", 255); end
	if inf.NeonCol1_b == nil then inf.NeonCol1_b = 0; SCarsReportError("NeonCol1_b was nil. How!? Solved.", 255); end
	if inf.NeonCol2_r == nil then inf.NeonCol2_r = 0; SCarsReportError("NeonCol2_r was nil. How!? Solved.", 255); end
	if inf.NeonCol2_g == nil then inf.NeonCol2_g = 0; SCarsReportError("NeonCol2_g was nil. How!? Solved.", 255); end
	if inf.NeonCol2_b == nil then inf.NeonCol2_b = 0; SCarsReportError("NeonCol1_r was nil. How!? Solved.", 255); end	
	self:SetNeonLights( inf.NeonSize, inf.NeonStayTime, inf.NeonFadeTime, Color(inf.NeonCol1_r,inf.NeonCol1_g,inf.NeonCol1_b,255), Color(inf.NeonCol2_r,inf.NeonCol2_g,inf.NeonCol2_b,255) )

	
	self:ChangeWheelAll( inf.TireModel, inf.physMat, true, false)
	
	for i = 1, inf.nrOfWheels do
		self.WheelsPhys[i] = inf["wheel_"..i.."_physMat"]
		self.WheelsModel[i] = inf["wheel_"..i.."_model"]	
	end
	self:ChangeWheelAll( nil, nil, true, false)
	
	for i = 1, inf.nrOfWheels do
		self.Wheels[i]:SetMaterial( inf["wheel_"..i.."_material"] )
		self.Wheels[i]:SetSkin( inf["wheel_"..i.."_skin"] )
		self.Wheels[i]:SetColor( Color(inf["wheel_"..i.."_colr"], inf["wheel_"..i.."_colg"], inf["wheel_"..i.."_colb"], inf["wheel_"..i.."_cola"]) )		
	end
	
	--Yes i really need a timer for this one.
	timer.Create( "FixSCarSpawnPos", 0.01, 1, function()
		self:SetPos(self:GetPos() + self:GetUp() * 10)
		self:SetCarOwner( ply )
	end)
	
	self:UpdateAllCharacteristics()
end

function ENT:KickOutPassengers()
	local result = false
	for i = 2, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			local driver = self.Seats[i]:GetDriver()
			if IsValid(driver) then
				driver:ExitVehicle()
				result = true
			end
		end
	end
	
	return result
end

function ENT:KickOutAllPassengers()
	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			local driver = self.Seats[i]:GetDriver()
			if IsValid(driver) then
				driver:ExitVehicle( )		
			end
		end
	end
end


function ENT:PrepareCarForSave()
	self:KickOutAllPassengers()

	self:FrontLightsOff()
	self:RearLightsOff()	
	
	
	for i = 1, self.NrOfSeats do
		if self.Seats[i] and self.Seats[i] != NULL and IsValid(self.Seats[i]) then
			self.Seats[i]:Remove()
			self.Seats[i] = nil
		end		
	end
		
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] and self.Wheels[i] != NULL and IsValid(self.Wheels[i]) then
			self.Wheels[i]:OnRemove() --Have to call it manually or gmod won't have time to do it before it saves

			self.Wheels[i]:Remove()
			self.Wheels[i] = nil
		end
	end	
	
	if self.StabilizerProp and self.StabilizerProp != NULL and IsValid(self.StabilizerProp) then
		self.StabilizerProp:Remove()
	end
	
end

function ENT:RestoreCarFromSave()
	for i = 1, self.NrOfSeats do
	
		if self.SeatPos[i] then
			self.Seats[i] = ents.Create("prop_vehicle_prisoner_pod")  
			self.Seats[i]:SetModel( "models/nova/airboat_seat.mdl" ) 
			self.Seats[i]:SetPos( self:GetPos() + (self:GetForward() * self.SeatPos[i].x) + (self:GetRight() * self.SeatPos[i].y) + (self:GetUp() * self.SeatPos[i].z))
			
			local addAng = Angle(0,0,0)
			
			if self.SeatAngOffset and self.SeatAngOffset[i] then
				addAng = self.SeatAngOffset[i]
			end
			
			self.Seats[i]:SetAngles(self:GetAngles() + Angle(0,-90,0) + addAng)
			self.Seats[i]:SetKeyValue("limitview", "0") 
			self.Seats[i]:SetColor(Color(255,255,255,0))
			self.Seats[i]:Spawn()  
			self.Seats[i]:Activate()
			self.Seats[i]:GetPhysicsObject():EnableGravity(false)
			self.Seats[i]:GetPhysicsObject():SetMass(1)
			self.Seats[i]:SetNotSolid( true )
			self.Seats[i]:GetPhysicsObject():EnableDrag(false)	
			self.Seats[i]:DrawShadow( false )
			self.Seats[i]:SetNoDraw( true )
			self.Seats[i].SCarGroup = true
			
			timer.Simple( 1, function()
				if self.Seats and IsValid(self.Seats[i]) then
					self.Seats[i]:SetNetworkedInt("SCarSeat", i)
					self.Seats[i]:SetNetworkedInt("SCarThirdPersonView", 0)
					self.Seats[i]:SetNetworkedEntity("SCarEnt", self)
				end
			end )
			
			self.Seats[i].IsScarSeat = true
			self.Seats[i].EntOwner = self
			self.Seats[i].SeatPosID = i
			self.Seats[i].DrivingAnimType = self.AnimType
			
			self.Seats[i].HandleAnimation = nil
			
			
			self.SeatWelds[i] = constraint.Weld( self, self.Seats[i], 0, 0, 0, true )
		else
			ply:PrintMessage( HUD_PRINTTALK, "SCAR TEMPLATE ERROR: SEAT position on slot nr "..i.." was not valid\n")
		end
	end
	
	--Stabilizer
	self:CheckStabiliserOffset()
	
	if self.StabilizerProp and self.StabilizerProp != NULL and IsValid(self.StabilizerProp) then
		self.StabilizerProp:Remove()
	end	
	
	self:CreateStabilizer()
	
	constraint.Weld( self, self.StabilizerProp, 0, 0, 0, true )
	self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, Angle(0,0,0) , 0, self.Stabilisation)		
	

	--Getting a fresh copy because after a save the entity will go back to use the global tables.
	local cpy1 = {}
	local cpy2 = {}
	for i = 1, self.NrOfWheels do
		cpy1[i] = self.WheelsPhys[i]
		cpy2[i] = self.WheelsModel[i]
	end

	self:ChangeWheelAll( self.TireModel, self.physMat, true, false)
	
	self.WheelsPhys = {}
	self.WheelsModel = {}

	for i = 1, self.NrOfWheels do
		self.WheelsPhys[i] = cpy1[i]
		self.WheelsModel[i] = cpy2[i]
	end	
	
	self:ChangeWheelAll( nil, nil, true, false)		
	
	local Players = player.GetAll()
	if Players and IsValid( Players[1] ) then
		Players[1]:AddCount( "SCar", self )	
			
		undo.Create("SCars")
		undo.AddEntity( self )
		undo.SetPlayer( Players[1] )
		undo.SetCustomUndoText( "Undone "..self.PrintName )
		undo.Finish()
			
		Players[1]:AddCleanup( "SCars", CarEnt )
	end	
end


function ENT:RestoreCarFromLoading()
	self.Seats = {}
	self.SeatWelds = {}
	self.Wheels = {}
	self.WheelAxis = {}
	self.HandBrakeConstraints = {}
	
	self.FrontLights = {}
	self.FrontLightsCentre = {}
	self.FrontLightsRt = {}
	self.RearLights = {}
	self.HydraulicsToggleSep = {}
	self.HydraulicsToggleSep[1] = false
	self.HydraulicsToggleSep[2] = false
	self.HydraulicsToggleSep[3] = false
	self.HydraulicsToggleSep[4] = false
	self.NoCollideWheelConstraints = {}
	
	
	self.WheelsHeight = {}
	self.TurningWheels = {}
	self.TorqueWheels = {}		
	
	
	if !self.HornSound then
		self.HornSound = "car/horn/horn1.wav"
	end

	self:RefreshSounds()	
	
	self:RestoreCarFromSave()

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
	phys:SetMass(self.CarMass)
	phys:EnableDrag(false)	
	construct.SetPhysProp( self.Owner,  self, 0, nil, { GravityToggle = 1, Material = "metal" })
	phys:SetBuoyancyRatio( 0.025 )	
	
	self.GearRevChange = self.GearRevSpace / self.NrOfGears
end
	
function ENT:SetCurrentRadioStation( name, url)
	self.RadioName = name
	self.RadioURL = url
	self:GivePassengersDriverStation()
end

function ENT:GivePassengersDriverStation()
	if self.RadioName and self.RadioName != "" and self.RadioURL and self.RadioURL != "" then
		for i = 1, self.NrOfSeats do
			if IsValid(self.Seats[i]) then
				local driver = self.Seats[i]:GetDriver()
				if IsValid(driver) then
					self:SendRadioInfo( self.RadioName, self.RadioURL, driver )
				end
			end
		end
	end
end

function ENT:SetNeonLights( size, stayTime, fadeTime, Col1, Col2 )
	self.NeonStayTime = stayTime
	self.NeonFadeTime = fadeTime
	self.NeonCol1 = Col1
	self.NeonCol2 = Col2
	self.NeonSize = size
	 
	self:SetNetworkedFloat( "NeonCol1r", Col1.r )
	self:SetNetworkedFloat( "NeonCol1g", Col1.g )
	self:SetNetworkedFloat( "NeonCol1b", Col1.b )
	self:SetNetworkedFloat( "NeonCol2r", Col2.r )
	self:SetNetworkedFloat( "NeonCol2g", Col2.g )
	self:SetNetworkedFloat( "NeonCol2b", Col2.b )
	
	self:SetNetworkedFloat( "NeonStayTime", self.NeonStayTime )
	self:SetNetworkedFloat( "NeonFadeTime", self.NeonFadeTime )
	self:SetNetworkedFloat( "NeonSize", self.NeonSize )	
end

function ENT:RefreshSounds()

	if self.SpecialRefreshSounds then
		self:SpecialRefreshSounds()
	end

	self.Horn   = CreateSound(self,self.HornSound)	
	self.OffSound   = CreateSound(self, self.TurnOffSoundDir)	
	self.Skid = CreateSound(self,"vehicles/v8/skid_highfriction.wav")	
	self.TurboStartSound = CreateSound(self, self.TurboStartSoundDir)	
	self.TurboStopSound = CreateSound(self, self.TurboOffSoundDir)	
	self.FireSound = CreateSound(self,"ambient/fire/fire_big_loop1.wav")	

	if string.find( self.DefaultSound, "%." ) == nil then
		self.StartSound = CreateAdvancedSCarSound( self, self.DefaultSound )
	else
		self.StartSound = CreateSound(self, self.DefaultSound)	
	end
	
end

function ENT:GetSteerPercent() --Returns a value between -1 to 1
	return self.SteerPercent
end

function ENT:GetRevPercent() --Returns a value between 0.16 (min rev) to 1
	return self.RevPercent
end

function ENT:GetFuelPercent() --Returns a value between 0 to 1
	return self.FuelPercent
end

function ENT:GetSpeedKPH() --Returns a the cars speed in kilometers per hour
	return self:GetVelocity():Length() / 14.49 --Convert valve units to kph
end

function ENT:GetSpeedMPH() --Returns a the cars speed in miles per hour
	return self:GetVelocity():Length() / 23.33 --Convert valve units to mph
end

--[[
MATH!
3500 units = 150mph
ValveSpeed / MPHSpeed = MPHDivider
3500 / 150 = 23.3333

ValveSpeed = 1000
ValveSpeed / MPHDivider = MPHSpeed
1000 / 23.3333 = 42.85

MPHSpeed * KPHModifier = KPHSpeed
42.85 * 1.609344 = 68.97

ValveSpeed / KPHDivider = KPHSpeed
1000 / KPHDivider = 68.97
1000 = 68.97 * KPHDivider
1000 / 68.97 = KPHDivider
KPHDivider = 14.49
--]]

function ENT:UpdateVehicleHealthShared()
	if self.CarHealth < 0 then self.CarHealth = 0 end
	self:SetNetworkedFloat( "VehicleHealth", self.CarHealth )
end

function ENT:GetVehicleHealth()
	return self.CarHealth
end

function ENT:SafeStopSound( snd )
	if snd.Stop then
		snd:Stop()
	else
		SCarsReportError("Couldn't stop sound for an unkown reason.")
	end
end

function ENT:CheckStabiliserOffset()
	if !self.StabiliserOffset or self.StabiliserOffset != NULL or !self.StabiliserOffset.x or !self.StabiliserOffset.y or !self.StabiliserOffset.z then
		SCarsReportError("StabiliserOffset wasn't valid. This is normal. Solving...")
		self.StabiliserOffset = Vector(0,0,20)
	end
end


function ENT:CreateStabilizer()
	if IsValid(self.StabilizerProp) then
		self.StabilizerProp:Remove()
	end
	
	self.StabilizerProp = ents.Create( "prop_physics" )
	self.StabilizerProp:SetModel("models/props_junk/sawblade001a.mdl")		
	self.StabilizerProp:SetPos(self:GetPos() + self.StabiliserOffset.x * self:GetForward() + self.StabiliserOffset.y * self:GetRight() + self.StabiliserOffset.z * self:GetUp() )
	self.StabilizerProp:SetOwner(self.Owner)		
	self.StabilizerProp:SetAngles(self:GetAngles())
	self.StabilizerProp:SetColor(Color(255,255,255,0))
	self.StabilizerProp:Spawn()
	self.StabilizerProp:Activate()
	self.StabilizerProp:GetPhysicsObject():EnableGravity(false)	
	self.StabilizerProp:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )	
	self.StabilizerProp:GetPhysicsObject():SetMass(self.StabilisationMultiplier)
	self.StabilizerProp:SetNotSolid( true )
	self.StabilizerProp:SetNoDraw( true )
	self.StabilizerProp:GetPhysicsObject():EnableDrag(false)	
	self.StabilizerProp.SCarGroup = true
end


















