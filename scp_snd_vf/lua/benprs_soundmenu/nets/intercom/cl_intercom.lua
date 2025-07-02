local infoFrame
local RNDX = include("../../func/cl_rndx.lua")
net.Receive("BENPRS:SCPSOUNDVF::INTERCOM_HUD", function() 
    local isSpeaking = net.ReadBool()

    if isSpeaking then  
        if IsValid(infoFrame) then
            infoFrame:Remove()
        end

        if IsValid(infoFrame) and infoFrame.sound then
            infoFrame.sound:Stop()
        end

        sound.PlayFile("sound/benprs/_script/pa_system/PA_START1.mp3", "noplay", function(station)
            if IsValid(station) then
                station:SetVolume(0.2)
                station:Play()
                infoFrame.sound = station
            end
        end)

        infoFrame = vgui.Create("DPanel")
        infoFrame:SetSize(RW(300), RH(50))
        infoFrame:SetPos((ScrW() - RW(300)) / 2, ScrH() - RH(50) - 10)
        infoFrame:SetAlpha(0) 
        infoFrame:AlphaTo(255, 0.4, 0)

        infoFrame.Paint = function(self, w, h)
            RNDX.Draw(6, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"] )
            draw.SimpleText(
                "Annonce à l'intercom",
                SCPSNDVF:Font("Poppins", 12, 90),
                RW(150),
                RH(25),
                SCPSNDVF.CONFIG.COULEUR["blanc_fade"],
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        end 
    else 
        sound.PlayFile("sound/benprs/_script/pa_system/PA_STOP1.mp3", "noplay", function(station)
            if IsValid(station) then
            station:SetVolume(0.2)
            station:Play()
            end
        end)
        if IsValid(infoFrame) then
            infoFrame:AlphaTo(0, 0.4, 0, function()
                infoFrame:Remove()
            end)
        end 
    end
end)

function draw.Circle(x, y, radius, seg)
    local cir = {}

    for i = 0, seg do
        local a = math.rad((i / seg) * -360)
        table.insert(cir, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius
        })
    end

    draw.NoTexture()
    surface.DrawPoly(cir)
end

local showHUD = false
local startTime = 0
local endTime = 1
local canSpeak = false

net.Receive("BENPRS:SCPSOUNDVF::INTERCOM_HUD_SPEAK", function()
    local isSpeaking = net.ReadBool()

    if isSpeaking then 
        showHUD = true
        startTime = CurTime()
        endTime = startTime + 2.5
        canSpeak = false 
    else 
        showHUD = false
    end
end)

hook.Add("HUDPaint", "BENPRS:SCPSOUNDVF::INTERCOM_HUD_DISPLAY", function()
    if not showHUD then return end

    RNDX.Draw(6, RW(5), RH(1080/2), RW(300), RH(50), SCPSNDVF.CONFIG.COULEUR["fond"] )
    local timeLeft = math.ceil(endTime - CurTime())
    if CurTime() >= endTime then
        canSpeak = true
    end

    RNDX.DrawCircle(RW(25), RH(565), 32, canSpeak and Color(178, 235, 131) or Color(83, 26, 26))

    draw.SimpleText(
        canSpeak and "C'est à vous de parler !" or ("Parlez dans " .. timeLeft .. "..."),
        SCPSNDVF:Font("Poppins", 12, 90),
        RW(50),
        RH(566),
        SCPSNDVF.CONFIG.COULEUR["blanc_fade"],
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
end)