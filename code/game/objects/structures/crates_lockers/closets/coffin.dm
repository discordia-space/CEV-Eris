/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	var/mob/living/occupant = null


/obj/structure/closet/coffin/close(mob/living/user)
	..()
	for (var/mob/living/L in contents)
		//When the coffin is closed we check for mobs in it.
		//If there's a mob in here that was once a player, then we start processing
		if (L.mind && L.mind.key)
			//We won't check if the mob is dead yet, maybe being spaced in a coffin is an execution method
			occupant = L
			break

	if (occupant)
		START_PROCESSING(SSobj, src)


//The coffin processes when there's a mob inside
/obj/structure/closet/coffin/Process()
	if (!occupant || QDELETED(occupant) || occupant.loc != src)
		return PROCESS_KILL

	var/turf/T = get_turf(src)
	if (!(T.z in maps_data.station_levels))
		//The coffin has left the ship. Burial at space
		if (occupant && occupant.stat == DEAD)

			var/mob/M = key2mob(occupant.mind.key)
			//We send a message to the occupant's current mob - probably a ghost, but who knows.
			M << SPAN_NOTICE("Your remains have been committed to the void. Your crew respawn time has been reduced by 15 minutes.")
			M << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced

			//A proper funeral for the corpse allows a faster respawn
			M.set_respawn_bonus("CORPSE_HANDLING", 15 MINUTES)

			qdel(occupant)
			qdel(src)

/obj/structure/closet/coffin/Destroy()

	occupant = null
	STOP_PROCESSING(SSobj, src)
	return ..()