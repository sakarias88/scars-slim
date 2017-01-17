
local items = {}
local nrOfItems = 0

local function ApplySettings()
	for _, v in pairs( items ) do
		if (v.SCarConVar != nil && v.SCarConVar != NULL && GetConVar( v.SCarConVar ) != nil && GetConVar( v.SCarConVar ) != NULL ) then

			local val =  v:GetValue()
			
			if v.IsCheckBox then
				val = 0
			
				if v:GetChecked( true ) then
					val = 1
				end		
			end
			
			RunConsoleCommand( "sakarias_changelimit", v.SCarConVar, val )		
		end
	end

	RunConsoleCommand( "sakarias_updateallvehicles" )
end

local function PopuScarAdminMenu(Panel)
	Panel:ClearControls()
	
	
	local button = vgui.Create( "DButton" ) 
	button:SetSize( 150, 20 )
	button:SetText( "Apply Settings" )
	button.DoClick = function( button )
		if LocalPlayer():IsAdmin() then
			ApplySettings()
		else
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "You are not an administrator!")
		end
	end
	
	Panel:AddItem(button)	
	
	
	Panel:AddControl( "Label", { Text = "\n\nSTool options (Unchecked = admin only)", Description = "" } )	
	for k, v in pairs( list.Get("ScarConVarStool") ) do
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( v[1] ) 
		checkBox:SetValue( GetConVarNumber( v[2] ) )
		checkBox.SCarConVar = v[2]
		checkBox.IsCheckBox = true
		checkBox:SetChecked( GetConVarNumber( v[2] ) )
		Panel:AddItem(checkBox)
		nrOfItems = nrOfItems + 1
		items[nrOfItems] = checkBox	
	end	

	
	Panel:AddControl( "Label", { Text = "\n\nMisc", Description = "" } )	
	
	for k, v in pairs( list.Get("ScarConVarCheckBoxes") ) do
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( v[1] ) 
		checkBox:SetValue( GetConVarNumber( v[2] ) )
		checkBox.SCarConVar = v[2]
		checkBox.IsCheckBox = true
		checkBox:SetChecked( GetConVarNumber( v[2] ) )
		Panel:AddItem(checkBox)
		nrOfItems = nrOfItems + 1
		items[nrOfItems] = checkBox	
	end		

	Panel:AddControl( "Label", { Text = "\n\n", Description = "" } )
	for k, v in pairs( list.Get("ScarConVarSliders") ) do
		local slider = vgui.Create( "DNumSlider" )
		slider:SetText( v[1] )
		slider:SetSize( 150, 50 )
		slider:SetMin( v[4] )			
		slider:SetMax( v[5] )
		slider:SetDecimals( v[6] )					
		slider.SCarConVar = v[2]
		CreateClientConVar( "cl_"..v[2], v[3], true, false)
		slider:SetConVar( "cl_"..v[2] )			
		slider.IsCheckBox = false
		Panel:AddItem(slider)
		nrOfItems = nrOfItems + 1
		items[nrOfItems] = slider	
	end		
	
	local button = vgui.Create( "DButton" ) 
	button:SetSize( 150, 20 )
	button:SetText( "Apply Settings" )
	button.DoClick = function( button )
		if LocalPlayer():IsAdmin() then
			ApplySettings()
		else
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "You are not an administrator!")
		end
	end	
	
	Panel:AddItem(button)	
end

