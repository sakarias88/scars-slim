
TOOL.Category		= "SCars"
TOOL.Name			= "#Health"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar = {
	CarHealth    = "200",
	CanTakeDamage = "1",
	CanTakeWheelDamage = "1",
}

if CLIENT then
	language.Add( "Tool_carhealth_CarHealth", "Car Health" )
	language.Add( "Tool_carhealth_CanTakeDamage", "Car Damage" )
	language.Add( "Tool_carhealth_CanTakeDamage_desc", "Turn car damage on or off" )

	language.Add( "Tool_carhealth_CanTakeWheelDamage", "Wheel Damage" )
	language.Add( "Tool_carhealth_CanTakeWheelDamage_desc", "Turn wheel damage on or off" )
	
	language.Add( "Tool.carhealth.name", "Car Health" )
	language.Add( "Tool.carhealth.desc", "Change the health on the cars" )
	language.Add( "Tool.carhealth.0", "Primary fire to paste and secondary fire to copy" )
	
	
	language.Add( "Undone_Repair", "Undone Repair Station" )
	language.Add( "Cleanup_Repair", "SCar Repair Station" )
	language.Add( "Cleaned_Repair", "Repair Station Removed" )	
end

function TOOL:LeftClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end


	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carhealth", ply) then return false end	

	local CarHealth = self:GetClientNumber( "CarHealth" )
	local CanTakeDamage = self:GetClientNumber( "CanTakeDamage" )	
	local CanTakeWheelDamage = self:GetClientNumber( "CanTakeWheelDamage" )
	
	local allowDisablingWheelDamage =  GetConVarNumber("scar_tiredamage") 
	local allowDisablingCarDamage =  GetConVarNumber("scar_cardamage") 
	local maxHealthAllowed = GetConVarNumber("scar_maxhealth") 
	
	
	trace.Entity:EmitSound("carStools/tune.wav",100,math.random(80,150))
	
	if !game.SinglePlayer() and GetConVarNumber( "scar_carcharlimitation" ) == 1 then
		if maxHealthAllowed < CarHealth then
			CarHealth = maxHealthAllowed
		end
		
		if CanTakeDamage == 0 && allowDisablingCarDamage == 0 then
			CanTakeDamage = 1
		end

		if CanTakeWheelDamage == 0 && allowDisablingWheelDamage == 0 then
			CanTakeWheelDamage = 1
		end
	end
	
	trace.Entity:SetCarHealth( CarHealth )	
	trace.Entity:SetCanTakeDamage( CanTakeDamage, CanTakeWheelDamage )
	
	return true
end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local CarHealth  = trace.Entity.CarMaxHealth
	local CanTakeDamage = trace.Entity.CanTakeDamage
	local CanTakeWheelDamage = trace.Entity.CanTakeWheelDamage
	
	self:GetOwner():ConCommand("carhealth_CarHealth "..CarHealth)
	self:GetOwner():ConCommand("carhealth_CanTakeDamage "..CanTakeDamage)
	self:GetOwner():ConCommand("carhealth_CanTakeWheelDamage "..CanTakeWheelDamage)
	
	return true
end

function TOOL:Reload(trace)

	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carhealth", ply) then return false end	
		
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local RepairProp = ents.Create( "sent_Sakarias_RepairStation" )	
	RepairProp:SetPos(trace.HitPos)	
	RepairProp:SetAngles(Ang)
	RepairProp:Spawn()	
	
	local min = RepairProp:OBBMins()
	RepairProp:SetPos( trace.HitPos - trace.HitNormal * min.z )	

	
	undo.Create("Repair")
	undo.AddEntity( RepairProp )
	undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "Repair", RepairProp )

end

function TOOL.BuildCPanel( CPanel )
	

	
	CPanel:AddControl( "Slider", { Label = "#Tool_carhealth_CarHealth",
									 Description = "",
									 Type = "float",
									 Min = 100,
									 Max = 1000,
									 Command = "carhealth_CarHealth" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_carhealth_CanTakeDamage",
									 Description = "#Tool_carhealth_CanTakeDamage_desc",
									 Command = "carhealth_CanTakeDamage" } )								 

	CPanel:AddControl( "CheckBox", { Label = "#Tool_carhealth_CanTakeWheelDamage",
									 Description = "#Tool_carhealth_CanTakeWheelDamage_desc",
									 Command = "carhealth_CanTakeWheelDamage" } )			

	CPanel:AddControl( "Label", { Text = "Press RELOAD to spawn a repair station", Description = "" } )									 
end
