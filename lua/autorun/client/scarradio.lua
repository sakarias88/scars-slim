
SCarRadioManager = {}
SCarRadioManager.NrOfChannels = 0
SCarRadioManager.ChannelName = {}
SCarRadioManager.ChannelURL = {}
SCarRadioManager.retry = false

SCarRadioManager.DefaultRadios = [[
BassDrive¤http://www.radiotower.com/player.php?channel_id=2162
ANOMALY RADIO Network¤http://www.radiotower.com/player.php?channel_id=12634
Z100Internet¤http://www.radiotower.com/player.php?channel_id=17815
CFRM - 100.7 FM¤http://www.radiotower.com/player.php?channel_id=2199
APS Radio¤http://www.radiotower.com/player.php?channel_id=16751
ClanBase Radio¤http://www.radiotower.com/player.php?channel_id=11742
WKXL 1450 AM¤http://www.radiotower.com/player.php?channel_id=5577
Police Stories on AM 1710 Antioch¤http://tunein.com/radio/Police-Stories-p143064/?popout=true
]]


function SCarRadioManager:ReadChannelsFromFile()

	local canDo = false
	canDo = file.Exists( "scarradiochannels.txt", "DATA" )

	if canDo then
		local cont = {}
		cont = file.Read( "scarradiochannels.txt", "DATA" )
		
		if cont == nil then
			SCarsReportError("Radio file exists but it has no real content? Writing default radio file!", 150)
			file.Write( "scarradiochannels.txt", SCarRadioManager.DefaultRadios)
			cont = file.Read( "scarradiochannels.txt", "DATA" )
			
			if cont == nil then
				SCarsReportError("Writing the default radio file and reading it didn't work. Not allowed to read/write files?", 255)
				return
			end
		end
		
		local channels = string.Explode(string.char(10), cont)

		for k,v in pairs(channels) do
			local chanAndURL = string.Explode("¤", v)
			
			if 	table.Count( chanAndURL ) == 2 then
				SCarRadioManager:AddChannel( chanAndURL[1], chanAndURL[2] )
			end
		end
		
	else
		if SCarRadioManager.retry == false then
			SCarRadioManager.retry = true

			file.Write( "scarradiochannels.txt", SCarRadioManager.DefaultRadios)
			SCarRadioManager:ReadChannelsFromFile()
		end
	end
end

function SCarRadioManager:GetChannelID( name )
	for i = 1, SCarRadioManager.NrOfChannels do
		if SCarRadioManager.ChannelName[i] == name then return i end
	end
	
	return 0
end

function SCarRadioManager:AddChannel( name, URL )
	if SCarRadioManager:GetChannelID( name ) == 0 then
		SCarRadioManager.NrOfChannels = SCarRadioManager.NrOfChannels + 1
		SCarRadioManager.ChannelName[SCarRadioManager.NrOfChannels] = name
		SCarRadioManager.ChannelURL[SCarRadioManager.NrOfChannels] = URL
		
		return true
	end
	
	return false
end

function SCarRadioManager:RemoveChannel( name )
	local id = SCarRadioManager:GetChannelID( name )
	if id != 0 then
		SCarRadioManager.ChannelName[id] = SCarRadioManager.ChannelName[SCarRadioManager.NrOfChannels]
		SCarRadioManager.ChannelURL[id] = SCarRadioManager.ChannelURL[SCarRadioManager.NrOfChannels]
		SCarRadioManager.NrOfChannels = SCarRadioManager.NrOfChannels - 1
	end
end

function SCarRadioManager:SaveChannelsToFile()
	local fileStr = ""
	
	for i = 1, SCarRadioManager.NrOfChannels do
		fileStr = fileStr..SCarRadioManager.ChannelName[i].."¤"..SCarRadioManager.ChannelURL[i].."\n"
	end
	file.Write( "scarradiochannels.txt", fileStr)
end

