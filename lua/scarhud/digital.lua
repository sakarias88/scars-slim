
HUD = {}
HUD.Name = "Digital"
HUD.lastTrans = 100
HUD.lastXpos = 98
HUD.lastYpos = 89

local Font_DigiHud = {}
Font_DigiHud.font = "DS-Digital"
Font_DigiHud.size = ScreenScale(15)
Font_DigiHud.weight = 200
Font_DigiHud.blursize = 0
Font_DigiHud.scanlines = 0
Font_DigiHud.antialias = false
Font_DigiHud.additive = false
Font_DigiHud.underline = false
Font_DigiHud.italic  = false
Font_DigiHud.strikeout = false
Font_DigiHud.symbol  = false
Font_DigiHud.rotary = false
Font_DigiHud.shadow = false
Font_DigiHud.outline = false
surface.CreateFont("DigiHud", Font_DigiHud )
--surface.CreateFont( "DS-Digital", ScreenScale(15), 200, 0, 0, "DigiHud")

HUD.trans = 0
HUD.xPos = 0
HUD.yPos = 0
HUD.w = 0
HUD.h = 0
HUD.xScale = 0
HUD.yScale = 0
HUD.xAdd = 0
HUD.yAdd = 0
HUD.height = 0
HUD.length = 0
HUD.NrOfBars = 10
HUD.xDec = 0
HUD.yDec = 0
HUD.yInc = 0
HUD.doRev = 0
HUD.txtAdd = ""
function HUD:Init()
	self.lastTrans = GetConVarNumber( "scar_digihudtransparency" )
	self.lastXpos = GetConVarNumber( "scar_digihudxpos" )
	self.lastYpos = GetConVarNumber( "scar_digihudypos" )
end

function HUD:DrawHud(vel, rev, gear, fuel, turbo, speed, scar, ply, isWideScreen, kilometersOrMiles)

	self.xPos = 0
	self.yPos = 0
	self.w = ScrW()
	self.h = ScrH()

	self.trans = self.lastTrans * 0.01
	self.xScale = self.lastXpos * 0.01
	self.yScale = self.lastYpos * 0.01
	
	self.xAdd = (self.w - (self.w * 0.223)) * self.xScale
	self.yAdd = (self.h - (self.h * 0.1125)) * self.yScale
	
	--BG
	self.xPos = self.xAdd
	self.yPos = self.yAdd
	self.height = self.h * 0.1125
	self.length = self.w * 0.223
	draw.RoundedBox( 2, self.xPos, self.yPos, self.length, self.height, Color(100,100,100,200 * self.trans) )
	
	self.xPos = self.xPos + 2
	self.yPos = self.yPos + 2
	self.height = self.height - 4
	self.length = self.length - 4
	draw.RoundedBox( 0, self.xPos, self.yPos, self.length, self.height, Color(0,0,0,250 * self.trans) )	
	
	self.height = self.h * 0.056666
	self.length = self.w * 0.0049107143
	self.xPos = self.w * 0.109375 + self.xAdd
	self.yPos = self.h * 0.0375 + self.yAdd
	

	self.xDec = self.w * 0.01
	self.yDec = self.h * 0.001
	self.yInc = self.h * 0.005
	
	
	
	for i = 0, self.NrOfBars do
		self.doRev = self.NrOfBars - math.floor(rev * self.NrOfBars)
		
		if self.doRev <= i then
			draw.RoundedBox( 0, self.xPos - self.xDec * i, self.yPos + self.yInc * i, self.length, self.height - self.yInc * i, Color((255 * (1-(i / self.NrOfBars))),(255 * (i / self.NrOfBars)),0,150 * self.trans) )
		else
			draw.RoundedBox( 0, self.xPos - self.xDec * i, self.yPos + self.yInc * i, self.length, self.height - self.yInc * i, Color(255,255,255, 100 * self.trans) )
		end
		--
		if turbo * self.NrOfBars >= i then
			draw.RoundedBox( 0, self.xPos - self.xDec * i, self.yPos - self.h * 0.020, self.length, self.height - self.yInc * (self.NrOfBars-i) , Color(55+(200 * (1-turbo)),55+(200 * (1-turbo)),255,100 * self.trans) )
		else
			draw.RoundedBox( 0, self.xPos - self.xDec * i, self.yPos - self.h * 0.020, self.length, self.height - self.yInc * (self.NrOfBars-i) , Color(255,255,255,100 * self.trans) )
		end
	end


	if kilometersOrMiles then
		txtAdd = " Km/h"
	else
		txtAdd = " Mph"
	end
	

	self.xPos = self.w * 0.1270125 + self.xAdd
	self.yPos = self.h * 0.0125 + self.yAdd
	draw.SimpleText(math.floor(speed)..txtAdd, "DigiHud", self.xPos, self.yPos, Color( 255, 255, 255, 200 * self.trans), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT )

	self.xPos = self.w * 0.1270125 + self.xAdd
	self.yPos = self.h * 0.057 + self.yAdd
	self.xSize = self.w * 0.08
	self.ySize = self.h * 0.035
	draw.RoundedBox( 2, self.xPos, self.yPos, self.xSize, self.ySize , Color(100,100,100,255 * self.trans) )
	
	
	self.xPos = self.xPos + 2
	self.yPos = self.yPos + 2
	self.xSize = self.xSize - 4
	self.ySize = self.ySize - 4	
	draw.RoundedBox( 0, self.xPos, self.yPos, self.xSize, self.ySize , Color(0,0,0,255 * self.trans) )
	
	self.xPos = self.xPos + 2
	self.yPos = self.yPos + 2
	self.xSize = self.xSize - 4
	self.ySize = self.ySize - 4	
	draw.RoundedBox( 0, self.xPos, self.yPos, self.xSize * fuel, self.ySize , Color(255,255,255,255 * self.trans) )	
