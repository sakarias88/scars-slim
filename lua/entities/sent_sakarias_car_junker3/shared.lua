ENT.Base = "sent_sakarias_scar_base"
ENT.Type = "anim"

ENT.PrintName		= "Junker3"
ENT.Author			= "Sakarias88"
ENT.Category 		= "Junk"
ENT.Information 	= ""  
ENT.AdminOnly		= false


ENT.AddSpawnHeight = 51
ENT.ViewDist = 250
ENT.ViewDistUp = 20


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
ENT.CarMass = 800
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 90 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/props_vehicles/van001a.mdl"
ENT.TireModel = "models/props_vehicles/carparts_wheel01a.mdl"
ENT.AnimType = 1 --1 = jeep anim, 2 = airboat anim
ENT.EngineEffectName = "Junk Car"
ENT.FrontLightColor = "220 220 160" --RGB


for i = 1, ENT.NrOfWheels do
	ENT.WheelInfo[i] = {}
end

local xPos = 0
local yPos = 0
local zPos = 0

//SEAT POSITIONS
--Seat Position 1 (Driver seat)
xPos = 39
yPos = -20
zPos = -8
ENT.SeatPos[1] = Vector(xPos, yPos, zPos)

--Seat Position 2 (Right front seat)
xPos = 39
yPos = 20
zPos = -8
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
xPos = 42
yPos = -36
zPos = -32	
ENT.WheelInfo[1].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[1].Side = false
ENT.WheelInfo[1].Torq = false
ENT.WheelInfo[1].Steer = 1

--Front Right wheel
xPos = 42
yPos = 44
zPos = -35		
ENT.WheelInfo[2].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[2].Side = true
ENT.WheelInfo[2].Torq = false
ENT.WheelInfo[2].Steer = 1

--Rear Left wheel
xPos = -80
yPos = -36
zPos = -27	
ENT.WheelInfo[3].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[3].Side = false
ENT.WheelInfo[3].Torq = true
ENT.WheelInfo[3].Steer = 0

--Rear Right wheel
xPos = -80
yPos = 44
zPos = -30			
ENT.WheelInfo[4].Pos  =  Vector( xPos, yPos, zPos )
ENT.WheelInfo[4].Side = true
ENT.WheelInfo[4].Torq = true
ENT.WheelInfo[4].Steer = 0




//LIGHT POSITIONS	

--//Front Lights
--Left
xPos = 95
yPos = -32.5
zPos = -10	
ENT.FrontLightsPos[1] = Vector(xPos, yPos, zPos)

--Right
xPos = 95
yPos = 38
zPos = -13			
ENT.FrontLightsPos[2] = Vector(xPos, yPos, zPos)


--//Rear Lights
--Left
xPos = -121
yPos = -27
zPos = 3
ENT.RearLightsPos[1] = Vector(xPos, yPos, zPos)

--Right
xPos = -121
yPos = 33
zPos = -1.5	
ENT.RearLightsPos[2] = Vector(xPos, yPos, zPos)






--The position where the fire and smoke effects will be placed when the car is damaged
xPos = 92
yPos = 0
zPos = -2		
ENT.effectPos = Vector(xPos, yPos, zPos)

--The position of the exhaust
xPos = -108
yPos = -28
zPos = -24		
ENT.ExhaustPos[1] = Vector(xPos, yPos, zPos)

//SUSPENSION
--The higher the number is the harder the suspension will be
--Recommend not to change these numbers
ENT.DefaultSoftnesFront = 27
ENT.DefaultSoftnesRear = 27	

ENT.DefaultAcceleration = 2000
ENT.DefaultMaxSpeed = 1000
ENT.DefaultTurboEffect = 2
ENT.DefaultTurboDuration = 4
ENT.DefaultTurboDelay = 10
ENT.DefaultReverseForce = 1000
ENT.DefaultReverseMaxSpeed = 200
ENT.DefaultBreakForce = 2000
ENT.DefaultSteerForce = 5.5	
ENT.DefautlSteerResponse = 0.15
ENT.DefaultStabilisation = 2000
ENT.DefaultNrOfGears = 5
ENT.DefaultAntiSlide = 30
ENT.DefaultAutoStraighten = 10

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
