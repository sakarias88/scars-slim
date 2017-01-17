ENT.Base = "sent_sakarias_scar_base"
ENT.Type = "anim"

ENT.PrintName		= "Junker1"
ENT.Author			= "Sakarias88"
ENT.Category 		= "Junk"
ENT.Information 	= "" 
ENT.AdminOnly		= false


ENT.AddSpawnHeight = 37
ENT.ViewDist = 200
ENT.ViewDistUp = 30


ENT.NrOfSeats = 2
ENT.NrOfWheels = 4
ENT.NrOfExhausts = 1
ENT.NrOfFrontLights = 2
ENT.NrOfRearLights = 2

ENT.SeatPos = {}
ENT.WheelInfo = {}
ENT.ExhaustPos = {}
ENT.FrontLightsPos = {}
ENT.RearLightsPos = {}

ENT.effectPos = NULL

ENT.DefaultSoftnesFront = 15
ENT.DefaultSoftnesRear = 15
ENT.CarMass = 500
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 70 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/props_vehicles/car002b.mdl"
ENT.TireModel = "models/props_vehicles/carparts_wheel01a.mdl"
ENT.AnimType = 1 --1 = jeep anim, 2 = airboat anim
ENT.EngineEffectName = "Junk Car"
ENT.FrontLightColor = "220 220 160" --RGB

--[[
ENT.DependencyNotice = "Needs some special stuff"
ENT.EntityDependency = {"sent_sakarias_car_junker2", "sent_sakarias_car_junker3"}
--]]

for i = 1, ENT.NrOfWheels do
	ENT.WheelInfo[i] = {}
end

local xPos = 0
local yPos = 0
local zPos = 0

//Meters
ENT.SpeedoInfo = {}
ENT.SpeedoInfo.Model = "Dir to the needle you want to use"
ENT.SpeedoInfo.Pos = Vector(0,20,1) --Local pos of the needle
ENT.SpeedoInfo.Ang = Angle(0,24,51) --Local angle of the needle
ENT.SpeedoInfo.TurnDegrees = 180 --The number of degrees you want it to be able to turn

//SEAT POSITIONS
--Seat Position 1 (Driver seat)
xPos = -5.5
yPos = -11.5
zPos = -12
ENT.SeatPos[1] = Vector(xPos, yPos, zPos)

--Seat Position 2 (Right front seat)
xPos = -5.5
yPos = 13
zPos = -12
ENT.SeatPos[2] = Vector(xPos, yPos, zPos)



//WHEEL POSITIONS

--Side false = Left
--Side true = Right
--Torq true = spins
--Torq false = do not spin

--The two first wheels should be the front ones.
--The third and fourth wheel should be the rear ones.
--You can have more wheels but the suspension adjuster stool will set the suspension softness to the middle value between the front and rear softness.

--Front Left wheel
xPos = 46
yPos = -28
zPos = -20 	
ENT.WheelInfo[1].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[1].Side = false
ENT.WheelInfo[1].Torq = true
ENT.WheelInfo[1].Steer = 1

--Front Right wheel
xPos = 46
yPos = 32
zPos = -20		
ENT.WheelInfo[2].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[2].Side = true
ENT.WheelInfo[2].Torq = true
ENT.WheelInfo[2].Steer = 1

--Rear Left wheel
xPos = -46
yPos = -28
zPos = -20	
ENT.WheelInfo[3].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[3].Side = false
ENT.WheelInfo[3].Torq = false
ENT.WheelInfo[3].Steer = 0

--Rear Right wheel
xPos = -46
yPos = 32
zPos = -20	
ENT.WheelInfo[4].Pos  =  Vector( xPos, yPos, zPos )
ENT.WheelInfo[4].Side = true
ENT.WheelInfo[4].Torq = false
ENT.WheelInfo[4].Steer = 0




//LIGHT POSITIONS	

--//Front Lights
--Left
xPos = 68
yPos = -27
zPos = 3	
ENT.FrontLightsPos[1] = Vector(xPos, yPos, zPos)

--Right
xPos = 68
yPos = 31
zPos = 1	
ENT.FrontLightsPos[2] = Vector(xPos, yPos, zPos)


--//Rear Lights
--Left
xPos = -82
yPos = -29
zPos = 2
ENT.RearLightsPos[1] = Vector(xPos, yPos, zPos)

--Right
xPos = -82
yPos = 32
zPos = 1	
ENT.RearLightsPos[2] = Vector(xPos, yPos, zPos)






--The position where the fire and smoke effects will be placed when the car is damaged
xPos = 47
yPos = 0
zPos = 10	
ENT.effectPos = Vector(xPos, yPos, zPos)

--The position of the exhaust
xPos = -72
yPos = -20
zPos = -18				
ENT.ExhaustPos[1] = Vector(xPos, yPos, zPos)

//SUSPENSION
--The higher the number is the harder the suspension will be
--Recommend not to change these numbers
ENT.DefaultSoftnesFront = 19
ENT.DefaultSoftnesRear = 19	

ENT.DefaultAcceleration = 2000
ENT.DefaultMaxSpeed = 1000
ENT.DefaultTurboEffect = 2
ENT.DefaultTurboDuration = 4
ENT.DefaultTurboDelay = 10
ENT.DefaultReverseForce = 1000
ENT.DefaultReverseMaxSpeed = 200
ENT.DefaultBreakForce = 2000
ENT.DefaultSteerForce = 4
ENT.DefautlSteerResponse = 0.2
ENT.DefaultStabilisation = 2000
ENT.DefaultNrOfGears = 4
ENT.DefaultAntiSlide = 20
ENT.DefaultAutoStraighten = 8

ENT.DeafultSuspensionAddHeight = 0
ENT.DefaultHydraulicActive = 0
------------------------------------VARIABLES END

list.Set( "SCarsList", ENT.PrintName, ENT )

function ENT:Initialize()
	
	--Setting up the SCar in the SCar base
	self:Setup()	

	if (SERVER) then
		--Setting up the car characteristics
		self:SetAcceleration( self.DefaultAcceleration )
		self:SetMaxSpeed( self.DefaultMaxSpeed )
		
		self:SetTurboEffect( self.DefaultTurboEffect )
		self:SetTurboDuration( self.DefaultTurboDuration )
		self:SetTurboDelay( self.DefaultTurboDelay )
		
		self:SetReverseForce( self.DefaultReverseForce )
		self:SetReverseMaxSpeed( self.DefaultReverseMaxSpeed )
		self:SetBreakForce( self.DefaultBreakForce )
		
		self:SetSteerForce( self.DefaultSteerForce )
		self:SetSteerResponse( self.DefautlSteerResponse )
		
		self:SetStabilisation( self.DefaultStabilisation )
		self:SetNrOfGears( self.DefaultNrOfGears )
		self:SetAntiSlide( self.DefaultAntiSlide )
		self:SetAutoStraighten( self.DefaultAutoStraighten )	
		
		self:SetSuspensionAddHeight( self.DeafultSuspensionAddHeight )
		self:SetHydraulicActive( self.DefaultHydraulicActive )	
	end
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
