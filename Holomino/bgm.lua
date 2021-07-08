-- Settings --

bgm = {}
bgm.libname = "bgm"


bgm.menu_bgm_intro = "suisei_remix_intro"
bgm.menu_bgm_loop = "suisei_remix_loop"
bgm.playing_menu_intro = true

bgm.game_bgm_intro = "next_colour_planet_remix_intro"
bgm.game_bgm_loop = "next_colour_planet_remix_loop"
bgm.playing_game_intro = true


-- bgm.game_bgm = {
-- {name = "akai_haatos_bgm_flow",				artist = "@itsprojectroyal", link = "https://youtu.be/EO3H4dp8Rac", full_name = "akai haato's bgm but it's a melancholic lo-fi beat"},
-- {name = "korone_goes_home",					artist = "@itsprojectroyal", link = "https://youtu.be/iiq7xRqXtNc", full_name = "korone goes home (lo-fi future bass)"},
-- {name = "pls_rip",							artist = "@itsprojectroyal", link = "https://youtu.be/BAaM70YTcvI", full_name = "please rip♡ (remix instrumental)"},
-- {name = "rushias_yandare_rap",				artist = "@itsprojectroyal", link = "https://youtu.be/KXW7USW2nLY", full_name = "rushia's yandere rap for tamaki (chill remix)"},
-- {name = "the_watson_concoction_experience",	artist = "@itsprojectroyal", link = "https://youtu.be/zXTs25-eYHk", full_name = "the watson concoction experience (lo-fi hip hop)"},
-- {name = "usagi_chillhop",					artist = "@itsprojectroyal", link = "https://youtu.be/7DqDRE_SW34", full_name = "usagi chillhop (peko type beat)"},
-- {name = "watame_factory",					artist = "@itsprojectroyal", link = "https://youtu.be/y6Afqx_bFBc", full_name = "watame factory but it's LOFI"},
-- {name = "watame-lon_head_rap",				artist = "@itsprojectroyal", link = "https://youtu.be/UAuvULuOSvY", full_name = "watame-lon head rap (aesthetic lofi remix)"},
-- {name = "watames_lullaby",					artist = "@itsprojectroyal", link = "https://youtu.be/NssVxzzqFM4", full_name = "watame's lullaby but it's lo-fi"},
-- {name = "orewa korone",						artist = "@itsprojectroyal", link = "https://youtu.be/GBpoKvqt4Ws", full_name = "orewa korone but it's Lo-Fi trap (w/ lyrics)"},
-- }

-- bgm.game_playing = 1

-- function bgm.load()
	
	
	
-- end

function bgm.update(dt)
	
	-- music loop --
	if ui.menu_open == "game" or ui.menu_open == "pause" or ui.menu_open == "reset_conf" then
		
		-- if not music[bgm.game_bgm[bgm.game_playing].name]:isPlaying() then
			
		-- 	bgm.game_playing = bgm.game_playing + 1
		-- 	if bgm.game_playing > #bgm.game_bgm then
		-- 		bgm.game_playing = 1
		-- 	end
		-- 	music[bgm.game_bgm[bgm.game_playing].name]:play()
			
		-- 	if ui.menu_open == "game" then
		-- 		music[bgm.game_bgm[bgm.game_playing].name]:setFilter({
		-- 			type = 'lowpass',
		-- 			volume = 1,
		-- 			highgain = 1,
		-- 		})
		-- 	elseif ui.menu_open == "pause" or ui.menu_open == "reset_conf" then
		-- 		music[bgm.game_bgm[bgm.game_playing].name]:setFilter({
		-- 			type = 'lowpass',
		-- 			volume = 1,
		-- 			highgain = 0.01,
		-- 		})
		-- 	end
			
		-- end
		
		if bgm.playing_game_intro and not music[bgm.game_bgm_intro]:isPlaying() then
			
			bgm.playing_game_intro = false
			music[bgm.game_bgm_loop]:play()
			
		end
		
	elseif ui.menu_open == "gameover" or ui.menu_open == "splash" or ui.menu_open == "quit_conf" then
		-- dont loop any music
	else
		
		if bgm.playing_menu_intro and not music[bgm.menu_bgm_intro]:isPlaying() then
			
			bgm.playing_menu_intro = false
			music[bgm.menu_bgm_loop]:play()
			
		end
		
	end
	
end

function bgm.openMenu(menu, old_menu)
	
	if menu == "main" then
		
		if old_menu == "pause" or old_menu == "game" or old_menu == "gameover" or old_menu == "splash" or old_menu == "quit_conf" then
			
			stopAll(music)
			
			music[bgm.menu_bgm_intro]:play()
			bgm.playing_menu_intro = true
			
			music[bgm.game_bgm_intro]:setFilter({
				type = 'lowpass',
				volume = 1,
				highgain = 1,
			})
			music[bgm.game_bgm_loop]:setFilter({
				type = 'lowpass',
				volume = 1,
				highgain = 1,
			})
			
		end
		
	elseif menu == "game" then
		
		if old_menu == "main" or old_menu == "gameover" then
			
			stopAll(music)
			-- bgm.game_playing = math.random(1, #bgm.game_bgm)
			-- music[bgm.game_bgm[bgm.game_playing].name]:play()
			music[bgm.game_bgm_intro]:play()
			bgm.playing_game_intro = true
			
		elseif old_menu == "pause" or old_menu == "reset_conf" then
			
			-- music[bgm.game_bgm[bgm.game_playing].name]:setFilter({
			music[bgm.game_bgm_intro]:setFilter({
				type = 'lowpass',
				volume = 1,
				highgain = 1,
			})
			music[bgm.game_bgm_loop]:setFilter({
				type = 'lowpass',
				volume = 1,
				highgain = 1,
			})
			
		end
		
	elseif menu == "pause" then
		
		-- music[bgm.game_bgm[bgm.game_playing].name]:setFilter({
		music[bgm.game_bgm_intro]:setFilter({
			type = 'lowpass',
			volume = 1,
			highgain = 0.01,
		})
		music[bgm.game_bgm_loop]:setFilter({
			type = 'lowpass',
			volume = 1,
			highgain = 0.01,
		})
		
	elseif menu == "quit_conf" then
		
		stopAll(music)
				
	end
	
end


return bgm
