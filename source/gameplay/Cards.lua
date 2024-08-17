
Titles = {}
CardBacks = {}

Packs = {}

Uncards = {}

Cards = {
    AFriendlyFaceOnTheRoad = {
        name = "A Friendly Face on the Road",
        portrait = 2,
        deck = "TheRoad",
        options = {
            {
                name = "They can share of our food.",
                effect = { affluence = -1, suspicion = -1 },
                skip = 2
            },
            {
                name = "They can peruse our tinctures.",
                effect = { herbs = -1, suspicion = -1 },
                skip = 2
            },
            {
                name = "A friendly smile can't hurt.",
                effect = {},
                skip = 1
            }
        }
    },

    BanditsInTheNight = {
        name = "Bandits In the Night!",
        deck = "TheNight",
        portrait = 1,
        options = {
            {
                name = "Give Them Your Materials!",
                effect = { herbs = function(h) return -h end },
                skip = 2
            },
            {
                name = "Give Them Your Riches!",
                effect = { affluence = function(a) return -a end },
                skip = 2
            },
            {
                name = "Endure.",
                effect = {},
                insert = { TheWound = function(w) return math.random(1, 3) end },
                skip = 3
            },
            {
                name = "Haunt Their Dreams...",
                effect = { familiars = -5 },
                skip = 10,
            }
        }
    },

    Wound1 = {
        name = "A Painful Wound",
        deck = "TheWound",
        oneoff = true,
        options = {
            {
                name = "Ignore It Until It Goes Away",
                effect = {}
            }
        }
    },

    Wound2 = {
        name = "A Throbbing Pain",
        deck = "TheWound",
        oneoff = true,
        options = {
            {
                name = "Massage It Until Sleep Takes You",
                effect = {}
            }
        }
    },

    Wound3 = {
        name = "A Cut That Never Healed Right",
        deck = "TheWound",
        oneoff = true,
        options = {
            {
                name = "Bandage It Yet Again",
                effect = {}
            }
        }
    },
    
    ATreasureToBehold = {
        name = "A Treasure to Behold",
        deck = "TheRoad",
        options = {
            { 
                name = "It goes to the highest bid.",
                effect = { affluence = -5, artifacts = 1 }
            },
            {
                name = "We'll plan a score and come at night.",
                effect = { suspicion = 1 },
                insert = { TheScore = 1 },
                skip = 2
            },
            {
                name = "Let's use our thurgy for devious means.",
                effect = { coven = -2, familiars = -2, artifacts = 2 },
                skip = 1
            }
        }
    },

    TheScoreWithoutAHitch = {
        name = "Smooth Criminal",
        deck = "TheScore",
        oneoff = true,
        options = {
            {
                name = "Easy as pie, the treasure is ours!",
                effect = { artifacts = 1 }
            }
        }
    },

    TheScoreComplications = {
        name = "Complications!",
        deck = "TheScore",
        oneoff = true,
        options = {
            {
                name = "Take the goods and run!",
                effect = { artifacts = 1, suspicion = 2 }
            },
            {
                name = "One of us will slow them down.",
                effect = { artifacts = 1, coven = -1 }
            },
            {
                name = "We'll bribe them to turn away.",
                effect = { artifacts = 1, affluence = -4 }
            }
        }
    },

    TheScoreWeHadToGiveUp = {
        name = "Treasure Safeguarded",
        deck = "TheScore",
        oneoff = true,
        options = {
            {
                name = "There's nothing at all here...",
                effect = {}
            }
        }
    },

    TheCauldronAlight = {
        name = "The Cauldron Alight!",
        deck = "TheRoad",
        options = {
            {
                name = "Lavender, For Nightly Spirits",
                effect = { herbs = -1, familiars = 1 },
                skip = 1
            },
            {
                name = "Rosehips, So We Know no Limits",
                effect = { herbs = -1, coven = 1 },
                skip = 1
            },
            {
                name = "Marigold, for e'er More Visits",
                effect = { herbs = -1, affluence = 1 },
                skip = 1
            },
            {
                name = "Pass It On",
                effect = {},
                skip = 1
            }
        }
    },

    BusyOutpostIsInSight = {
        name = "A Busy Outpost Is In Sight",
        deck = "TheRoad",
        portrait = 15,
        options = {
            {
                name = "Get the Best They've Got",
                effect = { affluence = -4, artifacts = 1 },
                skip = 2
            },
            {
                name = "Get the Seasonal Herbs",
                effect = { affluence = -2, herbs = 1 },
                skip = 2
            },
            {
                name = "Sell the Out of Season Stuff",
                effect = { herbs = -2, affluence = 1 },
                skip = 2
            },
            {
                name = "Wave to Them but Linger Not",
                effect = {},
                skip = 2
            }
        }
    },

    VillageHealerNotAWitch = {
        name = "Our Calling is Helping the Locals",
        deck = "TheRoad",
        options = {
            {
                name = "From Problem to Pocket",
                effect = { affluence = 2 }
            },
            {
                name = "From Pocket to Coven",
                effect = { suspicion = 1, affluence = 1, coven = 1 }
            },
            {
                name = "From Friend to Fearsome",
                effect = { familiars = -1, suspicion = 3, affluence = 5 }
            }
        }
    },

    FairyRingsToGrantUsThings = {
        name = "Fairy Rings To Grant Us Things",
        deck = "TheRoad",
        options = {
            {
                name = "Abundant Herbs To Last the Winter",
                effect = { herbs = 3 },
                skip = 2
            },
            {
                name = "Friendly Ghouls, to Warm the Cinder",
                effect = { familiars = 2 },
                skip = 2
            },
            {
                name = "A Dancing Person, Mind Asplinter",
                effect = { coven = 1 },
                skip = 2
            }
        }
    },

    ABrokenCartOnTheOpenRoad = {
        name = "A Ruined Cart on the Open Road",
        deck = "TheNight",
        options = {
            {
                name = "Renew your Coffers",
                effect = { affluence = 3 },
                skip = 2
            },
            {
                name = "Search for Survivors",
                effect = { affluence = 2, coven = 1 },
                skip = 2
            },
            {
                name = "Do not halt, it may be a Trap",
                effect = {},
                skip = 3
            }
        }
    },

    TheNightGoesOn = {
        name = "The Night Goes On, It's Very Long",
        deck = "TheNight",
        options = {
            {
                name = "Memories of Us Start to Fade",
                effect = { suspicion = function(s) return -s / 2 end },
                skip = 2
            },
            {
                name = "We Count the Coins We've Saved",
                effect = { affluence = 1 },
                skip = 2
            },
            {
                name = "We Dance until the Morning's Made",
                effect = { coven = 1 },
                skip = 2
            }
        }
    },

    ASharpFeverInTheNight = {
        name = "A Sharp Fever in the Night",
        deck = "TheNight",
        options = {
            {
                name = "Take Better Care of Ourselves",
                effect = { herbs = -2 },
                skip = 1
            },
            {
                name = "Put up Iron to Ward the Elves",
                effect = { affluence = -2 },
                skip = 2
            },
            {
                name = "We Can't Afford to Take Measures",
                effect = { coven = function(c) return -c / 2 end }
            }
        }
    },

    AForgottenCave = {
        name = "A Cave Entrance",
        deck = "TheNight",
        options = {
            {
                name = "We Are Tired As Is...",
                effect = {},
                skip = 3
            },
            {
                name = "We'll Ready an Expedition!",
                effect = { coven = -1, affluence = -1, herbs = -1 },
                insert = { TheCave1 = 1 },
                skip = 2
            },
            {
                name = "This Requires Serious Planning.",
                effect = { coven = -3, affluence = -3, herbs = -3 },
                insert = { TheCave1 = 1, TheFind = 2 },
                skip = 2
            }
        }
    },

    WillOfTheAncients = {
        name = "Will of the Ancients",
        deck = "TheFind",
        oneoff = true,
        options = {
            {
                name = "Ghostly Candles Reveal The Runes",
                effect = { herbs = 1, familiars = 3 }
            },
        }
    },
    ForlornBooksOfRites = {
        name = "Forlorn Books of Rites",
        deck = "TheFind",
        oneoff = true,
        options = {
            {
                name = "Take Whatever You Can Carry",
                effect = { affluence = 1, coven = 3 }
            },
            {
                name = "Librarians, Pick Carefully.",
                effect = { coven = -2, affluence = 2, familiars = 4 }
            },
        }
    },
    ArtisanConstructs = {
        name = "Artisan Constructs",
        deck = "TheFind",
        oneoff = true,
        options = {
            {
                name = "Take The Smaller Ones",
                effect = { artifacts = 1 }
            },
            {
                name = "Disassemble the Monolith",
                effect = { artifacts = 3, suspicion = 3 }
            },
        }
    },
    AFewTreasureChests = {
        name = "A Few Treasure Chests!",
        deck = "TheFind",
        oneoff = true,
        options = {
            {
                name = "A Small Room In the Deep",
                effect = { affluence = 2 }
            },
            {
                name = "A Large Room Behind The Illusion",
                effect = { affluence = 5, familiars = -3 }
            },
        }
    },
    NecropolisUntouched = {
        name = "Necropolis Untouched!",
        deck = "TheFind",
        oneoff = true,
        options = {
            {
                name = "Leave It To Braver People",
                effect = { affluence = 1, familiars = 1, coven = 1 }
            },
            {
                name = "Knives Out. The Ritual Commences",
                effect = { coven = -7, familiars = -3, herbs = -1 },
                insert = { TheRitual = 1 }
            },
        }
    },
    SubterraneanRiver = {
        name = "Squeeze By a Subterranean River",
        deck = "TheCave1",
        oneoff = true,
        options = {
            {
                name = "Watch the Water, Be Careful",
                effect = { coven = -1 },
                insert = { TheCave2 = 1 }
            },
            {
                name = "Let Us Retreat",
                effect = {}
            },
        }
    },
    LimestonePassage = {
        name = "A Damp Limestone Passage",
        deck = "TheCave1",
        oneoff = true,
        options = {
            {
                name = "Search for Runes, Split the Party",
                effect = { coven = -2 },
                insert = { TheCave2 = 2 }
            },
            {
                name = "Let Us Retreat",
                effect = {}
            },
        }
    },
    NarrowChamber = {
        name = "A Very Narrow Chamber",
        deck = "TheCave2",
        oneoff = true,
        options = {
            {
                name = "Leave Some Inventory Behind",
                effect = { affluence = -1, herbs = -1 },
                insert = { TheCave3 = 1 }
            },
            {
                name = "Let Us Retreat",
                effect = {},
                insert = { TheCave1 = 1 }
            },
        }
    },
    UnderwaterLake = {
        name = "A Calm, Pristine Lake",
        deck = "TheCave3",
        oneoff = true,
        options = {
            {
                name = "Dive Below, Leave the Others",
                effect = { affluence = -1, herbs = -1, coven = -2 },
                insert = { TheCave4 = 1 }
            },
            {
                name = "Let Us Retreat",
                effect = {},
                insert = { TheCave1 = 1 }
            },
        }
    },
    DomeOfTheWitch = {
        name = "Dome of the Witch Azala",
        deck = "TheCave4",
        oneoff = true,
        options = {
            {
                name = "Share Her Forever-Dream",
                effect = { familiars = 10, herbs = 10, artifacts = 3 },
                insert = { RedDream1 = 1 }
            },
            {
                name = "Let Us Retreat",
                effect = {}
            },
        }
    },

    -- the omens
    ProfoundDreams = {
        name = "Profound Dreams",
        deck = "TheOmens",
        oneoff = true,
        options = {
            {
                name = "An Urge Pulls Me Somewhere",
                effect = { artifacts = 1 }
            },
            {
                name = "Next Tuesday Will Be Good To Us",
                effect = {},
                insert = { TheFind = 1 },
            },
            {
                name = "Ignore These Stupid Dreams",
                effect = {},
                insert = { TheOmens = 1, TheDream = 1 }
            }
        }
    },
    QuathTheRaven = {
        name = "The Raven Quoth a Name",
        deck = "TheOmens",
        oneoff = true,
        options = {
            {
                name = "Sacrifice This Person",
                effect = { coven = -1 }
            },
            {
                name = "Celebrate Their Presence",
                effect = { affluence = -1 }
            },
            {
                name = "Some Beliefs Simply Are Nonsense",
                effect = {},
                insert = { TheOmens = 2 }
            }
        }
    },
    ALunarEclipse = {
        name = "A Lunar Eclipse",
        deck = "TheOmens",
        oneoff = true,
        options = {
            {
                name = "Bring Lunar Offerings",
                effect = { affluence = -1, herbs = -1, familiars = -1 }
            },
            {
                name = "Celebrate The Eye of Nuln",
                effect = { familiars = -2, coven = -2 },
                insert = { TheDream = 1 }
            },
            {
                name = "Don't Look at the Sky",
                effect = {},
                insert = { TheOmens = 2 }
            }
        }
    },
    ABlackCatCrossedOurPath = {
        name = "A Black Cat Crossed Our Path",
        deck = "TheOmens",
        oneoff = true,
        options = {
            {
                name = "Take It In",
                effect = { familiars = 1 }
            },
            {
                name = "Pet It",
                effect = {},
                insert = { TheDream = 1 }
            }
        }
    },

    -- the dream / red dream
    PropheticSlumber = {
        name = "The Dream: Prophetic Slumber",
        deck = "TheDream",
        options = {
            {
                name = "We Shall Hug the Road Again",
                effect = {},
                insert = { TheRoad = 2 },
                skip = 2
            },
            {
                name = "We'll Go Into the Wild",
                effect = {},
                insert = { TheForest = 1 },
                skip = 2
            },
            {
                name = "A Storm Is Coming Our Way",
                effect = {},
                insert = { TheStorm = 1 },
                skip = 2
            }
        }
    },
    CrimsonIndulgence = {
        name = "Crimson Indulgence",
        deck = "TheDream",
        oneoff = true,
        options = {
            {
                name = "Drink of the River of Life",
                effect = { coven = -1, familiar = -1 },
                insert = { RedDream1 = 1 }
            },
            {
                name = "Wake Up And Forget",
                effect = {}
            }
        }
    },
    AtTheLakeOfBecoming = {
        name = "At The Lake of Becoming",
        deck = "RedDream1",
        oneoff = true,
        options = {
            {
                name = "Drink Deeper the Crimson, Never Stop",
                effect = { coven = -1, familiar = -1 },
                insert = { RedDream2 = 1 }
            },
            {
                name = "Wake Up In Sweat",
                effect = {}
            }
        }
    },
    WithAStrangerInTheMist = {
        name = "With A Stranger In the Mist",
        deck = "RedDream2",
        oneoff = true,
        options = {
            {
                name = "Invite Their Lanky, Hungry Form",
                effect = { coven = -2, familiar = -1, herbs = -1 },
                insert = { RedDream3 = 1 }
            },
            {
                name = "Wake Up And Forget",
                effect = { familiars = -1 }
            }
        }
    },
    HissYourDeepestDesires = {
        name = "Hiss Your Deepest Desires",
        deck = "RedDream3",
        oneoff = true,
        options = {
            {
                name = "Salvation!",
                effect = { coven = -2, familiar = -1, herbs = -1, affluence = -1 },
                insert = { RedDream4 = 1 }
            },
            {
                name = "Destruction!",
                effect = { coven = -1, familiar = -1 },
                insert = { RedDream3 = 1 }
            },
            {
                name = "Wake Up And Forget",
                effect = { coven = -1 }
            }
        }
    },
    KnowYourCarnalIntentions = {
        name = "Know Your Carnal Intentions",
        deck = "RedDream4",
        oneoff = true,
        options = {
            {
                name = "Thirst Eternal, Blood and Souls!",
                effect = { coven = -2, familiar = -2 },
                insert = { RedDream5 = 1 }
            },
            {
                name = "Bottomless Hunger, Gold and Gifts!",
                effect = { affluence = -2, artifacts = -1 },
                insert = { RedDream5 = 1 }
            },
            {
                name = "Restful, Dreamless Sleep!",
                effect = { artifacts = 1 },
                insert = { TheDream = 1 }
            }
        }
    },
    WhenBeckonedToPerceive = {
        name = "When Beckoned to Perceive",
        deck = "RedDream5",
        oneoff = true,
        options = {
            {
                name = "Open Your Eyes, Emeralds Two!",
                effect = { coven = -2, artifacts = -2 },
                insert = { RedDream5 = 1 }
            }
        }
    },
    ObserveThatYouAreADeity = {
        name = "Observe That You Are a Deity",
        deck = "RedDream6",
        oneoff = true,
        options = {
            {
                name = "I am Nuln, the Crimson Whisper",
                effect = {},
                tags = { Victory = 1, RedDreamEnding = 1 }
            }
        }
    },

    -- the forest
    AnAbundantGrove = {
        name = "An Abundant Grove",
        deck = "TheForest",
        options = {
            {
                name = "Let Us Pick the Blessed Meadow",
                effect = { herbs = 3 }
            },
            {
                name = "Let's Meet the Forest Spirits",
                effect = { familiars = 3 }
            }
        }
    },
    RumorsOfDarkness = {
        name = "Rumors of Darkness",
        deck = "TheForest",
        options = {
            {
                name = "Follow the Whispers",
                effect = {},
                -- TODO (add god questline here)
            },
            {
                name = "We Have No Time For This",
                effect = {}
            }
        }
    },
    LostOurBearings1 = {
        name = "We Lost Our Bearings",
        deck = "TheForest",
        options = {
            {
                name = "Go Left",
                effect = {},
                insert = { TheRoad = 1 }
            },
            {
                name = "Go Right",
                effect = {},
                insert = { TheForest = 1 }
            },
        }
    },
    LostOurBearings2 = {
        name = "We Lost Our Bearings",
        deck = "TheForest",
        options = {
            {
                name = "Go Left",
                effect = {},
                insert = { TheNight = 1 }
            },
            {
                name = "Go Right",
                effect = {},
                insert = { TheStorm = 1 }
            },
        }
    },
    -- the storm
    HarshWinds = {
        name = "Harsh Winds",
        deck = "TheStorm",
        options = {
            {
                name = "We Push Through",
                effect = { coven = -1 }
            },
            {
                name = "Our Sacks Burst Open",
                effect = { herbs = -1 },
            },
        }
    },
    SuddenDeluge = {
        name = "Sudden Deluge",
        deck = "TheStorm",
        options = {
            {
                name = "Save The Coven!",
                effect = { affluence = -1, herbs = -1, artifacts = -1 }
            },
            {
                name = "Save The Idols!",
                effect = { coven = -1, familiars = -1 },
            },
            {
                name = "Command It To Stop!",
                effect = { suspicion = 3 }
            }
        }
    },
    ARefreshingDownpour = {
        name = "A Refreshing Downpour",
        deck = "TheStorm",
        options = {
            {
                name = "The Plants Enjoy It",
                effect = { herbs = 1 }
            },
            {
                name = "We Celebrate the Calm",
                effect = { coven = 1, familiars = 1 },
            },
        }
    },
    WeBrandishYourPower = {
        name = "We Brandish Your Might",
        deck = "TheTemple",
        options = {
            {
                name = "Hark thee, Witchbane! Begone!",
                effect = { coven = -5, artifacts = -5, suspicion = -5 },
                tag = { Victory = 1, TempleEnding = 1 }
            }
        }
    },

    Inquisitors = {
        name = "Inquisitors!",
        deck = "TheTower",
        oneoff = true,
        portrait = 8,
        options = {
            {
                name = "No Witches Here",
                effect = { affluence = -2, suspicion = -5 }
            },
            {
                name = "Stay Quiet And Keep Moving",
                effect = { suspicion = 1 },
                insert = { TheTower = 1 }
            }
        }
    },
    RaidForTheEsoteric = {
        name = "Raid For the Esoteric",
        deck = "TheTower",
        oneoff = true,
        options = {
            {
                name = "Give Up Your Trinkets",
                effect = { herbs = -2, affluence = -2, suspicion = -2 },
                insert = { TheTower = 1 }
            },
            {
                name = "Hand Them Your Artifice",
                effect = { artifacts = -1, suspicion = -4 },
            }
        }
    },
    GraveBetrayal = {
        name = "Grave Betrayal!",
        deck = "TheTower",
        oneoff = true,
        portrait = 19,
        options = {
            {
                name = "One Of Our Own Betrayed Us",
                effect = { coven = function(c) return -c / 2 end, suspicion = -3 },
                insert = { TheTower = 1 }
            },
            {
                name = "Our Spirits Were Captured",
                effect = { familiars = function(f) return -f / 2 end, suspicion = -3 },
                insert = { TheTower = 1 }
            }
        }
    },

    APickingOfBerries = {
        name = "A Picking of Berries",
        deck = "TheHedgeWitch",
        options = {
            {
                name = "We Take What The Earth Gives",
                effect = { herbs = 3 },
                skip = 2,
            },
        }
    },
    SolidarityWithTheWeak = {
        name = "We Stand With The Weak",
        deck = "TheHedgeWitch",
        options = {
            {
                name = "We Stand With Those Who Cannot",
                effect = { coven = 3, suspicion = 1 },
                skip = 2,
            },
            {
                name = "We Wait For Our Chance",
                effect = { suspicion = -3 },
                skip = 2,
            }
        }
    },
    SingingToSpirits = {
        name = "We Sing to the Spirits Unseen",
        deck = "TheHedgeWitch",
        options = {
            {
                name = "Accept Them In Your Hollow Hearts",
                effect = { familiars = 3, suspicion = 1 },
                skip = 2,
            },
            {
                name = "Do Not Rouse the Inquisition",
                effect = { suspicion = -3 },
                skip = 2,
            }
        }
    },
    KnowledgeMostArcane = {
        name = "Yearn for Knowledge Most Arcane",
        deck = "TheHedgeWitch",
        options = {
            {
                name = "The Circle of Five...",
                effect = { coven = 3, suspicion = 1 },
                skip = 2,
            },
            {
                name = "Five Broken Parts...",
                effect = { artifacts = 1, suspicion = 1 },
                skip = 2,
            },
            {
                name = "With Shadows Long...",
                effect = { suspicion = 2 },
                skip = 2,
            },
            {
                name = "Witchbane Will Cut.",
                effect = {},
                skip = 2,
            },
        }
    },
    ACoinForTheRemedy = {
        name = "A Coin For the Remedy",
        deck = "TheHedgeWitch",
        options = {
            {
                name = "We Take What We Must",
                effect = { affluence = 1 },
                skip = 2,
            },
            {
                name = "We Tighten Our Sashes",
                effect = { suspicion = -3 },
                skip = 2,
            }
        }
    },
}