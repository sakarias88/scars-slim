
local PANEL = {}

PANEL.Models = {}
PANEL.Positions = {}
PANEL.Angles = {}
PANEL.Colors = {}
PANEL.CamPos = Vector(230,125,60)
PANEL.LookAtPos = Vector(0,0,0)
PANEL.CamDist = 265
PANEL.CamAng = Angle(0,0,0)
PANEL.MouseUse = false
PANEL.MouseHover = false
PANEL.LastMouseX = 0
PANEL.LastMouseY = 0

AccessorFunc( PANEL, "m_fAnimSpeed",     "AnimSpeed" )
AccessorFunc( PANEL, "Entity",             "Entity" )
AccessorFunc( PANEL, "vCamPos",         "CamPos" )
AccessorFunc( PANEL, "fFOV",             "FOV" )
AccessorFunc( PANEL, "vLookatPos",         "LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor",         "Color" )
AccessorFunc( PANEL, "bAnimated",         "Animated" )


function PANEL:Init()

    --self = nil
	self.Models = {}
	self.Positions = {}
	self.Angles = {}
    self.LastPaint = 0
    self.DirectionalLight = {}
    
    self:SetCamPos( Vector( 50, 50, 50 ) )
    self:SetLookAt( Vector( 0, 0, 40 ) )
    self:SetFOV( 70 )
    
    self:SetText( "" )
    self:SetAnimSpeed( 0.5 )
    self:SetAnimated( false )
    
    self:SetAmbientLight( Color( 50, 50, 50, 255 ) )
    
    self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255, 255 ) )
    self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255, 255 ) )
    
    self:SetColor( Color( 255, 255, 255, 255 ) )

end

function PANEL:Clear()
	self.Models = {}
	self.Positions = {}
	self.Angles = {}
end

function PANEL:OnMouseWheeled( arg )

	self.CamDist = self.CamDist + arg * -10
end

function PANEL:Think()
	
	if self.MouseUse == true then
		local diffX = self.LastMouseX - gui.MouseX()
		local diffY = self.LastMouseY - gui.MouseY()	
		self.LastMouseX = gui.MouseX()
		self.LastMouseY = gui.MouseY()
		
		self.CamAng.y = self.CamAng.y + diffX * 0.5
		self.CamAng.p = self.CamAng.p + diffY * 0.5
	end


	if self.MouseHover then
		if input.IsKeyDown(KEY_A) then
			self.CamAng.y = self.CamAng.y - 1
		elseif input.IsKeyDown(KEY_D) then
			self.CamAng.y = self.CamAng.y + 1
		end
		
		if input.IsKeyDown(KEY_LSHIFT) then
			if input.IsKeyDown(KEY_S) then
				self.CamDist = self.CamDist + 1
			elseif input.IsKeyDown(KEY_W ) then
				self.CamDist = self.CamDist - 1
			end			
		else
			if input.IsKeyDown(KEY_S) then
				self.CamAng.p = self.CamAng.p - 1
			elseif input.IsKeyDown(KEY_W ) then
				self.CamAng.p = self.CamAng.p + 1
			end	
		end
	end
	
	self.CamDist = math.Clamp(self.CamDist, 10,500)
	self.CamPos = self.CamAng:Forward() * self.CamDist
end


function PANEL:SetDirectionalLight( iDirection, color )
    self.DirectionalLight[iDirection] = color
end


function PANEL:AddModel( strModelName, id )
    
	if ( IsValid( self.Models[id] ) ) then
        self.Models[id]:Remove()
		self.Models[id] = nil        
    end	
	
	 if ( !ClientsideModel ) then return end
	self.Models[id] = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	self.Positions[id] = Vector(0,0,0)
	self.Angles[id] = Angle(0,0,0)
	self.Models[id]:SetNoDraw( true )
	self.Colors[id] = Color(255,255,255,255)
	
end

function PANEL:SetModelPos( id, pos )
	if ( IsValid( self.Models[id] ) ) then
		self.Positions[id] = pos
		self.Models[id]:SetPos(pos)
	end
end

function PANEL:SetModel( id, model )
	if ( IsValid( self.Models[id] ) ) then
        self.Models[id]:Remove()       
		self.Models[id] = ClientsideModel( model, RENDER_GROUP_OPAQUE_ENTITY )
		
		if self.Positions[id] then
			self.Models[id]:SetPos(self.Positions[id])	
		end
		
		if self.Angles[id] then
			self.Models[id]:SetAngles(self.Angles[id])	
		end		
	end
end

function PANEL:GetModelPos( id )
	return self.Positions[id]
end

function PANEL:SetModelAng( id, ang )
	if ( IsValid( self.Models[id] ) ) then
		self.Angles[id] = ang
		self.Models[id]:SetAngles(ang)
	end
end

function PANEL:SetModelColour( id, r,g,b,a )
	if ( IsValid( self.Models[id] ) ) then
		self.Colors[id] = Color(r,g,b,a)
	end
end

function PANEL:RemoveModel( id )
	self.Models[id] = nil        
end

function PANEL:OnMousePressed()
	self.MouseUse = true
	self.LastMouseX = gui.MouseX()
	self.LastMouseY = gui.MouseY()	
end

function PANEL:OnMouseReleased()
	self.MouseUse = false
	self.LastMouseX = gui.MouseX()
	self.LastMouseY = gui.MouseY()		
end

function PANEL:OnCursorEntered()
	self.MouseHover = true
end

function PANEL:OnCursorExited()
	self.MouseUse = false
	self.MouseHover = false
	self.LastMouseX = gui.MouseX()
	self.LastMouseY = gui.MouseY()	
end


function PANEL:Paint()

	if SCarEditor.InvalidModelInfo == true then
		SCarEditor.InvalidModelInfo = false
		SCarEditor:ApplyAllModelSettings()
	end



	local x, y = self:LocalToScreen( 0, 0 )
	local w,h = self:GetSize()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Vector(0,0,0) )
	
	local addX = (self:GetWide() - (self:GetWide() * 0.99)) * 0.5
	local addY = (self:GetTall() - (self:GetTall() * 0.99)) * 0.5
	draw.RoundedBox( 4, addX, addY, self:GetWide() * 0.99 , self:GetTall() * 0.99, Vector(150,150,150) )
	

	cam.Start3D( self.CamPos, (self.LookAtPos-self.CamPos):Angle(), self.fFOV, x, y, w,h )
	cam.IgnoreZ( true )
	render.SuppressEngineLighting( true )	
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )
	
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	for k,v in pairs(self.Models) do
		if ( !IsValid( v ) ) then return end
		render.SetColorModulation( self.Colors[k].r/255, self.Colors[k].g/255, self.Colors[k].b/255 )

		render.SetLightingOrigin( v:GetPos() )

		v:DrawModel()
	end
	
	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()			

	self.LastPaint = RealTime()	
end


function PANEL:RunAnimation()
    self:FrameAdvance( (RealTime()-self.LastPaint) * self.m_fAnimSpeed )    
end


function PANEL:LayoutEntity( Entity )
    if ( self.bAnimated ) then
        self:RunAnimation()
    end
    
    Entity:SetAngles( Angle( 0, RealTime()*10,  0) )
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

    local ctrl = vgui.Create( ClassName )
        ctrl:SetSize( 300, 300 )
        ctrl:SetModel( "models/error.mdl" )
        
    PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DMultiModelPanel", "A panel containing models", PANEL, "DButton" )



--------------------------------------------------------------------------------------



SCarEditor = {}
SCarEditor.Panel = nil
SCarEditor.ModelPanel = nil
SCarEditor.CarModel = "models/Splayn/chevy66.mdl"
SCarEditor.WheelModel = "models/Splayn/chevy66_wheel.mdl"
SCarEditor.CarMass = 600
SCarEditor.OptionsList = nil
SCarEditor.CarMassSlider = nil
SCarEditor.LastLoadTable = nil
CreateClientConVar("scareditor_carmass", "500", true, false)

SCarEditor.InvalidModelInfo = false
SCarEditor.CarModelTextField = nil
SCarEditor.WheelModelTextField = nil
SCarEditor.CarCategory = nil
SCarEditor.CarCategoryName = "No Category"

SCarEditor.HydraulicsSlider = nil
SCarEditor.HydraulicsSliderValue = 10

--Models and misc
SCarEditor.AnimTypeList = nil
SCarEditor.AnimType = 1
SCarEditor.AddSpawnHeightSlider = nil
SCarEditor.AddSpawnHeight = 5
CreateClientConVar("scareditor_AddSpawnHeight", "5", true, false)
SCarEditor.ViewDistSlider = nil
SCarEditor.ViewDist = 200
CreateClientConVar("scareditor_ViewDist", "200", true, false)
SCarEditor.ViewDistUpSlider = nil
SCarEditor.ViewDistUp = 10
CreateClientConVar("scareditor_ViewDistUp", "10", true, false)


--Wheel stuff
SCarEditor.NrOfWheels = 0
SCarEditor.MaxNrOfWheels = 0
SCarEditor.WheelsPos = {}
SCarEditor.WheelSide = {}
SCarEditor.WheelTorq = {}
SCarEditor.WheelSteer = {}
SCarEditor.wheelList = nil
SCarEditor.wheelListLines = {}
SCarEditor.CurId = 0
SCarEditor.WheelSuspensionSlider = nil
SCarEditor.WheelSuspensionStiffness = 15

SCarEditor.XSliderWheel = nil
SCarEditor.YSliderWheel = nil
SCarEditor.ZSliderWheel = nil


SCarEditor.IgnoreChange = false

SCarEditor.TorqCheckBox = nil
SCarEditor.SideCheckBox = nil
SCarEditor.SteerSlider = nil

CreateClientConVar("scareditor_x_wheel", "0", true, false)
CreateClientConVar("scareditor_y_wheel", "0", true, false)
CreateClientConVar("scareditor_z_wheel", "0", true, false)

CreateClientConVar("scareditor_x", "0", true, false)
CreateClientConVar("scareditor_y", "0", true, false)
CreateClientConVar("scareditor_z", "0", true, false)

CreateClientConVar("scareditor_torq", "0", true, false)
CreateClientConVar("scareditor_side", "0", true, false)
CreateClientConVar("scareditor_steer", "0", true, false)
CreateClientConVar("scareditor_suspensionStiffness", "0", true, false)
SCarEditor.Xpos_wheel = 0
SCarEditor.Ypos_wheel = 0
SCarEditor.Zpos_wheel = 0

--Seat Stuff
SCarEditor.NrOfSeats = 0
SCarEditor.MaxNrOfSeats = 0
SCarEditor.SeatPos = {}
SCarEditor.seatList = nil
SCarEditor.seatListLines = {}

SCarEditor.XSliderSeat = nil
SCarEditor.YSliderSeat = nil
SCarEditor.ZSliderSeat = nil

CreateClientConVar("scareditor_x_seat", "0", true, false)
CreateClientConVar("scareditor_y_seat", "0", true, false)
CreateClientConVar("scareditor_z_seat", "0", true, false)

SCarEditor.Xpos_seat = 0
SCarEditor.Ypos_seat = 0
SCarEditor.Zpos_seat = 0


--Front lights
SCarEditor.NrOfFLight = 0
SCarEditor.MaxNrOfFLight = 0
SCarEditor.FLightPos = {}
SCarEditor.FLightList = nil
SCarEditor.FLightListLines = {}

SCarEditor.XSliderFLight = nil
SCarEditor.YSliderFLight = nil
SCarEditor.ZSliderFLight = nil

CreateClientConVar("scareditor_x_fl", "0", true, false)
CreateClientConVar("scareditor_y_fl", "0", true, false)
CreateClientConVar("scareditor_z_fl", "0", true, false)

SCarEditor.Xpos_fl = 0
SCarEditor.Ypos_fl = 0
SCarEditor.Zpos_fl = 0


--Rear lights
SCarEditor.NrOfRLight = 0
SCarEditor.MaxNrOfRLight = 0
SCarEditor.RLightPos = {}
SCarEditor.RLightList = nil
SCarEditor.RLightListLines = {}

SCarEditor.XSliderRLight = nil
SCarEditor.YSliderRLight = nil
SCarEditor.ZSliderRLight = nil

CreateClientConVar("scareditor_x_rl", "0", true, false)
CreateClientConVar("scareditor_y_rl", "0", true, false)
CreateClientConVar("scareditor_z_rl", "0", true, false)
SCarEditor.Xpos_rl = 0
SCarEditor.Ypos_rl = 0
SCarEditor.Zpos_rl = 0


--Exhausts
SCarEditor.NrOfExhausts = 0
SCarEditor.MaxNrOfExhausts= 0
SCarEditor.ExhaustsPos = {}
SCarEditor.ExhaustsList = nil
SCarEditor.ExhaustsListLines = {}

SCarEditor.XSliderExhausts = nil
SCarEditor.YSliderExhausts = nil
SCarEditor.ZSliderExhausts = nil

CreateClientConVar("scareditor_x_exhaust", "0", true, false)
CreateClientConVar("scareditor_y_exhaust", "0", true, false)
CreateClientConVar("scareditor_z_exhaust", "0", true, false)

SCarEditor.Xpos_exhaust = 0
SCarEditor.Ypos_exhaust = 0
SCarEditor.Zpos_exhaust = 0

--Effect pos
SCarEditor.EffectPos = nil
SCarEditor.XSliderEffect = nil
SCarEditor.YSliderEffect = nil
SCarEditor.ZSliderEffect = nil

CreateClientConVar("scareditor_x_effect", "0", true, false)
CreateClientConVar("scareditor_y_effect", "0", true, false)
CreateClientConVar("scareditor_z_effect", "0", true, false)

SCarEditor.Xpos_effect = 0
SCarEditor.Ypos_effect = 0
SCarEditor.Zpos_effect = 0


--Sound and effects
SCarEditor.EngineSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
SCarEditor.EngineSoundID = 1
SCarEditor.HornSound = "SCarHorns/horn 1.wav"
SCarEditor.HornSoundID = 1
SCarEditor.EngineEffect = "Default"
SCarEditor.EngineEffectID = 1

SCarEditor.EngineSoundList = nil
SCarEditor.HornSoundList = nil
SCarEditor.EngineEffectList = nil


