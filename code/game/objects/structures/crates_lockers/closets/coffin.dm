/obj/structure/closet/coffin
	name = "coffin"
	desc = "A burial receptacle for the dearly departed."
	icon_state = "coffin"
	matter = list(MATERIAL_WOOD = 10)
	spawn_blacklisted = TRUE
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_ta69s = SPAWN_TA69_CLOSET_COFFIN
	bad_type = /obj/structure/closet/coffin
	var/mob/livin69/occupant = null

/obj/structure/closet/coffin/close(mob/livin69/user)
	..()
	for (var/mob/livin69/L in contents)
		//When the coffin is closed we check for69obs in it.
		if (L.mind && L.mind.key)
			//We won't check if the69ob is dead yet,69aybe bein69 spaced in a coffin is an execution69ethod
			occupant = L
			break

//The coffin processes when there's a69ob inside
/obj/structure/closet/coffin/lost_in_space()
	//The coffin has left the ship. Burial at space
	if (occupant && occupant.is_dead())
		var/mob/M = key2mob(occupant.mind.key)
		//We send a69essa69e to the occupant's current69ob - probably a 69host, but who knows.
		to_chat(M, SPAN_NOTICE("Your remains have been committed to the69oid. Your crew respawn time has been reduced by 1569inutes."))
		M << 'sound/effects/ma69ic/blind.o6969' //Play this sound to a player whenever their respawn time 69ets reduced

		//A proper funeral for the corpse allows a faster respawn
		M.set_respawn_bonus("CORPSE_HANDLIN69", 1569INUTES)

		69del(occupant)
		69del(src)

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
	var/atom/A = pick(/obj/landmark/corpse/chef, /obj/landmark/corpse/doctor, /obj/landmark/corpse/en69ineer, /obj/landmark/corpse/en69ineer/ri69, /obj/landmark/corpse/clown, \
	/obj/landmark/corpse/scientist, /obj/landmark/corpse/miner, /obj/landmark/corpse/miner/ri69, /obj/landmark/corpse/brid69eofficer, /obj/landmark/corpse/commander, \
	/obj/landmark/corpse/russian)
	new A