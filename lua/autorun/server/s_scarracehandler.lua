RaceHandler = {}
RaceHandler.race = {}
RaceHandler.raceId = {}
RaceHandler.nrOfRaces = 0
RaceHandler.LastCreatedRace = 0
function RaceHandler:RaceExists( id )

	for i = 1, RaceHandler.nrOfRaces do
		if RaceHandler.raceId[i] == id then
			return true
		end
	end
	
	return false
end

function RaceHandler:CreateRace( id )

	if !RaceHandler:RaceExists( id ) then

		RaceHandler.LastCreatedRace = id --REMOVE THIS
		RaceHandler.race[id] = {}
		RaceHandler.race[id].StartTime = 0
		RaceHandler.race[id].NrOfCheckPoints = 0
		RaceHandler.race[id].NrOfRacers = 0
		RaceHandler.race[id].NrOfFinishedRacers = 0
		RaceHandler.race[id].Laps = 1
		RaceHandler.race[id].RaceEndCountDown = false
		RaceHandler.race[id].PlayerRacers = {}
		RaceHandler.race[id].PlayerRacersPositions = {}
		RaceHandler.race[id].PlayerRacersPositionsOld = {}
		RaceHandler.race[id].RaceInfo = {}
		RaceHandler.race[id].LastRaceTime = {}
		RaceHandler.race[id].SomeoneFinished = false
		RaceHandler.race[id].RaceIsStarted = false
		RaceHandler.race[id].RaceIsFinished = false
		RaceHandler.race[id].RaceHandlerEnt = NULL
		RaceHandler.race[id].msg = ""
		RaceHandler.race[id].msgCol = Color(0,0,0,255)
		RaceHandler.race[id].RaceHandlerEnt = nil
		RaceHandler.nrOfRaces = RaceHandler.nrOfRaces + 1
		RaceHandler.raceId[RaceHandler.nrOfRaces] = id
		return true
	end
	
	return false
end

function RaceHandler:LinkRaceHandlerEntToRace( id, ent )
	if IsValid(ent) and RaceHandler:RaceExists( id ) then
		RaceHandler.race[id].RaceHandlerEnt = ent
	end
end

function RaceHandler:UpdateRaceEntScreen( id )
	if IsValid(RaceHandler.race[id].RaceHandlerEnt) then
		RaceHandler.race[id].RaceHandlerEnt:UpdatePlayerScreen()
	end
end

function RaceHandler:RemoveAllCheckpointsInRace( id )

	if RaceHandler.race[id] then
	
		RaceHandler:StopRace( id )
		RaceHandler:ClearPlayersFromRace( id )
		
		local checkPointNr = RaceHandler.race[id].NrOfCheckPoints
		
		for i = 1, checkPointNr do
			if IsValid(RaceHandler.race[id][ i ]) then
				RaceHandler.race[id][ i ]:Remove()
			end
		end
	end
end

function RaceHandler:UpdateRace( id )
	if RaceHandler:RaceExists( id ) and RaceHandler:RaceIsOn(id) then
		RaceHandler:CalculatePlayerPositions( id )
	end
end

function RaceHandler:AddCheckPointToRace( id, checkPoint, msg, col )

	if RaceHandler.race[id] && IsValid( checkPoint ) then
	
		if msg then
			RaceHandler.race[id].msg = msg
		end
		
		if col then
			RaceHandler.race[id].msgCol = col
		end
	
		RaceHandler.race[id].NrOfCheckPoints = RaceHandler.race[id].NrOfCheckPoints + 1
		local checkPointNr = RaceHandler.race[id].NrOfCheckPoints
		
		RaceHandler.race[id][ checkPointNr ] = checkPoint
		if checkPointNr == 1 then

			RaceHandler.race[id][ checkPointNr ].NextNode  =  RaceHandler.race[id][ checkPointNr ]
			RaceHandler.race[id][ checkPointNr ].PrevNode  =  RaceHandler.race[id][ checkPointNr ]
		else		
					
			RaceHandler.race[id][ checkPointNr ].NextNode = RaceHandler.race[id][ 1 ]
			RaceHandler.race[id][ checkPointNr ].PrevNode = RaceHandler.race[id][ (checkPointNr - 1) ]
			RaceHandler.race[id][ (checkPointNr - 1) ].NextNode = RaceHandler.race[id][ checkPointNr ]
			RaceHandler.race[id][ 1 ].PrevNode = RaceHandler.race[id][ checkPointNr ]
		end
		
		RaceHandler:SetAllHeaderInfo( id )	
		checkPoint:SetRaceID( checkPointNr, id )
		return true
	end
	
	return false
