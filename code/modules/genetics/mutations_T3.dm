// Decently powerful mutations with real downsides to them
/datum/mutation/t3
	name = "Unknown mutation"
	desc = "Unknown function"
	tier_num = 3
	tier_string = "Hadrian"
	NSA_load = 20

// Imunity to viruses, reject shrapnel, carrion spiders and augmentations, like cruciform does
// If cruciform is supressed by another mutation - reject cruciform too, with fatal consiquences
/datum/mutation/t3/reject
	name = "Overwhelming immune response"
	desc = "Makes body actively reject foreign bodies, be it shrapnel or augmentation."

// Heal wounds with effectivenes of Bicaridine
/datum/mutation/t3/healing_factor
	name = "Greater healing factor"
	desc = "Significantly improves natural regeneration."


/datum/mutation/t3/oborin
	name = "Oborin Syndrome"
	desc = "\[REDACTED\]"
	NSA_load = 0

/datum/mutation/t3/oborin/imprint(mob/living/carbon/user)
	if(..())
		user.stats.addPerk(PERK_OBORIN_SYNDROME)

/datum/mutation/t3/oborin/cleanse(mob/living/carbon/user)
	if(..())
		user.stats.removePerk(PERK_OBORIN_SYNDROME)


/datum/mutation/t3/night_vision
	name = "Night Vision"
	desc = "Enhances eye sensitivity, allowing to see in the dark as if wearing night-vision goggles."

/datum/mutation/t3/thermal_vision
	name = "Thermal Vision"
	desc = "Provides ability to detect heat signatures of synthetics and organics alike."
