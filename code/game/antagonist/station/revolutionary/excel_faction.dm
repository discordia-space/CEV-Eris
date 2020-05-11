/datum/faction/excelsior
	id = FACTION_EXCELSIOR
	name = "Excelsior"
	antag = "infiltrator"
	antag_plural = "infiltrators"
	welcome_text = "You are Excelsior, Ever Upward. You have infiltrated this vessel to further the Revolution.\n\
    The People's strength lies in securing our position, gathering the oppressed, and producing arms and armor for the final revolution. A slow and methodical approach is recommended. \n\n\
    Our first phase is to retrieve the cache of manufacturing materials and circuit boards. Without a means of production our revolution is in peril.\n\n\
    Our second phase is to establish a fortified position in secret. The People will send additional resources through the teleporter once it is established. This and our autolathe can be protected further with turrets and shield generators, in addition to loyal comrades.\n\n\
    Our third phase is expansion. Aquire implants, prosthetics or robotic parts and convert them into new implants. These can be injected into the oppressed to formally induct them to the Revolution. Use their labor to produce the weapons of their liberation.\n\n\
    When the People are ready, break the chains of the oppressor and seize control of the ship"

	hud_indicator = "excelsior"

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

	new /obj/item/weapon/computer_hardware/hard_drive/portable/design/excelsior(LM)
	new /obj/item/weapon/circuitboard/excelsiorautolathe(LM)
	new /obj/item/weapon/circuitboard/excelsior_teleporter(LM)

	for (var/datum/antagonist/A in members)
		to_chat(A.owner.current, SPAN_NOTICE("Use your excelsior supply stash. [landmark.navigation]"))
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
