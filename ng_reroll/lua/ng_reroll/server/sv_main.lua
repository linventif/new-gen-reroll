// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//             Init Network               //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

util.AddNetworkString("NGReroll")

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            Prime Functions             //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

local function Reroll()
    local nature = table.Random(NGReroll.Config.Nature)
    if math.Rand(1, 100) <= nature.drop then
        return table.KeyFromValue(NGReroll.Config.Nature, nature)
    else
        return Reroll()
    end
end

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//           Init SQL Data Base           //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

sql.Query("CREATE TABLE IF NOT EXISTS ng_reroll (id INTEGER PRIMARY KEY AUTOINCREMENT, steamid64 TEXT, nature TEXT DEFAULT " .. Reroll() .. ", reroll INTEGER DEFAULT " .. NGReroll.Config.RerollDefault .. ", mana INTEGER DEFAULT " .. NGReroll.Config.ManaDefault .. ")")

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//         SQL Data Base Functions        //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

local function CreateData(steamid64)
    sql.Query("INSERT INTO ng_reroll (steamid64, nature) VALUES ('" .. steamid64 .. "', '" .. Reroll() .. "')")
end

local function DeleteData(steamid64)
    sql.Query("DELETE FROM ng_reroll WHERE steamid64 = '" .. steamid64 .. "'")
end

local function EditData(steamid64, column, value)
    sql.Query("UPDATE ng_reroll SET " .. column .. " = '" .. value .. "' WHERE steamid64 = '" .. steamid64 .. "'")
end

local function GetData(steamid64)
    local data = sql.Query("SELECT * FROM ng_reroll WHERE steamid64 = '" .. steamid64 .. "'")
    if !data then
        CreateData(steamid64)
        return GetData(steamid64)
    else
        return data[1]
    end
end

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            Player Functions            //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

local function SaveDataPlayer(ply)
    local data = GetData(ply:SteamID64())
    if !data then return end
    sql.Query("UPDATE ng_reroll SET reroll = " .. ply:GetNWInt("NGReroll") .. ", mana = " .. tonumber(ply:GetNWInt("NGManaMax")) .. ", nature = '" .. ply:GetNWString("NGNature") .. "' WHERE steamid64 = '" .. ply:SteamID64() .. "'")
end

local function CanReroll(ply)
    local data = GetData(ply:SteamID64())
    if !data then return false end
    if tonumber(data.reroll) > 0 then
        return true
    else
        return false
    end
end

local function Notif(ply, text)
    net.Start("NGReroll")
        net.WriteString("notif")
        net.WriteString(text)
    net.Send(ply)
end

local function GetLevel(ply)
    if !NGReroll.Config.Nature[ply:GetNWString("NGNature")] then return 0 end
    local mana = tonumber(ply:GetNWInt("NGMana"))
    for k, v in pairs(NGReroll.Config.Nature[ply:GetNWString("NGNature")].level) do
        if mana >= v.mana_min && mana <= v.mana_max then
            return k
        end
    end
    return 0
end

local function EditMana(ply, amount)
    local modificator = tonumber(amount)
    local mana = tonumber(ply:GetNWInt("NGMana")) + modificator
    local mana_max = tonumber(ply:GetNWInt("NGManaMax")) + modificator
    if mana < 0 then mana = 0 end
    if mana_max < 0 then mana_max = 0 end
    ply:SetNWInt("NGMana", mana)
    ply:SetNWInt("NGManaMax", mana_max)
    EditData(ply:SteamID64(), "mana", mana_max)
end

local function SetMana(ply, amount)
    local modificator = tonumber(amount)
    local mana = modificator
    if mana < 0 then mana = 0 end
    ply:SetNWInt("NGMana", mana)
    ply:SetNWInt("NGManaMax", mana)
    EditData(ply:SteamID64(), "mana", mana)
end

local function EditReroll(ply, amount)
    local modificator = tonumber(amount)
    local reroll = ply:GetNWInt("NGReroll") + modificator
    if reroll < 0 then reroll = 0 end
    ply:SetNWInt("NGReroll", reroll)
    EditData(ply:SteamID64(), "reroll", reroll)
end

local function SetReroll(ply, amount)
    local modificator = tonumber(amount)
    local reroll = modificator
    if reroll < 0 then reroll = 0 end
    ply:SetNWInt("NGReroll", reroll)
    EditData(ply:SteamID64(), "reroll", reroll)
end

local function SetNature(ply, nature)
    if !NGReroll.Config.Nature[nature] then return end
    ply:SetNWString("NGNature", nature)
    EditData(ply:SteamID64(), "nature", nature)
end

local function InitData(ply)
    local data = GetData(ply:SteamID64())
    if !data then
        CreateData(ply:SteamID64())
        InitData(ply)
        return
    end
    if !NGReroll.Config.Nature[data.nature] then
        EditData(ply:SteamID64(), "nature", Reroll())
        InitData(ply)
        return
    end
    ply:SetNWInt("NGReroll", tonumber(data.reroll))
    ply:SetNWInt("NGMana", tonumber(data.mana))
    ply:SetNWInt("NGManaMax", tonumber(data.mana))
    ply:SetNWString("NGNature", data.nature)
end

local function PlySpawn(ply)
    local nature = ply:GetNWString("NGNature")
    local mana_max = tonumber(ply:GetNWInt("NGManaMax"))
    ply:SetNWInt("NGMana", mana_max)
    local weps = NGReroll.Config.Nature[nature].level[GetLevel(ply)].weapons
    if weps then
        for k, v in pairs(weps) do
            ply:Give(k)
        end
    end
end

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            Optional Function           //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

