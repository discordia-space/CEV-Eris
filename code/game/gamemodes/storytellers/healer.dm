/datum/storyteller/healer
	config_tag = "healer"
	name = "The Healer"
	welcome = "Welcome to CEV Eris! We hope you enjoy your stay!"
	description = "Peaceful and relaxed storyteller who will try to help the crew a little."

	gain_mult_mundane = 1.2
	gain_mult_moderate = 0.8
	gain_mult_major = 0.8
	gain_mult_roleset = 0.8

	repetition_multiplier = 0.95
	tag_weight_mults = list(TAG_COMBAT = 0.75, TAG_NEGATIVE = 0.5, TAG_POSITIVE = 2)

	//Healer gives you half an hour to setup before any antags
	points = list(
	EVENT_LEVEL_MUNDANE = 0, //Mundane
	EVENT_LEVEL_MODERATE = 0, //Moderate
	EVENT_LEVEL_MAJOR = 0, //Major
	EVENT_LEVEL_ROLESET = 90 //Roleset
	)