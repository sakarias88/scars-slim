
TOOL.Category		= "SCars"
TOOL.Name			= "#tool.carfuel.title"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {

	FuelConsumptionUse = "0",
	FuelConsumption = "100",
}
cleanup.Register( "Fuel" )

if CLIENT then
end

function TOOL:LeftClick( trace )


	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end
	
	
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carfuel", ply) then return false end	 
	 
	 
	local FuelConsumptionUse = self:GetClientNumber( "FuelConsumptionUse" )
	local FuelConsumption = self:GetClientNumber( "FuelConsumption" )
	
	local AllowDisablingFuelConsumption = GetConVarNumber("scar_fuelconsumptionuse")
	local MinFuelConsumption = GetConVarNumber("scar_fuelconsumption")


	
	trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))

	if !game.SinglePlayer() and GetConVarNumber( "scar_carcharlimitation" ) == 1 then
		if FuelConsumption < MinFuelConsumption then
			FuelConsumption = MinFuelConsumption
		end	
	
		if AllowDisablingFuelConsumption == 0 && FuelConsumptionUse == 0 then
			FuelConsumptionUse = 1
		end
	end
	
	trace.Entity:SetFuelConsumptionUse( FuelConsumptionUse )
	trace.Entity:SetFuelConsumption( FuelConsumption )
	trace.Entity:Refuel()
	return true



end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()

	local FuelConsumptionUse = trace.Entity.UsesFuelConsumption
	local FuelConsumption = trace.Entity.FuelConsumption
	
	self:GetOwner():ConCommand("carfuel_FuelConsumptionUse "..FuelConsumptionUse)
	self:GetOwner():ConCommand("carfuel_FuelConsumption "..FuelConsumption)		

	return true

end

function TOOL:Reload(trace)


	if (CLIENT) then return true end
	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carfuel", ply) then return false end	
		
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local FuelProp = ents.Create( "sent_Sakarias_GasPump" )	
	FuelProp:SetPos(trace.HitPos)	
	FuelProp:SetAngles(Ang)
	FuelProp:Spawn()	
	
	local min = FuelProp:OBBMins()
	FuelProp:SetPos( trace.HitPos - trace.HitNormal * min.z )	

	
	undo.Create("Fuel")
	undo.AddEntity( FuelProp )
	undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "Fuel", FuelProp )

end

function TOOL.BuildCPanel( CPanel )
											 
					 
	CPanel:AddControl( "Slider", { Label = "#tool_car_fuelconsumptionuse",
									 Description = "",
									 Type = "float",
									 Min = 0.5,
									 Max = 20,
									 Command = "carfuel_FuelConsumption" } )										 
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool_car_fuel",
									 Description = "#tool_car_fuel_desc",
									 Command = "carfuel_FuelConsumptionUse" } )	
									 
	CPanel:AddControl( "Label", { Text = "#tool_car_fuelpress_reload_gas", Description = "" } )	
end
