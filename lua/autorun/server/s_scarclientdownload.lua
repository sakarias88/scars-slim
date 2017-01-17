--[[
These are all off by default.
Why?
Because no one will join your server if they have to download 2500 files!
It's better that all cars show up as errors and they have to dowload it manually.
You still have the option to tell the client to download everything.
--]]

local DownloadSounds 		= false --Dowload all sounds
local DownloadMaterials 	= false --Dowload all materials
local DownloadModels 		= false --Dowload all models




--This function will add files the client should download
--The path starts from the SCars addon folder
--AddDownloadDirectory("models", "mdl") will add all the models in the models folder.
--The first argument is the directory and the second is the filetype you want to add.
--Leaving the filetype will make it add all files




function AddDownloadDirectory(addon, dir, filt)
	local files, dirs = file.Find( "addons/"..addon.."/"..dir.."/*" , "MOD")
	for _, fdir in pairs(dirs) do
		if fdir != ".svn" then --Don't add svn folders.
			AddDownloadDirectory(addon, dir.."/"..fdir, filt)
		end
	end
	
	for k,v in pairs(files) do
		if !file.IsDir("../addons/"..addon.."/"..dir.."/"..v, "MOD") then --Don't add folders
		
			if filt then --Check the file if we have one
				local expl = string.Explode( ".", v )
				local exte = expl[table.Count( expl )]
				
				if exte == filt then
					resource.AddFile(dir.."/"..v)
				end			
			else
				resource.AddFile(dir.."/"..v)
			end
		end
	end
end


if DownloadSounds then
	--Adding sound
	AddDownloadDirectory("SCars Slim", "sound") 				
	AddDownloadDirectory("SCars Basic", "sound") 
	AddDownloadDirectory("SCars Extra", "sound") 	
end

if DownloadMaterials then
	--Adding materials
	AddDownloadDirectory("SCars Slim", "materials", "vmt") 	
	AddDownloadDirectory("SCars Basic", "materials", "vmt") 
	AddDownloadDirectory("SCars Extra", "materials", "vmt") 	
else
	--Tab icon
	resource.AddFile( "materials/SCarMisc/scar.vmt" ) 
end

if DownloadModels then
	--Adding models
	AddDownloadDirectory("SCars Slim", "models", "mdl") 	
	AddDownloadDirectory("SCars Basic", "models", "mdl") 
	AddDownloadDirectory("SCars Extra", "models", "mdl") 
end


