
TOOL.Category		= "SCars"
TOOL.Name			= "#Neon lights"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {

	lightsize = "150",
	stayTime = "0",
	fadeTime = "1",
	col1r = "255",
	col1g = "255",
	col1b = "255",
	col1a = "255",
	col2r = "0",
	col2g = "0",
	col2b = "0",
	col2a = "0",
}

if CLIENT then


	language.Add( "Tool_Car_neonlightsize", "Light size" )	
	language.Add( "Tool_Car_neonlightsfade", "Fade time" )
	language.Add( "Tool_Car_neonlightsstay", "Stay time" )
	
	language.Add( "Tool.carneonlights.name", "Car Neon lights" )
	language.Add( "Tool.carneonlights.desc", "Put some neon lights under your car" )
	language.Add( "Tool.carneonlights.0", "Primary fire to apply, secondary fire to copy settings, reload to remove neon lights" )
	
end

function TOOL:LeftClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carneonlights", ply) then return false end		 
	 
	local size = self:GetClientNumber( "lightsize" )
	local stayTime = self:GetClientNumber( "stayTime" )
	local fadeTime = self:GetClientNumber( "fadeTime" )
	
	local AllowDisablingFuelConsumption = GetConVarNumber("scar_fuelconsumptionuse")
	local MinFuelConsumption = GetConVarNumber("scar_fuelconsumption")


	trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))
	local size = self:GetClientNumber( "lightsize" )
	local stayTime = self:GetClientNumber( "stayTime" )
	local fadeTime = self:GetClientNumber( "fadeTime" )		
	local Col1 = Color(self:GetClientNumber( "col1r" ),self:GetClientNumber( "col1g" ), self:GetClientNumber( "col1b" ),0 )
	local Col2 = Color(self:GetClientNumber( "col2r" ),self:GetClientNumber( "col2g" ), self:GetClientNumber( "col2b" ),0 )

	trace.Entity:SetNeonLights( size, stayTime, fadeTime, Col1, Col2 )
	return true

end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	
	local size = trace.Entity.NeonSize
	local stayTime = trace.Entity.NeonStayTime
	local fadeTime = trace.Entity.NeonFadeTime
	local Col1 = trace.Entity.NeonCol1
	local Col2 = trace.Entity.NeonCol2

	
	self:GetOwner():ConCommand("carneonlights_lightsize "..size)
	self:GetOwner():ConCommand("carneonlights_stayTime "..stayTime)
	self:GetOwner():ConCommand("carneonlights_fadeTime "..fadeTime)
	self:GetOwner():ConCommand("carneonlights_col1r "..Col1.r)
	self:GetOwner():ConCommand("carneonlights_col1g "..Col1.g)
	self:GetOwner():ConCommand("carneonlights_col1b "..Col1.b)
	self:GetOwner():ConCommand("carneonlights_col2r "..Col2.r)
	self:GetOwner():ConCommand("carneonlights_col2g "..Col2.g)
	self:GetOwner():ConCommand("carneonlights_col2b "..Col2.b)

	return true
end

function TOOL:Reload(trace)

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()

	trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))
	trace.Entity:SetNeonLights( 0, 0, 0, Color(0,0,0,0), Color(0,0,0,0) )
	return true
end

function TOOL.BuildCPanel( CPanel )

	local slider = {}
	slider.Label = "#Tool_Car_neonlightsize"
	slider.Description = ""
	slider.Type = "float"
	slider.Min = 50
	slider.Max = 200
	slider.Command = "carneonlights_lightsize" 
	CPanel:AddControl( "Slider", slider )	
	
	slider.Label = "#Tool_Car_neonlightsstay"
	slider.Description = ""
	slider.Type = "float"
	slider.Min = 0
	slider.Max = 10
	slider.Command = "carneonlights_stayTime" 
	CPanel:AddControl( "Slider", slider )	
	
	
	slider.Label = "#Tool_Car_neonlightsfade"
	slider.Description = ""
	slider.Type = "float"
	slider.Min = 0
	slider.Max = 10
	slider.Command = "carneonlights_fadeTime" 
	CPanel:AddControl( "Slider", slider )

			
					 
	local color = {}
	color.Label = "Colour one"
	color.Red = "carneonlights_col1r"
	color.Green = "carneonlights_col1g"
	color.Blue = "carneonlights_col1b"
	color.Alpha = "carneonlights_col1a"
	color.ShowAlpha = 0
	color.ShowHSV = 0
	color.ShowRGB = 0
	color.Multiplier = 255
	CPanel:AddControl("Color", color)
	
	
	color.Label = "Colour 2"
	color.Red = "carneonlights_col2r"
	color.Green = "carneonlights_col2g"
	color.Blue = "carneonlights_col2b"
	color.Alpha = "carneonlights_col2a"
	color.ShowAlpha = 0
	color.ShowHSV = 0
	color.ShowRGB = 0
	color.Multiplier = 255
	 CPanel:AddControl("Color", color)	
	
end
