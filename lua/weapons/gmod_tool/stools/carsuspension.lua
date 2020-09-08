
TOOL.Category		= "SCars"
TOOL.Name			= "#tool.carsuspension.title"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.LiveEnt = NULL
TOOL.UpdateHeight = CurTime()
TOOL.UpdateDelay = 0.25


TOOL.ClientConVar = {
	SoftnesFront    = "0",
	SoftnesRear   = "0",
	liveAction = "0",
	liveAction2 = "0",	
	HeightFront = "0",
	HeightRear = "0",
}
TOOL.OldSoftnesFront = 0
TOOL.OldSoftnesRear = 0
TOOL.OldHeightFront = 0
TOOL.OldHeightRear = 0


if CLIENT then
end

function TOOL:LeftClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carsuspension", ply) then return false end
	
	trace.Entity:EmitSound("carStools/hydraulic.wav",100,math.random(80,150))
	local SoftnesFront			= self:GetClientNumber( "SoftnesFront" )
	local SoftnesRear			= self:GetClientNumber( "SoftnesRear" )
	local HeightFront           = self:GetClientNumber( "HeightFront" )
	local HeightRear            = self:GetClientNumber( "HeightRear" )
	
	local NewHeightFront = HeightFront * -1
	local NewHeightRear  = HeightRear * -1
	
	self.OldHeightFront = HeightFront
	self.OldHeightRear = HeightRear	
	self.OldSoftnesFront = SoftnesFront
	self.OldSoftnesRear = SoftnesRear

	--A weird bug makes the car disappear if a wheel is damaged for some reason
	if trace.Entity:WheelsAreDamaged() then
		trace.Entity:Repair()
	end
	
	trace.Entity:SetSoftnesFront( SoftnesFront )
	trace.Entity:SetSoftnesRear( SoftnesRear )		

	trace.Entity:SetHeightFront( NewHeightFront )
	trace.Entity:SetHeightRear( NewHeightRear )
	self.LiveEnt = trace.Entity
	return true
end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	
	self.LiveEnt = NULL
	local SoftnesFront  = trace.Entity.SoftnesFront
	local SoftnesRear   = trace.Entity.SoftnesRear

	local HeightFront   = trace.Entity.HeightFront * -1
	local HeightRear    = trace.Entity.HeightRear * -1
	
	self:GetOwner():ConCommand("carsuspension_SoftnesFront "..SoftnesFront)
	self:GetOwner():ConCommand("carsuspension_SoftnesRear "..SoftnesRear)

	self:GetOwner():ConCommand("carsuspension_HeightFront "..HeightFront)
	self:GetOwner():ConCommand("carsuspension_HeightRear "..HeightRear)
	
	self.OldHeightFront = HeightFront
	self.OldHeightRear = HeightRear	
	self.OldSoftnesFront = SoftnesFront
	self.OldSoftnesRear = SoftnesRear	
	
	self.LiveEnt = trace.Entity
	return true
end

function TOOL:ValChange( sofF, sofR, heiF, heiR)

	if self.OldSoftnesFront != sofF then return true end
	if self.OldSoftnesRear != sofR then return true end

	if self.OldHeightFront != heiF then return true end
	if self.OldHeightRear != heiR then return true end	
	return false
end

function TOOL:Think()

	if (CLIENT) then return true end

	if self.LiveEnt != NULL && self.LiveEnt != nil && self.LiveEnt:IsValid() && self.LiveEnt.Base == "sent_sakarias_scar_base" && self.UpdateHeight < CurTime() then
		self.UpdateHeight = CurTime() + self.UpdateDelay

		self.LiveEnt:GetPhysicsObject():Wake()
		
		
		local SoftnesFront			= self:GetClientNumber( "SoftnesFront" )
		local SoftnesRear			= self:GetClientNumber( "SoftnesRear" )				
		local HeightFront           = self:GetClientNumber( "HeightFront" )
		local HeightRear            = self:GetClientNumber( "HeightRear" )		
		
		
		if self:ValChange(SoftnesFront, SoftnesRear, HeightFront, HeightRear) then
	
			self.OldHeightFront = HeightFront
			self.OldHeightRear = HeightRear	
			self.OldSoftnesFront = SoftnesFront
			self.OldSoftnesRear = SoftnesRear	
	
			local live = self:GetClientNumber( "liveAction" )
			local live2 = self:GetClientNumber( "liveAction2" )

			if live2 == 1 or live == 1 then 
				self.LiveEnt:ForceRemoveHandBrake()
			end
		
			if live2 == 1 then
				self.LiveEnt:SetSoftnesFront( SoftnesFront )
				self.LiveEnt.SoftnesFront = SoftnesFront
				self.LiveEnt:SetSoftnesRear( SoftnesRear )
				self.LiveEnt.SoftnesRear = SoftnesRear		
			end
			
			if live == 1 then
				self.LiveEnt:SetHeightFront( HeightFront * -1 )
				self.LiveEnt.HeightFront = HeightFront
				self.LiveEnt:SetHeightRear( HeightRear * -1 )
				self.LiveEnt.HeightRear = HeightRear	
			end
		end
	end
end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	
	CPanel:AddControl( "Slider", { Label = "#tool_car_softnesfront",
									 Description = "",
									 Type = "float",
									 Min = -30,
									 Max = 30,
									 Command = "carsuspension_SoftnesFront" } )
									 
	CPanel:AddControl( "Slider", { Label = "#tool_car_softnesrear",
									 Description = "",
									 Type = "float",
									 Min = -30,
									 Max = 30,
									 Command = "carsuspension_SoftnesRear" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool_car_liveaction",
									 Description = "#tool_car_liveaction_desc",
									 Command = "carsuspension_liveAction2" } )								 
									 
CPanel:AddControl( "Label", { Text = "________________________________________", Description = "" } )									 
									 
	CPanel:AddControl( "Slider", { Label = "#tool_car_heightfront",
									 Description = "",
									 Type = "float",
									 Min = -30,
									 Max = 30,
									 Command = "carsuspension_HeightFront" } )
									 
	CPanel:AddControl( "Slider", { Label = "#tool_car_heightrear",
									 Description = "",
									 Type = "float",
									 Min = -30,
									 Max = 30,
									 Command = "carsuspension_HeightRear" } )									 
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool_car_liveaction",
									 Description = "#tool_car_liveaction_desc",
									 Command = "carsuspension_liveAction" } )
									 
end
