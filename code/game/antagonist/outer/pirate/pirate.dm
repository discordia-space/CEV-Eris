#define WELCOME_PIRATES "You are a serbian pirate, part of a team of professional soldiers. You are currently aboard your base preparing for a mission targeting the CEV Eris.<br>\
	<br>\
	In your base you will find your armoury full of weapon crates and the EVA capable SCAF armour. It is advised that you take a pistol, a rifle, a knife and a SCAF suit for basic equipment.<br>\
	Once you have your basic gear, you may also wish to take along a specialist weapon, like the RPG-7 or the Pulemyot Kalashnikova. Each of the specialist weapons is powerful but very bulky, you will need to wear it over your back.<br>\
	<br>\
	Discuss your specialties with your team, choose a broad range of weapons that will allow your group to overcome a variety of obstacles. Search the base and load up everything onto your ship which may be useful, you will not be able to easily return here once you depart.<br>\
	When ready, use the console on your shuttle bridge to depart for Eris. Travelling will take several minutes, and you will be detected before you even arrive, stealth is not an option. Once you arrive, you have a time limit to complete your mission."

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
	new /obj/item/clothing/suit/armor/bulletproof(src)
	new /obj/item/storage/backpack/satchel(src)
	new /obj/item/melee/energy/sword/pirate(src)

// PIRATE LOOT CRATE

/obj/structure/closet/crate/pirate
	name = "loot crate"
	desc = "A rectangular steel crate to store your pricy and ethically obtained loot."

// LOOT CHECKER

#define CHECKER_COOLDOWN 1 MINUTE

/obj/item/device/loot_checker
	name = "loot value checker"
	desc = "Used to check the total value of plundered loot."
	icon_state = "voice0"
	item_state = "flashbang"
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1, MATERIAL_STEEL = 2)
	flags = CONDUCT
	anchored = TRUE

	var/last_use = - CHECKER_COOLDOWN

/obj/item/device/loot_checker/attack_hand(mob/user)
	if(world.time > last_use + CHECKER_COOLDOWN)
		var/cumulated_amount = check_loot_value()
		if(cumulated_amount)
			audible_message(SPAN_WARNING("[src] beeps: 'LOOT VALUE: [cumulated_amount] credits.'"))
		else
			audible_message(SPAN_WARNING("[src] beeps: 'ERROR: Unable to compute loot value.'"))
		last_use = world.time
	else
		to_chat(user, SPAN_NOTICE("The loot value checker has [round((last_use + CHECKER_COOLDOWN - world.time) / (1 SECOND))] seconds of cooldown remaining."))

/obj/item/device/loot_checker/proc/check_loot_value()
	var/cumulated_amount = 0

	// Check cumulated loot value
	for(var/obj/structure/closet/crate/pirate/P in get_area_contents(/area/shuttle/pirate))
		var/turf/T = get_turf(P)
		for(var/atom/movable/item in T.get_recursive_contents())
			cumulated_amount += SStrade.get_price(item, TRUE)

	return cumulated_amount

#undef CHECKER_COOLDOWN