if NGReroll.Config.ManaGiveDelay > 0 then
    timer.Create("NGRerollGiveMana", NGReroll.Config.ManaGiveDelay, 0, function()
        for _, ply in pairs(player.GetAll()) do
            local mana_sup = NGReroll.Config.ManaGive[ply:GetUserGroup()] or NGReroll.Config.ManaGive["user"] or 0
            ply:SetNWInt("NGMana", tonumber(ply:GetNWInt("NGMana")) + mana_sup)
            ply:SetNWInt("NGManaMax", tonumber(ply:GetNWInt("NGManaMax")) + mana_sup)
            ply:ChatPrint("Votre limite de mana max a augmenté de " .. mana_sup .. ".")
            SaveDataPlayer(ply)
        end
    end)
end

if NGReroll.Config.ManaRegenDelay > 0 then
    timer.Create("NGRerollRegenMana", NGReroll.Config.ManaRegenDelay, 0, function()
        for _, ply in pairs(player.GetAll()) do
            local mana = tonumber(tonumber(ply:GetNWInt("NGMana")))
            local mana_max = tonumber(tonumber(ply:GetNWInt("NGManaMax")))
            if mana < mana_max then
                local new_man1 = math.Round(mana_max * ((NGReroll.Config.ManaRegen[ply:GetUserGroup()] || NGReroll.Config.ManaRegenDefault) / 100))
                local new_man2 = mana + new_man1
                if new_man2 > new_man2 then new_man2 = mana_max end
                ply:SetNWInt("NGMana", new_man2)
            end
        end
    end)
end

if NGReroll.Config.ManaGiveKill > 0 then
    hook.Add("OnNPCKilled", "PlayerKillCounter", function (victim, killer, weapon)
        if !IsValid(killer) || !killer:IsPlayer() then return end
        killer:SetNWInt("NGMana", killer:GetNWInt("NGMana") + NGReroll.Config.ManaGiveKill)
        killer:SetNWInt("NGManaMax", killer:GetNWInt("NGManaMax") + NGReroll.Config.ManaGiveKill)
        killer:ChatPrint("Votre limite de mana a augmenté de " .. NGReroll.Config.ManaGiveKill .. ".")
    end)
end

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//                Hooks                   //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

hook.Add("PlayerInitialSpawn", "NGReroll:PlayerInitialSpawn", function(ply)
    InitData(ply)
end)

hook.Add("PlayerLoadout", "NGReroll:PlayerLoadout", function(ply)
    PlySpawn(ply)
end)

hook.Add("PlayerDisconnected", "NGReroll:Disconect", function(ply)
    SaveDataPlayer(ply)
end)

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//             Commands Server            //
//          No Admin Verification         //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

concommand.Add("ngr_drop_db", function(ply, cmd, args)
    sql.Query("DROP TABLE ng_reroll")
    print("La base de données a été supprimée.")
end)

concommand.Add("ngr_create_db", function(ply, cmd, args)
    sql.Query("CREATE TABLE ng_reroll (id INTEGER PRIMARY KEY AUTOINCREMENT, steamid64 TEXT, nature TEXT DEFAULT " .. Reroll() .. ", reroll INTEGER DEFAULT " .. NGReroll.Config.RerollDefault .. ", mana INTEGER DEFAULT " .. NGReroll.Config.ManaDefault .. ")")
    print("La base de données a été créée.")
end)

concommand.Add("ngr_show_db", function(ply, cmd, args)
    local data = sql.Query("SELECT * FROM ng_reroll")
    if data then
        PrintTable(data)
    else
        print("La base de données est vide.")
    end
end)


concommand.Add("ngr_set_mana", function(ply, cmd, args)
    EditData(args[1], "mana", args[2])
end)

concommand.Add("ngr_set_reroll", function(ply, cmd, args)
    EditData(args[1], "reroll", args[2])
end)

concommand.Add("ngr_set_nature", function(ply, cmd, args)
    EditData(args[1], "nature", args[2])
end)

concommand.Add("ngr_delete_data", function(ply, cmd, args)
    sql.Query("DELETE FROM ng_reroll WHERE steamid64 = '" .. args[1] .. "'")
end)

concommand.Add("ngr_inspect_data", function(ply, cmd, args)
    local data = GetData(args[1])
    PrintTable(data)
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
                local data = GetData(target_ply:SteamID64())
                if data then
                    data.level = GetLevel(target_ply)
                    data.name = target_ply:Nick()
                    data.group = target_ply:GetUserGroup()
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
        local data = GetData(ply:SteamID64())
        if data && CanReroll(ply) then
            EditData(ply:SteamID64(), "reroll", data.reroll - 1)
            local nature = Reroll()
            EditData(ply:SteamID64(), "nature", nature)
            ply:SetNWString("NGNature", nature)
            Notif(ply, "Vous avez reroll votre nature.")
        else
            Notif(ply, "Vous n'avez pas de reroll.")
        end
--  elseif id == "krp" then
--      DeleteData(ply:SteamID64())
--      CreateData(ply:SteamID64())
--      InitData(ply)
--      Notif(ply, "Vos donner on été réinitialisé.")
    elseif id == "open" then
        local data = GetData(ply:SteamID64())
        if data then
            data.level = GetLevel(ply)
            data.name = ply:Nick()
            data.group = ply:GetUserGroup()
            net.Start("NGReroll")
                net.WriteString("open")
                net.WriteString(util.TableToJSON(data))
            net.Send(ply)
        else
            Notif(ply, "Le joueur " .. ply:Nick() .. " n'existe pas dans la base de données.")
        end
    end
end)