function SCarRadioManager:GetUrlFromName( name )
	local id = SCarRadioManager:GetChannelID( name )
	
	if id != 0 then
		return SCarRadioManager.ChannelURL[id]
	end
	
	return ""
end

function SCarRadioManager:GetNrOfChannels()
	return SCarRadioManager.NrOfChannels
end

function SCarRadioManager:GetNameTable()
	return SCarRadioManager.ChannelName
end

function SCarRadioManager:GetURLTable() 
	return SCarRadioManager.ChannelURL
end

SCarRadioManager:ReadChannelsFromFile()




ScarRadio = {}

local Font_DigitalRadio = {}
Font_DigitalRadio.font = "DS-Digital"
Font_DigitalRadio.size = (ScrH() * 0.03333333)
Font_DigitalRadio.weight = 200
Font_DigitalRadio.blursize = 0
Font_DigitalRadio.scanlines = 0
Font_DigitalRadio.antialias = false
Font_DigitalRadio.additive = false
Font_DigitalRadio.underline = false
Font_DigitalRadio.italic  = false
Font_DigitalRadio.strikeout = false
Font_DigitalRadio.symbol  = false
Font_DigitalRadio.rotary = false
Font_DigitalRadio.shadow = false
Font_DigitalRadio.outline = false
surface.CreateFont("DigitalRadio", Font_DigitalRadio )
--surface.CreateFont( "DS-Digital", (ScrH() * 0.03333333), 200, 0, 0, "DigitalRadio")

--Radio
ScarRadio.isInChat = false
ScarRadio.turnOnTime = 0.5
ScarRadio.oldRadioChan = 2
ScarRadio.ignoreChange = 0
ScarRadio.radioFrame = surface.GetTextureID("SCarHUD/radiobg")
ScarRadio.radioAlpha = 0
ScarRadio.radioFadeOutTime = 2
ScarRadio.radioStay = 1
ScarRadio.radioFadeInTime = 1
ScarRadio.radioFadeOutDel = CurTime() 
ScarRadio.radioFadeInDel = CurTime() 
ScarRadio.radioStayDel = CurTime()
ScarRadio.turnOnDelay = CurTime()
ScarRadio.isOn = false
ScarRadio.PrevOrNext = false
ScarRadio.ForceSetChannel = false
	ScarRadio.isWideScreen = true
	ScarRadio.ForceChannelName = ""
		
	
	
	ScarRadio.stackStart = 1
	ScarRadio.stackEnd = 1
	ScarRadio.chanStack = {}
	ScarRadio.chanPos = {}
	
	ScarRadio.StackDest = 0

	ScarRadio.fadeOutTime = 5
	ScarRadio.fadeOutDel = CurTime()

	ScarRadio.keyPress = false
	ScarRadio.initiateTable = false
	ScarRadio.changeDel = CurTime()
	ScarRadio.maxChan = SCarRadioManager:GetNrOfChannels()
	ScarRadio.chanNr = 1
	ScarRadio.SmoothChanNr = 1
	
	ScarRadio.cleared = false
	ScarRadio.changeOnce = false
	ScarRadio.Channel = nil

	ScarRadio.tune = nil
	ScarRadio.initiate = false


	ScarRadio.channelLinks = {}
	ScarRadio.channelLinks[1] = ""
	
	local tableChan = SCarRadioManager:GetURLTable() 
	for i = 1, ScarRadio.maxChan do
		ScarRadio.channelLinks[i + 1] = tableChan[i]
	end

	ScarRadio.channelNames = {}
	ScarRadio.channelNames[1] = "Radio OFF"
	local tableChan = SCarRadioManager:GetNameTable() 
	for i = 1, ScarRadio.maxChan do
		ScarRadio.channelNames[i + 1] = tableChan[i]
	end
	
	
	ScarRadio.maxChan = ScarRadio.maxChan + 1


	
ScarRadio.OldName = ScarRadio.channelNames[ScarRadio.chanNr]


