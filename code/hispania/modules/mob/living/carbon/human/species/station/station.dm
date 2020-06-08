/datum/species/kidan
	name = SPECIES_KIDAN
	name_plural = SPECIES_KIDAN
	icobase = 'icons/hispania/mob/human_races/r_kidan.dmi'
	deform = 'icons/hispania/mob/human_races/r_def_kidan.dmi'
	blurb = "The Kidan are ant-like creatures who posses an exoskeleton. \
	They originate from the world of Aurum, a harsh world with a poor atmosphere now lost with the destruction of the Milky Way. \
	The last Kidan Empress was killed and their planets conquered at least a century ago in a war with humanity. \
	After unconditional surrender the kidan were strictly controlled and under sanctions. \
	Most of the kidan in Canis Major are now refugees."
	name_language = LANGUAGE_KIDAN
	language = LANGUAGE_KIDAN           // Default racial language, if any.
	spawn_flags = CAN_JOIN
	appearance_flags = HAS_SKIN_TONE | HAS_EYE_COLOR | HAS_HAIR_COLOR
	num_alternate_languages = 1
	min_age = 18
	max_age = 60
	unarmed_types = list(/datum/unarmed_attack/claws, /datum/unarmed_attack/stomp,  /datum/unarmed_attack/kick, /datum/unarmed_attack/bite)
	reagent_tag = IS_KIDAN
	breath_pressure = 10 //deafault 16
	brute_mod = 0.8
	burn_mod = 1.5
	radiation_mod = 0.5
	toxins_mod = 0.5

	eyes = "kidan_eyes"
	flesh_color = "#ba7814"
	blood_color = "#FB9800"

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/kidan,
		BP_LUNGS =    /obj/item/organ/internal/lungs/kidan,
		BP_LIVER =    /obj/item/organ/internal/liver/kidan,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/kidan,
		BP_BRAIN =    /obj/item/organ/internal/brain/kidan,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes/kidan, //Default darksight of 2.
		)

/datum/species/kidan/get_bodytype()
	return SPECIES_KIDAN
