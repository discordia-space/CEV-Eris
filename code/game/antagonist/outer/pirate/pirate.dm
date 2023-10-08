/datum/antagonist/pirate
	id = ROLE_PIRATE
	bantype = ROLE_PIRATE
	faction_id = FACTION_PIRATES
	role_text = "Pirate"
	welcome_text = WELCOME_PIRATES
	antaghud_indicator = "hudoperative"
	landmark_id = "pirate-spawn"
	outer = TRUE

	default_access = list(access_pirate, // This access governs their ship and base
						access_external_airlocks,
						access_maint_tunnels) // Pirates get maintenance access on eris, because being an antag without it is hell
	id_type = /obj/item/card/id/pirate // They got forged vagabond IDs

	appearance_editor = FALSE

	possible_objectives = list()
	survive_objective = null

    // A bunch of rowdy pirates should be somewhat equivalent to roundstart IH operative
	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 20,
		STAT_VIG = 25,
		STAT_BIO = 10,
		STAT_MEC = 10,
		STAT_COG = 10
	)

	perks = list(PERK_SURVIVOR)

/datum/antagonist/pirate/equip()
	var/mob/living/L = owner.current

	// Put on the fatigues. Armor not included, they equip that manually from the merc base
	var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/pirate/casual)
	O.equip(L)

	// Set their language, This also adds it to their list
	L.set_default_language(LANGUAGE_COMMON)

	// And we'll give them a random serbian name to start off with
	var/datum/language/lang = all_languages[LANGUAGE_COMMON]
	lang.set_random_name(L)

	// The missing part was antag's stats!
	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])

	for(var/perk in perks)
		L.stats.addPerk(perk)

	create_id("Pirate")
	..()

// PIRATE ID

/obj/item/card/id/pirate
	icon_state = "syndicate"

/obj/item/card/id/pirate/Initialize(mapload)
	. = ..()
	access = list(access_pirate, //This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels)

// PIRATE LOCKER

/obj/structure/closet/secure_closet/pirate
	name = "pirate locker"
	req_access = list(access_pirate)
	icon_state = "cabinet"
	icon_lock = "cabinet"

/obj/structure/closet/secure_closet/pirate/populate_contents()
	new /obj/item/clothing/under/pirate(src)
	new /obj/item/device/radio/headset/pirates(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/bandana(src)
	new /obj/item/clothing/suit/pirate(src)
	new /obj/item/storage/backpack/satchel(src)
	new /obj/item/melee/energy/sword/pirate(src)

#undef WELCOME_PIRATES
