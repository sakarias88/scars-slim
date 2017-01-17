
SCarViewManager = {}

SCarViewManager.oldSpeed = Vector(0,0,0)
SCarViewManager.realAddAng = Vector(0,0,0)

SCarViewManager.posOffsetO = Vector(0,0,0)
SCarViewManager.realOffsetPosO = Vector(0,0,0)
SCarViewManager.posOffsetI = Vector(0,0,0)
SCarViewManager.realOffsetPosI = Vector(0,0,0)
	
SCarViewManager.startTime = CurTime()
SCarViewManager.transPos = Vector(0,0,0)
SCarViewManager.transAng = Angle(0,0,0)
SCarViewManager.saveTransAng = Angle(0,0,0)
SCarViewManager.savePos = Vector(0,0,0)
SCarViewManager.endTime = 1
SCarViewManager.isOut = false
SCarViewManager.curView = 0
SCarViewManager.SCar = nil

SCarViewManager.veh = nil
SCarViewManager.isScarSeat = 0
SCarViewManager.ThirdPersonView = 0

SCarViewManager.zSmooth = 0
SCarViewManager.lastZ = 0 

SCarViewManager.view = {}
SCarViewManager.newPos = Vector(0,0,0)
SCarViewManager.newAngs = Angle(0,0,0)
SCarViewManager.newFov = 0

SCarViewManager.Cams = {}
SCarViewManager.CurCam = "Default"
SCarViewManager.retry = true


function SCarViewManager:ReadFromFile()
	local canDo = false
	
	canDo = file.Exists( "scarcam.txt", "DATA" )


	if canDo then
		local cont = {}
	
		cont = file.Read( "scarcam.txt", "DATA" )

		if cont == nil then
			SCarsReportError("SCar camera file exists but it has no real content? Writing default SCar camera file!", 150)
			file.Write( "scarcam.txt", "Default")
			cont = file.Read( "scarcam.txt", "DATA" )
			
			if cont == nil then
				SCarsReportError("Writing the default SCar camera file and reading it didn't work. Not allowed to read/write files?", 255)
				return
			end
		end		
		
		local data = string.Explode(string.char(10), cont)
		self.CurCam = data[1]

		if !self.Cams[self.CurCam] && self.retry == true then --//Something broke? Resave, reload
			SCarsReportError("Reading SCar cam file failed! Trying to solve..")
			self.retry = false
			self.CurCam = "Default"
			self:SaveToFile()
			self:ReadFromFile()
		elseif self.Cams[self.CurCam] && self.Cams[self.CurCam].Init then
			self.Cams[self.CurCam]:Init()
		else
			SCarsReportError("Could not read SCar camera settings file!", 250)
		end		
	else
		if self.retry == true then
			self.retry = false
			file.Write( "scarcam.txt", "Default" )
			self:ReadFromFile()
		else
			SCarsReportError("Could not read SCar camera settings file!", 250)
		end
	end
end



function SCarViewManager:Init()
	local cams = {}

	cams =	file.Find( "scarcams/*.lua" , "LUA")

	for _, plugin in ipairs( cams ) do
		include( "scarcams/" .. plugin )
	end
	
	self:ReadFromFile()
end

function SCarViewManager:Refresh()
	self.Cams = {}
	self:Init()
end


function SCarViewManager:SaveToFile()
	file.Write( "scarcam.txt", self.CurCam.."\n")
end

function SCarViewManager:GetTableOfCamNames()

	local names = {}
	local count = 0
	
	for k, v in pairs(self.Cams) do
		count = count + 1
		names[count] = k
	end

	return names
end

function SCarViewManager:RegisterCam(cam)
	
	if !cam.Name then
		cam.Name = "No Name"
	end

	self.Cams[cam.Name] = cam
end

function SCarViewManager:SaveViewInfo( view )
	self.saveTransAng.p = self.view.angles.p
	self.saveTransAng.y = self.view.angles.y
	self.saveTransAng.r = self.view.angles.r
	
	self.savePos.x = self.view.origin.x
	self.savePos.y = self.view.origin.y
	self.savePos.z = self.view.origin.z
end

function SCarViewManager:RefreshMenu( Panel )
	local CPanel = controlpanel.Get( "SCarCam" )
	if ( !CPanel ) then return end
	
	CPanel:ClearControls()
	SCarViewManager.BuildMenu( CPanel )
end

function SCarViewManager.BuildMenu( Panel )
	local self = SCarViewManager
	

	local Text = vgui.Create("DLabel")
	Text:SetPos(5,0)
	Text:SetFont("Default")
	Text:SetText("Selected: "..self.CurCam)
	Text:SetColor(Color(255,255,255,255))
	Panel:AddItem(Text)	
	
	
	local camList = vgui.Create( "DListView" )
	camList:SetSize( 100, 185 )
	camList:SetMultiSelect(false)
	camList:AddColumn("Cams") -- Add column
	
	camList.OnClickLine = function(parent, line, isselected)
		local val = line:GetValue(1)
		if SCarViewManager.CurCam != val then
			SCarViewManager.CurCam = val

			SCarViewManager:SaveToFile()
			SCarViewManager:RefreshMenu( Panel )
			
			
			if SCarViewManager.Cams[SCarViewManager.CurCam].Init then
				SCarViewManager.Cams[SCarViewManager.CurCam]:Init()
			end				
		end
	end		
	

	for k, v in pairs(self.Cams) do
		camList:AddLine( k )
	end	
	Panel:AddItem(camList)	
	
	if self.Cams[self.CurCam] then
		self.Cams[self.CurCam]:MenuElements( Panel )
	end

