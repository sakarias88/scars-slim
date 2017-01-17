local Font_raceMessageText = {}
Font_raceMessageText.font = "Mister Belvedere"
Font_raceMessageText.size = ScreenScale(40)
Font_raceMessageText.weight = 400
Font_raceMessageText.blursize = 0
Font_raceMessageText.scanlines = 0
Font_raceMessageText.antialias = true
Font_raceMessageText.additive = false
Font_raceMessageText.underline = false
Font_raceMessageText.italic  = false
Font_raceMessageText.strikeout = false
Font_raceMessageText.symbol  = false
Font_raceMessageText.rotary = false
Font_raceMessageText.shadow = false
Font_raceMessageText.outline = false
surface.CreateFont("raceMessageText", Font_raceMessageText )
--surface.CreateFont("Mister Belvedere", ScreenScale(40), 400, true, false, "raceMessageText")

local message = ""
local messages = {}
local messageStartDel = 2
local messageStayDel = 1
local messageEndDel = 1
local messageStage = 0
local messageTime =  CurTime()
local isWideScreen = true
local noInterruptDel = CurTime()

local startPosX = 0
local startPosY = 0
local newPosX = 0
local newPosY = 0
local percent = 0
local col = Color(255,255,255,255)

local sepSign = "@"
local theTime = 0
local forceShowMessage = false
local lastId = 0




function SCarRaceMesasge_DrawHud() 
	
	if LocalPlayer().Alive and !LocalPlayer():Alive() then return end
	if(LocalPlayer().GetActiveWeapon and (LocalPlayer():GetActiveWeapon() == NULL or LocalPlayer():GetActiveWeapon() == "Camera")) then return end		
	if GetViewEntity():GetClass() == "gmod_cameraprop" then return end
	
	local veh = LocalPlayer():GetVehicle()
	local ply = LocalPlayer()	
	

	if (IsValid(veh) or forceShowMessage == true) && messageStage >= 1 then
		--Checking if the user have a widescreen res or not.
		isWideScreen = true
		
		if (ScrW() / ScrH()) <= (4 / 3) then
			isWideScreen = false
		end	
	
		if messageStage == 1 then
			percent = ((messageTime - CurTime()) / messageStartDel)
			col = Color(255,255,255, ((1-math.Clamp( percent, 0, 1 )) * 255))
		elseif messageStage == 2 then
			percent = ((messageTime - CurTime()) / messageStayDel)			
			col = Color(255,255,255,255)
		elseif messageStage == 3 then
			percent = ((messageTime - CurTime()) / messageEndDel)
			col = Color(255,255,255, (math.Clamp( percent, 0, 1 ) * 255))
		end
	
		newPosX = (ScrW() / 2) 
		newPosY = (ScrH() / 2)		
	
		if lastId == 1 or lastId == 2 then
			newPosX = (ScrW() / 2) 
			newPosY = (ScrH() / 10)			
		end
	
		if percent <= 0 then
			messageStage = messageStage + 1
			
			if messageStage == 2 then
				messageTime = CurTime() + messageStayDel
			elseif messageStage == 3 then
				messageTime = CurTime() + messageEndDel
			elseif messageStage > 3 then 
				messageStage = 0
				forceShowMessage = false
			end
			
		end
		
		for k, v in ipairs(messages) do
			draw.SimpleTextOutlined( v, "raceMessageText", newPosX, (newPosY + (k-1) * ScreenScale(30)), col, 1, 1, 2, Color( 0, 0, 0, 255 ) )
		end	

	else
		messageStage = 0
	end

end

hook.Add( "HUDPaint", "SCarRaceMesasge_DrawHud", SCarRaceMesasge_DrawHud )


--UserMessages
function GetSCarRaceMessageFromServer( data )
	if noInterruptDel <= CurTime() or id == 6 then
		message = data:ReadString()
		local id = data:ReadShort()
		messageStage = 1
		
		startPosX = 0
		startPosY = ScrH()
		
		
		
		if id == 1 then
			LocalPlayer():EmitSound("buttons/button17.wav",100,100)
			message = SCar_ConvertTimeToString(data:ReadFloat())
		elseif id == 2 then
			LocalPlayer():EmitSound("buttons/button17.wav",100,50)
			message = "Lap "..SCar_ConvertTimeToString(data:ReadFloat())
		elseif id == 3 then
			LocalPlayer():EmitSound("car/raceSignal.mp3",100,100)
			message = "Finish "..SCar_ConvertTimeToString(data:ReadFloat())
		elseif id == 4 then
			LocalPlayer():EmitSound("car/raceSignal.mp3",100,200)
			forceShowMessage = true
		elseif id == 5 then
			forceShowMessage = true
		elseif id == 6 then
			forceShowMessage = true
			message = "Back up!@Too close to starting line!"
			noInterruptDel = CurTime() + 1
		end	
		
		messageTime =  CurTime() + messageStartDel
		messages = string.Explode(sepSign, message)	
		
		lastId = id
	end
end
usermessage.Hook( "GetSCarRaceMessageFromServer", GetSCarRaceMessageFromServer )


