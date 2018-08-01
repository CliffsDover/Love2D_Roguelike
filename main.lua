if arg[2] then
    require( arg[2] .. "/main" )
else
    io.write([[
ERROR: Please specify a folder, for example:
    love . Part01
]])

    love.event.push('quit')
end
