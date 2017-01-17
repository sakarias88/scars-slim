--A track is a circular list

local track = {}
local trackIDs = {}
local nrOfTracks = 0

local function TrackExists( trackID )

	for i = 1, nrOfTracks do
		if trackIDs[i] == trackID then
			return true
		end
	end
	
	return false
end


function CreateTrack( trackID )

	if !TrackExists( trackID ) then
		track[trackID] = {}
		track[trackID].NrOfNodes = 0
		nrOfTracks = nrOfTracks + 1
		trackIDs[nrOfTracks] = trackID
		return true
	end
	
	return false
end

function AddNodeToTrack( trackID, ent )
	CreateTrack( trackID )
	
	if track[trackID] && IsValid( ent ) then
	
		track[trackID].NrOfNodes = track[trackID].NrOfNodes + 1
		local nodeNr = track[trackID].NrOfNodes
		
		
		if nodeNr == 1 then

			track[trackID][ nodeNr ] = ent
			track[trackID][ nodeNr ].NextNode  =  track[trackID][ nodeNr ]
			track[trackID][ nodeNr ].PrevNode  =  track[trackID][ nodeNr ]
		else
			local nodeNr = track[trackID].NrOfNodes			
			
			track[trackID][ nodeNr ] = ent			
			track[trackID][ nodeNr ].NextNode = track[trackID][ 1 ]
			track[trackID][ nodeNr ].PrevNode = track[trackID][ (nodeNr - 1) ]
			track[trackID][ (nodeNr - 1) ].NextNode = track[trackID][ nodeNr ]
			track[trackID][ 1 ].PrevNode = track[trackID][ nodeNr ]

		end
		
	end
	
	return false
end

function GetFirstNode( trackID )

	return track[trackID][ 1 ]

end

function RemoveNodeOnTrack( trackID, ent )

	if IsValid( ent ) then
		local nrOfNodes = track[trackID].NrOfNodes

		for i = 1, nrOfNodes do
			if track[trackID][i]:EntIndex() == ent:EntIndex() then
				ent.PrevNode.NextNode = ent.NextNode
				ent.NextNode.PrevNode = ent.PrevNode
				ent:Remove()
				
				track[trackID][i] = track[trackID][nrOfNodes]
				track[trackID].NrOfNodes = track[trackID].NrOfNodes - 1
				return true
			end
		end
	end
	
	return false
end


function CalibrateTrack( trackID )

	if TrackExists( trackID ) then
		
		local nrOfNodes = track[trackID].NrOfNodes
		
		
		for i = 1, nrOfNodes do
			if IsValid( track[trackID][i] ) && track[trackID][i].IsCalibrated == 0 then
				track[trackID][i]:UpdateSpeedLimitations()
				track[trackID][i].IsCalibrated = 1
			else
				SCarsReportError("Error calibrating track")
			end
		end
		
		for i = 1, nrOfNodes do
			track[trackID][i].IsCalibrated = 0
		end
		
	end
end