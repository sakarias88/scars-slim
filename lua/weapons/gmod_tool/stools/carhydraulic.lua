
TOOL.Category		= "SCars"
TOOL.Name			= "#Hydraulics"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
	SuspensionAddHeight    = "0",
	Active = "0",
}

if CLIENT then
	language.Add( "Tool_CarHydraulic_SuspensionAddHeight", "Suspension Add Height" )
	language.Add( "Tool_CarHydraulic_Active", "Active" )
	language.Add( "Tool_CarHydraulic_Active_desc", "Enable or disable this feature" )
	
	language.Add( "Tool.carhydraulic.name", "Car Hydraulics" )
	language.Add( "Tool.carhydraulic.desc", "Can change the hydraulic settings" )
	language.Add( "Tool.carhydraulic.0", "Primary fire to paste and secondary fire to copy" )
	
end

function TOOL:LeftClick( trace )

	Msg("ANUS")
	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carhydraulic", ply) then return false end
	

	local SuspensionAddHeight = self:GetClientNumber( "SuspensionAddHeight" )
	
	--if !game.SinglePlayer() and GetConVarNumber( "scar_carcharlimitation" ) == 1 then
	Msg("ConVar: "..GetConVarNumber( "scar_carcharlimitation" ).."\n")
	if GetConVarNumber( "scar_carcharlimitation" ) == 1 then
		local LimitHydHeight  = GetConVarNumber( "scar_maxhydheight" )
		Msg("LimitHydHeight: "..LimitHydHeight .."\n")
		Msg("SuspensionAddHeight: "..SuspensionAddHeight .."\n")
		SuspensionAddHeight = math.Clamp(SuspensionAddHeight, 5, LimitHydHeight)
		Msg("NEW: "..SuspensionAddHeight .."\n")
	end
	
	local newSuspensionAddHeight = SuspensionAddHeight * -1
	local allowHydraulics = GetConVarNumber("scar_allowHydraulics") 
	local Active 			  = self:GetClientNumber( "Active" )	
	
	trace.Entity:EmitSound("carStools/hydraulic.wav",100,math.random(80,150))
	trace.Entity:SetSuspensionAddHeight( newSuspensionAddHeight )
	
	if !game.SinglePlayer() then
		if allowHydraulics == 0 then
			Active = 0
		end
	end
	
	trace.Entity:SetHydraulicActive( Active )
	return true
end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()

	local SuspensionAddHeight  = trace.Entity.HydraulicHeight * -1
	local Active 			  = trace.Entity.HydraulicActive
	
	self:GetOwner():ConCommand("carhydraulic_SuspensionAddHeight "..SuspensionAddHeight)
	self:GetOwner():ConCommand("carhydraulic_Active "..Active)
	
	return true
end

function TOOL.BuildCPanel( CPanel )
	
	// HEADER
	CPanel:AddControl( "Header", { Text = "Carframes", Description	= "Suspension Add Height" }  )	
	
	CPanel:AddControl( "Slider", { Label = "",
									 Description = "",
									 Type = "float",
									 Min = 5,
									 Max = 30,
									 Command = "carhydraulic_SuspensionAddHeight" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_CarHydraulic_Active",
									 Description = "#Tool_CarHydraulic_Active_desc",
									 Command = "carhydraulic_Active" } )								 
									 
end