function ScarRadio:RefreshChannelList()

	ScarRadio.tune:Stop()
	ScarRadio.isOn = false
	ScarRadio.ForceSetChannel = false
	ScarRadio.changeDel = CurTime() + 1		
	ScarRadio.changeOnce = false	

	if ScarRadio.Channel then
		ScarRadio.Channel:Remove()
		ScarRadio.Channel = nil
	end	

	ScarRadio.maxChan = SCarRadioManager:GetNrOfChannels()

	ScarRadio.channelLinks = {}
	ScarRadio.channelLinks[1] = ""

	local tableChan = SCarRadioManager:GetURLTable() 
	for i = 1, ScarRadio.maxChan do
		ScarRadio.channelLinks[i + 1] = tableChan[i]
	end

	ScarRadio.channelNames = {}
	ScarRadio.channelNames[1] = "Radio OFF"
	local tableChan = SCarRadioManager:GetNameTable() 
	for i = 1, ScarRadio.maxChan do
		ScarRadio.channelNames[i + 1] = tableChan[i]
	end
	
	ScarRadio.maxChan = ScarRadio.maxChan + 1
	
	ScarRadio.chanNr = 1
	ScarRadio.SmoothChanNr = 1
	ScarRadio.ignoreChange = 1
	
	local ply = LocalPlayer()
	local veh = ply:GetVehicle()
	local isSCarVeh = 0

	if ply:InVehicle() && IsValid( veh ) then
		isSCarVeh = veh:GetNetworkedInt( "SCarSeat" ) 
	end	
	
	if isSCarVeh == 1 then
		RunConsoleCommand( "scar_setradiochannel", ScarRadio.channelNames[ScarRadio.chanNr], "")
	end
end
	
