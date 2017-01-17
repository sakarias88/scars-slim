
SCarAiHandler = {}
SCarAiHandler.AI = {}
SCarAiHandler.nrOfAI = 0

SCarAiHandler.AIUnique = {}
SCarAiHandler.AIMetas = {}

--//Creating ai default meta table
AIDEF = {}
AIDEF.Title = "NO TITLE"
AIDEF.Author = "NO AUTHOR"
AIDEF.IsState = false --If this is true it won't be added to the stool
AIDEF.Owner = nil -- This will be the entity that uses the AI
AI_DEF = { __index = AIDEF }

function AIDEF:Init()
end

function AIDEF:OnTakeDamage(dmg)
end

function AIDEF:FastThink()
end

function AIDEF:Think()
end

function AIDEF:CarCollide( data, phys )
end

function AIDEF:PlayerEnteredSCar( player )
end

function AIDEF:LeftWhiskerHit()
end

function AIDEF:RightWhiskerHit()
end

function AIDEF:FrontWhiskerHit()
end

function AIDEF:RearWhiskerHit()
end

function SCarAiHandler:Init()
	local ais = {}
	ais =	file.Find( "scarai/*.lua" , "LUA")
	for _, plugin in ipairs( ais ) do
		include( "scarai/" .. plugin )
	end	
end

function SCarAiHandler:registerAI( regAI )
	if regAI.Title then
		--Msg("Registered AI: "..regAI.Title.."\n")
		setmetatable(regAI, AI_DEF)
		SCarAiHandler.AIUnique[regAI.Title] = regAI
		SCarAiHandler.AIMetas[regAI.Title] = { __index = SCarAiHandler.AIUnique[regAI.Title] }
	end	
end

function SCarAiHandler:GetAiByName( name )

	if SCarAiHandler.AIMetas[name] then
		local tabl = {}
		setmetatable(tabl, SCarAiHandler.AIMetas[name])
		
		return tabl;
	end
	
	return nil
end

function SCarAiHandler:GetTableOfTitles()

	local names = {}
	local nrOfNames = 0
	
	for k, v in pairs(SCarAiHandler.AIUnique) do
		if v.IsState != true then
			
			nrOfNames = nrOfNames + 1
			names[nrOfNames] = k
		end	
	end
	return nrOfNames, names
end