end


function SCarViewManager.CalcView(ply, position, angles, fov)
	local self = SCarViewManager
	
	
	if !ply:Alive() then return end
	if ply:GetActiveWeapon() == "Camera" then return end
	if GetViewEntity() != ply then return end
	

	self.veh = LocalPlayer():GetVehicle()
	self.isScarSeat = 0
	self.ThirdPersonView = 0
	
	if IsValid(self.veh) then
		self.isScarSeat = self.veh:GetNetworkedInt( "SCarSeat" )
		self.ThirdPersonView = LocalPlayer():GetNetworkedInt( "SCarThirdPersonView" )
		self.SCar = self.veh:GetNetworkedEntity("SCarEnt")
		
		if self.isScarSeat >= 1 and self.ThirdPersonView == 1 and IsValid(self.SCar) then	

			if self.SCar.CalcViewOverrideTP then
				self.newPos, self.newAngs, self.newFov = self.SCar:CalcViewOverrideTP(ply, position, angles, fov, self.isScarSeat)	
				
				
				
				if !self.newPos or !self.newAngs or !self.newFov then
					self.newPos, self.newAngs, self.newFov = self.Cams[self.CurCam]:ThirdPerson(ply, position, angles, fov, self.SCar, self.veh)	
				end
				
				self.view.origin = self.newPos
				self.view.angles = self.newAngs
				self.view.fov = self.newFov
				self:SaveViewInfo( self.view )
				return self.view
			else
				self.newPos, self.newAngs, self.newFov = self.Cams[self.CurCam]:ThirdPerson(ply, position, angles, fov, self.SCar, self.veh)	
				self.view.origin = self.newPos
				self.view.angles = self.newAngs
				self.view.fov = self.newFov
				self:SaveViewInfo( self.view )
				return self.view	
			end
		elseif self.isScarSeat >= 1 and self.ThirdPersonView == 0 and IsValid(self.SCar) then
			if self.SCar.CalcViewOverrideFPS then
				self.newPos, self.newAngs, self.newFov = self.SCar:CalcViewOverrideFPS(ply, position, angles, fov, self.isScarSeat)
				
				if !self.newPos or !self.newAngs or !self.newFov then
					self.newPos, self.newAngs, self.newFov = self.Cams[self.CurCam]:FirstPerson(ply, position, angles, fov, self.SCar, self.veh)	
				end
				
				self.view.origin = self.newPos
				self.view.angles = self.newAngs
				self.view.fov = self.newFov
				self:SaveViewInfo( self.view )
				return self.view	
			else
				self.newPos, self.newAngs, self.newFov = self.Cams[self.CurCam]:FirstPerson(ply, position, angles, fov, self.SCar, self.veh)
				self.view.origin = self.newPos
				self.view.angles = self.newAngs
				self.view.fov = self.newFov
				self:SaveViewInfo( self.view )
				return self.view	
			end
		end
	end

	self.curView = 0
	self.isOut = true
	
	self.view.origin = position
	self.view.angles = angles
	
	self:SaveViewInfo( self.view )	
end
hook.Add("CalcView", "SCar CalcView", SCarViewManager.CalcView)



function SCarSetHeadPosFromServer( data ) --  :[
	
	local self = SCarViewManager

	self.transPos = data:ReadVector()
	ang = data:ReadAngle()

	self.veh = LocalPlayer():GetVehicle()

	self.ThirdPersonView = LocalPlayer():GetNetworkedInt( "SCarThirdPersonView" )
	
	
	if self.ThirdPersonView == 1 then --THRD P View
		if self.isOut == true then
			self.isOut = false
			self.transAng = self.saveTransAng - ang - Angle(0,90,0)
			self.lastZ = self.savePos.z
		end		
	else --FPS VIEW
		if (self.startTime + self.endTime) > CurTime() then
			local percent = ((self.startTime + self.endTime) - CurTime()) / self.endTime
			self.transPos = self.transPos + (self.realOffsetPosI * -1)
			self.transAng = self.saveTransAng
		else
			self.transAng.y = self.transAng.y - 90
		end
		
		self.transAng.z = 0

		if self.isOut == true then
			self.isOut = false
			self.transAng = self.saveTransAng - ang - Angle(0,90,0)
		end	
	end

	self.startTime = CurTime()
end
usermessage.Hook( "SetHeadPosFromServerCalcView", SCarSetHeadPosFromServer )


function SCarViewManager.SCarShouldDrawLocalPlayer()

	local self = SCarViewManager
	self.veh = LocalPlayer():GetVehicle()
	self.isScarSeat = 0
	self.ThirdPersonView = 0	
	
	if IsValid(self.veh) then
		self.isScarSeat = self.veh:GetNetworkedInt( "SCarSeat" )
		self.ThirdPersonView = LocalPlayer():GetNetworkedInt( "SCarThirdPersonView" )
	end	
	
	
	if self.isScarSeat >= 1 and (self.ThirdPersonView == 1 or self.ThirdPersonView == 0 and SCarClientData["scar_draw_driver_in_fp"]) then
		return true
	end
end
hook.Add("ShouldDrawLocalPlayer", "SCarViewManager.SCarShouldDrawLocalPlayer", SCarViewManager.SCarShouldDrawLocalPlayer)
