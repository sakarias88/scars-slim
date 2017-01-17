////NOTE TO SELF!
// Use SetIK to false to solve weird animation issues in gmod13 SetIK(false)



--[[
----HORN ANIM
Bone: ValveBiped.Bip01_R_UpperArm
Ang P:-19.180328369141 Y:7.3770489692688 R:-16.229507446289
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Forearm
Ang P:0 Y:-4.4262294769287 R:-22.131147384644
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Hand
Ang P:42.786884307861 Y:90 R:-13.278688430786
Pos X:0 Y:0 Z:0


----GEAR CHANGE
Bone: ValveBiped.Bip01_R_UpperArm
Ang P:25.081966400146 Y:51.639343261719 R:-16.229507446289
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Forearm
Ang P:10.327868461609 Y:-39.836067199707 R:-45.737705230713
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Hand
Ang P:0 Y:16.229507446289 R:13.278688430786
Pos X:0 Y:0 Z:0



------Hand brake
Bone: ValveBiped.Bip01_R_UpperArm
Ang P:51.639343261719 Y:45.737705230713 R:0
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Forearm
Ang P:-60.491802215576 Y:10.327868461609 R:25.081966400146
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Hand
Ang P:1.4754098653793 Y:-33.934425354004 R:0
Pos X:0 Y:0 Z:0

----BRAKE PEDAL

Bone: ValveBiped.Bip01_R_Thigh
Ang P:-13.278688430786 Y:13.278688430786 R:0
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Calf
Ang P:0 Y:-19.180328369141 R:0
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Foot
Ang P:0 Y:33.934425354004 R:0
Pos X:0 Y:0 Z:0

-----CLUTCH
Bone: ValveBiped.Bip01_R_Thigh
Ang P:0.00062133022584021 Y:10.327868461609 R:0.0074572954326868
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Calf
Ang P:0.00088616518769413 Y:-13.278688430786 R:0
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_R_Foot
Ang P:1.4754098653793 Y:22.131147384644 R:0
Pos X:0 Y:0 Z:0

-------THROTTLE
Bone: ValveBiped.Bip01_L_Thigh
Ang P:0.00062133022584021 Y:10.327868461609 R:0.0074572954326868
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_L_Calf
Ang P:0.00088616518769413 Y:-13.278688430786 R:0
Pos X:0 Y:0 Z:0

Bone: ValveBiped.Bip01_L_Foot
Ang P:1.4754098653793 Y:22.131147384644 R:0
Pos X:0 Y:0 Z:0
--]]

SCarAnim = {}
SCarAnim.veh = nil
SCarAnim.isScarSeat = 0
SCarAnim.turnParam = 0
SCarAnim.carId = 0
SCarAnim.curPer = 0
SCarAnim.SCar = 0
SCarAnim.boneInd = nil
SCarAnim.mat = nil

--Override anims
SCarAnim.throttleState = 0
SCarAnim.throttleTime = 1 / 0.2
SCarAnim.throttleDel = CurTime()
SCarAnim.lastGear = 0

SCarAnim.clutchState = 0
SCarAnim.clutchTime = 1 / 0.2
SCarAnim.clutchDel = CurTime()

SCarAnim.brakeState = 0
SCarAnim.brakeTime = 1 / 0.2
SCarAnim.brakeDel = CurTime()


SCarAnim.handBrakeState = 0
SCarAnim.handBrakeTime = 1 / 0.2
SCarAnim.handBrakeDel = CurTime()
SCarAnim.handBrakeAng = {}
SCarAnim.handBrakeAng[1] = Angle(51.63, 45.7, 0)
SCarAnim.handBrakeAng[2] = Angle( -60.5, 10.32, 25)
SCarAnim.handBrakeAng[3] = Angle( 1.47, -33.93, 0)


