include('shared.lua')

local Font_cpText = {}
Font_cpText.font = "Mister Belvedere"
Font_cpText.size = 80
Font_cpText.weight = 400
Font_cpText.blursize = 0
Font_cpText.scanlines = 0
Font_cpText.antialias = true
Font_cpText.additive = false
Font_cpText.underline = false
Font_cpText.italic  = false
Font_cpText.strikeout = false
Font_cpText.symbol  = false
Font_cpText.rotary = false
Font_cpText.shadow = false
Font_cpText.outline = false
surface.CreateFont("cpText", Font_cpText )
--surface.CreateFont("Mister Belvedere", 80, 400, true, false, "cpText")

ENT.FoundPills = false
ENT.Lpill = NULL
ENT.Rpill = NULL

ENT.WindowScale = 0.6

ENT.BoxHeight = 70
ENT.BoxWidth = 300
ENT.HeightOffset = ENT.BoxHeight + 55

function ENT:Initialize()
	local mx, mn = self:GetRenderBounds()
	self:SetRenderBounds( mn + Vector(0,128,0), mx + Vector(0,-128,-128), 0 )	
end
	
	

function ENT:Think()
end

function ENT:OnRestore()
end

function ENT:Draw()


	local lPill = self:GetNetworkedEntity( "leftPill" )
	local rPill = self:GetNetworkedEntity( "rightPill" )
	local text = self:GetNetworkedString( "HeaderText" )
	
	local raceHandler = self:GetNetworkedEntity("RaceStarterEnt")
	local messageText = raceHandler:GetNetworkedString( "MessageText" )
	local rcol = raceHandler:GetNetworkedInt("rCol")
	local gcol = raceHandler:GetNetworkedInt("gCol")
	local bcol = raceHandler:GetNetworkedInt("bCol")

	if !text || text == "" then 
		text = "ERROR"
	end
	
	if !messageText then 
		messageText = "ERROR"
	end	
	
	
	if lPill != NULL && IsValid(lPill) && rPill != NULL && IsValid(rPill) then
	
		local ang = (lPill:GetPos() - rPill:GetPos()):Angle() + Angle(0,0,90)
		local pos = (lPill:GetPos() + rPill:GetPos()) / 2
		pos = self:GetPos()
		
		cam.Start3D2D( pos, ang, self.WindowScale )
		
			
			draw.RoundedBox( 4, -(self.BoxWidth*0.5), 5, self.BoxWidth, self.BoxHeight, Color(0,0,0,255))
			draw.DrawText( text, "cpText", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
			
			draw.RoundedBox( 4, -((self.BoxWidth*1.5)*0.5), -self.HeightOffset, (self.BoxWidth*1.5), self.BoxHeight, Color(rcol,gcol,bcol,255))
			draw.DrawText( messageText, "cpText", 0, -self.HeightOffset-5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end

end