--Vehicle performance
CreateClientConVar("scareditor_DefaultAcceleration", "3000", true, false)
CreateClientConVar("scareditor_DefaultMaxSpeed", "1500", true, false)
CreateClientConVar("scareditor_DefaultTurboEffect", "2", true, false)
CreateClientConVar("scareditor_DefaultTurboDuration", "4", true, false)
CreateClientConVar("scareditor_DefaultTurboDelay", "10", true, false)
CreateClientConVar("scareditor_DefaultReverseForce", "1000", true, false)
CreateClientConVar("scareditor_DefaultReverseMaxSpeed", "200", true, false)
CreateClientConVar("scareditor_DefaultBreakForce", "2000", true, false)
CreateClientConVar("scareditor_DefaultSteerForce", "5", true, false)
CreateClientConVar("scareditor_DefautlSteerResponse", "0.3", true, false)
CreateClientConVar("scareditor_DefaultStabilisation", "2000", true, false)
CreateClientConVar("scareditor_DefaultNrOfGears", "5", true, false)
CreateClientConVar("scareditor_DefaultAntiSlide", "10", true, false)
CreateClientConVar("scareditor_DefaultAutoStraighten", "5", true, false)
CreateClientConVar("scareditor_DeafultSuspensionAddHeight", "10", true, false)
CreateClientConVar("scareditor_DefaultHydraulicActive", "0", true, false)



---Save Load Menu
SCarEditor.FileList = nil
SCarEditor.SaveNameTextBox = nil
SCarEditor.FileListFileName = ""
SCarEditor.SaveFileName = ""
SCarEditor.SaveLoadDir = "SCarEditorSaves/"


concommand.Add("scar_showeditor", function()
	SCarEditor:Menu()
end)

function SCarEditor:GetLastSpawnTable()
	return self.LastLoadTable
end

function SCarEditor:Menu( panel )

 
	if self.Panel == nil or self.Panel and self.Panel.IsActive == nil or self.Panel and self.Panel:IsActive() == false then
		self:InitMenu( panel )
		self:CreateAllModels()
		self:LoadAndSave()
		self:ModelsAndMiscMenu()
		self:WheelMenu()
		self:SeatMenu()
		self:FLightMenu()
		self:RLightMenu()
		self:ExhaustMenu()
		self:EffectMenu()
		self:SoundAndEffectMenu()
		self:PerformanceMenu()
		self:HydraylicsAndSuspensionMenu()
		self:FillListsWithContent()
		
		SCarEditor.InvalidModelInfo = true
	end
end

function SCarEditor:FillListsWithContent()

	self.wheelListLines = {}
	self.wheelList:Clear()
	for i = 1, self.MaxNrOfWheels do
		if self.WheelsPos[i] then
			self.wheelListLines[i] = self.wheelList:AddLine("wheel"..i)
			self.wheelListLines[i].OnSelect = function()
				SCarEditor:SelectWheel( i )
			end		
		end
	end	
	
	--Seats
	self.seatListLines = {}
	self.seatList:Clear()
	for i = 1, self.MaxNrOfSeats do
		if self.SeatPos[i] then
			self.seatListLines[i] = self.seatList:AddLine("seat"..i)
			self.seatListLines[i].OnSelect = function()
				SCarEditor:SelectSeat( i )
			end				
		end
	end
	

	--FLight
	self.FLightListLines = {}
	self.FLightList:Clear()
	for i = 1, self.MaxNrOfFLight do
		if self.FLightPos[i] then
			self.FLightListLines[i] = self.FLightList:AddLine("flight"..i)
			self.FLightListLines[i].OnSelect = function()
				SCarEditor:SelectFLight( i )
			end				
		end
	end
	
	--RLight
	self.RLightListLines = {}
	self.RLightList:Clear()
	for i = 1, self.MaxNrOfRLight do
		if self.RLightPos[i] then
			self.RLightListLines[i] = self.RLightList:AddLine("rlight"..i)
			self.RLightListLines[i].OnSelect = function()
				SCarEditor:SelectRLight( i )
			end				
		end
	end
	
	--Exhausts
	self.ExhaustsListLines = {}
	self.ExhaustsList:Clear()
	for i = 1, self.MaxNrOfExhausts do
		if self.ExhaustsPos[i] then
			self.ExhaustsListLines[i] = self.ExhaustsList:AddLine("exhaust"..i)
			self.ExhaustsListLines[i].OnSelect = function()
				SCarEditor:SelectExhausts( i )
			end			
		end
	end
	

	--Effect pos
	if self.EffectPos then
		self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "effect" )
		self.ModelPanel:SetModelPos( "effect", self.EffectPos )

		RunConsoleCommand("scareditor_x_effect", self.EffectPos.x)
		RunConsoleCommand("scareditor_y_effect", self.EffectPos.y)
		RunConsoleCommand("scareditor_z_effect", self.EffectPos.z)
	end
	
	
	RunConsoleCommand("scareditor_carmass", self.CarMass)
	self.CarMassSlider:SetValue(self.CarMass)
	
	self.SaveNameTextBox:SetText(self.FileListFileName)
	self.SaveFileName = self.FileListFileName
	self.CarModelTextField:SetText(self.CarModel)
	self.WheelModelTextField:SetText(self.WheelModel)
	
	self.CarCategory:SetText(self.CarCategoryName)
		

	self.AnimTypeList:ChooseOptionID( self.AnimType )

	
	RunConsoleCommand("scareditor_DeafultSuspensionAddHeight", self.HydraulicsSliderValue)
	self.HydraulicsSlider:SetValue( self.HydraulicsSliderValue )
	
	RunConsoleCommand("scareditor_suspensionStiffness", self.WheelSuspensionStiffness)
	self.WheelSuspensionSlider:SetValue( self.WheelSuspensionStiffness )	
	
	
	
	RunConsoleCommand("scareditor_AddSpawnHeight", self.AddSpawnHeight)
	self.AddSpawnHeightSlider:SetValue( self.AddSpawnHeight )	

	RunConsoleCommand("scareditor_ViewDist", self.ViewDist)
	self.ViewDistSlider:SetValue( self.ViewDist )	

	RunConsoleCommand("scareditor_ViewDistUp", self.ViewDistUp)
	self.ViewDistUpSlider:SetValue( self.ViewDistUp )		
	

	self.EngineSoundID = tonumber(self.EngineSoundID) 
	self.HornSoundID = tonumber(self.HornSoundID) 
	self.EngineEffectID = tonumber(self.EngineEffectID) 
	self.EngineSoundList:ChooseOptionID( self.EngineSoundID )
	self.HornSoundList:ChooseOptionID( self.HornSoundID )
	self.EngineEffectList:ChooseOptionID( self.EngineEffectID )
	
end

function SCarEditor:CreateAllModels()
	
	--Wheels
	for i = 1, self.MaxNrOfWheels do
		if self.WheelsPos[i] then
			self.ModelPanel:AddModel( self.WheelModel, "wheel"..i )
		end
	end
	
	--Seats
	for i = 1, self.MaxNrOfSeats do
		if self.SeatPos[i] then
			self.ModelPanel:AddModel( "models/Nova/airboat_seat.mdl", "seat"..i )
		end
	end
	
	--Front lights
	for i = 1, self.MaxNrOfFLight do
		if self.FLightPos[i] then
			self.ModelPanel:AddModel( "models/props_wasteland/prison_cagedlight001a.mdl", "flight"..i )
		end
	end
	
	--Rear lights
	for i = 1, self.MaxNrOfRLight do
		if self.RLightPos[i] then
			self.ModelPanel:AddModel( "models/props_wasteland/prison_cagedlight001a.mdl", "rlight"..i )
		end
	end
	
	--Exhausts
	for i = 1, self.MaxNrOfExhausts do
		if self.ExhaustsPos[i] then
			self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "exhaust"..i )		
		end
	end
	
	if self.EffectPos then
		self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "effect" )
	end
end

function SCarEditor:ApplyAllModelSettings()
	
	--Wheels
	for i = 1, self.MaxNrOfWheels do
		if self.WheelsPos[i] then
			self.ModelPanel:SetModelPos( "wheel"..i , self.WheelsPos[i] )
			
			if self.WheelSide[i] == 0 then
				self.ModelPanel:SetModelAng( "wheel"..i, Angle(0,0,0) )
			else
				self.ModelPanel:SetModelAng( "wheel"..i, Angle(0,180,0) )
			end
		end
	end
	
	--Seats
	for i = 1, self.MaxNrOfSeats do
		if self.SeatPos[i] then
			self.ModelPanel:SetModelAng( "seat"..i, Angle(0,-90,0) )
			self.ModelPanel:SetModelPos( "seat"..i , self.SeatPos[i] )
		end
	end

	
	--Front lights
	for i = 1, self.MaxNrOfFLight do
		if self.FLightPos[i] then
			self.ModelPanel:SetModelColour( "flight"..i, 255,255,0,0 )
			self.ModelPanel:SetModelPos( "flight"..i , self.FLightPos[i] )
		end
	end


	
	--Rear lights
	for i = 1, self.MaxNrOfRLight do
		if self.RLightPos[i] then
			self.ModelPanel:SetModelColour( "rlight"..i, 255,0,0,0 )
			self.ModelPanel:SetModelAng( "rlight"..i, Angle(0,180,0) )
			self.ModelPanel:SetModelPos( "rlight"..i , self.RLightPos[i] )
		end
	end
	
	--Exhausts
	for i = 1, self.MaxNrOfExhausts do
		if self.ExhaustsPos[i] then
			self.ModelPanel:SetModelAng( "exhaust"..i, Angle(0,180,0) )	
			self.ModelPanel:SetModelPos( "exhaust"..i , self.ExhaustsPos[i] )			
		end
	end
	
	if self.EffectPos then
		self.ModelPanel:SetModelPos( "effect", self.EffectPos )
	end	
end

function SCarEditor:InitMenu( panel )

	if panel == nil then
		self.Panel = vgui.Create( "DFrame" )
	else 
		self.Panel = panel
	end
	self.Panel:SetPos( 50,50 )
	self.Panel:SetSize( 1000, 700 )
	self.Panel:SetTitle( "SCar Editor" )
	self.Panel:SetVisible( true )
	self.Panel:SetDraggable( true )
	self.Panel:ShowCloseButton( true )
	self.Panel:MakePopup()
	
	self.ModelPanel = vgui.Create( "DMultiModelPanel", self.Panel )
	self.ModelPanel:SetPos(10,30)
	self.ModelPanel:AddModel( self.CarModel, "mdl1" )
	self.ModelPanel:SetModelPos( "mdl1", Vector(0,0,0) )
	self.ModelPanel:SetSize( 660, 660 )
	self.ModelPanel:SetCamPos( Vector( 50, 50, 120 ) )
	self.ModelPanel:SetLookAt( Vector( 0, 0, 0 ) )	

	self:CreateAllModels()
	
	self.OptionsList = vgui.Create( "DPanelList", self.Panel )
	self.OptionsList:SetPos( 680, 30 )
	self.OptionsList:SetSize( 305, 655 )
	self.OptionsList:SetSpacing( 5 ) 
	self.OptionsList:EnableHorizontal( false ) 
	self.OptionsList:EnableVerticalScrollbar( true ) 
end

function SCarEditor:ReloadFileList()
	self.FileList:Clear()
	self.FileList.DaChoices = {}
	
	local files = {}

	files =	file.Find( self.SaveLoadDir.."*.txt", "DATA")

		
	for k, v in pairs(files) do
		self.FileList:AddChoice(string.Explode(".", v)[1])
	end		
end

function SCarEditor:ResetSettings()
	self.CarModel = "models/Splayn/chevy66.mdl"
	self.WheelModel = "models/Splayn/chevy66_wheel.mdl"
	self.CarMass = 600
	self.CarCategoryName = "No Category"
	self.HydraulicsSliderValue = 10
	self.AnimType = 1
	self.AddSpawnHeight = 5
	self.ViewDist = 200
	self.ViewDistUp = 10
	self.NrOfWheels = 0
	self.MaxNrOfWheels = 0
	self.CurId = 0
	self.WheelSuspensionStiffness = 15
	self.Xpos_wheel = 0
	self.Ypos_wheel = 0
	self.Zpos_wheel = 0
	self.NrOfSeats = 0
	self.MaxNrOfSeats = 0
	self.Xpos_seat = 0
	self.Ypos_seat = 0
	self.Zpos_seat = 0
	self.NrOfFLight = 0
	self.MaxNrOfFLight = 0
	self.Xpos_fl = 0
	self.Ypos_fl = 0
	self.Zpos_fl = 0


	self.NrOfRLight = 0
	self.MaxNrOfRLight = 0

	self.Xpos_rl = 0
	self.Ypos_rl = 0
	self.Zpos_rl = 0

	self.NrOfExhausts = 0
	self.MaxNrOfExhausts= 0

	self.Xpos_exhaust = 0
	self.Ypos_exhaust = 0
	self.Zpos_exhaust = 0

	self.Xpos_effect = 0
	self.Ypos_effect = 0
	self.Zpos_effect = 0


	--Sound and effects
	self.EngineSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
	self.EngineSoundID = 1
	self.HornSound = "scarhorns/horn 1.wav"
	self.HornSoundID = 1
	self.EngineEffect = "Default"
	self.EngineEffectID = 1

	---Save Load Menu
	self.FileListFileName = ""
	self.SaveFileName = ""
	self.SaveLoadDir = "scareditorsaves/"
	
	
	self.ModelPanel:Clear()

	self.WheelsPos = {}
	self.WheelSide = {}
	self.WheelTorq = {}
	self.WheelSteer = {}
	self.SeatPos = {}
	self.FLightPos = {}
	self.RLightPos = {}
	self.ExhaustsPos = {}
	self.EffectPos = nil	


	
	self.ModelPanel:AddModel( self.CarModel, "mdl1" )
	self.ModelPanel:SetModelPos( "mdl1", Vector(0,0,0) )
	
	--Wheels
	self.wheelListLines = {}
	self.wheelList:Clear()
	

	--Seats
	self.seatListLines = {}
	self.seatList:Clear()
	

	--FLight
	self.FLightListLines = {}
	self.FLightList:Clear()

	
	--RLight
	self.RLightListLines = {}
	self.RLightList:Clear()
	
	--Exhausts
	self.ExhaustsListLines = {}
	self.ExhaustsList:Clear()


	self:FillListsWithContent()	
end

