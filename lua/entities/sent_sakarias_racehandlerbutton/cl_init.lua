include('shared.lua')

ENT.SeparationSign = "@"

local Font_participatorTextButton = {}
Font_participatorTextButton.font = "Mister Belvedere"
Font_participatorTextButton.size = 80
Font_participatorTextButton.weight = 400
Font_participatorTextButton.blursize = 0
Font_participatorTextButton.scanlines = 0
Font_participatorTextButton.antialias = true
Font_participatorTextButton.additive = false
Font_participatorTextButton.underline = false
Font_participatorTextButton.italic  = false
Font_participatorTextButton.strikeout = false
Font_participatorTextButton.symbol  = false
Font_participatorTextButton.rotary = false
Font_participatorTextButton.shadow = false
Font_participatorTextButton.outline = false
surface.CreateFont("participatorTextButton", Font_participatorTextButton )
--surface.CreateFont("Mister Belvedere", 80, 400, true, false, "participatorTextButton")

ENT.TextScale = 0.1
ENT.WindowScale = 1
ENT.FinalScale = 0
ENT.Height = 1
ENT.Width = 1

ENT.YOffset = -10

ENT.Txt = ""
ENT.OldTxt = "hubbabubba"

function ENT:Initialize()
	
	self.FinalScale = self.WindowScale / self.TextScale
	self.Height = 5 * self.FinalScale
end
	
	

function ENT:Think()

	self.Txt = self:GetNetworkedString( "ButtonText" )

	if self.OldTxt != self.Txt && self.Txt then
		self.OldTxt = self.Txt
		self.Width = string.len( self.Txt ) * 2.1 * self.FinalScale
	end
end

function ENT:OnRestore()
end

function ENT:Draw()
	
	ply = LocalPlayer()
	local col = Color(0,0,50,150)
	local dist = self:GetPos():Distance( ply:GetShootPos() )
	local dr = (self:GetPos() - ply:GetShootPos()):GetNormalized():Dot( ply:GetAimVector() )
	
	if dr > 0.98 && dist < 100 then
		col = Color(0,100,0,200)
	end


	cam.Start3D2D( self:GetPos(), self:GetAngles() , self.TextScale )
	
		draw.RoundedBox( 4, -self.Width, -self.Height, (self.Width * 2), (self.Height * 2), col)
		draw.DrawText( self.Txt, "participatorTextButton", self.YOffset, (-self.Height / 1.5), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )					
	
	cam.End3D2D()

end