end

function RaceHandler:PlyIsAheadOfPly2( ply, ply2 )

	if ply2.SCarCurrentLap == nil or ply2.SCarNextRaceCheckpoint == nil then return true end

	if !ply:InVehicle() then return false end
	if !ply2:InVehicle() then return true end
	
	if ply.SCarCurrentLap != nil or ply.SCarNextRaceCheckpoint != nil then

		if ply.SCarCurrentLap > ply2.SCarCurrentLap then 
			return true
		elseif ply.SCarCurrentLap == ply2.SCarCurrentLap then --On same lap
			
			if ply.SCarNextRaceCheckpoint.CheckPointNr > ply2.SCarNextRaceCheckpoint.CheckPointNr then
				return true
			elseif ply.SCarNextRaceCheckpoint.CheckPointNr == ply2.SCarNextRaceCheckpoint.CheckPointNr then --On same checkpoint
				
				if ply.SCarNextRaceCheckpoint:GetPos():Distance( ply:GetPos() ) < ply2.SCarNextRaceCheckpoint:GetPos():Distance( ply2:GetPos() ) then --Closest to the checkpoint wins
					return true
				end
			end
		end
	end
	
	return false
end

function RaceHandler:CalculatePlayerPositions( id )
	if RaceHandler:RaceExists( id ) and RaceHandler.race[id].NrOfRacers > 0 then
		--RaceHandler.race[id].PlayerRacersPositions = {}

		--Copy the content (one sorted and one un-sorted)
		for i = 1, RaceHandler.race[id].NrOfRacers do
			RaceHandler.race[id].PlayerRacersPositionsOld[i] = RaceHandler.race[id].PlayerRacersPositions[i]
			RaceHandler.race[id].PlayerRacersPositions[i] = RaceHandler.race[id].PlayerRacers[i]
		end

		RaceHandler:PlyQuickSort(id, 1, RaceHandler.race[id].NrOfRacers )


		
		local change = false
		local str = ""
		for i = 1, RaceHandler.race[id].NrOfRacers do
			if RaceHandler.race[id].PlayerRacersPositionsOld[i]:Nick() != RaceHandler.race[id].PlayerRacersPositions[i]:Nick() then
				change = true
				for i = 1, RaceHandler.race[id].NrOfRacers do
					str = str..RaceHandler.race[id].PlayerRacersPositions[i]:Nick().."¤"
				end
				break				
			end
		end
	
		
		if change == true then
			for i = 1, RaceHandler.race[id].NrOfRacers do
				if !RaceHandler.race[id].PlayerRacers[i]:IsBot() then-----REMOVE THIS
					RaceHandler:PlayerSetRacePositions( str , RaceHandler.race[id].PlayerRacers[i] )
				end
			end			
		end

	end
end

function RaceHandler:PlyQuickSort(id, aStart, aEnd )

	if aStart < aEnd then
		local p = RaceHandler:PlyQuickPartition(id, aStart, aEnd )
		RaceHandler:PlyQuickSort(id, aStart, p-1 )
		RaceHandler:PlyQuickSort(id, p+1, aEnd )
	end

end

