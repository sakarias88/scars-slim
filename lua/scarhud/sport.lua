HUD = {}
HUD.Name = "Sport"

HUD.background = surface.GetTextureID("SCarHUD/sport/background")
HUD.board = surface.GetTextureID("SCarHUD/sport/board")
HUD.bigArrow = surface.GetTextureID("SCarHUD/sport/bigarrow")
HUD.smallArrow = surface.GetTextureID("SCarHUD/sport/smallarrow") 
HUD.noslight = surface.GetTextureID("SCarHUD/sport/noslight") 
HUD.lastTrans = 0

HUD.mainLastR = 255
HUD.mainLastG = 255
HUD.mainLastB = 255
HUD.mainLastA = 255

HUD.arrowLastR = 255
HUD.arrowLastG = 255
HUD.arrowLastB = 255
HUD.arrowLastA = 255

local Font_SportGear = {}
Font_SportGear.font = "DS-Digital"
Font_SportGear.size = ScreenScale(25)
Font_SportGear.weight = 200
Font_SportGear.blursize = 0
Font_SportGear.scanlines = 0
Font_SportGear.antialias = false
Font_SportGear.additive = false
Font_SportGear.underline = false
Font_SportGear.italic  = false
Font_SportGear.strikeout = false
Font_SportGear.symbol  = false
Font_SportGear.rotary = false
Font_SportGear.shadow = false
Font_SportGear.outline = false
surface.CreateFont("SportGear", Font_SportGear )
--surface.CreateFont( "DS-Digital", ScreenScale(25), 200, 0, 0, "SportGear")


function HUD:Init()
	self.lastTrans = GetConVarNumber( "scar_digihudtransparency" )
	
	self.mainLastR = GetConVarNumber( "scar_sporthudred" )
	self.mainLastG = GetConVarNumber( "scar_sporthudgreen" )
	self.mainLastB = GetConVarNumber( "scar_sporthudblue" )
	self.mainLastA = GetConVarNumber( "scar_sporthudalpha" )

	self.arrowLastR = GetConVarNumber( "scar_sporthudredarrow" )
	self.arrowLastG = GetConVarNumber( "scar_sporthudgreenarrow" )
	self.arrowLastB = GetConVarNumber( "scar_sporthudbluearrow" )
	self.arrowLastA = GetConVarNumber( "scar_sporthudalphaarrow" )	
end

