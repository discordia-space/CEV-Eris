#define CASTE_NONE 0
#define CASTE_LOWBORN 1 //may chaos take the world
#define CASTE_NOBLE 2

#define STATUS_LOW 1
#define STATUS_MEDIUM 1
#define STATUS_HIGH 3
#define GENERIC_DISLIKE_BLURB "They are enemies of "

#define ORIGIN_OBERTH 1
#define ORIGIN_PREDSTRAZA 2
#define ORIGIN_SICH_PRIME 3
#define ORIGIN_NEW_ROME 4
#define ORIGIN_SHIMATENGOKU 5
#define ORIGIN_HMSS_DESTINED 6
#define ORIGIN_CROZET 7
#define ORIGIN_FIRST_EXPEDITIONARY_FLEET 8
#define ORIGIN_END_POINT 9
#define ORIGIN_NSS_FORECASTER 10
#define ORIGIN_EUREKA 11
#define ORIGIN_WANDERING_STRELTSY 12
#define ORIGIN_TRIPWIRE_BELT 13
#define ORIGIN_KESTREL_HIVE 14


//make
//add differential feebdack
//add add-remove from perks
//add randomization

/datum/social_data
	var/name = "Perkele"
	var/desc = ""
	var/mob/living/carbon/human/holder
	var/caste = CASTE_NONE
	var/status = 0
	var/origin = 0 //nobles don't recognize nobles from other origins, either due to ignorance or just being snooty.
	var/list/dislikedOrigins
	var/list/likedOrigins

//we do the null checks before running this
/datum/social_data/proc/get_feedback_string(datum/social_data/perceiver, datum/social_data/target)
	var/feedback = "\n"
	if(perceiver.origin == target.origin && perceiver.caste == CASTE_NOBLE && target.caste == CASTE_NOBLE)
		var/nobilitySynonym = "nobility"
		if(prob(50))
			nobilitySynonym = "aristocracy"
		if(perceiver.status < target.status)
			feedback += "This person outranks me as [perceiver.origin] [nobilitySynonym].\nI should respect and obey."
		else if(perceiver.status > target.status)
			feedback += "I outrank this person in [perceiver.origin] [nobilitySynonym].\nThey should respect me!"
		else if(perceiver.status == target.status)
			feedback += "We are both equal [perceiver.origin] [nobilitySynonym].\nWe should stick together."
	else if(perceiver.caste == CASTE_LOWBORN && target.caste == CASTE_LOWBORN)
		feedback += "We are both lowborn.\nWe should stick together in these trying times."
	else if(perceiver.caste != CASTE_LOWBORN && target.caste == CASTE_LOWBORN)
		var/pejorative = "such rascals"
		if(prob(50))
			pejorative = "scum like this"
		feedback += "Lowborn scum. I should be wary of [pejorative]."
	else if (perceiver.caste != CASTE_NOBLE && target.caste == CASTE_NOBLE)
		feedback += "Bearing, posture, features.\nThey show signs of noble heritage. "
	return feedback

/datum/social_data/proc/set_origin(datum/category_item/setup_option/background/origin/O)
	src.origin = O.name



















/datum/social_data/none
	name = "Normal"
	caste = CASTE_NONE
	status = 0

/datum/social_data/lowborn
	name = "Normal"
	caste = CASTE_NONE
	status = 0

/datum/social_data/noble_high
	name = "Normal"
	caste = CASTE_NONE
	status = 0

/datum/social_data/noble_low
	name = "Normal"
	caste = CASTE_NONE
	status = 0