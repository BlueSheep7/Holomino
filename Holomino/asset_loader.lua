-- Graphics Sounds Music and Font Loader --
-- Last Updated: 07/07/2021 --

-- love.graphics.setDefaultFilter("nearest","nearest")


local function loadImages(path)
	local img = {}
	local files = love.filesystem.getDirectoryItems(path)
	local k
	local v
	
	for k,v in pairs (files) do
		if love.filesystem.getInfo(path.."/"..v).type == "directory" then
			img[v] = loadImages(path.."/"..v)
			
		elseif string.sub(v, #v - 3) == ".png" or string.sub(v, #v - 3) == ".jpg" or string.sub(v, #v - 3) == ".gif" then
			img[string.sub(v, 1, #v - 4)] = love.graphics.newImage(path.."/"..v)
			
		end
	end
	
	return img
	
end

local function loadSounds(path, stream_type)
	local sound = {}
	local files = love.filesystem.getDirectoryItems(path)
	local k
	local v
	
	for k,v in pairs (files) do
		if love.filesystem.getInfo(path.."/"..v).type == "directory" then
			sound[v] = loadSounds(path.."/"..v, stream_type)
			
		elseif string.sub(v, #v - 3) == ".ogg" or string.sub(v, #v - 3) == ".wav" or string.sub(v, #v - 3) == ".mp3" then
			sound[string.sub(v, 1, #v - 4)] = love.audio.newSource(path.."/"..v, stream_type)
			if string.sub(v, #v - 8, #v - 4) == "_loop" then
				sound[string.sub(v, 1, #v - 4)]:setLooping(true)
			end
			
		end
	end
	
	return sound
	
end

local function loadFonts(path)
	local font = {}
	local files = love.filesystem.getDirectoryItems(path)
	local k
	local v
	
	for k,v in pairs (files) do
		if love.filesystem.getInfo(path.."/"..v).type == "directory" then
			font[v] = loadFonts(path.."/"..v)
			
		elseif string.sub(v, #v - 3) == ".ttf" or string.sub(v, #v - 3) == ".ttc" or string.sub(v, #v - 3) == ".otf" then
			font[string.sub(v, 1, #v - 4)] = love.graphics.newFont(path.."/"..v)
			
		end
	end
	
	return font
	
end


img = loadImages("graphics")

sound = loadSounds("sounds", "static")
music = loadSounds("music", "stream")

-- font = loadFonts("fonts")


function stopAll(tbl)
	for k,v in pairs (tbl) do
		if type(v) == "table" then
			stopAll(v)
		else
			v:stop()
		end
	end
end


