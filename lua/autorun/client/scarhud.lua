
SCarHudHandler = {}
SCarHudHandler.Huds = {}
SCarHudHandler.HudsNameTrans = {}
SCarHudHandler.NrOfHuds = 0
SCarHudHandler.CurrentHud = nil

SCarHudHandler.isWideScreen = false
SCarHudHandler.vel = 0
SCarHudHandler.mph = 0
SCarHudHandler.kmh = 0
SCarHudHandler.showGear = ""
SCarHudHandler.CurGear = 0

SCarHudHandler.rev = 40
SCarHudHandler.revScale = 40
SCarHudHandler.isRevving = false
SCarHudHandler.curRev = 40

SCarHudHandler.forwardMaxSpeed = 300
SCarHudHandler.reverseMaxSpeed = 300
SCarHudHandler.fuel = 1
SCarHudHandler.neutral = false
SCarHudHandler.isOn = false
SCarHudHandler.isScarSeat = 0
SCarHudHandler.SCar = nil
SCarHudHandler.FuncRes = false
SCarHudHandler.ply = nil
SCarHudHandler.veh = nil

SCarHudHandler.LastSelection = 1
SCarHudHandler.LastSelectionName = ""
SCarHudHandler.retry = true

SCarHudHandler.UseTurbo = false
SCarHudHandler.TurboPercent = 0
SCarHudHandler.LastTurboUse = false
SCarHudHandler.ContineousTurbo = false
SCarHudHandler.TDur = 0
SCarHudHandler.TurboDelay = 0
SCarHudHandler.TurboDuration = 0
SCarHudHandler.StartTurboTime = 0
SCarHudHandler.speed = 0

SCarHudHandler.xSize = 0
SCarHudHandler.ySize = 0
SCarHudHandler.xPos = 0
SCarHudHandler.yPos = 0
SCarHudHandler.CamData = {}
SCarHudHandler.maxs = Vector(0,0,0)
SCarHudHandler.mins = Vector(0,0,0)
SCarHudHandler.length = 0
SCarHudHandler.height = 0
SCarHudHandler.origin = Vector(0,0,0)
SCarHudHandler.ang = Angle(0,0,0)

function SCarHudHandler:Init()
	local huds = {}
	huds =	file.Find( "scarhud/*.lua" , "LUA")

	for _, plugin in ipairs( huds ) do	
		include( "scarhud/" .. plugin )
	end
	
	self:ReadFromFile()
end

function SCarHudHandler:SaveToFile()
	file.Write( "scarhud.txt", self.LastSelectionName.."\n")
end

function SCarHudHandler:Refresh()
	self.NrOfHuds = 0
	self:Init()
end

function SCarHudHandler:ReadFromFile()

	local canDo = false
	canDo = file.Exists( "scarhud.txt", "DATA" )


	if canDo then
		local cont = file.Read( "scarhud.txt" )
		cont = file.Read( "scarhud.txt", "DATA" )
		
		if cont == nil then
			SCarsReportError("SCar hud file exists but it has no real content? Writing default SCar hud file!", 150)
			file.Write( "scarhud.txt", "Default" )
			cont = file.Read( "scarhud.txt", "DATA" )
			
			if cont == nil then
				SCarsReportError("Writing the default SCar hud file and reading it didn't work. Not allowed to read/write files?", 255)
				return
			end
		end
		
		local data = string.Explode(string.char(10), cont)

		if !self.HudsNameTrans[data[1]] && self.retry == true then
			self.retry = false
			SCarsReportError("AAReading SCar hud file failed! Trying to solve..")
			file.Write( "scarhud.txt", "Default" )
			self:ReadFromFile()			
		elseif !self:SetActiveHudByName( data[1] ) then
			SCarHudHandler.LastSelection = 1
			SCarHudHandler.LastSelectionName = ""
			self.CurrentHud = self.Huds[1]
			
			if self.CurrentHud.Init then
				self.CurrentHud:Init()
			end
		end
	else
		if self.retry == true then
			self.retry = false
			file.Write( "scarhud.txt", "Default" )
			self:ReadFromFile()
		else
			SCarsReportError("Could not read SCar hud settings file!", 250)
		end
	end
