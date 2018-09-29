//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim="gibbed-m",do_gibs)
	death(1)
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	update_canmove()
	dead_mob_list -= src

	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	if(do_gibs) gibs(loc, dna)

	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(anim="dust-m",remains=/obj/effect/decal/cleanable/ash, iconfile = 'icons/mob/mob.dmi')
	death(1)
	if (istype(loc, /obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = loc
		H.release_mob()

	var/atom/movable/overlay/animation = null
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = iconfile
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	dead_mob_list -= src
	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)


/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...")

	if(stat == DEAD)
		return 0

	facing_dir = null

	if(!gibbed && deathmessage != "no message") // This is gross, but reliable. Only brains use it.
		src.visible_message("<b>\The [src.name]</b> [deathmessage]")

	stat = DEAD

	update_canmove()

	layer = MOB_LAYER

/*	if(blind && client)
		blind.alpha = 0*/

	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	drop_all_hands()

	//TODO:  Change death state to health_dead for all these icon files.  This is a stop gap.
/*
	if(healths)
		if("health7" in icon_states(healths.icon))
			healths.icon_state = "health7"
		else
			healths.icon_state = "health6"
			log_debug("[src] ([src.type]) died but does not have a valid health7 icon_state (using health6 instead). report this error to Ccomp5950 or your nearest Developer")
*/
	if(isliving(src))
		var/mob/living/L = src
		if(L.HUDneed.Find("health"))
			var/obj/screen/health/H = L.HUDneed["health"]
			//H.icon_state = "health7" hm... need recode this moment...
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
		mind.store_memory("Time of death: [stationtime2text()]", 0)
	living_mob_list -= src
	dead_mob_list |= src

	updateicon()

	return 1




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