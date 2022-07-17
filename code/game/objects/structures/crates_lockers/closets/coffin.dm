/obj/structure/closet/coffin
	name = "coffin"
	desc = "A burial receptacle for the dearly departed."
	icon_state = "coffin"
	matter = list(MATERIAL_WOOD = 10)
	spawn_blacklisted = TRUE
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_CLOSET_COFFIN
	bad_type = /obj/structure/closet/coffin
	var/mob/living/occupant = null

/obj/structure/closet/coffin/close(mob/living/user)
	..()
	for (var/mob/living/L in contents)
		//When the coffin is closed we check for mobs in it.
		if (L.mind && L.mind.key)
			//We won't check if the mob is dead yet, maybe being spaced in a coffin is an execution method
			occupant = L
			break

//The coffin processes when there's a mob inside
/obj/structure/closet/coffin/lost_in_space()
	//The coffin has left the ship. Burial at space
	if (occupant && occupant.is_dead())
		var/mob/M = key2mob(occupant.mind.key)
		//We send a message to the occupant's current mob - probably a ghost, but who knows.
		to_chat(M, SPAN_NOTICE("Your remains have been committed to the void. Your crew respawn time has been reduced by [(COFFIN_RESPAWN_BONUS)/600] minutes."))
		M << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced

		//A proper funeral for the corpse allows a faster respawn
		M.set_respawn_bonus("CORPSE_HANDLING", COFFIN_RESPAWN_BONUS)

		qdel(occupant)
		qdel(src)

	return TRUE

/obj/structure/closet/coffin/Destroy()
	occupant = null
	return ..()

/obj/structure/closet/coffin/spawnercorpse
	name = "coffin"
	desc = "A burial receptacle for the dearly departed."
	icon_state = "coffin"
	welded = 1

/obj/structure/closet/coffin/spawnercorpse/New()
	..()
	var/atom/A = pick(/obj/landmark/corpse/chef, /obj/landmark/corpse/doctor, /obj/landmark/corpse/engineer, /obj/landmark/corpse/engineer/rig, /obj/landmark/corpse/clown, \
	/obj/landmark/corpse/scientist, /obj/landmark/corpse/miner, /obj/landmark/corpse/miner/rig, /obj/landmark/corpse/bridgeofficer, /obj/landmark/corpse/commander, \
	/obj/landmark/corpse/russian)
	new A