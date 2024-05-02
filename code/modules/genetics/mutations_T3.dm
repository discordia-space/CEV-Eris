/datum/mutation/t3
	tier_num = 3
	tier_string = "Hadrian"
	NSA_load = 20

// Reject shrapnel, carrion spiders and augmentations, like cruciform does
// If cruciform is supressed by another mutation - reject cruciform too, with fatal consiquences
/datum/mutation/t3/reject
	name = "Overwhelming immune response"
	desc = "Makes body actively reject foreign bodies, be it shrapnel or augmentation."

// Heal wounds with effectivenes of Bicaridine
/datum/mutation/t3/healing_factor
	name = "Greater healing factor"
	desc = "Significantly improves natural regeneration."


/datum/mutation/t3/oborin
	name = "Oborin syndrome"
	desc = "Removes ability to distinguishing between colors and taste."
	NSA_load = 0

/datum/mutation/t3/oborin/imprint(mob/living/carbon/user)
	if(..())
		user.stats.addPerk(PERK_OBORIN_SYNDROME)

/datum/mutation/t3/oborin/cleanse(mob/living/carbon/user)
	if(..())
		user.stats.removePerk(PERK_OBORIN_SYNDROME)


/datum/mutation/t3/night_vision
	name = "Night vision"
	desc = "Enhances eye sensitivity, allowing to see in the dark as if wearing night-vision goggles."


/datum/mutation/t3/thermal_vision
	name = "Thermal vision"
	desc = "Provides ability to detect heat signatures of synthetics and organics alike."


/datum/mutation/t3/inner_fuhrer
	name = "Inner fuhrer"
	desc = "Gives ability to summon nearby critters."

/datum/mutation/t3/inner_fuhrer/imprint(mob/living/carbon/user)
	if(..())
		add_verb(user, /mob/living/carbon/human/proc/inner_fuhrer)

/datum/mutation/t3/inner_fuhrer/cleanse(mob/living/carbon/user)
	if(..())
		remove_verb(user, /mob/living/carbon/human/proc/inner_fuhrer)

/datum/mutation/t3/telekinesis
	name = "Telekinesis"
	desc = "Ability to move or manipulate objects by thought."

/datum/mutation/t3/atheist
	name = "Clerical psi shielding"
	desc = "Provides resistance to specific kind of psionic effects."
