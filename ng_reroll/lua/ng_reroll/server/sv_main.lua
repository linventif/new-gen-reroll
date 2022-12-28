// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//          Init Network and SQL          //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //
util.AddNetworkString("NGReroll")
//  sql.Query("DROP TABLE ng_reroll")
sql.Query("CREATE TABLE IF NOT EXISTS ng_reroll (id INTEGER PRIMARY KEY AUTOINCREMENT, player_steamid64 TEXT, nature TEXT DEFAULT 'none', reroll INTEGER DEFAULT " .. NGReroll.Config.RerollDefault .. ", mana INTEGER DEFAULT " .. NGReroll.Config.ManaDefault .. ")")



// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//               Functions                //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

local function Reroll(ply)
    local nature = table.Random(NGReroll.Config.Nature)
    if math.Rand(1, 100) <= nature.drop then
        return table.KeyFromValue(NGReroll.Config.Nature, nature)
    else
        return Reroll(ply)
    end
end

local function CanReroll(ply)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
    if !data then return true end
    if data[1].reroll > 0 then return true end
    return false
end

local function EditMana(ply, amount)
    local mana = ply:GetNWInt("NGMana") + amount
    local mana_max = ply:GetNWInt("NGManaMax") + amount
    if mana < 0 then mana = 0 end
    if mana_max < 0 then mana_max = 0 end
    ply:SetNWInt("NGMana", mana)
    ply:SetNWInt("NGManaMax", mana_max)
    sql.Query("UPDATE ng_reroll SET mana = " .. mana_max .. " WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
end

local function SetMana(ply, amount)
    local mana = amount
    if mana < 0 then mana = 0 end
    ply:SetNWInt("NGMana", mana)
    ply:SetNWInt("NGManaMax", mana)
    sql.Query("UPDATE ng_reroll SET mana = " .. mana .. " WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
end

local function EditReroll(ply, amount)
    local reroll = ply:GetNWInt("NGReroll") + amount
    if reroll < 0 then reroll = 0 end
    ply:SetNWInt("NGReroll", reroll)
    sql.Query("UPDATE ng_reroll SET reroll = " .. reroll .. " WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
end

local function SetReroll(ply, amount)
    local reroll = amount
    if reroll < 0 then reroll = 0 end
    ply:SetNWInt("NGReroll", reroll)
    sql.Query("UPDATE ng_reroll SET reroll = " .. amount .. " WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
end

local function SetNature(ply, nature)
    ply:SetNWString("NGNature", nature)
    sql.Query("UPDATE ng_reroll SET nature = '" .. nature .. "' WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
end

local function CreateData(steamid)
    sql.Query("INSERT INTO ng_reroll (player_steamid64) VALUES ('" .. steamid .. "')")
end

local function DeleteData(steamid)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. steamid .. "'")
    if !data then return end
    sql.Query("DELETE FROM ng_reroll WHERE player_steamid64 = '" .. steamid .. "'")
end

local function SaveData(ply)
    sql.Query("UPDATE ng_reroll SET reroll = " .. ply:GetNWInt("NGReroll") .. ", mana = " .. ply:GetNWInt("NGManaMax") .. ", nature = '" .. ply:GetNWString("NGNature") .. "' WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
end

local function GetLevel(ply)
    local mana = ply:GetNWInt("NGMana")
    mana = tonumber(mana)
    local nature = ply:GetNWString("NGNature")
    for k, v in pairs(NGReroll.Config.Nature[nature].level) do
        if mana >= v.mana_min && mana <= v.mana_max then
            return k
        end
    end
    return 0
end

local function InitData(ply)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
    if !data then
        CreateData(ply:SteamID64())
        InitData(ply)
    else
        ply:SetNWInt("NGReroll", data[1].reroll)
        ply:SetNWInt("NGMana", data[1].mana)
        ply:SetNWInt("NGManaMax", data[1].mana)
        ply:SetNWString("NGNature", data[1].nature)
        if data[1].nature == "none" then
            SetNature(ply, Reroll(ply))
        end
        if !NGReroll.Config.Nature[nature] then
            SetNature(ply, Reroll(ply))
        else
            for k, v in pairs(NGReroll.Config.Nature[nature].level[GetLevel(ply)].weapons) do
                ply:Give(k)
            end
        end
    end
end

local function Notif(ply, text)
    net.Start("NGReroll")
        net.WriteString("notif")
        net.WriteString(text)
    net.Send(ply)
end

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//              Functionality             //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

if NGReroll.Config.ManaGiveDelay > 0 then
    timer.Create("NGRerollGiveMana", NGReroll.Config.ManaGiveDelay, 0, function()
        for _, ply in pairs(player.GetAll()) do
            local mana_sup = NGReroll.Config.ManaGive[ply:GetUserGroup()]
            ply:SetNWInt("NGMana", ply:GetNWInt("NGMana") + mana_sup)
            ply:SetNWInt("NGManaMax", ply:GetNWInt("NGManaMax") + mana_sup)
            ply:ChatPrint("Votre limite de mana a augmenté de " .. mana_sup .. ".")
        end
    end)
end

if NGReroll.Config.ManaRegenDelay > 0 then
    timer.Create("NGRerollRegenMana", NGReroll.Config.ManaRegenDelay, 0, function()
        for _, ply in pairs(player.GetAll()) do
            local mana = ply:GetNWInt("NGMana")
            local mana_max = ply:GetNWInt("NGManaMax")
            if mana < mana_max then
                local new_man = mana + NGReroll.Config.ManaRegen[ply:GetUserGroup()]
                if new_man > mana_max then new_man = mana_max end
                ply:SetNWInt("NGMana", new_man)
            end
        end
    end)
end

if NGReroll.Config.ManaGiveKill > 0 then
    hook.Add("OnNPCKilled", "PlayerKillCounter", function (victim, killer, weapon)
        if !IsValid(killer) || !killer:IsPlayer() then return end
        killer:SetNWInt("NGMana", killer:GetNWInt("NGMana") + NGReroll.Config.ManaGiveKill)
        killer:SetNWInt("NGManaMax", killer:GetNWInt("NGManaMax") + NGReroll.Config.ManaGiveKill)
        sql.Query("UPDATE ng_reroll SET mana = " .. killer:GetNWInt("NGMana") .. " WHERE player_steamid64 = '" .. killer:SteamID64() .. "'")
        killer:ChatPrint("Votre limite de mana a augmenté de " .. NGReroll.Config.ManaGiveKill .. ".")
    end)
end

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//                Hooks                   //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

hook.Add("PlayerInitialSpawn", "NGReroll", function(ply)
    InitData(ply)
end)

hook.Add("PlayerSpawn", "NGReroll:PlayerSpawn", function(ply)
    InitData(ply)
end)

hook.Add("PlayerDisconnected", "NGReroll", function(ply)
    SaveData(ply)
end)

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//             Commands Server            //
//          No Admin Verification         //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

concommand.Add("ngr_edit_mana", function(ply, cmd, args)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. args[1] .. "'")
    if !data then
        sql.Query("INSERT INTO ng_reroll (player_steamid64, mana) VALUES ('" .. args[1] .. "', " .. args[2] .. ")")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " mana.")
    else
        sql.Query("UPDATE ng_reroll SET mana = " .. args[2] .. " WHERE player_steamid64 = '" .. args[1] .. "'")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " mana.")
    end
end)

concommand.Add("ngr_set_mana", function(ply, cmd, args)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. args[1] .. "'")
    if !data then
        sql.Query("INSERT INTO ng_reroll (player_steamid64, mana) VALUES ('" .. args[1] .. "', " .. args[2] .. ")")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " mana.")
    else
        sql.Query("UPDATE ng_reroll SET mana = " .. args[2] .. " WHERE player_steamid64 = '" .. args[1] .. "'")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " mana.")
    end
