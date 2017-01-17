
TOOL.Category		= "SCars"
TOOL.Name			= "#Wheel changer"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
	model    = "models/Splayn/cadillac_wh.mdl",
	physmaterial = "rubber"
}

if CLIENT then

	language.Add( "Tool.wheelchanger.name", "Wheel changer" )	
	language.Add( "Tool.wheelchanger.desc", "Change the wheels on the cars" )		
	language.Add( "Tool.wheelchanger.0", "Primary fire: Change wheel" )	

end


function TOOL:Deploy()
	if (CLIENT) then
	  local CPanel = controlpanel.Get( "carspawner" )
	  if ( !CPanel ) then return end
		CPanel:ClearControls()
		CPanel:AddControl( "Header", { Text = "#Tool_wheelchanger_name", Description	= "#Tool_wheelchanger_desc" }  )				

		ThaMaterialBox = {}
		ThaMaterialBox.Label = "Wheels"
		ThaMaterialBox.MenuButton = 0
		ThaMaterialBox.Height = 100
		ThaMaterialBox.Width = 100
		ThaMaterialBox.Rows = 6
		ThaMaterialBox.Options = list.Get( "scar_wheels" )

		CPanel:AddControl("MaterialGallery", ThaMaterialBox)

		CPanel:AddControl( "Label", { Text = "Wheel physical properties", Description = "" } )	
		CPanel:AddControl( "ComboBox", { Label = "#Tool_Car_Sounds",
										 Description = "",
										 MenuButton = "0",
										 Options = list.Get( "physMaterials" ) } )	
	end
    return true
end


function TOOL:LeftClick( trace )



	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" ) or string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel_punked" )) or trace.Entity.IsDestroyed == 1 or ( trace.Entity && trace.Entity:IsPlayer() ) then return false end


	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_wheelchanger", ply) then return false end	

	local model	  = self:GetClientInfo( "model" )
	local physMat = self:GetClientInfo( "physmaterial" ) 	
	
	if trace.Entity:IsValid() then
	
		if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel_punked" ) then 
			trace.Entity:ChangeOneWheel( model, physMat, true, false)
			trace.Entity.TireModel = model	
			trace.Entity.physMat = physMat
		else
			trace.Entity:ChangeWheelAll( model, physMat, true, false)
			trace.Entity.TireModel = model	
			trace.Entity.physMat = physMat		
		end
		trace.Entity:EmitSound("carStools/wheel.wav",80,math.random(100,150))	
		return true
	end
	
	return false
end

function TOOL:RightClick( trace )

	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" ) or string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel_punked" )) or trace.Entity.IsDestroyed == 1 or ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	local physMat = trace.Entity.physMat 
	self:GetOwner():ConCommand("wheelchanger_physmaterial "..physMat)	
	
	local model   = trace.Entity.TireModel
	self:GetOwner():ConCommand("wheelchanger_model "..model)

	return true
end

function TOOL.BuildCPanel( CPanel )

	// HEADER		

	local wheels = list.Get( "scar_wheels" )
	local exists = false
	for k,v in pairs( wheels ) do
	
		exists = false
		exists = file.Exists( "materials/"..v.Material..".vmt" , "GAME" )
		
	
		if !exists then
			v.Material = "vgui/entities/noicon"
		end	
	end		
	
	ThaMaterialBox = {}
	ThaMaterialBox.Label = "Wheels"
	ThaMaterialBox.MenuButton = 0
	ThaMaterialBox.Height = 100
	ThaMaterialBox.Width = 100
	ThaMaterialBox.Rows = 6
	ThaMaterialBox.Options = wheels

	CPanel:AddControl("MaterialGallery", ThaMaterialBox)
	

	CPanel:AddControl( "Label", { Text = "Wheel physical properties", Description = "" } )	

	CPanel:AddControl( "ComboBox", { Label = "#Tool_Car_Sounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "physMaterials" ) } )	

end

list.Set( "physMaterials", "#Rubber", { wheelchanger_physmaterial = "rubber" } )
list.Set( "physMaterials", "#Rubber tire", { wheelchanger_physmaterial = "rubbertire" } )
list.Set( "physMaterials", "#Sliding rubber tire", { wheelchanger_physmaterial = "slidingrubbertire" } )
list.Set( "physMaterials", "#Jeep tire", { wheelchanger_physmaterial = "jeeptire" } )
list.Set( "physMaterials", "#Braking rubber tire", { wheelchanger_physmaterial = "brakingrubbertire" } )
