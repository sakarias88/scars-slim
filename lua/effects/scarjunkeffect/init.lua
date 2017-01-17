EFFECT.Vel = Vector(0,0,0)
EFFECT.Pos = Vector(0,0,0)
EFFECT.part = nil
EFFECT.emitter = nil
function EFFECT:Init( data )
	
	self.Pos = data:GetOrigin()
	self.Vel = data:GetStart()
	
	self.emitter = ParticleEmitter( self.Pos )
	
	for i = 0, 30 do
		
		self.part = self.emitter:Add( "particles/smokey", self.Pos )
		if (self.part) then
			
			self.part:SetVelocity( self.Vel +  VectorRand() * math.Rand(0,20))
			
			self.part:SetLifeTime( 0 )
			self.part:SetDieTime( math.Rand(0.01,0.5) )
			
			self.part:SetStartAlpha( 250 )
			self.part:SetEndAlpha( 0 )
			
			self.part:SetStartSize( 2 )
			self.part:SetEndSize( math.Rand(5,30) )
			
			self.part:SetColor(Color(50,50,40,255))
			self.part:SetRollDelta(math.Rand(-2,2))

			self.part:SetLighting( true )
			self.part:SetCollide( true )
			self.part:SetBounce( 0.5 )
		end
	end
	
	self.emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
