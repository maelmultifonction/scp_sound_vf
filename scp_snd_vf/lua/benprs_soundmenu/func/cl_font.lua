SCPSNDVF.Fonts = {}

hook.Add("OnScreenSizeChanged", "SCPSNDVF:FONTS:SIZE", function()
    SCPSNDVF.Fonts = {}
end)

function SCPSNDVF:Font(FontName, Size, Weight)

    local Weight = Weight or 8
    local FontCreate = "SCPSNDVF:Panel:"..tostring(Size)..":"..tostring(Weight)..":"..FontName
    if not SCPSNDVF.Fonts[FontCreate] then

        surface.CreateFont(FontCreate, {
            font = FontName,
            size = ScreenScale(Size),
            antialias = true,
            weight = ScreenScale(Weight),
            extended = false
        })

        SCPSNDVF.Fonts[FontCreate] = true
    
    end

    return FontCreate
end