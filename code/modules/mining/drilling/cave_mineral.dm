/turf/floor/asteroid/cave
	// Low pressure version of /turf/floor/asteroid
	oxygen = 14
	nitrogen = 23

/turf/impassable_rock
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = TRUE
	layer = CLOSED_TURF_LAYER
	blocks_air = 1
	temperature = T0C

/turf/impassable_rock/Initialize()
	.=..()
	icon_state = "rock[rand(0,4)]"

/turf/cave_mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 14
	nitrogen = 23
	opacity = 1
	density = TRUE
	layer = CLOSED_TURF_LAYER
	blocks_air = 1
	temperature = T0C
	var/mined_turf = /turf/floor/asteroid/cave
	var/ore/mineral
	var/mineral_name
	var/mined_ore = 0
	var/seismic_multiplier = 1

	has_resources = 1

/turf/cave_mineral/Initialize()
	.=..()
	if (mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	icon_state = "rock[rand(0,4)]"

/turf/cave_mineral/can_build_cable()
	return !density

/turf/cave_mineral/is_plating()
	return TRUE

/turf/cave_mineral/explosion_act(target_power, explosion_handler/handler)
	. = ..()
	if(src && target_power > 75)
		mined_ore = 1
		GetDrilled()

/turf/cave_mineral/Bumped(AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(istype(H.l_hand,/obj/item))
			var/obj/item/I = H.l_hand
			if((QUALITY_DIGGING in I.tool_qualities) && (!H.hand))
				attackby(I,H)
		if(istype(H.r_hand,/obj/item))
			var/obj/item/I = H.r_hand
			if((QUALITY_DIGGING in I.tool_qualities) && (H.hand))
				attackby(I,H)

	else if(isrobot(AM))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item))
			var/obj/item/I = R.module_active
			if(QUALITY_DIGGING in I.tool_qualities)
				attackby(I,R)

	else if(istype(AM,/mob/living/exosuit))
		var/mob/living/exosuit/M = AM
		if(istype(M.selected_hardpoint, /obj/item/mech_equipment/drill))
			var/obj/item/mech_equipment/drill/D = M.selected_hardpoint
			D.afterattack(src)

/turf/cave_mineral/proc/UpdateMineral()
	clear_ore_effects()
	if(!mineral)
		name = "\improper Rock"
		icon_state = "rock"
		return
	name = "\improper [mineral.display_name] deposit"
	var/obj/effect/mineral/M = new /obj/effect/mineral(src, mineral)
	spawn(1)
		M.color = color

//Not even going to touch this pile of spaghetti
/turf/cave_mineral/attackby(obj/item/I, mob/living/user)

	var/tool_type = I.get_tool_type(user, list(QUALITY_DIGGING), src, CB = CALLBACK(src, PROC_REF(check_radial_dig)))
	switch(tool_type)
		if(QUALITY_DIGGING)
			to_chat(user, SPAN_NOTICE("You start digging the [src]."))
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_ROB))
				to_chat(user, SPAN_NOTICE("You finish digging the [src]."))
				GetDrilled()
			return
		if(ABORT_CHECK)
			return
		else
			return ..()

/turf/cave_mineral/proc/clear_ore_effects()
	for(var/obj/effect/mineral/M in contents)
		qdel(M)

/turf/cave_mineral/proc/DropMineral()
	if(!mineral)
		return
	for (var/i = 1 to seismic_multiplier)
		new mineral.ore(src)

/turf/cave_mineral/proc/GetDrilled()

	if (mineral && mineral.result_amount)
		// If the turf has already been excavated, some of it's ore has been removed
		clear_ore_effects()
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	// Add some rubble, you did just clear out a big chunk of rock.
	var/turf/floor/asteroid/cave/N = ChangeTurf(mined_turf)
	if(istype(N))
		N.overlay_detail = "asteroid[rand(0,9)]"
		N.updateMineralOverlays(1)

/turf/cave_mineral/proc/check_radial_dig()
	return TRUE

// SUBTYPES FOR EACH MINERAL

/turf/cave_mineral/carbon
	mineral_name = ORE_CARBON

/turf/cave_mineral/iron
	mineral_name = ORE_IRON

/turf/cave_mineral/plasma
	mineral_name = ORE_PLASMA

/turf/cave_mineral/uranium
	mineral_name = ORE_URANIUM

/turf/cave_mineral/diamond
	mineral_name = ORE_DIAMOND

/turf/cave_mineral/silver
	mineral_name = ORE_SILVER

/turf/cave_mineral/gold
	mineral_name = ORE_GOLD

/turf/cave_mineral/platinum
	mineral_name = ORE_PLATINUM
