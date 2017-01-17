
list.Set( "SCarEngineSounds", "#V8 cruise", { carsound_enginesound = "vehicles/v8/fourth_cruise_loop2.wav" } )
list.Set( "SCarEngineSounds", "#V8 first gear", { carsound_enginesound = "vehicles/v8/v8_firstgear_rev_loop1.wav" } )
list.Set( "SCarEngineSounds", "#V8 start", { carsound_enginesound = "vehicles/v8/v8_start_loop1.wav" } )
list.Set( "SCarEngineSounds", "#Crane idle", { carsound_enginesound = "vehicles/Crane/crane_slow_to_idle_loop4.wav" } )
list.Set( "SCarEngineSounds", "#APC cruise", { carsound_enginesound = "vehicles/APC/apc_cruise_loop3.wav" } )
list.Set( "SCarEngineSounds", "#Diesel", { carsound_enginesound = "vehicles/diesel_loop2.wav" } )
list.Set( "SCarEngineSounds", "#Airboat fan full Throttle", { carsound_enginesound = "vehicles/Airboat/fan_blade_fullthrottle_loop1.wav" } )
list.Set( "SCarEngineSounds", "#Airboat fan idle", { carsound_enginesound = "vehicles/Airboat/fan_blade_idle_loop1.wav" } )
list.Set( "SCarEngineSounds", "#Airboat full Throttle", { carsound_enginesound = "vehicles/Airboat/fan_motor_fullthrottle_loop1.wav" } )
list.Set( "SCarEngineSounds", "#Airboat idle", { carsound_enginesound = "vehicles/Airboat/fan_motor_idle_loop1.wav" } )

local function ProcessEngineSoundFiles(files)
		if !string or !string.Explode then
			SCarsReportError("The string.Explode function is missing.", 150, "The string.Explode function is missing")
			return
		end

		for _, plugin in ipairs( files ) do
			local expl = string.Explode( ".", plugin )
			local slot = expl[1]

			list.Set( "SCarEngineSounds", "#"..expl[1], { carsound_enginesound = "SCarEngineSounds/"..plugin } )
		end
end

--Automatically add sounds in this directory
local dir = "sound/scarenginesounds/"
ProcessEngineSoundFiles(file.Find( dir.."*.wav", "GAME"))
