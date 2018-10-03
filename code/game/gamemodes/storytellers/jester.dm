/datum/storyteller/jester
	config_tag = "jester"
	name = "The Jester"
	welcome = "Welcome to the house of fun. We're all mad here!"
	description = "Aggressive and chaotic storyteller who generates a larger quantity of random events."

	gain_mult_mundane = 1.5
	gain_mult_moderate = 1.5
	gain_mult_major = 1.5

	variance = 0.25
	repetition_multiplier = 0.65

	//Jester generates lots of random events, but not so many antag
	points = list(
	15, //Mundane
	35, //Moderate
	75, //Major
	80 //Roleset
	)