function SCarEditor:LoadAndSave()
	local collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Load and Save" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	local CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )
	
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Save File" )
	button.DoClick = function( button )
		SCarEditor:SaveFile( SCarEditor.SaveFileName )
		self:ReloadFileList()
	end	
	CategoryList:AddItem( button )		
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Load File" )
	button.DoClick = function( button )
		SCarEditor:LoadFile( SCarEditor.FileListFileName )
	end	
	CategoryList:AddItem( button )		

	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Delete File" )
	button.DoClick = function( button )
		SCarEditor:DeleteFile( SCarEditor.FileListFileName )
		SCarEditor:ReloadFileList()
	end	
	CategoryList:AddItem( button )		
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Export" )
	button.DoClick = function( button )
		SCarEditor:SaveFileAsLua( SCarEditor.FileListFileName )
	end	
	CategoryList:AddItem( button )			
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Spawn" )
	button.DoClick = function( button )
		SCarEditor:SpawnCar( SCarEditor.SaveFileName )
	end	
	CategoryList:AddItem( button )			
	
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Save File Name") 
	CategoryList:AddItem( textLabel )
	
	self.SaveNameTextBox = vgui.Create( "DTextEntry", DermaPanel )
	self.SaveNameTextBox:SetWide( 190 )
	self.SaveNameTextBox:SetEnterAllowed( true )
	self.SaveNameTextBox:SetValue("")
	self.SaveNameTextBox.OnEnter = function()
		SCarEditor.SaveFileName = self.SaveNameTextBox:GetValue()
	end	 
	self.SaveNameTextBox.OnLoseFocus = function()
		SCarEditor.SaveFileName = self.SaveNameTextBox:GetValue()
	end	 
	self.SaveNameTextBox.OnGetFocus = function()
		SCarEditor.SaveFileName = self.SaveNameTextBox:GetValue()
	end	 
	
	CategoryList:AddItem( self.SaveNameTextBox )	
	
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Selected File") 
	CategoryList:AddItem( textLabel )
	
	self.FileList = vgui.Create( "DComboBox", CategoryList)

	
	self.FileList.DaChoices = {}
	self.FileList.oldListFunc = self.FileList.AddChoice
	self.FileList.AddChoice = function(lst, choice)
		if !lst.DaChoices[choice] then
			lst.DaChoices[choice] = true
			lst:oldListFunc(choice)
		end
	end
	self.FileList.OnSelect = function( panel, index, value, data)
		SCarEditor.FileListFileName = value
	end
	
	self:ReloadFileList()
	 
	CategoryList:AddItem( self.FileList )

	
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "New Car" )
	button.DoClick = function( button )
		SCarEditor:ResetSettings()
	end	
	CategoryList:AddItem( button )		

	
	collapsCat:SetContents( CategoryList )	
end

function SCarEditor:DeleteFile( name )

	local foundDir = false

	foundDir = file.Exists( self.SaveLoadDir..name..".txt" , "DATA" )

	
	if 	foundDir then
		file.Delete( self.SaveLoadDir..name..".txt" )
	end
end

function SCarEditor:SpawnCar( name )
	--if SinglePlayer() then
	if LocalPlayer():IsAdmin() or GetConVarNumber( "scar_clispawneditor" ) == 1 then
		local cnt = 0
		local tabl = {}
		tabl.CarModel = self.CarModel
		tabl.WheelModel = self.WheelModel
		tabl.EngineSound = self.EngineSound
		tabl.HornSound = self.HornSound
		tabl.EngineEffect = self.EngineEffect
		tabl.CarMass = self.CarMass
		tabl.LoadedCarName = name
		tabl.AnimType = self.AnimType
		tabl.CarCategoryName = self.CarCategoryName
		tabl.WheelSuspensionStiffness = self.WheelSuspensionStiffness
		
		tabl.ViewDistUp = self.ViewDistUp
		tabl.ViewDist = self.ViewDist
		tabl.AddSpawnHeight = self.AddSpawnHeight
		

		---Wheels
		tabl.WheelsPos = {}
		tabl.WheelSide = {}
		tabl.WheelTorq = {}
		tabl.WheelSteer = {}
		for i = 1, self.MaxNrOfWheels do
			if self.WheelsPos[i] then
				cnt = cnt + 1
				tabl.WheelsPos[cnt] = self.WheelsPos[i]
				tabl.WheelSide[cnt] = self.WheelSide[i]
				tabl.WheelTorq[cnt] = self.WheelTorq[i]
				tabl.WheelSteer[cnt] = self.WheelSteer[i]
			end
		end
		tabl.NrOfWheels = cnt
		
		---Seats
		cnt = 0
		tabl.SeatPos = {}
		for i = 1, self.MaxNrOfSeats do
			if self.SeatPos[i] then
				cnt = cnt + 1
				tabl.SeatPos[cnt] = self.SeatPos[i]
			end
		end
		tabl.NrOfSeats = cnt
		
		--Front lights
		cnt = 0
		tabl.FLightPos = {}
		for i = 1, self.MaxNrOfFLight do
			if self.FLightPos[i] then
				cnt = cnt + 1
				tabl.FLightPos[cnt] = self.FLightPos[i]
			end
		end
		tabl.NrOfFLight = cnt
		
		--Rear lights
		cnt = 0
		tabl.RLightPos = {}
		for i = 1, self.MaxNrOfRLight do
			if self.RLightPos[i] then
				cnt = cnt + 1
				tabl.RLightPos[cnt] = self.RLightPos[i]
			end
		end
		tabl.NrOfRLight = cnt

		
		--Exhausts
		cnt = 0
		tabl.ExhaustPos = {}
		for i = 1, self.MaxNrOfExhausts do
			if self.ExhaustsPos[i] then
				cnt = cnt + 1
				tabl.ExhaustPos[cnt] = self.ExhaustsPos[i]
			end
		end
		tabl.NrOfExhausts = cnt

		if !self.EffectPos then self.EffectPos = Vector(0,0,0) end
		tabl.EffectPos = self.EffectPos
		tabl.DefaultAcceleration = GetConVarNumber( "scareditor_DefaultAcceleration" )
		tabl.DefaultMaxSpeed = GetConVarNumber( "scareditor_DefaultMaxSpeed" )
		tabl.DefaultTurboEffect = GetConVarNumber( "scareditor_DefaultTurboEffect" )
		tabl.DefaultTurboDuration = GetConVarNumber( "scareditor_DefaultTurboDuration" )
		tabl.DefaultTurboDelay = GetConVarNumber( "scareditor_DefaultTurboDelay" )
		tabl.DefaultReverseForce = GetConVarNumber( "scareditor_DefaultReverseForce" )
		tabl.DefaultReverseMaxSpeed = GetConVarNumber( "scareditor_DefaultReverseMaxSpeed" )
		tabl.DefaultBreakForce = GetConVarNumber( "scareditor_DefaultBreakForce" )
		tabl.DefaultSteerForce = GetConVarNumber( "scareditor_DefaultSteerForce" )
		tabl.DefautlSteerResponse = GetConVarNumber( "scareditor_DefautlSteerResponse" )
		tabl.DefaultStabilisation = GetConVarNumber( "scareditor_DefaultStabilisation" )
		tabl.DefaultNrOfGears = GetConVarNumber( "scareditor_DefaultNrOfGears" )
		tabl.DefaultAntiSlide = GetConVarNumber( "scareditor_DefaultAntiSlide" )
		tabl.DefaultAutoStraighten = GetConVarNumber( "scareditor_DefaultAutoStraighten" )
		tabl.DeafultSuspensionAddHeight = GetConVarNumber( "scareditor_DeafultSuspensionAddHeight" )
		tabl.DefaultHydraulicActive = GetConVarNumber( "scareditor_DefaultHydraulicActive" )
		tabl.FileName = name
	
		self.LastLoadTable = tabl
		
	
		
		net.Start("SCarSpawnSendFile")
			net.WriteTable( tabl )
		net.SendToServer()	

	
	end
end

