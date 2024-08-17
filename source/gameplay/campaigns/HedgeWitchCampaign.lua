
local hedgeWitchWeeks <const> = {
    { name = "Long Roads Ahead...", content = { TheRoad = 3, TheHedgeWitch = 3, TheNight = 3 } },
    { name = "And Longer Nights...", content = { TheNight = 2 } },
    { name = "Under Thunder Clouds...", content = { TheStorm = 4 } },
    { name = "O'er Rolling Hills...", content = {} },
    { name = "Through Forest Thick...", content = { TheForest = 4, TheOmens = 2 } },
    { name = "To Temple Solemn...", content = {} },
    { name = "Where We Will Thrive.", content = { TheTemple = 1 } }
}

Campaigns.HedgeWitch = function (_week, _char)
    local deck = hedgeWitchWeeks[_week] or {}
    
    if math.random(5, 10) < _char.Resources.suspicion then
        deck.content.TheTower = (deck.content.TheTower or 0) + math.floor(_char.Resources.suspicion / 5)
    end

    return deck
end

