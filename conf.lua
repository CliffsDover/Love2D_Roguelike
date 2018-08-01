screenWidth = 80
screenHeight = 50
tileWidth = 16
tileHeight = 16
screenWidthPixels = screenWidth * tileWidth
screenHeightPixels = screenHeight * tileHeight

function love.conf( t )
    t.identity = nil
    t.version = 11.1
    t.console = false
    t.window.title = "Roguelike"
    t.window.width = screenWidthPixels
    t.window.height = screenHeightPixels
end