function ScarRadio:RadioThink()
	if ScarRadio.isInChat == false then
		local ply = LocalPlayer()
		local veh = ply:GetVehicle()
		local isSCarVeh = 0

		if ply:InVehicle() && IsValid( veh ) then
			isSCarVeh = veh:GetNetworkedInt( "SCarSeat" ) 
		end

		if ScarRadio.initiate == false then
			ScarRadio.initiate = true
			ScarRadio.tune = CreateSound(ply,"car/radio.wav")
		end
		
		
		if isSCarVeh >= 1 then
		
			--If we enter a car we should start the radio
			if ScarRadio.cleared == true then
				
				
				if ScarRadio.chanNr == 1 then 
					ScarRadio.isOn = false
					ScarRadio.OldName = ScarRadio.channelNames[ScarRadio.chanNr]
					
					if isSCarVeh == 1 then
						RunConsoleCommand( "scar_setradiochannel", ScarRadio.channelNames[ScarRadio.chanNr], "")
					end
				else
					ScarRadio.isOn = true
				end
				
				if ScarRadio.chanNr > ScarRadio.maxChan then ScarRadio.chanNr = 2 end
				
				if ScarRadio.Channel then
					ScarRadio.Channel:Remove()
					ScarRadio.Channel = nil
				end		
				
				if ScarRadio.chanNr != 1 and ScarRadio.channelLinks[ScarRadio.chanNr] then
	
					
					ScarRadio.Channel = vgui.Create("HTML")
					ScarRadio.Channel:SetPos(-10,-10)
					ScarRadio.Channel:SetSize( 10, 10 )
					ScarRadio.Channel:OpenURL(ScarRadio.channelLinks[ScarRadio.chanNr])
					ScarRadio.ForceSetChannel = false

					if isSCarVeh == 1 then
						RunConsoleCommand( "scar_setradiochannel", ScarRadio.channelNames[ScarRadio.chanNr], ScarRadio.channelLinks[ScarRadio.chanNr] )	
					end
					
				end
				if ScarRadio.chanNr != 1 then
					ScarRadio.OldName = "¤"
				end
			end		
		
		
		

			if ScarRadio.maxChan > 1 and (SCarKeys:GetKeyStatus("RadioNext") == 1 or SCarKeys:GetKeyStatus("RadioPrev") == 1) and ScarRadio.keyPress == false then
				ScarRadio.keyPress = true
				ScarRadio.turnOnDelay = CurTime() + ScarRadio.turnOnTime
				
				if SCarKeys:GetKeyStatus("RadioNext") == 1 then
					SCarKeys.PrevOrNext = true
				else
					SCarKeys.PrevOrNext = false
				end
				
				
			elseif ((SCarKeys:GetKeyStatus("RadioNext") == 0 and SCarKeys.PrevOrNext == true) or (SCarKeys:GetKeyStatus("RadioPrev") == 0 and SCarKeys.PrevOrNext == false)) and ScarRadio.keyPress == true then
				ScarRadio.keyPress = false
				ScarRadio.turnOnDelay = 0
				
				
				if ScarRadio.isOn == true && ScarRadio.ignoreChange <= 0 then
					ply:EmitSound("buttons/lightswitch2.wav")
					
					if ScarRadio.changeDel < CurTime() then
						ScarRadio.tune:Stop()
						ScarRadio.tune:Play()
					end
				
					ScarRadio.changeDel = CurTime() + 2							
					ScarRadio.changeOnce = true

					if SCarKeys.PrevOrNext == true then
						ScarRadio.chanNr = ScarRadio.chanNr + 1
						if ScarRadio.chanNr > ScarRadio.maxChan then ScarRadio.chanNr = 2 end	
					else
						ScarRadio.chanNr = ScarRadio.chanNr - 1
						if ScarRadio.chanNr < 2 then ScarRadio.chanNr = ScarRadio.maxChan end
					end
				end	
				ScarRadio.ignoreChange = ScarRadio.ignoreChange - 1			
			end
			
			if ScarRadio.turnOnDelay < CurTime() && ScarRadio.keyPress == true then
				ScarRadio.turnOnDelay = CurTime() + ScarRadio.turnOnTime
				if ScarRadio.isOn == true then
					ScarRadio.isOn = false
					ScarRadio.oldRadioChan = ScarRadio.chanNr
					ScarRadio.chanNr = 1
					
					if ScarRadio.Channel then
						ScarRadio.Channel:Remove()
						ScarRadio.Channel = nil
					end	

					if isSCarVeh == 1 then
						RunConsoleCommand( "scar_setradiochannel", ScarRadio.channelNames[ScarRadio.chanNr], "")	
					end
				else
					ScarRadio.changeOnce = true
					ScarRadio.chanNr = ScarRadio.oldRadioChan
					ScarRadio.isOn = true
					ScarRadio.ignoreChange = 1
				end
				ScarRadio.OldName = ""
				ply:EmitSound("buttons/lightswitch2.wav")
			end
			
			
		
			--Changeing channel
			if ScarRadio.changeOnce == true && ScarRadio.changeDel < CurTime() and ScarRadio.channelLinks[ScarRadio.chanNr] then
				ScarRadio.changeOnce = false
				ScarRadio.tune:Stop()

				if ScarRadio.Channel then
					ScarRadio.Channel:Remove()
					ScarRadio.Channel = nil
				end

				
				ScarRadio.Channel = vgui.Create("HTML")
				ScarRadio.Channel:SetPos(-10,-10)
				ScarRadio.Channel:SetSize( 10, 10 )
				ScarRadio.Channel:OpenURL(ScarRadio.channelLinks[ScarRadio.chanNr])
				if isSCarVeh == 1 then
					RunConsoleCommand( "scar_setradiochannel", ScarRadio.channelNames[ScarRadio.chanNr], ScarRadio.channelLinks[ScarRadio.chanNr] )	
				end	
				ScarRadio.ForceSetChannel = false
			
			end
			
			ScarRadio.cleared = false
			
		else
			--If we leave the car we should turn the radio off and fix the radio fading
			if ScarRadio.cleared == false then
			
				ScarRadio.tune:Stop()
				
				ScarRadio.changeDel = 0
				ScarRadio.changeOnce = false
				ScarRadio.cleared = true
				
				if ScarRadio.Channel then
					ScarRadio.Channel:Remove()
					ScarRadio.Channel = nil
				end

				--Radio fade fix
				if ScarRadio.radioFadeInDel > CurTime() then
					
					local percent = (1 - ((ScarRadio.radioFadeInDel - CurTime()) / ScarRadio.radioFadeInTime))
					ScarRadio.radioFadeOutDel = CurTime() + ScarRadio.radioFadeOutTime * percent
				
					ScarRadio.radioFadeInDel = CurTime()
					ScarRadio.radioStayDel = CurTime()			
				elseif ScarRadio.radioStayDel > CurTime() then
					ScarRadio.radioFadeInDel = CurTime()
					ScarRadio.radioStayDel = CurTime()
					ScarRadio.radioFadeOutDel = CurTime() + ScarRadio.radioFadeOutTime
				end
			end			
		end
	end
