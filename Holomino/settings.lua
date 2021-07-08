-- Settings --

settings = {}
settings.libname = "settings"

settings.version = "1.0"

settings.key_left = "left"
settings.key_right = "right"
settings.key_rot_right = "x"
settings.key_rot_left = "z"
settings.key_flip = ""
settings.key_down = "down"
settings.key_drop = "space"
settings.key_hold = "lshift"

settings.joy_left = ""
settings.joy_right = ""
settings.joy_rot_right = ""
settings.joy_rot_left = ""
settings.joy_flip = ""
settings.joy_down = ""
settings.joy_drop = ""
settings.joy_hold = ""

settings.show_grid = true
settings.show_particles = true
settings.double_press_protection = 0.2

settings.effect_volume = 0.5
settings.voice_volume = 0.5
settings.music_volume = 1/4

settings.video_fullscreen = false


function settings.load()
	
	dat = love.filesystem.read("settings.cfg")
	
	if dat then
		
		dat_tbl = string.split(dat, "\n")
		
		is_outdated = true
		for index, this in pairs (dat_tbl) do
			if this == "version="..settings.version then
			is_outdated = false
				break
			end
		end
		if is_outdated then
			settings.save()
			love.window.showMessageBox("GOMENNASORRY", "We detected a different game version so your settings had to be reset.\n別のゲームバージョンが検出されたため、設定をリセットする必要がありました。", {"OK"}, "warning")
		else
			
			for index, this in pairs (dat_tbl) do
				
				info = string.split(this, "=")
				
				if settings[info[1]] then
					if type(settings[info[1]]) == "string" then
						settings[info[1]] = tostring(info[2])
						
					elseif type(settings[info[1]]) == "number" then
						settings[info[1]] = tonumber(info[2])
						
					elseif type(settings[info[1]]) == "boolean" then
						settings[info[1]] = info[2] == "true"
						
					end
				end
				
			end
			
		end
		
	else
		
		settings.save()
		
	end
	
	settings.createUI()
	
	-- control button names --
	for index, this in pairs (settings) do
		if ui.element["btn_"..index] then
			ui.element["btn_"..index].title[1] = string.upper(this)
		end
	end
	
	-- volume --
	for index, this in pairs (sound.effects) do
		this:setVolume(settings.effect_volume)
	end
	
	for voice_index, this_voice in pairs (sound.voice) do
		for sound_index, this_sound in pairs (this_voice) do
			this_sound:setVolume(settings.voice_volume)
		end
	end
	
	for index, this in pairs (music) do
		this:setVolume(settings.music_volume)
	end
	
	-- music[bgm.menu_bgm_loop]:setLooping(true)
	-- music[bgm.menu_bgm_intro]:play()
	
end

function settings.save()
	
	dat = ""
	
	for index, this in pairs (settings) do
		
		if index ~= "libname" and type(this) ~= "function" then
			dat = dat ..index .."="..tostring(this).."\n"
		end
		
	end
	
	love.filesystem.write("settings.cfg", dat)
	
end

