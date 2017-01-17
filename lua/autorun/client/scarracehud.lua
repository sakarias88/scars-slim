
local Font_raceCountDownText = {}
Font_raceCountDownText.font = "Mister Belvedere"
Font_raceCountDownText.size = ScreenScale(30)
Font_raceCountDownText.weight = 400
Font_raceCountDownText.blursize = 0
Font_raceCountDownText.scanlines = 0
Font_raceCountDownText.antialias = true
Font_raceCountDownText.additive = false
Font_raceCountDownText.underline = false
Font_raceCountDownText.italic  = false
Font_raceCountDownText.strikeout = false
Font_raceCountDownText.symbol  = false
Font_raceCountDownText.rotary = false
Font_raceCountDownText.shadow = false
Font_raceCountDownText.outline = false
surface.CreateFont("raceCountDownText", Font_raceCountDownText )
--surface.CreateFont("Mister Belvedere", ScreenScale(30), 400, true, false, "raceCountDownText")

local Font_raceText = {}
Font_raceText.font = "Mister Belvedere"
Font_raceText.size = ScreenScale(15)
Font_raceText.weight = 400
Font_raceText.blursize = 0
Font_raceText.scanlines = 0
Font_raceText.antialias = true
Font_raceText.additive = false
Font_raceText.underline = false
Font_raceText.italic  = false
Font_raceText.strikeout = false
Font_raceText.symbol  = false
Font_raceText.rotary = false
Font_raceText.shadow = false
Font_raceText.outline = false
surface.CreateFont("raceText", Font_raceText )
--surface.CreateFont("Mister Belvedere", ScreenScale(15), 400, true, false, "raceText")

SCarRaceHud = {}

SCarRaceHud.theEndTime = 0
SCarRaceHud.colPercent = 0

SCarRaceHud.currentLap = 0
SCarRaceHud.lapsToGo = 0

SCarRaceHud.raceEndTime = 0
SCarRaceHud.raceMaxEndTime = 0
SCarRaceHud.showRaceEndTime = false

SCarRaceHud.totalTime = 0
SCarRaceHud.lapTime = 0

SCarRaceHud.raceStartTime = 0
SCarRaceHud.lapStartTime = 0

SCarRaceHud.showRaceHud = false
SCarRaceHud.firstTimeShow = false

SCarRaceHud.GearTex = surface.GetTextureID("SCarHUD/gear") 


SCarRaceHud.borderCol = Color(0,0,0,128)
SCarRaceHud.borderHighlightCol = Color( 255,255,255,255 )

SCarRaceHud.textCol = Color(255,255,255,255)
SCarRaceHud.textHighlightCol = Color(0,0,0,255)



--Music stuff
SCarRaceHud.dir = "sound/racemusic/"
SCarRaceHud.dirTwo = "racemusic/"
SCarRaceHud.musicNames = {}

SCarRaceHud.mp3Files = {}
SCarRaceHud.wavFiles = {}

SCarRaceHud.mp3Files = file.Find( SCarRaceHud.dir.."*.mp3", "GAME")
SCarRaceHud.wavFiles = file.Find( SCarRaceHud.dir.."*.wav", "GAME")



SCarRaceHud.nrOfMusic = 0
SCarRaceHud.tune = nil
SCarRaceHud.tuneDuration = 0

SCarRaceHud.x = 32
SCarRaceHud.y = 32
SCarRaceHud.xSize = 220
SCarRaceHud.ySize = 40


SCarRaceHud.RacePositions = {}
SCarRaceHud.NrOfRacers = 0

--Arrow
SCarRaceHud.arrowPos = Vector(0,0,0)
SCarRaceHud.showArrow = false
SCarRaceHud.ArrowTex = surface.GetTextureID("SCarMisc/arrow")
SCarRaceHud.ArrowTex2 = surface.GetTextureID("SCarMisc/arrowBg")
SCarRaceHud.curArrowDir = 0
--Getting all mp3 files we have
for _, plugin in ipairs( SCarRaceHud.mp3Files ) do
	table.insert( SCarRaceHud.musicNames, plugin )
end

--Getting all wav files we have
for _, plugin in ipairs( SCarRaceHud.wavFiles ) do
	table.insert( SCarRaceHud.musicNames, plugin )
end

SCarRaceHud.nrOfMusic = table.Count( SCarRaceHud.musicNames )

function SCarRaceHud:StartRaceMusic() 
	if SCarClientData["scar_useracemusic"] == true then 
		if self.tune then
			self.tune:Stop()
		end
		if self.nrOfMusic > 0 then
			local soundDir = self.dirTwo..self.musicNames[math.random( 1, self.nrOfMusic )]
			self.tune = CreateSound(LocalPlayer(),soundDir)
			self.tune:Play()
			self.tuneDuration = SoundDuration( soundDir ) + RealTime()
		end
	end
end

function SCarRaceHud:StopRaceMusic()
	if self.tune then
		self.tune:Stop()
	end
end

