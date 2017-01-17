TOOL.Category		= "SCars"
TOOL.Name			= "#Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""

cleanup.Register( "SCars" )

TOOL.LastCategory = "All"
TOOL.ClientConVar = {
	model    = "sent_sakarias_car_junker1",
	select   = "1",
	category = "All",
}

if CLIENT then

	language.Add( "Tool.carspawner.name", "Car spawner" )	
	language.Add( "Tool.carspawner.desc", "Spawn Cars" )		
	language.Add( "Tool.carspawner.0", "Primary fire: spawn" )
	language.Add( "Undone_Cars", "Undone Car" )
	
	language.Add( "Undone_SCars", "Undone SCar" )
	language.Add( "Cleanup_SCars", "SCars" )
	language.Add( "Cleaned_SCars", "SCars Removed" )		

end

function TOOL:Deploy()
	if (CLIENT) then
	  local CPanel = controlpanel.Get( "carspawner" )
	  if ( !CPanel ) then return end
	  CPanel:ClearControls()
		CPanel:AddControl( "Header", { Text = "#Tool_carspawner_name", Description	= "#Tool_carspawner_desc" }  )									 
				
		ThaMaterialBox = {}
		ThaMaterialBox.Label = "Cars"
		ThaMaterialBox.MenuButton = 0
		ThaMaterialBox.Height = 100
		ThaMaterialBox.Width = 100
		ThaMaterialBox.Rows = 2
		ThaMaterialBox.Options = list.Get( "scar_carList" )

		CPanel:AddControl("MaterialGallery", ThaMaterialBox)	
	end
    return true
end

function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carspawner", ply) then return false end	
	
	if SCarGetFastConvar["scar_scarspawnadminonly"] == 1 and ply:IsAdmin() == false then 
		ply:PrintMessage( HUD_PRINTTALK, "Only admins are allowed to spawn SCars")
		return false 
	end
	
	local MaxCarsAllowed  = GetConVarNumber( "scar_maxscars" )
	local nrOfCars = ply:GetCount( "SCar" )   
	   
	local CarNum = self:GetClientNumber( "select" )
	local model = string.lower(self:GetClientInfo( "model" ))
	local carInfo = SCarRegister:GetInfo( model )
	
	
	if !game.SinglePlayer() and carInfo and carInfo.AdminOnly and !ply:IsAdmin() and GetConVarNumber( "scar_admincarspawn" ) == 0 then
		ply:PrintMessage( HUD_PRINTTALK, carInfo.Name.." is admin only")
		return false 	
	end		   
	   
	if !game.SinglePlayer() and nrOfCars >= MaxCarsAllowed - 1 then 	
		ply:PrintMessage( HUD_PRINTTALK, "You have reached SCar spawn limit")
		return false 
	end
	   

	local CarEnt = ents.Create( model )

	if IsValid(CarEnt) then

		CarEnt:Spawn()
		CarEnt:Activate()
		CarEnt:SetPos( trace.HitPos + (trace.HitNormal * (CarEnt.AddSpawnHeight + 10)))	
		
		local Ang = trace.HitNormal:Angle()
		Ang:RotateAroundAxis( Ang:Right(), -90 )
		local newAng = (ply:GetPos() - CarEnt:GetPos()):GetNormalized():Angle()
		Ang:RotateAroundAxis( Ang:Up(), newAng.y )

		CarEnt:SetAngles( Ang )	
		CarEnt:Reposition()
		CarEnt.handBreakDel = CurTime() + 2
		CarEnt:UpdateAllCharacteristics()
		
		CarEnt:SetCarOwner( ply )

		ply:AddCount( "SCar", CarEnt )	
			
		undo.Create("SCars")
		undo.AddEntity( CarEnt )
		undo.SetPlayer( ply )
		undo.SetCustomUndoText( "Undone "..carInfo.Name )
		undo.Finish()
			
		ply:AddCleanup( "SCars", CarEnt )	

		return true
	end
	
	return false
end




function TOOL:Think()
	if ( CLIENT ) then
		local cat = self:GetClientInfo( "category" )
		
		if self.LastCategory != cat then
			self.LastCategory = cat
			
			local CPanel = controlpanel.Get( "carspawner" )
			if ( !CPanel ) then return end
			self.BuildCPanel(CPanel, self.LastCategory)
		end
	end
end

function TOOL.BuildCPanel( CPanel, category )

	CPanel:ClearControls()
	
	local catTable = {}

	if !category then category = "All" end
	
	if category == "No category" then -- Cars that don't have any category will be put here so they just don't disappear
		category = "scar_carList" 
		catTable = list.Get( category )
	elseif category == "All" then --Adding all cars
		category = "scar_carList"
		catTable = list.Get( category )
		
		local cats = list.Get( "scar_category" )

		for k,v in pairs( cats ) do
			local newTable = list.Get( "scar_carList_"..v )
			catTable = table.Add( newTable, catTable )
		end
	else --We have a valid category
		category = "scar_carList_"..category
		catTable = list.Get( category )
	end
	
	local exists = false
	for k,v in pairs( catTable ) do
		exists = file.Exists("materials/"..v.Material..".vmt" , "GAME" )
	
	
		if !exists then
			v.Material = "vgui/entities/noicon"
		end
	end	
	

	// HEADER

	local combobox = {}
	combobox.Label = "Category"
	combobox.Description = ""
	combobox.MenuButton = "0"
	combobox.Options = {}
	
	for k,v in pairs(list.Get( "scar_category" )) do
		combobox.Options[k] = {carspawner_category = v}
	end
	
	CPanel:AddControl("ComboBox", combobox)	

	ThaMaterialBox = {}
	ThaMaterialBox.Label = "Cars"
	ThaMaterialBox.MenuButton = 0
	ThaMaterialBox.Height = 100
	ThaMaterialBox.Width = 100
	ThaMaterialBox.Rows = 6
	ThaMaterialBox.Options = catTable


	CPanel:AddControl("MaterialGallery", ThaMaterialBox)
end