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

/datum/social_data
	var/name = "Perkele"
	var/desc = ""
	var/mob/living/carbon/human/holder
	var/caste = CASTE_NONE
	var/status = 0
	var/origin = 0 //nobles don't recognize nobles from other origins, either due to ignorance or just being snooty.

//we do the null checks before running this
/datum/social_data/proc/get_feedback_string(datum/social_data/perceiver, datum/social_data/target)
	var/feedback = "\n"
	var/statedOrigin = 0
	if(perceiver.origin == target.origin && perceiver.caste == CASTE_NOBLE && target.caste == CASTE_NOBLE)
		var/nobilitySynonym = "nobility"
		statedOrigin = 1
		if(prob(50))
			nobilitySynonym = "aristocracy"
		if(perceiver.status < target.status)
			feedback += "This person outranks me as [get_origin_name_from_id(perceiver.origin)] [nobilitySynonym].\nI should respect and obey."
		else if(perceiver.status > target.status)
			feedback += "I outrank this person in [get_origin_name_from_id(perceiver.origin)] [nobilitySynonym].\nThey should respect me!"
		else if(perceiver.status == target.status)
			feedback += "We are both equal [get_origin_name_from_id(perceiver.origin)] [nobilitySynonym].\nFeels good to be among peers."
	else if(perceiver.caste == CASTE_LOWBORN && target.caste == CASTE_LOWBORN)
		feedback += "We are both lowborn.\nWe should stick together."
	else if(perceiver.caste != CASTE_LOWBORN && target.caste == CASTE_LOWBORN)
		var/pejorative = "such rascals"
		if(prob(50))
			pejorative = "scum like this"
		feedback += "Lowborn scum. I should be wary of [pejorative]."
	else if(perceiver.caste != CASTE_NOBLE && target.caste == CASTE_NOBLE)
		feedback += "Bearing, posture, features.\nThey show signs of noble heritage. "
	if(perceiver.origin == target.origin && statedOrigin != 1)
		feedback += "\nThey come from [get_origin_name_from_id(perceiver.origin)], just like me."
	feedback += "\n"
	return feedback

/datum/social_data/proc/set_origin(datum/category_item/setup_option/background/origin/O)
	src.origin = get_origin_id_from_datum(O)


/proc/get_origin_id_from_datum(datum/category_item/setup_option/background/origin/O)
	if(istype(O, /datum/category_item/setup_option/background/origin/oberth))
		return ORIGIN_OBERTH
	if(istype(O, /datum/category_item/setup_option/background/origin/predstraza))
		return ORIGIN_PREDSTRAZA
	if(istype(O, /datum/category_item/setup_option/background/origin/sich_prime))
		return ORIGIN_SICH_PRIME
	if(istype(O, /datum/category_item/setup_option/background/origin/new_rome))
		return ORIGIN_NEW_ROME
	if(istype(O, /datum/category_item/setup_option/background/origin/shimatengoku))
		return ORIGIN_SHIMATENGOKU
	if(istype(O, /datum/category_item/setup_option/background/origin/hmss_destined))
		return ORIGIN_HMSS_DESTINED
	if(istype(O, /datum/category_item/setup_option/background/origin/crozet))
		return ORIGIN_CROZET
	if(istype(O, /datum/category_item/setup_option/background/origin/first_expeditionary_fleet))
		return ORIGIN_FIRST_EXPEDITIONARY_FLEET
	if(istype(O, /datum/category_item/setup_option/background/origin/end_point))
		return ORIGIN_END_POINT
	if(istype(O, /datum/category_item/setup_option/background/origin/nss_forecaster))
		return ORIGIN_NSS_FORECASTER
	if(istype(O, /datum/category_item/setup_option/background/origin/eureka))
		return ORIGIN_EUREKA
	if(istype(O, /datum/category_item/setup_option/background/origin/streltsy))
		return ORIGIN_WANDERING_STRELTSY
	if(istype(O, /datum/category_item/setup_option/background/origin/tripwire))
		return ORIGIN_TRIPWIRE_BELT
	if(istype(O, /datum/category_item/setup_option/background/origin/kestrel))
		return ORIGIN_KESTREL_HIVE
	return 0

/proc/get_origin_name_from_id(origin_id)
	switch(origin_id)
		if(ORIGIN_OBERTH)                    return "Oberth"
		if(ORIGIN_PREDSTRAZA)                return "Predstraza"
		if(ORIGIN_SICH_PRIME)                return "Sich Prime"
		if(ORIGIN_NEW_ROME)                  return "New Rome"
		if(ORIGIN_SHIMATENGOKU)              return "Shimatengoku"
		if(ORIGIN_HMSS_DESTINED)             return "HMSS \"Destined\""
		if(ORIGIN_CROZET)                    return "Crozet"
		if(ORIGIN_FIRST_EXPEDITIONARY_FLEET) return "First Expeditionary Fleet"
		if(ORIGIN_END_POINT)                 return "End Point"
		if(ORIGIN_NSS_FORECASTER)            return "NSS \"Forecaster\""
		if(ORIGIN_EUREKA)                    return "Eureka"
		if(ORIGIN_WANDERING_STRELTSY)        return "Wandering Streltsy"
		if(ORIGIN_TRIPWIRE_BELT)             return "Tripwire Belt"
		if(ORIGIN_KESTREL_HIVE)              return "Kestrel Hive"
	return "Unknown"