function RaceHandler:PlyQuickPartition(id, aStart, aEnd )

	local pivotValue = RaceHandler.race[id].PlayerRacersPositions[aStart];
	local pivotPosition = aStart;
	

	for pos = (aStart +1), aEnd do
		
		if !RaceHandler:PlyIsAheadOfPly2( pivotValue, RaceHandler.race[id].PlayerRacersPositions[pos] ) then
			local tmp = nil
		
			tmp = RaceHandler.race[id].PlayerRacersPositions[pivotPosition + 1]
			RaceHandler.race[id].PlayerRacersPositions[pivotPosition + 1] = RaceHandler.race[id].PlayerRacersPositions[pos]
			RaceHandler.race[id].PlayerRacersPositions[pos] = tmp
			
	
			tmp = RaceHandler.race[id].PlayerRacersPositions[pivotPosition]
			RaceHandler.race[id].PlayerRacersPositions[pivotPosition] = RaceHandler.race[id].PlayerRacersPositions[pivotPosition + 1]
			RaceHandler.race[id].PlayerRacersPositions[pivotPosition + 1] = tmp	
	
			pivotPosition = pivotPosition + 1;
		end
	
	end
	return pivotPosition;
	
end


function RaceHandler:SetAllHeaderInfo( id )
	
	if RaceHandler.race[id] && RaceHandler.race[id].NrOfCheckPoints > 0 then
	
		local startInd = RaceHandler.race[id][ 1 ]:EntIndex()
		local ent = RaceHandler.race[id][ 1 ]
		local curIndex = nil
		local count = 1
		
		local raceStarter = ent.RaceStarter
		
		if IsValid(raceStarter) then
			raceStarter:SetMessageColor( RaceHandler.race[id].msgCol )
			raceStarter:SetMessage( RaceHandler.race[id].msg )
		end
		
		while startInd != curIndex do
		
			local str = ""

			ent:SetRaceMsgAndCol( RaceHandler.race[id].msgCol, RaceHandler.race[id].msg)
			
			if count == 1 then
				str = "Start"
			elseif ent.NextNode.LastStrId == "Start" then
				str = "Finish"
			else
				str = "Nr:"..(count - 1)
			end

			ent:SetHeaderInfo( str )
			ent.CheckPointNr = (count - 1)
			
			if raceStarter then
				ent:SetNWEntity("RaceStarterEnt", raceStarter )
			end
			
			ent = ent:GetNextNode()
			curIndex = ent:EntIndex()
			count = count + 1
			
			--Just to be sure things won't freeze
			if count > RaceHandler.race[id].NrOfCheckPoints + 2 then
				SCarsReportError("Warning! Race track not finding all checkpoints")
				break
			end
		end
	end
end

function RaceHandler:RemoveSpecificCheckPointFromRace(id, cpID, checkPoint)

	if cpID > 0 then
		checkPoint.PrevNode.NextNode = checkPoint.NextNode
		checkPoint.NextNode.PrevNode = checkPoint.PrevNode
		
		
		local i = cpID
		while i <= (RaceHandler.race[id].NrOfCheckPoints - 1) do
			RaceHandler.race[id][i] = RaceHandler.race[id][i + 1]
			RaceHandler.race[id][i]:SetRaceID( i, id )
			i = i + 1
		end

		RaceHandler.race[id].NrOfCheckPoints = RaceHandler.race[id].NrOfCheckPoints - 1
		RaceHandler:SetAllHeaderInfo( id )
		
		return true
	end
	
	return false
end

function RaceHandler:RemoveCheckPointFromRace( id, checkPoint )

	if checkPoint.RaceID && checkPoint.CheckPointID then 
		return RaceHandler:RemoveSpecificCheckPointFromRace(id, checkPoint.CheckPointID, checkPoint)
	end

	if IsValid( checkPoint ) then
		local nrOfNodes = RaceHandler.race[id].NrOfCheckPoints

		for i = 1, nrOfNodes do
			if RaceHandler.race[id][ i ]:EntIndex() == checkPoint:EntIndex() then
				checkPoint.PrevNode.NextNode = checkPoint.NextNode
				checkPoint.NextNode.PrevNode = checkPoint.PrevNode

				RaceHandler.race[id][i] = RaceHandler.race[id][nrOfNodes]
				RaceHandler.race[id].NrOfCheckPoints = RaceHandler.race[id].NrOfCheckPoints - 1
				break
			end
		end
		
		RaceHandler:SetAllHeaderInfo( id )
		
		return true
	end
	
	return false