function SCar_ConvertTimeToString( tm )
	local minutes = math.floor(tm / 60)
	local seconds = tm - (minutes * 60)
	local milliSeconds = seconds
	seconds = math.floor(seconds)
	milliSeconds = milliSeconds - seconds
	milliSeconds = milliSeconds * 100
	milliSeconds = math.floor(milliSeconds)
	return string.format("%02.f", minutes)..":"..string.format("%02.f", seconds)..":"..string.format("%02.f", milliSeconds)
end


--Draw hud stuff
function SCarRaceHud.DrawHud() 

	local self = SCarRaceHud

	

	
	if self.showRaceHud then
		
		if self.firstTimeShow == false then
			self:StartRaceMusic()
			self.firstTimeShow = true
		end
	
		if self.tuneDuration < RealTime() or (self.tune and !self.tune:IsPlaying()) then
			self:StopRaceMusic()
			self:StartRaceMusic() 
		end
		
	
		--Top Left
		self.x = 0.019047619 * ScrW() --32
		self.y = 0.0304761905 * ScrH() --32
		self.xSize = 0.130952381 * ScrW() --220
		self.ySize = 0.0380952381 * ScrH()--40
		draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderCol )
		self.xSize = self.xSize - 0.0476190476 * ScrW() --220 - 80
		self.x = self.x + 0.0761904762 * ScrH()--80
		draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderHighlightCol )
		
		--Top Left middle
		self.x = 0.019047619 * ScrW() --32
		self.y = 0.0876190476 * ScrH() --92
		self.xSize = 0.119047619 * ScrW() --200
		draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderCol )	
		self.xSize = 0.080952381 * ScrW() --200 - 64
		self.x = 0.0571428571 * ScrW()--self.x + 64		
		draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderHighlightCol )
		
		--Top Left lower
		self.x = 0.019047619 * ScrW() --32
		self.y = 0.1447619048 * ScrH() --32 + 40 + 20 + 40 + 20
		self.xSize = 0.1023809524 * ScrW() --172
		draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderCol )	
		self.xSize = 0.0285714286 * ScrW()--48
		self.x = 0.068452381 * ScrW() --self.x + 83		
		draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderHighlightCol )
		
		self.x = 0.025 * ScrW()--32 + 10
		self.y = 0.1638095238 * ScrH() --32 + 20 + 40 + 20 + 40	+ 20
		draw.SimpleTextOutlined( "Laps  "..self.currentLap.."  "..self.lapsToGo, "raceText", self.x, self.y, Color(255,255,255,255) , 0, 1, 2, Color( 0, 0, 0, 255 ) )

		--self.x = 32 + 10 
		self.y = 0.0495238095 * ScrH()--32 + 20		
		draw.SimpleTextOutlined( "Race "..SCar_ConvertTimeToString( CurTime() - self.raceStartTime ), "raceText", self.x, self.y, Color(255,255,255,255) , 0, 1, 2, Color( 0, 0, 0, 255 ) )
		
		--self.x = 32 + 10
		self.y = 0.106666667 * ScrH()--32 + 40 + 20 + 20
		draw.SimpleTextOutlined( "Lap "..SCar_ConvertTimeToString( CurTime() - self.lapStartTime ), "raceText", self.x, self.y, Color(255,255,255,255) , 0, 1, 2, Color( 0, 0, 0, 255 ) )
			
		if self.showRaceEndTime then

			self.theEndTime = self.raceEndTime - CurTime()
			self.colPercent = self.theEndTime / self.raceMaxEndTime
			draw.SimpleTextOutlined( "Race ends in "..SCar_ConvertTimeToString( self.theEndTime ), "raceCountDownText", ScrW()*0.5, ScrH()*0.5, Color(255, 255*self.colPercent, 255*self.colPercent, 150) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, 150 ) )
		end
		

		for i = 1, SCarRaceHud.NrOfRacers do
			self.xSize = ScrW() * 0.11875
			self.ySize = ScrH() * 0.0390625
			self.x = ScrW() - self.xSize - ScrW() * 0.02
			self.y = 0.03125 * ScrH() + (i-1) * 0.046875 * ScrH()
			draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderCol )

			self.xSize = 0.025 * ScrW()
			self.ySize = 0.0390625 * ScrH()
			--self.x = ScrW() - 0.16375 * ScrW()
			self.x = 0.83625 * ScrW()
			self.y = 0.03125 * ScrH() + (i-1) * 0.046875 * ScrH() --
			draw.RoundedBox( 0, self.x, self.y, self.xSize, self.ySize, self.borderHighlightCol )	
			
			self.x = self.x + 0.008125 * ScrW()
			self.y = self.y + 0.01953125 * ScrH()
			draw.SimpleTextOutlined( i , "raceText", self.x, self.y, Color(255,255,255,255) , 0, 1, 2, Color( 0, 0, 0, 255 ) )
			
			self.x = self.x + 0.021875 * ScrW()
			draw.SimpleTextOutlined( SCarRaceHud.RacePositions[i] , "raceText", self.x, self.y, Color(255,255,255,255) , 0, 1, 2, Color( 0, 0, 0, 255 ) )
		end
		
	else
		if self.firstTimeShow == true then
			self:StopRaceMusic()
			self.firstTimeShow = false
		end
	end
	

