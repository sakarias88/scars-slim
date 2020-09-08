TOOL.Category		= "SCars"
TOOL.Name			= "#tool.carnodespawner.title"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar = {
TrackID = "1",
}
cleanup.Register( "SCarNode" )

include("autorun/s_scarnodehandler.lua")

if CLIENT then
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
								 
	CPanel:AddControl( "Slider", { Label = "#tool_trackid",
									 Description = "",
									 Type = "int",
									 Min = 1,
									 Max = 10,
									 Command = "carnodespawner_TrackID" } )

end