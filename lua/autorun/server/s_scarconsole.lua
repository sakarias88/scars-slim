concommand.Add( "sakarias_changelimit", function( ply, com, args )
	if ply:IsAdmin() then
		if ( string.match( args[1], "scar_[a-zA-z]+" ) and tonumber( args[2] ) ) then
			RunConsoleCommand( args[1], args[2] )
			SCarGetFastConvar[args[1]] = tonumber(args[2])
		end
	end	
end)

concommand.Add( "sakarias_updateallvehicles", function( ply, com, args )
	if !game.SinglePlayer() and ply:IsAdmin() then	
		for k, v in pairs( ents.GetAll() ) do
			if string.find( v:GetClass( ), "sent_sakarias_car" ) && not(string.find( v:GetClass( ), "sent_sakarias_carwheel" ) or string.find( v:GetClass( ), "sent_sakarias_carwheel_punked" ) or v.IsDestroyed == 1) then
				v:UpdateAllCharacteristics()	
			end 
		end
	end
end)


concommand.Add( "scar_setradiochannel", function( ply, com, args )
	if args[1] and args[2] and ply:InVehicle() then
		local veh = ply:GetVehicle()
		
		if veh and veh.SeatPosID and veh.SeatPosID == 1 then
			veh.EntOwner:SetCurrentRadioStation(args[1], args[2] )
		end
	end	
end)

local function MakeVehicle( Player, Pos, Ang, Model, Class, VName, VTable )

    if (!gamemode.Call( "PlayerSpawnVehicle", Player, Model, VName, VTable )) then return end
    
	local MaxCarsAllowed  = GetConVarNumber( "scar_maxscars" )
	local nrOfCars = Player:GetCount( "SCar" )   
	local carInfo = SCarRegister:GetInfo( Class )
	
	if carInfo.IsMissingDependencies then
		Player:PrintMessage( HUD_PRINTTALK, carInfo.Name.." Dependency info: "..carInfo.DependencyNotice)
		return false
	end
	
	if !game.SinglePlayer() and carInfo and carInfo.AdminOnly and !Player:IsAdmin() and GetConVarNumber( "scar_admincarspawn" ) == 0 then
		Player:PrintMessage( HUD_PRINTTALK, carInfo.Name.." is admin only")
		return false 	
	end		   	   
	   
	if !game.SinglePlayer() and nrOfCars >= MaxCarsAllowed - 1 then 	
		Player:PrintMessage( HUD_PRINTTALK, "You have reached SCar spawn limit")
		return false 
	end	
	
    local Ent = ents.Create( Class )
    if (!Ent) then return NULL end
    
    Ent:SetModel( Model )
    
    // Fill in the keyvalues if we have them
    if ( VTable && VTable.KeyValues ) then
        for k, v in pairs( VTable.KeyValues ) do
            Ent:SetKeyValue( k, v )
        end        
    end
        
    Ent:SetAngles( Ang )
    Ent:SetPos( Pos )
        
    Ent:Spawn()
    Ent:Activate()
    
    Ent.VehicleName     = VName
    Ent.VehicleTable     = VTable
    
    // We need to override the class in the case of the Jeep, because it
    // actually uses a different class than is reported by GetClass
    Ent.ClassOverride     = Class
	
    gamemode.Call( "PlayerSpawnedVehicle", Player, Ent )
    return Ent    
    
end

local function CCSpawnSCar( Player, command, arguments )
    if ( arguments[1] == nil ) then return end
	
	if !Player or !Player.IsPlayer or !Player:IsPlayer() then
		Player = game.GetWorld()
	end
	
	if SCarGetFastConvar["scar_scarspawnadminonly"] == 1 and Player:IsAdmin() == false then 
		Player:PrintMessage( HUD_PRINTTALK, "Only admins are allowed to spawn SCars")
		return false 
	end
	
    local vname = arguments[1]
    local VehicleList = list.Get( "SCarVehicles" )
    local vehicle = VehicleList[ vname ]

    // Not a valid vehicle to be spawning..
    if ( !vehicle ) then return end
	
    local tr = Player:GetEyeTraceNoCursor()
    
    local Angles = Player:GetAngles()
        Angles.pitch = 0
        Angles.roll = 0
        Angles.yaw = Angles.yaw + 180
    

    local Ent = MakeVehicle( Player, tr.HitPos, Angles, vehicle.Model, vehicle.Class, vname, vehicle )
    if ( !IsValid( Ent ) ) then return end
    
    if ( vehicle.Members ) then
        table.Merge( Ent, vehicle.Members )
        duplicator.StoreEntityModifier( Ent, "VehicleMemDupe", vehicle.Members );
    end
    
    undo.Create( "SCars" )
        undo.SetPlayer( Player )
        undo.AddEntity( Ent )
        undo.SetCustomUndoText( "Undone "..vehicle.Name )
    undo.Finish( "SCars ("..tostring( vehicle.Name )..")" )
    
    Player:AddCleanup( "SCars", Ent )
end

concommand.Add( "gm_spawnscar", CCSpawnSCar )