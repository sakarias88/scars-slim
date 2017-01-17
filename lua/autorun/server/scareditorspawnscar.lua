function NoMpCarSpawning( pl, handler, id )
	if handler == "SCarSpawnSendFile" and !pl:IsAdmin() and GetConVarNumber( "scar_clispawneditor" ) == 0 then return false end
end
hook.Add( "AcceptStream", "SCarsNoMpCarSpawning", NoMpCarSpawning )

function GetSCarSpawnFromClient( sender, decoded )

	--if SinglePlayer() then
	if sender:IsAdmin() or GetConVarNumber( "scar_clispawneditor" ) == 1 then
		
		local CarEnt = ents.Create("sent_sakarias_car_junker1")
		CarEnt:SetNetworkedBool( "spawnedByEditor", true )
		local pos = sender:GetShootPos()
		local ang = sender:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*5000)
		tracedata.filter = sender
		local trace = util.TraceLine(tracedata)
		----APPLYING ALL VALUES
	
		
		CarEnt.NrOfSeats = decoded.NrOfSeats
		CarEnt.NrOfWheels = decoded.NrOfWheels
		CarEnt.NrOfExhausts = decoded.NrOfExhausts
		CarEnt.NrOfFrontLights = decoded.NrOfFLight
		CarEnt.NrOfRearLights = decoded.NrOfRLight
		
		CarEnt.effectPos = Vector(decoded.EffectPos.x, -decoded.EffectPos.y, decoded.EffectPos.z)
		
		CarEnt.CarMass = decoded.CarMass
		CarEnt.DefaultSound = decoded.EngineSound
		CarEnt.CarModel = decoded.CarModel
		CarEnt.TireModel = decoded.WheelModel
		
		CarEnt.Category = decoded.CarCategoryName	
		CarEnt.AnimType = decoded.AnimType
		CarEnt.HornSound = decoded.HornSound
		CarEnt.EngineEffectName = decoded.EngineEffect
		
		CarEnt.DefaultSoftnesFront = decoded.WheelSuspensionStiffness
		CarEnt.DefaultSoftnesRear = decoded.WheelSuspensionStiffness
		
		for i = 1, CarEnt.NrOfSeats do
			CarEnt.SeatPos[i] = Vector(decoded.SeatPos[i].x, -decoded.SeatPos[i].y, decoded.SeatPos[i].z)
		end
		
		
		CarEnt.WheelInfo = {}
		for i = 1, CarEnt.NrOfWheels do
			CarEnt.WheelInfo[i] = {}
			CarEnt.WheelInfo[i].Pos = Vector(decoded.WheelsPos[i].x, -decoded.WheelsPos[i].y, decoded.WheelsPos[i].z)
		

			if decoded.WheelSide[i] == 1 then
				CarEnt.WheelInfo[i].Side = false
			else
				CarEnt.WheelInfo[i].Side = true
			end			
			
			if decoded.WheelTorq[i] == 1 then
				CarEnt.WheelInfo[i].Torq = true
			else
				CarEnt.WheelInfo[i].Torq = false
			end
			
			CarEnt.WheelInfo[i].Steer = decoded.WheelSteer[i]
		end
				
		
		for i = 1, CarEnt.NrOfExhausts do
			CarEnt.ExhaustPos[i] = Vector(decoded.ExhaustPos[i].x, -decoded.ExhaustPos[i].y, decoded.ExhaustPos[i].z)
		end		
		
		for i = 1, CarEnt.NrOfFrontLights do
			CarEnt.FrontLightsPos[i] = Vector(decoded.FLightPos[i].x, -decoded.FLightPos[i].y, decoded.FLightPos[i].z)
		end		

		for i = 1, CarEnt.NrOfRearLights do
			CarEnt.RearLightsPos[i] = Vector(decoded.RLightPos[i].x, -decoded.RLightPos[i].y, decoded.RLightPos[i].z)
		end	
		
		
		
		CarEnt.DefaultAcceleration = decoded.DefaultAcceleration
		CarEnt.DefaultMaxSpeed = decoded.DefaultMaxSpeed
		CarEnt.DefaultTurboEffect = decoded.DefaultTurboEffect
		CarEnt.DefaultTurboDuration = decoded.DefaultTurboDuration
		CarEnt.DefaultTurboDelay = decoded.DefaultTurboDelay
		CarEnt.DefaultReverseForce = decoded.DefaultReverseForce
		CarEnt.DefaultReverseMaxSpeed = decoded.DefaultReverseMaxSpeed
		CarEnt.DefaultBreakForce = decoded.DefaultBreakForce
		CarEnt.DefaultSteerForce = decoded.DefaultSteerForce
		CarEnt.DefautlSteerResponse = decoded.DefautlSteerResponse
		CarEnt.DefaultStabilisation = decoded.DefaultStabilisation
		CarEnt.DefaultNrOfGears = decoded.DefaultNrOfGears
		CarEnt.DefaultAntiSlide = decoded.DefaultAntiSlide
		CarEnt.DefaultAutoStraighten = decoded.DefaultAutoStraighten
		CarEnt.DeafultSuspensionAddHeight = -decoded.DeafultSuspensionAddHeight
		CarEnt.DefaultHydraulicActive = decoded.DefaultHydraulicActive		

		CarEnt.AddSpawnHeight = decoded.AddSpawnHeight
		CarEnt.ViewDist = decoded.ViewDist
		CarEnt.ViewDistUp = decoded.ViewDistUp			


		
		----REPOSITION STUFF
		CarEnt:Spawn()
		CarEnt:Activate()
		addHeight = CarEnt.AddSpawnHeight
		CarEnt:SetPos( trace.HitPos + (trace.HitNormal * (addHeight + 10)))	
		
		local Ang = trace.HitNormal:Angle()
		Ang:RotateAroundAxis( Ang:Right(), -90 )
		local newAng = (sender:GetPos() - CarEnt:GetPos()):GetNormalized():Angle()
		Ang:RotateAroundAxis( Ang:Up(), newAng.y )
		

		CarEnt:SetAngles( Ang )	
		CarEnt:Reposition( sender )
		CarEnt.handBreakDel = CurTime() + 2
		CarEnt.SpawnedBy = sender	
		CarEnt:UpdateAllCharacteristics()
		
		CarEnt:SetCarOwner( sender )
		
		sender:AddCount( "SCar", CarEnt )	
			
		undo.Create("SCars")
		undo.AddEntity( CarEnt )
		undo.SetPlayer( sender )
		undo.SetCustomUndoText( "Undone "..decoded.LoadedCarName )
		undo.Finish()	
			
		sender:AddCleanup( "SCars", CarEnt )
		
		--//Can't send it instantly.
		--//If we do the information will be recieved before the entity is initiated on the client
		--//Have to send it after the entity is initiated on the client.
		timer.Simple( 2, function()
			net.Start("SCar_ServerSpawnedSCarFromEditor")
				net.WriteEntity( CarEnt )
				net.WriteTable( decoded )
			net.Broadcast()			
		end )
	end
end


local function SCarDoWithNET( len, ply )
	GetSCarSpawnFromClient( ply, net.ReadTable() )
end
net.Receive("SCarSpawnSendFile", SCarDoWithNET )
util.AddNetworkString( "SCarSpawnSendFile" )
util.AddNetworkString( "SCar_ServerSpawnedSCarFromEditor" )
