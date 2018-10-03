/datum/storyteller/chronicler
	config_tag = "chronicler"
	name = "The Chronicler"
	welcome = "Today will be a glorious day!"
	description = "A storyteller with a focus on player vs player combat. Spawns lots of antagonists, but fewer random events."

	gain_mult_mundane = 0.8
	gain_mult_moderate = 0.8
	gain_mult_major = 0.8
	gain_mult_roleset = 1.5

	repetition_multiplier = 0.9

	//Healer gives you half an hour to setup before any antags
	points = list(
	0, //Mundane
	0, //Moderate
	0, //Major
	200 //Roleset
	)