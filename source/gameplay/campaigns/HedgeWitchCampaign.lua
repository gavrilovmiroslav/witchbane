
local hedgeWitchWeeks <const> = {
    { name = "Long Roads Ahead...", content = { TheRoad = 4 } },
    { name = "And Longer Nights...", content = { TheHedgeWitch = 3, TheNight = 3 } },
    { name = "Under Thunder Clouds...", content = { TheStorm = 2, TheNight = 1 } },
    { name = "O'er Rolling Hills...", content = { TheHedgeWitch = 2, TheRoad = 1 } },
    { name = "Through Forest Thick...", content = { TheForest = 3 } },
    { name = "To Temple Solemn...", content = { TheForest = 3, TheRoad = 1 } },
    { name = "Where We Will Thrive.", content = { TheTemple = 1 } }
}

Campaigns.HedgeWitch = function (_week, _char)
    local deck = hedgeWitchWeeks[_week]

    local wealth = _char.Resources.affluence + _char.Resources.artifacts * 2
    if wealth > 10 then
        deck.content.TheOmens = math.floor(wealth / 10)
    end

    if _week > 3 and _char.Resources.coven == 0 then
        deck.content.TheRoad = math.random(1, 3)
        deck.content.TheForest = 5 - deck.content.TheRoad
    end

    if math.random(5, 10) < _char.Resources.suspicion then
        deck.content.TheTower = math.floor(_char.Resources.suspicion / 5)
    end

    return deck
end

