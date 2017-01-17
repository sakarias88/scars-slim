--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.RaceStage = 0
ENT.RaceIsAboutToStart = false
ENT.RaceStarter = NULL
ENT.LastStrId = ""
ENT.LeftPed = NULL
ENT.RightPed = NULL
ENT.SpaceBetween = 100
ENT.DetectorTrigger = NULL
ENT.OldDist = 0

ENT.Start = false

ENT.RecreateDelay = CurTime() + 1
ENT.Once = false

ENT.NextNode = NULL
ENT.PrevNode = NULL

ENT.BackUpDelay = CurTime()
ENT.PassedPlayers = {}
ENT.PassedPlayersTime = {}
ENT.NrOfPassedPlayers = 0
ENT.RaceID = 0
ENT.CheckPointID = 0

--
ENT.StartRaceDel = CurTime()
ENT.SignalDelay = CurTime()
ENT.SignalAddDelay = 1
ENT.RaceStartStage = false
ENT.RaceAddDelay = 10
ENT.OldStartTime = 0
ENT.sepSign = "@"
ENT.CountDown = -1
ENT.StrMsg = ""
ENT.CheckPointNr = 0

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_sakarias_checkPoint" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	return ent 
	
end

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/sawblade001a.mdl" )
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNotSolid( true )
	self:SetColor( Color(255,0,0,255) )
	
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then 
		phys:Wake() 
		
		phys:EnableMotion( false )
		phys:EnableGravity( false )
	end
	
	self.PassedPlayers = {}
	self.PassedPlayersTime = {}
	

	self.LeftPed = ents.Create( "sent_Sakarias_Pedistal" )	
	self.LeftPed:SetPos( self:GetPos() + self:GetRight() * -self.SpaceBetween + self:GetUp() * 150)	
	self.LeftPed:SetAngles(self:GetAngles() + Angle(0,0,-90))
	self.LeftPed.LORR = 1
	self.LeftPed:Spawn()
	
	
	self.RightPed = ents.Create( "sent_Sakarias_Pedistal" )	
	self.RightPed:SetPos( self:GetPos() + self:GetRight() * self.SpaceBetween + self:GetUp() * 150)	
	self.RightPed:SetAngles(self:GetAngles() + Angle(0,0,-90) )
	self.RightPed.LORR = -1
	self.RightPed:Spawn()
	
	self.LeftPed:SetSecondPedistal( self.RightPed )
	self.RightPed:SetSecondPedistal( self.LeftPed )
	
	
	self:SetNetworkedEntity( "leftPill", self.LeftPed )
	self:SetNetworkedEntity( "rightPill", self.RightPed )
end

function ENT:PhysicsUpdate()
	
	local timeLeft = math.ceil( self.StartRaceDel - CurTime() )
	if self.LastStrId == "Start" && self.CountDown > 0 && self.CountDown > timeLeft && self.Start == true then
		self.CountDown = self.CountDown - 1		
		if self.CountDown == 0 then
			self.RaceStarter:SendMessageAll( "Go!", 0 )	
		else
			self.RaceStarter:SendMessageAll( self.CountDown, 0 )	
		end
	end
	
	if self.StartRaceDel > CurTime() then
		self.RaceIsAboutToStart = true
		if self.RaceStartStage == false then --Get ready!
			
			if self:WasValidEnt( self.LeftPed ) then
				self.LeftPed:ShowRed()
			end

			if self:WasValidEnt( self.RightPed ) then
				self.RightPed:ShowRed()
			end		
			
			self.RaceStartStage = true
			self:EmitSound( "car/raceSignal.mp3", 400, 50 )
		end
		
		local per = ((self.StartRaceDel - CurTime()) / self.RaceAddDelay)
		
		if per < 0.6 then --Set
			if self.SignalDelay < CurTime() then
				self:EmitSound( "car/raceSignal.mp3", 400, 100 )
				self.OldStartTime = math.ceil(self.StartRaceDel)
				self.SignalDelay = CurTime() + self.SignalAddDelay
				
				if self:WasValidEnt( self.LeftPed ) then
					self.LeftPed:ShowYellow()
				end

				if self:WasValidEnt( self.RightPed ) then
					self.RightPed:ShowYellow()
				end					
			end
			
			if CurTime() > (self.SignalDelay - self.SignalAddDelay / 2) then
				if self:WasValidEnt( self.LeftPed ) then
					self.LeftPed:ShowNothing()
				end

				if self:WasValidEnt( self.RightPed ) then
					self.RightPed:ShowNothing()
				end					
			end
		end
	elseif self.RaceStartStage == true && self.Start == true then --GO!
		self.RaceIsAboutToStart = false
		RaceHandler:StartRace( self.RaceID )

		if self:WasValidEnt( self.LeftPed ) then
			self.LeftPed:ShowGreen()
		end

		if self:WasValidEnt( self.RightPed ) then
			self.RightPed:ShowGreen()
		end				
		self.RaceStartStage = false
		self:EmitSound( "car/raceSignal.mp3", 400, 150 )
		self.RaceStage = 1
	end
