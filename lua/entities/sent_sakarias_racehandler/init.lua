--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


ENT.EntOwner = NULL
ENT.CheckPointOwner = NULL
ENT.Laps = 1
ENT.MaxLaps = 5


ENT.Participators = {}
ENT.NrOfParticipators = 0
ENT.NrOfFinishedParticipators = 0


ENT.FinishStr = ""
ENT.SeparationSign = "@"
ENT.UseDelay = CurTime()
ENT.MaxParticipators = 8

ENT.EnterButton = NULL
ENT.LeaveButton = NULL
ENT.StartButton = NULL
ENT.StopButton = NULL
ENT.LapButton = NULL
ENT.RaceID = 0

ENT.FailSafeStartRaceDelay = CurTime()

ENT.UpdateRaceDel = CurTime()
ENT.RaceOn = false
------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )

 	if ( !tr.Hit ) then return end

 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)

	local ent = ents.Create( "sent_Sakarias_RaceHandler" )
	ent:SetPos( SpawnPos )
 	ent:Spawn()
	self:SetCarOwner( ply )
 	ent:Activate()
	return ent

end

function ENT:Initialize()

	self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")
	self:SetOwner(self.Owner)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	self:SetNetworkedString("Participators", "")
	self:SetColor(Color(255, 255, 255, 200))

	self.EnterButton = ents.Create( "sent_Sakarias_RaceHandlerButton" )
	self.EnterButton:SetPos( self:GetPos() + self:GetRight() * 25 + self:GetUp() * 20 )
	self.EnterButton:SetAngles( self:GetAngles() + Angle(0,120, 90) )
	self.EnterButton:SetOwnerEnt( self )
	self.EnterButton:SetTriggerFunction( "AddParticipator", 1 )
	self.EnterButton:SetParent(self)
	self.EnterButton:Spawn()
	self.EnterButton:SetButtonText( "#checkpoint.enter" )

	self.LeaveButton = ents.Create( "sent_Sakarias_RaceHandlerButton" )
	self.LeaveButton:SetPos( self:GetPos() + self:GetRight() * 30 + self:GetUp() * 10 + self:GetForward() * 15 )
	self.LeaveButton:SetAngles( self:GetAngles() + Angle(0,120, 90) )
	self.LeaveButton:SetOwnerEnt( self )
	self.LeaveButton:SetTriggerFunction( "AddParticipator", 2 )
	self.LeaveButton:SetParent(self)
	self.LeaveButton:Spawn()
	self.LeaveButton:SetButtonText( "#checkpoint.leave" )

	self.StartButton = ents.Create( "sent_Sakarias_RaceHandlerButton" )
	self.StartButton:SetPos( self:GetPos() + self:GetRight() * -25 + self:GetUp() * 20 )
	self.StartButton:SetAngles( self:GetAngles() + Angle(0,60,90) )
	self.StartButton:SetOwnerEnt( self )
	self.StartButton:SetTriggerFunction( "AddParticipator", 3 )
	self.StartButton:SetParent(self)
	self.StartButton:Spawn()
	self.StartButton:SetButtonText( "#checkpoint.start" )

	self.StopButton = ents.Create( "sent_Sakarias_RaceHandlerButton" )
	self.StopButton:SetPos( self:GetPos() + self:GetRight() * -30 + self:GetUp() * 10 + self:GetForward() * 15  )
	self.StopButton:SetAngles( self:GetAngles() + Angle(0,60,90) )
	self.StopButton:SetOwnerEnt( self )
	self.StopButton:SetTriggerFunction( "AddParticipator", 4 )
	self.StopButton:SetParent(self)
	self.StopButton:Spawn()
	self.StopButton:SetButtonText( "#checkpoint.reset" )

	self.LapButton = ents.Create( "sent_Sakarias_RaceHandlerButton" )
	self.LapButton:SetPos( self:GetPos() + self:GetUp() * 20 + self:GetForward() * 10  )
	self.LapButton:SetAngles( self:GetAngles() + Angle(0,90,60) )
	self.LapButton:SetOwnerEnt( self )
	self.LapButton:SetTriggerFunction( "AddParticipator", 5 )
	self.LapButton:SetParent(self)
	self.LapButton:Spawn()
	self.LapButton:SetButtonText( "  1  " )

	RaceHandler:SetRaceHandlerEnt( self.RaceID, self )
end

function ENT:Think()


	if self.FailSafeStartRaceDelay < CurTime() then
		self.FailSafeStartRaceDelay = CurTime() + 2
		if self.CheckPointOwner != NULL && IsValid( self.CheckPointOwner ) && self.CheckPointOwner.Start == true then
			local players, nr = RaceHandler:GetAllParticipators( self.RaceID )

			if nr <= 0 then
				self:StopRace( ply )
			end
		end
	end

	if self.RaceOn and self.UpdateRaceDel < CurTime() then
		self.UpdateRaceDel = CurTime() + 2
		RaceHandler:UpdateRace( self.RaceID )
	end

