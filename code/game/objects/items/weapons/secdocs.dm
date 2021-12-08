/obj/item/oddity/secdocs
	name = "science data"
	desc = "A folder containing some papers with important scientific data."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "folder"
	price_tag = 5000

	oddity_stats = list(
		STAT_MEC = 8,
		STAT_COG = 8,
		STAT_BIO = 8,
	)

	var/static/inv_spawn_count = 3

/obj/item/oddity/secdocs/Initialize()
	icon_state = "folder-[pick("omega","psi","theta")]"
	name = pick("Attractor field theory",
				"World lines theory",
				"Evidence of an outside-context problem",
				"On the use of self-learning AI for public administration",
				"Evidence of time travel related changes in history",
				"Geography of nonexistent cities",
				"Production of Alliance nanomachines",
				"Known SAU equipment specifications",
				"Known access points to Discordia",
				"The Door phenomenon",
				"Parallel world-related mutations",
				"Mass hallucinations or breach from another world?",
				"Ironhammer budget: evidence of SAU overfund",
				"The truth behind the fall of One Star",
				"Are we next? The connection between One Star and dead alien civilizations",
				"Unknown device blueprints")
	. = ..()
	var/mob/living/carbon/human/owner = loc
	if(istype(owner))
		to_chat(owner, SPAN_NOTICE("You have valuable scientific data on your person. Do not let it fall into the wrong hands."))

/hook/roundstart/proc/place_docs()
	var/list/obj/landmark/storyevent/midgame_stash_spawn/L = list()
	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in GLOB.landmarks_list)
		L.Add(S)

	L = shuffle(L)

	if(L.len < 3)
		warning("Failed to place secret documents: not enough landmarks.")
		return FALSE

	for(var/i in 1 to 3)
		new /obj/item/oddity/secdocs(L[i].get_loc())

	return TRUE