end



function RaceHandler:StartRace( id )
	if RaceHandler.race[id] && RaceHandler.race[id].NrOfRacers > 0 then
		
		RaceHandler.race[id].RaceIsStarted = true
		RaceHandler.race[id].RaceIsFinished = false
		RaceHandler.race[id].NrOfFinishedRacers = 0
		RaceHandler.race[id].RaceEndCountDown = false
		
		for i = 1, RaceHandler.race[id].NrOfCheckPoints do
			RaceHandler.race[id][ i ]:ClearPassedPlayers()
		end
		
		local chkPnt = RaceHandler.race[id][1]:GetPrevNode()
		
		if chkPnt && IsValid(chkPnt) then
			
			RaceHandler.race[id].PlayerRacersPositions = {}
			RaceHandler.race[id].PlayerRacersPositionsOld = {}	
			local str = ""
			
			for i = 1, RaceHandler.race[id].NrOfRacers do
				str = RaceHandler.race[id].PlayerRacers[i]:Nick().."¤"
				RaceHandler.race[id].PlayerRacersPositions[i] = RaceHandler.race[id].PlayerRacers[i]
				RaceHandler.race[id].PlayerRacersPositionsOld[i] = RaceHandler.race[id].PlayerRacers[i]	
			end
				
			for i = 1, RaceHandler.race[id].NrOfRacers do
				RaceHandler.race[id].PlayerRacers[i].SCarNextRaceCheckpoint = nil
	
				RaceHandler:PlayerSetRaceShowHud( true , RaceHandler.race[id].PlayerRacers[i] ) --Enable the race hud
				RaceHandler:PlayerSetLapsToGoHud( RaceHandler.race[id].Laps , RaceHandler.race[id].PlayerRacers[i] )
				RaceHandler:PlayerSetCurrentLapHud( 1 , RaceHandler.race[id].PlayerRacers[i] )
				RaceHandler:PlayerSetStartLapTimeHud( CurTime() , RaceHandler.race[id].PlayerRacers[i] )
				RaceHandler:PlayerSetStartTimeHud( CurTime() , RaceHandler.race[id].PlayerRacers[i] )				
				
				chkPnt:ClearPassedPlayers()
				RaceHandler.race[id].RaceInfo[i] = {}
				RaceHandler.race[id].RaceInfo[i].finished = false
				RaceHandler.race[id].RaceInfo[i].finishTime = 0
				RaceHandler.race[id].RaceInfo[i].Laps = 1
				
				RaceHandler:PlayerSetRacePositions( str , RaceHandler.race[id].PlayerRacers[i] )				
			end
		end
		RaceHandler:RaceRegisterStartTime( id )		
	end
end

function RaceHandler:RaceIsOn( id )
	return RaceHandler.race[id].RaceIsStarted
end


function RaceHandler:StopRace( id )
	RaceHandler.race[id].RaceIsStarted = false
	RaceHandler.race[id].RaceIsFinished = false
	
	for i = 1, RaceHandler.race[id].NrOfRacers do
		RaceHandler:PlayerSetRaceShowHud( false , RaceHandler.race[id].PlayerRacers[i] ) --Disable the race hud
	end
	
	RaceHandler.race[id].NrOfFinishedRacers = 0
end

function RaceHandler:RaceRegisterStartTime( id )
	if RaceHandler.race[id] != nil then
		RaceHandler.race[id].StartTime = CurTime()
	end
end

function RaceHandler:RaceGetStartTime( id )
	if RaceHandler.race[id] then
		return RaceHandler.race[id].StartTime
	end
	return 0
end

function RaceHandler:RegisterLastRaceTime(id, ply)
	local slot = RaceHandler:PlayerIsRegistered( id, ply )
	RaceHandler.race[id].LastRaceTime[slot] = CurTime()
	
	RaceHandler:PlayerSetCurrentLapHud( RaceHandler.race[id].RaceInfo[slot].Laps, ply )
	RaceHandler:PlayerSetStartLapTimeHud( CurTime() , ply )
	
