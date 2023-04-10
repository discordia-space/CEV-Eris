/*
/datum/gear/accessory
	sort_category = "Accessories"
	category = /datum/gear/accessory
	slot = slot_accessory_buffer

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["blue tie, clip"] = /obj/item/clothing/accessory/blue_clip
	ties["red long tie"] = /obj/item/clothing/accessory/red_long
	ties["black tie"] = /obj/item/clothing/accessory/black
	ties["yellow tie"] = /obj/item/clothing/accessory/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/navy
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["brown tie"] = /obj/item/clothing/accessory/brown
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/tie_color
	display_name = "colored tie"
	path = /obj/item/clothing/accessory
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie_color/New()
	..()
	var/ties = list()
	ties["tie"] = /obj/item/clothing/accessory
	ties["striped tie"] = /obj/item/clothing/accessory/long
	gear_tweaks += new/datum/gear_tweak/path(ties)
*/
/datum/gear/accessory
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_accessory_buffer
	sort_category = "Accessories"

/datum/gear/accessory/guild
	display_name = "armband, Aster's Guild"
	path = /obj/item/clothing/accessory/armband/cargo
	allowed_roles = list(JOBS_CARGO)

/datum/gear/accessory/engineering
	display_name = "armband, Technomancer League"
	path = /obj/item/clothing/accessory/armband/engine
	allowed_roles = list(JOBS_ENGINEERING)

/datum/gear/accessory/hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro

/datum/gear/accessory/medical
	display_name = "armband, white"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/accessory/moebius
	display_name = "Moebius armband selection"
	path = /obj/item/clothing/accessory/armband/science
	allowed_roles = list(JOBS_SCIENCE, JOBS_MEDICAL)

/datum/gear/accessory/moebius/New()
    ..()
    var/moebius_armband = list(
        "Moebius armband, research purple"	 	=	 /obj/item/clothing/accessory/armband/science,
		"Moebius armband, corporate colors" 	=	 /obj/item/clothing/accessory/armband/moebius,
        "Moebius armband, biomedical blue" 		=	 /obj/item/clothing/accessory/armband/medgreen
    )
    gear_tweaks += new /datum/gear_tweak/path(moebius_armband)

/datum/gear/accessory/holster
	display_name = "holster, selection"
	path = /obj/item/storage/pouch/holster

/datum/gear/accessory/holster/New()
	..()
	var/holsters = list(
		"Compact"				=	/obj/item/storage/pouch/holster,
		"Baton"					=	/obj/item/storage/pouch/holster/baton,
		"Belt"					=	/obj/item/storage/pouch/holster/belt,
		"Throwing knife pouch"	=	/obj/item/storage/pouch/holster/belt/knife,
		"Sheath"				=	/obj/item/storage/pouch/holster/belt/sheath
	)
	gear_tweaks += new/datum/gear_tweak/path(holsters)

/datum/gear/accessory/concealed_carry_holster
	display_name = "uniform holster, selection"
	path = /obj/item/clothing/accessory/holster
	cost = 3

/datum/gear/accessory/concealed_carry_holster/New()
	..()
	var/accs = list(
		"Concealed carry"		=	/obj/item/clothing/accessory/holster,
		"Scabbard"				=	/obj/item/clothing/accessory/holster/scabbard,
		"Throwing knife rig"	=	/obj/item/clothing/accessory/holster/knife,
		"Ring sheath" 			= 	/obj/item/clothing/accessory/holster/scabbard/ring
	)
	gear_tweaks += new/datum/gear_tweak/path(accs)

/datum/gear/accessory/tie/blue
	display_name = "tie, blue"
	path = /obj/item/clothing/accessory/blue

/datum/gear/accessory/tie/red
	display_name = "tie, red"
	path = /obj/item/clothing/accessory/red

/datum/gear/accessory/tie/horrible
	display_name = "tie, socially disgraceful"
	path = /obj/item/clothing/accessory/horrible

/datum/gear/accessory/wallet
	display_name = "wallet, colour select"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/mask/scarf
	slot = slot_wear_mask
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/mask/bandana
	slot = slot_wear_mask
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/cloak
	display_name = "poncho selection"
	path = /obj/item/clothing/accessory/cloak
	slot = slot_accessory_buffer
	flags = GEAR_HAS_TYPE_SELECTION
