SCarKeys = {}
SCarKeys.NrOfBoundKeyEvents = 0
SCarKeys.KeyVarTransTable = {}
SCarKeys.DefaultKeys = {}
SCarKeys.KeyName = {}
SCarKeys.KeyIsNetworked = {}
SCarKeys.IdToKeyNameTrans = {}

function SCarKeys:BuildKeyInfo()

	local keys = list.Get("ScarKeys")
	SCarKeys.NrOfBoundKeyEvents = table.Count(keys)

	for k, v in pairs( keys ) do
		SCarKeys.KeyVarTransTable[k] = v[1]
		SCarKeys.DefaultKeys[k] = v[2]
		SCarKeys.KeyName[k] = v[3]
		SCarKeys.KeyIsNetworked[k] = v[4]
		SCarKeys.IdToKeyNameTrans[SCarKeys.KeyVarTransTable[k]] = k
	end
	
	if (CLIENT) then
		SCarKeys:ClInit()
	end
end

function SCarKeys:RebuildKeyInfo()
	SCarKeys:BuildKeyInfo()
	
	if CLIENT then
		SCarKeys:RebuildKeys()
	end
end

