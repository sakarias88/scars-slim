--//Client
AddCSLuaFile( "autorun/client/clientconsoledata.lua" )
AddCSLuaFile( "autorun/client/scar3rdperson.lua" )
AddCSLuaFile( "autorun/client/scarconsole.lua" )
AddCSLuaFile( "autorun/client/scareditor.lua" )
AddCSLuaFile( "autorun/client/scarhud.lua" )
AddCSLuaFile( "autorun/client/scarracehud.lua" )
AddCSLuaFile( "autorun/client/scarracemessages.lua" )
AddCSLuaFile( "autorun/client/scarradio.lua" )
AddCSLuaFile( "autorun/client/scarsetcarkey.lua" )
AddCSLuaFile( "autorun/client/scarsseatanim.lua" )
AddCSLuaFile( "autorun/client/scartab.lua" )

--//Shared
AddCSLuaFile( "autorun/addcarhornstolist.lua" )
AddCSLuaFile( "autorun/addcarsoundstolist.lua" )
AddCSLuaFile( "autorun/addwheelstolistslim.lua" )
AddCSLuaFile( "autorun/carregister.lua" )
AddCSLuaFile( "autorun/donotcollidewithnodes.lua" )
AddCSLuaFile( "autorun/s_scaraihandler.lua" )
AddCSLuaFile( "autorun/scarconsolecommands.lua" )
AddCSLuaFile( "autorun/scarexhaustandgeareffecthandler.lua" )
AddCSLuaFile( "autorun/scarkeysadd.lua" )
AddCSLuaFile( "autorun/scarkeysloading.lua" )
AddCSLuaFile( "autorun/scarsavegamefixandmisc.lua" )
AddCSLuaFile( "autorun/advancedenginesoundhandler.lua" )
AddCSLuaFile( "autorun/pp_scarscppi.lua" )
AddCSLuaFile( "autorun/scars_mount_content.lua" )

--//Download all cameras
local cams = {}
cams =	file.Find( "scarcams/*.lua" , "LUA")


for _, plugin in ipairs( cams ) do
	AddCSLuaFile( "scarcams/" .. plugin )
end


--//Download all huds
local huds = {}
huds =	file.Find( "scarhud/*.lua" , "LUA")

for _, plugin in ipairs( huds ) do
	AddCSLuaFile( "scarhud/" .. plugin )
end


--//Download all engine effects
local engineEffects = {}
engineEffects =	file.Find( "scarengineeffects/*.lua" , "LUA")

for _, plugin in ipairs( engineEffects ) do
	AddCSLuaFile( "scarengineeffects/" .. plugin )
end


--Adding all AI to the register
local ais = {}
ais =	file.Find( "scarai/*.lua" , "LUA")


for _, plugin in ipairs( ais ) do
	AddCSLuaFile( "scarai/" .. plugin )
end