end


-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
end
-------------------------------------------THINK
function ENT:Think()

	if self:WasValidEnt( self.LeftPed ) && self:WasValidEnt( self.RightPed ) then
		self:SetPos((self.LeftPed:GetPos() + self.RightPed:GetPos()) / 2 + Vector(0,0,230))
		
		if self.Start == false or RaceHandler:RaceIsFinished( self.RaceID ) then
			self.LeftPed:ShowNothing()
			self.RightPed:ShowNothing()		
		end
	end

	if self.LastStrId == "Start" && (self.RaceStarter == NULL or self.RaceStarter != NULL && !IsValid(self.RaceStarter)) then

		local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetPos() + Vector(0,0,-400)
		trace.filter =  { self, self.LeftPed, self.RightPed, self.DetectorTrigger }
		local tr = util.TraceLine( trace )	
	
		self.RaceStarter = ents.Create("sent_Sakarias_RaceHandler")
		self.RaceStarter.RaceID = self.RaceID
		self.RaceStarter:Spawn()
		self.RaceStarter:SetCarOwner(self.SpawnedBy)
		self.RaceStarter:SetPos( tr.HitPos + Vector(0,0,40) )
		self.RaceStarter:SetAngles( tr.HitNormal:Angle() + Angle(90,0,0) )
		self.RaceStarter:LinkToCheckPoint( self )
		
		
		
		self:SetNWEntity("RaceStarterEnt", self.RaceStarter )
		
		self.RaceStarter:SetMessageColor(self.raceCol)
		self.RaceStarter:SetMessage(self.raceMsg)

		RaceHandler:SetAllHeaderInfo( self.TrackID )
		
	elseif self.LastStrId != "Start" && self.RaceStarter != NULL && IsValid(self.RaceStarter) then
		self.RaceStarter:Remove()
		self.RaceStarter = NULL

	end
	
	
	
	self:GetPhysicsObject():Wake()

	if !self:WasValidEnt( self.LeftPed ) or !self:WasValidEnt( self.RightPed ) then
		self:Remove()
		
		return
	end

	local dist = math.floor( self.LeftPed:GetPos():Distance( self.RightPed:GetPos() ) )
	
	
	if self.OldDist != dist then
		self.OldDist = dist
		self:ReCreateTrigger( dist )
	end
end

function ENT:OnRemove()


	if self.RaceID && !self.CheckPointID then
		RaceHandler:RemoveCheckPointFromRace( self.RaceID, self )
	elseif self.RaceID && self.CheckPointID then 
		RaceHandler:RemoveSpecificCheckPointFromRace(self.RaceID, self.CheckPointID, self)
	end

	if self:WasValidEnt( self.RaceStarter ) then
		self.RaceStarter:Remove()
	end	
	
	if self:WasValidEnt( self.LeftPed ) then
		self.LeftPed:Remove()
	end

	if self:WasValidEnt( self.RightPed ) then
		self.RightPed:Remove()
	end
	
	if self:WasValidEnt( self.DetectorTrigger ) then
		self.DetectorTrigger:Remove()
	end	

end

function ENT:ReCreateTrigger( dist )

	if self:WasValidEnt( self.LeftPed ) && self:WasValidEnt( self.RightPed ) then
		if self:WasValidEnt( self.DetectorTrigger ) then
			self.DetectorTrigger:Remove()
		end
		local pos = (self.LeftPed:GetPos() + self.RightPed:GetPos()) / 2	
		local ang = (self.LeftPed:GetPos() - self.RightPed:GetPos()):Angle() + Angle(0,90,0)
		self.DetectorTrigger = ents.Create( "sent_Sakarias_CheckDetector" )
		self.DetectorTrigger:SetModel("models/props_junk/sawblade001a.mdl")
		self.DetectorTrigger.width = dist	
		self.DetectorTrigger.rot = ang
		self.DetectorTrigger:SetAngles( ang )
		self.DetectorTrigger:SetPos( pos ) 		
		self.DetectorTrigger:Spawn()
		SCarSetObjOwner(self.SpawnedBy, self.DetectorTrigger)
		self.DetectorTrigger:SetNoDraw( true )
		self.DetectorTrigger:SetEntityOwner( self )	
	end
end

