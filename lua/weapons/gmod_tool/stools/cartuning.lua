
TOOL.Category		= "SCars"
TOOL.Name			= "#Tuner"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
	BreakEfficiency    = "10",
	ReverseForce   = "1000",
	ReverseMaxSpeed = "200",
	TurboEffect = "2",
	TurboDuration = "5",
	TurboDelay = "5",
	Acceleration = "3000",
	SteerForce = "5",
	MaxSpeed = "1500",
	NrOfGears = "5",
	soundname = "vehicles/Airboat/fan_motor_idle_loop1.wav",
	hornsoundname = "car/horn/car_horn1.wav",
	useRT = "0",
	SteerResponse = "0.3",
	Stabilisation = "0",
	ThirdPersonView = "0",
	CameraCorrection = "0",
	AntiSlide = "0",
	AutoStraighten = "0",
}


if CLIENT then
	language.Add( "Tool_Car_BreakEfficiency", "Brake Force" )
	language.Add( "Tool_Car_ReverseForce", "Reverse Power:" )	
	language.Add( "Tool_Car_ReverseMaxSpeed", "Reverse Max Speed:" )		
	language.Add( "Tool_Car_TurboEffect", "Turbo Effect (multiplier):" )
	language.Add( "Tool_Car_TurboDuration", "Turbo Duration (in seconds):" )
	language.Add( "Tool_Car_TurboDelay", "Turbo Delay (in seconds):" )	
	language.Add( "Tool_Car_Acceleration", "Power:" )
	language.Add( "Tool_Car_SteerForce", "Steer Force:" )	
	language.Add( "Tool_Car_MaxSpeed", "Max Speed:" )
	language.Add( "Tool_Car_NrOfGears", "Nr Of Gears:" )		

	language.Add( "Tool_Car_SteerResponse", "Steer Response:" )	
	language.Add( "Tool_Car_Stabilisation", "Stabilisation:" )	
	language.Add( "Tool_Car_AntiSlide", "AntiSlide:" )	
	language.Add( "Tool_Car_AutoStraighten", "AutoStraighten:" )	
	
	language.Add( "Tool_Car_rtlamps", "Use RT lamps" )
	language.Add( "Tool_Car_rtlamps_desc", "Turn RT lamps on or off" )
	
	language.Add( "Tool_Car_hud", "Use HUD" )
	language.Add( "Tool_Car_hud_desc", "Turn the HUD on or off" )

	language.Add( "Tool_Car_ThirdPersonView", "Use Third Person View" )
	language.Add( "Tool_Car_ThirdPersonView_desc", "Turn the third person view on or off" )

	language.Add( "Tool_Car_CameraCorrection", "Use Camera Correction" )
	language.Add( "Tool_Car_CameraCorrection_desc", "Camera Correction will help you turn your head" )
	
	language.Add( "Tool.cartuning.name", "Car Tuner" )
	language.Add( "Tool.cartuning.desc", "Can tune cars with it" )
	language.Add( "Tool.cartuning.0", "Primary fire to paste and secondary fire to copy" )
	
end

