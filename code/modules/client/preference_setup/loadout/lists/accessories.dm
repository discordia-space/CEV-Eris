/datum/gear/accessory
	sort_category = "Accessories"
	category = /datum/gear/accessory
	slot = slot_accessory_buffer
/*
/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties69"blue tie"69 = /obj/item/clothing/accessory/blue
	ties69"red tie"69 = /obj/item/clothing/accessory/red
	ties69"blue tie, clip"69 = /obj/item/clothing/accessory/blue_clip
	ties69"red long tie"69 = /obj/item/clothing/accessory/red_long
	ties69"black tie"69 = /obj/item/clothing/accessory/black
	ties69"yellow tie"69 = /obj/item/clothing/accessory/yellow
	ties69"navy tie"69 = /obj/item/clothing/accessory/navy
	ties69"horrible tie"69 = /obj/item/clothing/accessory/horrible
	ties69"brown tie"69 = /obj/item/clothing/accessory/brown
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/tie_color
	display_name = "colored tie"
	path = /obj/item/clothing/accessory
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie_color/New()
	..()
	var/ties = list()
	ties69"tie"69 = /obj/item/clothing/accessory
	ties69"striped tie"69 = /obj/item/clothing/accessory/long
	gear_tweaks += new/datum/gear_tweak/path(ties)
*/
/datum/gear/accessory
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_accessory_buffer
	sort_category = "Accessories"

/datum/gear/accessory/cargo
	display_name = "armband, cargo"
	path = /obj/item/clothing/accessory/armband/cargo
	allowed_roles = list(JOBS_CARGO)

/datum/gear/accessory/emt
	display_name = "armband, EMT"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(JOBS_MEDICAL)

/datum/gear/accessory/engineering
	display_name = "armband, engineering"
	path = /obj/item/clothing/accessory/armband/engine
	allowed_roles = list(JOBS_ENGINEERING)

/datum/gear/accessory/hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro

/datum/gear/accessory/medical
	display_name = "armband,69edical"
	path = /obj/item/clothing/accessory/armband/med
	allowed_roles = list(JOBS_MEDICAL)

/datum/gear/accessory/science
	display_name = "armband, science"
	path = /obj/item/clothing/accessory/armband/science
	allowed_roles = list(JOBS_SCIENCE)

/datum/gear/accessory/holster
	display_name = "holster"
	path = /obj/item/clothing/accessory/holster/armpit
	cost = 3

/datum/gear/accessory/holster/New()
	..()
	var/ties = list(
		"Armpit"	=	/obj/item/clothing/accessory/holster/armpit,
		"Hip"		=	/obj/item/clothing/accessory/holster/hip,
		"Waist"		=	/obj/item/clothing/accessory/holster/waist,
	)
	gear_tweaks += new/datum/gear_tweak/path(ties)

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
