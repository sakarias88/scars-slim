include('shared.lua')

ENT.SeparationSign = "@"

local Font_participatorText = {}
Font_participatorText.font = "Mister Belvedere"
Font_participatorText.size = 80
Font_participatorText.weight = 400
Font_participatorText.blursize = 0
Font_participatorText.scanlines = 0
Font_participatorText.antialias = true
Font_participatorText.additive = false
Font_participatorText.underline = false
Font_participatorText.italic  = false
Font_participatorText.strikeout = false
Font_participatorText.symbol  = false
Font_participatorText.rotary = false
Font_participatorText.shadow = false
Font_participatorText.outline = false
surface.CreateFont("participatorText", Font_participatorText )
--surface.CreateFont("Mister Belvedere", 80, 400, true, false, "participatorText")

ENT.TextScale = 0.1
ENT.WindowScale = 1
ENT.FinalScale = 0

ENT.BoxHeight = 0
ENT.BoxWidth = 0
ENT.HScale = 0
ENT.YOffset = -10

ENT.OldScrnTxt = "hubba bubba"
ENT.ScrnTxt = ""
ENT.TxtTbl = {}
ENT.TxtTblNr = 1

function ENT:Initialize()
	
	self.FinalScale = self.WindowScale / self.TextScale
	self.BoxHeight = 30 * self.FinalScale
	self.BoxWidth = 50 * self.FinalScale
	self.HScale	= (self.BoxHeight * 2) / 10

	local mx, mn = self:GetRenderBounds()
	self:SetRenderBounds( mn + Vector(0,128,128), mx + Vector(0,-128,0), 0 )	
end
	
	

function ENT:Think()
	self.ScrnTxt = self:GetNetworkedString( "Participators" )

	if self.OldScrnTxt != self.ScrnTxt then
		self.OldScrnTxt = self.ScrnTxt
		self.TxtTbl = string.Explode(self.SeparationSign, self.ScrnTxt)	
		self.TxtTblNr = table.Count(self.TxtTbl)	+ 1
	end
end

function ENT:OnRestore()
end

function ENT:Draw()

	self:DrawModel()

	local ang = self:GetAngles()
	ang:RotateAroundAxis( self:GetUp(), 90 )
	ang:RotateAroundAxis( self:GetRight(), -90 )

	local pos = self:GetPos() + self:GetUp() * 22 + self:GetForward() * -12 + (self:GetUp() * self.BoxHeight / self.FinalScale)
	
	
	local messText = self:GetNetworkedString( "MessageText" )
	local rcol = self:GetNetworkedInt( "rCol" )
	local gcol = self:GetNetworkedInt( "gCol" )
	local bcol = self:GetNetworkedInt( "bCol" )
	
	if !messText then 
		messText = "ERROR"
	end		
	
	cam.Start3D2D( pos, ang , self.TextScale )
	
		draw.RoundedBox( 4, -self.BoxWidth, -self.BoxHeight, (self.BoxWidth * 2), (self.BoxHeight * 2), Color(0,0,50,150))

		--if self.ScrnTxt != "" then
			
			draw.RoundedBox( 4, (-self.BoxWidth*0.75),(-self.BoxHeight-self.HScale*1.1), (self.BoxWidth * 1.5), self.HScale, Color(rcol,gcol,bcol,255))
			draw.DrawText( messText, "participatorText", 0, (-self.BoxHeight-self.HScale*1.1)+self.YOffset, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )	
			
			for i = 1, self.TxtTblNr-1 do
				
				if i == 1 then
					draw.RoundedBox( 0, -self.BoxWidth, (((i * self.HScale) - self.BoxHeight) - (self.HScale / 2)) , (self.BoxWidth * 2), self.HScale, Color(0,255,0,150))
					draw.DrawText( "#checkpoint.participants", "participatorText", 0, (((i * self.HScale) - self.BoxHeight) - (self.HScale / 2) + self.YOffset), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )					
				else
					draw.RoundedBox( 0, -self.BoxWidth, (((i * self.HScale) - self.BoxHeight) - (self.HScale / 2)), (self.BoxWidth * 2), self.HScale, Color((255 - i*20) ,0,0,150))
					draw.DrawText( self.TxtTbl[i-1], "participatorText", 0, (((i * self.HScale) - self.BoxHeight) - (self.HScale / 2) + self.YOffset), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )					
				end
			end
			
		--end
		
	cam.End3D2D()

end