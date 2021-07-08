-- UI --

ui = {}
ui.libname = "ui"

drawable_add(ui, "ui", 1)
ui.interactorder = 1

ui.font = love.graphics.newFont("fonts/Exo-Regular.otf", 24)
ui.fallback_font = love.graphics.newFont("fonts/YasashisaGothicBold-V2.otf", 24)
ui.font:setFallbacks(ui.fallback_font)
ui.font_large = love.graphics.newFont("fonts/Exo-Regular.otf", 45)
ui.fallback_font_large = love.graphics.newFont("fonts/YasashisaGothicBold-V2.otf", 45)
ui.font_large:setFallbacks(ui.fallback_font_large)

ui.cursor_arrow = love.mouse.getSystemCursor("arrow")

love.graphics.setLineStyle("rough")
love.graphics.setBackgroundColor(225/255, 117/255, 204/255)

ui.menu_open = "splash" -- splash, main, pause, game, gameover, settings, about, controls, reset_conf, quit_conf
ui.menu_opening = nil
ui.menu_open_tick = 0

ui.menu_w = img.ui.suisei_bg:getWidth()
ui.menu_h = img.ui.suisei_bg:getHeight()

ui.clicking = nil
ui.setting_key = nil
ui.slider_tick = 0

ui.btn_fade_tick = 0
ui.btn_fade_up = true
ui.btn_fade_r1 = 200/255
ui.btn_fade_g1 = 140/255
ui.btn_fade_b1 = 215/255
ui.btn_fade_r2 = 150/255
ui.btn_fade_g2 = 245/255
ui.btn_fade_b2 = 240/255
ui.highlight_r = 0
ui.highlight_g = 0
ui.highlight_b = 0

ui.dust_front = love.graphics.newParticleSystem(img.ui.particle_circle, 1000)
ui.dust_front:setParticleLifetime(60*60*24)-- 1 day
ui.dust_front:setEmissionRate(0)
ui.dust_front:setLinearAcceleration(-15, 0, 15, 0) -- gravity + wind
ui.dust_front:setLinearDamping(1, 1)
ui.dust_front:setEmissionArea("normal", 113/2, 5, 0, false)
ui.dust_front:setSpeed(100, 1000)
ui.dust_front:setDirection(math.pi * 3/2)
ui.dust_front:setSpread(math.pi)
ui.dust_front:setColors(1, 1, 1, 0.6)

ui.dust_back = ui.dust_front:clone( )
ui.dust_back:setColors(1, 1, 1, 0.4)
ui.dust_back:setSizes(0.7)
ui.dust_back:setSpeed(100, 1200)

ui.dust_front:emit(1000)
ui.dust_back:emit(1000)

ui.element = {}

ui.counting_down = false
ui.count_down_num = 0
ui.count_down_tick = 0
ui.count_down_voices = {"gura", "amelia", "ina", "kiara", "suisei"}
ui.count_down_voice = ui.count_down_voices[1]

ui.announce = {}

ui.splash_tick = 3
ui.splash_rot_tick = 0
ui.splash_sound_played = false

function ui.outline_print(text, x, y, offset, r, g, b, a, rot, sx, sy, ox, oy)
	
	if not rot then rot = 0 end
	if not sx then sx = 1 end
	if not sy then sy = 1 end
	if not ox then ox = 0 end
	if not oy then oy = 0 end
	
	local old_r, old_g, old_b, old_a = love.graphics.getColor()
	
	love.graphics.setColor(r, g, b, a)
	
	love.graphics.print(text, x, y - offset, rot, sx, sy, ox, oy)
	love.graphics.print(text, x, y + offset, rot, sx, sy, ox, oy)
	love.graphics.print(text, x + offset, y, rot, sx, sy, ox, oy)
	love.graphics.print(text, x - offset, y, rot, sx, sy, ox, oy)
	love.graphics.print(text, x - offset, y - offset, rot, sx, sy, ox, oy)
	love.graphics.print(text, x - offset, y + offset, rot, sx, sy, ox, oy)
	love.graphics.print(text, x + offset, y + offset, rot, sx, sy, ox, oy)
	love.graphics.print(text, x + offset, y - offset, rot, sx, sy, ox, oy)
	
	love.graphics.setColor(old_r, old_g, old_b, old_a)
	love.graphics.print(text, x, y, rot, sx, sy, ox, oy)
	