end
hook.Add( "HUDPaint", "DrawSCarRaceHUD", SCarRaceHud.DrawHud )



function SCarRaceHud.DrawArrow()
	if !IsValid(LocalPlayer()) or LocalPlayer() and !LocalPlayer():Alive() then return end

	if IsValid(LocalPlayer():GetVehicle()) and SCarClientData["scar_usecheckarrow"] == true and SCarRaceHud.showRaceHud then
		local self = SCarRaceHud
		local ang = SCarViewManager.saveTransAng:Forward() * -1
		ang = ang:Angle()
		local pos = SCarViewManager.savePos + SCarViewManager.saveTransAng:Forward() * 5 + ang:Up() * -2.3
		
		
		ang:RotateAroundAxis( ang:Up(), 90)
		ang:RotateAroundAxis( ang:Forward(), 20)
		
		local pointAng = LocalPlayer():GetPos() - self.arrowPos
		pointAng = pointAng:Angle()
		local diff = math.AngleDifference(  pointAng.y, SCarViewManager.saveTransAng.y)
		diff = diff + 180
	
		self.curArrowDir = math.ApproachAngle( self.curArrowDir, diff, (self.curArrowDir - diff) * FrameTime() )

		
		cam.Start3D2D( pos, ang, 1)	
			surface.SetDrawColor( 100, 100, 100, 255 )
			surface.SetTexture( self.ArrowTex2 )
			--surface.DrawTexturedRectRotated( 0 , 0, 1, 1, self.curArrowDir )	
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture( self.ArrowTex )
			surface.DrawTexturedRectRotated( 0 , 0, 1, 1, self.curArrowDir )			
		cam.End3D2D()		
	end
		
	
end
hook.Add("PostDrawTranslucentRenderables", "SCarRaceHudDrawArrow", SCarRaceHud.DrawArrow )


--If the hud should be rendered
function SCarRaceHud.SCarShowHud( data )
	SCarRaceHud.showRaceHud = data:ReadBool()
	
	if SCarRaceHud.showRaceHud == false then
		SCarRaceHud.currentLap = 0
		SCarRaceHud.lapsToGo = 0
		SCarRaceHud.totalTime = 0
		SCarRaceHud.lapTime = 0
		SCarRaceHud.raceStartTime = 0
		SCarRaceHud.lapStartTime = 0
		SCarRaceHud.raceEndTime = 0
		SCarRaceHud.showRaceEndTime = false	
		SCarRaceHud.showArrow = false
	end
end
usermessage.Hook( "SCarShowHud", SCarRaceHud.SCarShowHud )

--The current lap we're on
function SCarRaceHud.SCarSetCurrentLap( data )
	SCarRaceHud.currentLap = data:ReadShort()
end
usermessage.Hook( "SCarSetCurrentLap", SCarRaceHud.SCarSetCurrentLap )

function SCarRaceHud.GetRaceEndCountDown( data )
	SCarRaceHud.raceMaxEndTime = data:ReadShort()
	SCarRaceHud.raceEndTime = CurTime() + SCarRaceHud.raceMaxEndTime
	SCarRaceHud.showRaceEndTime = true
end
usermessage.Hook( "SetRaceEndCountDown", SCarRaceHud.GetRaceEndCountDown )

--Total number of laps
function SCarRaceHud.SCarSetLapsToGo( data )
	SCarRaceHud.lapsToGo = data:ReadShort()
end
usermessage.Hook( "SCarSetLapsToGo", SCarRaceHud.SCarSetLapsToGo )

--The time in seconds when the race started ( CurTime() )
function SCarRaceHud.SCarSetStartTime( data )
	SCarRaceHud.raceStartTime = data:ReadLong()
end
usermessage.Hook( "SCarSetStartTime", SCarRaceHud.SCarSetStartTime )

--The time in seconds when the lap started ( CurTime() ) 
--This will reset each time the player finishes a lap
function SCarRaceHud.SCarSetStartLapTime( data )
	SCarRaceHud.lapStartTime = data:ReadLong()
end
usermessage.Hook( "SCarSetStartLapTime", SCarRaceHud.SCarSetStartLapTime )

function SCarRaceHud.GetNextArrowPoint( data )
	SCarRaceHud.showArrow = data:ReadBool()
	SCarRaceHud.arrowPos = data:ReadVector()
end
usermessage.Hook( "SetArrowPointFromServer", SCarRaceHud.GetNextArrowPoint )

function SCarRaceHud.GetRacePositions( data )

	local str = data:ReadString()
	SCarRaceHud.RacePositions = string.Explode("¤", str)
	SCarRaceHud.NrOfRacers = table.Count( SCarRaceHud.RacePositions ) - 1

	for i = 1, SCarRaceHud.NrOfRacers do
		if string.len( SCarRaceHud.RacePositions[i] ) > 11 then
			SCarRaceHud.RacePositions[i] = string.sub(SCarRaceHud.RacePositions[i], 0, 11)..".."
		end
	end

end
usermessage.Hook( "SCarSetRacePositions", SCarRaceHud.GetRacePositions )