local function PopuScarAdminMenuLimitations(Panel)
	Panel:ClearControls()
	
	
	local button = vgui.Create( "DButton" ) 
	button:SetSize( 150, 20 )
	button:SetText( "Apply Settings" )
	button.DoClick = function( button )
		if LocalPlayer():IsAdmin() then
			ApplySettings()
		else
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "You are not an administrator!")
		end
	end
	
	Panel:AddItem(button)	
	
	for k, v in pairs( list.Get("ScarConVarCheckBoxesCar") ) do
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( v[1] ) 
		checkBox:SetValue( GetConVarNumber( v[2] ) )
		checkBox.SCarConVar = v[2]
		checkBox.IsCheckBox = true
		checkBox:SetChecked( GetConVarNumber( v[2] ) )
		Panel:AddItem(checkBox)
		nrOfItems = nrOfItems + 1
		items[nrOfItems] = checkBox	
	end		

	for k, v in pairs( list.Get("ScarConVarSlidersCar") ) do
		local slider = vgui.Create( "DNumSlider" )
		slider:SetText( v[1] )
		slider:SetSize( 150, 50 )
		slider:SetMin( v[4] )			
		slider:SetMax( v[5] )
		slider:SetDecimals( v[6] )					
		slider.SCarConVar = v[2]
		CreateClientConVar( "cl_"..v[2], v[3], true, false)
		slider:SetConVar( "cl_"..v[2] )				
		slider.IsCheckBox = false
		Panel:AddItem(slider)
		nrOfItems = nrOfItems + 1
		items[nrOfItems] = slider	
	end		
	
	local button = vgui.Create( "DButton" ) 
	button:SetSize( 150, 20 )
	button:SetText( "Apply Settings" )
	button.DoClick = function( button )
		if LocalPlayer():IsAdmin() then
			ApplySettings()
		else
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "You are not an administrator!")
		end
	end	
	
	Panel:AddItem(button)	
end

local function ScarRadioPanels(Panel)
	Panel:ClearControls()

	local lastSelection = ""
	
	local CannelName = vgui.Create( "DTextEntry" )
	local ChannelURL = vgui.Create( "DTextEntry" )

	
	local ChannelList = vgui.Create( "DListView" )
	ChannelList:SetSize( 100, 185 )
	ChannelList:SetMultiSelect(false)
	ChannelList:AddColumn("Radio Stations") -- Add column	
	
	
	local chanNames = SCarRadioManager:GetNameTable()
	for i = 1, SCarRadioManager:GetNrOfChannels() do
		ChannelList:AddLine( chanNames[i] )
	end		

	local AddButton = vgui.Create( "DButton" )
	AddButton:SetText( "Add new channel" )
	AddButton.DoClick = function ()
		
		local name = CannelName:GetValue()
		local url = ChannelURL:GetValue()
		
		if !name or string.len( name ) == 0 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "Missing name" )	
			return
		end
		
		if !url or string.len( url ) == 0 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "Missing URL" )	
			return
		end
		if !SCarRadioManager:AddChannel( CannelName:GetValue(), ChannelURL:GetValue() ) then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "Channel already exists" )
			return
		else
			ChannelList:AddLine( CannelName:GetValue() )
			SCarRadioManager:SaveChannelsToFile()
			ScarRadio:RefreshChannelList()
		end
	end	

	local RemoveButton = vgui.Create( "DButton" )
	RemoveButton:SetText( "Remove channel" )
	RemoveButton.DoClick = function ()
		
		SCarRadioManager:RemoveChannel( lastSelection )
		SCarRadioManager:SaveChannelsToFile()
		local CPanel = controlpanel.Get( "SCarsRadioControls" )
		if ( !CPanel ) then return end
		
		CPanel:ClearControls()
		ScarRadioPanels(CPanel)
		ScarRadio:RefreshChannelList()
	end	
	
	
	ChannelList.OnClickLine = function(parent, line, isselected)
		local val = line:GetValue(1)
		if lastSelection != val then
			lastSelection = val

			CannelName:SetValue( lastSelection )
			ChannelURL:SetValue( SCarRadioManager:GetUrlFromName( lastSelection ) )
		end
	end		

	
	Panel:AddItem(ChannelList)
	Panel:AddControl( "Label", { Text = "Name", Description = "" } )	
	Panel:AddItem(CannelName)
	Panel:AddControl( "Label", { Text = "URL", Description = "" } )	
	Panel:AddItem(ChannelURL)	
	Panel:AddItem(AddButton)	
	Panel:AddItem(RemoveButton)
	
