local cooldown = 0

function NGRUseWep(element, cost)
    if cooldown > CurTime() then return false end
    cooldown = CurTime() + 1
    local mana = element.Owner:GetNWInt("NGMana")
    local mana_max = element.Owner:GetNWInt("NGManaMax")
    if tonumber(mana) < cost then
        // shake player screen
        element.Owner:ScreenFade( SCREENFADE.IN, Color( 51, 172, 202, 20), 0.5, 0 )
        util.ScreenShake(element.Owner:GetPos(), 2, 2, 0.25, 1000)
        return
    end
    mana = math.Clamp(mana - cost, 0, mana_max)
    element.Owner:SetNWInt("NGMana", mana)
    return true
end