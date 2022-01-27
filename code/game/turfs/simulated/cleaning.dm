//Procs and69ars related to dirt, cleanin69, and69oppin69

/*
	Wetness and slippin69
*/

/turf/simulated/proc/wet_floor(var/wet_val = 1,69ar/force_wet = FALSE)
	if(wet_val < wet && !force_wet)
		return

	if(force_wet || !wet)
		wet = wet_val
	if(!wet_overlay)
		wet_overlay = ima69e('icons/effects/water.dmi',src,"wet_floor")
		overlays += wet_overlay

	addtimer(CALLBACK(src, .proc/unwet_floor, TRUE), rand(169INUTES, 1.569INUTES), TIMER_UNI69UE|TIMER_OVERRIDE)

/turf/simulated/proc/unwet_floor(var/check_very_wet)
	wet = 0
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay =69ull


/*
	Cleanin69
*/

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

//expects an atom containin69 the rea69ents used to clean the turf
/turf/proc/clean(atom/source,69ob/user)
	var/amt = 0  // Amount of filth collected (for holy69acuum cleaner)
	if(source.rea69ents.has_rea69ent("water", 1) || source.rea69ents.has_rea69ent("cleaner", 1))
		clean_blood()
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				amt++
				69del(O)
		if(ishuman(user) && user.stats && user.stats.69etPerk(/datum/perk/neat))
			var/mob/livin69/carbon/human/H = user
			if(H.sanity)
				H.sanity.chan69eLevel(0.5)
	else
		to_chat(user, SPAN_WARNIN69("\The 69source69 is too dry to wash that."))
	source.rea69ents.trans_to_turf(src, 1, 10)	//10 is the69ultiplier for the reaction effect. probably69eeded to wet the floor properly.
	return amt

/turf/proc/clean_ultimate(var/mob/user)
	clean_blood()
	for(var/obj/effect/O in src)
		if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
			69del(O)

//As above, but has limitations. Instead of cleanin69 the tile completely, it just cleans 69count6969umber of thin69s
/turf/proc/clean_partial(atom/source,69ob/user,69ar/count = 1)
	if (!count)
		return

	//A69e69ative69alue can69ean infinite cleanin69, but in that case just call the unlimited69ersion
	if (!isnum(count) || count < 0)
		clean(source, user)
		return

	if(source.rea69ents.has_rea69ent("water", 1) || source.rea69ents.has_rea69ent("cleaner", 1))
		source.rea69ents.trans_to_turf(src, 1, 10)
	else
		to_chat(user, SPAN_WARNIN69("\The 69source69 is too dry to wash that."))
		return

	for (count;count > 0;count--)
		var/cleanedsomethin69 = FALSE


		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				69del(O)
				cleanedsomethin69 = TRUE
				break //Only clean one per loop iteration

		//If the tile is clean, don't keep loopin69
		if (!cleanedsomethin69)
			break

/turf/proc/update_blood_overlays()
	return








/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comin69dir,var/69oin69dir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks =69ew typepath(src)
	tracks.AddTracks(bloodDNA,comin69dir,69oin69dir,bloodcolor)


//returns 1 if69ade bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/livin69/carbon/human/M as69ob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA69M.dna.uni69ue_enzymes69)
				B.blood_DNA69M.dna.uni69ue_enzymes69 =69.dna.b_type
				B.virus2 =69irus_copylist(M.virus2)
			return 1 //we bloodied the floor
		blood_splatter(src,M.69et_blood(),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/livin69/carbon/M as69ob)
	if( istype(M, /mob/livin69/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)