end

function SCarHudHandler:SetActiveHudByName( name )

	if self.HudsNameTrans[name] then
		SCarHudHandler.LastSelectionName = name
		SCarHudHandler.LastSelection = self.HudsNameTrans[SCarHudHandler.LastSelectionName]
		self.CurrentHud = self.Huds[SCarHudHandler.LastSelection]

		if self.CurrentHud.Init then
			self.CurrentHud:Init()
		end		
		
		return true
	end
	
	return false
end

function SCarHudHandler:RefreshMenu( Panel )
	local CPanel = controlpanel.Get( "SCarHud" )
	if ( !CPanel ) then return end
	
	CPanel:ClearControls()
	SCarHudHandler.BuildMenu( CPanel )
end

function SCarHudHandler.BuildMenu( Panel )
	local self = SCarHudHandler
	
	
	local Text = vgui.Create("DLabel")
	Text:SetPos(5,0)
	Text:SetFont("Default")
	Text:SetText("Selected: "..self.LastSelectionName)
	Text:SetColor(Color(255,255,255,255))
	Panel:AddItem(Text)	
	
	local hudList = vgui.Create( "DListView" )
	hudList:SetSize( 100, 185 )
	hudList:SetMultiSelect(false)
	hudList:AddColumn("Huds") -- Add column
	
	hudList.OnClickLine = function(parent, line, isselected)
		local val = line:GetValue(1)
		if SCarHudHandler.LastSelectionName != val then
			SCarHudHandler.LastSelectionName = val

			SCarViewManager:SaveToFile()
			SCarViewManager:RefreshMenu( Panel )
			
			
			if SCarViewManager.Cams[SCarViewManager.CurCam].Init then
				SCarViewManager.Cams[SCarViewManager.CurCam]:Init()
			end		

			self:SetActiveHudByName(val)
			SCarHudHandler:SaveToFile()
			SCarHudHandler:RefreshMenu( Panel )
			
		end
	end		
	
	for i = 1, self.NrOfHuds do
		hudList:AddLine( self.Huds[i].Name )
	end	
	Panel:AddItem(hudList)	
	

	if self.Huds[SCarHudHandler.LastSelection].MenuElements then
		self.Huds[SCarHudHandler.LastSelection]:MenuElements( Panel )
	end

end



function SCarHudHandler:RegisterHUD(hud)
	self.NrOfHuds = self.NrOfHuds + 1
	
	if !hud.Name then
		hud.Name = "No Name"
	end
	
	self.Huds[self.NrOfHuds] = hud
	self.HudsNameTrans[hud.Name] = self.NrOfHuds
end

function SCarHudHandler:GetHudByName( name )
	for i = 1, self.NrOfHuds do
		if self.Huds[i].Name == name then
			return self.Huds[i]
		end
	end
end

function SCarHudHandler:SelectHud( name )
	self:GetHudByName( name )
end

function SCarHudHandler:GetTableOfTitles( )

	local names = {}
	for i = 1, self.NrOfHuds do
		names[i] = self.Huds[i].Name
	end
	
	return nrOfNames, names
end

