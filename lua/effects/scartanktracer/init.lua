

EFFECT.Mat = Material( "effects/spark" )

function EFFECT:Init( data )

	
	self.EndPos = data:GetOrigin()
	self.StartPos = data:GetStart()
	
	self.Dir = self.EndPos - self.StartPos
	
	
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	local dist = self.EndPos - self.StartPos
	dist = dist:Length()
	self.TracerTime = dist * 0.0001
	self.Length = 0.05
	
	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
	
end

function EFFECT:Think( )
	if ( CurTime() > self.DieTime ) then return false end
	return true
end

function EFFECT:Render( )

	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5
			
	render.SetMaterial( self.Mat )
	
	local sinWave = math.sin( fDelta * math.pi )


	render.DrawBeam( self.EndPos - self.Dir * (fDelta - sinWave * self.Length ), 		
					 self.EndPos - self.Dir * (fDelta + sinWave * self.Length ),
					 4,					
					 1,					
					 0,				
					 Color(255,247,125,0) )
				 
end
