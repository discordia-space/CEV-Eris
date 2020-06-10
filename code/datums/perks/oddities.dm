#define PERK_FAST_FINGERS /datum/perk/fast_fingers
#define PERK_ASS_OFF_CONCRETE /datum/perk/ass_off_concrete
#define PERK_RAT /datum/perk/rat
#define PERK_REJECTED_GENIUS /datum/perk/rejected_genius

/datum/perk/fast_fingers
	name = "Survivor"
	desc = "After seeing the death of many acquaintances and friends, witnessing death doesn't shock you as much as before."
	icon_state = "survivor" // https://game-icons.net/1x1/lorc/one-eyed.html

// Fate
//rat
/datum/perk/rat
	name = "rat"
	desc = " In your life you decided to feast upon what’s not yours, be that thief, raiding, or scavenging and exploring. It’s all the same no matter how you name it, after all. You know the ways of infiltrating, salvaging, and getting away with the loot."
	icon_state = "rat" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/rat/assign(mob/living/carbon/human/H)
	..()
	holder.stats.addTempStat(STAT_MEC, -10, INFINITY, "Fate Rat")
	holder.stats.addTempStat(STAT_VIG, -10, INFINITY, "Fate Rat")
	holder.sanity.max_level -= 10

/datum/perk/rat/remove()
	holder.stats.removeTempStat(STAT_MEC, "Fate Rat")
	holder.stats.removeTempStat(STAT_VIG, "Fate Rat")
	holder.sanity.max_level += 10
	..()

//genius
/datum/perk/rejected_genius
	name = "rat"
	desc = " In your life you decided to feast upon what’s not yours, be that thief, raiding, or scavenging and exploring. It’s all the same no matter how you name it, after all. You know the ways of infiltrating, salvaging, and getting away with the loot."
	icon_state = "rat" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/rejected_genius/assign(mob/living/carbon/human/H)
	..()
	holder.sanity.positive_prob = 0
	holder.sanity.insight_passive_gain_multiplier *= 1.5
	holder.sanity.max_level -= 20

/datum/perk/rejected_genius/remove()
	holder.sanity.positive_prob = initial(holder.sanity.positive_prob)
	holder.sanity.insight_passive_gain_multiplier /= 1.5
	holder.sanity.max_level += 20
	..()
