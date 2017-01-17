
SCarRegister = {}
SCarRegister.Nr = 0
SCarRegister.CarInfo = {}
SCarRegister.MissingDependencies = {}

list.Set( "scar_category", "All", "All")
list.Set( "scar_category", "No category", "No category")

function SCarRegister:AddCar( car )
	--Getting the class name
	local expl = string.Explode( "/", car.Folder )
	local name = expl[table.Count( expl )]
			
	if !SCarRegister.CarInfo[name] then
		
		--Msg(car.PrintName.."\n")
		
		SCarRegister.CarInfo[name] = {}
		SCarRegister.CarInfo[name].EntName = name
		SCarRegister.CarInfo[name].Name = car.PrintName
		SCarRegister.CarInfo[name].Author = car.Author
		SCarRegister.CarInfo[name].Category = car.Category
		SCarRegister.CarInfo[name].Information = car.Information
		SCarRegister.CarInfo[name].WheelNr      = car.NrOfWheels
		SCarRegister.CarInfo[name].ExhaustNr    = car.NrOfExhausts
		SCarRegister.CarInfo[name].FrontLightNr = car.NrOfFrontLights
		SCarRegister.CarInfo[name].RearLightNr  = car.NrOfRearLights
		SCarRegister.CarInfo[name].Mass         = car.CarMass
		SCarRegister.CarInfo[name].Model        = car.CarModel
		SCarRegister.CarInfo[name].TireModel    = car.TireModel
		SCarRegister.CarInfo[name].FrontSuspensionSoftness = car.DefaultSoftnesFront
		SCarRegister.CarInfo[name].RearSuspensionSoftness = car.DefaultSoftnesRear
		SCarRegister.CarInfo[name].DefaultSound = car.DefaultSound
		SCarRegister.CarInfo[name].AddSpawnHeight = car.AddSpawnHeight
		SCarRegister.CarInfo[name].DependencyNotice = car.DependencyNotice
		SCarRegister.CarInfo[name].EntityDependency = car.EntityDependency
		SCarRegister.CarInfo[name].IsMissingDependencies = false
		
		//Getting all default settings
		SCarRegister.CarInfo[name].DefaultAcceleration = car.DefaultAcceleration
		SCarRegister.CarInfo[name].DefaultMaxSpeed = car.DefaultMaxSpeed
		SCarRegister.CarInfo[name].DefaultTurboEffect = car.DefaultTurboEffect
		SCarRegister.CarInfo[name].DefaultTurboDuration = car.DefaultTurboDuration
		SCarRegister.CarInfo[name].DefaultTurboDelay = car.DefaultTurboDelay
		SCarRegister.CarInfo[name].DefaultReverseForce = car.DefaultReverseForce
		SCarRegister.CarInfo[name].DefaultReverseMaxSpeed = car.DefaultReverseMaxSpeed
		SCarRegister.CarInfo[name].DefaultBreakForce = car.DefaultBreakForce
		SCarRegister.CarInfo[name].DefaultSteerForce = car.DefaultSteerForce
		SCarRegister.CarInfo[name].DefautlSteerResponse = car.DefautlSteerResponse
		SCarRegister.CarInfo[name].DefaultStabilisation = car.DefaultStabilisation
		SCarRegister.CarInfo[name].DefaultNrOfGears = car.DefaultNrOfGears
		SCarRegister.CarInfo[name].DefaultAntiSlide = car.DefaultAntiSlide
		SCarRegister.CarInfo[name].DefaultAutoStraighten = car.DefaultAutoStraighten		
		SCarRegister.CarInfo[name].SuspensionFrontHeight = 0
		SCarRegister.CarInfo[name].SuspensionFrontRear = 0
		SCarRegister.CarInfo[name].DeafultSuspensionAddHeight = car.DeafultSuspensionAddHeight
		SCarRegister.CarInfo[name].DefaultHydraulicActive = car.DefaultHydraulicActive
		SCarRegister.CarInfo[name].AdminOnly = car.AdminOnly
		SCarRegister.CarInfo[name].DefaultWheelHeight = 0
		
		if (CLIENT) then
			local tmp = ClientsideModel(car.TireModel, RENDERGROUP_OPAQUE)
			SCarRegister.CarInfo[name].DefaultWheelHeight = (tmp:OBBMaxs().Z - tmp:OBBMins().Z) / 2	
			tmp:Remove()
			language.Add (name, car.PrintName)
			killicon.Add(name, "VGUI/entities/"..name, Color( 255, 255, 255, 255 ) )
		end
		
		if !SCarRegister.CarInfo[name].Name or SCarRegister.CarInfo[name].Name == "" then
			SCarRegister.CarInfo[name].Name = "No Name"
		end

		if !SCarRegister.CarInfo[name].Author or SCarRegister.CarInfo[name].Author == "" then
			SCarRegister.CarInfo[name].Author = "Sakarias88"
		end

		if !SCarRegister.CarInfo[name].Category or SCarRegister.CarInfo[name].Category == "" then
			SCarRegister.CarInfo[name].Category = "No category"
		end

		if !SCarRegister.CarInfo[name].DependencyNotice or SCarRegister.CarInfo[name].DependencyNotice == "" then
			SCarRegister.CarInfo[name].DependencyNotice = "No note? Ask the author of this SCar."
		end		

		if (SERVER) then
			SCarRegister.CarInfo[name].IsMissingDependencies = self:CheckDependency(SCarRegister.CarInfo[name].EntityDependency, name)
			SCarRegister.MissingDependencies[name] = SCarRegister.CarInfo[name].IsMissingDependencies
		end
		
		if !SCarRegister.CarInfo[name].Information then SCarRegister.CarInfo[name].Information = "" end
		
		
		list.Set( "scar_category", SCarRegister.CarInfo[name].Category, SCarRegister.CarInfo[name].Category)
		list.Set( "scar_carList_"..SCarRegister.CarInfo[name].Category, "#"..SCarRegister.CarInfo[name].Name, { Material = "vgui/entities/"..SCarRegister.CarInfo[name].EntName, carspawner_model = SCarRegister.CarInfo[name].EntName , Value = SCarRegister.CarInfo[name].Name } )

	
		 local V = {
					Name = SCarRegister.CarInfo[name].Name,
					Class = SCarRegister.CarInfo[name].EntName,
					Category = SCarRegister.CarInfo[name].Category,
					Author = SCarRegister.CarInfo[name].Author,
					Information = SCarRegister.CarInfo[name].Information,
					Model = ""}

		list.Set("SCarVehicles", SCarRegister.CarInfo[name].EntName, V)
	
		
		SCarRegister.CarInfo[name].ExhaustPos = {}	
		for i = 1, car.NrOfExhausts do
			SCarRegister.CarInfo[name].ExhaustPos[i] = car.ExhaustPos[i]
		end
		
		SCarRegister.CarInfo[name].WheelInfo = {}
		for i = 1, car.NrOfWheels do
			SCarRegister.CarInfo[name].WheelInfo[i] = {}
			SCarRegister.CarInfo[name].WheelInfo[i].Pos   = car.WheelInfo[i].Pos 
			SCarRegister.CarInfo[name].WheelInfo[i].Side  = car.WheelInfo[i].Side 
			SCarRegister.CarInfo[name].WheelInfo[i].Torq  = car.WheelInfo[i].Torq 
			SCarRegister.CarInfo[name].WheelInfo[i].Steer = car.WheelInfo[i].Steer 		
		end		
		

		SCarRegister.CarInfo[name].FrontLightPos = {}
		for i = 1, car.NrOfFrontLights do
			SCarRegister.CarInfo[name].FrontLightPos[i] = car.FrontLightsPos[i]
		end
		
		
		SCarRegister.CarInfo[name].RearLightPos = {}
		for i = 1, car.NrOfRearLights do
			SCarRegister.CarInfo[name].RearLightPos[i] = car.RearLightsPos[i]
		end			
	end
end

function SCarRegister:CheckDependency( dependencyEntities, nam )
	if !dependencyEntities then
		return false
	end

	local missingDependency = false

	for k, v in pairs(dependencyEntities) do
		local files, dirs = file.Find("entities/*", "LUA")

		if !(files and table.HasValue( files, v ) || dirs and table.HasValue(dirs, v )) then
			missingDependency = true
			if SERVER then
				SCarsReportError("SCar is missing dependency entity "..v.."!", 150)
			end
		end
	end	
	
	return missingDependency
end

function SCarRegister:GetInfo( car )
	return SCarRegister.CarInfo[car]
end

if SERVER then
function SCarRegister.PlayerInitialSpawn(ply)
	net.Start("SCars_MissingDependencies")
		net.WriteTable( SCarRegister.MissingDependencies )
	net.Send(ply)	
end
hook.Add("PlayerInitialSpawn", "SCarRegister.PlayerInitialSpawn", SCarRegister.PlayerInitialSpawn)
util.AddNetworkString( "SCars_MissingDependencies" )
end

