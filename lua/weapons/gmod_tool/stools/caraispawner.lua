TOOL.Category		= "SCars"
TOOL.Name			= "#tool.caraispawner.title"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar = {
	AiName = "FollowPlayer",
	AiID = 1,
}
cleanup.Register( "SCarAI" )


if CLIENT then
end

function TOOL:LeftClick( trace )

	if (CLIENT) then return true end
	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" or (trace.Entity.Base == "sent_sakarias_scar_base" && trace.Entity:HasDriver()) then return false end
	
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_caraispawner", ply) then return false end	


	local AiName = self:GetClientInfo( "AiName" )
	local ai = SCarAiHandler:GetAiByName( AiName )
	local ply = self:GetOwner()
	
	if ai == nil then return false end
	
	local AiEnt = ents.Create( "sent_aiscarcontroller" )
	AiEnt:SetPos( trace.HitPos )
	AiEnt:SetAngles( trace.HitNormal:Angle() )
	AiEnt.SpawnedBy = ply
	
	ai.Owner = AiEnt 
	ai.SpawnedBy = ply
	
	AiEnt:Spawn()
	AiEnt:ConnectToCar( trace.Entity )
	AiEnt:SetAI( ai )
	
	ply:AddCount( "SCarAI", AiEnt )				
	undo.Create("SCarAI")
	undo.AddEntity( AiEnt )
	undo.SetPlayer( ply )
	undo.Finish()
	ply:AddCleanup( "SCarAI", AiEnt )	
	
	return true

end

function TOOL:RightClick( trace )
	return self:RemoveCarAI( trace )
end

function TOOL:Reload(trace)
	return self:RemoveCarAI( trace )
end

function TOOL:RemoveCarAI( trace )
	if (CLIENT) then return true end
	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" or (trace.Entity.Base == "sent_sakarias_scar_base" && !trace.Entity:HasDriver()) then return false end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_caraispawner", ply) then return false end		

	trace.Entity.AIController:Remove()
	trace.Entity.AIController = nil
	
	return true
end

function TOOL.BuildCPanel( CPanel )
		

	local combobox = {}
	combobox.Label = "#tool.caraispawner_ai_type"
	combobox.Description = ""
	combobox.MenuButton = "0"
	combobox.Options = {}
	local nr, AllNames = SCarAiHandler:GetTableOfTitles()
	
	for i = 1, nr do
		combobox.Options[AllNames[i]] = {caraispawner_AiName = AllNames[i],  caraispawner_AiID = i }
	end
	
	CPanel:AddControl("ComboBox", combobox)
end