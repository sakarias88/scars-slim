
local SCarErrorStr = ""
local SCarErrorSvCol = Color( 0, 255, 0, 255 )
local SCarErrorClCol = Color( 0, 0, 255, 255 )
local SCarErrorCol = nil

if (CLIENT) then
	SCarErrorCol = SCarErrorClCol
elseif (SERVER) then
	SCarErrorCol = SCarErrorSvCol
end

CreateConVar("scar_showerrors", 0, { FCVAR_REPLICATED, FCVAR_ARCHIVE })
CreateConVar("scar_errordatestamp", 1, { FCVAR_REPLICATED, FCVAR_ARCHIVE })
function SCarsReportError( text, severity, codeRed )
	severity = severity or 0
	codeRed = codeRed or ""
	

	text = "SCar Error| "..text.."\n"
	
	if GetConVarNumber( "scar_errordatestamp" ) == 1 then
		SCarErrorStr = SCarErrorStr..tostring( os.date() ).."|"..text
	else
		SCarErrorStr = SCarErrorStr..text
	end	
	
	if (GetConVarNumber( "scar_showerrors" ) == 1 or severity >= 255) and codeRed == "" then
		MsgC( Color( severity, SCarErrorCol.g, SCarErrorCol.b, SCarErrorCol.a ), text)
	elseif codeRed and codeRed != ""  then
		MsgC( Color( 255, 0, 0, 255 ), "SCars is getting some really weird errors that shouldn't occur.\n")
		MsgC( Color( 255, 0, 0, 255 ), "Message: "..codeRed.."\n")
		MsgC( Color( 255, 0, 0, 255 ), "Ever thought about cleaning up GMod? You probably should!\n")	
	end
end

local function SaveSCarErrorLogs()
	if SCarErrorStr != "" then
		SCarErrorStr = "Created: "..tostring( os.date() ).."\n"..SCarErrorStr
		if (CLIENT) then
			file.Write( "scar_errorlog_cl.txt", SCarErrorStr)
		elseif (SERVER) then
			file.Write( "scar_errorlog_sv.txt", SCarErrorStr)
		end
	end
end
hook.Add("ShutDown", "SaveSCarErrorLogs", SaveSCarErrorLogs)

local preSaveFunc = saverestore.PreSave
saverestore.PreSave = function()
	for k, v in pairs( ents.GetAll() ) do
		if string.find( v:GetClass(), "sent_sakarias_car" ) and v.PrepareCarForSave then 
			v:PrepareCarForSave()
		end	
	end
	preSaveFunc()
end

local function SaveCar( restore )
	for k, v in pairs( ents.GetAll() ) do
		if string.find( v:GetClass(), "sent_sakarias_car" ) and v.RestoreCarFromSave then 
			v:RestoreCarFromSave()
		end	
	end	
end

--We have to restore all sounds because Garrys Mod can't save sounds from the CSoundPatch
local function RestoreCar( restore )
	for k, v in pairs( ents.GetAll() ) do
		if string.find( v:GetClass(), "sent_sakarias_car" ) and v.RestoreCarFromLoading then 
			v:RestoreCarFromLoading()
		elseif string.find( v:GetClass(), "env_projectedtexture" ) and v.IsScarRT then
			v:Remove()
		end	
	end	
end
	
saverestore.AddSaveHook( "SCarFromSave", SaveCar )
saverestore.AddRestoreHook( "SCarFromSave", RestoreCar )


local function InitSCarsPhysics()

	local physInf = physenv.GetPerformanceSettings()
	
	if physInf == nil or physInf.MaxVelocity == nil or physInf.MaxAngularVelocity == nil then
		SCarsReportError("You fucked up the physical performance settings somehow. Good luck fixing it.")
	else

		--Default: 2000, Recommended: 5000
		--5000 is about 340 km\h or about 210 mph
		local change = false
		if physInf.MaxVelocity < 5000 then
			physInf.MaxVelocity = 5000
			change = true
		end
		
		if physInf.MaxAngularVelocity >	3636.3637695313 then
			physInf.MaxAngularVelocity = 3636.3637695313
			change = true
		end		
		
		if change then
			physenv.SetPerformanceSettings( physInf )
		end	
	end
end
hook.Add( "InitPostEntity", "InitSCarsPhysics", InitSCarsPhysics )


