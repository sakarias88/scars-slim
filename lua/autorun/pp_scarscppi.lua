local function SCarsCreateCPPI_PP_Functions()
	local meta = FindMetaTable("Entity")
	meta.SCarsSetOldOwner = meta.CPPISetOwner
	
	function meta:CPPISetOwner(ply)	
		if IsValid(ply) && IsValid(self) and self.Base and (self.Base == "sent_sakarias_scar_base" or self:GetClass() == "sent_sakarias_checkPoint" ) then
			self:SetCarOwner(ply)
		end
		
		if self.SCarsSetOldOwner then
			return self:SCarsSetOldOwner(ply)
		end
	end
end
hook.Add( "Initialize", "SCarsCreateCPPI_PP_Functions", SCarsCreateCPPI_PP_Functions );