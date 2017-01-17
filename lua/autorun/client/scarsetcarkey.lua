
--[[
//0=KeyUp
//1=KeyPressed
//2=KeyDown
//3=KeyReleased
--]]

--1 Toggle hydraulics
--2 Hydraulics
--3 Toggle headlights
--4 Toggle View
--5 Radio Next
--6 Radio Prev
--7 Horn
--8 Flip Car


SCarKeys.BoundKeyEvents = {}
SCarKeys.LastBoundKeyEvent = {}
SCarKeys.BoundKeyEventsID = {}
SCarKeys.keyTransTable = {}


SCarKeys.PanelListener = nil
SCarKeys.PanelID = 0
SCarKeys.KeyEvents = {}
SCarKeys.isInChat = false
SCarKeys.ply = nil
SCarKeys.veh = nil
SCarKeys.isScar = 0
SCarKeys.nrOfKeys = 112
SCarKeys.MouseDel = CurTime()
SCarKeys.retry = false
SCarKeys.InvMouse = false


function SCarKeys:ClInit()
	
	--Creating key translation table
	for i = 1, SCarKeys.nrOfKeys do
		if i <= 10 then --Numbers
			SCarKeys.keyTransTable[i] = i - 1
		elseif i > 10 and i <= 36 then --Chars
			SCarKeys.keyTransTable[i] = string.char(i + 54)
		elseif i > 36 and i <= 46 then --Pad numbers
			SCarKeys.keyTransTable[i] = "Pad "..(i - 37)
		elseif i > 91 and i <= 103 then
			SCarKeys.keyTransTable[i] = "F"..(i - 91)
		end
	end	
	
	--Setting some manually
	SCarKeys.keyTransTable[47] = "Pad Divide"
	SCarKeys.keyTransTable[48] = "Pad Multiply"
	SCarKeys.keyTransTable[49] = "Pad Minus"
	SCarKeys.keyTransTable[50] = "Pad Plus"
	SCarKeys.keyTransTable[51] = "Pad Enter"
	SCarKeys.keyTransTable[52] = "Pad Decimal"
	SCarKeys.keyTransTable[53] = "L Bracket"
	SCarKeys.keyTransTable[54] = "R Bracket"
	SCarKeys.keyTransTable[55] = "Semicolon"
	SCarKeys.keyTransTable[56] = "Apostrophe"
	SCarKeys.keyTransTable[57] = "Backquote"
	SCarKeys.keyTransTable[58] = "Comma"
	SCarKeys.keyTransTable[59] = "Period"
	SCarKeys.keyTransTable[60] = "Slash"
	SCarKeys.keyTransTable[61] = "Backslash"
	SCarKeys.keyTransTable[62] = "Minus"
	SCarKeys.keyTransTable[63] = "Equal"
	SCarKeys.keyTransTable[64] = "Enter"
	SCarKeys.keyTransTable[65] = "Space"
	SCarKeys.keyTransTable[66] = "Backspace"
	SCarKeys.keyTransTable[67] = "Tab"
	SCarKeys.keyTransTable[68] = "Capslock"
	SCarKeys.keyTransTable[69] = "Numlock"
	SCarKeys.keyTransTable[70] = "Escape"
	SCarKeys.keyTransTable[71] = "Print Screen"
	SCarKeys.keyTransTable[72] = "Insert"
	SCarKeys.keyTransTable[73] = "Delete"
	SCarKeys.keyTransTable[74] = "Home"
	SCarKeys.keyTransTable[75] = "End"
	SCarKeys.keyTransTable[76] = "Page Up"
	SCarKeys.keyTransTable[77] = "Page Down"
	SCarKeys.keyTransTable[78] = "Break"
	SCarKeys.keyTransTable[79] = "Shift"
	SCarKeys.keyTransTable[80] = "Shift"
	SCarKeys.keyTransTable[81] = "Alt"
	SCarKeys.keyTransTable[82] = "Alt"
	SCarKeys.keyTransTable[83] = "Ctrl"
	SCarKeys.keyTransTable[84] = "Ctrl"
	SCarKeys.keyTransTable[85] = "Left windows"
	SCarKeys.keyTransTable[86] = "Right windows"
	SCarKeys.keyTransTable[87] = "App"
	SCarKeys.keyTransTable[88] = "Up"
	SCarKeys.keyTransTable[89] = "Left"
	SCarKeys.keyTransTable[90] = "Down"
	SCarKeys.keyTransTable[91] = "Right"
	
	SCarKeys.keyTransTable[107] = "Left Mouse"
	SCarKeys.keyTransTable[108] = "Right Mouse"
	SCarKeys.keyTransTable[109] = "Middle Mouse"
	SCarKeys.keyTransTable[110] = "Mouse 1"
	SCarKeys.keyTransTable[111] = "Mouse 2"
	
	
	SCarKeys:ReadKeysFromFile()

	for i = 1, SCarKeys.nrOfKeys do
		SCarKeys.KeyEvents[i] = 3
	end
	
	SCarKeys:CheckForInvMouse()