end

function RaceHandler:GetLastRaceTime(id, ply)
	local slot = RaceHandler:PlayerIsRegistered( id, ply )
	if RaceHandler.race[id] && slot != 0 then
		return RaceHandler.race[id].LastRaceTime[slot]
	end

	return 0
end


function RaceHandler:ClearRace(id)
	if RaceHandler.race[id] then
		RaceHandler.race[id].Laps = 1
	end
end
-----------------------------------------
function RaceHandler:PlayerIsRegistered(id, ply)
	if RaceHandler:RaceExists( id ) and RaceHandler.race[id].NrOfRacers >= 1 then
		for i = 1, RaceHandler.race[id].NrOfRacers do
			if ply != NULL and ply:IsPlayer() && ply:UniqueID() == RaceHandler.race[id].PlayerRacers[i]:UniqueID() then
				return i
			end
		end
	end
	return 0
end

		
function RaceHandler:PlayerIsAttendingInRace( ply )
	
	local id = 0
	for i = 1, RaceHandler.nrOfRaces do
		id = RaceHandler:PlayerIsRegistered(RaceHandler.raceId[i], ply)
		if id != 0 then 
			return RaceHandler.raceId[i], id 
		end
	end
	
	return 0
end

function RaceHandler:ClearPlayersFromRace(id)
	if RaceHandler.race[id] then
		if RaceHandler.race[id].NrOfRacers then
			for i = 1, RaceHandler.race[id].NrOfRacers do
				self:PlayerSetRaceShowHud( false , RaceHandler.race[id].PlayerRacers[i] )
			end
		end
		
		if RaceHandler.race[id] then
			RaceHandler.race[id].NrOfRacers = 0
			RaceHandler.race[id].RaceIsStarted = false
			RaceHandler.race[id].SomeoneFinished = false
		end
	end
end

function RaceHandler:RegisterPlayer(id, ply)
	if RaceHandler.race[id] then
		local slot = RaceHandler:PlayerIsRegistered(id, ply)
		
		if slot == 0 then
		
			local RaceId, plyID = RaceHandler:PlayerIsAttendingInRace( ply )
			
			if RaceId != 0 then
				RaceHandler:UnRegisterPlayer(RaceId, ply, plyID)
				RaceHandler:UpdateRaceEntScreen( RaceId )
			end	
		
			RaceHandler.race[id].NrOfRacers = RaceHandler.race[id].NrOfRacers + 1
			RaceHandler.race[id].PlayerRacers[RaceHandler.race[id].NrOfRacers] = ply
			
			RaceHandler.race[id].RaceInfo[RaceHandler.race[id].NrOfRacers] = {}
			RaceHandler.race[id].RaceInfo[RaceHandler.race[id].NrOfRacers].finished = false
			RaceHandler.race[id].RaceInfo[RaceHandler.race[id].NrOfRacers].finishTime = 0
			RaceHandler.race[id].RaceInfo[RaceHandler.race[id].NrOfRacers].Laps = 1
		end
	end
end

function RaceHandler:GetPlayerRaceInfo(id, ply)
	local slot = RaceHandler:PlayerIsRegistered(id, ply)
	
	if slot != 0 then
		return RaceHandler.race[id].RaceInfo[slot]
	end
	
	return nil
end

function RaceHandler:UnRegisterPlayer(RaceId, ply, plyID)


	if !plyID then plyID = RaceHandler:PlayerIsRegistered(RaceId, ply) end

	if plyID != 0 then
		self:PlayerSetRaceShowHud( false , ply )
		RaceHandler.race[RaceId].PlayerRacers[plyID] = RaceHandler.race[RaceId].PlayerRacers[RaceHandler.race[RaceId].NrOfRacers]
		RaceHandler.race[RaceId].NrOfRacers = RaceHandler.race[RaceId].NrOfRacers - 1
	end
	
	if RaceHandler.race[RaceId].NrOfRacers <= 0 then
		RaceHandler.race[RaceId].SomeoneFinished = false
	end
end


