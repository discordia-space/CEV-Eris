/datum/faction/revolutionary
	id = null
	faction_invisible = FALSE
	hud_indicator = "rev"

/datum/faction/revolutionary/create_objectives()
	objectives.Cut()


	//Create the Excelsior Stash
	var/obj/landmark/storyevent/midgame_stash_spawn/landmark = null

	var/list/L = list()
	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in landmarks_list)
		L.Add(S)

	L = shuffle(L)

	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in L)
		if(!S.is_visible())
			landmark = S
			break

	if(!landmark)
		return FALSE


	var/turf/LM = landmark.get_loc()

	new /obj/item/weapon/disk/autolathe_disk/excelsior(LM)
	new /obj/item/weapon/circuitboard/autolathe(LM)
	new /obj/item/weapon/circuitboard/excelsior_teleporter(LM)

	for (var/datum/antagonist/A in members)
		A.owner.current << SPAN_NOTICE("Use your excelsior supply stash. [landmark.navigation]")
		A.owner.store_memory("Excelsior stash. [landmark.navigation]")



	var/has = FALSE
	for(var/datum/mind/M in SSticker.minds)
		if(M.assigned_role in list(JOBS_COMMAND))
			has = TRUE
			var/datum/objective/faction/rev/excelsior/O = new(src)
			O.set_target(M)

	if(!has)
		new /datum/objective/faction/rev/excelsior(src)

	.=..()