function TOOL:LeftClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end
	
	local pos =  trace.Entity:WorldToLocal( trace.HitPos )
	
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_cartuning", ply) then return false end	
	

	if trace.Entity:IsValid()  then

		//Getting all the values and check all limitations
		local BreakEfficiency   = self:GetClientNumber( "BreakEfficiency" )
		local ReverseForce   = self:GetClientNumber( "ReverseForce" )
		local ReverseMaxSpeed = self:GetClientNumber( "ReverseMaxSpeed" )
		local TurboEffect = self:GetClientNumber( "TurboEffect" )
		local TurboDuration = self:GetClientNumber( "TurboDuration" )
		local TurboDelay = self:GetClientNumber( "TurboDelay" )
		local Acceleration = self:GetClientNumber( "Acceleration" )
		local SteerForce = self:GetClientNumber( "SteerForce" )
		local MaxSpeed = self:GetClientNumber( "MaxSpeed" )
		local NrOfGears = self:GetClientNumber( "NrOfGears" ) 
		--local EngineSound = self:GetClientInfo( "soundname" )
		--local HornSound = self:GetClientInfo( "hornsoundname" )
		local useRT = self:GetClientNumber( "useRT" )
		local SteerResponse = self:GetClientNumber( "SteerResponse" )
		local Stabilisation =  self:GetClientNumber( "Stabilisation" )
		local ThirdPersonView =  self:GetClientNumber( "ThirdPersonView" )
		local CameraCorrection = self:GetClientNumber( "CameraCorrection" )
		local AntiSlide = self:GetClientNumber( "AntiSlide" )
		local AutoStraighten = self:GetClientNumber( "AutoStraighten" )
		
		if SteerForce < 0.01 then
			SteerForce = 0.01
		end
		
		if !game.SinglePlayer() and GetConVarNumber( "scar_carcharlimitation" ) == 1 then
			local LimitMaxBreakEfficiency   = GetConVarNumber( "scar_breakefficiency" )--Max Break Efficiency
			local LimitMaxReverseForce   = GetConVarNumber( "scar_reverseforce" )--Max Reverse Force
			local LimitMaxReverseSpeed = GetConVarNumber( "scar_reversemaxspeed" )--Max Reverse Speed
			local LimitMaxTurboEffect = GetConVarNumber( "scar_turborffect" )--Max Turbo Effect
			local LimitMaxTurboDuration = GetConVarNumber( "scar_turboduration" )--Max Turbo Duration
			local LimitMinTurboDelay = GetConVarNumber( "scar_turbodelay" )--Min Turbo Delay
			local LimitMaxAcceleration = GetConVarNumber( "scar_acceleration" )--Max Acceleration
			local LimitMaxSteerForce = GetConVarNumber( "scar_steerforce" )--Max Steer Force
			local LimitMaxSpeed = GetConVarNumber( "scar_maxspeed" )--Max Speed
			local LimitMaxNumberofGears = GetConVarNumber( "scar_nrofgears" )--Min Number of Gears
			local LimitAllowRT = GetConVarNumber( "scar_usert" )--Allow RT
			local LimitMaxSteerResponse = GetConVarNumber( "scar_steerresponse" )--Max Steer Response
			local LimitMaxStabilisation =  GetConVarNumber( "scar_stabilisation" )--Max Stabilisation
			local LimitAllowThirdPersonView =  GetConVarNumber( "scar_thirdpersonview" )--Allow Third Person View
			local LimitMaxAntiSlide = GetConVarNumber("scar_maxantislide")--Max Anti Slide
			local LimitMaxAutoStraighten = GetConVarNumber("scar_maxautostraighten")--Max AutoStraighten
			local maxAcc = GetConVarNumber("SCar_Acceleration")
			
			if BreakEfficiency > LimitMaxBreakEfficiency then
				BreakEfficiency = LimitMaxBreakEfficiency
				--ply:PrintMessage( HUD_PRINTTALK, "BREAK EFFICIENCY limit: "..LimitMaxBreakEfficiency)
			end
			
			if ReverseForce > LimitMaxReverseForce then
				ReverseForce = LimitMaxReverseForce
				--ply:PrintMessage( HUD_PRINTTALK, "REVERSE FORCE limit: "..LimitMaxReverseForce)
			end
			
			if ReverseMaxSpeed > LimitMaxReverseSpeed then
				ReverseMaxSpeed = LimitMaxReverseSpeed
				--ply:PrintMessage( HUD_PRINTTALK, "REVERSE MAX SPEED limit: "..LimitMaxReverseSpeed)
			end
			
			if TurboEffect > LimitMaxTurboEffect then 
				TurboEffect = LimitMaxTurboEffect
				--ply:PrintMessage( HUD_PRINTTALK, "TURBO EFFECT limit: "..LimitMaxTurboEffect)
			end
			
			if TurboDuration > LimitMaxTurboDuration then
				TurboDuration = LimitMaxTurboDuration
				--ply:PrintMessage( HUD_PRINTTALK, "TURBO DURATION limit: "..LimitMaxTurboDuration)
			end
			
			if TurboDelay < LimitMinTurboDelay then
				TurboDelay = LimitMinTurboDelay
				--ply:PrintMessage( HUD_PRINTTALK, "MIN TURBO DELAY limit: "..LimitMinTurboDelay)			
			end
			
			if Acceleration > LimitMaxAcceleration then
				Acceleration = LimitMaxAcceleration
				--ply:PrintMessage( HUD_PRINTTALK, "ACCELERATION limit: "..LimitMaxAcceleration)				
			end
			
			if SteerForce > LimitMaxSteerForce then
				SteerForce = LimitMaxSteerForce
				--ply:PrintMessage( HUD_PRINTTALK, "STEER FORCE limit: "..LimitMaxSteerForce)				
			end
			
			if MaxSpeed > LimitMaxSpeed then
				MaxSpeed = LimitMaxSpeed
				--ply:PrintMessage( HUD_PRINTTALK, "MAX SPEED limit: "..LimitMaxSpeed)				
			end
			
			if NrOfGears > LimitMaxNumberofGears then
				NrOfGears = LimitMaxNumberofGears
				--ply:PrintMessage( HUD_PRINTTALK, "MIN GEARS limit: "..LimitMaxNumberofGears)				
			end
			
			if useRT == 1 && LimitAllowRT == 0 then
				useRT = 0
				--ply:PrintMessage( HUD_PRINTTALK, "RT Lamps not allowed!")				
			end
			
			
			if SteerResponse > LimitMaxSteerResponse then
				SteerResponse = LimitMaxSteerResponse
				--ply:PrintMessage( HUD_PRINTTALK, "STEER RESPONSE limit: "..LimitMaxSteerResponse)				
			end
			
			if Stabilisation > LimitMaxStabilisation then
				Stabilisation = LimitMaxStabilisation
				--ply:PrintMessage( HUD_PRINTTALK, "STABILISATION limit: "..LimitMaxStabilisation)				
			end
			
			if ThirdPersonView == 1 && LimitAllowThirdPersonView == 0 then
				ThirdPersonView = 0
				--ply:PrintMessage( HUD_PRINTTALK, "Third Person View not allowed!")				
			end		
		
			if AntiSlide > LimitMaxAntiSlide then
				AntiSlide = LimitMaxAntiSlide
			end

			if AutoStraighten > LimitMaxAutoStraighten then
				AutoStraighten = LimitMaxAutoStraighten
			end
			
			if Acceleration > maxAcc then 
				Acceleration = maxAcc 
			end
		
		end

		trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))
		trace.Entity:SetBreakForce( BreakEfficiency )
		trace.Entity:SetReverseForce( ReverseForce )	
		trace.Entity:SetReverseMaxSpeed( ReverseMaxSpeed )
		trace.Entity:SetTurboEffect( TurboEffect )
		trace.Entity:SetTurboDuration( TurboDuration )	
		trace.Entity:SetTurboDelay( TurboDelay )
		trace.Entity:SetAcceleration( Acceleration )
		trace.Entity:SetSteerForce( SteerForce )
		trace.Entity:SetMaxSpeed( MaxSpeed )
		trace.Entity:SetNrOfGears( NrOfGears )
		--trace.Entity:SetHornSound( HornSound )
		--trace.Entity:SetEngineSound( EngineSound )
		trace.Entity:SetSteerResponse( SteerResponse )
		trace.Entity:SetStabilisation( Stabilisation )
		trace.Entity:SetAntiSlide( AntiSlide )
		trace.Entity:SetAutoStraighten( AutoStraighten )	

		return true

	end
	return true

