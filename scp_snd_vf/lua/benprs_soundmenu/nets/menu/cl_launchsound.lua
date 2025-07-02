
local infoFrame

local loop_sound = false 
local RNDX = include("../../func/cl_rndx.lua")
net.Receive("SCPSOUNDVF:BOUCLAGE:CHANGE", function()
    SCPSOUNDVF_SYSTEME_BOUCLAGE_ENABLE = net.ReadBool()
end)

net.Receive("BENPRS:SCPSOUNDVF::LAUNCHSOUNDCL", function() 
    local sound_url = net.ReadString()
    
    hook.Remove("HUDPaint", "SCPSOUNDVF:HUD:PLAYING")

    sound.PlayURL(sound_url, "noblock", function(soundChannel)
        if not IsValid(soundChannel) then return end

        VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND = soundChannel
        VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND:EnableLooping(SCPSOUNDVF_SYSTEME_BOUCLAGE_ENABLE)
        VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND:SetVolume(0.6)
        VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND:Play()

        if IsValid(infoFrame) then
            infoFrame:Remove()
        end
        infoFrame = vgui.Create("DPanel")
        infoFrame:SetSize(RW(300), RH(50))
        infoFrame:SetPos((ScrW() - RW(300)) / 2, ScrH() - RH(50) - 10)
        infoFrame:SetAlpha(0)

        infoFrame:AlphaTo(255, 0.4, 0)

        infoFrame.Paint = function(self, w, h)
            RNDX.Draw(6, 0, 0, w, h, SCPSNDVF.CONFIG.COULEUR["fond"] )
            draw.SimpleText("ANNONCE EN COURS", SCPSNDVF:Font("Poppins", 12, 90), RW(150), RH(20), SCPSNDVF.CONFIG.COULEUR["blanc_fade"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if IsValid(VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND) then
                local length = VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND:GetLength() or 0
                local pos = VAR_SYSTEM_BENSOUNDMENU_PLAYSOUND:GetTime() or 0
                if length > 0 then
                    local barW, barH = RW(260), RH(12)
                    local barX, barY = RW(15), RH(32)
                    local progress = math.Clamp(pos / length, 0, 1)
                    RNDX.Draw(6, barX, barY, barW, barH, SCPSNDVF.CONFIG.COULEUR["fond_txt"] )
                    RNDX.Draw(6, barX, barY, barW * progress, barH, SCPSNDVF.CONFIG.COULEUR["texte"] )
                end
            end
        end

        timer.Create("SCPSOUNDVF:CHECK_END", 0.3, 0, function()
            if not IsValid(soundChannel) or soundChannel:GetState() == GMOD_CHANNEL_STOPPED then
                if IsValid(infoFrame) then
                    infoFrame:AlphaTo(0, 0.4, 0, function()
                        infoFrame:Remove()
                    end)
                end
                timer.Remove("SCPSOUNDVF:CHECK_END")
            end
        end)
    end)
end)