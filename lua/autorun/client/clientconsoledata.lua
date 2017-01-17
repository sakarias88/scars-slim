
list.Add("ScarClConvarOptions", { "Show driver in first person view", "scar_draw_driver_in_fp", 1} )
list.Add("ScarClConvarOptions", { "Share radio station with driver", "scar_shareradiostation", 1} )
list.Add("ScarClConvarOptions", { "Use point lights when braking", "scar_usepointlights", 1} )
list.Add("ScarClConvarOptions", { "Swosh effect when car spins", "scar_swosheffect", 1} )
list.Add("ScarClConvarOptions", { "Kmh(checked) or Mph(unchecked)", "scar_kmormiles", 1} )
list.Add("ScarClConvarOptions", { "Auto move cam in reverse", "scar_autoreversecam", 1} )
list.Add("ScarClConvarOptions", { "Race Music", "scar_useracemusic", 1} )
list.Add("ScarClConvarOptions", { "Race help arrow (points at closest checkpoint)", "scar_usecheckarrow", 1} )
list.Add("ScarClConvarOptions", { "Detailed driver animations", "scar_usedetailedanimations", 0} )
--list.Add("ScarClConvarOptions", { "Adapt effects depending on terrain material", "scar_adapteffects", 1} )

list.Add("ScarClConvarMisc", {"scar_rearviewmirror_use", 0, true} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_posx", 50, false} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_posy", 2, false} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_sizex", 50, false} )
list.Add("ScarClConvarMisc", {"scar_rearviewmirror_sizey", 17, false} )


SCarClientData = {}

for k, v in pairs( list.Get("ScarClConvarOptions") ) do
	CreateClientConVar(v[2], v[3], true, false)
	
	if GetConVarNumber( v[2] ) == 1 then
		SCarClientData[v[2]] = true
	else
		SCarClientData[v[2]] = false
	end
	
end


for k, v in pairs( list.Get("ScarClConvarMisc") ) do
	CreateClientConVar(v[1], v[2], true, false)
	
	if v[3] == true then
		if GetConVarNumber( v[1] ) == 1 then
			SCarClientData[v[1]] = GetConVarNumber( v[1] )
		else
			SCarClientData[v[1]] = false
		end	
	else
		SCarClientData[v[1]] = GetConVarNumber( v[1] )
	end
end



