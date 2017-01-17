local Cam = {}
Cam.Name = "Lerpy"

Cam.VecSmooth = 0
Cam.AngSmooth = 0
Cam.lastVecSmooth = 0
Cam.lastAngSmooth = 0

CreateClientConVar("scar_lerpyangsmoothness", "50", true, false)
CreateClientConVar("scar_lerpyvecsmoothness", "80", true, false)


function Cam:Init()
	self.VecSmooth = 1-(GetConVarNumber( "scar_lerpyvecsmoothness" ) * 0.01)
	self.AngSmooth = 1-(GetConVarNumber( "scar_lerpyangsmoothness" ) * 0.01)
end

function Cam:FirstPerson(ply, pos, ang, fov, SCar, veh)	

	lerpy = math.Clamp(  50 * FrameTime() * self.AngSmooth, 0,1)
	local newAng = LerpAngle( lerpy, SCarViewManager.saveTransAng, ang )
	
	return pos, newAng, fov
end

function Cam:ThirdPerson(ply, pos, ang, fov, SCar, veh)	

	local dot = SCar:GetForward():Dot(SCar:GetVelocity():GetNormalized())
	local smooth = math.Clamp((SCar:GetVelocity():Length() / 200) ,0,1)
	if dot < 0 and SCarClientData["scar_autoreversecam"] == true then 
		vec1 = ang:Forward() * -2
		vec1.z = 0
		vec2 = ang:Forward() + vec1 * smooth
		ang = vec2:Angle()
	end	


	local newPos = SCar:GetPos() + ang:Forward() * -200
	
	local Trace = {}
	Trace.start = SCar:GetPos()
	Trace.endpos = newPos
	Trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine(Trace)
	
	if tr.Hit then
		newPos = tr.HitPos + tr.HitNormal * 10
	end				
	
	local dist = SCarViewManager.savePos:Distance( newPos )
	local lerpy = math.Clamp(  0.5 * dist * FrameTime() * self.VecSmooth, 0,1)
	newPos = LerpVector( lerpy, SCarViewManager.savePos, newPos)
	lerpy = math.Clamp(  50 * FrameTime() * self.AngSmooth, 0,1)
	local newAng = LerpAngle( lerpy, SCarViewManager.saveTransAng, ang )

	return newPos, newAng, fov
end


function Cam:MenuElements(Panel)
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "Angle smoothness" )
	slider:SetSize( 150, 50 )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_lerpyangsmoothness" )
	
	slider.Think = function()
		if self.lastAngSmooth != GetConVarNumber( "scar_lerpyangsmoothness" ) then
			self.lastAngSmooth = GetConVarNumber( "scar_lerpyangsmoothness" )
			self.AngSmooth = 1-(self.lastAngSmooth * 0.01)
		end
	end
	Panel:AddItem(slider)	
	
	
	slider = vgui.Create( "DNumSlider" )
	slider:SetText( "Vector smoothness" )
	slider:SetSize( 150, 50 )
	slider:SetMin( 0 )			
	slider:SetMax( 100 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_lerpyvecsmoothness" )
	
	slider.Think = function()
		if self.lastVecSmooth != GetConVarNumber( "scar_lerpyvecsmoothness" ) then
			self.lastVecSmooth = GetConVarNumber( "scar_lerpyvecsmoothness" )
			self.VecSmooth = 1-(self.lastVecSmooth * 0.01)
		end
	end
	Panel:AddItem(slider)	
end

SCarViewManager:RegisterCam(Cam)