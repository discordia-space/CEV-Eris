/* BODY MARKINGS */

/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/species/default_markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD
	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like IPC optics overlay stuff.
	species_allowed = null
	var/layer_blend = ICON_OVERLAY
	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN,BP_HEAD
	var/draw_target = MARKING_TARGET_SKIN
	var/list/disallows = list() //A list of other marking types to ban from adding when this marking is already added