function ENT:CarInside( ent )
	local ply = ent:GetDriver()
	if self.RaceIsAboutToStart == true then
		self:SendRaceMessage( "", 6, ply, 0 )
	end
end

function ENT:CarEntered( ent )
	local ply = ent:GetDriver()
	local slot = self:GetPrevNode():PlayerHasPassed( ply )
	local RaceInfo = RaceHandler:GetPlayerRaceInfo( self.RaceID, ply)

	if RaceInfo and ply:IsPlayer() && (slot != 0 or self.LastStrId == "Start") && RaceHandler:RaceIsStarted( self.RaceID ) then
		local succes = self:AddPassedPlayer( ply )
		
		if succes == true then------------------------------------------------------------------------------------------
			if self.NextNode.LastStrId == "Start" then

				if RaceInfo.Laps >= RaceHandler:GetNrOfLaps( self.RaceID ) then --Finishes Race

					local secs, mins = self:TransformTime( CurTime() - RaceHandler:RaceGetStartTime( self.RaceID ))
					local str = "Finish"..self.sepSign..mins..":"..secs
					local Time = CurTime() - RaceHandler:RaceGetStartTime( self.RaceID )
					RaceHandler:PlayerFinishedRace( self.RaceID, ply, Time )
					self:SendRaceMessage( str, 3, ply, Time )			
				else --New lap
					RaceInfo.Laps = RaceInfo.Laps + 1
					
					local newSlot = self:PlayerHasPassed( ply )
					local Time = CurTime() - RaceHandler:RaceGetStartTime( self.RaceID )
					local secs, mins = self:TransformTime(Time)
					local str = "Lap "..RaceInfo.Laps..self.sepSign..mins..":"..secs
					
		
					if  RaceInfo.Laps > 2 && newSlot != 0 then
						Time = (CurTime() - RaceHandler:GetLastRaceTime( self.RaceID, ply ))
						secs, mins = self:TransformTime( Time )
						str = "Lap "..RaceInfo.Laps..self.sepSign..mins..":"..secs
					end
					
					RaceHandler:RegisterLastRaceTime(self.RaceID, ply)
					self:ClearPlayerFromCheckPoints(ply)
					self:SendRaceMessage( str, 2, ply, Time )	
					
					if self.NextNode and self.NextNode != NULL then
						self:SetArrowPoint( true, self.NextNode:GetPos(), ply )
						ply.SCarNextRaceCheckpoint = self.NextNode
					end					
				end
			else --Through CheckPoint
			
			
				if self.NextNode and self.NextNode != NULL then
					self:SetArrowPoint( true, self.NextNode:GetPos(), ply )
					ply.SCarNextRaceCheckpoint = self.NextNode
				end			
				
				if self.LastStrId != "Start" or (self.LastStrId == "Start" && RaceInfo.Laps > 1 ) then
					local theTime = 0
					if RaceInfo.Laps > 1 then
						theTime = (CurTime() - RaceHandler:GetLastRaceTime( self.RaceID, ply ))
					else
						theTime = (CurTime() - RaceHandler:RaceGetStartTime( self.RaceID ))
					end	
					
					local secs, mins = self:TransformTime( theTime )
					local str = mins..":"..secs
					self:SendRaceMessage( str, 1, ply, theTime )
				end
			end
		end
	elseif self.RaceIsAboutToStart == true then
		self:SendRaceMessage( "", 6, ply, 0 )
	end
end

--HUD user messages
function ENT:SendRaceMessage( str, id, ply, flt )
	if ply && ply:IsPlayer() then
		umsg.Start( "GetSCarRaceMessageFromServer", ply )
			umsg.String( str )
			umsg.Short(id)
			
			flt = flt or 1
			umsg.Float( flt )
		umsg.End()
	end
end