end
hook.Add("Think","ScarRadioThink", ScarRadio.RadioThink)


function ScarRadio.DrawHud()
	local ply = LocalPlayer()
	local veh = ply:GetVehicle()

	local isSCarVeh = 0
	local scarEnt = NULL
	
	if IsValid( veh ) then
		isSCarVeh = veh:GetNetworkedInt( "SCarSeat" )
		scarEnt = veh:GetNetworkedEntity("SCarEnt") //Only apply this effect if we are in a seat that was created by a SCar
	end
		
	if IsValid(scarEnt) and isSCarVeh >= 1 then
	
		if ScarRadio.ForceSetChannel == false and ScarRadio.channelNames[ScarRadio.chanNr] != ScarRadio.OldName or (ScarRadio.ForceSetChannel == true and ScarRadio.ForceChannelName != ScarRadio.OldName) then
		
			if ScarRadio.ForceSetChannel == false then
				ScarRadio.OldName = ScarRadio.channelNames[ScarRadio.chanNr]
			else
				ScarRadio.OldName = ScarRadio.ForceChannelName
			end
			
			if ScarRadio.radioFadeInDel < CurTime() && ScarRadio.radioStayDel > CurTime() then 
				ScarRadio.radioFadeInDel = CurTime()
				
			elseif ScarRadio.radioFadeInDel < CurTime() && ScarRadio.radioStayDel < CurTime() && ScarRadio.radioFadeOutDel > CurTime() then
				ScarRadio.radioFadeInDel = CurTime() + ScarRadio.radioFadeInTime * (1 - ((ScarRadio.radioFadeOutDel - CurTime()) / ScarRadio.radioFadeOutTime))		
				
			elseif ScarRadio.radioFadeInDel < CurTime() && ScarRadio.radioStayDel < CurTime() && ScarRadio.radioFadeOutDel < CurTime() then
				ScarRadio.radioFadeInDel = CurTime() + ScarRadio.radioFadeInTime
				
			end
			
			ScarRadio.radioStayDel = CurTime() + ScarRadio.radioFadeInTime + ScarRadio.radioStay
			ScarRadio.radioFadeOutDel = CurTime() + ScarRadio.radioFadeInTime + ScarRadio.radioStay + ScarRadio.radioFadeOutTime
		end
		
		if ScarRadio.radioFadeOutDel > CurTime() then
		
			
		
			if (ScrW() / ScrH()) <= (4 / 3) then
				ScarRadio.isWideScreen = false
			else
				ScarRadio.isWideScreen = true
			end		
		
			local alpha = 0
			
			if ScarRadio.radioFadeInDel > CurTime() then
				alpha = 255 * (1 - ((ScarRadio.radioFadeInDel - CurTime()) / ScarRadio.radioFadeInTime))
			elseif ScarRadio.radioStayDel > CurTime() then
				alpha = 255
			elseif ScarRadio.radioFadeOutDel > CurTime() then
				alpha = 255 * ((ScarRadio.radioFadeOutDel - CurTime()) / ScarRadio.radioFadeOutTime)
			end

			local xSize = 0
			local ySize = 0
			
			if ScarRadio.isWideScreen == true then
				xSize = ScrW() * 0.3047619048 --512
				ySize = ScrH() * 0.060952381 --64
			else
				xSize = ScrW() * 0.3047619048 --512
				ySize = ScrH() * 0.0594430839 --64			
			end
				
			local xPos = ScrW() * 0.5 - ( xSize * 0.5 )
			local yPos = ySize - ySize * 0.5

		
			surface.SetTexture( ScarRadio.radioFrame )
			surface.SetDrawColor( 150, 150, 150, alpha )	
			surface.DrawTexturedRect( xPos, yPos, xSize, ySize )	

			xPos = ScrW() * 0.5
			yPos = ScrH() * 0.073
			
			if ScarRadio.ForceSetChannel == false then
			
				ScarRadio.SmoothChanNr = math.Approach( ScarRadio.SmoothChanNr, ScarRadio.chanNr, (ScarRadio.chanNr - ScarRadio.SmoothChanNr) * 0.05 )			
				local middle = math.floor(ScarRadio.SmoothChanNr)
				local front = middle + 1
				if front > ScarRadio.maxChan then front = 2 end

				local tmpPer = (ScarRadio.SmoothChanNr - middle)

				draw.SimpleText( ScarRadio.channelNames[middle], "DigitalRadio", xPos - (tmpPer * 150), yPos , Color( 255, 255, 255, (1-tmpPer) * 255 * (alpha / 255)  ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				
				if ScarRadio.maxChan > 1 then
					draw.SimpleText( ScarRadio.channelNames[front], "DigitalRadio", 150 + xPos - (tmpPer * 150), yPos , Color( 255, 255, 255, tmpPer * 255 * (alpha / 255) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				end
			else
				draw.SimpleText( ScarRadio.OldName, "DigitalRadio", xPos, yPos , Color( 255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			end

		end
	end
end
hook.Add( "HUDPaint", "DrawSCarRadioHUD", ScarRadio.DrawHud )

function ScarRadio:ForceSetStation( name, url )
	ScarRadio.changeOnce = false
	ScarRadio.tune:Stop()

	if ScarRadio.Channel then
		ScarRadio.Channel:Remove()
		ScarRadio.Channel = nil
	end

	ScarRadio.Channel = vgui.Create("HTML")
	ScarRadio.Channel:SetPos(-10,-10)
	ScarRadio.Channel:SetSize( 10, 10 )
	ScarRadio.Channel:OpenURL(url)
	ScarRadio.ForceChannelName = name
	ScarRadio.ForceSetChannel = true
	ScarRadio.isOn = true
end
	
local function StartChat(TeamSay)
	ScarRadio.isInChat = true
end
hook.Add("StartChat", "SCarIngorKeysStart2", StartChat)

local function StopChat(TeamSay)
	ScarRadio.isInChat = false
end
hook.Add("FinishChat", "SCarIngorKeysFinish2", StopChat)

local function GetSCarRadioFromServer( data, str )

	local ply = LocalPlayer()
	local veh = ply:GetVehicle()
	local isSCarVeh = 0
	local scarEnt = veh:GetNetworkedEntity("SCarEnt")
	
	if ply:InVehicle() && IsValid( veh ) && IsValid(scarEnt) then
		isSCarVeh = veh:GetNetworkedInt( "SCarSeat" ) 
	end
		
		
	if isSCarVeh > 1 then
		local can = GetConVarNumber( "scar_shareradiostation" )
		message = data:ReadString()
			
		if can == 1 then
			local tabl = string.Explode("¤", message)
			ScarRadio:ForceSetStation( tabl[1], tabl[2] )
		end
	end
end
usermessage.Hook( "GetSCarRadioFromServer", GetSCarRadioFromServer )


