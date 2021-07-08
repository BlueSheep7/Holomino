-- Settings --
-- RWL --

joy = {}
joy.libname = "joy"

joy.holding_right = false
joy.holding_left = false
joy.holding_down = false

function joy.load()
	joy.sticks = love.joystick.getJoysticks()
end

function joy.update(dt)
	
	joy.holding_right = false
	joy.holding_left = false
	joy.holding_down = false
	
	for index, this in pairs (joy.sticks) do
		
		if settings.joy_left ~= "" and this:isGamepadDown(settings.joy_left) then
			joy.holding_left = true
		end
		if settings.joy_right ~= "" and this:isGamepadDown(settings.joy_right) then
			joy.holding_right = true
		end
		if settings.joy_down ~= "" and this:isGamepadDown(settings.joy_down) then
			joy.holding_down = true
		end
		
	end
	
end

function love.gamepadpressed(joystick, button)
	
	if ui.menu_open == "game" then
		
		if button == settings.joy_left then
			tetris.keypressed(settings.key_left)
		elseif button == settings.joy_right then
			tetris.keypressed(settings.key_right)
		elseif button == settings.joy_rot_right then
			tetris.keypressed(settings.key_rot_right)
		elseif button == settings.joy_rot_left then
			tetris.keypressed(settings.key_rot_left)
		elseif button == settings.joy_flip then
			tetris.keypressed(settings.key_flip)
		elseif button == settings.joy_down then
			tetris.keypressed(settings.key_down)
		elseif button == settings.joy_drop then
			tetris.keypressed(settings.key_drop)
		elseif button == settings.joy_hold then
			tetris.keypressed(settings.key_hold)
		end
		
	elseif ui.menu_open == "controls" then
		
		if ui.setting_key then
			
			if string.sub(ui.setting_key, 1, 4) == "joy_" then
				settings[ui.setting_key] = button
				ui.element["btn_"..ui.setting_key].title[1] = string.upper(button)
				
				ui.setting_key = nil
				
				sound.effects.tone_low:stop()
				sound.effects.tone_low:play()
			end
			
		end
		
	end
	
end

function love.joystickadded(joystick)
	joy.sticks = love.joystick.getJoysticks()
end
function love.joystickremoved(joystick)
	joy.sticks = love.joystick.getJoysticks()
end


return joy
