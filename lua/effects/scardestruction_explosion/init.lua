
function EFFECT:Init( data )
	
	local vOffset = data:GetOrigin()
	local vNorm = data:GetStart()
	local NumParticles = 50
	
	local emitter = ParticleEmitter( vOffset )
	
		for i=0, NumParticles do
			
			local part = emitter:Add( "particle/particle_smokegrenade", vOffset )
			if (part) then
				
				local Vec2 = VectorRand()
				part:SetVelocity( Vector(Vec2.x, Vec2.y, math.Rand(0.1,1.5)) * 600)
				
				part:SetLifeTime( 0 )
				part:SetDieTime( math.Rand(0.1,3) )
				
				part:SetStartAlpha( 250 )
				part:SetEndAlpha( 0 )
				
				part:SetStartSize( math.Rand(50,150) )
				part:SetEndSize( 0 )
				
				part:SetColor(Color(50,50,40,255))
				
				part:SetAirResistance( 250 )
				
				part:SetGravity( Vector( 100, 100, -400 ) )
				part:SetLighting( true )
				part:SetCollide( true )
				part:SetBounce( 0.5 )
			end
		end
		
		NumParticles = math.random(1,5)
		for i=0, NumParticles do
		
			local part = emitter:Add( "particle/particle_smokegrenade", vOffset )
			if (part) and part.TimeToLive then
				local Vec = vNorm + VectorRand()
				part:SetVelocity( Vector(Vec.x, Vec.y, math.Rand(0.5,2)) * 1000)
				
				part:SetLifeTime( 0 )
				part.TimeToLive = math.Rand(0.01,0.3) 
				part:SetDieTime( part.TimeToLive )
				
				part:SetStartAlpha( 0 )
				part:SetEndAlpha( 0 )
				
				part:SetStartSize( math.Rand(0.1,2) )
				part:SetEndSize( math.Rand(2,3)  )
				
				local mul = math.Rand( 0.8, 1.2 )
				part:SetColor(Color(100,100,90,255))
				part:SetAirResistance( 70 )
				
				part:SetGravity( Vector( 0, 0, -1000 ) )
				
				part:SetCollide( true )
				part:SetBounce( 0.5 )
				part:SetThinkFunction(SCar_ParticleThink)
				part:SetNextThink(CurTime() + 0.1)
			end				
		end		
		
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

local function SCar_ParticleThink( part )

	if part:GetLifeTime() > 0.05 then 
	
		local vOffset = part:GetPos()	
		local emitter = ParticleEmitter( vOffset )
	
		if emitter == nil then return end
		local particle = emitter:Add( "particles/smokey", vOffset )
		
		if (particle) then		
			particle:SetLifeTime( 0 )
			particle:SetDieTime( (1-(part.TimeToLive - part:GetLifeTime())) * 2 )
				
			particle:SetStartAlpha( 150 )
			particle:SetEndAlpha( 0 )
				
			
			particle:SetStartSize( 10 + (part.TimeToLive - part:GetLifeTime()) * 100 )
			particle:SetEndSize( 10 + (part.TimeToLive - part:GetLifeTime()) * 300)				
			
			particle:SetColor(Color(100,100,90,255))
				
			particle:SetRoll( math.Rand(-0.5, 0.5) )
			particle:SetRollDelta( math.Rand(-0.5, 0.5) )
				
			particle:SetAirResistance( 250 )
				
			particle:SetGravity( Vector( 200, 200, -100 ) )
				
			particle:SetLighting( true )
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )	
		end
		emitter:Finish()
	end

	part:SetNextThink( CurTime() + 0.5 )
end

function EFFECT:Render()
end
