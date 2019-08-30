#define SANITY_PASSIVE_GAIN 2

/datum/sanity
	var/level
	var/flags
	var/owner

/datum/sanity/New(mob/living/carbon/human/H)
	owner = H

/datum/sanity/proc/onLife()
	var/area/my_area = get_area(owner)
	if(!my_area)
		level += SANITY_PASSIVE_GAIN
		return
	else
		var/affect = my_area.sanity.affect
		if(affect < 0)
			affect = owner.stats.getStat(STAT_VIG)
		level += affect









#undef SANITY_PASSIVE_GAIN
