--Automatically add sounds in this directory
local dir = "sound/scarhorns/"
local wavFiles = {}

wavFiles =	file.Find( dir.."*.wav", "GAME")


for _, plugin in ipairs( wavFiles ) do
	
	local expl = string.Explode( ".", plugin )
	local slot = expl[1]
	
	list.Set( "SCarHornSounds", "#"..expl[1], { carsound_hornsound = "scarhorns/"..plugin } )
end