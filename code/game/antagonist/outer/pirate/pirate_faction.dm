/datum/faction/pirate
	id = FACTION_PIRATES
	name = "Pirates"
	antag = "pirate"
	antag_plural = "pirates"
	welcome_text = WELCOME_PIRATES

	hud_indicator = "pirate"

	possible_antags = list(ROLE_PIRATE)

	faction_invisible = FALSE

	var/objectives_num
	var/list/possible_objectives = list(
	/datum/objective/plunder = 10)
	var/objective_quantity = 2

/datum/faction/pirate/create_objectives()
	make_base_items_worthless()

	objectives.Cut()
	pick_objectives(src, possible_objectives, objective_quantity)

	new /datum/objective/timed/pirate(src)

	..()

/datum/faction/pirate/add_leader(var/datum/antagonist/member, var/announce = TRUE)
	.=..()
	if(.)
		// Put the commander outfit on
		var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/pirate/commander)
		O.equip(member.owner.current, OUTFIT_ADJUSTMENT_NO_RESET)

		member.create_id("Pirate Quartermaster")

// Special inventory proc for pirates. Includes the content of their loot crates.
/datum/faction/pirate/get_inventory()
	var/list/contents = list()
	for(var/obj/structure/closet/crate/pirate/P in get_area_contents(/area/shuttle/pirate))
		var/turf/T = get_turf(P)
		contents |= T.get_recursive_contents()

	return contents

// Make all stuff in pirate base worthless so that it cannot be used as loot in the loot crates
/datum/faction/pirate/proc/make_base_items_worthless()
	for(var/obj/item/I in get_area_contents(/area/centcom/pirate_base))
		I.item_flags |= PIRATE_BASE

#undef WELCOME_PIRATES
