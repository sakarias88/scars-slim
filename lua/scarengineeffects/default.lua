ExEff = {}
ExEff.Name = "Default"

--Runs when the car starts
function ExEff:Init( SCar )
end

--Runs when changing gear
function ExEff:ChangeGear( SCar, curGear )
	SCar:EmitSound("car/changeGear.wav", 70)
end

--Runs when the engine rev changes (very often)
function ExEff:RevEffect( SCar, rev, fadeTime )
end

--Runs for each exhaust when changing gear
function ExEff:ExhaustEffect( SCar, pos, dir, locPos )
end

--Runs when the car is turned off
function ExEff:Kill( SCar )
end

function ExEff:TurboOn( SCar, pos, dir, locPos )
end

function ExEff:TurboOff( SCar, pos, dir, locPos )
end

function ExEff:TurboThink( SCar, pos, dir, locPos )
end

SCarGearExhaustHandler:RegisterEffect(ExEff)