end
		
local function ScarOptions(Panel)
	Panel:ClearControls()

	
	for k, v in pairs( list.Get("ScarClConvarOptions") ) do
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( v[1] ) 
		checkBox:SetValue( GetConVarNumber( v[2] ) )
		checkBox:SetConVar( v[2] )
		checkBox.slot = v[2]
		checkBox.OnChange = function(se, val)
		   SCarClientData[se.slot] = val
		end		
		SCarClientData[v[2]] = checkBox:GetChecked()
		
		Panel:AddItem(checkBox)			
	end	
end


local function SCarStoolAdministration(Panel)
	Panel:ClearControls()

	for k, v in pairs( list.Get("ScarConVarStool") ) do
		local checkBox = vgui.Create( "DCheckBoxLabel" ) 
		checkBox:SetText( v[1] ) 
		checkBox:SetValue( GetConVarNumber( v[2] ) )
		CreateClientConVar( "cl_"..v[2], v[3], true, false)
		checkBox:SetConVar( "cl_"..v[2] )				
		checkBox.slot = v[2]
		checkBox.OnChange = function(se, val)
		   SCarClientData[se.slot] = val
		end		
		SCarClientData[v[2]] = checkBox:GetChecked()
		
		Panel:AddItem(checkBox)			
	end	
end

list.Add("ScarClConvarMisc", {"scar_rearviewmirror_use", 0, true} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_posx", 50, false} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_posy", 0, false} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_sizex", 30, false} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_sizey", 30, false} )

local function ScarRearViewMirror(Panel)
	Panel:ClearControls()

	
	local checkBox = vgui.Create( "DCheckBoxLabel" ) 
	checkBox:SetText( "Use rear view mirror" ) 
	checkBox:SetValue( GetConVarNumber( "scar_rearviewmirror_use" ) )
	checkBox:SetConVar( "scar_rearviewmirror_use" )
	checkBox.slot = "scar_rearviewmirror_use"
	checkBox.OnChange = function(se, val)
	   SCarClientData[se.slot] = val
	end		
	SCarClientData["scar_rearviewmirror_use"] = checkBox:GetChecked()
	Panel:AddItem(checkBox)	
	
	
	--X pos
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "X pos" )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_rearviewmirror_posx" )	
	slider.slot = "scar_rearviewmirror_posx"
	slider.OnValueChanged = function(se, val)
	   SCarClientData[se.slot] = val
	end	
	Panel:AddItem(slider)


	--Y pos
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "Y pos" )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_rearviewmirror_posy" )	
	slider.slot = "scar_rearviewmirror_posy"
	slider.OnValueChanged = function(se, val)	
	   SCarClientData[se.slot] = val
	end	
	Panel:AddItem(slider)

	--X size
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "X size" )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_rearviewmirror_sizex" )	
	slider.slot = "scar_rearviewmirror_sizex"
	slider.OnValueChanged = function(se, val)
	   SCarClientData[se.slot] = val
	end	
	Panel:AddItem(slider)
	
	--Y size
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "Y size" )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_rearviewmirror_sizey" )	
	slider.slot = "scar_rearviewmirror_sizey"
	slider.OnValueChanged = function(se, val)
	   SCarClientData[se.slot] = val
	end	
	Panel:AddItem(slider)	
	
	Panel:AddControl( "Label", { Text = "\n The rear view mirror may cause some sprites to dissappear.\n This is a rendering error i can not fix.", Description = "" } )
	
end

local function SCarEditorMenu(Panel)
	Panel:ClearControls()

	local button = vgui.Create( "DButton" ) 
	button:SetSize( 150, 20 )
	button:SetText( "Open Editor" )
	button.DoClick = function( button )
		LocalPlayer():ConCommand( "scar_showeditor" )
	end
	
	Panel:AddItem(button)	
end



local PANEL={}