end

function ENT:OnRemove()
	RaceHandler:ClearPlayersFromRace(self.RaceID)
	RaceHandler:ClearRace(self.RaceID)
end

function ENT:TriggerFunc( id , ply )

	local participate = RaceHandler:PlayerIsRegistered(self.RaceID, ply)

	if id == 1 then
		self:AddParticipator( ply )
	elseif id == 2 then
		self:RemoveParticipator( ply )
	elseif id == 3 then
		if participate != 0 then
			self:StartRace( ply )
		else
			self:SendRaceMessage( "#checkpoint.you_have_to_be_participant"..self.SeparationSign.."#checkpoint.to_start_race", 5, ply )
		end
	elseif id == 4 then
		if participate != 0 then
			self:StopRace( ply )
		else
			self:SendRaceMessage( "#checkpoint.you_have_to_be_participant"..self.SeparationSign.."#checkpoint.to_reset_race", 5, ply )
		end
	elseif id == 5 then

		if participate != 0 then
			self:AddLap( ply )
		elseif RaceHandler:RaceIsStarted( self.RaceID ) then
			self:SendRaceMessage( "#checkpoint.you_have_to_wait_untill", 5, ply )
		else
			self:SendRaceMessage( "#checkpoint.you_have_to_be_participant"..self.SeparationSign.."#checkpoint.to_change_nr", 5, ply )
		end
	end

end

function ENT:StartRace( ply )

	if self.CheckPointOwner != NULL && IsValid( self.CheckPointOwner ) then
		if self.CheckPointOwner.Start == false or RaceHandler:RaceIsFinished( self.RaceID ) then
			self.CheckPointOwner:StartRace( ply )
			self.RaceOn = true
			local players, nr = RaceHandler:GetAllParticipators( self.RaceID )
			local ms = ply:Nick().."#checkpoint.started_the_race"
			for i = 1, nr do
				if players[i] then
					self:SendRaceMessage( ms, 5, players[i] )
					self:SetArrowPoint( true, self.CheckPointOwner:GetPos(), players[i] )
				end
			end
		end
	end
end

function ENT:StopRace( ply )

	if self.CheckPointOwner != NULL && IsValid( self.CheckPointOwner )then
		self.RaceOn = false
		local players, nr = RaceHandler:GetAllParticipators( self.RaceID )
		local ms = " reset the race!"

		if ply then
			ms = ply:Nick()..ms
		end

		if self.CheckPointOwner.Start == true then
			self.CheckPointOwner:StopRace( ply )

			if ply then
				for i = 1, nr do
					if players[i] then
						self:SendRaceMessage( ms, 4, players[i] )
						self:SetArrowPoint( false, Vector(0,0,0), players[i] )
					end
				end
			end
		end
	end
end

function ENT:AddLap( ply )
	RaceHandler:AddLap( self.RaceID )

	self.LapButton:SetButtonText( "  "..RaceHandler:GetNrOfLaps( self.RaceID ).."  " )
	self:UpdatePlayerScreen()
end

function ENT:UpdatePlayerScreen()
	local str = RaceHandler:GetRaceInfoAsString( self.RaceID )

	self:SetNetworkedString("Participators", str)
end


function ENT:AddParticipator( ply )
	RaceHandler:RegisterPlayer(self.RaceID, ply)
	self:UpdatePlayerScreen()
end

function ENT:RemoveParticipator( ply )
	RaceHandler:UnRegisterPlayer(self.RaceID, ply)
	self:UpdatePlayerScreen()
end

function ENT:LinkToCheckPoint( cp )
	self.CheckPointOwner = cp
end

function ENT:PlayerFinishedRace( ply, finTime )
	RaceHandler:PlayerFinishedRace( self.RaceID, ply, finTime )

	self:UpdatePlayerScreen()
end

function ENT:SendMessageAll( str, id )
	local players, nr = RaceHandler:GetAllParticipators( self.RaceID )
	for i = 1, nr do
		if players[i] then
			self:SendRaceMessage( str, id, players[i] )
		end
	end
end

--HUD user messages
function ENT:SendRaceMessage( str, id, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "GetSCarRaceMessageFromServer", ply )
			umsg.String( str )
			umsg.Short(id)
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

function ENT:SetArrowPoint( bl, pos, ply )
	if ply && ply:IsPlayer() then
		umsg.Start( "SetArrowPointFromServer", ply )
			umsg.Bool(bl)
			umsg.Vector(pos)
		umsg.End()
	end
end


function ENT:SetMessageColor( col )
	self:SetNetworkedInt( "rCol", col.r )
	self:SetNetworkedInt( "gCol", col.g )
	self:SetNetworkedInt( "bCol", col.b )
end

function ENT:SetMessage( msg )
	self:SetNetworkedString( "MessageText", msg )
end

function ENT:SetCarOwner( ply )
	local world = game.GetWorld()
	SCarSetObjOwner( ply, self )
end
