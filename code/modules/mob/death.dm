//This is the proc for gibbing a69ob. Cannot gib ghosts.
//added different sort of gibs and animations.69
/mob/proc/gib(anim="gibbed-m",do_gibs)
	death(1)
	transforming = TRUE
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	icon =69ull
	invisibility = 101
	update_lying_buckled_and_verb_status()
	GLOB.dead_mob_list -= src

	if(do_gibs) gibs(loc, dna)

	var/atom/movable/overlay/animation =69ull
	if (anim)
		animation =69ew(loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick(anim, animation)
	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)

/mob/proc/check_delete(var/atom/movable/overlay/animation)
	if(animation)	qdel(animation)
	if(src)			qdel(src)

//This is the proc for turning a69ob into ash.69ostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the69irus code since it's irrelevant here.
//Dusting robots does69ot eject the69MI, so it's a bit69ore powerful than gib() /N
/mob/proc/dust(anim = "dust-m", remains = /obj/effect/decal/cleanable/ash, iconfile = 'icons/mob/mob.dmi')
	death(1)
	if (istype(loc, /obj/item/holder))
		var/obj/item/holder/H = loc
		H.release_mob()

	transforming = TRUE
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	icon =69ull
	invisibility = 101

	new remains(loc)

	remove_from_dead_mob_list()
	var/atom/movable/overlay/animation =69ull
	if(anim)
		animation =69ew(loc)
		animation.icon_state = "blank"
		animation.icon = iconfile
		animation.master = src
		flick(anim, animation)
	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)


/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...",show_dead_message = "You have died.")
	if(stat == DEAD)
		return 0

	facing_dir =69ull

	if(!gibbed && deathmessage != "no69essage") // This is gross, but reliable. Only brains use it.
		src.visible_message("<b>\The 69src.name69</b> 69deathmessage69")

	// Drop all embedded items if gibbed/dusted
	if(gibbed)
		for(var/obj/O in embedded)
			O.forceMove(loc)
		embedded = list()

	for(var/mob/living/carbon/human/H in oviewers(src))
		H.sanity.onSeeDeath(src)
		SEND_SIGNAL(H, COMSIG_MOB_DEATH, src)

	stat = DEAD
	for(var/obj/item/implant/carrion_spider/control/C in src)
		C.return_mind()

	update_lying_buckled_and_verb_status()
	reset_plane_and_layer()

	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	drop_r_hand()
	drop_l_hand()

	//Bay statistics system would be hooked in here, but we're69ot porting it


	if(isliving(src))
		var/mob/living/L = src
		if(L.HUDneed.Find("health"))
			var/obj/screen/health/H = L.HUDneed69"health"69
			//H.icon_state = "health7" hm...69eed recode this69oment...
			H.DEADelize()
	if(client)
		kill_CH() //We dead... clear any prepared abilities...

	timeofdeath = world.time
	if (isanimal(src))
		set_death_time(ANIMAL, world.time)
	else if (ispAI(src) || isdrone(src))
		set_death_time(MINISYNTH, world.time)
	else if (isliving(src))
		set_death_time(CREW, world.time)//Crew is the fallback
	if(mind)
		mind.store_memory("Time of death: 69stationtime2text()69", 0)
	switch_from_living_to_dead_mob_list()
	updateicon()
	to_chat(src,"<span class='deadsay'>69show_dead_message69</span>")
	return 1




//This proc retrieves the relevant time of death from
/mob/proc/get_death_time(var/which)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE

	return P.time_of_death69which69

/mob/proc/set_death_time(var/which,69ar/value)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE
	P.time_of_death69which69 =69alue
	return 1



//These functions get and set the bonuses to respawn time
//Bonuses can be applied by things like going to cryosleep
/mob/proc/get_respawn_bonus(var/which)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE

	if (which)
		return P.crew_respawn_bonuses69which69
	else
		//Passing in69o specific request will instead return the total of all the respawn bonuses
		//This behaviour is utilised in69ayrespawn
		var/total = 0
		for (var/v in P.crew_respawn_bonuses)
			total += P.crew_respawn_bonuses69v69
		return total

/mob/proc/set_respawn_bonus(var/which,69ar/value)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE
	P.crew_respawn_bonuses69which69 =69alue
	return 1

//Wipes all respawn bonuses. Called when a player actually respawns
/mob/proc/clear_respawn_bonus()
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE
	P.crew_respawn_bonuses.Cut()
	return 1