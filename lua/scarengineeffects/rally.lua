ExEff = {}
ExEff.Name = "Rally"

ExEff.MakePop = 1
ExEff.LastGear = 0

--Runs when the car starts
function ExEff:Init( SCar )
end

--Runs when changing gear
function ExEff:ChangeGear( SCar, curGear )

	if curGear > self.LastGear then
		SCar:EmitSound("GearEffectSounds/rally/shift/up"..math.random(1,3)..".wav", 70, math.random(90,110))
	else
		SCar:EmitSound("GearEffectSounds/rally/shift/down"..math.random(1,3)..".wav", 70, math.random(90,110))
	end
	
	self.LastGear = curGear
	
	if SCar:GetPhysicsObject():GetVelocity():Length() > 200 then
		self.MakePop = math.random(1,3)
		if self.MakePop == 1 then	
			SCar:EmitSound("GearEffectSounds/rally/backfire.wav", 80, math.random(70,130))	
		end
	else
		self.MakePop = 0
	end
end

--Runs when the engine rev changes (very often)
function ExEff:RevEffect( SCar, rev, fadeTime )
end

--Runs for each exhaust when changing gear
function ExEff:ExhaustEffect( SCar, pos, dir, locPos )
	if self.MakePop == 1 then	
		local effectdata = EffectData()
		effectdata:SetEntity( SCar )
		effectdata:SetOrigin( locPos )
		effectdata:SetScale(1.2)
		effectdata:SetMagnitude(1)
		util.Effect( "ScarRallyBackfire", effectdata )
	end
end

--Runs when the car is turned off
function ExEff:Kill( SCar )
end

SCarGearExhaustHandler:RegisterEffect(ExEff)