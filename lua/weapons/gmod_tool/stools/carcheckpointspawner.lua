TOOL.Category		= "SCars"
TOOL.Name			= "#CheckPoint Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar = {
TrackID = "1",
cpstr = "",
rcol = "0",
gcol = "0",
bcol = "0",
}
cleanup.Register( "SCarCheckPoint" )

if CLIENT then

	language.Add( "Tool.carcheckpointspawner.name", "CheckPoint spawner" )	
	language.Add( "Tool.carcheckpointspawner.desc", "Spawn CheckPoints" )		
	language.Add( "Tool.carcheckpointspawner.0", "Primary fire: spawn" )	
	language.Add( "Tool_TrackID", "Track ID" )
	
	language.Add( "Undone_SCarCheckPoint", "Undone SCar CheckPoint" )
	language.Add( "Cleanup_SCarCheckPoint", "SCar CheckPoint" )
	language.Add( "Cleaned_SCarCheckPoint", "CheckPoints Removed" )		
end

function TOOL:LeftClick( trace )


	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carcheckpointspawner", ply) then return false end	
	
	local plyID = ply:UniqueID()
	local TrackID   = math.Clamp( self:GetClientNumber( "TrackID" ), 1, 10)
	local finalID = plyID * 100 + TrackID --This should make all the race id's unique.
	local cpStr = string.sub(self:GetClientInfo("cpstr"),1,12)
	local rc = self:GetClientNumber( "rcol" )
	local gc = self:GetClientNumber( "gcol" )
	local bc = self:GetClientNumber( "bcol" )
		
	local cp = ents.Create( "sent_sakarias_checkPoint" )
	local ang = ply:GetAngles() + Angle(0,180,0)
	cp:SetPos( trace.HitPos )
	cp:SetAngles( ang )
	cp:Spawn()
	cp:SetCarOwner(ply)
	cp.TrackID = finalID
	
	RaceHandler:CreateRace( finalID )
	RaceHandler:AddCheckPointToRace( finalID, cp, cpStr, Color(rc,gc,bc,255)  )
	
	
	ply:AddCount( "SCarCheckPoint", cp )	
		
	undo.Create("SCarCheckPoint")
	undo.AddEntity( cp )
	undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "SCarCheckPoint", cp )	
	
	return true
end

function TOOL:Reload(trace)

	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carcheckpointspawner", ply) then return false end
	
	local plyID = ply:UniqueID()
	local TrackID   = math.Clamp( self:GetClientNumber( "TrackID" ), 1, 10)
	local finalID = plyID * 100 + TrackID --This should make all the race id's unique.
	
	RaceHandler:RemoveAllCheckpointsInRace( finalID )
end

function TOOL.BuildCPanel( CPanel )
								 
	CPanel:AddControl( "Slider", { Label = "#Tool_TrackID",
									 Description = "",
									 Type = "int",
									 Min = 1,
									 Max = 10,
									 Command = "carcheckpointspawner_TrackID" } )
									 
	CPanel:AddControl( "TextBox", {	Label		= "Text",
									MaxLength	= "12",
									Command		= "carcheckpointspawner_cpstr" })		

    CPanel:AddControl( "Color",  { Label    = "#Color",
                                    Red            = "carcheckpointspawner_rcol",
                                    Green        = "carcheckpointspawner_gcol",
                                    Blue        = "carcheckpointspawner_bcol",
                                    ShowAlpha    = 0,
                                    ShowHSV        = 1,
                                    ShowRGB     = 1,
                                    Multiplier    = 255 } ) 									

end