end

function SCarKeys:CheckForInvMouse()
	local nr = GetConVarNumber( "m_pitch" )
	
	if nr < 0 then
		SCarKeys.InvMouse = true
	else
		SCarKeys.InvMouse = false
	end
end


function SCarKeys.BuildKeyMenu(Panel)
	Panel:ClearControls()


	local elem = vgui.Create("DLabel",self)
	elem:SetFont("Default")
	elem:SetText("Press backspace or escape to cancel")
	elem:SetColor(Color(255,255,255,255))
	Panel:AddPanel(elem)			
	
	for i = 1, SCarKeys.NrOfBoundKeyEvents do
		elem = vgui.Create( "ScarKey", Panel ) 
		elem:SetKeyText(SCarKeys.KeyName[i])
		elem:SetId(i)
		elem:SetBoundText( SCarKeys:TranslateKey( SCarKeys:GetKeyByID( elem:GetId() )))
		Panel:AddPanel(elem)
	end
	
	local button = vgui.Create( "DButton" ) 
	button:SetSize( 150, 20 )
	button:SetText( "Set to default" )
	button.DoClick = function( button )
		local str = ""
		
		for i = 1, SCarKeys.NrOfBoundKeyEvents do
			str = str..SCarKeys.DefaultKeys[i].."\n"
		end			
		
		file.Write( "scarkeybindings.txt", str )
		SCarKeys:ReadKeysFromFile()
		SCarKeys:RebuildKeys()
	end	
	
	Panel:AddPanel(button)
	SCarKeys:CheckForInvMouse()
end

function SCarKeys:RebuildKeys()

	for i = 1, SCarKeys.NrOfBoundKeyEvents do
		SCarKeys.BoundKeyEventsID[i] = SCarKeys.DefaultKeys[i]
	end

	if file.Exists( "scarkeybindings.txt", "DATA" ) then
		local cont = {}
		cont = file.Read( "scarkeybindings.txt", "DATA" )
		
		
		local keys = string.Explode(string.char(10), cont)
		local nr = table.Count(keys) - 1
		for k,v in pairs(keys) do
			if k <= nr then
				SCarKeys.BoundKeyEvents[k] = 0
				SCarKeys.BoundKeyEventsID[k] = tonumber(v)
			end
		end
		
		for i = nr, SCarKeys.NrOfBoundKeyEvents do
			SCarKeys.BoundKeyEvents[i] = 0
			SCarKeys.BoundKeyEventsID[i] = SCarKeys.DefaultKeys[i]	
		end
	end
	
	--Rebuilding gui
	local CPanel = controlpanel.Get( "SCarControls" )
	if ( !CPanel ) then return end
	CPanel:ClearControls()
	SCarKeys.BuildKeyMenu(CPanel)
	
	SCarKeys:CheckForInvMouse()
end



function SCarKeys:ReadKeysFromFile()

	local canDo = false
	canDo = file.Exists( "scarkeybindings.txt", "DATA" )


	if canDo then
		local cont = {}
		cont = file.Read( "scarkeybindings.txt", "DATA" )
		
		if cont == nil then
			SCarsReportError("SCar keys file exists but it has no real content? Writing default SCar keys file!", 150)
			SCarKeys:WriteDefaultFile()
			cont = file.Read( "scarkeybindings.txt", "DATA" )
			
			if cont == nil then
				SCarsReportError("Writing the default SCar keys file and reading it didn't work. Not allowed to read/write files?", 255)
				return
			end
		end
		
		local keys = string.Explode(string.char(10), cont)

		for k,v in pairs(keys) do
			SCarKeys.BoundKeyEvents[k] = 0
			SCarKeys.BoundKeyEventsID[k] = tonumber(v)
		end
	else
		if SCarKeys.retry == false then
			SCarKeys.retry = true	
			SCarKeys:WriteDefaultFile()
			SCarKeys:ReadKeysFromFile()
		end
	end
