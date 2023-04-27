/datum/mutation/t2
	tier_num = 2
	tier_string = "Tacitus"
	NSA_load = 15

// Heal wounds with effectivenes of Tricordrazine
/datum/mutation/t2/healing_factor
	name = "Lesser healing factor"
	desc = "Slightly improves natural regeneration."


/datum/mutation/t2/remotesay
	name = "Mind projection"
	desc = "Allows to telepatically speak to other people."

/datum/mutation/t2/remotesay/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/remotesay

/datum/mutation/t2/remotesay/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/remotesay

/datum/mutation/t2/forcespeak
	name = "Force speak"
	desc = "Allows you to force other person in line of sight to speak."

/datum/mutation/t2/forcespeak/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/forcespeak

/datum/mutation/t2/forcespeak/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/forcespeak


/datum/mutation/t2/noprints
	name = "Numb fingers"
	desc = "Causes finger friction ridges to disappear, essentially removing the fingerprint pattern."
	NSA_load = 0


/datum/mutation/t2/roach_pheromones
	name = "Roach pheromones"
	desc = "Gives ability to release pheromones that calm down roaches for a short period of time."

/datum/mutation/t2/roach_pheromones/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/roach_pheromones

/datum/mutation/t2/roach_pheromones/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/roach_pheromones


/datum/mutation/t2/spider_pheromones
	name = "Spider pheromones"
	desc = "Gives ability to release pheromones that calm down spiders for a short period of time."

/datum/mutation/t2/spider_pheromones/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/spider_pheromones

/datum/mutation/t2/spider_pheromones/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/spider_pheromones
