-- Tetris --

-- TODO:
-- verify scoring is correct
-- hololive sound effects
-- ask for permission
-- final score animation
-- test on 4K monitor
-- more customizable tile textures
-- random voice sfx on volume change
-- new background / permission
-- high gravity lag bug

-- Future Features:
-- Shaders
-- full clear detection
-- auto-place time meter display?
-- more easter eggs
-- choose start level
-- id3
-- F
-- piece character selection
-- cursed hololive block textures
-- make it fun - someone steals blocks?
-- music + background customization
-- multiplayer
-- demo record
-- queue sounds
-- save game to disk
-- next shape sound effect

-- Horror:
-- Glitch effect
-- Heartbeat as you get closer to top
-- Jumpscare when you die
-- mess with music pitch

-- BEFORE RELEASE CHECKLIST:
-- turn off debug console
-- update version number
-- delete hidden / unneeded files
-- delete / disable debug code
-- window size

tetris = {}
tetris.libname = "tetris"
tetris.interactorder = 2
drawable_add(tetris, "tetris", 0)


-- constants --
tetris.tile_w = 40
tetris.grid_w = 10
tetris.grid_h = 25
tetris.grid_draw_h = 20
tetris.spawn_y = 21 -- DIFFERENT VERSIONS OF TETRIS USE DIFFERENT VALUES
tetris.side_move_delay = 1/5
tetris.side_move_repeat_delay = 1/20
tetris.down_move_delay = 1/20
tetris.block_choice = {"I", "J", "L", "O", "S", "T", "Z"}
tetris.who_choice = {I = "gura_tile", J = "ina_tile", L = "coco_tile", O = "akai_tile", S = "amelia_tile", T = "suisei_tile", Z = "ayame_tile", F = "lol"}
tetris.q_length = math.max(#tetris.block_choice - 2, 1)
tetris.lock_delay = 0.5
tetris.lock_max_moves = 15
tetris.line_clear_delay = 0.3

tetris.backgrounds = {
{img = "suisei_tobacco.jpg", artist = "@laxyiii", link = "https://twitter.com/laxyiii/status/1271059561986904069", anchor = "left"},
{img = "Hololive_FPS.png", artist = "Ruipi", link = "https://www.pixiv.net/en/artworks/84818998", anchor = "left"},
{img = "gura_cooking.jpg", artist = "@ETTA03135813", link = "https://twitter.com/ETTA03135813/status/1343513759646588933", anchor = "right"},
{img = "EN_L4D.jpg", artist = "@ETTA03135813", link = "https://twitter.com/ETTA03135813/status/1343513759646588933", anchor = "left"},
{img = "suisei_singing.png", artist = "@monochrome_shio", link = "https://twitter.com/monochrome_shio/status/1263079159795838982", anchor = "left"},
{img = "ina_giant.jpg", artist = "@Anonamos_701", link = "https://twitter.com/Anonamos_701/status/1329892272234704898", anchor = "left"},
{img = "aqua_ark.jpg", artist = "@NAMCOOo", link = "https://twitter.com/namcooo/status/1245687872973242368", anchor = "right"},
{img = "miko_ark.jpg", artist = "@NAMCOOo", link = "https://twitter.com/namcooo/status/1245687872973242368", anchor = "left"},
{img = "aki_ark.jpg", artist = "@NAMCOOo", link = "https://twitter.com/namcooo/status/1245687872973242368", anchor = "right"},
}

-- Wall Kick Checks --
tetris.kick_checks = {}
for w = 2, 4 do
	tetris.kick_checks[w] = {}
	for r = 0, 3 do
		tetris.kick_checks[w][r] = {}
	end
end

tetris.kick_checks[2][0][1] = {{ 0, 0}}
tetris.kick_checks[2][0][3] = {{ 0, 0}}
tetris.kick_checks[2][1][0] = {{ 0, 0}}
tetris.kick_checks[2][1][2] = {{ 0, 0}}
tetris.kick_checks[2][2][1] = {{ 0, 0}}
tetris.kick_checks[2][2][3] = {{ 0, 0}}
tetris.kick_checks[2][3][0] = {{ 0, 0}}
tetris.kick_checks[2][3][2] = {{ 0, 0}}

tetris.kick_checks[3][0][1] = {{ 0, 0}, {-1, 0}, {-1, 1}, { 0,-2}, {-1,-2}}
tetris.kick_checks[3][0][3] = {{ 0, 0}, { 1, 0}, { 1, 1}, { 0,-2}, { 1,-2}}
tetris.kick_checks[3][1][0] = {{ 0, 0}, { 1, 0}, { 1,-1}, { 0, 2}, { 1, 2}}
tetris.kick_checks[3][1][2] = {{ 0, 0}, { 1, 0}, { 1,-1}, { 0, 2}, { 1, 2}}
tetris.kick_checks[3][2][1] = {{ 0, 0}, {-1, 0}, {-1, 1}, { 0,-2}, {-1,-2}}
tetris.kick_checks[3][2][3] = {{ 0, 0}, { 1, 0}, { 1, 1}, { 0,-2}, { 1,-2}}
tetris.kick_checks[3][3][0] = {{ 0, 0}, {-1, 0}, {-1,-1}, { 0, 2}, {-1, 2}}
tetris.kick_checks[3][3][2] = {{ 0, 0}, {-1, 0}, {-1,-1}, { 0, 2}, {-1, 2}}

tetris.kick_checks[4][0][1] = {{ 0, 0}, {-2, 0}, { 1, 0}, {-2,-1}, { 1, 2}}
tetris.kick_checks[4][0][3] = {{ 0, 0}, {-1, 0}, { 2, 0}, {-1, 2}, { 2,-1}}
tetris.kick_checks[4][1][0] = {{ 0, 0}, { 2, 0}, {-1, 0}, { 2, 1}, {-1,-2}}
tetris.kick_checks[4][1][2] = {{ 0, 0}, {-1, 0}, { 2, 0}, {-1, 2}, { 2,-1}}
tetris.kick_checks[4][2][1] = {{ 0, 0}, { 1, 0}, {-2, 0}, { 1,-2}, {-2, 1}}
tetris.kick_checks[4][2][3] = {{ 0, 0}, { 2, 0}, {-1, 0}, { 2, 1}, {-1,-2}}
tetris.kick_checks[4][3][0] = {{ 0, 0}, { 1, 0}, {-2, 0}, { 1,-2}, {-2, 1}}
tetris.kick_checks[4][3][2] = {{ 0, 0}, {-2, 0}, { 1, 0}, {-2,-1}, { 1, 2}}

tetris.tspin_checks = {}
tetris.tspin_checks[0] = {A = {x = -1, y = 1},	B = {x = 1, y = 1},		C = {x = -1, y = -1},	D = {x = 1, y = -1}}
tetris.tspin_checks[1] = {A = {x = 1, y = 1},	B = {x = 1, y = -1},	C = {x = -1, y = 1},	D = {x = -1, y = -1}}
tetris.tspin_checks[2] = {A = {x = 1, y = -1},	B = {x = -1, y = -1},	C = {x = 1, y = 1},		D = {x = -1, y = 1}}
tetris.tspin_checks[3] = {A = {x = -1, y = -1},	B = {x = -1, y = 1},	C = {x = 1, y = -1},	D = {x = 1, y = 1}}

-- Piece Particles --
tetris.piece_dust = love.graphics.newParticleSystem(img.ui.particle_circle, 1000)
tetris.piece_dust:setParticleLifetime(0.7)
tetris.piece_dust:setEmissionRate(0)
tetris.piece_dust:setLinearDamping(1, 1)
tetris.piece_dust:setEmissionArea("normal", 30, 10, 0, false)
tetris.piece_dust:setSpeed(300, 600)
tetris.piece_dust:setDirection(math.pi * 3/2)
tetris.piece_dust:setSpread(math.pi/2)
tetris.piece_dust:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
tetris.piece_dust:setSizes(0.8)

-- Line Clear Particles --
tetris.line_clear_dust = love.graphics.newParticleSystem(img.ui.particle_circle, 1000)
tetris.line_clear_dust:setParticleLifetime(1)
tetris.line_clear_dust:setEmissionRate(0)
tetris.line_clear_dust:setEmissionArea("uniform", tetris.grid_w * tetris.tile_w / 2, tetris.tile_w/2, 0, false)
tetris.line_clear_dust:setSpeed(-500, 500)
tetris.line_clear_dust:setColors(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
tetris.line_clear_dust:setSizes(0.8)

-- Create Empty Grid --
tetris.grid = {}
for x = 0, tetris.grid_w-1 do
	tetris.grid[x] = {}
	for y = 0, tetris.grid_h-1 do
		tetris.grid[x][y] = {tile = 0, block_type = "", r = 0, who = ""}
	end
end

-- Load Block Types --
tetris.block = {}
tetris.block_info = {}
files = love.filesystem.getDirectoryItems("blocks")
for k,v in pairs (files) do
	if love.filesystem.getInfo("blocks/"..v).type ~= "directory" and string.sub(v, #v - 3) == ".png" then
		img_data = love.image.newImageData("blocks/"..v)
		local block_name = string.sub(v, 1, #v - 4)
		tetris.block[block_name] = {}
		tetris.block_info[block_name] = {w = img_data:getHeight(), quad = {}}
		
		for r = 0, 3 do
			tetris.block[block_name][r] = {}
			for x = 0, img_data:getHeight()-1 do
				tetris.block[block_name][r][x] = {}
				for y = 0, img_data:getHeight()-1 do
					red, green, blue, alpha = img_data:getPixel(x + r * img_data:getHeight() + r, y)
					if alpha == 1 then
						red = math.max(red * 255, 1)
						tetris.block[block_name][r][x][y] = red
						
						if r == 0 then
							tetris.block_info[block_name].quad[red] = love.graphics.newQuad(x * tetris.tile_w, y * tetris.tile_w, tetris.tile_w, tetris.tile_w, img_data:getHeight() * tetris.tile_w, img_data:getHeight() * tetris.tile_w)
						end
					else
						tetris.block[block_name][r][x][y] = 0
					end
				end
			end
		end
		
	end
end

-- Load High Score --
dat = love.filesystem.read("highscore")
if dat then
	
	tetris.high_score = tonumber(string.sub(dat, #"IF YOU TRY TO EDIT THIS, YOU ARE A DISHONORABLE GAMER\n"))
	
else
	
	tetris.high_score = 0

end

-- runs when a game is started / reset / resumed
function tetris.prepare()
	
	ui.counting_down = true
	ui.count_down_num = 4
	ui.count_down_tick = 0
	ui.count_down_voice = ui.count_down_voices[math.random(1, #ui.count_down_voices)]
	
	tetris.piece_dust:reset()
	
	if tetris.background_img then
		tetris.background_img = nil
		collectgarbage()
	end
	tetris.background = math.random(1, #tetris.backgrounds)
	tetris.background_img = love.graphics.newImage("backgrounds/"..tetris.backgrounds[tetris.background].img)

	ui.element["start_btn"].title = {"RESUME", "続ける"}
	
	ui.announce = {}
	
end

-- runs when a game is started / reset
function tetris.load()
	
	for x = 0, tetris.grid_w-1 do
		for y = 0, tetris.grid_h-1 do
			tetris.grid[x][y].tile = 0
			tetris.grid[x][y].block_type = ""
			tetris.grid[x][y].r = 0
			tetris.grid[x][y].who = ""
		end
	end
	
	tetris.q_type = {}
	tetris.q_who = {}
	tetris.fillQ()
	
	tetris.piece_type, tetris.piece_who = tetris.nextBlock()
	tetris.piece_reset()
	
	tetris.hold_type = false
	tetris.hold_who = false
	tetris.holded = false
	
	tetris.next_anime_tick = 0
	
	tetris.line_clear_tick = 0
	tetris.line_clear_table = {}
	
	tetris.score = 0
	tetris.lines_cleared = 0
	tetris.back_to_back = false
	tetris.level = 0
	tetris.fall_delay = (0.8-((tetris.level-1)*0.007))^(tetris.level-1)
	
	tetris.game_over = false
	
end

-- runs when a piece is created
function tetris.piece_reset()
	
	tetris.piece_x = tetris.grid_w / 2 - math.ceil(tetris.block_info[tetris.piece_type].w/2)
	tetris.piece_y = tetris.spawn_y
	tetris.piece_r = 0
	
	tetris.calculateGhost()
	
	tetris.gravity_tick = 0
	tetris.side_move_tick = 0
	tetris.double_press_tick = settings.double_press_protection
	
	tetris.piece_life = 0
	tetris.lock_tick = 0
	tetris.lowest_y = tetris.piece_y
	tetris.lock_moves = 0
	
	tetris.tspin = false
	tetris.tspin_mini = false
	
end


function tetris.draw(this)
	
	if ui.menu_open ~= "game" and ui.menu_open ~= "gameover" then
		return
	end
	
	-- background --
	love.graphics.origin()
	love.graphics.setColor(0.5, 0.5, 0.5)
	local scale = math.max(love.graphics.getHeight() / tetris.background_img:getHeight(), love.graphics.getWidth() / tetris.background_img:getWidth())
	if tetris.backgrounds[tetris.background].anchor == "left" then
		love.graphics.draw(tetris.background_img, 0, 0, 0, scale, scale)
	elseif tetris.backgrounds[tetris.background].anchor == "right" then
		love.graphics.draw(tetris.background_img, love.graphics.getWidth(), 0, 0, scale, scale, tetris.background_img:getWidth(), 0)
	end
	
	-- Game --
	love.graphics.origin()
	love.graphics.translate(tetris.getCamX(), tetris.getCamY())
	love.graphics.scale(tetris.getScale())
	
	love.graphics.setColor(0, 0, 0, 0.8)
	love.graphics.rectangle("fill", -5 * tetris.tile_w, 0, tetris.grid_w * tetris.tile_w, tetris.grid_draw_h * tetris.tile_w)
	
	-- New Grid --
	if settings.show_grid then
		love.graphics.setColor(1, 1, 1, 0.4)
		love.graphics.setLineWidth(1)
		for x = -4, 4 do
			love.graphics.line(x * tetris.tile_w, 0, x * tetris.tile_w, tetris.grid_draw_h * tetris.tile_w)
		end
		for y = 0, 19 do
			love.graphics.line(-5 * tetris.tile_w, y * tetris.tile_w, 5 * tetris.tile_w, y * tetris.tile_w)
		end
	end
	-- love.graphics.setColor(1, 0.2, 0.2)
	-- love.graphics.setLineWidth(2)
	-- love.graphics.line(-5 * tetris.tile_w, 1 * tetris.tile_w, 5 * tetris.tile_w, 1 * tetris.tile_w)
	
	-- Tiles --
	love.graphics.translate(-tetris.grid_w/2 * tetris.tile_w, 0)
	
	
	for x = 0, tetris.grid_w-1 do
		for y = 0, tetris.grid_h-1 do
			if tetris.grid[x][y].tile ~= 0 then
				
				love.graphics.setColor(1, 1, 1)
				
				if img.shape[tetris.grid[x][y].block_type][tetris.grid[x][y].who] and tetris.block_info[tetris.grid[x][y].block_type].quad[tetris.grid[x][y].tile] then
					-- love.graphics.draw(img.shape[tetris.grid[x][y].block_type][tetris.grid[x][y].who], tetris.block_info[tetris.grid[x][y].block_type].quad[tetris.grid[x][y].tile],
					-- (x) * tetris.tile_w + tetris.tile_w/2, (tetris.grid_draw_h - y - 1) * tetris.tile_w + tetris.tile_w/2, tetris.grid[x][y].r / 4 * math.pi * 2, 1, 1, tetris.tile_w/2, tetris.tile_w/2)
					love.graphics.draw(img.shape[tetris.grid[x][y].block_type][tetris.grid[x][y].who], tetris.block_info[tetris.grid[x][y].block_type].quad[1],
					(x) * tetris.tile_w + tetris.tile_w/2, (tetris.grid_draw_h - y - 1) * tetris.tile_w + tetris.tile_w/2, 0, 1, 1, tetris.tile_w/2, tetris.tile_w/2)
				else
					love.graphics.rectangle("fill", (x) * tetris.tile_w, (tetris.grid_draw_h - y - 1) * tetris.tile_w, tetris.tile_w, tetris.tile_w)
				end
				
				if tetris.line_clear_table[y] then
					love.graphics.setColor(ui.btn_fade_r2, ui.btn_fade_g2, ui.btn_fade_b2, 1 - tetris.line_clear_tick / tetris.line_clear_delay)
					love.graphics.rectangle("fill", (x) * tetris.tile_w, (tetris.grid_draw_h - y - 1) * tetris.tile_w, tetris.tile_w, tetris.tile_w)
				end
					
				
				-- if settings.show_grid then
					-- love.graphics.setColor(0, 0, 0)
					-- love.graphics.setLineWidth(2)
					-- love.graphics.rectangle("line", (x) * tetris.tile_w, (tetris.grid_draw_h - y - 1) * tetris.tile_w, tetris.tile_w, tetris.tile_w)
				-- end
				
			end
			-- love.graphics.setColor(1, 1, 1)
			-- love.graphics.setFont(debugger.font)
			-- love.graphics.print(x..","..y, (x) * tetris.tile_w + tetris.tile_w/2, (tetris.grid_draw_h - y - 1) * tetris.tile_w + tetris.tile_w/2)
		end
	end
	
	
	-- Particles
	if settings.show_particles then
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(tetris.piece_dust)
		love.graphics.draw(tetris.line_clear_dust)
	end
	
	
	-- Movable Piece --
	if ui.menu_open == "game" then
		if tetris.line_clear_tick > 0 then
			love.graphics.setColor(0.4, 0.4, 0.4)
		else
			love.graphics.setColor(1, 1, 1)
		end
		-- local anime_offset = math.min((tetris.gravity_tick / tetris.fall_delay) * 4, 1)
		tetris.drawPiece(tetris.piece_type, tetris.piece_who, tetris.piece_r, tetris.piece_x, tetris.grid_draw_h - tetris.piece_y - 1)
		
		
		-- Ghost --
		if tetris.line_clear_tick <= 0 then
			love.graphics.setColor(1, 1, 1, 0.2)
			if tetris.ghost_y then
				tetris.drawPiece(tetris.piece_type, tetris.piece_who, tetris.piece_r, tetris.piece_x, tetris.grid_draw_h - tetris.ghost_y - 1)
			end
		end
	end
	
	
	-- Hold --
	love.graphics.setColor(1, 1, 1)
	
	-- love.graphics.print("HOLD", 0, 0, 0, 2, 2)
	
	if tetris.hold_type and tetris.hold_who then
		
		if tetris.holded then
			love.graphics.setColor(0.4, 0.4, 0.4)
		end
		tetris.drawPiece(tetris.hold_type, tetris.hold_who, 0, -2 - tetris.block_info[tetris.hold_type].w, 1)
		
	end
	
	
	-- Next Up --
	love.graphics.setColor(1, 1, 1)
	
	-- love.graphics.print("NEXT UP", 0, 0, 0, 2, 2)
	
	for q = 1, tetris.q_length do
		
		if q == tetris.q_length and ui.menu_open == "game" then
			love.graphics.setColor(1, 1, 1, 1 - tetris.next_anime_tick)
		end
		tetris.drawPiece(tetris.q_type[q], tetris.q_who[q], 0, 10 + 2, 1 + (q-1 + tetris.next_anime_tick) * 3)
		
	end
	
	
end


function tetris.update(dt)
	
	tetris.double_press_tick = math.max(tetris.double_press_tick - dt, 0)
	
	if ui.menu_open ~= "game" and ui.menu_open ~= "gameover" then
		return
	end
	if ui.counting_down then
		return
	end
	
	-- particles --
	if settings.show_particles then
		tetris.piece_dust:update(dt)
		tetris.line_clear_dust:update(dt)
	end
	
	-- next up animation --
	if tetris.next_anime_tick > 0 then
		tetris.next_anime_tick = math.max(tetris.next_anime_tick - dt * 4, 0)
	end
	
	if ui.menu_open == "gameover" then
		return
	end
	
	-- line clear animation --
	if tetris.line_clear_tick > 0 then
		tetris.line_clear_tick = tetris.line_clear_tick - dt
		
		if tetris.line_clear_tick <= 0 then
			
			for index, this in pairs (tetris.line_clear_table) do
				if this then
					tetris.line_clear_dust:setPosition(tetris.grid_w * tetris.tile_w / 2, (tetris.grid_draw_h - index - 1) * tetris.tile_w + tetris.tile_w/2)
					tetris.line_clear_dust:emit(100)
				end
				
			end
			
			local y = 0
			while y < tetris.grid_h-1 do
				
				if tetris.line_clear_table[y] then
					
					for y2 = y, tetris.grid_h-2, 1 do
						for x2 = 0, tetris.grid_w-1 do
							tetris.grid[x2][y2].tile = tetris.grid[x2][y2 + 1].tile
							tetris.grid[x2][y2].block_type = tetris.grid[x2][y2 + 1].block_type
							tetris.grid[x2][y2].r = tetris.grid[x2][y2 + 1].r
							tetris.grid[x2][y2].who = tetris.grid[x2][y2 + 1].who
						end
						tetris.line_clear_table[y2] = tetris.line_clear_table[y2 + 1]
					end
					
				else
					y = y + 1
				end
				
			end
			
			tetris.calculateGhost()
			
			tetris.line_clear_table = {}
			
		end
		
		return
	end
	
	-- Fall --
	if (love.keyboard.isDown(settings.key_down) or joy.holding_down) and tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.piece_y - 1) then
		tetris.gravity_tick = tetris.gravity_tick + dt * 15
	else
		tetris.gravity_tick = tetris.gravity_tick + dt
	end
	while tetris.gravity_tick > tetris.fall_delay do
		tetris.gravity_tick = tetris.gravity_tick - tetris.fall_delay
		
		if tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.piece_y - 1) then
			
			tetris.piece_y = tetris.piece_y - 1
			
			
			tetris.tspin = false
			tetris.tspin_mini = false
			
			if tetris.piece_y < tetris.lowest_y then
				tetris.lowest_y = tetris.piece_y
				tetris.lock_moves = 0
				tetris.lock_tick = 0
			end
			
			if love.keyboard.isDown(settings.key_down) or joy.holding_down then
				tetris.score = tetris.score + 1
			end
			
		end
		
	end
	
	-- Lock --
	if not tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.piece_y - 1) then
		if tetris.lock_tick >= tetris.lock_delay then
			tetris.placeBlock(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.piece_y)
		else
			tetris.lock_tick = tetris.lock_tick + dt
		end
	end
	
	-- Move --
	if (love.keyboard.isDown(settings.key_left) or joy.holding_left) and not (love.keyboard.isDown(settings.key_right) or joy.holding_right) then
		
		tetris.side_move_tick = tetris.side_move_tick - dt
		if tetris.side_move_tick <= 0 then
			tetris.side_move_tick = tetris.side_move_tick + tetris.side_move_repeat_delay
			
			if tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x - 1, tetris.piece_y) then
				tetris.piece_x = tetris.piece_x - 1
				
				-- sound.tone_high:stop()
				-- sound.tone_high:play()
				
				tetris.calculateGhost()
				
				if tetris.lock_moves < tetris.lock_max_moves then
					tetris.lock_tick = 0
					tetris.lock_moves = tetris.lock_moves + 1
				end
				
				tetris.tspin = false
				tetris.tspin_mini = false
			end
		end
		
	end
	
	if (love.keyboard.isDown(settings.key_right) or joy.holding_right) and not (love.keyboard.isDown(settings.key_left) or joy.holding_left) then
		
		tetris.side_move_tick = tetris.side_move_tick - dt
		if tetris.side_move_tick <= 0 then
			tetris.side_move_tick = tetris.side_move_tick + tetris.side_move_repeat_delay
			
			if tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x + 1, tetris.piece_y) then
				tetris.piece_x = tetris.piece_x + 1
				
				-- sound.tone_high:stop()
				-- sound.tone_high:play()
				
				tetris.calculateGhost()
				
				if tetris.lock_moves < tetris.lock_max_moves then
					tetris.lock_tick = 0
					tetris.lock_moves = tetris.lock_moves + 1
				end
				
				tetris.tspin = false
				tetris.tspin_mini = false
			end
		end
		
	end
	
end


function tetris.keypressed(key)
	
	if ui.menu_open ~= "game" then
		return
	end
	if ui.counting_down then
		return
	end
	
	if tetris.line_clear_tick > 0 then
		return
	end
	
	if key == settings.key_left then
		
		if tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x - 1, tetris.piece_y) then
			tetris.piece_x = tetris.piece_x - 1
			
			sound.effects.tone_high:stop()
			sound.effects.tone_high:play()
			
			tetris.calculateGhost()
			
			if tetris.lock_moves < tetris.lock_max_moves then
				tetris.lock_tick = 0
				tetris.lock_moves = tetris.lock_moves + 1
			end
			
			tetris.tspin = false
			tetris.tspin_mini = false
		end
		
		tetris.side_move_tick = tetris.side_move_delay
		
	elseif key == settings.key_right then
		
		if tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x + 1, tetris.piece_y) then
			tetris.piece_x = tetris.piece_x + 1
			
			sound.effects.tone_high:stop()
			sound.effects.tone_high:play()
			
			tetris.calculateGhost()
			
			if tetris.lock_moves < tetris.lock_max_moves then
				tetris.lock_tick = 0
				tetris.lock_moves = tetris.lock_moves + 1
			end
			
			tetris.tspin = false
			tetris.tspin_mini = false
		end
		
		tetris.side_move_tick = tetris.side_move_delay
		
	elseif key == settings.key_rot_right then
		
		local new_r = tetris.piece_r + 1
		if new_r > 3 then
			new_r = 0
		end
		
		if tetris.kick_checks[tetris.block_info[tetris.piece_type].w] and tetris.kick_checks[tetris.block_info[tetris.piece_type].w][tetris.piece_r] and tetris.kick_checks[tetris.block_info[tetris.piece_type].w][tetris.piece_r][new_r] then
			for index, this in pairs (tetris.kick_checks[tetris.block_info[tetris.piece_type].w][tetris.piece_r][new_r]) do
				if tetris.isValidSpace(tetris.piece_type, new_r, tetris.piece_x + this[1], tetris.piece_y + this[2]) then
					tetris.piece_r = new_r
					tetris.piece_x = tetris.piece_x + this[1]
					tetris.piece_y = tetris.piece_y + this[2]
					tetris.calculateGhost()
					
					sound.effects.tone_low:stop()
					sound.effects.tone_low:play()
					
					if tetris.lock_moves < tetris.lock_max_moves then
						tetris.lock_tick = 0
						tetris.lock_moves = tetris.lock_moves + 1
					end
					
					tetris.checkTSpin()
					
					break
				end
			end
		else
			if tetris.isValidSpace(tetris.piece_type, new_r, tetris.piece_x, tetris.piece_y) then
				tetris.piece_r = new_r
				tetris.piece_x = tetris.piece_x
				tetris.piece_y = tetris.piece_y
				tetris.calculateGhost()
				
				sound.effects.tone_low:stop()
				sound.effects.tone_low:play()
				
				if tetris.lock_moves < tetris.lock_max_moves then
					tetris.lock_tick = 0
					tetris.lock_moves = tetris.lock_moves + 1
				end
				
				tetris.checkTSpin()
				
			end
		end
		
		
	elseif key == settings.key_rot_left then
		
		local new_r = tetris.piece_r - 1
		if new_r < 0 then
			new_r = 3
		end
		
		if tetris.kick_checks[tetris.block_info[tetris.piece_type].w] and tetris.kick_checks[tetris.block_info[tetris.piece_type].w][tetris.piece_r] and tetris.kick_checks[tetris.block_info[tetris.piece_type].w][tetris.piece_r][new_r] then
			for index, this in pairs (tetris.kick_checks[tetris.block_info[tetris.piece_type].w][tetris.piece_r][new_r]) do
				if tetris.isValidSpace(tetris.piece_type, new_r, tetris.piece_x + this[1], tetris.piece_y + this[2]) then
					tetris.piece_r = new_r
					tetris.piece_x = tetris.piece_x + this[1]
					tetris.piece_y = tetris.piece_y + this[2]
					tetris.calculateGhost()
					
					sound.effects.tone_low:stop()
					sound.effects.tone_low:play()
					
					if tetris.lock_moves < tetris.lock_max_moves then
						tetris.lock_tick = 0
						tetris.lock_moves = tetris.lock_moves + 1
					end
					
					tetris.checkTSpin()
					
					break
				end
			end
		else
			if tetris.isValidSpace(tetris.piece_type, new_r, tetris.piece_x, tetris.piece_y) then
				tetris.piece_r = new_r
				tetris.piece_x = tetris.piece_x
				tetris.piece_y = tetris.piece_y
				tetris.calculateGhost()
				
				sound.effects.tone_low:stop()
				sound.effects.tone_low:play()
				
				if tetris.lock_moves < tetris.lock_max_moves then
					tetris.lock_tick = 0
					tetris.lock_moves = tetris.lock_moves + 1
				end
				
				tetris.checkTSpin()
				
			end
		end
		
	elseif key == settings.key_flip then
		
		local new_r = tetris.piece_r + 2
		if new_r > 3 then
			new_r = new_r - 4
		end
		
		if tetris.isValidSpace(tetris.piece_type, new_r, tetris.piece_x, tetris.piece_y) then
			tetris.piece_r = new_r
			tetris.piece_x = tetris.piece_x
			tetris.piece_y = tetris.piece_y
			tetris.calculateGhost()
			
			sound.effects.tone_low:stop()
			sound.effects.tone_low:play()
			
			if tetris.lock_moves < tetris.lock_max_moves then
				tetris.lock_tick = 0
				tetris.lock_moves = tetris.lock_moves + 1
			end
			
			tetris.checkTSpin()
		end
		
	elseif key == settings.key_drop then
		
		if tetris.double_press_tick == 0 then
			
			local move_y = 0
			while move_y <= tetris.grid_h do
				move_y = move_y + 1
				if not tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.piece_y - move_y) then
					tetris.piece_y = tetris.piece_y - move_y + 1
					break
				else
					tetris.score = tetris.score + 2
					
					tetris.tspin = false
					tetris.tspin_mini = false
				end
			end
			
			tetris.placeBlock(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.piece_y)
			
		end
		
	elseif key == settings.key_hold then
		
		if not tetris.holded then
			
			if tetris.hold_type and tetris.hold_who then
				
				local temp_type = tetris.hold_type
				local temp_who = tetris.hold_who
				
				tetris.hold_type = tetris.piece_type
				tetris.hold_who = tetris.piece_who
				
				tetris.piece_type = temp_type
				tetris.piece_who = temp_who
				
			else
				
				tetris.hold_type = tetris.piece_type
				tetris.hold_who = tetris.piece_who
				
				tetris.piece_type = tetris.q_type[1]
				tetris.piece_who = tetris.q_who[1]
				
				piece_type, piece_who = tetris.nextBlock()
				
			end
			
			tetris.piece_reset()
			tetris.holded = true
			
		end
		
	end
	
end


function tetris.drawPiece(piece_type, piece_who, piece_r, piece_x, piece_y)
	
	-- local r, g, b, a = love.graphics.getColor()
	
	for x = 0, tetris.block_info[piece_type].w-1 do
		for y = 0, tetris.block_info[piece_type].w-1 do
			if tetris.block[piece_type][piece_r][x][y] > 0 then
				
				if img.shape[piece_type][piece_who] and tetris.block_info[piece_type].quad[tetris.block[piece_type][piece_r][x][y]] then
					-- love.graphics.draw(img.shape[piece_type][piece_who], tetris.block_info[piece_type].quad[tetris.block[piece_type][piece_r][x][y]],
						-- (piece_x + x) * tetris.tile_w + tetris.tile_w/2, (piece_y + y) * tetris.tile_w + tetris.tile_w/2, piece_r / 4 * math.pi * 2, 1, 1, tetris.tile_w/2, tetris.tile_w/2)
					love.graphics.draw(img.shape[piece_type][piece_who], tetris.block_info[piece_type].quad[1],
						(piece_x + x) * tetris.tile_w + tetris.tile_w/2, (piece_y + y) * tetris.tile_w + tetris.tile_w/2, 0, 1, 1, tetris.tile_w/2, tetris.tile_w/2)
				
				else
					love.graphics.rectangle("fill", (piece_x + x) * tetris.tile_w, (piece_y + y) * tetris.tile_w, tetris.tile_w, tetris.tile_w)
				
				end
				
				-- Black Grid --
				-- if settings.show_grid then
					-- love.graphics.setColor(0, 0, 0)
					-- love.graphics.setLineWidth(2)
					-- love.graphics.rectangle("line", (piece_x + x) * tetris.tile_w, (piece_y + y) * tetris.tile_w, tetris.tile_w, tetris.tile_w)
					-- love.graphics.setColor(r, g, b, a)
				-- end
				
			end
		end
	end
	
end

function tetris.isValidTile(x, y)
	if x < 0 or x > tetris.grid_w-1 or y < 0 or y > tetris.grid_h-1 then
		return false
	end
	
	if tetris.grid[x] and tetris.grid[x][y] and tetris.grid[x][y].tile > 0 then
		return false
	end
	
	return true
end
function tetris.isValidSpace(piece_type, piece_r, piece_x, piece_y)
	
	local can_move = true
	for x = 0, tetris.block_info[piece_type].w-1 do
		for y = 0, tetris.block_info[piece_type].w-1 do
			if tetris.block[piece_type][piece_r][x][y] > 0 and not tetris.isValidTile(piece_x + x, piece_y - y) then
				can_move = false
				break
			end
		end
	end
	
	return can_move
	
end

function tetris.calculateGhost()
	
	tetris.ghost_y = tetris.piece_y
	while tetris.ghost_y >= 0 do
		tetris.ghost_y = tetris.ghost_y - 1
		if not tetris.isValidSpace(tetris.piece_type, tetris.piece_r, tetris.piece_x, tetris.ghost_y) then
			tetris.ghost_y = tetris.ghost_y + 1
			break
		end
	end
	
end

function tetris.placeBlock(piece_type, piece_r, piece_x, piece_y)
	
	-- Put block on grid --
	local in_bounds = false
	local cleared_lines = 0
	
	for x = 0, tetris.block_info[piece_type].w-1 do
		for y = 0, tetris.block_info[piece_type].w-1 do
			if tetris.block[piece_type][piece_r][x][y] > 0 then
				if piece_y - y < tetris.grid_draw_h then
					in_bounds = true
				end
				if tetris.isValidTile(piece_x + x, piece_y - y) then
					tetris.grid[piece_x + x][piece_y - y].tile = tetris.block[piece_type][piece_r][x][y]
					tetris.grid[piece_x + x][piece_y - y].block_type = tetris.piece_type
					tetris.grid[piece_x + x][piece_y - y].r = tetris.piece_r
					tetris.grid[piece_x + x][piece_y - y].who = tetris.piece_who
				end
			end
		end
	end
	if not in_bounds then
		tetris.gameOver()
		return
	end
	
	-- Check for cleared lines --
	for y = 0, tetris.grid_h-2 do
		
		for x = 0, tetris.grid_w-1 do
			
			if tetris.grid[x][y].tile == 0 then
				tetris.line_clear_table[y] = false
				break
			elseif x == tetris.grid_w-1 then
				
				tetris.line_clear_table[y] = true
				
				cleared_lines = cleared_lines + 1
				
			end
			
		end
		
	end
	
	
	-- score --
	-- print stuff and test
	local cleared_lines_adjusted = cleared_lines
	
	if cleared_lines == 0 then
		if tetris.tspin then
			cleared_lines_adjusted = 4
			ui.newAnnounce("T-Spin!")
		elseif tetris.tspin_mini then
			cleared_lines_adjusted = 1
			ui.newAnnounce("Mini T-Spin!")
		end
	elseif cleared_lines == 1 then
		if tetris.tspin then
			cleared_lines_adjusted = 8
			ui.newAnnounce("T-Spin Single!")
		elseif tetris.tspin_mini then
			cleared_lines_adjusted = 2
			ui.newAnnounce("Mini T-Spin Single!")
		else
			cleared_lines_adjusted = 1
			ui.newAnnounce("Single!")
		end
	elseif cleared_lines == 2 then
		if tetris.tspin then
			cleared_lines_adjusted = 12
			ui.newAnnounce("T-Spin Double!")
		else
			cleared_lines_adjusted = 3
			ui.newAnnounce("Double!")
		end
	elseif cleared_lines == 3 then
		if tetris.tspin then
			cleared_lines_adjusted = 16
			ui.newAnnounce("T-Spin Triple!")
		else
			cleared_lines_adjusted = 5
			ui.newAnnounce("Triple!")
		end
	elseif cleared_lines == 4 then
		cleared_lines_adjusted = 8
		ui.newAnnounce("Tetris!")
	end
	
	if cleared_lines == 4 or ((tetris.tspin_mini or tetris.tspin) and cleared_lines > 0) then
		
		if tetris.back_to_back then
			cleared_lines_adjusted = cleared_lines_adjusted + cleared_lines_adjusted/2
		else
			tetris.back_to_back = true
		end
		
	elseif cleared_lines > 0 then
		
		tetris.back_to_back = false
		
	end
	
	
	tetris.score = tetris.score + cleared_lines_adjusted * 100 * tetris.level
	tetris.lines_cleared = tetris.lines_cleared + cleared_lines_adjusted
	tetris.level = math.floor(tetris.lines_cleared / 10)
	tetris.fall_delay = (0.8-((tetris.level-1)*0.007))^(tetris.level-1)
	
	
	-- particles --
	if settings.show_particles then
		tetris.piece_dust:setPosition((piece_x + tetris.block_info[piece_type].w/2) * tetris.tile_w, (tetris.grid_draw_h + tetris.block_info[piece_type].w/2 - piece_y) * tetris.tile_w)
		tetris.piece_dust:emit(30)
	end
	
	-- animation --
	if cleared_lines > 0 then
		tetris.line_clear_tick = tetris.line_clear_delay
	end
	
	-- sounds --
	if cleared_lines > 0 then
		tetris.pointSound(tetris.piece_who)
	end
	sound.effects.thud:stop()
	sound.effects.thud:play()
	
	-- Reset Piece --
	tetris.piece_type, tetris.piece_who = tetris.nextBlock()
	tetris.piece_reset()
	tetris.holded = false
	
	-- topout check --
	for x = 0, tetris.block_info[tetris.piece_type].w-1 do
		for y = 0, tetris.block_info[tetris.piece_type].w-1 do
			if tetris.block[tetris.piece_type][tetris.piece_r][x][y] > 0 and not tetris.isValidTile(tetris.piece_x + x, tetris.piece_y - y) then
				tetris.gameOver()
				return
			end
		end
	end
	
end

function tetris.pointSound(who)
	
	if sound.voice[who] and sound.voice[who].point then
		sound.voice[who].point:stop()
		sound.voice[who].point:play()
	else
	end
	
end

function tetris.fillQ()
	
	local bag = table.clone(tetris.block_choice)
	while #bag > 0 do
		local rand = math.random(1, #bag)
		table.insert(tetris.q_type, bag[rand])
		table.insert(tetris.q_who, tetris.who_choice[bag[rand]])
		table.remove(bag, rand)
	end
	
end

function tetris.nextBlock()
	
	local piece_type = tetris.q_type[1]
	local piece_who = tetris.q_who[1]
	table.remove(tetris.q_type, 1)
	table.remove(tetris.q_who, 1)
	
	if #tetris.q_type < #tetris.block_choice then
		tetris.fillQ()
	end
	
	tetris.next_anime_tick = 1
	tetris.lock_tick = 0
	
	return piece_type, piece_who
	
end

function tetris.gameOver()
	
	if tetris.score > tetris.high_score then
		tetris.high_score = tetris.score
		love.filesystem.write("highscore", "IF YOU TRY TO EDIT THIS, YOU ARE A DISHONORABLE GAMER\n"..tetris.high_score)
		tetris.got_high_score = true
	else
		tetris.got_high_score = false
	end
	
	tetris.game_over = true
	ui.element["start_btn"].title = {"START", "スタート"}
	ui.menu_open = "gameover"
	
	sound.voice.amelia.game_over:stop()
	sound.voice.amelia.game_over:play()
	
	stopAll(music)
	
end

function tetris.checkTSpin()
	
	tetris.tspin = false
	tetris.tspin_mini = false
	
	if tetris.piece_type == "T" then
		
		local piece_x = tetris.piece_x + math.floor(tetris.block_info[tetris.piece_type].w/2)
		local piece_y = tetris.piece_y - math.floor(tetris.block_info[tetris.piece_type].w/2)
		local A_corner = tetris.isValidTile(piece_x + tetris.tspin_checks[tetris.piece_r].A.x, piece_y + tetris.tspin_checks[tetris.piece_r].A.y)
		local B_corner = tetris.isValidTile(piece_x + tetris.tspin_checks[tetris.piece_r].B.x, piece_y + tetris.tspin_checks[tetris.piece_r].B.y)
		local C_corner = tetris.isValidTile(piece_x + tetris.tspin_checks[tetris.piece_r].C.x, piece_y + tetris.tspin_checks[tetris.piece_r].C.y)
		local D_corner = tetris.isValidTile(piece_x + tetris.tspin_checks[tetris.piece_r].D.x, piece_y + tetris.tspin_checks[tetris.piece_r].D.y)
		
		
		if not A_corner and not B_corner and (not C_corner or not D_corner) then
			tetris.tspin = true
			-- TODO t spin sound effect
		elseif not C_corner and not D_corner and (not A_corner or not B_corner) then
			tetris.tspin_mini = true
			-- TODO mini t spin sound effect
		end
		
		
	end
	
end


function tetris.getCamX()
	return	love.graphics.getWidth()/2
end
function tetris.getCamY()
	return	3 * tetris.tile_w * tetris.getScale()
end
function tetris.getScale()
	return	love.graphics.getHeight() / ((tetris.grid_draw_h + 5) * tetris.tile_w)
end


return tetris