function SCarHudHandler:UpdateHUD()
	local self = SCarHudHandler

	if !LocalPlayer() or !LocalPlayer():Alive() then return end
	if LocalPlayer():GetActiveWeapon() == "Camera" then return end		
	if GetViewEntity():GetClass() == "gmod_cameraprop" then return end

	self.ply = LocalPlayer()	
	self.veh = self.ply:GetVehicle()

	
	self.isScarSeat = 0
	self.SCar = nil
	self.FuncRes = false
	
	if IsValid(self.veh) then
		self.isScarSeat = self.veh:GetNetworkedInt( "SCarSeat" )
		self.SCar = self.veh:GetNetworkedEntity("SCarEnt")
	end

	if self.SCar and self.SCar.HudPaintAdd then
		self.FuncRes = self.SCar:HudPaintAdd(self.isScarSeat)
	end	

	if !self.FuncRes and self.isScarSeat == 1 and IsValid(self.SCar) then

		--Checking if the user have a widescreen res or not.
		self.isWideScreen = true
		
		if (ScrW() / ScrH()) <= (4 / 3) then
			self.isWideScreen = false
		end	
	
		self.vel = self.veh:GetVelocity():Length()
		self.mph = self.vel / 23.33
		self.kmh = self.vel / 14.49
		self.showGear = " "
		
		if self.CurGear == -1 then
			self.showGear = "R"
		elseif self.CurGear == -2 then
			self.showGear = "B"	
		elseif self.CurGear == -3 then
			self.showGear = "H"
		else
			self.showGear = tostring(self.CurGear + 1)
		end


		--Calculating Rev
		self.rev = ((self.vel % self.revScale) / self.revScale)
		
		if self.isRevving == true then
			self.curRev = math.Approach( self.curRev, 1 , 0.58333 * FrameTime() )
		elseif self.neutral == true or self.isOn == false then --Neutral (no throttle)
			self.curRev = math.Approach( self.curRev, 0 , 0.3 * FrameTime() )
		elseif self.CurGear >= 0 then
			self.curRev = math.Approach( self.curRev, self.rev , ((self.rev - self.curRev) * 0.1) )
			
			if self.vel > self.forwardMaxSpeed then
				self.curRev = 1
			end
			
		elseif self.CurGear == -1 then		
			self.rev = ( self.vel / self.reverseMaxSpeed ) 
			self.curRev = math.Approach( self.curRev, self.rev , ((self.rev - self.curRev) * 0.1) )
			
			if self.vel > self.reverseMaxSpeed then
				self.rev = 1
			end
			
		else
			self.curRev = math.Approach( self.curRev, 0 , 0.3 * FrameTime() )
		end
		self.curRev = math.Clamp( self.curRev, 0, 1) 			
		
		--------Turbo
		if self.ContineousTurbo == true then
			if self.UsingTurbo == true then
				self.TurboPercent = (self.TDur - CurTime()) / self.TurboDuration
			else
				self.TurboPercent = 1-(self.TDur - CurTime()) / self.TurboDelay
			end
		else
			
			if self.UsingTurbo == true then
				self.TurboPercent = (1 - self.TurboDelay) * ((self.StartTurboTime - CurTime()) / self.TurboDuration)
			else
				self.TurboPercent = self.TurboDelay + (1-((self.StartTurboTime - CurTime()) / self.TurboDuration)) * (1-self.TurboDelay)
			end
		end
		
		self.TurboPercent = math.Clamp(self.TurboPercent,0,1)
		
		if SCarClientData["scar_kmormiles"] == true then
			self.speed = self.kmh
		else
			self.speed = self.mph
		end
		
		
		self.CurrentHud:DrawHud(self.vel, self.curRev, self.showGear, self.fuel, self.TurboPercent, self.speed, self.SCar, self.ply, self.isWideScreen, SCarClientData["scar_kmormiles"])
		
		
		if SCarClientData["scar_rearviewmirror_use"] then	
			self.xSize = ScrW() * (SCarClientData["scar_rearviewmirror_sizex"] * 0.01)
			self.ySize = ScrH() * (SCarClientData["scar_rearviewmirror_sizey"] * 0.01)
			self.xPos = (ScrW() - self.xSize) * (SCarClientData["scar_rearviewmirror_posx"] * 0.01)
			self.yPos = (ScrH() - self.ySize) * (SCarClientData["scar_rearviewmirror_posy"] * 0.01)
			
			
			draw.RoundedBox( 0, self.xPos, self.yPos, self.xSize, self.ySize , Color(0,0,0,255) )			
			self.xSize = self.xSize - 4
			self.ySize = self.ySize - 4
			self.xPos = self.xPos + 2
			self.yPos = self.yPos + 2
			
			self.maxs = self.SCar:OBBMaxs()
			self.mins = self.SCar:OBBMins()
			self.length = (self.maxs.x - self.mins.x) * -0.47
			self.height = (self.maxs.z - self.mins.z) * 0.2
			self.origin = self.SCar:LocalToWorld(self.SCar:OBBCenter()) + self.SCar:GetForward() * self.length + self.SCar:GetUp() * self.height 
			
			self.ang = self.SCar:GetAngles()
			self.ang:RotateAroundAxis( self.ang:Up(), 180)

		
			self.SCar:SetDoDraw( false )
			self.CamData.angles = self.ang
			self.CamData.origin = self.origin
			self.CamData.x = self.xPos
			self.CamData.y = self.yPos
			self.CamData.w = self.xSize
			self.CamData.h = self.ySize
			render.RenderView( self.CamData )
			self.SCar:SetDoDraw( true )
		
		end
	end	
	