end

CreateClientConVar("scar_digihudtransparency", "100", true, false)
CreateClientConVar("scar_digihudxpos", "98", true, false)
CreateClientConVar("scar_digihudypos", "98", true, false)


function HUD:MenuElements(Panel)


	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "Transparency" )
	slider:SetSize( 150, 50 )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_digihudtransparency" )
	
	slider.Think = function()
		if self.lastTrans != GetConVarNumber( "scar_digihudtransparency" ) then
			self.lastTrans = GetConVarNumber( "scar_digihudtransparency" )
		end
	end
	Panel:AddItem(slider)	
	
	
	
	local sliderPosX = vgui.Create( "DNumSlider" )
	sliderPosX:SetText( "Pos X" )
	sliderPosX:SetSize( 150, 50 )
	sliderPosX:SetMin( 0 )			
	sliderPosX:SetMax( 100 )
	sliderPosX:SetDecimals( 1 )					
	sliderPosX:SetConVar( "scar_digihudxpos" )
	
	sliderPosX.Think = function()
		if self.lastXpos != GetConVarNumber( "scar_digihudxpos" ) then
			self.lastXpos = GetConVarNumber( "scar_digihudxpos" )
		end
	end
	Panel:AddItem(sliderPosX)	
	

	local sliderPosY = vgui.Create( "DNumSlider" )
	sliderPosY:SetText( "Pos Y" )
	sliderPosY:SetSize( 150, 50 )
	sliderPosY:SetMin( 0 )			
	sliderPosY:SetMax( 100 )
	sliderPosY:SetDecimals( 1 )					
	sliderPosY:SetConVar( "scar_digihudypos" )
	
	sliderPosY.Think = function()
		if self.lastYpos != GetConVarNumber( "scar_digihudypos" ) then
			self.lastYpos = GetConVarNumber( "scar_digihudypos" )
		end
	end
	Panel:AddItem(sliderPosY)	
end

SCarHudHandler:RegisterHUD(HUD)