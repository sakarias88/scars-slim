ExEff = {}
ExEff.Name = "Turbo"

ExEff.MakePop = 1
--Runs when the car starts
function ExEff:Init( SCar )
	SCar.EffectTurboSound = CreateSound(SCar,"GearEffectSounds/turbo/turbo.wav")
	SCar.EffectTurboSound:Play()
end

--Runs when changing gear
function ExEff:ChangeGear( SCar, curGear )

	SCar:EmitSound("GearEffectSounds/turbo/shift/"..math.random(1,6)..".wav", 40 + SCar.RealPitch * 0.0041666 * 30, math.random(90,110))
end

--Runs when the engine rev changes (very often)
function ExEff:RevEffect( SCar, rev, fadeTime )

	if SCar.EffectTurboSound then
		SCar.EffectTurboSound:ChangePitch( 30 + rev*rev*0.0005, fadeTime)
		SCar.EffectTurboSound:ChangeVolume( 0.25 + rev * 0.0005, fadeTime )
	end
end

--Runs for each exhaust when changing gear
function ExEff:ExhaustEffect( SCar, pos, dir, locPos )
end

--Runs when the car is turned off
function ExEff:Kill( SCar )
	if SCar.EffectTurboSound then
		SCar.EffectTurboSound:Stop()
	end
end

SCarGearExhaustHandler:RegisterEffect(ExEff)