end

function SCarKeys:WriteDefaultFile()
	local str = ""
	
	for i = 1, SCarKeys.NrOfBoundKeyEvents do
		str = str..SCarKeys.DefaultKeys[i].."\n"
	end			
	
	file.Write( "scarkeybindings.txt", str )
end

function SCarKeys:TranslateKey( key )
	
	local keyName = SCarKeys.keyTransTable[key]

	if keyName then return keyName end
	
	return "Unknown key"
end

function SCarKeys:WriteKeysToFile()
	local str = ""
	
	for i = 1, SCarKeys.NrOfBoundKeyEvents do
		if SCarKeys.BoundKeyEventsID[i] then
			str = str..SCarKeys.BoundKeyEventsID[i].."\n"
		end
	end
	
	file.Write( "scarkeybindings.txt", str)
	SCarKeys:CheckForInvMouse()
end

function SCarKeys:GetKeyByID( id )
	return SCarKeys.BoundKeyEventsID[id]
end

function SCarKeys:SetListeningPanel( panel )
	if SCarKeys.PanelListener then
		SCarKeys.PanelListener:UnSelect()
	end
	SCarKeys.PanelListener = panel
	SCarKeys.PanelID = panel.id
	SCarKeys.MouseDel = CurTime() + 0.2
	
	for i = 1, SCarKeys.nrOfKeys do
		SCarKeys.KeyEvents[i] = 2
	end	
end


function SCarKeys:GetKeyStatus(key)
	return SCarKeys.BoundKeyEvents[SCarKeys.IdToKeyNameTrans[key]]
end

function SCarKeys:KeyThink()

	if SCarKeys.isInChat == false then


		SCarKeys.ply = LocalPlayer()
		SCarKeys.veh = SCarKeys.ply:GetVehicle()
		SCarKeys.isSCarVeh = 0
		
		if SCarKeys.ply:InVehicle() && IsValid( SCarKeys.veh ) then
			SCarKeys.isSCarVeh = SCarKeys.veh:GetNetworkedInt( "SCarSeat" ) 
		end
		

		if SCarKeys.isSCarVeh >= 1 then	
	
			for i = 1, SCarKeys.NrOfBoundKeyEvents do
			
				local func = input.IsKeyDown
				
				if SCarKeys.BoundKeyEventsID and SCarKeys.BoundKeyEventsID[i] and SCarKeys.BoundKeyEventsID[i] >= 107 then
					func = input.IsMouseDown 
				end		
			
			
				if( SCarKeys.BoundKeyEventsID[i] and func(SCarKeys.BoundKeyEventsID[i])) then
					
					if( SCarKeys.BoundKeyEvents[i] == 0 ) then 
						SCarKeys.BoundKeyEvents[i] = 1
					elseif( SCarKeys.BoundKeyEvents[i] == 1 ) then 
						SCarKeys.BoundKeyEvents[i] = 2
					elseif( SCarKeys.BoundKeyEvents[i] == 3 ) then 
						SCarKeys.BoundKeyEvents[i] = 1 
					end
				else
					if( SCarKeys.BoundKeyEvents[i] == 1 ) then 
						SCarKeys.BoundKeyEvents[i] = 3
					elseif ( SCarKeys.BoundKeyEvents[i] == 2 ) then 
						SCarKeys.BoundKeyEvents[i] = 3
					elseif ( SCarKeys.BoundKeyEvents[i] == 3 ) then 
						SCarKeys.BoundKeyEvents[i] = 0					
					end
				end	

			
				if SCarKeys.KeyIsNetworked[i] and SCarKeys.LastBoundKeyEvent[i] != SCarKeys.BoundKeyEvents[i] and SCarKeys.BoundKeyEvents[i] >= 1 then
					
					RunConsoleCommand( "SetSCarPlayerSCarKey", i,SCarKeys.BoundKeyEvents[i] )
					SCarKeys.LastBoundKeyEvent[i] = SCarKeys.BoundKeyEvents[i]
				end			
			end
		end
	end
