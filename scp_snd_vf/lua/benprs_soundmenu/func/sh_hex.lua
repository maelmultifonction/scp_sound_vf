function hex(hex)

    if string.sub(hex, 1, 1) == "#" then
        local r = tonumber(string.sub(hex, 2, 3), 16)
        local g = tonumber(string.sub(hex, 4, 5), 16)
        local b = tonumber(string.sub(hex, 6, 7), 16)

        return Color(r, g, b) 
    else
        return Color(255,255,255)
    end
end
