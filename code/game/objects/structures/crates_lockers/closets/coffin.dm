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
	store_items = FALSE
	store_misc = FALSE //It's a coffin, not a storage bin
	var/mob/living/occupant = null
	var/on_fire = FALSE
	var/burning = null

/obj/structure/closet/coffin/pauper
	name = "pauper's coffin"
	desc = "A burial receptacle for the dearly departed. Perfect for the entire family."
	icon_state = "coffin_wide"
	matter = list(MATERIAL_WOOD = 30)
	storage_capacity = 2 * MOB_HUGE //*slaps coffin* This bad boy fits two whole Iriskas

/obj/structure/closet/coffin/close(mob/living/user)
	..()
	if(on_fire)
		add_overlay("coffin_pyre") //Otherwise the flame visual goes away from the icon changing
	for(var/mob/living/L in contents)
		//When the coffin is closed we check for mobs in it.
		if(L.mind && L.mind.key)
			//We won't check if the mob is dead yet, maybe being spaced in a coffin is an execution method
			occupant = L
			break

/obj/structure/closet/coffin/open()
	..()
	occupant = null
	if(on_fire)
		on_fire = FALSE
		deltimer(burning)
		visible_message(SPAN_NOTICE("Opening the coffin has disrupted the fire!"))

//The coffin processes when there's a mob inside
/obj/structure/closet/coffin/touch_map_edge()
	if(z in SSmapping.sealed_z_levels)
		return

	//The coffin has left the ship. Burial at space
	if(occupant && occupant.is_dead())
		var/mob/M = key2mob(occupant.mind.key)
		//We send a message to the occupant's current mob - probably a ghost, but who knows.
		to_chat(M, SPAN_NOTICE("Your remains have been committed to the void. Your crew respawn time has been reduced by [(COFFIN_RESPAWN_BONUS)/600] minutes."))
		M << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced

		//A proper funeral for the corpse allows a faster respawn
		M.set_respawn_bonus("CORPSE_HANDLING", COFFIN_RESPAWN_BONUS)

		qdel(occupant)
		qdel(src)
		return
	..()


/obj/structure/closet/coffin/proc/pyre()
	if(opened)
		close() //If someone wanted an open casket funeral, we still need the casket to close to determine occupant
	if(occupant && occupant.is_dead())
		var/mob/N = key2mob(occupant.mind.key)
		to_chat(N, SPAN_NOTICE("Your remains have been reduced to ash. Your crew respawn time has been reduced by [round(COFFIN_RESPAWN_BONUS/(1 MINUTE))] minutes."))
		N << 'sound/effects/magic/blind.ogg'
		N.set_respawn_bonus("CORPSE_HANDLING", COFFIN_RESPAWN_BONUS)
	new /obj/effect/decal/cleanable/ash(loc)
	qdel(occupant)
	qdel(src)

	return

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

/obj/structure/closet/coffin/attack_hand(mob/user)
	add_fingerprint(user)
	if(opened)
		to_chat(user, SPAN_NOTICE("You can't fit the cover back on without hammering it into place!"))
	else
		to_chat(user, SPAN_NOTICE("The cover is too heavy to lift without a prying tool!"))

/obj/structure/closet/coffin/proc/burn()
	add_overlay("coffin_pyre")
	on_fire = TRUE
	burning = addtimer(CALLBACK(src, PROC_REF(pyre), src), 60 SECONDS, TIMER_STOPPABLE) //TODO: Add TIMER_STOPPABLE to being extinguished, which involves giving reagents touch effects to structures, which they currently don't affect

/obj/structure/closet/coffin/attackby(obj/item/I, mob/user)
	if(!on_fire && isflamesource(I))
		user.visible_message(
				SPAN_WARNING("[user] has lit the [src] on fire! In a couple minutes, it and its occupant will be ash!"), \
				SPAN_WARNING("You've started the pyre, committing a poor soul unto the afterlife."), \
				SPAN_WARNING("You smell wood burning.")
			)
		burn()

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
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					user.visible_message(
							SPAN_NOTICE("[user] pried open the [src] with \the [I]."), \
							SPAN_NOTICE("You pried open the [src]."), \
							SPAN_NOTICE("You hear nails being pried from wood.")
					)
					open()
			else
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					user.visible_message(
							SPAN_NOTICE("[user] tore apart the [src] with \the [I]."), \
							SPAN_NOTICE("You pried apart the planks of the [src]."), \
							SPAN_NOTICE("You hear a something wooden being torn apart.")
					)
					drop_materials(drop_location())
					qdel(src)
			return

		if(QUALITY_SAWING)
			if(opened)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					user.visible_message(
							SPAN_NOTICE("[user] carved the [src] apart with \the [I]."), \
							SPAN_NOTICE("You carved off the planks of the [src]."), \
							SPAN_NOTICE("You hear wood being sawn.")
					)
					drop_materials(drop_location())
					qdel(src)
				return
		if(QUALITY_HAMMERING)
			if(opened)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					user.visible_message(
							SPAN_NOTICE("[user] diligently hammered the [src] cover in place with \the [I]."), \
							SPAN_NOTICE("You hammered the [src] cover on."), \
							SPAN_NOTICE("You hear nails being driven into wood.")
					)
					close()
				return
