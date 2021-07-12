
background = {}
background.libname = "background"
drawable_add(background, "background", -1)


background.backgrounds = {
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


-- background.acu = 100
-- background.acuv = 1
-- background.shape_rot = 0
-- background.changetick = 0
-- background.tick = 0
-- background.cycle_length = math.pi * 1

-- function background.init()
-- 	background.rand = math.random(10,200)
-- 	background.tmax = (230 - background.rand)/3
-- 	background.shape_size = math.random(10,30)
-- 	background.shape = math.random(1,2)
-- 	background.scale = 0
-- 	background.scalev = 25
-- end
-- background.init()

-- function background.equ(rot)
-- 	return 10*math.sin(rot*background.rand)
-- end


function background.getPointX(rot)
	return love.graphics.getWidth()/2 + math.cos(rot) * background.equ(rot) * 50
end
function getPointY(rot)
	return love.graphics.getHeight()/2 - math.sin(rot) * background.equ(rot) * 50
end

function background.draw()
	
	if ui.menu_open ~= "game" and ui.menu_open ~= "gameover" then
		return
	end
	
	-- BG Image --
	love.graphics.origin()
	love.graphics.setColor(0.5, 0.5, 0.5)
	local scale = math.max(love.graphics.getHeight() / background.image:getHeight(), love.graphics.getWidth() / background.image:getWidth())
	if background.backgrounds[background.id].anchor == "left" then
		love.graphics.draw(background.image, 0, 0, 0, scale, scale)
	elseif background.backgrounds[background.id].anchor == "right" then
		love.graphics.draw(background.image, love.graphics.getWidth(), 0, 0, scale, scale, background.image:getWidth(), 0)
	end
	
	-- Trippy Animation --
	-- for f = 0, background.tmax, math.pi/background.acu do
		
	-- 	love.graphics.setColor((math.sin(love.timer.getTime()*1)+1)/2*255/255,math.min(f*10,255)/255,255-(background.tmax-f*3)/255,150/255)
	-- 	local x = background.getPointX(f)
	-- 	local y = getPointY(f)
	-- 	love.graphics.polygon("fill",
	-- 		x + math.cos(background.shape_rot)*background.shape_size, y+math.sin(background.shape_rot)*background.shape_size,
	-- 		x + math.cos(background.shape_rot+math.pi/2)*background.shape_size, y+math.sin(background.shape_rot+math.pi/2)*background.shape_size,
	-- 		x + math.cos(background.shape_rot+math.pi)*background.shape_size, y+math.sin(background.shape_rot+math.pi)*background.shape_size,
	-- 		x + math.cos(background.shape_rot+math.pi/2*3)*background.shape_size, y+math.sin(background.shape_rot+math.pi/2*3)*background.shape_size
	-- 	)
		
	-- end
	
end


function background.update(dt)
	
	if ui.menu_open ~= "game" and ui.menu_open ~= "gameover" then
		return
	end
	
	-- background.tick = background.tick + dt
	-- if background.tick > background.cycle_length then
	-- 	background.tick = background.tick - background.cycle_length
	-- 	-- background.init()
	-- end
	
	-- if (background.acuv > 0 and background.acu > 40) or (background.acuv < 0 and background.acu < 25) then
	-- 	background.acuv = -background.acuv
	-- end
	-- background.acu = background.acu + 0.01 * background.acuv * dt
	
	-- background.shape_rot = background.shape_rot + 1 * dt
	-- if background.shape_rot > math.pi then
	-- 	background.shape_rot = background.shape_rot - math.pi
	-- end
	
end


return background
