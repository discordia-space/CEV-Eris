/mob/new_player/AIize()
	spawning = 1
	return ..()

/mob/proc/AIize(move=1)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	if(client)
		sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
	var/mob/living/silicon/ai/O = new (loc, base_law_type,,1)//No MMI but safety is in effect.
	O.aiRestorePowerRoutine = 0

	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
	else
		O.key = key

	if(move)
		var/obj/new_location = null
		for(var/turf/sloc in get_datum_spawn_locations("AI"))
			if(locate(/obj/structure/AIcore) in sloc)
				continue
			new_location = sloc
		if (!new_location)
			for(var/turf/sloc in get_datum_spawn_locations("triai"))
				if(locate(/obj/structure/AIcore) in sloc)
					continue
				new_location = sloc
		if (!new_location)
			to_chat(O, "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone.")
			new_location = pick_spawn_location("AI")

		O.forceMove(new_location)

	O.on_mob_init()

	O.add_ai_verbs()

	O.rename_self("ai",1)
	qdel(src)
	return O

//human -> robot
/mob/living/proc/Robotize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot( loc )

	if(mind)		//TODO
		mind.transfer_to(O)
		if(O.mind.assigned_role == "Robot")
			O.mind.original = O
		else if(mind && mind.antagonist.len)
			O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
	else
		O.key = key

	O.forceMove(loc)
	O.job = "Robot"
	if(O.mind.assigned_role == "Robot")
		O.mmi = new /obj/item/device/mmi(O)
		O.mmi.transfer_identity(src)

	callHook("borgify", list(O))
	O.Namepick()

	qdel(src)
	return O

/mob/living/proc/slimeize(adult as num, reproduce as num)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	var/mob/living/carbon/slime/new_slime
	if(reproduce)
		var/number = pick(14;2,3,4)	//reproduce (has a small chance of producing 3 or 4 offspring)
		var/list/babies = list()
		for(var/i=1,i<=number,i++)
			var/mob/living/carbon/slime/M = new/mob/living/carbon/slime(loc)
			M.nutrition = round(nutrition/number)
			step_away(M,src)
			babies += M
		new_slime = pick(babies)
	else
		new_slime = new /mob/living/carbon/slime(loc)
		if(adult)
			new_slime.is_adult = 1
		else
	new_slime.key = key

	to_chat(new_slime, "<B>You are now a slime. Skreee!</B>")
	qdel(src)
	return


/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	to_chat(new_mob, "You feel more... animalistic")

	qdel(src)
