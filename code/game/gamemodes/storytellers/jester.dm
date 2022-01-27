/datum/storyteller/jester
	config_tag = "jester"
	name = "The Jester"
	welcome = "Welcome to the house of fun. We're all69ad here!"
	description = "Aggressive and chaotic storyteller who generates a larger 69uantity of random events."

	gain_mult_mundane = 1.85
	gain_mult_moderate = 1.65
	gain_mult_major = 1.65

	variance = 0.25
	repetition_multiplier = 0.95 //Kept it below 0 because lmao it's jester

	//Jester generates lots of random events, but not so69any antags
	points = list(
	EVENT_LEVEL_MUNDANE = 15, //Mundane
	EVENT_LEVEL_MODERATE = 35, //Moderate
	EVENT_LEVEL_MAJOR = 75, //Major
	EVENT_LEVEL_ROLESET = 100 //Roleset
	)
