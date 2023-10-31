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
	var/on_fire = FALSE

/obj/structure/closet/coffin/pauper
	name = "pauper's coffin"
	desc = "A burial receptacle for the dearly departed. Perfect for the entire family."
	icon_state = "coffin_wide"
	matter = list(MATERIAL_WOOD = 30)
	storage_capacity = 2 * MOB_HUGE //*slaps coffin* This bad boy fits two whole Iriskas

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
		qdel(contents)
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

/obj/structure/closet/coffin/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(opened)
		to_chat(user, SPAN_NOTICE("You can't fit the cover back on without hammering it into place!"))
	if(!opened)
		to_chat(user, SPAN_NOTICE("The cover is too heavy to lift without a prying tool!"))

/obj/structure/closet/coffin/proc/pyre(atom/movable/object)
	add_overlay("coffin_pyre")
	on_fire = 1
	anchored = 1
	sleep(600) //One minute to burn, for theatrics
	new /obj/effect/decal/cleanable/ash(loc)
	if(occupant)
		lost_in_space()

/obj/structure/closet/coffin/attackby(obj/item/I, mob/user)
	if(on_fire)
		to_chat(user, SPAN_NOTICE("The pyre is already lit. There's no turning back."))
		return
	if(!on_fire && isflamesource(I))
		user.visible_message(SPAN_WARNING("[user] has lit the [src] on fire!"))
		pyre()
	
	var/list/usable_qualities = list()
	if(opened)
		usable_qualities += QUALITY_SAWING
		usable_qualities += QUALITY_PRYING
		usable_qualities += QUALITY_HAMMERING
	if(!opened)
		usable_qualities += QUALITY_PRYING

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_PRYING)
			if(!opened)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					visible_message(
							SPAN_NOTICE("\The [src] has been pried open by [user] with \the [I]."),
							"You hear [tool_type]."
					)
					open()
			else
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					visible_message(
							SPAN_NOTICE("\The [src] has been pried apart by [user] with \the [I]."),
							"You hear [tool_type]."
					)
					drop_materials(drop_location())
					qdel(src)
			return

		if(QUALITY_SAWING)
			if(opened)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					visible_message(
							SPAN_NOTICE("\The [src] has been cut apart by [user] with \the [I]."),
							"You hear [tool_type]."
					)
					drop_materials(drop_location())
					qdel(src)
				return
		if(QUALITY_HAMMERING)
			if(opened)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					visible_message(
							SPAN_NOTICE("\The [src] has had it's cover secured by [user] with \the [I]."),
							"You hear [tool_type]."
					)
					close()
				return
