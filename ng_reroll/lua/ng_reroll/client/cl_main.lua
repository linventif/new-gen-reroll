local function RespW(x)
    return ScrW() / 1920 * x
end

local function RespH(y)
    return ScrH() / 1080 * y
end

if NGReroll.Config.ShowBar then
    hook.Add("HUDPaint", "NGHUD", function()
        if not LocalPlayer():Alive() then return end
        local maxmana = LocalPlayer():GetNWInt("NGManaMax")
        local mana = math.Clamp(LocalPlayer():GetNWInt("NGMana"), 0, maxmana)
        local percent = math.Clamp((mana / maxmana) * 100, 0, 100)
        draw.RoundedBox(7, RespW((ScrW() / 2) - 400 / 2) - 6, RespH(ScrH() - 70 - 6), RespW(400 + 12), RespH(30 + 12), NGReroll.Config.BarBackColor2)
        draw.RoundedBox(6, RespW((ScrW() / 2 ) - 400 / 2), RespH(ScrH() - 70 ), RespW(400), RespH(30), NGReroll.Config.BarBackColor)
        draw.RoundedBox(6, RespW((ScrW() / 2) - (percent * 4) / 2), RespH(ScrH() - 70), RespW((percent * 4)), RespH(30), NGReroll.Config.BarColor)
        draw.SimpleText("Mana : " .. mana .. " / " .. maxmana, "LinvFontRobo20", RespW(ScrW() / 2), RespH(ScrH() - 55), NGReroll.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end

local actions = {
    [1] = "edit_mana",
    [2] = "set_mana",
    [3] = "edit_reroll",
    [4] = "set_reroll",
    [5] = "set_nature",
    [6] = "inspect",
    [7] = "delete_data"
}

local function AddLogo(element)
    local LogoClasse = vgui.Create("DHTML", element)
    LogoClasse:SetSize(RespW(96), RespH(96))
    LogoClasse:SetPos(RespW(-96 / 2), RespH(-96 / 2))
    LogoClasse:SetMouseInputEnabled(false)
    LogoClasse:SetHTML( "<style> body, html { height: 100%; margin: 0; } .icon { background-image: url(https://i.imgur.com/KYpeGLB.png); height: 100%; background-position: center; background-repeat: no-repeat; background-size: cover; overflow: hidden;} </style> <body> <div class=\"icon\"></div> </body>" )
end

local function Notif(text)
    local frame = vgui.Create("DPanel")
    frame:SetSize(RespW(600), RespH(40))
    frame:SetPos(ScrW()/2-RespW(300), RespH(-100))
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColor)
        draw.SimpleText(text, "LinvFontRobo20", RespW(600)/2, RespH(20), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    frame:MoveTo(ScrW()/2-RespW(300), RespH(10), 0.5, 0, 1)
    timer.Simple(4, function()
        frame:MoveTo(ScrW()/2-RespW(300), -RespH(100), 0.5, 0, 1)
        timer.Simple(0.5, function()
            frame:Remove()
        end)
    end)
end

local function ConfirmMenu(msg, but_confirm, but_cancel)
    local but_confirm_text = but_confirm || "Confirmer"
    local but_cancel_text = but_cancel || "Annuler"
    local frame = vgui.Create("DFrame")
    frame:SetSize(RespW(400), RespH(200))
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColor)
        draw.SimpleText(msg, "LinvFontRobo20", RespW(400)/2, RespH(50), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local but_cancel = vgui.Create("DButton", frame)
    but_cancel:SetSize(RespW(140), RespH(40))
    but_cancel:SetPos(RespW(40), RespH(130))
    but_cancel:SetText(but_cancel_text)
    but_cancel:SetFont("LinvFontRobo20")
    but_cancel:SetTextColor(Color(255, 255, 255))
    but_cancel.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_cancel.DoClick = function()
        frame:Remove()
        return false
    end
    LinvLib.Hover(but_cancel, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    local but_confirm = vgui.Create("DButton", frame)
    but_confirm:SetSize(RespW(140), RespH(40))
    but_confirm:SetPos(RespW(220), RespH(130))
    but_confirm:SetText(but_confirm_text)
    but_confirm:SetFont("LinvFontRobo20")
    but_confirm:SetTextColor(Color(255, 255, 255))
    but_confirm.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_confirm.DoClick = function()
        frame:Remove()
        return true
    end
    LinvLib.Hover(but_confirm, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
end

local function InfoMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(RespW(800), RespH(600))
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColor)
        draw.SimpleText("New Gen Reroll Informations", "LinvFontRobo30", RespW(w/2), RespH(30), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        DisableClipping(true)
    end
    local space = 0
    for k, v in SortedPairs(NGReroll.Config.Information) do
        draw.SimpleText(v, "LinvFontRobo20", RespW(20), RespH(80 + space), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        space = space + 30
    end
    local scroll_txt = vgui.Create("DScrollPanel", frame)
    scroll_txt:SetSize(RespW(800), RespH(540))
    scroll_txt:SetPos(0, RespH(60))
    for k, v in SortedPairs(NGReroll.Config.Information) do
        local lab_wep = vgui.Create("DLabel", scroll_txt)
        lab_wep:SetSize(RespW(800), RespH(30))
        lab_wep:SetText(v)
        lab_wep:SetFont("LinvFontRobo20")
        lab_wep:Dock(TOP)
        lab_wep:DockMargin(0, 0, 0, 0)
        lab_wep:SetTextColor(Color(255, 255, 255))
        lab_wep:SetContentAlignment(5)
        lab_wep.Paint = function(self, w, h) return end
    end
    local but_close = vgui.Create("DButton", frame)
    // use material materials\linventif-library\icons\close_30px.png
    but_close:SetSize(RespW(30), RespH(30))
    but_close:SetPos(RespW(755), RespH(15))
    but_close:SetText("")
    but_close.Paint = function(self, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(Material("materials/linventif-library/icons/close_30px.png"))
        surface.DrawTexturedRect(0, 0, w, h)
    end
    but_close.DoClick = function()
        frame:Remove()
    end
    AddLogo(frame)
end

local function OpenMenuAdmnin()
    local data = {
        ["player"] = nil,
        ["action"] = nil,
        ["value"] = nil,
        ["custom"] = nil
    }
    local frame = vgui.Create("DFrame")
    frame:SetSize(RespW(800), RespH(600))
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(16, 0, 0, w, h, NGReroll.Config.MenuBackColor)
        draw.SimpleText("New Gen Reroll Admin", "LinvFontRobo30", RespW(w/2), RespH(30), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Joueurs", "LinvFontRobo25", RespW(160), RespH(75), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Actions", "LinvFontRobo25", RespW(420), RespH(75), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Valeur", "LinvFontRobo25", RespW(660), RespH(75), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Valeur Personalisé", "LinvFontRobo25", RespW(660), RespH(335), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Autre", "LinvFontRobo25", RespW(660), RespH(445), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(8, RespW(30), RespH(90), RespW(250), RespH(480), NGReroll.Config.MenuBackColorElement)
        draw.RoundedBox(8, RespW(310), RespH(90), RespW(215), RespH(480), NGReroll.Config.MenuBackColorElement)
        draw.RoundedBox(8, RespW(555), RespH(90), RespW(215), RespH(215), NGReroll.Config.MenuBackColorElement)
        DisableClipping(true)
    end
    local ply_num = 1
    local scroll_player = vgui.Create("DScrollPanel", frame)
    scroll_player:SetSize(RespW(250), RespH(480))
    scroll_player:SetPos(RespW(30), RespH(90))
    for _, ply in pairs(player.GetAll()) do
        local id = ply_num
        local but_player = vgui.Create("DButton", scroll_player)
        but_player:SetSize(RespW(250), RespH(40))
        but_player:SetText(ply:Nick())
        but_player:Dock(TOP)
        but_player:DockMargin(0, 0, 0, 0)
        but_player:SetFont("LinvFontRobo20")
        but_player:SetTextColor(Color(255, 255, 255))
        but_player.Paint = function(self, w, h)
            if data.player == ply then
                if id == 1 then
                    draw.RoundedBoxEx(8, 0, 0, w, h, NGReroll.Config.MenuSelectColor, true, true, false, false)
                else
                    draw.RoundedBox(0, 0, 0, w, h, NGReroll.Config.MenuSelectColor)
                end
            else
                if id == 1 then
                    draw.RoundedBoxEx(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement, true, true, false, false)
                else
                    draw.RoundedBox(0, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
                end
            end
        end
        but_player.DoClick = function()
            if data.player == ply then
                data.player = nil
            else
                data.player = ply
            end
        end
        ply_num = ply_num + 1
    end
    local scroll_value = vgui.Create("DScrollPanel", frame)
    scroll_value:SetSize(RespW(215), RespH(215))
    scroll_value:SetPos(RespW(555), RespH(90))
    local function ValueRebuild()
        if NGReroll.Config.AdminDefaultValue[data.action] then
            local value_num = 1
            for k, v in pairs(NGReroll.Config.AdminDefaultValue[data.action]) do
                local id = value_num
                local but_value = vgui.Create("DButton", scroll_value)
                but_value:SetSize(RespW(215), RespH(40))
                but_value:SetText(tostring(v))
                but_value:Dock(TOP)
                but_value:DockMargin(0, 0, 0, 0)
                but_value:SetFont("LinvFontRobo20")
                but_value:SetTextColor(Color(255, 255, 255))
                but_value.Paint = function(self, w, h)
                    if data.value == v then
                        if id == 1 then
                            draw.RoundedBoxEx(8, 0, 0, w, h, NGReroll.Config.MenuSelectColor, true, true, false, false)
                        else
                            draw.RoundedBox(0, 0, 0, w, h, NGReroll.Config.MenuSelectColor)
                        end
                    else
                        if id == 1 then
                            draw.RoundedBoxEx(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement, true, true, false, false)
                        else
                            draw.RoundedBox(0, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
                        end
                    end
                end
                but_value.DoClick = function()
                    if data.value == v then
                        data.value = nil
                    else
                        data.value = v
                    end
                end
                value_num = value_num + 1
            end
        else
            local but_value = vgui.Create("DButton", scroll_value)
            but_value:SetSize(RespW(215), RespH(40))
            but_value:SetText("Aucune Valeur")
            but_value:Dock(TOP)
            but_value:DockMargin(0, 0, 0, 0)
            but_value:SetFont("LinvFontRobo20")
            but_value:SetTextColor(Color(255, 255, 255))
            but_value.Paint = function(self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
            end
        end
    end
    ValueRebuild()
    local scroll_action = vgui.Create("DScrollPanel", frame)
    scroll_action:SetSize(RespW(215), RespH(480))
    scroll_action:SetPos(RespW(310), RespH(90))
    local action_num = 1
    for k, v in pairs(actions) do
        data.action = nil
        local id = action_num
        if v.actif == false then continue end
        local but_action = vgui.Create("DButton", scroll_action)
        but_action:SetSize(RespW(215), RespH(40))
        but_action:SetText(NGReroll.Config.AdminActions[v].name)
        but_action:Dock(TOP)
        but_action:DockMargin(0, 0, 0, 0)
        but_action:SetFont("LinvFontRobo20")
        but_action:SetTextColor(Color(255, 255, 255))
        but_action.Paint = function(self, w, h)
            if data.action == v then
                if id == 1 then
                    draw.RoundedBoxEx(8, 0, 0, w, h, NGReroll.Config.MenuSelectColor, true, true, false, false)
                else
                    draw.RoundedBox(0, 0, 0, w, h, NGReroll.Config.MenuSelectColor)
                end
            else
                if id == 1 then
                    draw.RoundedBoxEx(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement, true, true, false, false)
                else
                    draw.RoundedBox(0, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
                end
            end
        end
        but_action.DoClick = function()
            if data.action == v then
                data.action = nil
            else
                data.action = v
                scroll_value:Clear()
                ValueRebuild()
            end
        end
        action_num = action_num + 1
    end
    local but_close = vgui.Create("DButton", frame)
    but_close:SetSize(RespW(215), RespH(40))
    but_close:SetPos(RespW(555), RespH(530))
    but_close:SetText("Fermer")
    but_close:SetFont("LinvFontRobo20")
    but_close:SetTextColor(Color(255, 255, 255))
    but_close.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_close.DoClick = function()
        frame:Close()
    end
    LinvLib.Hover(but_close, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    local dt_custom = vgui.Create("DTextEntry", frame)
    dt_custom:SetSize(RespW(215), RespH(40))
    dt_custom:SetPos(RespW(555), RespH(365))
    dt_custom:SetFont("LinvFontRobo20")
    dt_custom:SetTextColor(Color(255, 255, 255))
    dt_custom.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
        self:DrawTextEntryText(Color(255, 255, 255), Color(88, 88, 88), Color(255, 255, 255))
    end
    local but_aply = vgui.Create("DButton", frame)
    but_aply:SetSize(RespW(215), RespH(40))
    but_aply:SetPos(RespW(555), RespH(475))
    but_aply:SetText("Appliquer")
    but_aply:SetFont("LinvFontRobo20")
    but_aply:SetTextColor(Color(255, 255, 255))
    but_aply.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_aply.DoClick = function()
        if dt_custom:GetText() != "" then
            data.value = tonumber(dt_custom:GetText())
        end
        if data.action == nil || data.player == nil then
            Notif("Veuillez remplir tous les champs")
            return
        else
            if NGReroll.Config.AdminDefaultValue[data.action] && data.action == nil then
                Notif("Veuillez remplir tous les champs")
                return
            else
                net.Start("NGReroll")
                    net.WriteString("admin")
                    net.WriteString(util.TableToJSON(data))
                    net.WriteEntity(data.player)
                net.SendToServer()
                frame:Close()
            end
        end
    end
    LinvLib.Hover(but_aply, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    AddLogo(frame)
end

local function RerollMenu(data)
    local frame = vgui.Create("DFrame")
    frame:SetSize(RespW(800), RespH(370))
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(16, 0, 0, w, h, NGReroll.Config.MenuBackColor)
        draw.SimpleText("New Gen Reroll", "LinvFontRobo30", RespW(w/2), RespH(30), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Informations", "LinvFontRobo25", RespW(152), RespH(75), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Techniques de Level", "LinvFontRobo25", RespW(412), RespH(75), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Actions Dangereuse", "LinvFontRobo25", RespW(660), RespH(75), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Actions", "LinvFontRobo25", RespW(660), RespH(230), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(8, RespW(30), RespH(90), RespW(235), RespH(250), NGReroll.Config.MenuBackColorElement)
        draw.RoundedBox(8, RespW(295), RespH(90), RespW(235), RespH(250), NGReroll.Config.MenuBackColorElement)
        draw.SimpleText("Nom : " .. data[1].name, "LinvFontRobo20", RespW(140), RespH(110), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Mana : " .. data[1].mana, "LinvFontRobo20", RespW(140), RespH(150), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if NGReroll.Config.ManaGive[data[1].group] then
            draw.SimpleText("Boost Mana : Actif " .. NGReroll.Config.ManaGive[data[1].group] .. "x", "LinvFontRobo20", RespW(140), RespH(190), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Boost Mana : Non Actif", "LinvFontRobo20", RespW(140), RespH(190), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        draw.SimpleText("Nature : " .. NGReroll.Config.Nature[data[1].nature].name, "LinvFontRobo20", RespW(140), RespH(230), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Reroll : " .. data[1].reroll, "LinvFontRobo20", RespW(140), RespH(270), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Level : " .. data[1].level, "LinvFontRobo20", RespW(140), RespH(310), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        DisableClipping(true)
    end
    local scroll_wep = vgui.Create("DScrollPanel", frame)
    scroll_wep:SetSize(RespW(235), RespH(250))
    scroll_wep:SetPos(RespW(295), RespH(90))
    if data[1].level == 0 then
        local lab_wep = vgui.Create("DLabel", scroll_wep)
        lab_wep:SetSize(RespW(235), RespH(40))
        lab_wep:SetText("Aucune")
        lab_wep:SetFont("LinvFontRobo20")
        lab_wep:Dock(TOP)
        lab_wep:DockMargin(0, 0, 0, 0)
        lab_wep:SetTextColor(Color(255, 255, 255))
        lab_wep:SetContentAlignment(5)
        lab_wep.Paint = function(self, w, h) return end
    else
        for k, v in pairs(NGReroll.Config.Nature[data[1].nature].level[data[1].level].weapons) do
            local lab_wep = vgui.Create("DLabel", scroll_wep)
            lab_wep:SetSize(RespW(235), RespH(40))
            lab_wep:SetText(NGReroll.Config.Weapons[k] || k)
            lab_wep:SetFont("LinvFontRobo20")
            lab_wep:Dock(TOP)
            lab_wep:DockMargin(0, 0, 0, 0)
            lab_wep:SetTextColor(Color(255, 255, 255))
            lab_wep:SetContentAlignment(5)
            lab_wep.Paint = function(self, w, h) return end
        end
    end
    local but_reroll = vgui.Create("DButton", frame)
    but_reroll:SetSize(RespW(215), RespH(40))
    but_reroll:SetPos(RespW(555), RespH(90))
    but_reroll:SetText("Utulise un Reroll")
    but_reroll:SetFont("LinvFontRobo20")
    but_reroll:SetTextColor(Color(255, 255, 255))
    but_reroll.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_reroll.DoClick = function()
        if data[1].player_steamid64 != LocalPlayer():SteamID64() then
            Notif("Vous n'êtes pas le propriétaire de ce personnage !")
            return
        else
            frame:Close()
            if ConfirmMenu("Êtes vous sur de vouloir utiliser un reroll ?") then
                net.Start("NGReroll")
                    net.WriteString("reroll")
                net.SendToServer()
            end
        end
    end
    LinvLib.Hover(but_reroll, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    local but_rpk = vgui.Create("DButton", frame)
    but_rpk:SetSize(RespW(215), RespH(40))
    but_rpk:SetPos(RespW(555), RespH(145))
    but_rpk:SetText("Role Play Kill")
    but_rpk:SetFont("LinvFontRobo20")
    but_rpk:SetTextColor(Color(255, 255, 255))
    but_rpk.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_rpk.DoClick = function()
        print(data[1].steamid)
        if data[1].player_steamid64 != LocalPlayer():SteamID64() then
            Notif("Vous n'êtes pas le propriétaire de ce personnage !")
            return
        else
            frame:Close()
            if ConfirmMenu("Êtes vous sur de vouloir tuer ce personnage ?") then
                net.Start("NGReroll")
                    net.WriteString("rpk")
                net.SendToServer()
            end
        end
    end
    LinvLib.Hover(but_rpk, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    local but_info = vgui.Create("DButton", frame)
    but_info:SetSize(RespW(215), RespH(40))
    but_info:SetPos(RespW(555), RespH(246))
    but_info:SetText("Panel d’Informations")
    but_info:SetFont("LinvFontRobo20")
    but_info:SetTextColor(Color(255, 255, 255))
    but_info.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_info.DoClick = function()
        frame:Close()
        InfoMenu()
    end
    LinvLib.Hover(but_info, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    local but_close = vgui.Create("DButton", frame)
    but_close:SetSize(RespW(215), RespH(40))
    but_close:SetPos(RespW(555), RespH(300))
    but_close:SetText("Fermer")
    but_close:SetFont("LinvFontRobo20")
    but_close:SetTextColor(Color(255, 255, 255))
    but_close.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, NGReroll.Config.MenuBackColorElement)
    end
    but_close.DoClick = function()
        frame:Close()
    end
    LinvLib.Hover(but_close, 8, 0, NGReroll.Config.MenuBackColorElement, NGReroll.Config.MenuHoverColor)
    AddLogo(frame)
end

hook.Add("OnPlayerChat", "NGRerollChat", function(ply, text, team, dead)
    if NGReroll.Config.AdminCommands[string.lower(text)] && (ply == LocalPlayer()) && NGReroll.Config.Admin[ply:GetUserGroup()] then
        OpenMenuAdmnin()
    elseif NGReroll.Config.UserCommands[string.lower(text)] && (ply == LocalPlayer()) then
        net.Start("NGReroll")
            net.WriteString("open")
        net.SendToServer()
    end
end)

net.Receive("NGReroll", function(len, ply)
    local id = net.ReadString()
    if id == "notif" then
        local msg = net.ReadString()
        Notif(msg)
    elseif id == "inspect" || id == "open" then
        local data = net.ReadString()
        data = util.JSONToTable(data)
        RerollMenu(data)
    elseif id == "open-npc" then
        local keys = table.GetKeys(NGReroll.Config.UserCommands)
        RunConsoleCommand("say", keys[1])
    end
end)