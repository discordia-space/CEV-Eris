/**
 * Blow up the mob into giblets
 *
 * Arguments:
 * * no_brain - Should the mob NOT drop a brain?
 * * no_organs - Should the mob NOT drop organs?
 * * no_bodyparts - Should the mob NOT drop bodyparts?
*/
/mob/proc/gib(anim="gibbed-m",do_gibs)
	if(stat != DEAD)
		death(TRUE)
	transforming = TRUE
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	icon = null
	invisibility = 101
	update_lying_buckled_and_verb_status()
	GLOB.dead_mob_list -= src

	if(do_gibs)
		gibs(loc, dna)

	var/atom/movable/overlay/animation = null
	if (anim)
		animation = new(loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		FLICK(anim, animation)
	addtimer(CALLBACK(src, .proc/check_delete, animation), 15)
	qdel(src)

/mob/proc/check_delete(atom/movable/overlay/animation)
	if(!QDELETED(animation))
		qdel(animation)
	if(!QDELETED(src))
		qdel(src)

/**
 * This is the proc for turning a mob into ash.
 * Dusting robots does not eject the MMI, so it's a bit more powerful than gib()
 *
 * Arguments:
 * * just_ash - If TRUE, ash will spawn where the mob was, as opposed to remains
 * * drop_items - Should the mob drop their items before dusting?
 * * force - Should this mob be FORCABLY dusted?
*/
/mob/proc/dust(anim = "dust-m", remains = /obj/effect/decal/cleanable/ash, iconfile = 'icons/mob/mob.dmi')
	death(TRUE)

	if (istype(loc, /obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = loc
		H.release_mob()

	transforming = TRUE
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	icon = null
	invisibility = 101

	remove_from_dead_mob_list()
	var/atom/movable/overlay/animation = null
	if(anim)
		animation = new(loc)
		animation.icon_state = "blank"
		animation.icon = iconfile
		animation.master = src
		FLICK(anim, animation)
	new remains(loc)
	// tg: 5, this coderbase: 15
	QDEL_IN(src, 10) // since this is sometimes called in the middle of movement, allow half a second for movement to finish, ghosting to happen and animation to play. Looks much nicer and doesn't cause multiple runtimes.
	QDEL_IN(anim, 10)
/*
 * Called when the mob dies. Can also be called manually to kill a mob.
 *
 * Arguments:
 * * gibbed - Was the mob gibbed?
*/
/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...",show_dead_message = "You have died.")
	stat = DEAD
	unset_machine()
	timeofdeath = world.time // cannot fail, unless the time machine works
	if (isanimal(src))
		set_death_time(ANIMAL, world.time)
	else if (ispAI(src) || isdrone(src))
		set_death_time(MINISYNTH, world.time)
	else if (isliving(src))
		set_death_time(CREW, world.time)//Crew is the fallback
	var/tod = stationtime2text() //station_time_timestamp()
	// var/turf/T = get_turf(src)
	// if(mind && mind.name && mind.active && !istype(T.loc, /area/ctf))
	// 	deadchat_broadcast(" has died at <b>[get_area_name(T)]</b>.", "<b>[mind.name]</b>", follow_target = src, turf_target = T, message_type=DEADCHAT_DEATHRATTLE)
	if(mind)
		mind.store_memory("Time of death: [tod]", 0)
	// set_drugginess(0)
	// set_disgust(0)
	SetSleeping(0) //, 0)
	// reset_perspective(null)
	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_in_dark(8)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
	// reload_fullscreen()
	// update_action_buttons_icon()
	// update_damage_hud()
	// update_health_hud()
	// med_hud_set_health()
	// med_hud_set_status()
	stop_pulling()
	update_lying_buckled_and_verb_status()
	reset_plane_and_layer()

	SEND_SIGNAL(src, COMSIG_LIVING_DEATH, gibbed)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_DEATH, src, gibbed)

	facing_dir = null

	if(!gibbed && deathmessage != "no message") // This is gross, but reliable. Only brains use it.
		visible_message("<b>\The [src.name]</b> [deathmessage]")

	// Drop all embedded items if gibbed/dusted
	if(gibbed)
		for(var/obj/O in embedded)
			O.forceMove(loc)
		embedded = list()

	for(var/mob/living/carbon/human/H in oviewers(src))
		H.sanity.onSeeDeath(src)
		SEND_SIGNAL(H, COMSIG_MOB_DEATH, src) // LOCAL death

	for(var/obj/item/weapon/implant/carrion_spider/control/C in src)
		C.return_mind()

	drop_r_hand()
	drop_l_hand()

	//Bay statistics (cringe) system would be hooked in here, but we're not porting it
	if(isliving(src))
		var/mob/living/L = src
		if(L.HUDneed.Find("health"))
			var/obj/screen/health/H = L.HUDneed["health"]
			//H.icon_state = "health7" hm... need recode this moment...
			H.DEADelize()
	if(client)
		kill_CH() //We dead... clear any prepared abilities... (don't worry, our OWN click handler is still alive)

	switch_from_living_to_dead_mob_list()
	updateicon()
	to_chat(src,"<span class='deadsay'>[show_dead_message]</span>")

	return TRUE


//This proc retrieves the relevant time of death from
/mob/proc/get_death_time(var/which)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE

	return P.time_of_death[which]

/mob/proc/set_death_time(var/which, var/value)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE
	P.time_of_death[which] = value
	return 1



//These functions get and set the bonuses to respawn time
//Bonuses can be applied by things like going to cryosleep
/mob/proc/get_respawn_bonus(var/which)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE

	if (which)
		return P.crew_respawn_bonuses[which]
	else
		//Passing in no specific request will instead return the total of all the respawn bonuses
		//This behaviour is utilised in mayrespawn
		var/total = 0
		for (var/v in P.crew_respawn_bonuses)
			total += P.crew_respawn_bonuses[v]
		return total

/mob/proc/set_respawn_bonus(var/which, var/value)
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE
	P.crew_respawn_bonuses[which] = value
	return 1

//Wipes all respawn bonuses. Called when a player actually respawns
/mob/proc/clear_respawn_bonus()
	var/datum/preferences/P = get_preferences(src)
	if (!P)
		return FALSE
	P.crew_respawn_bonuses.Cut()
	return 1
