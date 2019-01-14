/datum/faction/excelsior
	id = FACTION_EXCELSIOR
	name = "Excelsior"
	antag = "infiltrator"
	antag_plural = "infiltrators"
	welcome_text = "You are an excelsior infiltrator, here to take over the ship. It will be a long and difficult process.\n\
	Your strengths lie in manufacturing, production and defense, excelsior are not built for an early rush.\n\n\
	Your first goal is to retrieve your stash, it contains powerful circuitry you will need to found your base\n\n\
	After that, your second priority is to establish a secret base, somewhere nobody will detect you. Build your autolathe and teleporter, create turrets and shield generators to defend them. \n\n\
	Your third goal is to expand. Steal implants, prosthetics or robotic parts and convert them into new implants. recruit new allies and manufacture equipment for them. Send them out to scavenge for useful parts for manufacturing.\n\n\
	When you are ready, your ultimate goal is to overthrow all the heads of staff, and take control of the ship."

	hud_indicator = "hudexcelsior"

	possible_antags = list(ROLE_EXCELSIOR_REV)
	verbs = list(/datum/faction/excelsior/proc/communicate_verb)


/datum/faction/excelsior/create_objectives()
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
	new /obj/item/weapon/circuitboard/excelsiorautolathe(LM)
	new /obj/item/weapon/circuitboard/excelsior_teleporter(LM)

	for (var/datum/antagonist/A in members)
		A.owner.current << SPAN_NOTICE("Use your excelsior supply stash. [landmark.navigation]")
		A.owner.store_memory("Excelsior stash. [landmark.navigation]")



	for(var/datum/mind/M in SSticker.minds)
		if (M in members)
			continue

		if(M.assigned_role in list(JOBS_COMMAND))
			new /datum/objective/faction/excelsior(src, M)



	.=..()

/datum/faction/excelsior/proc/communicate_verb()

	set name = "Excelsior comms"
	set category = "Cybernetics"

	if(!ishuman(usr))
		return

	var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)

	if(!F)
		return

	F.communicate(usr)
