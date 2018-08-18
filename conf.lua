function love.conf(t)
    t.identity = "dk.tangramgames.90secondportraits"
    t.version = "11.0"
    t.console = false
    t.accelerometerjoystick = false
    t.gammacorrect = false
 
    t.window.title = "90 Second Portraits"
    t.window.icon = nil
    t.window.width = 320
    t.window.height = 240
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.msaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    t.modules.video = false
    t.modules.joystick = false
    t.modules.physics = false
end
