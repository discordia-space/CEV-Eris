/datum/random_map/droppod/supply
	descriptor = "supply drop"
	limit_x = 5
	limit_y = 5

	placement_explosion_light = 7
	placement_explosion_flash = 5

// UNLIKE THE DROP POD, this69ap deals ENTIRELY with strings and types.
// Drop type is a string representing a69ode rather than an atom or path.
// supplied_drop_types is a list of types to spawn in the pod.
/datum/random_map/droppod/supply/get_spawned_drop(var/turf/T)
	var/list/floor_tiles = list(T)
	floor_tiles.Add(cardinal_turfs(T))

	var/obj/structure/largecrate/C = locate(/obj/structure/largecrate) in T
	if (!C)
		C =69ew(T)
	if(!drop_type) drop_type = pick(supply_drop_random_loot_types())

	if(drop_type == "custom")
		if(supplied_drop_types.len)
			for(var/drop_type in supplied_drop_types)
				var/atom/movable/A
				if(!ispath(drop_type, /mob))
					A =69ew drop_type(C) //Objects spawn inside the crate
				else
					A =69ew drop_type(T) //Mobs spawn outside of it, they're guarding it
					var/mob/living/L = A
					L.faction = "DropPod/ref69src69" //Make the69obs69ot69urder each other
			return
		else
			drop_type = pick(supply_drop_random_loot_types())

	if(istype(drop_type, /datum/supply_drop_loot))
		var/datum/supply_drop_loot/SDL = drop_type
		SDL.drop(T)
	else
		error("Unhandled drop type: 69drop_type69")


ADMIN_VERB_ADD(/datum/admins/proc/call_supply_drop, R_FUN, FALSE)
/datum/admins/proc/call_supply_drop()
	set category = "Fun"
	set desc = "Call an immediate supply drop on your location."
	set69ame = "Call Supply Drop"

	if(!check_rights(R_FUN)) return

	var/chosen_loot_type
	var/list/chosen_loot_types
	var/choice = alert("Do you wish to supply a custom loot list?",,"No","Yes")
	if(choice == "Yes")
		chosen_loot_types = list()

		choice = alert("Do you wish to add69obs?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a69ew loot path. Cancel to finish.", "Loot Selection",69ull) as69ull|anything in typesof(/mob/living)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add structures or69achines?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a69ew loot path. Cancel to finish.", "Loot Selection",69ull) as69ull|anything in typesof(/obj) - typesof(/obj/item)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add any69on-weapon items?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a69ew loot path. Cancel to finish.", "Loot Selection",69ull) as69ull|anything in typesof(/obj/item) - typesof(/obj/item)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type

		choice = alert("Do you wish to add weapons?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a69ew loot path. Cancel to finish.", "Loot Selection",69ull) as69ull|anything in typesof(/obj/item)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add ABSOLUTELY ANYTHING ELSE? (you really shouldn't69eed to)",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a69ew loot path. Cancel to finish.", "Loot Selection",69ull) as69ull|anything in typesof(/atom/movable)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
	else
		choice = alert("Do you wish to specify a loot type?",,"No","Yes")
		if(choice == "Yes")
			chosen_loot_type = input("Select a loot type.", "Loot Selection",69ull) as69ull|anything in supply_drop_random_loot_types()

	choice = alert("Are you SURE you wish to deploy this supply drop? It will cause a sizable explosion and gib anyone underneath it.",,"No","Yes")
	if(choice == "No")
		return
	log_admin("69key_name(usr)69 dropped supplies at (69usr.x69,69usr.y69,69usr.z69)")
	new /datum/random_map/droppod/supply(null, usr.x-2, usr.y-2, usr.z, supplied_drops = chosen_loot_types, supplied_drop = chosen_loot_type)
