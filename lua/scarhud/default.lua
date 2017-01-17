
HUD = {}
HUD.Name = "Default"

local Font_gear = {}
Font_gear.font = "Agency FB"
Font_gear.size = (ScrH() * 0.03333333)
Font_gear.weight = 200
Font_gear.blursize = 0
Font_gear.scanlines = 0
Font_gear.antialias = true
Font_gear.additive = false
Font_gear.underline = false
Font_gear.italic  = false
Font_gear.strikeout = false
Font_gear.symbol  = false
Font_gear.rotary = false
Font_gear.shadow = false
Font_gear.outline = false
surface.CreateFont("gear", Font_gear )
--surface.CreateFont( "Agency FB", (ScrH() * 0.03333333), 200, 0, 0, "gear")

HUD.SpeedTex = surface.GetTextureID("SCarHUD/speed")
HUD.SpeedPointerTex = surface.GetTextureID("SCarHUD/speedPointer")
HUD.RevTex = surface.GetTextureID("SCarHUD/rev") 
HUD.GearTex = surface.GetTextureID("SCarHUD/gear") 
HUD.FuelTex = surface.GetTextureID("SCarHUD/fuelPointer") 


function HUD:Init()
end

function HUD:DrawHud(vel, rev, gear, fuel, turbo, speed, scar, ply, isWideScreen, kilometersOrMiles)


	--Checking if the user have a widescreen res or not.
	local Width = ScrW()
	local Height = ScrH()


	local xPos = 0
	local yPos = 0
	local xSize = 0
	local ySize = 0
	
	//Speed
	if isWideScreen then
		xPos = Width * 0.8214285714
		yPos = Height * 0.7142857143
		xSize = Width * 0.1785714286
		ySize = Height * 0.2857142857
	else
		xPos = Width * 0.8214285714
		yPos = Height * 0.7823142857
		xSize = Width * 0.1785714286
		ySize = Height * 0.2176870749	
	end	
	
	surface.SetTexture( self.SpeedTex )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( xPos, yPos, xSize, ySize )	

	--speed arrow
	if isWideScreen then
		xPos = Width * 0.9107142857
		yPos = Height * 0.8571428571
		xSize = Width * 0.1785714286
		ySize = Height * 0.2857142857
	else
		xPos = Width * 0.9107142857
		yPos = Height * 0.8911564626
		xSize = Width * 0.1785714286
		ySize = Height * 0.2176870749		
	end		
	

	
	
	surface.SetTexture( self.SpeedPointerTex )
	surface.SetDrawColor( 255, 255, 255, 255 )
	local rotation = -260 * (speed / 240)
	surface.DrawTexturedRectRotated( xPos, yPos, xSize, ySize, rotation)

	--Fuel arrow
	if isWideScreen then
		xPos = Width * 0.9107142857
		yPos = Height * 0.939047619
		xSize = Width * 0.0595238095
		ySize = Height * 0.0952380952
	else
		xPos = Width * 0.9107142857	
		yPos = Height * 0.9503854875
		xSize = Width * 0.0595238095
		ySize = Height * 0.0725714286	
	end
	
	rotation = (fuel * 20000) * -0.006
	surface.SetTexture( self.FuelTex )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRectRotated( xPos , yPos, xSize, ySize, rotation )
	

	if isWideScreen then	
		xPos = Width * 0.7023809524
		yPos = Height * 0.8095238095
		xSize = Width * 0.119047619
		ySize = Height * 0.1904761905
	else
		xPos = Width * 0.7023809524
		yPos = Height * 0.8548752835
		xSize = Width * 0.119047619
		ySize = Height * 0.1451247165		
	end


	//Rev
	surface.SetTexture( self.RevTex )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( xPos, yPos, xSize, ySize )

	--Rev arrow		
	if isWideScreen then		
		xPos = Width * 0.7619047619
		yPos = Height * 0.9047619048
		xSize = Width * 0.119047619
		ySize = Height * 0.1904761905
	else
		xPos = Width * 0.7619047619
		yPos = Height * 0.9274376418
		xSize = Width * 0.119047619
		ySize = Height * 0.1451247165	
	end


	rotation = (rev * 200) * -1.3		

	surface.SetTexture( self.SpeedPointerTex )
	surface.SetDrawColor( 255, 255, 255, 255 )	
	surface.DrawTexturedRectRotated( xPos, yPos, xSize, ySize, rotation )
	
	//Gear	
	if isWideScreen then				
		xPos = Width * 0.8107142857
		yPos = Height * 0.933333333
		xSize = Width * 0.0380952381
		ySize = Height * 0.060952381
	else
		xPos = Width * 0.8107142857
		yPos = Height * 0.947845805
		xSize = Width * 0.0380952381
		ySize = Height * 0.0464399093		
	end
		
	surface.SetTexture( self.GearTex )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( xPos, yPos, xSize, ySize )

	if isWideScreen then				
		xPos = Width * 0.8297619048
		yPos = Height * 0.9619047619		
	else
		xPos = Width * 0.8297619048
		yPos = Height * 0.9619047619		
	end
	
	draw.SimpleText( gear, "gear", xPos, yPos, Color( 255, 255, 255, 200 ), 1, 1 )
end


function HUD:MenuElements(Panel)
	
end

SCarHudHandler:RegisterHUD(HUD)