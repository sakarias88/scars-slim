//I do not take any credit for this stool.
//Mihara is the author.
//I just changed some simple things so it will fit with my addon

TOOL.Category	= "SCars"
TOOL.Name       = "#Paint Job Switcher"
TOOL.Command    = nil
TOOL.ConfigName = nil

TOOL.ClientConVar[ "skin" ] 		= 0


if ( SERVER ) then

local manualcontrol = true
local oldslider = 0
local newslider = 0

end

if ( CLIENT ) then 

local colorswitcherPreviousEntity = nil

language.Add("Tool.paintjobswitcher.name", "Paint Job Switcher")
language.Add("Tool.paintjobswitcher.desc", "Changes the paint job on the car.")
language.Add("Tool.paintjobswitcher.0", "Left click to cycle paint job. \nRight click to select a car for manipulation.\nReload to pick a random paint job.")

function TOOL.BuildCPanel( CPanel, SwitchEntity )

  CPanel:AddControl( "Header", { Text = "#Tool.paintjobswitcher.name", 
                                 Description	= "#Tool.paintjobswitcher.desc" 
                               }  )
                               
  if IsValid(SwitchEntity) then
    local maxskins = SwitchEntity:SkinCount()
    if maxskins > 1 then
	
		local DermaNumSlider = vgui.Create( "DNumSlider", DermaPanel )
		DermaNumSlider:SetText( "Paint Job" )
		DermaNumSlider:SetMin( 0 )
		DermaNumSlider:SetMax( maxskins-1 )
		DermaNumSlider:SetDecimals( 0 )
		DermaNumSlider:SetConVar( "paintjobswitcher_skin" )
		CPanel:AddItem(DermaNumSlider)

    else
      CPanel:AddControl("Label", { Text = "This car only has one paint job." } )
    end
  else
    CPanel:AddControl("Label", { Text = "No car selected." } )
  end
end

function TOOL:RebuildControlPanel()
  local CPanel = controlpanel.Get( "paintjobswitcher" )
  if ( !CPanel ) then return end
  CPanel:ClearControls()
  self.BuildCPanel(CPanel, self:GetcolorswitcherEntity())
end


function TOOL:DrawHUD()
  local selected = self:GetcolorswitcherEntity()		
  if ( !IsValid( selected ) ) then return end
		local scrpos = selected:GetPos():ToScreen()
		if (!scrpos.visible) then return end
		
		local player_eyes = LocalPlayer():EyeAngles()
		local side = (selected:GetPos() + player_eyes:Right() * 50):ToScreen()
		local size = math.abs( side.x - scrpos.x )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture(surface.GetTextureID( "gui/faceposer_indicator"))
		surface.DrawTexturedRect( scrpos.x-size, scrpos.y-size, size*2, size*2 )

	end
end

function TOOL:GetcolorswitcherEntity()
	return self:GetWeapon():GetNetworkedEntity( 1 )
end

function TOOL:SetcolorswitcherEntity( ent )
	return self:GetWeapon():SetNetworkedEntity( 1, ent )
end



function TOOL:LeftClick(trace)

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_paintjobswitcher", ply) then return false end

	local skins = trace.Entity:SkinCount()


	if skins <= 1 then
		return false
	else 
		local currentskin = trace.Entity:GetSkin()
			local newskin = 0
		if (currentskin + 1) >= skins then
			newskin = currentskin + 1 - skins
		else
			newskin = currentskin+1
		end  


		local effectdata = EffectData()
		local vecStart = Vector( trace.Entity:GetSkin(), newskin, 0)
		effectdata:SetEntity( trace.Entity )
		effectdata:SetStart( vecStart )
		util.Effect( "carskinswitch", effectdata )	

		trace.Entity:SetSkin(newskin)
		trace.Entity:EmitSound("carStools/spray.wav",80,math.random(100,150))
	end

	return true

end

function TOOL:Reload(trace)

	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

	local ply = self:GetOwner()
	if !CanUseSCarTool("scar_paintjobswitcher", ply) then return false end	
	
  local skins = trace.Entity:SkinCount()
	
  if skins == 1 then
    return false
  else 
    local currentskin = trace.Entity:GetSkin()
    local newskin = currentskin
    while newskin == currentskin do
      newskin = math.random(skins)
    end
	trace.Entity:EmitSound("carStools/spray.wav",80,math.random(100,150))	
	
	local effectdata = EffectData()
	local vecStart = Vector( trace.Entity:GetSkin(), newskin, 0)
	effectdata:SetEntity( trace.Entity )
	effectdata:SetStart( vecStart )
	util.Effect( "carskinswitch", effectdata )
	
    trace.Entity:SetSkin(newskin)
  end

  return true
    
end

function TOOL:RightClick(trace)

	self.SelectedEntity = nil
	if !trace.Entity:IsValid() or !trace.Entity.Base or trace.Entity.Base != "sent_sakarias_scar_base" then return false end
	if (CLIENT) then return true end

    self.SelectedEntity = trace.Entity
    self:SetcolorswitcherEntity(self.SelectedEntity)
end

function TOOL:Think()
  if ( CLIENT ) then
    if not (colorswitcherPreviousEntity == self:GetcolorswitcherEntity()) then
      self:RebuildControlPanel()
      colorswitcherPreviousEntity = self:GetcolorswitcherEntity()
    end
    return
  end

  newslider = self:GetClientNumber("skin")
  if newslider ~= oldslider then
    oldslider = newslider
    manualcontrol = false
  else
    manualcontrol = true
  end

  if self.SelectedEntity then 
    if self.SelectedEntity:IsValid() then
      if self.SelectedEntity:SkinCount() > 1 then
        -- I can't say it's good code, but I'm fed up with it.
        if not manualcontrol then
			local effectdata = EffectData()
			local vecStart = Vector( self.SelectedEntity:GetSkin(), newslider, 0)
			effectdata:SetEntity( self.SelectedEntity )
			effectdata:SetStart( vecStart )
			util.Effect( "carskinswitch", effectdata )		 		
          self.SelectedEntity:SetSkin(newslider) 
        end
      end
    end
  end 
end
