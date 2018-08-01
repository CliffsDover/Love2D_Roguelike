screenWidth = 80
screenHeight = 50
tileWidth = 16
tileHeight = 16
screenWidthPixels = screenWidth * tileWidth
screenHeightPixels = screenHeight * tileHeight

mapWidth = 80
mapHeight = 45

function love.conf( t )
    t.identity = nil
    t.version = 11.1
    t.console = false
    t.window.title = "Roguelike"
    t.window.width = screenWidthPixels
    t.window.height = screenHeightPixels
    t.window.fullscreen = true             -- Enable fullscreen (boolean)
    --t.window.fullscreentype = "exclusive"   -- Standard fullscreen or desktop fullscreen mode (string)
    
end