function HUD:DrawHud(vel, rev, gear, fuel, turbo, speed, scar, ply, isWideScreen, kilometersOrMiles)

	local xSize = 0
	local ySize = 0
	local xPos = 0
	local yPos = 0
	
	self.trans = self.lastTrans * 0.01
	
	if isWideScreen then
		xSize = ScrW() * 0.234375
		ySize = ScrH() * 0.375
		xPos = ScrW() * 0.75
		yPos = ScrH() * 0.67	
	else
		xSize = ScrW() * 0.234375
		ySize = ScrH() * 0.292926875
		xPos = ScrW() * 0.75
		yPos = ScrH() * 0.751953125
	end

	surface.SetTexture( self.background )
	surface.SetDrawColor( 0, 0, 0, self.lastTrans )
	surface.DrawTexturedRect( xPos, yPos, xSize, ySize )	
	
	surface.SetTexture( self.board )
	surface.SetDrawColor( self.mainLastR, self.mainLastG, self.mainLastB, self.mainLastA )
	surface.DrawTexturedRect( xPos, yPos, xSize, ySize )

	surface.SetTexture( self.noslight )
	surface.SetDrawColor( 255*(1-turbo), 255*turbo, 0, 255 )
	surface.DrawTexturedRect( xPos, yPos, xSize, ySize )	
	
	
	surface.SetTexture( self.bigArrow )
	surface.SetDrawColor( self.arrowLastR, self.arrowLastG, self.arrowLastB, self.arrowLastA )
	local rotation = 117 - 234 * (speed / 260)
	xPos = xPos + xSize * 0.5
	yPos = yPos + ySize * 0.5
	surface.DrawTexturedRectRotated( xPos, yPos, xSize, ySize, rotation)	
	
	surface.SetTexture( self.smallArrow )
	surface.SetDrawColor( self.arrowLastR, self.arrowLastG, self.arrowLastB, self.arrowLastA )	
	rotation = 110 - 220 * rev
	surface.DrawTexturedRectRotated( xPos, yPos, xSize, ySize, rotation)	
	
	draw.SimpleText(gear, "SportGear", xPos, yPos, Color( self.arrowLastR, self.arrowLastG, self.arrowLastB, self.arrowLastA )	, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	

	if isWideScreen then
		yPos = ScrH() * 0.922
		ySize = ScrH() * 0.0395
		xSize = ScrW() * 0.08
		xPos = xPos - xSize * 0.5
	else
		yPos = ScrH() * 0.95
		ySize = ScrH() * 0.03
		xSize = ScrW() * 0.08
		xPos = xPos - xSize * 0.5
	end	
	
	
	draw.RoundedBox( 0, xPos, yPos, xSize, ySize , Color(self.mainLastR, self.mainLastG, self.mainLastB, self.mainLastA ) )	
	
	yPos = yPos + 2
	ySize = ySize - 4
	xSize = xSize - 4
	xPos = xPos + 2
	draw.RoundedBox( 0, xPos, yPos, xSize, ySize , Color(100,100,100,255) )	
	
	yPos = yPos + 2
	ySize = ySize - 4
	xSize = (xSize - 4) * fuel
	xPos = xPos + 2
	draw.RoundedBox( 0, xPos, yPos, xSize, ySize , Color(self.mainLastR, self.mainLastG, self.mainLastB, self.mainLastA ) )	
end

CreateClientConVar("scar_sporthudtransparency", "100", true, false)

CreateClientConVar("scar_sporthudred", "255", true, false)
CreateClientConVar("scar_sporthudgreen", "255", true, false)
CreateClientConVar("scar_sporthudblue", "255", true, false)
CreateClientConVar("scar_sporthudalpha", "255", true, false)

CreateClientConVar("scar_sporthudredarrow", "255", true, false)
CreateClientConVar("scar_sporthudgreenarrow", "255", true, false)
CreateClientConVar("scar_sporthudbluearrow", "255", true, false)
CreateClientConVar("scar_sporthudalphaarrow", "255", true, false)


function HUD:MenuElements(Panel)

	local color = {}
	color.Label = "Main color"
	color.Red = "scar_sporthudred"
	color.Green = "scar_sporthudgreen"
	color.Blue = "scar_sporthudblue"
	color.Alpha = "scar_sporthudalpha"
	color.ShowAlpha = 0
	color.ShowHSV = 0
	color.ShowRGB = 0
	color.Multiplier = 255


	local trans = vgui.Create( "DNumSlider" )
	trans:SetText( "Transparency" )
	trans:SetSize( 150, 50 )
	trans:SetMin( 0 )			
	trans:SetMax( 255 )
	trans:SetDecimals( 1 )					
	trans:SetConVar( "scar_sporthudtransparency" )
	
	trans.Think = function()
		if self.lastTrans != GetConVarNumber( "scar_sporthudtransparency" ) then
			self.lastTrans = GetConVarNumber( "scar_sporthudtransparency" )
		end
		
		if self.mainLastR != GetConVarNumber( "scar_sporthudred" ) then
			self.mainLastR = GetConVarNumber( "scar_sporthudred" )
		end

		if self.mainLastG != GetConVarNumber( "scar_sporthudgreen" ) then
			self.mainLastG = GetConVarNumber( "scar_sporthudgreen" )
		end
		
		if self.mainLastB != GetConVarNumber( "scar_sporthudblue" ) then
			self.mainLastB = GetConVarNumber( "scar_sporthudblue" )
		end

		if self.mainLastA != GetConVarNumber( "scar_sporthudalpha" ) then
			self.mainLastA = GetConVarNumber( "scar_sporthudalpha" )
		end	
	

		if self.arrowLastR != GetConVarNumber( "scar_sporthudredarrow" ) then
			self.arrowLastR = GetConVarNumber( "scar_sporthudredarrow" )
		end

		if self.arrowLastG != GetConVarNumber( "scar_sporthudgreenarrow" ) then
			self.arrowLastG = GetConVarNumber( "scar_sporthudgreenarrow" )
		end
		
		if self.arrowLastB != GetConVarNumber( "scar_sporthudbluearrow" ) then
			self.arrowLastB = GetConVarNumber( "scar_sporthudbluearrow" )
		end

		if self.arrowLastA != GetConVarNumber( "scar_sporthudalphaarrow" ) then
			self.arrowLastA = GetConVarNumber( "scar_sporthudalphaarrow" )
		end	
	
	end
	Panel:AddItem(trans)	
	

	local labelMainCol = vgui.Create("Label", frame)
	labelMainCol:SetText("Main color")
	Panel:AddItem(labelMainCol)	
	Panel:AddControl("Color", color)
	
	color.Label = "Arrow colour"
	color.Red = "scar_sporthudredarrow"
	color.Green = "scar_sporthudgreenarrow"
	color.Blue = "scar_sporthudbluearrow"
	color.Alpha = "scar_sporthudalphaarrow"	
	
	local labelMainCol = vgui.Create("Label", frame)
	labelMainCol:SetText("Arrow colour")
	Panel:AddItem(labelMainCol)	
	Panel:AddControl("Color", color)	
end

SCarHudHandler:RegisterHUD(HUD)