end
hook.Add("Think","ScarKeyThink", SCarKeys.KeyThink)


function SCarKeys:KeyPanelThink()

	if SCarKeys.PanelListener and SCarKeys.isInChat == false then
		for i = 1, SCarKeys.nrOfKeys do
		
			local func = input.IsKeyDown
			
			if i >= 107 then
				if SCarKeys.MouseDel > CurTime() then return end
				func = input.IsMouseDown 
			end
			
	
			
			if( func(i)) then
				
				if( SCarKeys.KeyEvents[i] == 0 ) then 
					SCarKeys.KeyEvents[i] = 1
				elseif( SCarKeys.KeyEvents[i] == 1 ) then 
					SCarKeys.KeyEvents[i] = 2
				elseif( SCarKeys.KeyEvents[i] == 3 ) then 
					SCarKeys.KeyEvents[i] = 1 
				end
			else
				if( SCarKeys.KeyEvents[i] == 1 ) then 
					SCarKeys.KeyEvents[i] = 3
				elseif ( SCarKeys.KeyEvents[i] == 2 ) then 
					SCarKeys.KeyEvents[i] = 3
				elseif ( SCarKeys.KeyEvents[i] == 3 ) then 
					SCarKeys.KeyEvents[i] = 0					
				end
			end

			if (i == 70 or i == 66) and SCarKeys.PanelListener and SCarKeys.KeyEvents[i] == 1 then
				SCarKeys.PanelListener:UnSelect()
				SCarKeys.PanelListener = nil
			elseif i != 70 and i != 66 and SCarKeys.PanelListener and SCarKeys.KeyEvents[i] == 1 then --Ignoring escape (70)
				SCarKeys.PanelListener:SetBoundText(SCarKeys:TranslateKey( i ))
				SCarKeys.PanelListener:UnSelect()
				SCarKeys.BoundKeyEvents[i] = 0
				SCarKeys.LastBoundKeyEvent[i] = 0
				SCarKeys.BoundKeyEventsID[SCarKeys.PanelListener.id] = i
				SCarKeys.PanelListener = nil
				SCarKeys:WriteKeysToFile()
			end
		end
	end
end
hook.Add("Think","ScarKeyPanelThink", SCarKeys.KeyPanelThink)



function SCarKeys:StartChat(TeamSay)
	SCarKeys.isInChat = true
end
hook.Add("StartChat", "SCarIngorKeysStart", SCarKeys.StartChat)

function SCarKeys:StopChat(TeamSay)
	SCarKeys.isInChat = false
end
hook.Add("FinishChat", "SCarIngorKeysFinish", SCarKeys.StopChat)



--Mouse Input

local ply = LocalPlayer()	
local veh = nil
local isScarSeat = false
local isInside = false
local xWasZero = true
local yWasZero = true

local function MouseInput(cmd, x, y, angle)

	if LocalPlayer() and LocalPlayer().GetVehicle then --Sometimes the function is nil for some odd reason.
		veh = LocalPlayer():GetVehicle()
		
		if IsValid(veh) then
			isScarSeat = veh:GetNetworkedInt( "SCarSeat" )
			
			if isScarSeat >= 1 and veh:GetNetworkedBool("SCarRequiresMouseMovement") then
				isScarSeat = true
			end
		else 
			isScarSeat = false
		end
		
		

		if isScarSeat == true then
			isInside = true
			if x != 0 then
				xWasZero = false
				RunConsoleCommand( "SetSCarMouseMovementX", x)	
			elseif xWasZero == false then
				xWasZero = true
				RunConsoleCommand( "SetSCarMouseMovementX", 0)
			end	
			
			if y != 0 then
				yWasZero = false
				if SCarKeys.InvMouse then
					y = -y
				end
				RunConsoleCommand( "SetSCarMouseMovementY", y)	
			elseif yWasZero == false then
				yWasZero = true
				RunConsoleCommand( "SetSCarMouseMovementY", 0)			
			end
		elseif isInside == true then
			isInside = false
			RunConsoleCommand( "SetSCarMouseMovementX", 0)	
			RunConsoleCommand( "SetSCarMouseMovementY", 0)	
		end
	end
end
hook.Add("InputMouseApply", "SCarMouseInput", MouseInput)