end)

concommand.Add("ngr_edit_reroll", function(ply, cmd, args)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. args[1] .. "'")
    if !data then
        sql.Query("INSERT INTO ng_reroll (player_steamid64, reroll) VALUES ('" .. args[1] .. "', " .. args[2] .. ")")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " reroll.")
    else
        sql.Query("UPDATE ng_reroll SET reroll = " .. args[2] .. " WHERE player_steamid64 = '" .. args[1] .. "'")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " reroll.")
    end
end)

concommand.Add("ngr_set_reroll", function(ply, cmd, args)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. args[1] .. "'")
    if !data then
        sql.Query("INSERT INTO ng_reroll (player_steamid64, reroll) VALUES ('" .. args[1] .. "', " .. args[2] .. ")")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " reroll.")
    else
        sql.Query("UPDATE ng_reroll SET reroll = " .. args[2] .. " WHERE player_steamid64 = '" .. args[1] .. "'")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " reroll.")
    end
end)

concommand.Add("ngr_set_nature", function(ply, cmd, args)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. args[1] .. "'")
    if !data then
        sql.Query("INSERT INTO ng_reroll (player_steamid64, nature) VALUES ('" .. args[1] .. "', '" .. args[2] .. "')")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " nature.")
    else
        sql.Query("UPDATE ng_reroll SET nature = '" .. args[2] .. "' WHERE player_steamid64 = '" .. args[1] .. "'")
        print("Le joueur " .. args[1] .. " a été mis à " .. args[2] .. " nature.")
    end
end)