function RaceHandler:RaceIsStarted( id )
	if RaceHandler.race[id] then
		return RaceHandler.race[id].RaceIsStarted
	end
	
	return false
end

function RaceHandler:PlayerFinishedRace( id, ply, finTime )

	local slot = RaceHandler:PlayerIsRegistered(id, ply)

	if slot != 0 then
	
		RaceHandler:PlayerSetRaceShowHud( false , RaceHandler.race[id].PlayerRacers[slot] ) --Disable the race hud

		if RaceHandler.race[id].RaceInfo[slot].finished == false then
			RaceHandler.race[id].RaceInfo[slot].finishTime = finTime
			
			--Start race countdown
			if RaceHandler.race[id].NrOfFinishedRacers == 0 then
				RaceHandler:SetEndRaceCountDown( id, GetConVarNumber( "scar_raceendime" ) )
			end	
			
			RaceHandler.race[id].NrOfFinishedRacers = RaceHandler.race[id].NrOfFinishedRacers + 1
			RaceHandler.race[id].RaceInfo[slot].finished = true	
			
			
			if RaceHandler:RaceIsFinished(id) then
				RaceHandler.race[id].RaceIsStarted = false
				RaceHandler.race[id].RaceIsFinished = true			
			end
			
			local tempInfo = RaceHandler.race[id].RaceInfo[ RaceHandler.race[id].NrOfFinishedRacers ]
			local temp = RaceHandler.race[id].PlayerRacers[ RaceHandler.race[id].NrOfFinishedRacers ]
			
			RaceHandler.race[id].PlayerRacers[ RaceHandler.race[id].NrOfFinishedRacers ] =  RaceHandler.race[id].PlayerRacers[ slot ]
			RaceHandler.race[id].RaceInfo[ RaceHandler.race[id].NrOfFinishedRacers ] =  RaceHandler.race[id].RaceInfo[ slot ]
			
			RaceHandler.race[id].PlayerRacers[ slot ] = temp
			RaceHandler.race[id].RaceInfo[ slot ] = tempInfo
			
			RaceHandler.race[id].SomeoneFinished = true
		end	
	end
	
	if RaceHandler.race[id].RaceHandlerEnt != NULL && IsValid( RaceHandler.race[id].RaceHandlerEnt ) then
		RaceHandler.race[id].RaceHandlerEnt:UpdatePlayerScreen()
	end
end

function RaceHandler:SetEndRaceCountDown( id, endTime )

	if RaceHandler.race[id].RaceEndCountDown == false then
	
		RaceHandler.race[id].RaceEndCountDown = true
		
		timer.Create( "SCarRaceEndTimer"..id, endTime, 1, function()
			if RaceHandler.race[id].RaceEndCountDown == true and RaceHandler:RaceIsStarted( id ) then
				RaceHandler:StopRace( id )
				RaceHandler.race[id].RaceEndCountDown = false
			end
		end )

		for i = 1, RaceHandler.race[id].NrOfRacers do
			RaceHandler:PlayerSetRaceEndCountDown( endTime , RaceHandler.race[id].PlayerRacers[i] )
		end		
	end	
end

function RaceHandler:RaceIsFinished( id )
	if RaceHandler.race[id].NrOfFinishedRacers >= RaceHandler.race[id].NrOfRacers  then return true end
	return false
end
function RaceHandler:AddLap( id )
	RaceHandler.race[id].Laps = RaceHandler.race[id].Laps + 1
	
	if RaceHandler.race[id].Laps > 5 then
		RaceHandler.race[id].Laps = 1
	end
end

function RaceHandler:GetNrOfLaps( id )
	return RaceHandler.race[id].Laps
end

function RaceHandler:AddLapToPlayer( id, ply )
	local slot = RaceHandler:PlayerIsRegistered(id, ply)

	if slot != 0 then
		RaceHandler.race[id].RaceInfo[slot].Laps = RaceHandler.race[id].RaceInfo[slot].Laps + 1
	end
end

function RaceHandler:GetAllParticipators( id )
	return RaceHandler.race[id].PlayerRacers, RaceHandler.race[id].NrOfRacers
