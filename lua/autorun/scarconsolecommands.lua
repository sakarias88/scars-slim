
--SLIDERS  Name, conVar, default, min, max, decimals

list.Add("ScarConVarSlidersCar", { "Max Power", "scar_acceleration", 10000,    0, 10000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Speed", "scar_maxspeed"    ,  5000,   10, 5000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Turbo Effect", "scar_turborffect",  5,   1, 5, 1} )
list.Add("ScarConVarSlidersCar", { "Max Turbo Duration", "scar_turboduration",  10,   1, 10, 1} )
list.Add("ScarConVarSlidersCar", { "Min Turbo Delay", "scar_turbodelay",  1,   1, 60, 1} )
list.Add("ScarConVarSlidersCar", { "Max Reverse Power", "scar_reverseforce",  5000,   0, 5000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Reverse Speed", "scar_reversemaxspeed",  1000,   0, 1000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Break Efficiency", "scar_breakefficiency",  5000,   0.5, 5000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Steer Force", "scar_steerforce",  20,   0, 20, 1} )
list.Add("ScarConVarSlidersCar", { "Max Steer Response", "scar_steerresponse",  2,   0, 2, 1} )
list.Add("ScarConVarSlidersCar", { "Max Stabilisation", "scar_stabilisation",  4000,   0, 4000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Number of Gears", "scar_nrofgears",  10,   1, 10, 0} )
list.Add("ScarConVarSlidersCar", { "Min Fuel Consumption", "scar_fuelconsumption",  0.5,   0.5, 20, 1} )
list.Add("ScarConVarSlidersCar", { "Max Health", "scar_maxhealth",  1000,   100, 1000, 1} )
list.Add("ScarConVarSlidersCar", { "Max Anti Slide", "scar_maxantislide",  100,   0, 100, 1} )
list.Add("ScarConVarSlidersCar", { "Max Auto Straighten", "scar_maxautostraighten",  50,   0, 50, 1} )
list.Add("ScarConVarSlidersCar", { "Max hydraulics height", "scar_maxhydheight",  30,   0, 30, 1} )

list.Add("ScarConVarSliders", { "SCar spawn limit", "scar_maxscars",  10,   0, 50, 0} )
list.Add("ScarConVarSliders", { "Remove after exploded (in seconds)" , "scar_removedelay",  60,   0, 600, 0} )
list.Add("ScarConVarSliders", { "Damage scale" , "scar_damagescale",  1,   0.1, 10, 1} )
list.Add("ScarConVarSliders", { "Race end time", "scar_raceendime", 30,    0, 60, 0} )

--CHECKBOXES Name, conVar, default
list.Add("ScarConVarCheckBoxesCar", { "Allow RT Lights" , "scar_usert",  1} )
list.Add("ScarConVarCheckBoxesCar", { "Allow Third Person View" , "scar_thirdpersonview",  1} )
list.Add("ScarConVarCheckBoxesCar", { "Allow disabling Fuel Consumption" , "scar_fuelconsumptionuse",  1} )
list.Add("ScarConVarCheckBoxesCar", { "Allow Hydraulics", "scar_allowHydraulics",  1} )
list.Add("ScarConVarCheckBoxesCar", { "Allow disabling tire damage" , "scar_tiredamage",  1} )
list.Add("ScarConVarCheckBoxesCar", { "Allow disabling car damage", "scar_cardamage",  1} )
list.Add("ScarConVarCheckBoxesCar", { "Limit car characteristics (options below)", "scar_carcharlimitation",  0} )

list.Add("ScarConVarCheckBoxes", { "Only allow admins to spawn SCars", "scar_scarspawnadminonly",  0} )
list.Add("ScarConVarCheckBoxes", { "Start car when entering vehicle", "scar_carautoenter",  1} )
list.Add("ScarConVarCheckBoxes", { "Turn off car when leaving vehicle", "scar_carautoleave",  1} )
list.Add("ScarConVarCheckBoxes", { "Continuous Turbo", "scar_continuousturbo",  0} )
list.Add("ScarConVarCheckBoxes", { "Air control", "scar_aircontrol",  1} )
list.Add("ScarConVarCheckBoxes", { "Allow Admin car spawns", "scar_admincarspawn",  0} )
list.Add("ScarConVarCheckBoxes", { "Autodeploy handbrake", "scar_autodeployhandbrake",  1} )
list.Add("ScarConVarCheckBoxes", { "Let clients spawn cars through the editor", "scar_clispawneditor",  0} )


list.Add("ScarConVarStool", {  "AI Spawner", "scar_caraispawner",  0} )
list.Add("ScarConVarStool", {  "CheckPoint Spawner", "scar_carcheckpointspawner",  1} )
list.Add("ScarConVarStool", {  "Fuel", "scar_carfuel",  1} )
list.Add("ScarConVarStool", {  "Health", "scar_carhealth",  1} )
list.Add("ScarConVarStool", {  "Hydraulics", "scar_carhydraulic",  1} )
list.Add("ScarConVarStool", {  "Neon lights", "scar_carneonlights",  1} )
list.Add("ScarConVarStool", {  "AI Node Spawner", "scar_carnodespawner",  0} )
list.Add("ScarConVarStool", {  "Spawner", "scar_carspawner",  1} )
list.Add("ScarConVarStool", {  "Suspension adjustment", "scar_carsuspension",  1} )
list.Add("ScarConVarStool", {  "Tuner", "scar_cartuning",  1} )
list.Add("ScarConVarStool", {  "Paint Job Switcher", "scar_paintjobswitcher",  1} )
list.Add("ScarConVarStool", {  "Wheel changer", "scar_wheelchanger",  1} )
list.Add("ScarConVarStool", {  "Car sounds", "scar_carsound",  1} )

if (SERVER) then
	SCarGetFastConvar ={}
end
for k, v in pairs( list.Get("ScarConVarStool") ) do
	CreateConVar( v[2], v[3], { FCVAR_REPLICATED, FCVAR_ARCHIVE })
end

for k, v in pairs( list.Get("ScarConVarSlidersCar") ) do
	CreateConVar(v[2], v[3], { FCVAR_REPLICATED, FCVAR_ARCHIVE })
end

for k, v in pairs( list.Get("ScarConVarSliders") ) do
	CreateConVar(v[2], v[3], { FCVAR_REPLICATED, FCVAR_ARCHIVE })
end

for k, v in pairs( list.Get("ScarConVarCheckBoxesCar") ) do
	CreateConVar(v[2], v[3], { FCVAR_REPLICATED, FCVAR_ARCHIVE })
end

for k, v in pairs( list.Get("ScarConVarCheckBoxes") ) do
	CreateConVar(v[2], v[3], { FCVAR_REPLICATED, FCVAR_ARCHIVE  })
	if SERVER then
		SCarGetFastConvar[v[2]] = GetConVarNumber( v[2] )
	end
end