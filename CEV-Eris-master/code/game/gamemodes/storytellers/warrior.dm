/datum/storyteller/warrior
	config_tag = "warrior"
	name = "The Warrior"
	welcome = "Ready your weapons, and prepare for battle..."
	description = "Aggressive storyteller with a focus on generating monsters and antagonists that will do battle with the crew"

	gain_mult_moderate = 1.25
	gain_mult_major = 1.25
	gain_mult_roleset = 1.25

	tag_weight_mults = list(TAG_COMBAT = 1.75)

	//Warrior has starting values that will cause moderate and major events very early in the round
	points = list(
	EVENT_LEVEL_MUNDANE = 0, //Mundane
	EVENT_LEVEL_MODERATE = 35, //Moderate
	EVENT_LEVEL_MAJOR = 75, //Major
	EVENT_LEVEL_ROLESET = 140 //Roleset
	)