end
hook.Add( "HUDPaint", "DrawSCarHUD", SCarHudHandler.UpdateHUD )

function SCarHudHandler.Hide( Element )

	if SCarHudHandler.isScarSeat >= 1 then
		if (Element=="CHudHealth") or (Element=="CHudBattery") or (Element=="CHudAmmo") or (Element=="CHudSecondaryAmmo")then 
		   return false
		end
	end
end
hook.Add("HUDShouldDraw", "HideCrapScarHud", SCarHudHandler.Hide) 

--UserMessages
local function GetUseNosFromServer( data )
	SCarHudHandler.UsingTurbo = data:ReadBool()
	if SCarHudHandler.UsingTurbo == true then
		SCarHudHandler.TDur = CurTime() + SCarHudHandler.TurboDuration
	elseif SCarHudHandler.UsingTurbo == false then
		SCarHudHandler.TDur = CurTime() + SCarHudHandler.TurboDelay
	end		
end
usermessage.Hook( "SCarGetUseNosFromServer", GetUseNosFromServer )



local function SCarGetUseContNosFromServer( data )
	SCarHudHandler.ContineousTurbo = data:ReadBool()
end
usermessage.Hook( "SCarGetUseContNosFromServer", SCarGetUseContNosFromServer )

local function GetNosTimeFromServer( data )
	SCarHudHandler.TurboDuration = data:ReadFloat()
	SCarHudHandler.StartTurboTime = SCarHudHandler.TurboDuration + CurTime()
end
usermessage.Hook( "GetNosTimeFromServer", GetNosTimeFromServer )

local function GetNosRegenTimeFromServer( data )
	SCarHudHandler.TurboDelay = data:ReadFloat()
end
usermessage.Hook( "GetNosRegenTimeFromServer", GetNosRegenTimeFromServer )



local function GetGearFromServer( data )
	SCarHudHandler.CurGear = data:ReadShort()
end
usermessage.Hook( "SCarGetGearFromServer", GetGearFromServer )

local function GetEngineRevFromServer( data )
	SCarHudHandler.revScale = data:ReadLong()
end
usermessage.Hook( "SCarGetEngineRevFromServer", GetEngineRevFromServer )

local function GetEngineRevReverseFromServer( data )
	SCarHudHandler.reverseMaxSpeed = data:ReadLong()
end
usermessage.Hook( "SCarGetEngineRevReverseFromServer", GetEngineRevReverseFromServer )

local function GetEngineRevForwardFromServer( data )
	SCarHudHandler.forwardMaxSpeed = data:ReadLong()
end
usermessage.Hook( "SCarGetEngineRevForwardFromServer", GetEngineRevForwardFromServer )

local function GetFuelFromServer( data )
	SCarHudHandler.fuel = data:ReadLong() / 20000
end
usermessage.Hook( "SCarGetFuelFromServer", GetFuelFromServer )

local function GetNeutralFromServer( data )
	SCarHudHandler.neutral = data:ReadBool()
end
usermessage.Hook( "SCarGetNeutralFromServer", GetNeutralFromServer )

local function GetRevvingFromServer( data )
	SCarHudHandler.isRevving = data:ReadBool()
end
usermessage.Hook( "SCarGetRevvingFromServer", GetRevvingFromServer )

local function GetIsOnFromServer( data )
	SCarHudHandler.isOn = data:ReadBool()
end
usermessage.Hook( "SCarGetIsOnFromServer", GetIsOnFromServer )