function PANEL:Init()
	self.Selected = false
	self.id = 0
	
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)	
	local width = self:GetParent():GetWide() --Width keep getting fucked up! Returns 64 here while it returns 281 in the paint func
	local height = 25
	self:SetSize(width,height) 

	self.KeyText = vgui.Create("DLabel",self)
	self.KeyText:SetPos(5,0)
	self.KeyText:SetFont("Default")
	self.KeyText:SetText("")
	self.KeyText:SetColor(Color(255,255,255,255))
	self.KeyText:SetSize(width/2,height)

	self.BoundKey = vgui.Create("DLabel",self)
	self.BoundKey:SetFont("Default")
	self.BoundKey:SetPos(width/2,0)
	self.BoundKey:SetSize(width/2,height)
	self.KeyText:SetColor(Color(255,255,255,255))
	self.BoundKey:SetText("")
	self.BoundKey.__IsVisible=true	
	
end


function PANEL:ToggleSelect()
	if self.Selected then
		self.Selected = false
	else
		self.Selected = true
		SCarKeys:SetListeningPanel( self )
	end
end

function PANEL:Select()
	self.Selected = true
	SCarKeys:SetListeningPanel( self )
end

function PANEL:UnSelect()
	self.Selected = false
end

function PANEL:SetId( id )
	self.id = id
end

function PANEL:GetId()
	return self.id
end

function PANEL:SetKeyText(txt)
	self.KeyText:SetText(txt)
end

function PANEL:SetBoundText(txt)
	self.BoundKey:SetText(txt)
end
 

function PANEL:Paint()
	self.BoundKey:SetPos(self:GetWide()*0.05,0)
	self.KeyText:SetSize(self:GetWide()*0.5,25)
	self.BoundKey:SetPos(self:GetWide()*0.55,0)
	self.BoundKey:SetSize(self:GetWide()*0.5,25)

	draw.RoundedBox(0,0,0,self:GetWide() * 0.5,self:GetTall(),Color(200,200,200,255))
	draw.RoundedBox(0,1,1,self:GetWide() * 0.5-2,self:GetTall()-2,Color(150,150,150,255))
	
	if self.Selected then
		draw.RoundedBox(0,self:GetWide() * 0.5,0,self:GetWide() * 0.5-2,self:GetTall(),Color(0,0,0,255))
		draw.RoundedBox(0,self:GetWide() * 0.5 + 1,1,self:GetWide() * 0.5-4,self:GetTall	()-2,Color(150,150,150,255))
		self.BoundKey:SetColor(Color(255,255,255,0))
	else
		draw.RoundedBox(0,self:GetWide() * 0.5,0,self:GetWide() * 0.5-2,self:GetTall(),Color(150,150,150,255))
		draw.RoundedBox(0,self:GetWide() * 0.5 + 1,1,self:GetWide() * 0.5-4,self:GetTall	()-2,Color(100,100,100,255))
		self.BoundKey:SetColor(Color(255,255,255,255))
	end
	
	return true
end


function PANEL:OnMousePressed()
	self:ToggleSelect()
end
 
vgui.Register( "ScarKey", PANEL )


local function AddPopulateSCarAdminMenu()
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarsRadioControls", "Radio", "", "", ScarRadioPanels)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarAdminOptions", "Admin Options", "", "", PopuScarAdminMenu)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarLimitations", "Admin Car Limitations", "", "", PopuScarAdminMenuLimitations)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarOptions", "Options", "", "", ScarOptions)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarControls", "Controls", "", "", SCarKeys.BuildKeyMenu)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarHud", "HUD", "", "", SCarHudHandler.BuildMenu)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarCam", "Camera", "", "", SCarViewManager.BuildMenu)
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarRearViewMirror", "Rear view mirror", "", "", ScarRearViewMirror)
	
	spawnmenu.AddToolMenuOption("Utilities", "SCars", "SCarEditor", "SCar Editor", "", "", SCarEditorMenu)
end
hook.Add("PopulateToolMenu", "AddPopulateSCarAdminMenu", AddPopulateSCarAdminMenu)

	