function settings.createUI()
	
	-- main menu --
	ui.element["start_btn"] = {type = "button", menu = "main", title = {"START", "スタート"}, x = 148, y = 155, w = 160, h = 70, press = function() ui.openMenu("game", true) end}
	table.insert(ui.element, {type = "button", menu = "main", title = {"SETTINGS", "設定"}, x = 148, y = 356, w = 160, h = 70, press = function() ui.openMenu("settings", true) end})
	table.insert(ui.element, {type = "button", menu = "main", title = {"ABOUT", " クレジット"}, x = 621, y = 155, w = 160, h = 70, press = function() ui.openMenu("about", true) end})
	table.insert(ui.element, {type = "button", menu = "main", title = {"EXIT", "やめろ"}, x = 621, y = 356, w = 160, h = 70, press = function() ui.openMenu("quit_conf", false) sound.effects.tone_high:stop() sound.effects.tone_high:play() end})
	
	-- settings --
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*1/3, y = 155-15, text = "Sound Effect Volume"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*1/3, y = 255-15, text = "Voice Volume"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*1/3, y = 355-15, text = "Music Volume"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*1/3, y = 155+15, text = "効果音ボリューム"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*1/3, y = 255+15, text = "声ボリューム"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*1/3, y = 355+15, text = "音楽ボリューム"})
	ui.element["settings_effect_volume"] = {type = "slider", menu = "settings", x = 764*2/3, y = 155, w = 150, h = 25, value = settings.effect_volume,
	valueSet = function(value)--Effect Volume
		
		settings.effect_volume = value
		ui.element["pause_effect_volume"].value = value
		
		for index, this in pairs (sound.effects) do
			this:setVolume(value)
		end
		
		sound.effects.tone_low:stop()
		sound.effects.tone_low:play()
		
	end}
	ui.element["settings_voice_volume"] = {type = "slider", menu = "settings", x = 764*2/3, y = 255, w = 150, h = 25, value = settings.voice_volume,
	valueSet = function(value)--Voice Volume
		
		settings.voice_volume = value
		ui.element["pause_voice_volume"].value = value
		
		for voice_index, this_voice in pairs (sound.voice) do
			for sound_index, this_sound in pairs (this_voice) do
				this_sound:setVolume(value)
			end
		end
		
		sound.voice.gura.point:stop()
		sound.voice.gura.point:play()
		
	end}
	ui.element["settings_music_volume"] = {type = "slider", menu = "settings", x = 764*2/3, y = 355, w = 150, h = 25, value = settings.music_volume,
	valueChanged = function(value)--Music Volume
		
		for index, this in pairs (music) do
			this:setVolume(value)
		end
		
	end,
	valueSet = function(value)--Music Volume
		
		settings.music_volume = value
		ui.element["pause_music_volume"].value = value
		
		for index, this in pairs (music) do
			this:setVolume(value)
		end
		
	end}
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*2/8, y = 455-15, text = "Particles"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*2/8, y = 455+15, text = "パーティクル"})
	table.insert(ui.element, {type = "checkbox", menu = "settings", x = 764*3/8, y = 455, w = 20, h = 20, value = settings.show_particles, valueChanged = function(value) settings.show_particles = value end})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*5/8, y = 455-15, text = "Grid"})
	table.insert(ui.element, {type = "text", menu = "settings", x = 764*5/8, y = 455+15, text = " グリッド"})
	table.insert(ui.element, {type = "checkbox", menu = "settings", x = 764*6/8, y = 455, w = 20, h = 20, value = settings.show_grid, valueChanged = function(value) settings.show_grid = value end})
	table.insert(ui.element, {type = "button", menu = "settings", title = {"Key Bindings", "キーバインド"}, x = 764/2, y = 655, w = 180, h = 70, press = function() ui.openMenu("controls", true) end})
	table.insert(ui.element, {type = "button", menu = "settings", title = {"BACK", "戻る"}, x = 379.5, y = 928, w = 160, h = 70, press = function() ui.openMenu("main", true) settings.save() end})


	-- about --
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2, y = 155, text = "Game made by:"})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2, y = 190, text = "@BlueSheep777", press = function() ui.openLink("https://twitter.com/BlueSheep777") end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2 - ui.font:getWidth("Menu art by:  ")/2, y = 355, text = "Menu art by:  "})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2 + ui.font:getWidth("@Chameleon_Ch")/2, y = 355, text = "@Chameleon_Ch", press = function() ui.openLink("https://twitter.com/Chameleon_Ch") end})
	-- table.insert(ui.element, {type = "text", menu = "about", x = 764/2 - ui.font:getWidth("Amelia art by:  ")/2, y = 385, text = "Amelia art by:  "})
	-- table.insert(ui.element, {type = "text", menu = "about", x = 764/2 + ui.font:getWidth("@walfieee")/2, y = 385, text = "@walfieee", press = function() ui.openLink("https://twitter.com/walfieee") end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2 - ui.font:getWidth("Game Music by:  ")/2, y = 455, text = "Game Music by:  "})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2 + ui.font:getWidth("yoyoyonono")/2, y = 455, text = "yoyoyonono", press = function() ui.openLink("http://www.ggrks.moe/") sound.voice.amelia.good_song:play() end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2 - ui.font:getWidth("Menu Music by:  ")/2, y = 485, text = "Menu Music by:  "})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2 + ui.font:getWidth("Kaiya Glenanne")/2, y = 485, text = "Kaiya Glenanne", press = function() sound.voice.amelia.good_song:play() end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2, y = 555, text = "Fonts Used:"})
	table.insert(ui.element, {type = "text", menu = "about", x = 764*1/3, y = 580, text = "Exo", press = function() ui.openLink("https://www.1001fonts.com/exo-font.html") end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764*2/3, y = 580, text = "やさしさゴシックボールドV2", press = function() ui.openLink("https://flopdesign.booth.pm/items/1833993") end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2, y = 800, text = "Thanks for playing!   遊んでくれてありがとう！"})
	table.insert(ui.element, {type = "button", menu = "about", title = {"BACK", "戻る"}, x = 379.5, y = 928, w = 160, h = 70, press = function() ui.openMenu("main", true) end})
	table.insert(ui.element, {type = "text", menu = "about", x = 764/2, y = 1065, text = "Hololive Production is a property of Ⓒ COVER Corp", press = function() ui.openLink("https://en.hololive.tv/terms") end})

	-- pause --
	table.insert(ui.element, {type = "text", menu = "pause", x = 764/2, y = 155, text = "- PAUSED -"})
	table.insert(ui.element, {type = "text", menu = "pause", x = 764*1/3, y = 255-15, text = "Sound Effect Volume"})
	table.insert(ui.element, {type = "text", menu = "pause", x = 764*1/3, y = 355-15, text = "Voice Volume"})
	table.insert(ui.element, {type = "text", menu = "pause", x = 764*1/3, y = 455-15, text = "Music Volume"})
	table.insert(ui.element, {type = "text", menu = "pause", x = 764*1/3, y = 255+15, text = "効果音ボリューム"})
	table.insert(ui.element, {type = "text", menu = "pause", x = 764*1/3, y = 355+15, text = "声ボリューム"})
	table.insert(ui.element, {type = "text", menu = "pause", x = 764*1/3, y = 455+15, text = "音楽ボリューム"})
	ui.element["pause_effect_volume"] = {type = "slider", menu = "pause", x = 764*2/3, y = 255, w = 150, h = 25, value = settings.effect_volume,
	valueSet = function(value)--Effect Volume
		
		settings.effect_volume = value
		ui.element["settings_effect_volume"].value = value
		
		for index, this in pairs (sound.effects) do
			this:setVolume(value)
		end
		
		sound.effects.tone_low:stop()
		sound.effects.tone_low:play()
		
		settings.save()
		
	end}
	ui.element["pause_voice_volume"] = {type = "slider", menu = "pause", x = 764*2/3, y = 355, w = 150, h = 25, value = settings.voice_volume,
	valueSet = function(value)--Voice Volume
		
		settings.voice_volume = value
		ui.element["settings_voice_volume"].value = value
		
		for voice_index, this_voice in pairs (sound.voice) do
			for sound_index, this_sound in pairs (this_voice) do
				this_sound:setVolume(value)
			end
		end
		
		sound.voice.gura.point:stop()
		sound.voice.gura.point:play()
		
		settings.save()
		
	end}
	ui.element["pause_music_volume"] = {type = "slider", menu = "pause", x = 764*2/3, y = 455, w = 150, h = 25, value = settings.music_volume,
	valueChanged = function(value)--Music Volume
		
		for index, this in pairs (music) do
			this:setVolume(value)
		end
		
	end,
	valueSet = function(value)--Music Volume
		
		settings.music_volume = value
		ui.element["settings_music_volume"].value = value
		
		for index, this in pairs (music) do
			this:setVolume(value)
		end
		
		settings.save()
		
	end}
	table.insert(ui.element, {type = "button", menu = "pause", title = {"RESUME GAME", "再開"}, x = 764/2, y = 655, w = 250, h = 70, press = function() ui.openMenu("game", true) end})
	table.insert(ui.element, {type = "button", menu = "pause", title = {"RESET GAME", " リセット"}, x = 764/2, y = 755, w = 250, h = 70, press = function() ui.openMenu("reset_conf", false) sound.effects.tone_high:stop() sound.effects.tone_high:play() end})
	table.insert(ui.element, {type = "button", menu = "pause", title = {"QUIT TO TITLE", "メインメニューに戻る"}, x = 764/2, y = 855, w = 250, h = 70, press = function() ui.openMenu("main", true) end})

	-- controls --
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*5/8, y = 155-15-90, text = "Keyboard"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*5/8, y = 155-15-90+30, text = "キーボード"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*7/8, y = 155-15-90, text = "Controller"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*7/8, y = 155-15-90+30, text = "コントローラー"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*0, text = "Move Right"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*0, text = "右移動"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*1, text = "Move Left"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*1, text = "左移動"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*2, text = "Rotate Clockwise"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*2, text = "右回転"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*3, text = "Rotate Counter-Clockwise"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*3, text = "左回転"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*4, text = "Flip"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*4, text = "フリップ"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*5, text = "Soft Drop"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*5, text = "ソフトドロップ"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*6, text = "Hard Drop"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*6, text = "ハードドロップ"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155-15+90*7, text = "Hold Piece"})
	table.insert(ui.element, {type = "text", menu = "controls", x = 764*1/4, y = 155+15+90*7, text = "ホールド"})
	
	ui.element["btn_key_right"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*0, w = 160, h = 50, press = function(this) ui.setKey(this, "key_right") end}
	ui.element["btn_key_left"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*1, w = 160, h = 50, press = function(this) ui.setKey(this, "key_left") end}
	ui.element["btn_key_rot_right"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*2, w = 160, h = 50, press = function(this) ui.setKey(this, "key_rot_right") end}
	ui.element["btn_key_rot_left"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*3, w = 160, h = 50, press = function(this) ui.setKey(this, "key_rot_left") end}
	ui.element["btn_key_flip"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*4, w = 160, h = 50, press = function(this) ui.setKey(this, "key_flip") end}
	ui.element["btn_key_down"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*5, w = 160, h = 50, press = function(this) ui.setKey(this, "key_down") end}
	ui.element["btn_key_drop"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*6, w = 160, h = 50, press = function(this) ui.setKey(this, "key_drop") end}
	ui.element["btn_key_hold"] = {type = "button", menu = "controls", title = {}, x = 764*5/8, y = 155+90*7, w = 160, h = 50, press = function(this) ui.setKey(this, "key_hold") end}
	
	ui.element["btn_joy_right"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*0, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_right") end}
	ui.element["btn_joy_left"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*1, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_left") end}
	ui.element["btn_joy_rot_right"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*2, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_rot_right") end}
	ui.element["btn_joy_rot_left"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*3, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_rot_left") end}
	ui.element["btn_joy_flip"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*4, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_flip") end}
	ui.element["btn_joy_down"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*5, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_down") end}
	ui.element["btn_joy_drop"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*6, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_drop") end}
	ui.element["btn_joy_hold"] = {type = "button", menu = "controls", title = {}, x = 764*7/8, y = 155+90*7, w = 160, h = 50, press = function(this) ui.setKey(this, "joy_hold") end}
	
	table.insert(ui.element, {type = "button", menu = "controls", title = {"BACK", "戻る"}, x = 379.5, y = 928, w = 160, h = 70, press = function() ui.openMenu("settings", true) settings.save() end})
	
	-- game over --
	table.insert(ui.element, {type = "button", menu = "gameover", title = {"PLAY AGAIN", "やり直し"}, x = 10, y = 755, w = 250, h = 70, press = function() ui.openMenu("game", true) end})
	table.insert(ui.element, {type = "button", menu = "gameover", title = {"QUIT TO TITLE", "メインメニューに戻る"}, x = 10, y = 855, w = 250, h = 70, press = function() ui.openMenu("main", true) end})
	
	-- reset confirmation --
	table.insert(ui.element, {type = "text", menu = "reset_conf", x = 764/2, y = 255-15, text = "Are you sure you want to reset your current game?"})
	table.insert(ui.element, {type = "text", menu = "reset_conf", x = 764/2, y = 255+15, text = "TRANSLATION NEEDED"})
	table.insert(ui.element, {type = "button", menu = "reset_conf", title = {"Yes", "はい"}, x = 148, y = 555, w = 250, h = 70, press = function() tetris.load() ui.openMenu("game", true) end})
	table.insert(ui.element, {type = "button", menu = "reset_conf", title = {"No", "いいえ"}, x = 621, y = 555, w = 250, h = 70, press = function() ui.openMenu("pause", false) sound.effects.tone_high:stop() sound.effects.tone_high:play() end})
	
	-- quit confermation --
	table.insert(ui.element, {type = "text", menu = "quit_conf", x = 764/2, y = 555-15, text = "Are you sure?"})
	table.insert(ui.element, {type = "text", menu = "quit_conf", x = 764/2, y = 555+15, text = "宜しですか?"})
	table.insert(ui.element, {type = "button", menu = "quit_conf", title = {"Yes", "はい"}, x = 148, y = 655, w = 250, h = 70, press = function() love.event.quit() end})
	table.insert(ui.element, {type = "button", menu = "quit_conf", title = {"No", "いいえ"}, x = 621, y = 655, w = 250, h = 70, press = function() ui.openMenu("main", false) sound.effects.tone_high:stop() sound.effects.tone_high:play() end})
	
	
end


return settings