end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	
	if trace.Entity:IsValid() && trace.Entity != NULL && trace.Entity != nil then

		local BreakEfficiency   = trace.Entity.BreakForce
		local ReverseForce   = trace.Entity.ReverseForce
		local ReverseMaxSpeed = trace.Entity.ReverseMaxSpeed
		local TurboEffect = trace.Entity.TurboEffect
		local TurboDuration = trace.Entity.TurboDuration
		local TurboDelay = trace.Entity.TurboDelay			
		local Acceleration = trace.Entity.Acceleration
		local SteerForce = trace.Entity.SteerForce
		local MaxSpeed = trace.Entity.MaxSpeed
		local NrOfGears = trace.Entity.NrOfGears
		local useRT = trace.Entity.useRT		

		local SteerResponse = trace.Entity.SteerResponse
		local Stabilisation = trace.Entity.Stabilisation
		local ThirdPersonView = trace.Entity.ThirdPersonView		
		local CameraCorrection = trace.Entity.CameraCorrection
		local AntiSlide = trace.Entity.AntiSlide
		local AutoStraighten = trace.Entity.AutoStraighten
		
		self:GetOwner():ConCommand("cartuning_BreakEfficiency "..BreakEfficiency)
		self:GetOwner():ConCommand("cartuning_ReverseForce "..ReverseForce)
		self:GetOwner():ConCommand("cartuning_ReverseMaxSpeed "..ReverseMaxSpeed)
		self:GetOwner():ConCommand("cartuning_TurboEffect "..TurboEffect)
		self:GetOwner():ConCommand("cartuning_TurboDuration "..TurboDuration)
		self:GetOwner():ConCommand("cartuning_TurboDelay "..TurboDelay)
		self:GetOwner():ConCommand("cartuning_Acceleration "..Acceleration)
		self:GetOwner():ConCommand("cartuning_SteerForce "..SteerForce)		
		self:GetOwner():ConCommand("cartuning_MaxSpeed "..MaxSpeed)
		self:GetOwner():ConCommand("cartuning_NrOfGears "..NrOfGears)
		self:GetOwner():ConCommand("cartuning_SteerResponse "..SteerResponse)
		self:GetOwner():ConCommand("cartuning_Stabilisation "..Stabilisation)
		self:GetOwner():ConCommand("cartuning_AntiSlide "..AntiSlide)		
		self:GetOwner():ConCommand("cartuning_AutoStraighten "..AutoStraighten)			
		return true
	end
	
	
	return true
