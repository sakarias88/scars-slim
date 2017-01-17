TOOL.Category		= "SCars"
TOOL.Name			= "#Node Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar = {
TrackID = "1",
}
cleanup.Register( "SCarNode" )

include("autorun/s_scarnodehandler.lua")

if CLIENT then

	language.Add( "Tool.carnodespawner.name", "AI Node spawner" )	
	language.Add( "Tool.carnodespawner.desc", "Spawn Nodes" )		
	language.Add( "Tool.carnodespawner.0", "Primary fire: spawn" )	
	language.Add( "Tool_TrackID", "Track ID" )

	language.Add( "Undone_SCarNode", "Undone SCar Node" )
	language.Add( "Cleanup_SCarNode", "SCar Node" )
	language.Add( "Cleaned_SCarNode", "Nodes Removed" )		
end

function TOOL:LeftClick( trace )


	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carnodespawner", ply) then return false end	



	
	local ply = self:GetOwner()
	local plyID = ply:UniqueID()
	local TrackID   = math.Clamp( self:GetClientNumber( "TrackID" ), 1, 10)
	local finalID = plyID * 100 + TrackID --This should make all the race id's unique.	
	local node = ents.Create( "sent_scarainode" )
	node:SetPos( trace.HitPos + Vector(0,0,20) )
	node:SetAngles( Angle(0,0,0) )
	node:Spawn()
	node.TrackID = finalID

	AddNodeToTrack( finalID, node )
	
	
	ply:AddCount( "SCarNode", node )	
		
	undo.Create("SCarNode")
	undo.AddEntity( node )
	undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "SCarNode", node )	
	
	
	
	return true
end

function TOOL.BuildCPanel( CPanel )
								 
	CPanel:AddControl( "Slider", { Label = "#Tool_TrackID",
									 Description = "",
									 Type = "int",
									 Min = 1,
									 Max = 10,
									 Command = "carnodespawner_TrackID" } )

end