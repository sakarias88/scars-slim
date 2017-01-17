local SCarDepencies = {}

local PANEL = {}
language.Add( "SCars_MissingDependency", "SCar missing addon dependency!" )	

function PANEL:Init()
    self:SetSize( 83, 83 )
    
    self.Label = vgui.Create ( "DLabel", self )
    
    self:SetKeepAspect( true )
    self:SetDrawBorder( true )
    
    self.m_Image:SetPaintedManually( true )
end

function PANEL:PerformLayout()
    self.Label:SizeToContents()
    
    self.Label:SetFont( "HudHintTextSmall" )
    self.Label:SetTextColor( color_white )
    self.Label:SetContentAlignment( 5 )
    self.Label:SetWide( self:GetWide() )
    self.Label:AlignBottom( 2 )
    
    DImageButton.PerformLayout( self )
    
    if ( self.imgAdmin ) then
    
        self.imgAdmin:SizeToContents()
        self.imgAdmin:AlignTop( 4 )
        self.imgAdmin:AlignRight( 4 )
    
    end
end

function PANEL:Paint( w, h )
    local w, h = self:GetSize()
    
    self.m_Image:Paint()
    
    surface.SetDrawColor( 30, 30, 30, 200 )
    surface.DrawRect( 0, h - 16, w, 16 )

end

function PANEL:CreateAdminIcon()
    self.imgAdmin = vgui.Create( "DImage", self )
    self.imgAdmin:SetImage( "gui/silkicons/shield" )
    self.imgAdmin:SetTooltip( "#Admin Only" )
end

function PANEL:CreateMissingDependencyIcon()
    self.imgAdmin = vgui.Create( "DImage", self )
    self.imgAdmin:SetImage( "gui/silkicons/invalid" )
    self.imgAdmin:SetTooltip( "#SCars_MissingDependency" )
end

function PANEL:Setup( NiceName, SpawnName, IconMaterial, AdminOnly, MissingDependency, DependencyNotice )
    self.Label:SetText( NiceName or "No Name" )
    self.DoClick = function()
		if MissingDependency then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, SpawnName..": Dependency note: "..DependencyNotice)
			LocalPlayer():EmitSound("buttons/button17.wav",100,100)
		else
			RunConsoleCommand( "gm_spawnscar", SpawnName )
		end
	end

    if ( !IconMaterial ) then
        IconMaterial = "vgui/entities/"..SpawnName
    end
    
	local existDir = "materials/"..IconMaterial..".vmt"
	if( !file.Exists( existDir, "GAME" ) ) then
		IconMaterial = "vgui/entities/noicon"
	end

    self:SetOnViewMaterial( IconMaterial, "vgui/swepicon" )

	if ( MissingDependency ) then 
		self:CreateMissingDependencyIcon() 
    elseif ( AdminOnly ) then 
		self:CreateAdminIcon() 
	end

    self:InvalidateLayout()

end
local WeaponIcon = vgui.RegisterTable( PANEL, "DImageButton" )


local PANEL = {}
function PANEL:Init()
    
    self.PanelList = vgui.Create( "DPanelList", self )    
        self.PanelList:SetPadding( 4 )
        self.PanelList:SetSpacing( 2 )
        self.PanelList:EnableVerticalScrollbar( true )
        
    self:BuildList()
end

function PANEL:BuildList()
    
    self.PanelList:Clear()
    
    local Vehicles = list.Get( "SCarVehicles" )
    local Categorised = {}
	
    for k, vehicle in pairs( Vehicles ) do
        vehicle.Category = vehicle.Category or "Other"
        Categorised[ vehicle.Category ] = Categorised[ vehicle.Category ] or {}
        vehicle.__ClassName = k
        table.insert( Categorised[ vehicle.Category ], vehicle )
        Vehicles[ k ] = nil
    
    end
    Vehicles = nil
    
    for CategoryName, v in SortedPairs( Categorised ) do
    
        local Category = vgui.Create( "DCollapsibleCategory", self )
        self.PanelList:AddItem( Category )
        Category:SetLabel( CategoryName )
        Category:SetCookieName( "VehicleSpawn."..CategoryName )
        
        local Content = vgui.Create( "DPanelList" )
        Category:SetContents( Content )
        Content:EnableHorizontal( true )
        Content:SetDrawBackground( false )
        Content:SetSpacing( 2 )
        Content:SetPadding( 2 )
        Content:SetAutoSize( true )


        for k, SCarTable in SortedPairsByMemberValue( v, "Name" ) do
			local carInfo = SCarRegister:GetInfo( SCarTable.__ClassName )
			
			local hasDependency = false
			if SCarDepencies and SCarDepencies[SCarTable.__ClassName] then
				hasDependency = SCarDepencies[SCarTable.__ClassName]
			end

            local Icon = vgui.CreateFromTable( WeaponIcon, self )
                Icon:Setup( SCarTable.Name or SCarTable.__ClassName, SCarTable.__ClassName, SCarTable.Material, carInfo.AdminOnly, hasDependency, carInfo.DependencyNotice)
               
            local Tooltip =  Format( "Name: %s", SCarTable.Name )
                if ( SCarTable.Author ) then Tooltip = Format( "%s\nAuthor: %s", Tooltip, SCarTable.Author ) end
                if ( SCarTable.Information ) then Tooltip = Format( "%s\n\n%s", Tooltip, SCarTable.Information ) end
                
                Icon:SetTooltip( Tooltip )
                Content:AddItem( Icon )
        end
    end
    
    self.PanelList:InvalidateLayout()
end

function PANEL:PerformLayout()
    self.PanelList:StretchToParent( 0, 0, 0, 0 )
end

local CreationSheet = vgui.RegisterTable( PANEL, "Panel" )

SCarsTab = {}
local function CreateContentPanel()
    local ctrl = vgui.CreateFromTable( CreationSheet )
	SCarsTab = ctrl
    return ctrl
end
spawnmenu.AddCreationTab( "SCars", CreateContentPanel, "SCarMisc/scar", 40 )


local function SCars_MissingDependencies(len)
	local tabl = net.ReadTable()
	
	if tabl then
		SCarDepencies = tabl
	end
end
net.Receive("SCars_MissingDependencies", SCars_MissingDependencies)
 