SCarAnim.hornState = 0
SCarAnim.hornDel = CurTime()
SCarAnim.hornTime = 1 / 0.1
SCarAnim.hornAng = {}
SCarAnim.hornAng[1] = Angle( -19.18, 7.3, -16.22 )
SCarAnim.hornAng[2] = Angle( 0, -4.42, -22.13)
SCarAnim.hornAng[3] = Angle( 42.78, 90, -13.27)


SCarAnim.gearState = 0
SCarAnim.gearTime = 1 / 0.35
SCarAnim.gearDel = CurTime()
SCarAnim.gearAngles = {}
SCarAnim.gearAngles[1] = Angle( 25, 51.63, -16.22 )
SCarAnim.gearAngles[2] = Angle( 10.32, -39.83, -45.73 )
SCarAnim.gearAngles[3] = Angle( 0, 16.22, 13.27 )

SCarAnim.animPer = 0
SCarAnim.gearChange = false

SCarAnim.isSeat = nil	
SCarAnim.tmpAng = Angle(0,0,0)


SCarAnim.brakeAng = {}
SCarAnim.brakeAng[1] = Angle( -13.27, 13.27, 0 )
SCarAnim.brakeAng[2] = Angle( 0, -19.18, 0)
SCarAnim.brakeAng[3] = Angle( 0, 33.93, 0 )


SCarAnim.clutchAng = {}
SCarAnim.clutchAng[1] = Angle( 0, 10.32, 0)
SCarAnim.clutchAng[2] = Angle(0, -13.27, 0)
SCarAnim.clutchAng[3] = Angle(1.47,22.13, 0)


SCarAnim.throttAng = {}
SCarAnim.throttAng[1] = Angle( 0, 10.32, 0)
SCarAnim.throttAng[2] = Angle(0, -13.27, 0)
SCarAnim.throttAng[3] = Angle(1.47,22.13, 0)

SCarAnim.startAnimatingDelay = 0
SCarAnim.doAnimationSwitch = false



--May flicker when it changes between LOD models but you won't really notice it
function SCarAnim.ShrinkHeadInSCar()

	if GetViewEntity() != LocalPlayer() or !LocalPlayer():InVehicle() then return end
	SCarAnim.isScarSeat = LocalPlayer():GetVehicle():GetNetworkedInt( "SCarSeat" )
	SCarAnim.SCar = LocalPlayer():GetNetworkedInt( "SCarThirdPersonView" )

	if SCarAnim.isScarSeat >= 1 and SCarAnim.SCar == 0 then 
		SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_Head1")
		SCarAnim.boneInd = SCarAnim.boneInd or 0
		SCarAnim.mat = LocalPlayer():GetBoneMatrix( SCarAnim.boneInd )
		
		if SCarAnim.mat then
			SCarAnim.mat:Scale( Vector(0,0,0) )
			LocalPlayer():SetBoneMatrix( SCarAnim.boneInd, SCarAnim.mat )	
		end
	end
end
--hook.Add("PrePlayerDraw", "SCarAnim.ShrinkHeadInSCar", SCarAnim.ShrinkHeadInSCar)  


function SCarShrinkHead_OldBuildBonePositions( ent )
	if ent:IsPlayer() then
		ent:AddCallback( "BuildBonePositions", SCarAnim.ShrinkHeadInSCar )
	end
end
hook.Add("OnEntityCreated", "SCarShrinkHead_OldBuildBonePositions", SCarShrinkHead_OldBuildBonePositions)  


function SCarAnim.SCar_Animation_Override(ply, vel, maxSeqGround)

	SCarAnim.isSeat = 0
	if IsValid(LocalPlayer():GetVehicle()) then
		SCarAnim.isSeat = LocalPlayer():GetVehicle():GetNetworkedInt( "SCarSeat" )
	end		
	
	if SCarAnim.isSeat >= 1 and SCarAnim.doAnimationSwitch == false and LocalPlayer():ShouldDrawLocalPlayer() and SCarClientData["scar_usedetailedanimations"] == true then
		SCarAnim.doAnimationSwitch = true
		SCarAnim.startAnimatingDelay = CurTime() + 0.2
	elseif SCarAnim.isSeat <= 0 and SCarAnim.doAnimationSwitch == true then
		SCarAnim.doAnimationSwitch = false
		SCarAnim.ResetSCarAnimations()
		LocalPlayer():SetColor(Color(255,255,255,255))
	end
	
	if SCarAnim.doAnimationSwitch and SCarAnim.startAnimatingDelay < CurTime() then
		SCarAnim.DoSCarAnimations()
	end
