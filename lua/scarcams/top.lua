local Cam = {}
Cam.Name = "Top"

Cam.TopDist = 500
CreateClientConVar("scar_topcamdistance", "500", true, false)


function Cam:Init()
	self.TopDist = GetConVarNumber( "scar_topcamdistance" )
end

function Cam:FirstPerson(ply, pos, ang, fov, SCar, veh)	
	return Cam:TopCam(ply, pos, ang, fov, SCar, veh)	
end

function Cam:ThirdPerson(ply, pos, ang, fov, SCar, veh)	
	return Cam:TopCam(ply, pos, ang, fov, SCar, veh)	
end

function Cam:TopCam(ply, pos, ang, fov, SCar, veh)	

	local newPos = SCar:GetPos() + Vector(0,0, self.TopDist)
	
	local Trace = {}
	Trace.start = SCar:GetPos()
	Trace.endpos = newPos
	Trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine(Trace)
	
	if tr.Hit then
		newPos = tr.HitPos + tr.HitNormal * 10
	end		
	
	local newAng = Angle(90,0,0)
	
	return newPos, newAng, fov
end


function Cam:MenuElements(Panel)
	local slider = vgui.Create( "DNumSlider" )
	slider:SetText( "Height" )
	slider:SetSize( 150, 50 )
	slider:SetMin( 100 )			
	slider:SetMax( 1000 )
	slider:SetDecimals( 1 )					
	slider:SetConVar( "scar_topcamdistance" )
	
	slider.Think = function()
		if self.TopDist != GetConVarNumber( "scar_topcamdistance" ) then
			self.TopDist = GetConVarNumber( "scar_topcamdistance" )
		end
	end
	Panel:AddItem(slider)	
	
		
end

SCarViewManager:RegisterCam(Cam)