end

function TOOL.BuildCPanel( CPanel )
	
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_Acceleration",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 10000,
									 Command = "cartuning_Acceleration" } )		
								 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_MaxSpeed",
									 Description = "",
									 Type = "float",
									 Min = 10,
									 Max = 5000,
									 Command = "cartuning_MaxSpeed" } )	

CPanel:AddControl( "Label", { Text = "________________________________________\n", Description = "" } )	

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_TurboEffect",
									 Description = "",
									 Type = "float",
									 Min = 1,
									 Max = 5,
									 Command = "cartuning_TurboEffect" } )

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_TurboDuration",
									 Description = "",
									 Type = "float",
									 Min = 1,
									 Max = 10,
									 Command = "cartuning_TurboDuration" } )

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_TurboDelay",
									 Description = "",
									 Type = "float",
									 Min = 1,
									 Max = 60,
									 Command = "cartuning_TurboDelay" } )									 
									 
									 
CPanel:AddControl( "Label", { Text = "________________________________________\n", Description = "" } )										 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_ReverseForce",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 5000,
									 Command = "cartuning_ReverseForce" } )					 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_ReverseMaxSpeed",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 1000,
									 Command = "cartuning_ReverseMaxSpeed" } )								 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_BreakEfficiency",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 5000,
									 Command = "cartuning_BreakEfficiency" } )
									 
CPanel:AddControl( "Label", { Text = "________________________________________\n", Description = "" } )											 
					 								 									 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_SteerForce",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 20,
									 Command = "cartuning_SteerForce" } )										 

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_SteerResponse",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 2,
									 Command = "cartuning_SteerResponse" } )										 

CPanel:AddControl( "Label", { Text = "________________________________________\n", Description = "" } )

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_Stabilisation",
									 Description = "",
									 Type = "int",
									 Min = 0,
									 Max = 4000,
									 Command = "cartuning_Stabilisation" } )									 		 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_NrOfGears",
									 Description = "",
									 Type = "int",
									 Min = 1,
									 Max = 10,
									 Command = "cartuning_NrOfGears" } )									 

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_AntiSlide",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 100,
									 Command = "cartuning_AntiSlide" } )			

	CPanel:AddControl( "Slider", { Label = "#Tool_Car_AutoStraighten",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 50,
									 Command = "cartuning_AutoStraighten" } )

		--[[								 
	CPanel:AddControl( "Label", { Text = "Engine sound", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#Tool_Car_Sounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "SCarEngineSounds" ) } )			

	CPanel:AddControl( "Label", { Text = "Horn sound", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#Tool_Car_HornSounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "SCarHornSounds" ) } )	
--]]									 
end