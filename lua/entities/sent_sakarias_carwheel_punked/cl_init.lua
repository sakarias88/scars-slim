include('shared.lua')

ENT.ScrapeSound = NULL
ENT.SparkDel = CurTime()

function ENT:Initialize()
	self.ScrapeSound = CreateSound(self,"tire/flat.wav")	
end


function ENT:Think()

	local speed = self:GetVelocity():Length()
	
	if (speed > 200 or self:GetNetworkedBool( "shouldSparkle")) && self:IsColliding() then

		if !self.ScrapeSound:IsPlaying() then
			self.ScrapeSound:Stop()
			self.ScrapeSound:Play()
			self.ScrapeSound:ChangeVolume( 0.65, 0 )
		end				
		
		speed = (speed / 3500) * 100 + 50
		speed = math.Clamp( speed, 0, 150 )
		self.ScrapeSound:ChangePitch( speed, 0.1)				

		
	
	elseif self.ScrapeSound:IsPlaying() then
		self.ScrapeSound:Stop()
	end
end

function ENT:IsColliding()
	return self:GetNetworkedBool("IsColliding", false)
end

function ENT:OnRemove()
	self.ScrapeSound:Stop()
end