function ENT:SetArrowPoint( bl, pos, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SetArrowPointFromServer", ply )
			umsg.Bool(bl)
			umsg.Vector(pos)
		umsg.End()
	end
end


function ENT:WasValidEnt( ent )
	if ent != NULL && ent != nil && IsValid( ent ) then
		return true
	end

	return false
end


function ENT:GetNextNode()

	if self:WasValidEnt( self.NextNode ) then
		return self.NextNode
	end
	
	return nil
end

function ENT:GetPrevNode()

	if self:WasValidEnt( self.PrevNode ) then
		return self.PrevNode
	end
	
	return nil
end

function ENT:SetRaceID( id, raceID )
	self.CheckPointID = id
	self.RaceID = raceID
end

function ENT:SetMessageColor( col )
	self:SetNetworkedInt( "rCol", col.r )
	self:SetNetworkedInt( "gCol", col.g )
	self:SetNetworkedInt( "bCol", col.b )
end

function ENT:SetMessage( msg )
	self:SetNetworkedString( "MessageText", msg )
end

function ENT:SetHeaderInfo( str )

	self:SetNetworkedString( "HeaderText", str )
	self.LastStrId = str
	

	if self.LastStrId == "Start" then
		
		if self:WasValidEnt( self.RightPed ) then
			self.RightPed:ShowTrafficLights( true )
		end
		
		if self:WasValidEnt( self.LeftPed ) then
			self.LeftPed:ShowTrafficLights( true )
		end
			
	else
		if self:WasValidEnt( self.RightPed ) then
			self.RightPed:ShowTrafficLights( false )
		end
		
		if self:WasValidEnt( self.LeftPed ) then
			self.LeftPed:ShowTrafficLights( false )
		end
	end	
end

function ENT:StartRace( ply )
	self.RaceIsAboutToStart = false
	self.Start = true
	self.StartRaceDel = CurTime() + self.RaceAddDelay
	self.RaceStartStage = false
	self.RaceStage = 0
	self.CountDown = 6
	
	RaceHandler:StopRace( self.RaceID )
	
	if self.RaceStarter && IsValid( self.RaceStarter )then
		self.RaceStarter:UpdatePlayerScreen()
	end
end

function ENT:StopRace( ply )
	self.RaceIsAboutToStart = false
	self.Start = false
	self.RaceStartStage = false
	RaceHandler:StopRace( self.RaceID )

	
	self.StartRaceDel = CurTime()
	self.RaceStage = 0

	if self:WasValidEnt( self.LeftPed ) then
		self.LeftPed:ShowNothing()
	end

	if self:WasValidEnt( self.RightPed ) then
		self.RightPed:ShowNothing()
	end		
end

function ENT:GetPlyTime( ply )
	
	local slot = self:PlayerHasPassed( ply )

	if slot != 0 then
		return self.PassedPlayersTime[slot]
	end	
		
	return -1
end

function ENT:RaceIsOn()

	if RaceHandler:RaceIsOn( self.RaceID ) == true or self.RaceStartStage == true then
		return true
	end

	return false
end

function ENT:AddPassedPlayer( ply )

	if self:PlayerHasPassed( ply ) == 0 then
		self.NrOfPassedPlayers = self.NrOfPassedPlayers + 1
		self.PassedPlayers[self.NrOfPassedPlayers] = ply
		self.PassedPlayersTime[self.NrOfPassedPlayers] = CurTime()

		return true
	end
	
	return false
end

function ENT:RemovePlayer( slot )
	self.PassedPlayers[slot] = self.PassedPlayers[self.NrOfPassedPlayers] 
	self.NrOfPassedPlayers = self.NrOfPassedPlayers - 1
end


function ENT:ClearPassedPlayers()
	self.NrOfPassedPlayers = 0
end

function ENT:ClearPlayerFromCheckPoints(ply)

		local startInd = self:EntIndex()
		local ent = self
		local curIndex = nil
		local count = 1
		
		
		while startInd != curIndex do
		
			local slot = ent:PlayerHasPassed( ply )
			
			if slot != 0 then
				ent:RemovePlayer( slot )
			end
			
			ent = ent:GetPrevNode()
			curIndex = ent:EntIndex()
			count = count + 1
			
			if count > RaceHandler.race[self.RaceID].NrOfCheckPoints + 10 then
				SCarsReportError("Warning! Track not finding all checkpoints ENTITY")
				break
			end
		end
end

function ENT:PlayerHasPassed( ply )

	for i = 1, self.NrOfPassedPlayers do
		if ply && ply != NULL && ply:IsPlayer() && self.PassedPlayers[i] && self.PassedPlayers[i] != nil && self.PassedPlayers[i]:UserID() == ply:UserID() then 
			return i 
		end
	end

	return 0
end

function ENT:TransformTime( tm )
	local mins = math.floor(tm / 60)
	local secs = math.Round((tm - (mins * 60)) * 100) / 100
	return secs, mins
end

function ENT:SetRaceMsgAndCol( col, msg )
	self.raceCol = col
	self.raceMsg = msg
end

function ENT:SetCarOwner(ply)
	SCarSetObjOwner(ply, self)
	SCarSetObjOwner(ply, self.LeftPed)
	SCarSetObjOwner(ply, self.RightPed)

	if IsValid(self.DetectorTrigger) then
		SCarSetObjOwner(ply, self.DetectorTrigger)
	end

	if IsValid(self.RaceStarter) then
		self.RaceStarter:SetCarOwner( ply )
	end
end

function ENT:CPPIGetOwner()
	return self.SpawnedBy
end