function SCarEditor:SaveFile( name )

	if name and name != "" then
		local foundDir = false
		

		foundDir = file.Exists( "scareditorsaves" , "DATA" )

	
		if !foundDir then
			file.CreateDir( "scareditorsaves" )
		end

		local fileExists = false

		fileExists = file.Exists( "scareditorsaves/exported" , "DATA" )

		
		if !fileExists then
			file.CreateDir( "scareditorsaves/exported" )
		end

		local strFile = ""
		local SEP = "¤"
		local torq = 0
		local side = 0	

		strFile = strFile.."CarModel"..SEP..self.CarModel.."\n"
		strFile = strFile.."WheelModel"..SEP..self.WheelModel.."\n"
		strFile = strFile.."EngineSound"..SEP..self.EngineSound.."\n"
		strFile = strFile.."HornSound"..SEP..self.HornSound.."\n"
		strFile = strFile.."EngineEffect"..SEP..self.EngineEffect.."\n"
		strFile = strFile.."NrOfWheels"..SEP..self.NrOfWheels.."\n"
		strFile = strFile.."NrOfSeats"..SEP..self.NrOfSeats.."\n"
		strFile = strFile.."NrOfFLight"..SEP..self.NrOfFLight.."\n"
		strFile = strFile.."NrOfRLight"..SEP..self.NrOfRLight.."\n"
		strFile = strFile.."NrOfExhausts"..SEP..self.NrOfExhausts.."\n"
		strFile = strFile.."CarMass"..SEP..self.CarMass.."\n"
		strFile = strFile.."AnimType"..SEP..self.AnimType.."\n"
		strFile = strFile.."CarCategoryName"..SEP..self.CarCategoryName.."\n"
		strFile = strFile.."WheelSuspensionStiffness"..SEP..self.WheelSuspensionStiffness.."\n"
		strFile = strFile.."AddSpawnHeight"..SEP..self.AddSpawnHeight.."\n"
		strFile = strFile.."ViewDist"..SEP..self.ViewDist.."\n"
		strFile = strFile.."ViewDistUp"..SEP..self.ViewDistUp.."\n"
		strFile = strFile.."EngineSoundID"..SEP..self.EngineSoundID.."\n"
		strFile = strFile.."HornSoundID"..SEP..self.HornSoundID.."\n"
		strFile = strFile.."EngineEffectID"..SEP..self.EngineEffectID.."\n"		
		
		--Wheels
		strFile = strFile.."MaxNrOfWheels"..SEP..self.MaxNrOfWheels.."\n"
		for i = 1, self.MaxNrOfWheels do
			if self.WheelsPos[i] then
				strFile = strFile.."Wheel"..SEP..i..SEP..self.WheelsPos[i].x..SEP..self.WheelsPos[i].y..SEP..self.WheelsPos[i].z..SEP..self.WheelSide[i]..SEP..self.WheelTorq[i]..SEP..self.WheelSteer[i].."\n"
			end
		end

		--Seats
		strFile = strFile.."MaxNrOfSeats"..SEP..self.MaxNrOfSeats.."\n"
		for i = 1, self.MaxNrOfSeats do
			if self.SeatPos[i] then
				strFile = strFile.."Seat"..SEP..i..SEP..self.SeatPos[i].x..SEP..self.SeatPos[i].y..SEP..self.SeatPos[i].z.."\n"
			end
		end
		
		--Front lights
		strFile = strFile.."MaxNrOfFLight"..SEP..self.MaxNrOfFLight.."\n"
		for i = 1, self.MaxNrOfFLight do
			if self.FLightPos[i] then
				strFile = strFile.."FLight"..SEP..i..SEP..self.FLightPos[i].x..SEP..self.FLightPos[i].y..SEP..self.FLightPos[i].z.."\n"
			end
		end	
		
		--Rear lights
		strFile = strFile.."MaxNrOfRLight"..SEP..self.MaxNrOfRLight.."\n"
		for i = 1, self.MaxNrOfRLight do
			if self.RLightPos[i] then
				strFile = strFile.."RLight"..SEP..i..SEP..self.RLightPos[i].x..SEP..self.RLightPos[i].y..SEP..self.RLightPos[i].z.."\n"
			end
		end	
		
		--Exhausts
		strFile = strFile.."MaxNrOfExhausts"..SEP..self.MaxNrOfExhausts.."\n"
		for i = 1, self.MaxNrOfExhausts do
			if self.ExhaustsPos[i] then
				strFile = strFile.."Exhaust"..SEP..i..SEP..self.ExhaustsPos[i].x..SEP..self.ExhaustsPos[i].y..SEP..self.ExhaustsPos[i].z.."\n"
			end
		end		
		
		if !self.EffectPos then self.EffectPos = Vector(0,0,0) end
		strFile = strFile.."EffectPos"..SEP..self.EffectPos.x..SEP..self.EffectPos.y..SEP..self.EffectPos.z.."\n"

		
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultAcceleration"..SEP..GetConVarNumber( "scareditor_DefaultAcceleration" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultMaxSpeed"..SEP..GetConVarNumber( "scareditor_DefaultMaxSpeed" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultTurboEffect"..SEP..GetConVarNumber( "scareditor_DefaultTurboEffect" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultTurboDuration"..SEP..GetConVarNumber( "scareditor_DefaultTurboDuration" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultTurboDelay"..SEP..GetConVarNumber( "scareditor_DefaultTurboDelay" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultReverseForce"..SEP..GetConVarNumber( "scareditor_DefaultReverseForce" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultReverseMaxSpeed"..SEP..GetConVarNumber( "scareditor_DefaultReverseMaxSpeed" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultBreakForce"..SEP..GetConVarNumber( "scareditor_DefaultBreakForce" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultSteerForce"..SEP..GetConVarNumber( "scareditor_DefaultSteerForce" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefautlSteerResponse"..SEP..GetConVarNumber( "scareditor_DefautlSteerResponse" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultStabilisation"..SEP..GetConVarNumber( "scareditor_DefaultStabilisation" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultNrOfGears"..SEP..GetConVarNumber( "scareditor_DefaultNrOfGears" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultAntiSlide"..SEP..GetConVarNumber( "scareditor_DefaultAntiSlide" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultAutoStraighten"..SEP..GetConVarNumber( "scareditor_DefaultAutoStraighten" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DeafultSuspensionAddHeight"..SEP..GetConVarNumber( "scareditor_DeafultSuspensionAddHeight" ).."\n"
		strFile = strFile.."ConVar"..SEP.."scareditor_DefaultHydraulicActive"..SEP..GetConVarNumber( "scareditor_DefaultHydraulicActive" ).."\n"	
		
		file.Write( self.SaveLoadDir..name..".txt", strFile )
	end
end

function SCarEditor:LoadFile( name )
	local SEP = "¤"

	
	local foundDir = false
	foundDir = file.Exists( "scareditorsaves" , "DATA" )


	if !foundDir then
		file.CreateDir( "scareditorsaves" )
	end	
	

	
	foundDir = false
	foundDir = file.Exists( "scareditorsaves/exported" , "DATA" )


	if !foundDir then
		file.CreateDir( "scareditorsaves/Exported" )
	end
	
	
	local doesExist = false
	doesExist = file.Exists( self.SaveLoadDir..name..".txt" , "DATA" )


	
	if doesExist then
	
		self.ModelPanel:Clear()
	
		self.WheelsPos = {}
		self.WheelSide = {}
		self.WheelTorq = {}
		self.WheelSteer = {}
		self.SeatPos = {}
		self.FLightPos = {}
		self.RLightPos = {}
		self.ExhaustsPos = {}
		self.EffectPos = nil	
	
		local inf = {}
		inf = file.Read( self.SaveLoadDir..name..".txt", "DATA" )

		local frac = {}
		inf = string.Explode( string.char(10), inf)

		for k, v in pairs( inf ) do
			frac = string.Explode( SEP, v )
			
			if frac[1] == "Wheel" then
				self.WheelsPos[tonumber(frac[2])] = Vector(frac[3], frac[4], frac[5])
				self.WheelSide[tonumber(frac[2])] = tonumber(frac[6])
				self.WheelTorq[tonumber(frac[2])] = tonumber(frac[7])
				self.WheelSteer[tonumber(frac[2])] = tonumber(frac[8])
			elseif frac[1] == "Seat" then 
				self.SeatPos[tonumber(frac[2])] = Vector(frac[3],frac[4],frac[5])
			elseif frac[1] == "FLight" then 
				self.FLightPos[tonumber(frac[2])] = Vector(frac[3],frac[4],frac[5])
			elseif frac[1] == "RLight" then 
				self.RLightPos[tonumber(frac[2])] = Vector(frac[3],frac[4],frac[5])
			elseif frac[1] == "Exhaust" then 
				self.ExhaustsPos[tonumber(frac[2])] = Vector(frac[3],frac[4],frac[5])
			elseif frac[1] == "EffectPos" then 
				self.EffectPos = Vector(tonumber(frac[2]),tonumber(frac[3]),tonumber(frac[4]))
			elseif frac[1] == "ConVar" then 
				RunConsoleCommand(frac[2], frac[3])
			else
				if frac[1] and frac[1] != "" then
					self[frac[1]] = frac[2]
				end
			end
		end
		
		
		--Apply the new values to various Derma elements
		
		self.ModelPanel:AddModel( self.CarModel, "mdl1" )
		self.ModelPanel:SetModelPos( "mdl1", Vector(0,0,0) )
		--Wheels
		self.wheelListLines = {}
		self.wheelList:Clear()
		for i = 1, self.MaxNrOfWheels do
			if self.WheelsPos[i] then

				self.ModelPanel:AddModel( self.WheelModel, "wheel"..i )
				self.ModelPanel:SetModelPos( "wheel"..i, self.WheelsPos[i] )	
				
				if self.WheelSide[i] == 0 then
					self.ModelPanel:SetModelAng( "wheel"..i, Angle(0,0,0) )
				else
					self.ModelPanel:SetModelAng( "wheel"..i, Angle(0,180,0) )
				end
				
			end
		end
		

		--Seats
		self.seatListLines = {}
		self.seatList:Clear()
		for i = 1, self.MaxNrOfSeats do
			if self.SeatPos[i] then
				self.ModelPanel:AddModel( "models/Nova/airboat_seat.mdl", "seat"..i )
				self.ModelPanel:SetModelAng( "seat"..i, Angle(0,-90,0) )
				self.ModelPanel:SetModelPos( "seat"..i, self.SeatPos[i] )			
			end
		end
		

		--FLight
		self.FLightListLines = {}
		self.FLightList:Clear()
		for i = 1, self.MaxNrOfFLight do
			if self.FLightPos[i] then
				self.ModelPanel:AddModel( "models/props_wasteland/prison_cagedlight001a.mdl", "flight"..i )
				self.ModelPanel:SetModelColour( "flight"..i, 255,255,0,0 )
				self.ModelPanel:SetModelPos(  "flight"..i, self.FLightPos[i] )		
			end
		end
		
		--RLight
		self.RLightListLines = {}
		self.RLightList:Clear()
		for i = 1, self.MaxNrOfRLight do
			if self.RLightPos[i] then
				self.ModelPanel:AddModel( "models/props_wasteland/prison_cagedlight001a.mdl", "rlight"..i )
				self.ModelPanel:SetModelColour( "rlight"..i, 255,0,0,0 )
				self.ModelPanel:SetModelAng( "rlight"..i, Angle(0,180,0) )
				self.ModelPanel:SetModelPos(  "rlight"..i, self.RLightPos[i] )		
			end
		end
		
		--Exhausts
		self.ExhaustsListLines = {}
		self.ExhaustsList:Clear()
		for i = 1, self.MaxNrOfExhausts do
			if self.ExhaustsPos[i] then
				self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "exhaust"..i )
				self.ModelPanel:SetModelAng( "exhaust"..i, Angle(0,180,0) )
				self.ModelPanel:SetModelPos(  "exhaust"..i, self.ExhaustsPos[i] )	
			end
		end
		
		--Effect pos
		if self.EffectPos then
			self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "effect" )
			self.ModelPanel:SetModelPos( "effect", self.EffectPos )
		end

		self.AnimType = tonumber(self.AnimType)
		
		self:FillListsWithContent()
	end
end


function SCarEditor:SaveFileAsLua( name )
	if !name or name == "" then return end
	
	local strFile = ""
	local sChar = string.char(34)
	local tb = string.char(9)
	local SEP = "¤"
	
	local foundDir = false
	foundDir = file.Exists( "scareditorsaves" , "DATA" )

	if !foundDir then
		file.CreateDir( "scareditorsaves" )
	end		
	
	foundDir = false
	foundDir = file.Exists( "scareditorsaves/exported" , "DATA" )


	if !foundDir then
		file.CreateDir( "scareditorsaves/exported" )
	end
	
	
	foundDir = false
	foundDir = file.Exists( "scareditorsaves/exported/sent_sakarias_car_"..name, "DATA" )


	if !foundDir then
		file.CreateDir( "scareditorsaves/exported/sent_sakarias_car_"..name )
	end	
	
	strFile = "include("..sChar.."shared.lua"..sChar..")"
	file.Write( "scareditorsaves/Exported/sent_sakarias_car_"..name.."/cl_init.txt", strFile )
	
	strFile = "AddCSLuaFile("..sChar.."cl_init.lua"..sChar..")\n"
	strFile = strFile.."AddCSLuaFile("..sChar.."shared.lua"..sChar..")\n"
	strFile = strFile.."include("..sChar.."shared.lua"..sChar..")"
	file.Write( "scareditorsaves/exported/sent_sakarias_car_"..name.."/init.txt", strFile )
	
	
	
	strFile = "ENT.Base = "..sChar.."sent_sakarias_scar_base"..sChar.."\n"
	strFile = strFile.."ENT.Type = "..sChar.."anim"..sChar.."\n\n"
	
	strFile = strFile.."ENT.PrintName = "..sChar..name..sChar.."\n"
	strFile = strFile.."ENT.Author = "..sChar.."EDITOR"..sChar.."\n"
	strFile = strFile.."ENT.Category = "..sChar..self.CarCategoryName..sChar.."\n"
	strFile = strFile.."ENT.Information = "..sChar..sChar.."\n"
	strFile = strFile.."ENT.AdminOnly = false\n"
	strFile = strFile.."ENT.Spawnable = false\n"
	strFile = strFile.."ENT.AdminSpawnable = false\n\n"
	

	strFile = strFile.."ENT.AddSpawnHeight = "..self.AddSpawnHeight.."\n"
	strFile = strFile.."ENT.ViewDist = "..self.ViewDist.."\n"
	strFile = strFile.."ENT.ViewDistUp = "..self.ViewDistUp.."\n\n"

	strFile = strFile.."ENT.NrOfSeats = "..self.NrOfSeats.."\n"
	strFile = strFile.."ENT.NrOfWheels = "..self.NrOfWheels.."\n"
	strFile = strFile.."ENT.NrOfExhausts = "..self.NrOfExhausts.."\n"
	strFile = strFile.."ENT.NrOfFrontLights = "..self.NrOfFLight.."\n"
	strFile = strFile.."ENT.NrOfRearLights = "..self.NrOfRLight.."\n\n"
	
	strFile = strFile.."ENT.SeatPos = {}\n"
	strFile = strFile.."ENT.WheelInfo = {}\n"
	strFile = strFile.."ENT.ExhaustPos = {}\n"
	strFile = strFile.."ENT.FrontLightsPos = {}\n"
	strFile = strFile.."ENT.RearLightsPos = {}\n\n"

	strFile = strFile.."ENT.effectPos = NULL\n\n"

	strFile = strFile.."ENT.DefaultSoftnesFront ="..self.WheelSuspensionStiffness.."\n"
	strFile = strFile.."ENT.DefaultSoftnesRear ="..self.WheelSuspensionStiffness.."\n\n"

	strFile = strFile.."ENT.CarMass ="..self.CarMass.."\n"
	strFile = strFile.."ENT.StabiliserOffset = NULL\n"
	strFile = strFile.."ENT.StabilisationMultiplier = 70\n\n"

	strFile = strFile.."ENT.DefaultSound = "..sChar..self.EngineSound..sChar.."\n"
	strFile = strFile.."ENT.EngineEffectName = "..sChar..self.EngineEffect..sChar.."\n"
	strFile = strFile.."ENT.HornSound = "..sChar..self.HornSound..sChar.."\n\n"
	
	strFile = strFile.."ENT.CarModel = "..sChar..self.CarModel..sChar.."\n"
	strFile = strFile.."ENT.TireModel = "..sChar..self.WheelModel..sChar.."\n"
	strFile = strFile.."ENT.AnimType = "..self.AnimType.."\n\n"

	strFile = strFile.."ENT.FrontLightColor = "..sChar.."220 220 160"..sChar.."\n"

	strFile = strFile.."------------------------------------VARIABLES END\n\n"
	
	strFile = strFile.."for i = 1, ENT.NrOfWheels do\n"
	strFile = strFile..tb.."ENT.WheelInfo[i] = {}\n"
	strFile = strFile.."end\n\n"
	
	strFile = strFile.."local xPos = 0\n"
	strFile = strFile.."local yPos = 0\n"
	strFile = strFile.."local zPos = 0\n\n"

	strFile = strFile.."//SEAT POSITIONS\n"
	local cnt = 0
	for i = 1, self.MaxNrOfSeats do
		if self.SeatPos[i] then
			cnt = cnt + 1
			strFile = strFile.."--Seat Position "..cnt.."\n"
			strFile = strFile.."xPos = "..self.SeatPos[i].x.."\n"
			strFile = strFile.."yPos = "..(-self.SeatPos[i].y).."\n"
			strFile = strFile.."zPos = "..self.SeatPos[i].z.."\n"
			strFile = strFile.."ENT.SeatPos["..cnt.."] = Vector(xPos, yPos, zPos)\n\n"
		end
	end	

	
	strFile = strFile.."//WHEEL POSITIONS\n"
	cnt = 0
	for i = 1, self.MaxNrOfWheels do
		if self.WheelsPos[i] then
			cnt = cnt + 1
			strFile = strFile.."--Wheel Position "..cnt.."\n"
			strFile = strFile.."xPos = "..self.WheelsPos[i].x.."\n"
			strFile = strFile.."yPos = "..(-self.WheelsPos[i].y).."\n"
			strFile = strFile.."zPos = "..self.WheelsPos[i].z.."\n"		
			strFile = strFile.."ENT.WheelInfo["..cnt.."].Pos = Vector(xPos, yPos, zPos)\n"
			
			if self.WheelSide[i] == 1 then
				strFile = strFile.."ENT.WheelInfo["..cnt.."].Side = false\n"
			else
				strFile = strFile.."ENT.WheelInfo["..cnt.."].Side = true\n"
			end

			if self.WheelTorq[i] == 1 then
				strFile = strFile.."ENT.WheelInfo["..cnt.."].Torq = true\n"
			else
				strFile = strFile.."ENT.WheelInfo["..cnt.."].Torq = false\n"
			end
			
			strFile = strFile.."ENT.WheelInfo["..cnt.."].Steer = "..self.WheelSteer[i].."\n\n"
		end
	end

	
	strFile = strFile.."//FRONT LIGHT POSITIONS\n"
	cnt = 0
	for i = 1, self.MaxNrOfFLight do
		if self.FLightPos[i] then
			cnt = cnt + 1
			strFile = strFile.."--Front light "..cnt.."\n"
			strFile = strFile.."xPos = "..self.FLightPos[i].x.."\n"
			strFile = strFile.."yPos = "..(-self.FLightPos[i].y).."\n"
			strFile = strFile.."zPos = "..self.FLightPos[i].z.."\n"		
			strFile = strFile.."ENT.FrontLightsPos["..cnt.."] = Vector(xPos, yPos, zPos)\n\n"			
		end
	end
	
	strFile = strFile.."//REAR LIGHT POSITIONS\n"
	cnt = 0
	for i = 1, self.MaxNrOfRLight do
		if self.RLightPos[i] then
			cnt = cnt + 1
			strFile = strFile.."--Rear light "..cnt.."\n"
			strFile = strFile.."xPos = "..self.RLightPos[i].x.."\n"
			strFile = strFile.."yPos = "..(-self.RLightPos[i].y).."\n"
			strFile = strFile.."zPos = "..self.RLightPos[i].z.."\n"		
			strFile = strFile.."ENT.RearLightsPos["..cnt.."] = Vector(xPos, yPos, zPos)\n\n"			
		end
	end
	
	strFile = strFile.."//EXHAUST POSITIONS\n"
	cnt = 0	
	for i = 1, self.MaxNrOfExhausts do
		if self.ExhaustsPos[i] then
			cnt = cnt + 1
			strFile = strFile.."--Exhaust "..cnt.."\n"
			strFile = strFile.."xPos = "..self.ExhaustsPos[i].x.."\n"
			strFile = strFile.."yPos = "..(-self.ExhaustsPos[i].y).."\n"
			strFile = strFile.."zPos = "..self.ExhaustsPos[i].z.."\n"		
			strFile = strFile.."ENT.ExhaustPos["..cnt.."] = Vector(xPos, yPos, zPos)\n\n"				
		end
	end	
	
	if !self.EffectPos then self.EffectPos = Vector(0,0,0) end
	strFile = strFile.."//EFFECT POSITION\n"
	strFile = strFile.."xPos = "..self.EffectPos.x.."\n"
	strFile = strFile.."yPos = "..(-self.EffectPos.y).."\n"
	strFile = strFile.."zPos = "..self.EffectPos.z.."\n"		
	strFile = strFile.."ENT.effectPos = Vector(xPos, yPos, zPos)\n\n"		
	
	
	strFile = strFile.."//CAR CHARACTERISTICS\n"
	strFile = strFile.."ENT.DefaultAcceleration = "..GetConVarNumber( "scareditor_DefaultAcceleration" ).."\n"
	strFile = strFile.."ENT.DefaultMaxSpeed = "..GetConVarNumber( "scareditor_DefaultMaxSpeed" ).."\n"
	strFile = strFile.."ENT.DefaultTurboEffect = "..GetConVarNumber( "scareditor_DefaultTurboEffect" ).."\n"
	strFile = strFile.."ENT.DefaultTurboDuration = "..GetConVarNumber( "scareditor_DefaultTurboDuration" ).."\n"
	strFile = strFile.."ENT.DefaultTurboDelay = "..GetConVarNumber( "scareditor_DefaultTurboDelay" ).."\n"
	strFile = strFile.."ENT.DefaultReverseForce = "..GetConVarNumber( "scareditor_DefaultReverseForce" ).."\n"
	strFile = strFile.."ENT.DefaultReverseMaxSpeed = "..GetConVarNumber( "scareditor_DefaultReverseMaxSpeed" ).."\n"
	strFile = strFile.."ENT.DefaultBreakForce = "..GetConVarNumber( "scareditor_DefaultBreakForce" ).."\n"
	strFile = strFile.."ENT.DefaultSteerForce = "..GetConVarNumber( "scareditor_DefaultSteerForce" ).."\n"
	strFile = strFile.."ENT.DefautlSteerResponse = "..GetConVarNumber( "scareditor_DefautlSteerResponse" ).."\n"
	strFile = strFile.."ENT.DefaultStabilisation = "..GetConVarNumber( "scareditor_DefaultStabilisation" ).."\n"
	strFile = strFile.."ENT.DefaultNrOfGears = "..GetConVarNumber( "scareditor_DefaultNrOfGears" ).."\n"
	strFile = strFile.."ENT.DefaultAntiSlide = "..GetConVarNumber( "scareditor_DefaultAntiSlide" ).."\n"
	strFile = strFile.."ENT.DefaultAutoStraighten = "..GetConVarNumber( "scareditor_DefaultAutoStraighten" ).."\n"
	strFile = strFile.."ENT.DeafultSuspensionAddHeight = "..GetConVarNumber( "scareditor_DeafultSuspensionAddHeight" ).."\n"
	strFile = strFile.."ENT.DefaultHydraulicActive = "..GetConVarNumber( "scareditor_DefaultHydraulicActive" ).."\n\n"	
	
	strFile = strFile.."list.Set( "..string.char(34).."SCarsList"..string.char(34)..", ENT.PrintName, ENT )\n\n"	

	strFile = strFile..[[function ENT:Initialize()
		
	self:Setup()

	if (SERVER) then
		--Setting up the car characteristics
		self:SetAcceleration( self.DefaultAcceleration )
		self:SetMaxSpeed( self.DefaultMaxSpeed )
		
		self:SetTurboEffect( self.DefaultTurboEffect )
		self:SetTurboDuration( self.DefaultTurboDuration )
		self:SetTurboDelay( self.DefaultTurboDelay )
		
		self:SetReverseForce( self.DefaultReverseForce )
		self:SetReverseMaxSpeed( self.DefaultReverseMaxSpeed )
		self:SetBreakForce( self.DefaultBreakForce )
		
		self:SetSteerForce( self.DefaultSteerForce )
		self:SetSteerResponse( self.DefautlSteerResponse )
		
		self:SetStabilisation( self.DefaultStabilisation )
		self:SetNrOfGears( self.DefaultNrOfGears )
		self:SetAntiSlide( self.DefaultAntiSlide )
		self:SetAutoStraighten( self.DefaultAutoStraighten )	
		
		self:SetSuspensionAddHeight( self.DeafultSuspensionAddHeight )
		self:SetHydraulicActive( self.DefaultHydraulicActive )
	end
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end]]

	file.Write( "SCarEditorSaves/Exported/sent_sakarias_car_"..name.."/shared.txt", strFile )
end

function SCarEditor:ModelsAndMiscMenu()
	
	
	--------------------------MODELS AND MISC
	local collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Models and misc" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )
	self.OptionsList:AddItem(collapsCat)
	
	local CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding(5)
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )
	
	 
	 
	 
	 
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Car Model") 
	CategoryList:AddItem( textLabel )

	self.CarModelTextField = vgui.Create( "DTextEntry", DermaPanel )
	self.CarModelTextField:SetWide( 190 )
	self.CarModelTextField:SetEnterAllowed( true )
	self.CarModelTextField:SetValue( self.CarModel )
	self.CarModelTextField.OnEnter = function()
		self.ModelPanel:AddModel( self.CarModelTextField:GetValue(), "mdl1" )
		self.ModelPanel:SetModelPos( "mdl1", Vector(0,0,0) )
		SCarEditor.CarModel = self.CarModelTextField:GetValue()
	end	 
	CategoryList:AddItem( self.CarModelTextField )
	 
	 
	textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Wheel Model") 
	CategoryList:AddItem( textLabel )
	 
	self.WheelModelTextField = vgui.Create( "DTextEntry", DermaPanel )
	self.WheelModelTextField:SetWide( 190 )
	self.WheelModelTextField:SetEnterAllowed( true )
	self.WheelModelTextField:SetValue( self.WheelModel )
	self.WheelModelTextField.OnEnter = function()
		SCarEditor.WheelModel = self.WheelModelTextField:GetValue()
		
		
		for i = 1, self.MaxNrOfWheels do
			if self.WheelsPos[i] then
				self.ModelPanel:SetModel( "wheel"..i, SCarEditor.WheelModel )
			end	
		end			
	end	 
	CategoryList:AddItem( self.WheelModelTextField )	 
	
	textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("") 
	CategoryList:AddItem( textLabel )	
	
	textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Car Category") 
	CategoryList:AddItem( textLabel )
	
	self.CarCategory = vgui.Create( "DTextEntry", DermaPanel )
	self.CarCategory:SetWide( 190 )
	self.CarCategory:SetEnterAllowed( true )
	self.CarCategory:SetValue( self.CarCategoryName )
	self.CarCategory.OnEnter = function()
		SCarEditor.CarCategoryName = self.CarCategory:GetValue()
	end	 
	CategoryList:AddItem( self.CarCategory )	 	
	
	
	textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Animation Type") 
	CategoryList:AddItem( textLabel )
	
	self.AnimTypeList = vgui.Create( "DComboBox", CategoryList)

	
	self.AnimTypeList.OnSelect = function( panel, value, data)
		SCarEditor.AnimType = tonumber(value)
	end	
	self.AnimTypeList:AddChoice("Car drive animation")	
	self.AnimTypeList:AddChoice("Airboat drive animation")	
	CategoryList:AddItem( self.AnimTypeList )		
	
	textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("") 
	CategoryList:AddItem( textLabel )		
	
	self.CarMassSlider = vgui.Create( "DNumSlider", CategoryList )
	self.CarMassSlider:SetWide( 295 )
	self.CarMassSlider:SetText( "Car mass" )
	self.CarMassSlider:SetMin( 100 )
	self.CarMassSlider:SetMax( 2000 )
	self.CarMassSlider:SetDecimals( 1 )
	self.CarMassSlider:SetConVar( "scareditor_carmass" )
	self.CarMassSlider.OnValueChanged = function( panel, value )
		SCarEditor:SetCarMass(value)
	end  	
	CategoryList:AddItem( self.CarMassSlider )	

	
	self.AddSpawnHeightSlider = vgui.Create( "DNumSlider", CategoryList )
	self.AddSpawnHeightSlider:SetWide( 295 )
	self.AddSpawnHeightSlider:SetText( "Add spawn height" )
	self.AddSpawnHeightSlider:SetMin( -100 )
	self.AddSpawnHeightSlider:SetMax( 100 )
	self.AddSpawnHeightSlider:SetDecimals( 0 )
	self.AddSpawnHeightSlider:SetConVar( "scareditor_AddSpawnHeight" )
	self.AddSpawnHeightSlider.OnValueChanged = function( panel, value )
		SCarEditor.AddSpawnHeight = value 
	end  	
	CategoryList:AddItem( self.AddSpawnHeightSlider )		

	
	self.ViewDistSlider = vgui.Create( "DNumSlider", CategoryList )
	self.ViewDistSlider:SetWide( 295 )
	self.ViewDistSlider:SetText( "Camera view distance" )
	self.ViewDistSlider:SetMin( 100 )
	self.ViewDistSlider:SetMax( 500 )
	self.ViewDistSlider:SetDecimals( 0 )
	self.ViewDistSlider:SetConVar( "scareditor_ViewDist" )
	self.ViewDistSlider.OnValueChanged = function( panel, value )
		SCarEditor.ViewDist = value 
	end  	
	CategoryList:AddItem( self.ViewDistSlider )		

	self.ViewDistUpSlider = vgui.Create( "DNumSlider", CategoryList )
	self.ViewDistUpSlider:SetWide( 295 )
	self.ViewDistUpSlider:SetText( "Camera Z offset" )
	self.ViewDistUpSlider:SetMin( -100 )
	self.ViewDistUpSlider:SetMax( 100 )
	self.ViewDistUpSlider:SetDecimals( 0 )
	self.ViewDistUpSlider:SetConVar( "scareditor_ViewDistUp" )
	self.ViewDistUpSlider.OnValueChanged = function( panel, value )
		SCarEditor.ViewDistUp = value 
	end  	
	CategoryList:AddItem( self.ViewDistUpSlider )	


	collapsCat:SetContents( CategoryList )	
end

function SCarEditor:WheelMenu()
	--------------------------WHEEL ADJUSTMENTS
	local collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Wheels" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	local CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )		
	
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Add wheel" )
	button.DoClick = function( button )
		SCarEditor:AddWheel()
	end
	CategoryList:AddItem( button )
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Remove wheel" )
	button.DoClick = function( button )
		SCarEditor:RemoveWheel()
	end	
	CategoryList:AddItem( button )	
	

	self.XSliderWheel = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderWheel:SetWide( 295 )
	self.XSliderWheel:SetText( "X" )
	self.XSliderWheel:SetMin( -200 )
	self.XSliderWheel:SetMax( 200 )
	self.XSliderWheel:SetDecimals( 1 )
	self.XSliderWheel:SetConVar( "scareditor_x_wheel" )
	self.XSliderWheel.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_wheel = value
			SCarEditor:ChangeWheelPos(SCarEditor.Xpos_wheel, SCarEditor.Ypos_wheel, SCarEditor.Zpos_wheel)
		end
	end  	
	CategoryList:AddItem( self.XSliderWheel )
	
	
	self.YSliderWheel = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderWheel:SetWide( 295 )
	self.YSliderWheel:SetText( "Y" )
	self.YSliderWheel:SetMin( -200 )
	self.YSliderWheel:SetMax( 200 )
	self.YSliderWheel:SetDecimals( 1 )
	self.YSliderWheel:SetConVar( "scareditor_y_wheel" )
	self.YSliderWheel.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_wheel = value
			SCarEditor:ChangeWheelPos(SCarEditor.Xpos_wheel, SCarEditor.Ypos_wheel, SCarEditor.Zpos_wheel)
		end
	end  	
	CategoryList:AddItem( self.YSliderWheel )	
	
	
	self.ZSliderWheel = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderWheel:SetWide( 295 )
	self.ZSliderWheel:SetText( "Z" )
	self.ZSliderWheel:SetMin( -200 )
	self.ZSliderWheel:SetMax( 200 )
	self.ZSliderWheel:SetDecimals( 1 )
	self.ZSliderWheel:SetConVar( "scareditor_z_wheel" )
	self.ZSliderWheel.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_wheel = value
			SCarEditor:ChangeWheelPos(SCarEditor.Xpos_wheel, SCarEditor.Ypos_wheel, SCarEditor.Zpos_wheel)
		end
	end  	
	CategoryList:AddItem( self.ZSliderWheel )	
	

	self.TorqCheckBox = vgui.Create( "DCheckBoxLabel" )
	self.TorqCheckBox:SetText( "Torq" )  
	self.TorqCheckBox:SetConVar( "scareditor_torq" )
	self.TorqCheckBox.OnChange = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor:ChangeWheelTorq(value)
			
		end
	end 

	CategoryList:AddItem( self.TorqCheckBox )
	
	self.SideCheckBox = vgui.Create( "DCheckBoxLabel" )
	self.SideCheckBox:SetText( "Side" )  
	self.SideCheckBox:SetConVar( "scareditor_side" )
	self.SideCheckBox.OnChange = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor:ChangeWheelSide(value)
			
		end
	end 	
	self.SideCheckBox:SetSize(20,20)
	CategoryList:AddItem( self.SideCheckBox )
	
	
	

	
	self.SteerSlider = vgui.Create( "DNumSlider", CategoryList )
	self.SteerSlider:SetWide( 295 )
	self.SteerSlider:SetText( "Steer" )
	self.SteerSlider:SetMin( -1 )
	self.SteerSlider:SetMax( 1 )
	self.SteerSlider:SetDecimals( 0 )
	self.SteerSlider:SetConVar( "scareditor_steer" )
	self.SteerSlider.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor:ChangeWheelSteer(GetConVarNumber( "scareditor_steer" ))
		end
	end  	
	CategoryList:AddItem( self.SteerSlider )	
	
	
	self.wheelList = vgui.Create("DListView", CategoryList)
	self.wheelList:SetPos(25, 50)
	self.wheelList:SetMultiSelect(false)
	self.wheelList:AddColumn("Current Wheel")
	self.wheelList:SetSize(295, 80)
	CategoryList:AddItem( self.wheelList )	

	
	collapsCat:SetContents( CategoryList )	
end

function SCarEditor:SeatMenu()
	-------------------------------------SEAT
	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Seats" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	
	
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Add seat" )
	button.DoClick = function( button )
		SCarEditor:AddSeat()
	end
	CategoryList:AddItem( button )
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Remove seat" )
	button.DoClick = function( button )
		SCarEditor:RemoveSeat()
	end	
	CategoryList:AddItem( button )	
	

	self.XSliderSeat = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderSeat:SetWide( 295 )
	self.XSliderSeat:SetText( "X" )
	self.XSliderSeat:SetMin( -200 )
	self.XSliderSeat:SetMax( 200 )
	self.XSliderSeat:SetDecimals( 1 )
	self.XSliderSeat:SetConVar( "scareditor_x_seat" )
	self.XSliderSeat.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_seat = value
			SCarEditor:ChangeSeatPos(SCarEditor.Xpos_seat, SCarEditor.Ypos_seat, SCarEditor.Zpos_seat)
		end
	end  	
	CategoryList:AddItem( self.XSliderSeat )
	
	
	self.YSliderSeat = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderSeat:SetWide( 295 )
	self.YSliderSeat:SetText( "Y" )
	self.YSliderSeat:SetMin( -200 )
	self.YSliderSeat:SetMax( 200 )
	self.YSliderSeat:SetDecimals( 1 )
	self.YSliderSeat:SetConVar( "scareditor_y_seat" )
	self.YSliderSeat.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_seat = value
			SCarEditor:ChangeSeatPos(SCarEditor.Xpos_seat, SCarEditor.Ypos_seat, SCarEditor.Zpos_seat)
		end
	end  	
	CategoryList:AddItem( self.YSliderSeat )	
	
	
	self.ZSliderSeat = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderSeat:SetWide( 295 )
	self.ZSliderSeat:SetText( "Z" )
	self.ZSliderSeat:SetMin( -200 )
	self.ZSliderSeat:SetMax( 200 )
	self.ZSliderSeat:SetDecimals( 1 )
	self.ZSliderSeat:SetConVar( "scareditor_z_seat" )
	self.ZSliderSeat.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_seat = value
			SCarEditor:ChangeSeatPos(SCarEditor.Xpos_seat, SCarEditor.Ypos_seat, SCarEditor.Zpos_seat)
		end
	end  	
	CategoryList:AddItem( self.ZSliderSeat )

	
	self.seatList = vgui.Create("DListView", CategoryList)
	self.seatList:SetPos(25, 50)
	self.seatList:SetMultiSelect(false)
	self.seatList:AddColumn("Current Seat")
	self.seatList:SetSize(295, 80)
	CategoryList:AddItem( self.seatList )		
	
	collapsCat:SetContents( CategoryList )	
end

function SCarEditor:WheelMenu()
	--------------------------WHEEL ADJUSTMENTS
	local collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Wheels" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	local CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )		
	
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Add wheel" )
	button.DoClick = function( button )
		SCarEditor:AddWheel()
	end
	CategoryList:AddItem( button )
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Remove wheel" )
	button.DoClick = function( button )
		SCarEditor:RemoveWheel()
	end	
	CategoryList:AddItem( button )	
	

	self.XSliderWheel = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderWheel:SetWide( 295 )
	self.XSliderWheel:SetText( "X" )
	self.XSliderWheel:SetMin( -200 )
	self.XSliderWheel:SetMax( 200 )
	self.XSliderWheel:SetDecimals( 1 )
	self.XSliderWheel:SetConVar( "scareditor_x_wheel" )
	self.XSliderWheel.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_wheel = value
			SCarEditor:ChangeWheelPos(SCarEditor.Xpos_wheel, SCarEditor.Ypos_wheel, SCarEditor.Zpos_wheel)
		end
	end  	
	CategoryList:AddItem( self.XSliderWheel )
	
	
	self.YSliderWheel = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderWheel:SetWide( 295 )
	self.YSliderWheel:SetText( "Y" )
	self.YSliderWheel:SetMin( -200 )
	self.YSliderWheel:SetMax( 200 )
	self.YSliderWheel:SetDecimals( 1 )
	self.YSliderWheel:SetConVar( "scareditor_y_wheel" )
	self.YSliderWheel.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_wheel = value
			SCarEditor:ChangeWheelPos(SCarEditor.Xpos_wheel, SCarEditor.Ypos_wheel, SCarEditor.Zpos_wheel)
		end
	end  	
	CategoryList:AddItem( self.YSliderWheel )	
	
	
	self.ZSliderWheel = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderWheel:SetWide( 295 )
	self.ZSliderWheel:SetText( "Z" )
	self.ZSliderWheel:SetMin( -200 )
	self.ZSliderWheel:SetMax( 200 )
	self.ZSliderWheel:SetDecimals( 1 )
	self.ZSliderWheel:SetConVar( "scareditor_z_wheel" )
	self.ZSliderWheel.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_wheel = value
			SCarEditor:ChangeWheelPos(SCarEditor.Xpos_wheel, SCarEditor.Ypos_wheel, SCarEditor.Zpos_wheel)
		end
	end  	
	CategoryList:AddItem( self.ZSliderWheel )	
	

	self.TorqCheckBox = vgui.Create( "DCheckBoxLabel" )
	self.TorqCheckBox:SetText( "Torq" )  
	self.TorqCheckBox:SetConVar( "scareditor_torq" )
	self.TorqCheckBox.OnChange = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor:ChangeWheelTorq(value)
		end
	end 

	CategoryList:AddItem( self.TorqCheckBox )
	
	self.SideCheckBox = vgui.Create( "DCheckBoxLabel" )
	self.SideCheckBox:SetText( "Side" )  
	self.SideCheckBox:SetConVar( "scareditor_side" )
	self.SideCheckBox.OnChange = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor:ChangeWheelSide(value)
		end
	end 	
	self.SideCheckBox:SetSize(20,20)
	CategoryList:AddItem( self.SideCheckBox )
	
	
	

	
	self.SteerSlider = vgui.Create( "DNumSlider", CategoryList )
	self.SteerSlider:SetWide( 295 )
	self.SteerSlider:SetText( "Steer" )
	self.SteerSlider:SetMin( -1 )
	self.SteerSlider:SetMax( 1 )
	self.SteerSlider:SetDecimals( 0 )
	self.SteerSlider:SetConVar( "scareditor_steer" )
	self.SteerSlider.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor:ChangeWheelSteer(GetConVarNumber( "scareditor_steer" ))
		end
	end  	
	CategoryList:AddItem( self.SteerSlider )	
	
	
	self.wheelList = vgui.Create("DListView", CategoryList)
	self.wheelList:SetPos(25, 50)
	self.wheelList:SetMultiSelect(false)
	self.wheelList:AddColumn("Current Wheel")
	self.wheelList:SetSize(295, 80)
	CategoryList:AddItem( self.wheelList )	
	
	collapsCat:SetContents( CategoryList )	
end

function SCarEditor:HydraylicsAndSuspensionMenu()

	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Suspension and Hydraulics" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	
	
	self.WheelSuspensionSlider = vgui.Create( "DNumSlider", CategoryList )
	self.WheelSuspensionSlider:SetWide( 295 )
	self.WheelSuspensionSlider:SetText( "Suspension Stiffness" )
	self.WheelSuspensionSlider:SetMin( 5 )
	self.WheelSuspensionSlider:SetMax( 50 )
	self.WheelSuspensionSlider:SetDecimals( 0 )
	self.WheelSuspensionSlider:SetConVar( "scareditor_suspensionStiffness" )
	self.WheelSuspensionSlider.OnValueChanged = function( panel, value )
		SCarEditor.WheelSuspensionStiffness = GetConVarNumber( "scareditor_suspensionStiffness" )
	end  	
	CategoryList:AddItem( self.WheelSuspensionSlider )			
	
	
	self.HydraulicsSlider = vgui.Create( "DNumSlider", CategoryList )
	self.HydraulicsSlider:SetWide( 295 )
	self.HydraulicsSlider:SetText( "Hydraulics height" )
	self.HydraulicsSlider:SetMin( 5 )
	self.HydraulicsSlider:SetMax( 30 )
	self.HydraulicsSlider:SetDecimals( 1 )
	self.HydraulicsSlider:SetConVar( "scareditor_DeafultSuspensionAddHeight" )	
	self.HydraulicsSlider.OnValueChanged = function( panel, value )
		SCarEditor.HydraulicsSliderValue = GetConVarNumber( "scareditor_DeafultSuspensionAddHeight" )
	end  	
	
	CategoryList:AddItem( self.HydraulicsSlider )		
	
	local cBox = vgui.Create( "DCheckBoxLabel" )
	cBox:SetText( "Hydraulics active" )  
	cBox:SetConVar( "scareditor_DefaultHydraulicActive" )	
	CategoryList:AddItem( cBox )	
	
	collapsCat:SetContents( CategoryList )	
end

-------------------------------------FLight
function SCarEditor:FLightMenu()

	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Front lights" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	

	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Add front light" )
	button.DoClick = function( button )
		SCarEditor:AddFLight()
	end
	CategoryList:AddItem( button )
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Remove front light" )
	button.DoClick = function( button )
		SCarEditor:RemoveFLight()
	end	
	CategoryList:AddItem( button )	
	

	self.XSliderFLight = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderFLight:SetWide( 295 )
	self.XSliderFLight:SetText( "X" )
	self.XSliderFLight:SetMin( -200 )
	self.XSliderFLight:SetMax( 200 )
	self.XSliderFLight:SetDecimals( 1 )
	self.XSliderFLight:SetConVar( "scareditor_x_fl" )
	self.XSliderFLight.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_fl = value
			SCarEditor:ChangeFLightPos(SCarEditor.Xpos_fl, SCarEditor.Ypos_fl, SCarEditor.Zpos_fl)
		end
	end  	
	CategoryList:AddItem( self.XSliderFLight )
	
	
	self.YSliderFLight = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderFLight:SetWide( 295 )
	self.YSliderFLight:SetText( "Y" )
	self.YSliderFLight:SetMin( -200 )
	self.YSliderFLight:SetMax( 200 )
	self.YSliderFLight:SetDecimals( 1 )
	self.YSliderFLight:SetConVar( "scareditor_y_fl" )
	self.YSliderFLight.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_fl = value
			SCarEditor:ChangeFLightPos(SCarEditor.Xpos_fl, SCarEditor.Ypos_fl, SCarEditor.Zpos_fl)
		end
	end  	
	CategoryList:AddItem( self.YSliderFLight )	
	
	
	self.ZSliderFLight = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderFLight:SetWide( 295 )
	self.ZSliderFLight:SetText( "Z" )
	self.ZSliderFLight:SetMin( -200 )
	self.ZSliderFLight:SetMax( 200 )
	self.ZSliderFLight:SetDecimals( 1 )
	self.ZSliderFLight:SetConVar( "scareditor_z_fl" )
	self.ZSliderFLight.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_fl = value
			SCarEditor:ChangeFLightPos(SCarEditor.Xpos_fl, SCarEditor.Ypos_fl, SCarEditor.Zpos_fl)
		end
	end  	
	CategoryList:AddItem( self.ZSliderFLight )

	
	self.FLightList = vgui.Create("DListView", CategoryList)
	self.FLightList:SetPos(25, 50)
	self.FLightList:SetMultiSelect(false)
	self.FLightList:AddColumn("Current front light")
	self.FLightList:SetSize(295, 80)
	CategoryList:AddItem( self.FLightList )		
	
	collapsCat:SetContents( CategoryList )	
end


-------------------------------------RLight
function SCarEditor:RLightMenu()

	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Rear lights" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	

	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Add rear light" )
	button.DoClick = function( button )
		SCarEditor:AddRLight()
	end
	CategoryList:AddItem( button )
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Remove rear light" )
	button.DoClick = function( button )
		SCarEditor:RemoveRLight()
	end	
	CategoryList:AddItem( button )	
	

	self.XSliderRLight = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderRLight:SetWide( 295 )
	self.XSliderRLight:SetText( "X" )
	self.XSliderRLight:SetMin( -200 )
	self.XSliderRLight:SetMax( 200 )
	self.XSliderRLight:SetDecimals( 1 )
	self.XSliderRLight:SetConVar( "scareditor_x_rl" )
	self.XSliderRLight.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_rl = value
			SCarEditor:ChangeRLightPos(SCarEditor.Xpos_rl, SCarEditor.Ypos_rl, SCarEditor.Zpos_rl)
		end
	end  	
	CategoryList:AddItem( self.XSliderRLight )
	
	
	self.YSliderRLight = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderRLight:SetWide( 295 )
	self.YSliderRLight:SetText( "Y" )
	self.YSliderRLight:SetMin( -200 )
	self.YSliderRLight:SetMax( 200 )
	self.YSliderRLight:SetDecimals( 1 )
	self.YSliderRLight:SetConVar( "scareditor_y_rl" )
	self.YSliderRLight.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_rl = value
			SCarEditor:ChangeRLightPos(SCarEditor.Xpos_rl, SCarEditor.Ypos_rl, SCarEditor.Zpos_rl)
		end
	end  	
	CategoryList:AddItem( self.YSliderRLight )	
	
	
	self.ZSliderRLight = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderRLight:SetWide( 295 )
	self.ZSliderRLight:SetText( "Z" )
	self.ZSliderRLight:SetMin( -200 )
	self.ZSliderRLight:SetMax( 200 )
	self.ZSliderRLight:SetDecimals( 1 )
	self.ZSliderRLight:SetConVar( "scareditor_z_rl" )
	self.ZSliderRLight.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_rl = value
			SCarEditor:ChangeRLightPos(SCarEditor.Xpos_rl, SCarEditor.Ypos_rl, SCarEditor.Zpos_rl)
		end
	end  	
	CategoryList:AddItem( self.ZSliderRLight )

	
	self.RLightList = vgui.Create("DListView", CategoryList)
	self.RLightList:SetPos(25, 50)
	self.RLightList:SetMultiSelect(false)
	self.RLightList:AddColumn("Current rear light")
	self.RLightList:SetSize(295, 80)
	CategoryList:AddItem( self.RLightList )		
	
	collapsCat:SetContents( CategoryList )	
end


-------------------------------------Exhaust
function SCarEditor:ExhaustMenu()


	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Exhaust positions" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	

	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Add exhaust" )
	button.DoClick = function( button )
		SCarEditor:AddExhausts()
	end
	CategoryList:AddItem( button )
	
	local button = vgui.Create( "DButton" )
	button:SetSize( 295, 30 )
	button:SetText( "Remove exhaust" )
	button.DoClick = function( button )
		SCarEditor:RemoveExhausts()
	end	
	CategoryList:AddItem( button )	
	

	self.XSliderExhausts = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderExhausts:SetWide( 295 )
	self.XSliderExhausts:SetText( "X" )
	self.XSliderExhausts:SetMin( -200 )
	self.XSliderExhausts:SetMax( 200 )
	self.XSliderExhausts:SetDecimals( 1 )
	self.XSliderExhausts:SetConVar( "scareditor_x_exhaust" )
	self.XSliderExhausts.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_exhaust = value
			SCarEditor:ChangeExhauststPos(SCarEditor.Xpos_exhaust, SCarEditor.Ypos_exhaust, SCarEditor.Zpos_exhaust)
		end
	end  	
	CategoryList:AddItem( self.XSliderExhausts )
	
	
	self.YSliderExhausts = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderExhausts:SetWide( 295 )
	self.YSliderExhausts:SetText( "Y" )
	self.YSliderExhausts:SetMin( -200 )
	self.YSliderExhausts:SetMax( 200 )
	self.YSliderExhausts:SetDecimals( 1 )
	self.YSliderExhausts:SetConVar( "scareditor_y_exhaust" )
	self.YSliderExhausts.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_exhaust = value
			SCarEditor:ChangeExhauststPos(SCarEditor.Xpos_exhaust, SCarEditor.Ypos_exhaust, SCarEditor.Zpos_exhaust)
		end
	end  	
	CategoryList:AddItem( self.YSliderExhausts )	
	
	
	self.ZSliderExhausts = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderExhausts:SetWide( 295 )
	self.ZSliderExhausts:SetText( "Z" )
	self.ZSliderExhausts:SetMin( -200 )
	self.ZSliderExhausts:SetMax( 200 )
	self.ZSliderExhausts:SetDecimals( 1 )
	self.ZSliderExhausts:SetConVar( "scareditor_z_exhaust" )
	self.ZSliderExhausts.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_exhaust = value
			SCarEditor:ChangeExhauststPos(SCarEditor.Xpos_exhaust, SCarEditor.Ypos_exhaust, SCarEditor.Zpos_exhaust)
		end
	end  	
	CategoryList:AddItem( self.ZSliderExhausts )

	
	self.ExhaustsList = vgui.Create("DListView", CategoryList)
	self.ExhaustsList:SetPos(25, 50)
	self.ExhaustsList:SetMultiSelect(false)
	self.ExhaustsList:AddColumn("Current exhaust")
	self.ExhaustsList:SetSize(295, 80)
	CategoryList:AddItem( self.ExhaustsList )		
	
	collapsCat:SetContents( CategoryList )	
end


---------------------------------EFFECT
function SCarEditor:EffectMenu()


	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Damage effect position" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	

	self.XSliderEffect = vgui.Create( "DNumSlider", CategoryList )
	self.XSliderEffect:SetWide( 295 )
	self.XSliderEffect:SetText( "X" )
	self.XSliderEffect:SetMin( -200 )
	self.XSliderEffect:SetMax( 200 )
	self.XSliderEffect:SetDecimals( 1 )
	self.XSliderEffect:SetConVar( "scareditor_x_effect" )
	self.XSliderEffect.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Xpos_effect = value
			SCarEditor:ChangeEffectPos(SCarEditor.Xpos_effect, SCarEditor.Ypos_effect, SCarEditor.Zpos_effect)
		end
	end  	
	CategoryList:AddItem( self.XSliderEffect )
	

	self.YSliderEffect = vgui.Create( "DNumSlider", CategoryList )
	self.YSliderEffect:SetWide( 295 )
	self.YSliderEffect:SetText( "Y" )
	self.YSliderEffect:SetMin( -200 )
	self.YSliderEffect:SetMax( 200 )
	self.YSliderEffect:SetDecimals( 1 )
	self.YSliderEffect:SetConVar( "scareditor_y_effect" )
	self.YSliderEffect.OnValueChanged = function( panel, value )	
		if !SCarEditor.IgnoreChange then
			SCarEditor.Ypos_effect = value
			SCarEditor:ChangeEffectPos(SCarEditor.Xpos_effect, SCarEditor.Ypos_effect, SCarEditor.Zpos_effect)
		end
	end  	
	CategoryList:AddItem( self.YSliderEffect )	
	
	self.ZSliderEffect = vgui.Create( "DNumSlider", CategoryList )
	self.ZSliderEffect:SetWide( 295 )
	self.ZSliderEffect:SetText( "Z" )
	self.ZSliderEffect:SetMin( -200 )
	self.ZSliderEffect:SetMax( 200 )
	self.ZSliderEffect:SetDecimals( 1 )
	self.ZSliderEffect:SetConVar( "scareditor_z_effect" )
	self.ZSliderEffect.OnValueChanged = function( panel, value )
		if !SCarEditor.IgnoreChange then
			SCarEditor.Zpos_effect = value
			SCarEditor:ChangeEffectPos(SCarEditor.Xpos_effect, SCarEditor.Ypos_effect, SCarEditor.Zpos_effect)
		end
	end  	
	CategoryList:AddItem( self.ZSliderEffect )

	
	
	collapsCat:SetContents( CategoryList )	
end

function SCarEditor:SoundAndEffectMenu()
	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Effect adjustments" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Engine Sound") 
	CategoryList:AddItem( textLabel )	
	
	

	self.EngineSoundList = vgui.Create( "DComboBox", CategoryList)
	
	self.EngineSoundList.TrasDir = {}
	self.EngineSoundList.OnSelect = function( panel, value, data )
		self.EngineSound = panel.TrasDir[data]
		self.EngineSoundID = tonumber(value)
	end
	
	
	for k, v in pairs(list.Get( "SCarEngineSounds" )) do
		self.EngineSoundList:AddChoice(k)	
		self.EngineSoundList.TrasDir[k] = v.carsound_enginesound
	end	
	CategoryList:AddItem( self.EngineSoundList )

	
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Horn Sound") 
	CategoryList:AddItem( textLabel )		
	


	self.HornSoundList = vgui.Create( "DComboBox", CategoryList)
	
	self.HornSoundList.TrasDir = {}
	self.HornSoundList.OnSelect = function( panel, value, data )
		self.HornSound = panel.TrasDir[data]
		self.HornSoundID = tonumber(value)
	end	
	for k, v in pairs(list.Get( "SCarHornSounds" )) do
		self.HornSoundList:AddChoice(k)	
		self.HornSoundList.TrasDir[k] = v.carsound_hornsound
	end	
	CategoryList:AddItem( self.HornSoundList )
	
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("Engine Effect") 
	CategoryList:AddItem( textLabel )		
	
	self.EngineEffectList = vgui.Create( "DComboBox", CategoryList)
	
	self.EngineEffectList.TrasDir = {}
	self.EngineEffectList.OnSelect = function( panel, value, data )
		self.EngineEffect = panel.TrasDir[data]
		self.EngineEffectID = tonumber(value)
	end		
	for k, v in pairs(list.Get( "SCarGearEffect" )) do
		self.EngineEffectList:AddChoice(k)	
		self.EngineEffectList.TrasDir[k] = v.carsound_gearsoundeffect
	end	
	CategoryList:AddItem( self.EngineEffectList )	
	
	

	collapsCat:SetContents( CategoryList )		
end

function SCarEditor:PerformanceMenu()
	collapsCat = vgui.Create("DCollapsibleCategory", self.Panel)
	collapsCat:SetLabel( "Vehicle performance" )
	collapsCat:SetPos( 680, 30)
	collapsCat:SetSize( 300, 50)
	collapsCat:SetExpanded( 0 )	
	self.OptionsList:AddItem(collapsCat)
	
	CategoryList = vgui.Create( "DPanelList", collapsCat )
	CategoryList:EnableHorizontal( false )
	CategoryList:SetDrawBackground( false )
	CategoryList:SetSpacing( 5 )
	CategoryList:SetPadding( 5 )
	CategoryList:SetAutoSize( true )	 
	CategoryList:EnableVerticalScrollbar( true )	
	
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Power" )
	slider:SetMin( 0 )
	slider:SetMax( 10000 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultAcceleration" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Max Speed" )
	slider:SetMin( 10 )
	slider:SetMax( 5000 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultMaxSpeed" )	
	CategoryList:AddItem( slider )		
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("\n") 
	CategoryList:AddItem( textLabel )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Turbo Effect (multiplier)" )
	slider:SetMin( 1 )
	slider:SetMax( 5 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultTurboEffect" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Turbo Duration (in seconds)" )
	slider:SetMin( 1 )
	slider:SetMax( 10 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultTurboDuration" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Turbo Delay (in seconds)" )
	slider:SetMin( 1 )
	slider:SetMax( 60 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultTurboDelay" )	
	CategoryList:AddItem( slider )		
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("\n") 
	CategoryList:AddItem( textLabel )	

	
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Reverse Power" )
	slider:SetMin( 0 )
	slider:SetMax( 5000 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultReverseForce" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Reverse Max Speed" )
	slider:SetMin( 0 )
	slider:SetMax( 1000 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultReverseMaxSpeed" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Brake Force" )
	slider:SetMin( 0 )
	slider:SetMax( 5000 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultBreakForce" )	
	CategoryList:AddItem( slider )	
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("\n") 
	CategoryList:AddItem( textLabel )	

	
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Steer Force" )
	slider:SetMin( 0 )
	slider:SetMax( 20 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultSteerForce" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Steer Response" )
	slider:SetMin( 0 )
	slider:SetMax( 2 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefautlSteerResponse" )	
	CategoryList:AddItem( slider )		
	
	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("\n") 
	CategoryList:AddItem( textLabel )	

	
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Stabilisation" )
	slider:SetMin( 0 )
	slider:SetMax( 4000 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultStabilisation" )	
	CategoryList:AddItem( slider )
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "Nr Of Gears" )
	slider:SetMin( 1 )
	slider:SetMax( 10 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultNrOfGears" )	
	CategoryList:AddItem( slider )	
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "AntiSlide" )
	slider:SetMin( 0 )
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultAntiSlide" )	
	CategoryList:AddItem( slider )		
	
	local slider = vgui.Create( "DNumSlider", CategoryList )
	slider:SetWide( 295 )
	slider:SetText( "AutoStraighten" )
	slider:SetMin( 0 )
	slider:SetMax( 50 )
	slider:SetDecimals( 1 )
	slider:SetConVar( "scareditor_DefaultAutoStraighten" )	
	CategoryList:AddItem( slider )			

	local textLabel = vgui.Create("DLabel")
	textLabel:SetFont("default")
	textLabel:SetText("\n") 
	CategoryList:AddItem( textLabel )	
	
	
	

	
	
	collapsCat:SetContents( CategoryList )	
end


-----------------------MISC
function SCarEditor:SetCarMass(mass)
	self.CarMass = mass
end

----------------------WHEEL
function SCarEditor:GetFirstEmptyWheelSlot()
	for i = 1, self.MaxNrOfWheels do
		if self.WheelsPos[i] == nil then
			return i
		end
	end
end

function SCarEditor:ChangeWheelPos(x,y,z)
	if self.WheelsPos[self.CurId] then
		self.WheelsPos[self.CurId] = Vector(x,y,z)
		self.ModelPanel:SetModelPos( "wheel"..self.CurId, self.WheelsPos[self.CurId] )
	end
end

function SCarEditor:ChangeWheelTorq(torq)
	if self.WheelTorq[self.CurId] then
		if torq then
			self.WheelTorq[self.CurId] = 1
		else
			self.WheelTorq[self.CurId] = 0
		end
	end
end

function SCarEditor:ChangeWheelSteer(steer)
	if self.WheelSteer[self.CurId] then
		self.WheelSteer[self.CurId] = steer
	end
end

function SCarEditor:ChangeWheelSide(side)
	
	if self.WheelSide[self.CurId] then
	
		if side then
			self.WheelSide[self.CurId] = 1
		else
			self.WheelSide[self.CurId] = 0
		end
	
		if self.WheelSide[self.CurId] == 0 then
			self.ModelPanel:SetModelAng( "wheel"..self.CurId, Angle(0,0,0) )
		else
			self.ModelPanel:SetModelAng( "wheel"..self.CurId, Angle(0,180,0) )
		end
	end
end

function SCarEditor:SelectWheel( id )
	self.CurId = id
	self.IgnoreChange = true
	self.XSliderWheel:SetValue( self.WheelsPos[self.CurId].x )
	self.YSliderWheel:SetValue( self.WheelsPos[self.CurId].y )
	self.ZSliderWheel:SetValue( self.WheelsPos[self.CurId].z )
	self.TorqCheckBox:SetValue( self.WheelTorq[self.CurId] )
	self.SideCheckBox:SetValue( self.WheelSide[self.CurId] )
	self.SteerSlider:SetValue( self.WheelSteer[self.CurId] )
	self.IgnoreChange = false
end


function SCarEditor:AddWheel()
	if self.ModelPanel then
		local id = 0
		if self.NrOfWheels == self.MaxNrOfWheels then
			self.NrOfWheels = self.NrOfWheels + 1
			self.MaxNrOfWheels = self.NrOfWheels
			id = self.NrOfWheels
		else
			id = self:GetFirstEmptyWheelSlot()
			self.NrOfWheels = self.NrOfWheels + 1
		end

	

		self.WheelsPos[id] = Vector(0,0,0)
		self.WheelSide[id] = 0
		self.WheelTorq[id] = 0
		self.WheelSteer[id] = 0
	
		self.ModelPanel:AddModel( self.WheelModel, "wheel"..id )
		self.wheelListLines[id] = self.wheelList:AddLine("wheel"..id)
		self.wheelListLines[id].OnSelect = function()
			SCarEditor:SelectWheel( id )
		end
	end
end

function SCarEditor:RemoveWheel()


	self.NrOfWheels = tonumber(self.NrOfWheels) --Temp ugly fix
	if self.NrOfWheels > 0 and self.ModelPanel and self.wheelList and self.wheelList:GetSelectedLine() then
	
		local id = self.wheelList:GetSelectedLine()
		self.ModelPanel:RemoveModel( "wheel"..id )
		
		self.WheelsPos[id] = nil
		self.WheelSide[id] = nil
		self.WheelTorq[id] = nil
		self.WheelSteer[id] = nil
		
		self.wheelList:RemoveLine( id )
		self.NrOfWheels = self.NrOfWheels - 1
	end
end

-------------SEAT
function SCarEditor:GetFirstEmptySeatSlot()
	for i = 1, self.MaxNrOfSeats do
		if self.SeatPos[i] == nil then
			return i
		end
	end
end

function SCarEditor:ChangeSeatPos(x,y,z)
	if self.SeatPos[self.CurId] then
		self.SeatPos[self.CurId] = Vector(x,y,z)
		self.ModelPanel:SetModelPos( "seat"..self.CurId, self.SeatPos[self.CurId] )
	end
end

function SCarEditor:SelectSeat( id )
	self.CurId = id
	self.IgnoreChange = true
	self.XSliderSeat:SetValue( self.SeatPos[self.CurId].x )
	self.YSliderSeat:SetValue( self.SeatPos[self.CurId].y )
	self.ZSliderSeat:SetValue( self.SeatPos[self.CurId].z )
	self.IgnoreChange = false
end


function SCarEditor:AddSeat()
	if self.ModelPanel then
		local id = 0
		if self.NrOfSeats == self.MaxNrOfSeats then
			self.NrOfSeats = self.NrOfSeats + 1
			self.MaxNrOfSeats = self.NrOfSeats
			id = self.NrOfSeats
		else
			id = self:GetFirstEmptySeatSlot()
			self.NrOfSeats = self.NrOfSeats + 1
		end

	

		self.SeatPos[id] = Vector(0,0,0)
	
		self.ModelPanel:AddModel( "models/Nova/airboat_seat.mdl", "seat"..id )
		self.ModelPanel:SetModelAng( "seat"..id, Angle(0,-90,0) )
		self.seatListLines[id] = self.seatList:AddLine("seat"..id)
		self.seatListLines[id].OnSelect = function()
			SCarEditor:SelectSeat( id )
		end
	end
end

function SCarEditor:RemoveSeat()
	if self.NrOfSeats > 0 and self.ModelPanel and self.seatList and self.seatList:GetSelectedLine() then
	
		local id = self.seatList:GetSelectedLine()
		self.ModelPanel:RemoveModel( "seat"..id )
		
		self.SeatPos[id] = nil
		
		self.seatList:RemoveLine( id )
		self.NrOfSeats = self.NrOfSeats - 1
	end
end

---------------------------------FRONT LIGHTS
function SCarEditor:GetFirstEmptyFLightSlot()
	for i = 1, self.MaxNrOfFLight do
		if self.FLightPos[i] == nil then
			return i
		end
	end
end

function SCarEditor:ChangeFLightPos(x,y,z)
	if self.FLightPos[self.CurId] then
		self.FLightPos[self.CurId] = Vector(x,y,z)
		self.ModelPanel:SetModelPos( "flight"..self.CurId, self.FLightPos[self.CurId] )
	end
end

function SCarEditor:SelectFLight( id )
	self.CurId = id
	self.IgnoreChange = true
	self.XSliderFLight:SetValue( self.FLightPos[self.CurId].x )
	self.YSliderFLight:SetValue( self.FLightPos[self.CurId].y )
	self.ZSliderFLight:SetValue( self.FLightPos[self.CurId].z )
	self.IgnoreChange = false
end


function SCarEditor:AddFLight()
	if self.ModelPanel then
		local id = 0
		if self.NrOfFLight == self.MaxNrOfFLight then
			self.NrOfFLight = self.NrOfFLight + 1
			self.MaxNrOfFLight = self.NrOfFLight
			id = self.NrOfFLight
		else
			id = self:GetFirstEmptyFLightSlot()
			self.NrOfFLight = self.NrOfFLight + 1
		end

	

		self.FLightPos[id] = Vector(0,0,0)
	
		self.ModelPanel:AddModel( "models/props_wasteland/prison_cagedlight001a.mdl", "flight"..id )
		self.ModelPanel:SetModelColour( "flight"..id, 255,255,0,0 )
		self.FLightListLines[id] = self.FLightList:AddLine("flight"..id)
		self.FLightListLines[id].OnSelect = function()
			SCarEditor:SelectFLight( id )
		end
	end
end

function SCarEditor:RemoveFLight()
	if self.NrOfFLight > 0 and self.ModelPanel and self.FLightList and self.FLightList:GetSelectedLine() then
	
		local id = self.FLightList:GetSelectedLine()
		self.ModelPanel:RemoveModel( "flight"..id )
		
		self.FLightPos[id] = nil
		
		self.FLightList:RemoveLine( id )
		self.NrOfFLight = self.NrOfFLight - 1
	end
end

---------------------------------REAR LIGHTS
function SCarEditor:GetFirstEmptyRLightSlot()
	for i = 1, self.MaxNrOfRLight do
		if self.RLightPos[i] == nil then
			return i
		end
	end
end

function SCarEditor:ChangeRLightPos(x,y,z)
	if self.RLightPos[self.CurId] then
		self.RLightPos[self.CurId] = Vector(x,y,z)
		self.ModelPanel:SetModelPos( "rlight"..self.CurId, self.RLightPos[self.CurId] )
	end
end

function SCarEditor:SelectRLight( id )
	self.CurId = id
	self.IgnoreChange = true
	self.XSliderRLight:SetValue( self.RLightPos[self.CurId].x )
	self.YSliderRLight:SetValue( self.RLightPos[self.CurId].y )
	self.ZSliderRLight:SetValue( self.RLightPos[self.CurId].z )
	self.IgnoreChange = false
end


function SCarEditor:AddRLight()
	if self.ModelPanel then
		local id = 0
		if self.NrOfRLight == self.MaxNrOfRLight then
			self.NrOfRLight = self.NrOfRLight + 1
			self.MaxNrOfRLight = self.NrOfRLight
			id = self.NrOfRLight
		else
			id = self:GetFirstEmptyRLightSlot()
			self.NrOfRLight = self.NrOfRLight + 1
		end

	

		self.RLightPos[id] = Vector(0,0,0)
	
		self.ModelPanel:AddModel( "models/props_wasteland/prison_cagedlight001a.mdl", "rlight"..id )
		self.ModelPanel:SetModelColour( "rlight"..id, 255,0,0,0 )
		self.ModelPanel:SetModelAng( "rlight"..id, Angle(0,180,0) )
		self.RLightListLines[id] = self.RLightList:AddLine("rlight"..id)
		self.RLightListLines[id].OnSelect = function()
			SCarEditor:SelectRLight( id )
		end
	end
end

function SCarEditor:RemoveRLight()
	if self.NrOfRLight > 0 and self.ModelPanel and self.RLightList and self.RLightList:GetSelectedLine() then
	
		local id = self.RLightList:GetSelectedLine()
		self.ModelPanel:RemoveModel( "rlight"..id )
		
		self.RLightPos[id] = nil
		
		self.RLightList:RemoveLine( id )
		self.NrOfRLight = self.NrOfRLight - 1
	end
end

---------------------------------EXHAUSTS
function SCarEditor:GetFirstEmptyExhaustsSlot()

	for i = 1, self.MaxNrOfExhausts do
		if self.ExhaustsPos[i] == nil then
			return i
		end
	end
end

function SCarEditor:ChangeExhauststPos(x,y,z)
	if self.ExhaustsPos[self.CurId] then
		self.ExhaustsPos[self.CurId] = Vector(x,y,z)
		self.ModelPanel:SetModelPos( "exhaust"..self.CurId, self.ExhaustsPos[self.CurId] )
	end
end

function SCarEditor:SelectExhausts( id )
	self.CurId = id
	self.IgnoreChange = true
	self.XSliderExhausts:SetValue( self.ExhaustsPos[self.CurId].x )
	self.YSliderExhausts:SetValue( self.ExhaustsPos[self.CurId].y )
	self.ZSliderExhausts:SetValue( self.ExhaustsPos[self.CurId].z )
	self.IgnoreChange = false
end


function SCarEditor:AddExhausts()
	if self.ModelPanel then
		local id = 0
		if self.NrOfExhausts == self.MaxNrOfExhausts then
			self.NrOfExhausts = self.NrOfExhausts + 1
			self.MaxNrOfExhausts = self.NrOfExhausts
			id = self.NrOfExhausts
		else
			id = self:GetFirstEmptyExhaustsSlot()
			self.NrOfExhausts = self.NrOfExhausts + 1
		end

		self.ExhaustsPos[id] = Vector(0,0,0)
	
		self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "exhaust"..id )
		self.ModelPanel:SetModelAng( "exhaust"..id, Angle(0,180,0) )
		self.ExhaustsListLines[id] = self.ExhaustsList:AddLine("exhaust"..id)
		self.ExhaustsListLines[id].OnSelect = function()
			SCarEditor:SelectExhausts( id )
		end
	end
end

function SCarEditor:RemoveExhausts()
	if self.NrOfExhausts > 0 and self.ModelPanel and self.ExhaustsList and self.ExhaustsList:GetSelectedLine() then
	
		local id = self.ExhaustsList:GetSelectedLine()
		self.ModelPanel:RemoveModel( "exhaust"..id )
		
		self.ExhaustsPos[id] = nil
		
		self.ExhaustsList:RemoveLine( id )
		self.NrOfExhausts = self.NrOfExhausts - 1
	end
end


-------------------------------------------Effect pos
function SCarEditor:ChangeEffectPos(x,y,z)

	if !self.EffectPos then
		self.ModelPanel:AddModel( "models/dav0r/hoverball.mdl", "effect" )
		self.EffectPos = Vector(0,0,0)
	end

	if self.EffectPos then
		self.EffectPos = Vector(x,y,z)
		self.ModelPanel:SetModelPos( "effect", self.EffectPos )
	end
end


list.Set( "DesktopWindows", "SCarEditor",
{
	title		= "SCar Editor",
	icon		= "gui/car_editor.png",
	width		= 1000,
	height		= 700,
	onewindow	= true,
	init		= function( icon, window )
		window:Close()
		SCarEditor:Menu()
	end
} )


--// Once the server has spawned the car it will send back some of the information that should be shared.
--// For example the exhaust positions.
local function SCar_ServerSpawnedSCarFromEditor()
	local SCar = net.ReadEntity()
	local tabl = net.ReadTable()

	
	SCar.NrOfSeats = tabl.NrOfSeats
	SCar.NrOfWheels = tabl.NrOfWheels
	SCar.NrOfExhausts = tabl.NrOfExhausts
	SCar.NrOfFrontLights = tabl.NrOfFLight
	SCar.NrOfRearLights = tabl.NrOfRLight
	
	SCar.effectPos = Vector(tabl.EffectPos.x, -tabl.EffectPos.y, tabl.EffectPos.z)
	SCar.CarMass = tabl.CarMass
	SCar.DefaultSound = tabl.EngineSound
	SCar.CarModel = tabl.CarModel
	SCar.TireModel = tabl.WheelModel	
	SCar.AnimType = tabl.AnimType
	
	SCar.SeatPos = {}
	for i = 1, SCar.NrOfSeats do
		SCar.SeatPos[i] = Vector(tabl.SeatPos[i].x, -tabl.SeatPos[i].y, tabl.SeatPos[i].z)
	end
	
	
	SCar.WheelInfo = {}
	for i = 1, SCar.NrOfWheels do
		SCar.WheelInfo[i] = {}
		SCar.WheelInfo[i].Pos = Vector(tabl.WheelsPos[i].x, -tabl.WheelsPos[i].y, tabl.WheelsPos[i].z)
		
		if tabl.WheelSide[i] == 1 then
			SCar.WheelInfo[i].Side = false
		else
			SCar.WheelInfo[i].Side = true
		end			

		if tabl.WheelTorq[i] == 1 then
			SCar.WheelInfo[i].Torq = true
		else
			SCar.WheelInfo[i].Torq = false
		end
		
		SCar.WheelInfo[i].Steer = tabl.WheelSteer[i]
	end
			
	SCar.ExhaustPos = {}
	for i = 1, SCar.NrOfExhausts do
		SCar.ExhaustPos[i] = Vector(tabl.ExhaustPos[i].x, -tabl.ExhaustPos[i].y, tabl.ExhaustPos[i].z)
	end		
	
	SCar.FrontLightsPos = {}
	for i = 1, SCar.NrOfFrontLights do
		SCar.FrontLightsPos[i] = Vector(tabl.FLightPos[i].x, -tabl.FLightPos[i].y, tabl.FLightPos[i].z)
	end		

	SCar.RearLightsPos = {}
	for i = 1, SCar.NrOfRearLights do
		SCar.RearLightsPos[i] = Vector(tabl.RLightPos[i].x, -tabl.RLightPos[i].y, tabl.RLightPos[i].z)
	end	
	
	
	
	SCar.DefaultAcceleration = tabl.DefaultAcceleration
	SCar.DefaultMaxSpeed = tabl.DefaultMaxSpeed
	SCar.DefaultTurboEffect = tabl.DefaultTurboEffect
	SCar.DefaultTurboDuration = tabl.DefaultTurboDuration
	SCar.DefaultTurboDelay = tabl.DefaultTurboDelay
	SCar.DefaultReverseForce = tabl.DefaultReverseForce
	SCar.DefaultReverseMaxSpeed = tabl.DefaultReverseMaxSpeed
	SCar.DefaultBreakForce = tabl.DefaultBreakForce
	SCar.DefaultSteerForce = tabl.DefaultSteerForce
	SCar.DefautlSteerResponse = tabl.DefautlSteerResponse
	SCar.DefaultStabilisation = tabl.DefaultStabilisation
	SCar.DefaultNrOfGears = tabl.DefaultNrOfGears
	SCar.DefaultAntiSlide = tabl.DefaultAntiSlide
	SCar.DefaultAutoStraighten = tabl.DefaultAutoStraighten
	SCar.DeafultSuspensionAddHeight = -tabl.DeafultSuspensionAddHeight
	SCar.DefaultHydraulicActive = tabl.DefaultHydraulicActive
	SCar.Category = tabl.CarCategoryName	

	SCar.AddSpawnHeight = tabl.AddSpawnHeight
	SCar.ViewDist = tabl.ViewDist
	SCar.ViewDistUp = tabl.ViewDistUp			
	
	SCar.DefaultSoftnesFront = tabl.WheelSuspensionStiffness
	SCar.DefaultSoftnesRear = tabl.WheelSuspensionStiffness		
			
end
net.Receive("SCar_ServerSpawnedSCarFromEditor", SCar_ServerSpawnedSCarFromEditor )