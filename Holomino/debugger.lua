-- Debug --

debugger = {}
debugger.libname = "debugger"
debugger.debugcolor = {0.8, 0.8, 0.8}

debugger.interactorder = 0
drawable_add(debugger, "overlay", 99999999)

debugger.show = false
debugger.font = love.graphics.newFont(12)
debugger.quittick = 0

function debugger.draw()
	
	love.graphics.origin()
	-- love.graphics.translate(-game.camx, -game.camy)
	-- love.graphics.scale(game.scale)
	
	if debugger.show then
		love.graphics.setFont(debugger.font)
		
		-- Debug Text --
		love.graphics.origin()
		love.graphics.setColor(0, 0, 0, 0.5)
		love.graphics.rectangle("fill",0,0,450,(#drawable+1)*15)
		love.graphics.setColor(1, 1, 1)
		
		-- Stats --
		love.graphics.print("FPS: "..love.timer.getFPS(), 350, 0)
		-- love.graphics.print("Mouse: "..game.mx.." , "..game.my, 350, 15)
		-- love.graphics.print("Camera: "..math.floor(game.camx).." , "..math.floor(game.camy).." : "..string.sub(game.scale, 1, 4), 350, 30)
		
		-- Interact Order --
		love.graphics.print("Interact Order:", 200, 0)
		for k,item in pairs(interacttable) do
			if item.interactorder then
				love.graphics.print(item.libname..": "..item.interactorder, 200, k * 15)
			end
		end
		
		-- Draw Order --
		love.graphics.print("Draw Order:", 0, 0)
		for k,item in pairs(drawable) do
			if item.lib.debugcolor then
				love.graphics.setColor(item.lib.debugcolor[1], item.lib.debugcolor[2], item.lib.debugcolor[3])
			else
				love.graphics.setColor(1,1,1)
			end
			if type(item.id) == "string" then
				love.graphics.print(item.lib.libname.." - "..item.id..": "..item.y, 0, k * 15)
			else
				love.graphics.print(item.lib.libname..": "..item.y, 0, k * 15)
			end
		end
		
	end
	
end

function debugger.update(dt)
	
	-- if love.keyboard.isDown("=") then
		-- game.scale = game.scale + 2 * dt
	-- end
	-- if love.keyboard.isDown("-") then
		-- game.scale = game.scale - 2 * dt
	-- end
	
	if love.keyboard.isDown("escape") then
		debugger.quittick = debugger.quittick + dt
		if debugger.quittick >= 0.5 then
			love.event.quit()
		end
	else
		debugger.quittick = 0
	end
	
	if love.keyboard.isDown("rshift") then
		debugger.time_scale = 2
	else
		debugger.time_scale = 1
	end
	
end

function debugger.keypressed(key)
	
	if key == "f3" then
		debugger.show = not debugger.show
	end
	
	if key == "f11" then
		settings.video_fullscreen = not settings.video_fullscreen
		love.window.setFullscreen(settings.video_fullscreen)
	end
	
	if key == "f1" then
		tetris.background = tetris.background + 1
		if tetris.background > #tetris.backgrounds then
			tetris.background = 1
		end
		
		if tetris.background_img then
			tetris.background_img = nil
			collectgarbage()
		end
		tetris.background_img = love.graphics.newImage("backgrounds/"..tetris.backgrounds[tetris.background].img)
	end
	
	if key == "f9" then
		tetris.lines_cleared = tetris.lines_cleared - 10
		tetris.level = math.floor(tetris.lines_cleared / 10)
		tetris.fall_delay = (0.8-((tetris.level-1)*0.007))^(tetris.level-1)
	end
	if key == "f10" then
		tetris.lines_cleared = tetris.lines_cleared + 10
		tetris.level = math.floor(tetris.lines_cleared / 10)
		tetris.fall_delay = (0.8-((tetris.level-1)*0.007))^(tetris.level-1)
	end
	
	if key == "f2" then
		ui.newAnnounce("test")
	end
	
end

function debugger.mousepressed(mx, my, b)
	
	-- if b == 1 then
		-- love.system.setClipboardText(math.floor((love.mouse.getX() + game.camx) / game.scale)..", "..math.floor((love.mouse.getY() + game.camy) / game.scale))
	-- end
	
	-- if b == 1 then
		
	-- 	mx = (mx - tetris.getCamX() + tetris.grid_w/2 * tetris.tile_w) / tetris.getScale()
	-- 	my = (my - tetris.getCamY()) / tetris.getScale()
		
	-- 	for x = 0, tetris.grid_w-1 do
	-- 		for y = 0, tetris.grid_h-1 do
				
	-- 			if (x) * tetris.tile_w > mx - tetris.tile_w and (x) * tetris.tile_w < mx and (tetris.grid_draw_h - y - 1) * tetris.tile_w > my - tetris.tile_w and (tetris.grid_draw_h - y - 1) * tetris.tile_w < my then
	-- 				tetris.grid[x][y].tile = 1
	-- 				tetris.grid[x][y].block_type = "S"
	-- 				tetris.grid[x][y].who = "amelia_tile"
	-- 			end
				
	-- 		end
	-- 	end
	
	-- end
	
	-- if b == 1 then
		
		-- tetris.line_clear_dust:setPosition(tetris.tile_w/2, tetris.tile_w/2)
		-- tetris.line_clear_dust:emit(300)
		
	-- end
	
end

-- function debugger.wheelmoved(x, y)
	
	-- if y > 0 then
		-- game.scale = game.scale + 0.1
	-- elseif y < 0 then
		-- game.scale = game.scale - 0.1
	-- end
	
-- end

-- function love.filedropped(file)
	-- test_img = love.graphics.newImage(file))
-- end

return debugger
