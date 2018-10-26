//Chronicler is basically for antag vs antag fights.
/datum/storyteller/chronicler
	config_tag = "chronicler"
	name = "The Chronicler"
	welcome = "Today will be a glorious day!"
	description = "A storyteller with a focus on player vs player combat. Spawns lots of antagonists, but fewer random events."

	gain_mult_mundane = 0.8
	gain_mult_moderate = 0.8
	gain_mult_major = 0.8
	gain_mult_roleset = 1.5

	//Less combat-oriented events, so that we'll not be fighting NPC monsters much
	tag_weight_mults = list(TAG_COMBAT = 0.5)

	repetition_multiplier = 0.9

	//Very large starting roleset. Will spawn an antag immediately, and another very soon
	points = list(
	EVENT_LEVEL_MUNDANE = 0, //Mundane
	EVENT_LEVEL_MODERATE = 0, //Moderate
	EVENT_LEVEL_MAJOR = 0, //Major
	EVENT_LEVEL_ROLESET = 220 //Roleset
	)