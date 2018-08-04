screenWidth = 80
screenHeight = 50
tileWidth = 16
tileHeight = 16
screenWidthPixels = screenWidth * tileWidth
screenHeightPixels = screenHeight * tileHeight

mapWidth = 80
mapHeight = 45

max_monsters_per_room = 3

colors = {
        dark_wall = { 0, 0, 100.0/255.0, 255.0/255.0 },
        dark_ground = { 50.0/255.0, 50.0/255.0, 150/255.0, 255.0/255.0 },
        light_wall = { 130.0/255.0, 110.0/255.0, 50.0/255.0, 255.0/255.0 },
        light_ground = { 200.0/255.0, 180.0/255.0, 50.0/255.0, 255.0/255.0 }
        --dark_wall = { 0, 0, 10.0/255.0, 255.0/255.0 },
        --dark_ground = { 5.0/255.0, 5.0/255.0, 15/255.0, 255.0/255.0 },
        --light_wall = { 13.0/255.0, 11.0/255.0, 5.0/255.0, 255.0/255.0 },
        --light_ground = { 20.0/255.0, 18.0/255.0, 5.0/255.0, 255.0/255.0 }
    }
    
room_max_size = 10
room_min_size = 6
max_rooms = 30

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
