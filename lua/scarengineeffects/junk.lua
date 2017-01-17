ExEff = {}
ExEff.Name = "Junk Car"

ExEff.DoSmoke = 0
ExEff.FailGear = 0
ExEff.Sounds = {"weapons/ar2/fire1.wav", "weapons/pistol/pistol_fire3.wav", "weapons/357_fire2.wav"}
--Runs when the car starts
function ExEff:Init( SCar )
	
end



--Runs when changing gear
function ExEff:ChangeGear( SCar, curGear )
	
	
	self.FailGear = math.random(1,2)
	if self.FailGear == 1 then
		SCar:EmitSound("GearEffectSounds/junk/gear/"..math.random(1,2)..".wav", 70)
	else
		SCar:EmitSound("GearEffectSounds/junk/gear/"..math.random(3,4)..".wav", 70)
	end	
	
	self.DoSmoke = math.random(1,5)
	if self.DoSmoke == 1 then
		SCar:EmitSound(self.Sounds[math.random(1,3)],65, math.Rand(60,80))
		SCar:GetPhysicsObject():AddAngleVelocity( Vector(0,50000 / SCar:GetPhysicsObject():GetMass(),0) )
	else
		self.DoSmoke = 0
	end
end

--Runs when the engine rev changes (very often)
function ExEff:RevEffect( SCar, rev, fadeTime )
end

--Runs for each exhaust when changing gear
function ExEff:ExhaustEffect( SCar, pos, dir, locPos )
	if self.DoSmoke == 1 then
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetStart( SCar:GetVelocity() )
		util.Effect( "ScarJunkEffect", effectdata )
	end
end

--Runs when the car is turned off
function ExEff:Kill( SCar )
end

SCarGearExhaustHandler:RegisterEffect(ExEff)