concommand.Add("delete_data", function(ply, cmd, args)
    DeleteData(args[1])
    CreateData(args[1])
    local ply_target = player.GetBySteamID64(args[1])
    if ply_target && ply_target:IsValid() && ply_target:IsPlayer() then
        InitData(ply_target)
    end
    print("Le joueur " .. args[1] .. " a été réinitialisé.")
end)

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//                Network                 //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

net.Receive("NGReroll", function(len, ply, len)
    local id = net.ReadString()
    if id == "admin" then
        if NGReroll.Config.Admin[ply:GetUserGroup()] then
            local data = util.JSONToTable(net.ReadString())
            local target_ply = net.ReadEntity()
            if data.action == "edit_mana" then
                EditMana(target_ply, data.value)
                Notif(ply, "Le joueur " .. target_ply:Nick() .. " a été mis à " .. data.value .. " mana.")
            elseif data.action == "set_mana" then
                SetMana(target_ply, data.value)
                Notif(ply, "Le joueur " .. target_ply:Nick() .. " a été mis à " .. data.value .. " mana.")
            elseif data.action == "edit_reroll" then
                EditReroll(target_ply, data.value)
                Notif(ply, "Le joueur " .. target_ply:Nick() .. " a été mis à " .. data.value .. " reroll.")
            elseif data.action == "set_reroll" then
                SetReroll(target_ply, data.value)
                Notif(ply, "Le joueur " .. target_ply:Nick() .. " a été mis à " .. data.value .. " reroll.")
            elseif data.action == "set_nature" then
                SetNature(target_ply, data.value)
                Notif(ply, "Le joueur " .. target_ply:Nick() .. " a été mis à " .. data.value .. " nature.")
            elseif data.action == "inspect" then
                local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. target_ply:SteamID64() .. "'")
                if data then
                    data[1].level = GetLevel(target_ply)
                    data[1].name = target_ply:Nick()
                    data[1].group = target_ply:GetUserGroup()
                    net.Start("NGReroll")
                        net.WriteString("inspect")
                        net.WriteString(util.TableToJSON(data))
                    net.Send(ply)
                else
                    Notif(ply, "Le joueur " .. target_ply:Nick() .. " n'existe pas dans la base de données.")
                end
            elseif data.action == "delete_data" then
                DeleteData(target_ply:SteamID64())
                CreateData(target_ply:SteamID64())
                Notif(ply, "Le joueur " .. target_ply:Nick() .. " a été supprimé puis recréé dans la base de données.")
                if target_ply && target_ply:IsValid() && target_ply:IsPlayer() then
                    InitData(target_ply)
                end
            end
        end
    elseif id == "reroll" then
        local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
        if data then
            if tonumber(data[1].reroll) > 0 then
                local nature = Reroll(ply)
                sql.Query("UPDATE ng_reroll SET nature = '" .. nature .. "' WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
                ply:SetNWString("NGNature", nature)
                sql.Query("UPDATE ng_reroll SET reroll = " .. tonumber(data[1].reroll) - 1 .. " WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
                Notif(ply, "Vous avez reroll votre nature.")
            else
                Notif(ply, "Vous n'avez plus de reroll.")
            end
        else
            Notif(ply, "Vous n'avez pas de reroll.")
        end
    -- elseif id == "krp" then
    --     DeleteData(ply:SteamID64())
    --     CreateData(ply:SteamID64())
    --     InitData(ply)
    --     Notif(ply, "Vos donner on été réinitialisé.")
    elseif id == "open" then
        local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
        if data then
            data[1].level = GetLevel(ply)
            data[1].name = ply:Nick()
            data[1].group = ply:GetUserGroup()
            net.Start("NGReroll")
                net.WriteString("open")
                net.WriteString(util.TableToJSON(data))
            net.Send(ply)
        else
            Notif(ply, "Le joueur " .. ply:Nick() .. " n'existe pas dans la base de données.")
        end
    end
end)

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//                 Debug                  //
//     Don't touch if you don't know.     //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

local in_debug = false

if in_debug then
    for _, ply in pairs(player.GetAll()) do
    //  local nature = Reroll(ply)
    //  sql.Query("UPDATE ng_reroll SET nature = '" .. nature .. "' WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
    //  ply:SetNWString("NGNature", nature)
    //  local data = sql.Query("SELECT * FROM ng_reroll WHERE player_steamid64 = '" .. ply:SteamID64() .. "'")
        local nature = ply:GetNWString("NGNature")
        if !NGReroll.Config.Nature[nature] then return end
        for k, v in pairs(NGReroll.Config.Nature[nature].level[GetLevel(ply)].weapons) do
            ply:Give(k)
            ply:ChatPrint("Arme de rang " .. GetLevel(ply) .. " reçue.")
        end
    end
end