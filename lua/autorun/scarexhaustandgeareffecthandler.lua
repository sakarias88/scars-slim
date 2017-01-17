EFFECTDEF = {}
EFFECTDEF.Name = "Meta"
EFFECT_DEF = { __index = EFFECTDEF }

function EFFECTDEF:Init( SCar )
end

function EFFECTDEF:ChangeGear( SCar, curGear )
	SCar:EmitSound("car/changeGear.wav", 70)
end

function EFFECTDEF:RevEffect( SCar, rev, fadeTime )
end

function EFFECTDEF:ExhaustEffect( SCar, pos, dir, locPos )
end

function EFFECTDEF:Kill( SCar )
end

function EFFECTDEF:TurboOn( SCar, pos, dir, locPos )
end

function EFFECTDEF:TurboOff( SCar, pos, dir, locPos )
end

function EFFECTDEF:TurboThink( SCar, pos, dir, locPos )
end

SCarGearExhaustHandler = {}
SCarGearExhaustHandler.Dir = Vector(0,0,0)
SCarGearExhaustHandler.Pos = Vector(0,0,0)

function SCarGearExhaustHandler:Init()
	local effs = {}
	effs =	file.Find( "scarengineeffects/*.lua" , "LUA")

	for _, plugin in ipairs( effs ) do
		include( "scarengineeffects/" .. plugin )
	end
end

function SCarGearExhaustHandler:RegisterEffect( eff )
	if eff.Name then
		self[eff.Name] = eff
		
		setmetatable(self[eff.Name], EFFECT_DEF)
		
		list.Set( "SCarGearEffect", "#"..eff.Name, { carsound_gearsoundeffect = eff.Name } )
	end
end

function SCarGearExhaustHandler:IsValid( effectName )
	if self[effectName] then return true end
	return false
end

function SCarGearExhaustHandler:InitEffect( effectName, SCar )
	if self:IsValid( effectName ) then
		self[effectName]:Init( SCar )
	end
end

function SCarGearExhaustHandler:KillEffect( effectName, SCar )
	if self:IsValid( effectName ) then
		self[effectName]:Kill( SCar )
	end
end

function SCarGearExhaustHandler:EffectChangePitch( effectName, SCar, fadetime )
	if self:IsValid( effectName ) then
		self[effectName]:RevEffect( SCar, SCar.RealPitch, fadetime  )
	end
end

function SCarGearExhaustHandler:UseEffect( effectName, SCar )
	if self:IsValid( effectName ) then
	
		self[effectName]:ChangeGear( SCar, SCar.Gear )
	
		self.Dir = SCar:GetForward() * -1

		for i = 1, SCar.NrOfExhausts do
			self.Pos = SCar:GetPos() + SCar:GetForward() * SCar.ExhaustPos[i].x + SCar:GetRight() * SCar.ExhaustPos[i].y + SCar:GetUp() * SCar.ExhaustPos[i].z
			self[effectName]:ExhaustEffect( SCar, self.Pos, self.Dir, SCar.ExhaustPos[i] )
		end
	end
end

function SCarGearExhaustHandler:TurboOn( effectName, SCar )	self.Dir = SCar:GetForward() * -1
	if self:IsValid( effectName ) then
		for i = 1, SCar.NrOfExhausts do
			self.Pos = SCar:GetPos() + SCar:GetForward() * SCar.ExhaustPos[i].x + SCar:GetRight() * SCar.ExhaustPos[i].y + SCar:GetUp() * SCar.ExhaustPos[i].z
			self[effectName]:TurboOn( SCar, self.Pos, self.Dir, SCar.ExhaustPos[i] )
		end
	end
end

function SCarGearExhaustHandler:TurboOff( effectName, SCar )
	if self:IsValid( effectName ) then
		self.Dir = SCar:GetForward() * -1
		
		for i = 1, SCar.NrOfExhausts do
			self.Pos = SCar:GetPos() + SCar:GetForward() * SCar.ExhaustPos[i].x + SCar:GetRight() * SCar.ExhaustPos[i].y + SCar:GetUp() * SCar.ExhaustPos[i].z
			self[effectName]:TurboOff( SCar, self.Pos, self.Dir, SCar.ExhaustPos[i] )
		end
	end
end

function SCarGearExhaustHandler:TurboThink( effectName, SCar )
	if self:IsValid( effectName ) then
		self.Dir = SCar:GetForward() * -1
		
		for i = 1, SCar.NrOfExhausts do
			self.Pos = SCar:GetPos() + SCar:GetForward() * SCar.ExhaustPos[i].x + SCar:GetRight() * SCar.ExhaustPos[i].y + SCar:GetUp() * SCar.ExhaustPos[i].z
			self[effectName]:TurboThink( SCar, self.Pos, self.Dir, SCar.ExhaustPos[i] )
		end
	end
end