end

function ui.draw(layer)
	
	if ui.menu_open == "splash" then
		
		love.graphics.origin()
		
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(img.ui.blue_sheep, love.graphics.getWidth()/2, love.graphics.getHeight()/2, math.sin(ui.splash_rot_tick * 40) / 4, 1, 1, img.ui.blue_sheep:getWidth()/2, img.ui.blue_sheep:getHeight()/2)
		
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(ui.fallback_font_large)
		love.graphics.print("A game by BlueSheep", love.graphics.getWidth()/2 - ui.fallback_font_large:getWidth("A game by BlueSheep")/2, love.graphics.getHeight()/2 + img.ui.blue_sheep:getHeight()/2)
		
	elseif ui.menu_open == "game" or ui.menu_open == "gameover" then
		
		love.graphics.origin()
		love.graphics.translate(tetris.getCamX(), tetris.getCamY())
		love.graphics.scale(tetris.getScale())
		
		-- play area box --
		love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
		love.graphics.setLineWidth(6)
		
		love.graphics.line(-5 * tetris.tile_w - 6/2, 0, -5 * tetris.tile_w - 6/2, tetris.grid_draw_h * tetris.tile_w + 6)
		love.graphics.line(5 * tetris.tile_w + 6/2, 0, 5 * tetris.tile_w + 6/2, tetris.grid_draw_h * tetris.tile_w + 6)
		love.graphics.line(-5 * tetris.tile_w - 6/2, tetris.grid_draw_h * tetris.tile_w + 6/2, 5 * tetris.tile_w + 6/2, tetris.grid_draw_h * tetris.tile_w + 6/2)
		
		-- count down --
		if ui.counting_down then
			
			love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b, 1 - ui.count_down_tick)
			
			if ui.count_down_num <= 3 then
				love.graphics.draw(img.ui[tostring(ui.count_down_num)], -img.ui[tostring(ui.count_down_num)]:getWidth()/2, 10 * tetris.tile_w - 100)
			end
			
		end
		
		-- Score --
		if ui.menu_open == "game" then
			
			love.graphics.setFont(ui.font_large)
			love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
			love.graphics.print(tetris.score, 6 * tetris.tile_w, 19 * tetris.tile_w - ui.font_large:getHeight()/2)
			
		elseif ui.menu_open == "gameover" then
			
			love.graphics.setFont(ui.font_large)
			love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
			local text = "SCORE: "..tetris.score
			ui.outline_print(text, 0 - ui.font_large:getWidth(text)/2, 5.5 * tetris.tile_w - ui.font_large:getHeight()/2, 2, 0, 0, 0, 1)
			
			if tetris.got_high_score then
				-- love.graphics.setFont(ui.font)
				love.graphics.setFont(ui.font_large)
				ui.outline_print("NEW HIGHSCORE!", ui.font_large:getWidth(text)/2, 4 * tetris.tile_w, 2, 0, 0, 0, 1, math.pi/6, 0.5, 0.5, ui.font:getWidth("NEW HIGHSCORE!")/2, ui.font:getHeight()/2)
			end
			
		end
		
		-- Announcements --
		love.graphics.setFont(ui.font)
		for index, this in pairs (ui.announce) do
			
			love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b, math.min(this.tick * 2, 1))
			love.graphics.print(this.text, 6 * tetris.tile_w, 16 * tetris.tile_w + this.tick * 40)
			
		end
		
		-- info --
		love.graphics.origin()
		love.graphics.setFont(ui.font)
		
		-- music info --
		-- if settings.music_volume > 0 and ui.menu_open == "game" then
			
		-- 	local text = "Music / 音楽: "..bgm.game_bgm[bgm.game_playing].full_name.." by "
		-- 	local h = love.graphics.getHeight() - ui.font:getHeight()*0.9 * 2 - 7
			
		-- 	love.graphics.setColor(1, 1, 1)
		-- 	love.graphics.print(text, 3, love.graphics.getHeight() - ui.font:getHeight()*0.9 * 2 - 6, 0, 0.9, 0.9)
			
		-- 	if love.mouse.getX() < ui.font:getWidth(text)*0.9 + ui.font:getWidth(bgm.game_bgm[bgm.game_playing].artist)*0.9 and love.mouse.getY() > h and love.mouse.getY() < h + ui.font:getHeight()*0.9 then
		-- 		love.graphics.setColor(1, 1, 1)
		-- 	else
		-- 		love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
		-- 	end
			
		-- 	love.graphics.print(bgm.game_bgm[bgm.game_playing].artist, 3 + ui.font:getWidth(text)*0.9, love.graphics.getHeight() - ui.font:getHeight()*0.9 * 2 - 6, 0, 0.9, 0.9)
		-- end
		
		-- background info --
		local text = "Background Image / 背景画像: "
		
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(text, 3, love.graphics.getHeight() - ui.font:getHeight()*0.9 - 4, 0, 0.9, 0.9)
		
		if love.mouse.getX() < ui.font:getWidth(text)*0.9 + ui.font:getWidth(tetris.backgrounds[tetris.background].artist)*0.9 and love.mouse.getY() > love.graphics.getHeight() - ui.font:getHeight()*0.9 - 4 then
			love.graphics.setColor(1, 1, 1)
		else
			love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
		end
		
		love.graphics.print(tetris.backgrounds[tetris.background].artist, 3 + ui.font:getWidth(text)*0.9, love.graphics.getHeight() - ui.font:getHeight()*0.9 - 4, 0, 0.9, 0.9)
		
		
	elseif ui.menu_open == "main" then
		
		love.graphics.origin()
		love.graphics.translate(ui.getCamX(), ui.getCamY())
		love.graphics.scale(ui.getScale())
		
		love.graphics.setColor(1, 1, 1)
		
		love.graphics.draw(img.ui.suisei_bg, 0, 0)
		
		if settings.show_particles then
			love.graphics.draw(ui.dust_back, 764/2, 990)
		end
		
		love.graphics.draw(img.ui.suisei_bg_for, 0, 0)
		
		if settings.show_particles then
			love.graphics.draw(ui.dust_front, 764/2, 990)
		end
		
		love.graphics.draw(img.ui.suisei_bg_blocks, 0, 0)
		
	elseif ui.menu_open == "settings" or ui.menu_open == "about" or ui.menu_open == "pause" or ui.menu_open == "controls" or ui.menu_open == "reset_conf" then
		
		love.graphics.origin()
		love.graphics.translate(ui.getCamX(), ui.getCamY())
		love.graphics.scale(ui.getScale())
		
		love.graphics.setColor(0.2, 0.2, 0.2)
		love.graphics.draw(img.ui.suisei_bg, 0, 0)
		
	elseif ui.menu_open == "quit_conf" then
		
		love.graphics.origin()
		love.graphics.translate(ui.getCamX(), ui.getCamY())
		love.graphics.scale(ui.getScale())
		
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(img.ui.suisei_bg_2, 0, 0)
		
	end
	
	
	-- UI Elements --
	
	mx = (love.mouse.getX() - ui.getCamX()) / (love.graphics.getHeight() / ui.menu_h)
	my = love.mouse.getY() / ui.getScale()
	
	love.graphics.setFont(ui.font)
	love.graphics.setLineWidth(2)
	
	for index, this in pairs (ui.element) do
		if this.menu == ui.menu_open then
			
			love.graphics.origin()
			love.graphics.translate(ui.getCamX(), ui.getCamY())
			love.graphics.scale(ui.getScale())
			love.graphics.translate(this.x, this.y)
			
			-- Buttons --
			if this.type == "button" then
				
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", -this.w/2, -this.h/2, this.w, this.h)
				
				if ui.mouseIsOn(mx, my, this) then
					love.graphics.setColor(1, 1, 1)
				else
					love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
				end
				love.graphics.rectangle("line", -this.w/2, -this.h/2, this.w, this.h)
				
				for title_index, title in pairs (this.title) do
					love.graphics.print(title, -ui.font:getWidth(title)/2, (-#this.title/2 + (title_index-1)) * ui.font:getHeight())
				end
			
			-- Sliders --
			elseif this.type == "slider" then
				
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", -this.w/2, -3, this.w, 6)
				
				if ui.mouseIsOn(mx, my, this) or ui.clicking == this then
					love.graphics.setColor(1, 1, 1)
				else
					love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
				end
				love.graphics.rectangle("line", -this.w/2, -3, this.w, 6)
				
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", -this.w/2 + this.value * this.w - 5/2, -this.h/2, 5, this.h)
				
				if ui.mouseIsOn(mx, my, this) or ui.clicking == this then
					love.graphics.setColor(1, 1, 1)
				else
					love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
				end
				love.graphics.rectangle("line", -this.w/2 + this.value * this.w - 5/2, -this.h/2, 5, this.h)
				
			elseif this.type == "text" then
				
				if ui.mouseIsOn(mx, my, this) and this.press then
					love.graphics.setColor(1, 1, 1)
				else
					love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
				end
				love.graphics.print(this.text, -ui.font:getWidth(this.text)/2, -ui.font:getHeight()/2)
				
			elseif this.type == "checkbox" then
				
				if ui.mouseIsOn(mx, my, this) then
					love.graphics.setColor(1, 1, 1)
				else
					love.graphics.setColor(ui.highlight_r, ui.highlight_g, ui.highlight_b)
				end
				love.graphics.rectangle("line", -this.w/2, -this.h/2, this.w, this.h)
				
				if this.value then
					love.graphics.setColor(1, 1, 1)
					love.graphics.draw(img.ui.check, 0, 0 ,0, 1, 1, 10, 10)
				end
				
				
			end
			
		end
	end
	
	
	-- Black Bars --
	if ui.menu_open == "main" then
		love.graphics.origin()
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 0, ui.getCamX(), love.graphics.getHeight())
		love.graphics.rectangle("fill", love.graphics.getWidth() - ui.getCamX(), 0, ui.getCamX(), love.graphics.getHeight())
	end
	
	-- Fade --
	if ui.menu_opening then
		
		love.graphics.origin()
		love.graphics.setColor(0, 0, 0, ui.menu_open_tick)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		
	end
	
	-- cursor
	-- if ui.camera_grabbed_x and ui.camera_grabbed_y then
		-- love.mouse.setCursor(ui.cursor_grab)
	-- end
	
end


function ui.update(dt)
	
	if ui.menu_open == "splash" then
		
		ui.splash_tick = ui.splash_tick - dt
		
		if ui.splash_tick <= 0 then
			ui.openMenu("main", true)
		elseif ui.splash_tick < 2 then
			if not ui.splash_sound_played then
				ui.splash_sound_played = true
				sound.effects.baa:play()
			end
		end
		
		if sound.effects.baa:isPlaying() then
			ui.splash_rot_tick = ui.splash_rot_tick + dt
		else
			ui.splash_rot_tick = 0
		end
		
	end
	
	-- Clicked UI Animation --
	if ui.clicking then
		
		mx = (love.mouse.getX() - ui.getCamX()) / ui.getScale()
		-- my = love.mouse.getY() / (love.graphics.getHeight() / img.suisei_bg:getHeight())
		
		if ui.clicking.type == "slider" then
			
			ui.clicking.value = math.max(math.min((mx - ui.clicking.x + ui.clicking.w/2) / ui.clicking.w, 1), 0)
			
			ui.slider_tick = ui.slider_tick + dt
			if ui.slider_tick > 0.3 then
				ui.slider_tick = ui.slider_tick - 0.3
				
				if ui.clicking.valueChanged then
					ui.clicking.valueChanged(ui.clicking.value)
				end
			end
			
		end
		
	end
	
	
	-- Button RGB --
	if btn_fade_up then
		ui.btn_fade_tick = ui.btn_fade_tick + dt / 2
	else
		ui.btn_fade_tick = ui.btn_fade_tick - dt / 2
	end
	if ui.btn_fade_tick >= 1 then
		btn_fade_up = false
		ui.btn_fade_tick = 1
	elseif ui.btn_fade_tick <= 0 then
		btn_fade_up = true
		ui.btn_fade_tick = 0
	end
	ui.highlight_r = ui.btn_fade_r1 + (ui.btn_fade_r2 - ui.btn_fade_r1) * (math.cos(ui.btn_fade_tick * math.pi)/2 + 1/2)
	ui.highlight_g = ui.btn_fade_g1 + (ui.btn_fade_g2 - ui.btn_fade_g1) * (math.cos(ui.btn_fade_tick * math.pi)/2 + 1/2)
	ui.highlight_b = ui.btn_fade_b1 + (ui.btn_fade_b2 - ui.btn_fade_b1) * (math.cos(ui.btn_fade_tick * math.pi)/2 + 1/2)
	
	
	-- particles --
	if settings.show_particles and ui.menu_open == "main" then
		ui.dust_front:update(dt)
		ui.dust_back:update(dt)
	end
	
	-- menu fade --
	if ui.menu_opening then
		
		if ui.menu_opening == ui.menu_open then
			
			ui.menu_open_tick = ui.menu_open_tick - 4 * dt
			if ui.menu_open_tick <= 0 then
				ui.menu_opening = nil
				ui.menu_open_tick = 0
			end
			
		else
			
			ui.menu_open_tick = ui.menu_open_tick + 4 * dt
			if ui.menu_open_tick >= 1 then
				ui.openMenu(ui.menu_opening, false)
				ui.menu_open_tick = 1
			end
			
		end
		
	end
	
	-- count down --
	if ui.counting_down and ui.menu_open == "game" then
		ui.count_down_tick = ui.count_down_tick + dt
		if ui.count_down_tick >= 1 then
			ui.count_down_tick = ui.count_down_tick - 1
			
			ui.count_down_num = ui.count_down_num - 1
			if ui.count_down_num <= 0 then
				ui.counting_down = false
			end
			
			if ui.count_down_num > 0 and ui.count_down_num <= 3 then
				sound.voice[ui.count_down_voice][tostring(ui.count_down_num)]:play()
			end
		end
	end
	
	-- announcements --
	for index, this in pairs (ui.announce) do
		this.tick = this.tick - dt
	end
	if ui.announce[1] and ui.announce[1].tick <= 0 then
		table.remove(ui.announce, 1)
	end
	
end

function ui.mousepressed(mx, my, button)
	
	mx = (mx - ui.getCamX()) / ui.getScale()
	my = my / ui.getScale()
	
	if button == 1 then
		
		for index, this in pairs (ui.element) do
			if this.menu == ui.menu_open then
				
				if ui.mouseIsOn(mx, my, this) then
					ui.clicking = this
					return true
				end
				
			end
		end
		
		if ui.menu_open == "game" or ui.menu_open == "gameover" then
			
			-- if settings.music_volume > 0 and ui.menu_open == "game" then
			-- 	local text = "Music / 音楽: "..bgm.game_bgm[bgm.game_playing].full_name.." by "..bgm.game_bgm[bgm.game_playing].artist
			-- 	local h = love.graphics.getHeight() - ui.font:getHeight()*0.9 * 2 - 7
			-- 	if love.mouse.getX() < ui.font:getWidth(text)*0.9 and love.mouse.getY() > h and love.mouse.getY() < h + ui.font:getHeight()*0.9 then
			-- 		ui.openMenu("pause", false)
			-- 		ui.openLink(bgm.game_bgm[bgm.game_playing].link)
			-- 	end
			-- end
			
			local text = "Background Image / 背景画像: "..tetris.backgrounds[tetris.background].artist
			if love.mouse.getX() < ui.font:getWidth(text)*0.9 and love.mouse.getY() > love.graphics.getHeight() - ui.font:getHeight()*0.9 - 4 then
				if ui.menu_open == "game" then
					ui.openMenu("pause", false)
				end
				ui.openLink(tetris.backgrounds[tetris.background].link)
			end
			
		elseif ui.menu_open == "splash" then
			
			ui.openMenu("main", true)
			
		end
		
	end
	
end

function ui.mousereleased(mx, my, button)
	
	mx = (mx - ui.getCamX()) / ui.getScale()
	my = my / ui.getScale()
	
	if button == 1 then
		
		if ui.clicking then
			
				
			if ui.clicking.type == "button" or ui.clicking.type == "text" then
				
				if ui.mouseIsOn(mx, my, ui.clicking) and ui.clicking.press then
					if not ui.menu_opening then
						sound.effects.tone_high:stop()
						sound.effects.tone_high:play()
					end
					ui.clicking.press(ui.clicking)
				end
				
			elseif ui.clicking.type == "slider" then
				
				ui.clicking.value = math.max(math.min((mx - ui.clicking.x + ui.clicking.w/2) / ui.clicking.w, 1), 0)
				if ui.clicking.valueSet then
					ui.clicking.valueSet(ui.clicking.value)
				end
				
			elseif ui.clicking.type == "checkbox" then
				
				ui.clicking.value = not ui.clicking.value
				if ui.mouseIsOn(mx, my, ui.clicking) and ui.clicking.valueChanged then
					ui.clicking.valueChanged(ui.clicking.value)
					if ui.clicking.value then
						sound.effects.tone_high:stop()
						sound.effects.tone_high:play()
					else
						sound.effects.tone_low:stop()
						sound.effects.tone_low:play()
					end
				end
				
			end
			
			ui.clicking = nil
			
		end
		
	end
	
end


function ui.keypressed(key)
	
	if ui.menu_open == "main" then
		
		if key == "escape" then
			
			-- love.event.quit()
			ui.openMenu("quit_conf", false)
			
		end
		
	elseif ui.menu_open == "settings" then
		
		if key == "escape" then
			
			ui.openMenu("main", true)
			settings.save()
			
		end
		
	elseif ui.menu_open == "about" then
		
		if key == "escape" then
			
			ui.openMenu("main", true)
			
		end
		
	elseif ui.menu_open == "controls" then
		
		if key == "escape" then
			
			if ui.setting_key then
				
				ui.element["btn_"..ui.setting_key].title[1] = string.upper(settings[ui.setting_key])
				ui.setting_key = nil
				
			else
				
				ui.openMenu("settings", true)
				settings.save()
				
			end
			
		elseif ui.setting_key then
			
			if string.sub(ui.setting_key, 1, 4) == "key_" then
				settings[ui.setting_key] = key
				ui.element["btn_"..ui.setting_key].title[1] = string.upper(key)
				
				ui.setting_key = nil
				
				sound.effects.tone_low:stop()
				sound.effects.tone_low:play()
			end
			
		end
		
	elseif ui.menu_open == "game" then
		
		if key == "escape" then
			
			ui.openMenu("pause", false)
			
		end
		
	elseif ui.menu_open == "pause" then
		
		if key == "escape" then
			
			ui.openMenu("game", true)
			
		end
		
	elseif ui.menu_open == "splash" then
			
		ui.openMenu("main", true)
		
	end
	
end


function ui.textinput(text)
	
	
	
end


function ui.openMenu(menu, fade)
	
	if fade then
		
		if ui.menu_open_tick == 0 then
			ui.menu_opening = menu
		end
		
	else
		
		local old_menu = ui.menu_open
		ui.menu_open = menu
		
		bgm.openMenu(menu, old_menu)
		
		ui.menu_open_tick = 0
		
		stopAll(sound)
		
		if menu == "main" then
			
			love.graphics.setBackgroundColor(0, 0, 0)
			if settings.show_particles then
				ui.dust_front:reset()
				ui.dust_front:emit(1000)
				ui.dust_back:reset()
				ui.dust_back:emit(1000)
			end
			
		elseif menu == "game" then
			
			if tetris.game_over then
				tetris.load()
			end
			tetris.prepare()
			
		elseif menu == "settings" then
			
			if old_menu == "controls" then	
				
				if ui.setting_key then
					ui.element["btn_"..ui.setting_key].title[1] = string.upper(settings[ui.setting_key])
					ui.setting_key = nil
				end
				
			end
			
		end
		
	end
	
end

function ui.mouseIsOn(mx, my, this)
	if this.type == "button" or this.type == "slider" or this.type == "checkbox" then
		if mx > this.x - this.w/2 and mx < this.x + this.w/2 and my > this.y - this.h/2 and my < this.y + this.h/2 then
			return true
		end
	elseif this.type == "text" then
		if mx > this.x - ui.font:getWidth(this.text)/2 and mx < this.x + ui.font:getWidth(this.text)/2 and my > this.y - ui.font:getHeight()/2 and my < this.y + ui.font:getHeight()/2 then
			return true
		end
	end
	return false
end

function ui.setKey(this, key_type)
	
	if ui.setting_key then
		ui.element["btn_"..ui.setting_key].title[1] = string.upper(settings[ui.setting_key])
	end
	
	ui.setting_key = key_type
	this.title[1] = "..."
	
end

function ui.newAnnounce(text)
	
	table.insert(ui.announce, {text = text, tick = 2})
	
end

function ui.getCamX()
	return (love.graphics.getWidth() - ui.menu_w * ui.getScale()) / 2
end
function ui.getCamY()
	return 0
end
function ui.getScale()
	return love.graphics.getHeight() / ui.menu_h
end

function ui.openLink(link)
	love.system.openURL(link)
end

return ui
