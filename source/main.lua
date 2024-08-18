import 'libraries/noble/Noble'
import 'utilities/Utilities'
import 'utilities/GenericScene'
import 'utilities/Character'
import 'utilities/MusicPlayer'
import 'utilities/Soundbank'
import 'utilities/CardAppear'
import 'utilities/CardDestroy'

import 'scenes/MainMenuScene'
import 'scenes/StartAdventure'
import 'scenes/Adventuring'
import 'scenes/Credits'
import 'scenes/VictoryScreen'
import 'scenes/DefeatScreen'

import 'gameplay/Cards'
import 'gameplay/Campaigns'

import 'gameplay/packs/TheRoad'
import 'gameplay/packs/TheScore'
import 'gameplay/packs/TheNight'
import 'gameplay/packs/TheCave'
import 'gameplay/packs/TheFind'
import 'gameplay/packs/TheStorm'
import 'gameplay/packs/TheDream'
import 'gameplay/packs/TheForest'
import 'gameplay/packs/TheOmens'
import 'gameplay/packs/TheTemple'
import 'gameplay/packs/TheTower'
import 'gameplay/packs/TheWound'
import 'gameplay/packs/TheHedgeWitch'

import 'gameplay/campaigns/HedgeWitchCampaign'

Sounds = Soundbank.new({
	"menu-move",
	"menu-select",
	"menu-cancel",
	"new-day",
	"victory",
	"defeat",
	"oneoff",
	"create",
	"move",
	"move2",
	"move3"
})

Music = MusicPlayer.new()
Music:setMaxVolume(0.5)

Kenney = Graphics.imagetable.new("assets/images/kenney")
MapChars = Graphics.imagetable.new("assets/images/map-chars")
Buildings = Graphics.imagetable.new("assets/images/buildings")
CardFrames = Graphics.imagetable.new("assets/images/cardframes")
CardImages = Graphics.imagetable.new("assets/images/cards")
CardEffects = Graphics.imagetable.new("assets/images/cardeffects")
Itchio = Graphics.image.new("assets/images/itchio")
Bonfire = Graphics.image.new("assets/images/bonfire")

Font = playdate.graphics.font.new("assets/fonts/topaz8")
playdate.graphics.setFont(Font)
Portraits = Graphics.imagetable.new("assets/images/portraits")

Char = Character.new(CharacterSheet.new())
Victory = nil
Defeat = nil
Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Character = CharacterSheet.new()
}, 1, true, true)

Noble.showFPS = true

Noble.new(MainMenuScene)
--Noble.new(StartAdventure)
