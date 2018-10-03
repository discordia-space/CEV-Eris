/datum/storyteller/warrior
	config_tag = "warrior"
	name = "The Warrior"
	welcome = "Ready your weapons, and prepare for battle..."
	description = "Aggressive storyteller with a focus on generating monsters and antagonists that will do battle with the crew"

	//Todo: Add violent weighting here
	gain_mult_roleset = 1.25


	//Warrior has starting values that will cause moderate and major events very early in the round
	points = list(
	0, //Mundane
	35, //Moderate
	75, //Major
	120 //Roleset
	)