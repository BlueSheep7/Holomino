
version = "Beta 1.1"

function love.conf(t)
	
	t.identity = "Holomino"
	t.window.title = "Holomino "..version
	t.window.icon = "graphics/icon.png"
	
	t.window.resizable = true
	t.window.width = (10+2 + 4+2 + 4+2) * 40
	t.window.height = (20+2+3) * 40
	-- t.window.fullscreen = true
	-- t.window.vsync = false
	t.console = true
	
end
