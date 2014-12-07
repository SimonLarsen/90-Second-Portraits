function love.conf(t)
    t.identity = "portraits"
    t.version = "0.9.1"
    t.console = false

    t.window.title = "X Second Portraits"
    t.window.icon = nil                
    t.window.width = 320*3               
    t.window.height = 240*3              
    t.window.borderless = false        
    t.window.resizable = false         
    t.window.minwidth = 1              
    t.window.minheight = 1             
    t.window.fullscreen = false        
    t.window.fullscreentype = "normal" 
    t.window.vsync = true              
    t.window.fsaa = 0                  
    t.window.display = 1               
    t.window.highdpi = false           
    t.window.srgb = false              

    t.modules.audio = true             
    t.modules.event = true             
    t.modules.graphics = true          
    t.modules.image = true             
    t.modules.joystick = true          
    t.modules.keyboard = true          
    t.modules.math = true              
    t.modules.mouse = true             
    t.modules.physics = true           
    t.modules.sound = true             
    t.modules.system = true            
    t.modules.timer = true             
    t.modules.window = true            
    t.modules.thread = true            
end