end

--ManipulateBoneAngles is flawed. Makes the player disappear
hook.Add("PostPlayerDraw", "SCarAnim.SCar_Animation_Override", SCarAnim.SCar_Animation_Override) 
--TRY PrePlayerDraw as hook.

function SCarAnim.ManipulateBoneAng(bone, ang)
	local boneInd = LocalPlayer():LookupBone(bone)
	
	if bone and boneInd >= 0 then
		LocalPlayer():ManipulateBoneAngles( boneInd, ang)
	end
end

function SCarAnim.DoSCarAnimations()
	SCarAnim.tmpAng.p = 0
	SCarAnim.tmpAng.y = 0
	SCarAnim.tmpAng.r = 0
	--------------------------DETECT GEAR CHANGE
	SCarAnim.gearChange = false
	if SCarAnim.lastGear != SCarHudHandler.CurGear and SCarHudHandler.CurGear >= -1 then
		
		SCarAnim.gearChange = true
		SCarAnim.lastGear = SCarHudHandler.CurGear
	end

	--------------------------HORN
	if SCarAnim.hornState == 0 and SCarKeys:GetKeyStatus("Horn") == 2 then
		SCarAnim.hornState = 1
		SCarAnim.hornDel = CurTime()
	end
	
	if SCarAnim.hornState != 0 then
	
		SCarAnim.animPer = (CurTime() - SCarAnim.hornDel) * SCarAnim.hornTime
		
		if SCarAnim.hornState == 2 then
			SCarAnim.animPer = 1 - SCarAnim.animPer
		end
		
		SCarAnim.animPer = math.Clamp( SCarAnim.animPer, 0, 1 )
		
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_UpperArm", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.hornAng[1]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Forearm", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.hornAng[2]))
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Hand", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.hornAng[3]))
		
		if SCarAnim.animPer >= 1 and SCarKeys:GetKeyStatus("Horn") == 0 then
			SCarAnim.hornState = 2 
			SCarAnim.hornDel = CurTime()
		elseif SCarAnim.hornState == 2 and SCarAnim.animPer <= 0 then
			SCarAnim.hornState = 0
		end
	end

	--------------------------HANDBRAKE			
	if SCarAnim.handBrakeState == 0 and SCarHudHandler.CurGear == -3 then
		SCarAnim.handBrakeState = 1
		SCarAnim.handBrakeDel = CurTime()
	end
	
	if SCarAnim.handBrakeState == 1 or SCarAnim.handBrakeState == 2 then
	
		SCarAnim.animPer = (CurTime() - SCarAnim.handBrakeDel) * SCarAnim.handBrakeTime
		
		if SCarAnim.handBrakeState == 2 then
			SCarAnim.animPer = 1 - SCarAnim.animPer
		end
		
		SCarAnim.animPer = math.Clamp( SCarAnim.animPer, 0, 1 )
						
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_UpperArm", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.handBrakeAng[1]))
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Forearm", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.handBrakeAng[2]))
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Hand", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.handBrakeAng[3]))			

		if SCarHudHandler.CurGear != -3 and SCarAnim.animPer >= 1 then
			SCarAnim.handBrakeState = 2 
			SCarAnim.handBrakeDel = CurTime()
		elseif SCarAnim.handBrakeState == 2 and SCarAnim.animPer <= 0 then
			SCarAnim.handBrakeState = 0
		end
	end				

	
	--------------------------GEAR
	if SCarAnim.gearChange == true  and SCarAnim.gearState == 0 then
		SCarAnim.gearState = 1
		SCarAnim.gearDel = CurTime()
		SCarAnim.handBrakeState = 0
	end
	
	if SCarAnim.gearState == 1 or SCarAnim.gearState == 2 then
	
		SCarAnim.animPer = (CurTime() - SCarAnim.gearDel) * SCarAnim.gearTime
		
		if SCarAnim.gearState == 2 then
			SCarAnim.animPer = 1 - SCarAnim.animPer
		end
		
		SCarAnim.animPer = math.Clamp( SCarAnim.animPer, 0, 1 )
		
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_UpperArm", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.gearAngles[1]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Forearm", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.gearAngles[2]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Hand", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.gearAngles[3]))	
		
		if SCarAnim.animPer >= 1 and SCarAnim.gearState == 1 then
			SCarAnim.gearState = 2
			SCarAnim.gearDel = CurTime()	
		elseif SCarAnim.animPer <= 0 and SCarAnim.gearState == 2 then
			SCarAnim.gearState = 0
		end
	end	
	
	
	--------------------------BRAKE PEDAL
	if SCarAnim.brakeState == 0 and SCarHudHandler.neutral == false and SCarHudHandler.CurGear == -2 then
		SCarAnim.brakeState = 1
		SCarAnim.brakeDel = CurTime()
	elseif SCarAnim.brakeState == 1 and (SCarHudHandler.neutral == true or SCarHudHandler.CurGear != -2) then
		SCarAnim.brakeState = 2
		SCarAnim.brakeDel = CurTime()			
	end

	if (SCarAnim.brakeState == 1 or SCarAnim.brakeState == 2) then
		
		SCarAnim.animPer = (CurTime() - SCarAnim.brakeDel) * SCarAnim.brakeTime
		
		if SCarAnim.brakeState == 2 then
			SCarAnim.animPer = 1 - SCarAnim.animPer
		end
		
		SCarAnim.animPer = math.Clamp( SCarAnim.animPer, 0, 1 )				
		
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Thigh", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.brakeAng[1]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Calf", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.brakeAng[2]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Foot", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.brakeAng[3]))			
		
		if SCarAnim.brakeState == 2 and SCarAnim.animPer <= 0 then
			SCarAnim.brakeState = 0
		end
	end				

	--------------------------CLUTCH
	if SCarAnim.clutchState == 0 and (SCarAnim.gearChange == true or SCarAnim.brakeState == 1) then
		SCarAnim.clutchState = 1
		SCarAnim.clutchDel = CurTime()
	end

	if SCarAnim.clutchState == 1 or SCarAnim.clutchState == 2 then
		SCarAnim.animPer = (CurTime() - SCarAnim.clutchDel) * SCarAnim.clutchTime
		
		if SCarAnim.clutchState == 2 then
			SCarAnim.animPer = 1 - SCarAnim.animPer
		end
		
		SCarAnim.animPer = math.Clamp( SCarAnim.animPer, 0, 1 )
		
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_L_Thigh", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.clutchAng[1]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_L_Calf", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.clutchAng[2]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_L_Foot", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.clutchAng[3]))	

		if SCarAnim.clutchState == 1 and SCarAnim.gearChange == false and (SCarAnim.brakeState == 0 or SCarAnim.brakeState == 2) and SCarAnim.animPer >= 1 then
			SCarAnim.clutchState = 2
			SCarAnim.clutchDel = CurTime()
		elseif SCarAnim.clutchState == 2 and SCarAnim.animPer <= 0 then
			SCarAnim.clutchState = 0
		end
	end
	
	
	--------------------------GAS PEDAL
	if SCarAnim.gearState != 1 and SCarAnim.throttleState == 0 and SCarHudHandler.neutral == false and SCarHudHandler.CurGear != -2 then
		SCarAnim.throttleState = 1
		SCarAnim.throttleDel = CurTime()
	elseif SCarAnim.throttleState == 1 and (SCarHudHandler.neutral == true or SCarHudHandler.CurGear == -2 or SCarAnim.gearChange) then
		SCarAnim.throttleState = 2
		SCarAnim.throttleDel = CurTime()	
	end

	if SCarAnim.throttleState == 1 or SCarAnim.throttleState == 2 then
		
		SCarAnim.animPer = (CurTime() - SCarAnim.throttleDel) * SCarAnim.throttleTime
		
		if SCarAnim.throttleState == 2 then
			SCarAnim.animPer = 1 - SCarAnim.animPer
		end
		
		SCarAnim.animPer = math.Clamp( SCarAnim.animPer, 0, 1 )
		
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Thigh", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.throttAng[1]))	
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Foot", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.throttAng[2]))
		SCarAnim.ManipulateBoneAng("ValveBiped.Bip01_R_Foot", LerpAngle( SCarAnim.animPer, SCarAnim.tmpAng, SCarAnim.throttAng[3]))	

		if SCarAnim.throttleState == 2 and SCarAnim.animPer == 0 then
			SCarAnim.throttleState = 0
		end
	end
