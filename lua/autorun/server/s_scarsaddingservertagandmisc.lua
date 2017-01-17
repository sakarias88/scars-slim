local function CanPick( ent )
	if ent != NULL && IsValid(ent) && (ent:GetClass() == "sent_sakarias_racehandlerbutton" or ent:GetClass() == "sent_sakarias_carwheel" or ent:GetClass() == "sent_sakarias_carwheel_punked") and !ent.IsDestroyed then
		return true
	end
end

local function DontPickWheels( ply, ent )
	if CanPick(ent) then
		return false
	end
end
hook.Add("GravGunPickupAllowed", "DontPickWheels", DontPickWheels)

local function DontPuntWheels( ply, ent )
	if CanPick(ent) then
		return false
	end
end
hook.Add("GravGunPunt", "DontPuntWheels", DontPuntWheels)

local function DontPickupButtons( ply, ent )
	if CanPick(ent) then
		return false
	end
end
hook.Add( "PhysgunPickup", "SCarDontPickupButtons", DontPickupButtons )


local function DontDamagePhysOnPickup( ply, ent )
	if ent and ent.Base == "sent_sakarias_scar_base" then
		ent.IgnorePhysDamage = ent.IgnorePhysDamage + 1
	end
end
hook.Add( "PhysgunPickup", "SCarDisablePhysPickup", DontDamagePhysOnPickup )

local function DropDamagePhysOnPickup( ply, ent )
	if ent and ent.Base == "sent_sakarias_scar_base" then
		ent.IgnorePhysDamage = ent.IgnorePhysDamage - 1
	end
end
hook.Add( "PhysgunDrop", "SCarDisablePhysDrop", DropDamagePhysOnPickup )

--Tags
local tags = string.Explode( ",", ( GetConVarString("sv_tags") or "" ) )
if !table.HasValue(tags, "SCars 2.2") then
	table.insert(tags, "SCars 2.2")
	table.sort(tags)
	RunConsoleCommand("sv_tags", table.concat(tags, ","))
end

function CanUseSCarTool(tool, ply)

	if GetConVarNumber( tool ) == 0 and !ply:IsAdmin() then
		ply:PrintMessage( HUD_PRINTTALK, "This STool is admin only!")
		return false
	else
		return true
	end
end

function SCarSetObjOwner(ply, ent, setOwnerCPPI)

	if IsValid(ply) and IsValid(ent) then
		ent.SpawnedBy = ply
	end

	if setOwnerCPPI and IsValid(ent) and ent.CPPISetOwner then
		ent:CPPISetOwner(ply) --// Don't do anything more. Some PP addon with CPPI is installed
		return false
	end

end

local function SpawnSCarThroughVehicleMenuFix( ply, veh )
	if IsValid(veh) and string.find( veh:GetClass( ), "sent_sakarias_car" ) then
		if veh.Reposition == nil then
			SCarsReportError("Tried to spawn SCar but the Reposition function didn't exist!\n This isn't supposed to happen. You broke something!", 250)
			return
		end

		local wheelHeightAdd = veh.AddSpawnHeight

		veh:SetPos(veh:GetPos() + veh:GetUp() * wheelHeightAdd)
		veh:Reposition()

		veh.handBreakDel = CurTime() + 2
		veh.SpawnedBy = ply
		veh:UpdateAllCharacteristics()
		veh:SetCarOwner( ply )
	else
		SCarsReportError("Could not spawn SCar for an unknown reason!", 250)
	end
end
hook.Add( "PlayerSpawnedVehicle", "SpawnSCarThroughVehicleMenuFix", SpawnSCarThroughVehicleMenuFix )