end

function RaceHandler:GetRaceInfoAsString( id )
	local str = ""
	local sepSign = "@"
	if RaceHandler.race[id].SomeoneFinished == true then
	
		for i = 1, RaceHandler.race[id].NrOfRacers do
			if RaceHandler.race[id].RaceInfo[i].finished == true then
				local secs, mins = self:TransformTime( RaceHandler.race[id].RaceInfo[i].finishTime )
				str = str..i..". "..RaceHandler.race[id].PlayerRacers[i]:Nick().."  "..mins..":"..secs..sepSign
			else
				str = str..RaceHandler.race[id].PlayerRacers[i]:Nick().." Not Finished"..sepSign
			end
		end		
		
	else
		for i = 1, RaceHandler.race[id].NrOfRacers do
			str = str..RaceHandler.race[id].PlayerRacers[i]:Nick()..sepSign
		end		
	end
	
	return str
end

function RaceHandler:TransformTime( tm )
	local mins = math.floor(tm / 60)
	local secs = math.Round((tm - (mins * 60)) * 100) / 100
	return secs, mins
end

function RaceHandler:SetRaceHandlerEnt( id, ent )
	if RaceHandler.race[id] then
		RaceHandler.race[id].RaceHandlerEnt = ent
	else
		SCarsReportError("Couldn't apply racehandler to race with ID "..id)
	end
end

	
function RaceHandler.PlayerDisconnect( ply )

	local RaceId, plyID = RaceHandler:PlayerIsAttendingInRace( ply )
	
	if RaceId != 0 then
		RaceHandler:UnRegisterPlayer(RaceId, ply, plyID)
		RaceHandler:UpdateRaceEntScreen( RaceId )
	end		
	

	--Remove all checkpoints
	local finalID = ply:UniqueID() * 100
	for i = 1, 10 do
		RaceHandler:RemoveAllCheckpointsInRace( finalID + i )
	end	

	
end
hook.Add( "PlayerDisconnected", "ScarRaceHandlerPlayerDisconnect", RaceHandler.PlayerDisconnect )

function RaceHandler:PlayerSetRacePositions( strPositions , ply )
	if ply != NULL and ply && ply:IsPlayer() && !ply:IsBot()  then
		umsg.Start( "SCarSetRacePositions", ply )
			umsg.String( strPositions )
		umsg.End()
	end
end

function RaceHandler:PlayerSetRaceShowHud( shouldShow , ply )
	if ply != NULL and ply && ply:IsPlayer() && !ply:IsBot() then
		umsg.Start( "SCarShowHud", ply )
			umsg.Bool( shouldShow )
		umsg.End()
	end
end

function RaceHandler:PlayerSetRaceEndCountDown( endTime , ply )
	if ply && ply:IsPlayer() && !ply:IsBot() then
		umsg.Start( "SetRaceEndCountDown", ply )
			umsg.Short( endTime )
		umsg.End()
	end
end

function RaceHandler:PlayerSetCurrentLapHud( lap , ply )
	if ply && ply:IsPlayer() && !ply:IsBot() then
		ply.SCarCurrentLap = lap
		umsg.Start( "SCarSetCurrentLap", ply )
			umsg.Short( lap )
		umsg.End()
	end
end

function RaceHandler:PlayerSetLapsToGoHud( lap , ply )
	if ply && ply:IsPlayer() && !ply:IsBot() then
		umsg.Start( "SCarSetLapsToGo", ply )
			umsg.Short( lap )
		umsg.End()
	end
end

function RaceHandler:PlayerSetStartTimeHud( startTime , ply )
	if ply && ply:IsPlayer() && !ply:IsBot() then
		umsg.Start( "SCarSetStartTime", ply )
			umsg.Long( startTime )
		umsg.End()
	end
end

function RaceHandler:PlayerSetStartLapTimeHud( lapTime , ply )
	if ply && ply:IsPlayer() && !ply:IsBot() then
		umsg.Start( "SCarSetStartLapTime", ply )
			umsg.Long( lapTime )
		umsg.End()
	end
end