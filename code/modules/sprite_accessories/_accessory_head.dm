/* HEAD ACCESSORY */

/datum/sprite_accessory/head_accessory
	icon = 'icons/mob/human_races/species/body_accessory.dmi'
	species_allowed = list()
	icon_state = "accessory_none"
	var/over_hair

/datum/sprite_accessory/head_accessory/none
	name = "None"
	species_allowed = list(SPECIES_HUMAN, SPECIES_KIDAN)
	icon_state = "accessory_none"
