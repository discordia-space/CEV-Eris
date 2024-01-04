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
				"Unknown device blueprints",
				"Psionic and bluespace relativity",
				"Data teleportation with the use of bluespace",
				"Synthesization of darkmatter",
				"Bluespace local-continuum energy extraction",
				"Is god real? On the origin of cruciforms",
				"Non-relativistic bluespace phenomenons",
				"Moebius technologies, evidence of unethical mind experimentation",
				"Psionics, innate force within all bluespace entities",
				"Effects of teleportation, entanglement with one's bluespace copy",
				"On the existence of carrion's and their population within major social hubs",
				"Hacking methods using excelsior brute-forcing methods",
				"On the presence of bluespace waves in galaxies",
				"Hanza hierarchy study, a shadow government?",
				"Old Earth and Serbians. The effects of military equipment in the hands of pirates on space trade",
				"Psionics, found to be a common trait amongst one-star citizens",
				"Freezing light using bluespace lasers. Applications for increased-capacity battery cells.",
				"Interspecies wars, study into why they started.",
				"Aster's guild and the link between the new bluespace combat operatives."
				"Increase of brain-size correlates with insanity. Empirical study into the link between insanity and high intelligence",
				"Mental instability and brain-modifying drugs found to play a crucial part in the acquisition of psionic powers",
	)


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
