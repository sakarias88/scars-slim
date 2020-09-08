
TOOL.Category		= "SCars"
TOOL.Name			= "#tool.carsound.title"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.HornSound = nil
TOOL.HornPlay = false
TOOL.HornDelay = CurTime()

TOOL.EngineSound = nil
TOOL.EngineDelay = 1 / 3
TOOL.EngineStartTime = CurTime()
TOOL.EnginePlay = false


TOOL.ClientConVar = {

	enginesound = "vehicles/Airboat/fan_motor_idle_loop1.wav",
	hornsound = "SCarHorns/horn 1.wav",
	gearsoundeffect = "Default"
}

if CLIENT then
end

function TOOL:LeftClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_carsound", ply) then return false end	 
	 
	local EngineSound = self:GetClientInfo( "enginesound" )
	local HornSound = self:GetClientInfo( "hornsound" )
	local gearEffect = self:GetClientInfo( "gearsoundeffect" )
	EngineSound = string.lower(EngineSound)
	HornSound = string.lower(HornSound)
	
	trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))
	trace.Entity:SetHornSound( HornSound )
	trace.Entity:SetEngineSound( EngineSound )
	trace.Entity:SetGearEffect( gearEffect )
	return true

end

function TOOL:RightClick( trace )

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local EngineSound = trace.Entity.DefaultSound
	local HornSound = trace.Entity.HornSound
	local EngineEffectName = trace.Entity.EngineEffectName
	
	EngineSound = string.lower(EngineSound)
	HornSound = string.lower(HornSound)
	
	self:GetOwner():ConCommand("carsound_enginesound "..EngineSound)
	self:GetOwner():ConCommand("carsound_hornsound "..HornSound)		
	self:GetOwner():ConCommand("carsound_gearsoundeffect "..EngineEffectName)

	return true
end

function TOOL:Think()

	if self.HornPlay and self.HornDelay < CurTime() then
		self.HornSound:Stop()
		self.HornPlay = false
	end
	
	if self.EnginePlay then
		local per = ((CurTime() - self.EngineStartTime) * self.EngineDelay) * 2
		
		if per > 2 then
			self.EnginePlay = false
			self.EngineSound:Stop()
			return
		end
		
		if per > 1 then
			per = 2 - per
		end
		
		self.EngineSound:ChangePitch( 40 + 200 * per , 0)

	end
end

function TOOL:Holster()
	if self.HornSound then
		self.HornSound:Stop()
	end

	if self.EngineSound then
		self.EngineSound:Stop()
	end	
end

function TOOL:PlayHorn()
	
	if self.HornPlay == true then
		self.HornSound:Stop()
	end
	
	self.HornSound = CreateSound(LocalPlayer(),self:GetClientInfo( "hornsound" ))
	self.HornSound:Play()
	self.HornDelay = CurTime() + 1
	self.HornPlay = true
end

function TOOL:PlayEngine()

	if self.EnginePlay == true then
		self.EngineSound:Stop()
	end

	
	local filedir = self:GetClientInfo( "enginesound" )

	if file.IsDir( "sound/"..filedir, "GAME") then
		self.EngineSound = CreateAdvancedSCarSound(LocalPlayer(),self:GetClientInfo( "enginesound" ))
	else
		self.EngineSound = CreateSound(LocalPlayer(),self:GetClientInfo( "enginesound" ))
	end


	
	self.EngineSound:Play()
	self.EngineStartTime = CurTime()
	self.EnginePlay = true	
end

function TOOL.BuildCPanel( CPanel )
											 
					 
	CPanel:AddControl( "Label", { Text = "", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#tool_car_sounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "SCarEngineSounds" ) } )			

	CPanel:AddControl( "Label", { Text = "", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#tool_car_hornsounds",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "SCarHornSounds" ) } )	
									 
	CPanel:AddControl( "Label", { Text = "", Description = "" } )	
	CPanel:AddControl( "ComboBox", { Label = "#tool_car_exhausteffect",
									 Description = "",
									 MenuButton = "0",
									 Options = list.Get( "SCarGearEffect" ) } )

	CPanel:AddControl( "Label", { Text = "", Description = "" } )	
	
	local EngineButton = vgui.Create("DButton")
	EngineButton:SetText("#tool_car_playenginesound")
	EngineButton.DoClick = function()
		if LocalPlayer():GetTool() and LocalPlayer():GetTool().PlayEngine then
			LocalPlayer():GetTool():PlayEngine()
		end
    end
	CPanel:AddItem(EngineButton)
	
	local HornButton = vgui.Create("DButton")
	HornButton:SetText("#tool_car_playhornsound")
	HornButton.DoClick = function()
		if LocalPlayer():GetTool() and LocalPlayer():GetTool().PlayHorn then
			LocalPlayer():GetTool():PlayHorn()
		end		
    end
	CPanel:AddItem(HornButton)	
end