end

function SCarAnim.ResetSCarAnimations()

	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_R_UpperArm")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))
	
	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_R_Forearm")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))			
	
	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_R_Hand")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))
	
	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_R_Thigh")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))
	
	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_R_Calf")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))

	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_R_Foot")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))

	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_L_Thigh")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))
	
	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_L_Calf")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))

	SCarAnim.boneInd = LocalPlayer():LookupBone("ValveBiped.Bip01_L_Foot")
	LocalPlayer():ManipulateBoneAngles( SCarAnim.boneInd, Angle(0,0,0))

end 

function SCarAnim.ScarDriveAnim( ply )

    if ply:InVehicle() then
		SCarAnim.veh = ply:GetVehicle()
		ply:SetIK( false )
		SCarAnim.isScarSeat = SCarAnim.veh:GetNetworkedInt( "SCarSeat" )
		SCarAnim.SCar = SCarAnim.veh:GetNetworkedEntity("SCarEnt")
		
		if  SCarAnim.isScarSeat == 1 then --Driver seat
		
			--Compensating for the position offset the animation will add
			ply:SetLocalPos( Vector(-9,0,-5.5) )	
			
			if SCarAnim.veh:EntIndex() == SCarAnim.carId then
				SCarAnim.curPer = math.Approach( SCarAnim.curPer, SCarAnim.turnParam, (SCarAnim.curPer - SCarAnim.turnParam) *  0.1 )
				ply:SetPoseParameter( "vehicle_steer", -SCarAnim.curPer ) 
			else
				ply:SetPoseParameter( "vehicle_steer", 1 ) 
			end
			
			if !SCarAnim.SCar or !SCarAnim.SCar.AnimType or SCarAnim.SCar.AnimType == 1 then
				ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )
			elseif SCarAnim.SCar.AnimType == 2 then
				ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )
			end
			
			--CalcSeqOverride is not enough
			--If i want it to work on prop_vehicle_prisoner_pod i will have to set the sequence as well or it will have no effect
			ply:SetSequence( ply.CalcSeqOverride )	
			return true
		elseif SCarAnim.isScarSeat >= 1 then --Passenger seat
			ply:SetPoseParameter( "vertical_velocity", 0 )
			ply.CalcSeqOverride = ply:LookupSequence( "sit_rollercoaster" )
			return true
		end
    end
end
hook.Add("UpdateAnimation", "SCarAnim.ScarDriveAnim", SCarAnim.ScarDriveAnim)  
	

--UserMessages
function SCarAnim.GetTurnParamFromServer( data )
	SCarAnim.turnParam = data:ReadFloat()
	SCarAnim.carId = data:ReadShort()
end
usermessage.Hook( "SCarGetTurnParamFromServer", SCarAnim.GetTurnParamFromServer )
