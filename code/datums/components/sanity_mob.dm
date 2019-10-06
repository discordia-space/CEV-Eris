#define SANITY_PASSIVE_GAIN 2

var/list/levels = list(
	10 = "Divine",
	 9 = "Hallowed",
	 8 = "Holy",
	 7 = "Enlightening",
	 6 = "Blessed",
	 5 = "Inspirational",
	 4 = "Lovely",
	 3 = "Charming",
	 2 = "Pleasant",
	 1 = "Hospitable",
	 0 = "Neutral",
	-1 = "Moody",
	-2 = "Melancholic",
	-3 = "Depressing",
	-4 = "Unsetting",
	-5 = "Ominous",
	-6 = "Haunted",
	-7 = "Intense",
	-8 = "Dreadful",
	-9 = "Accursed",
	-10 = "Soul Crushing",
)


/datum/sanity
	var/level
	var/flags
	var/mob/living/carbon/human/owner

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
			affect = affect * owner.stats.getStat(STAT_VIG)/STAT_LEVEL_MAX
		level += affect









#undef SANITY_PASSIVE_GAIN
