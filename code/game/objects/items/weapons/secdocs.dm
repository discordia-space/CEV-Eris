/obj/item/weapon/secdocs
	name = "science data"
	desc = "Folder contains some papers with important science data."
	icon = 'icons/obj/items.dmi'
	icon_state = "scifolder0"
	var/obj/landmark/storyevent/midgame_stash_spawn/landmark = null

/obj/item/weapon/secdocs/New()
	icon_state = "scifolder[rand(0,3)]"
	name = pick("Atractor fields theory",
				"World lines theory",
				"Outside context problem evidence",
				"Use of self-learning AI for public administration",
				"Evidence of time travel related changes in history",
				"Geograpfy of non existent cyties",
				"Production of Alliance nanomachines",
				"Known S.A.U. equipment specifications",
				"Known access points to Discordia",
				"The Door phenomenon",
				"Paralell world related mutations",
				"Mass hallucinations or a breach from another world?",
				"Ironhammer budget: evidence of S.A.U. overfund",
				"Real reason of Alliance fall",
				"Connection between Alliance and dead alien civilizations, are we next?",
				"Unknown device blueprints")

/obj/item/weapon/secdocs/proc/place_docs()
	var/list/L = list()
	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in landmarks_list)
		L.Add(S)

	L = shuffle(L)

	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in L)
		if(!S.is_visible())
			landmark = S
			break

	forceMove(landmark.get_loc())


//Interaction benefits code might be here, but no
