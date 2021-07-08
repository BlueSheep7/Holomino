-- Library Manager
-- Last Updated: 28/03/2021 --


utf8 = require("utf8")
math.randomseed(os.time())
math.random()


-- Draw Functions --
drawable = {}
function drawable_add(lib, id, y, args)
	if #drawable == 0 or y > drawable[#drawable].y then
		table.insert(drawable, {lib = lib, id = id, y = y, args = args})
	else
		for drawindex, drawvalue in pairs(drawable) do
			if y < drawvalue.y then
				table.insert(drawable, drawindex, {lib = lib, id = id, y = y, args = args})
				break
			end
		end
	end
end

function drawable_remove(id)
	for drawindex, drawvalue in pairs(drawable) do
		if drawvalue.id == id then
			table.remove(drawable, drawindex)
			-- break
		end
	end
end

function drawable_remove_lib(lib)
	for drawindex, drawvalue in pairs(drawable) do
		if drawvalue.lib == lib then
			table.remove(drawable, drawindex)
		end
	end
end

function drawable_update(id, y) -- SUPER INEFFICIENT. PLEASE REDO --
	for drawindex, drawvalue in pairs(drawable) do
		if drawvalue.id == id then
			moved = drawvalue
			table.remove(drawable, drawindex)
			if #drawable == 0 or y > drawable[#drawable].y then
				table.insert(drawable, {lib = moved.lib, id = moved.id, y = y, args = moved.args})
			else
				for drawindex, drawvalue in pairs(drawable) do
					if y < drawvalue.y then
						table.insert(drawable, drawindex, {lib = moved.lib, id = moved.id, y = y, args = moved.args})
						break
					end
				end
			end
			break
		end
	end
end


-- Other Global Functions --
function progress(var, max)
	if var + 1 > max then
		return 1
	else
		return var + 1
	end
end

function table.clone(t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = table.clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

function string.split(str, splitter)
	local t = {}
	local c = 1
	local lastc = 1
	while c <= #str - #splitter + 1 do
		if string.sub(str, c, c + #splitter - 1) == splitter then
			table.insert(t, string.sub(str, lastc, c-1))
			c = c + #splitter
			lastc = c
		else
			c = c + 1
		end
	end
	table.insert(t, string.sub(str, lastc, #str))
	return t
end

function getRotFromVec(x1, y1, x2, y2)
	local r = math.atan((y2 - y1) / (x2 - x1))
	if x2 < x1 then
		r = r + math.pi
	end
	if x1 == x2 then
		if y1 < y2 then
			r = math.pi/2
		else
			r = math.pi/2*3
		end
	end
	if r > math.pi*2 then r = r - math.pi*2 end
	if r < 0 then r = r + math.pi*2 end
	return r
end


-- Grab libraries from Lua files --
libs = {}
file = love.filesystem.getDirectoryItems("")
for k,v in pairs(file) do
	if string.sub(v, #v - 3) == ".lua" then
		if v ~= "main.lua" and v ~= "conf.lua" then
			local t = os.clock()
			io.write("Loading library: "..v.."...")
			newlib = require(string.sub(v, 1, #v - 4))
			if newlib ~= true then
				table.insert(libs, newlib)
			end
			print("done. ("..(os.clock()-t).."s)")
		end
	end
end


-- Load --
function love.load(dt)
	for libindex, lib in pairs(libs) do
		if lib.load then
			lib.load(dt)
		end
	end
end

-- Draw --
function love.draw()
	for drawindex, drawvalue in pairs(drawable) do
		if drawvalue.lib.draw and (not drawvalue.lib.in_mode or drawvalue.lib.in_mode == game.mode) then
			drawvalue.lib.draw(drawvalue.id, drawvalue.args)
		end
	end
end

-- Update --
function love.update(dt)
	if debugger and debugger.time_scale then
		dt = dt * debugger.time_scale
	end
	for libindex, lib in pairs(libs) do
		if lib.update and (not lib.in_mode or lib.in_mode == game.mode) then
			lib.update(dt)
		end
	end
end


-- Interact --
interacttable = {} -- not a typo. interact + table, not interactable
for libindex, lib in pairs(libs) do
	if lib.interactorder then
		
		if #interacttable == 0 or lib.interactorder > interacttable[#interacttable].interactorder then
			table.insert(interacttable, lib)
		elseif lib.interactorder == interacttable[#interacttable].interactorder then
			love.errhand("Warning: Overlap found in interact table at "..lib.libname.." ("..lib.interactorder..")")
		else
			for k, v in pairs(interacttable) do
				if lib.interactorder == v.interactorder then
					love.errhand("Warning: Overlap found in interact table at "..libindex)
				elseif lib.interactorder < v.interactorder then
					table.insert(interacttable, k, lib)
					break
				end
			end
		end
		
	end
end
-- for libindex, lib in pairs (libs) do
	-- if not lib.interactorder then
		-- table.insert(interacttable, lib)
	-- end
-- end

-- Key Pressed --
function love.keypressed(key)
	for libindex, lib in pairs(interacttable) do
		if lib.keypressed and (not lib.in_mode or lib.in_mode == game.mode)  then
			if lib.keypressed(key) then break end
		end
	end
end

-- Key Released --
function love.keyreleased(key)
	for libindex, lib in pairs(interacttable) do
		if lib.keyreleased and (not lib.in_mode or lib.in_mode == game.mode)  then
			lib.keyreleased(key)
		end
	end
end

-- Text Input --
function love.textinput(text)
	for libindex, lib in pairs(interacttable) do
		if lib.textinput and (not lib.in_mode or lib.in_mode == game.mode)  then
			if lib.textinput(text) then break end
		end
	end
end

-- Mouse Pressed --
function love.mousepressed(x, y, b)
	for libindex, lib in pairs(interacttable) do
		if lib.mousepressed and (not lib.in_mode or lib.in_mode == game.mode)  then
			if lib.mousepressed(x, y, b) then break end
		end
	end
end

-- Mouse Released --
function love.mousereleased(x, y, b)
	for libindex, lib in pairs(interacttable) do
		if lib.mousereleased and (not lib.in_mode or lib.in_mode == game.mode)  then
			lib.mousereleased(x, y, b)
		end
	end
end

-- Mouse Wheel --
function love.wheelmoved(x, y)
	for libindex, lib in pairs(interacttable) do
		if lib.wheelmoved and (not lib.in_mode or lib.in_mode == game.mode)  then
			if lib.wheelmoved(x, y, b) then break end
		end
	end
end
