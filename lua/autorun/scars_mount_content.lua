SCARS_GLOBAL_HAS_LOADED_CONTENT = false

local function AngryErrorMessage(txt)
	MsgC( Color( 255, 0, 0, 255 ), "You managed to break SCars beyond repair.\n")
	MsgC( Color( 255, 0, 0, 255 ), "You just broke the"..txt..".\n")
	MsgC( Color( 255, 0, 0, 255 ), "You probably got too many addons installed.\n Disable or uninstall some and try again.\n")
	MsgC( Color( 255, 0, 0, 255 ), "Please visit this thread for more info: ")
	MsgC( Color( 0, 255, 0, 255 ), "http://facepunch.com/showthread.php?t=1250302\n")
end

local function InitSCarsMountableContent()

	if SCARS_GLOBAL_HAS_LOADED_CONTENT ==  false then
		SCARS_GLOBAL_HAS_LOADED_CONTENT = true
		
		--People are getting a lot of retarded errors here in this file that shouldn't be able to happen
		--Unfortunatly there really isn't anything I can do to solve it.
		--How am I supposed to solve something that doesn't exist?
		--So anyway, I'm just going to hide the errors and flash an angry message
		--Can't even use the global SCarsReportError function... THAT SHOULD EXIST AND BE ABLE TO WORK HERE! HOW DO THEY MANAGE TO BREAK IT SO MUCH!?
	
		
		--//Loading keys
		if SCarKeys and SCarKeys.BuildKeyInfo then
			SCarKeys:BuildKeyInfo()
		else
			AngryErrorMessage("SCar Keys handler")
		end			
		
		--//Loading cars
		if SCarRegister and SCarRegister.AddCar then
			for k, v in pairs(list.Get( "SCarsList" )) do
				//DarkRP list
				v.Name = v.PrintName
				v.Class = v.ClassName
				v.Members = nil
				v.KeyValues = nil
				v.Model = v.CarModel			
			
				SCarRegister:AddCar( v )
			end
		else
			AngryErrorMessage("SCar register")
		end
		
		--//Reading and loading AI
		if SCarAiHandler and SCarAiHandler.Init then
			SCarAiHandler:Init()
		else
			AngryErrorMessage("SCar AI handler")
		end
		
		
		if CLIENT then
			--//Reading and loading Cameras
			if SCarViewManager and SCarViewManager.Init then
				SCarViewManager:Init()
			else
				AngryErrorMessage("SCar view manager")
			end			
		
			--//Reading and loading HUDS
			if SCarHudHandler and SCarHudHandler.Init then
				SCarHudHandler:Init()
			else

			end	
		end
		
		--//Reading and loading engine effects
		if SCarGearExhaustHandler and SCarGearExhaustHandler.Init then
			SCarGearExhaustHandler:Init()
		else
			AngryErrorMessage("SCar gear & exhaust effect handler")
		end			
	end
end
hook.Add( "PostGamemodeLoaded", "InitSCarsMountableContent", InitSCarsMountableContent )

