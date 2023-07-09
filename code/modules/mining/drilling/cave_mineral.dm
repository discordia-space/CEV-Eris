/turf/simulated/cave_mineral //wall piece
	name = "Rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = TRUE
	layer = EDGED_TURF_LAYER
	blocks_air = 1
	temperature = T0C
	var/mined_turf = /turf/simulated/floor/asteroid
	var/ore/mineral
	var/mineral_name
	var/mined_ore = 0

	has_resources = 1

/turf/simulated/cave_mineral/Initialize()
	.=..()
	if (mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	icon_state = "rock[rand(0,4)]"

/turf/simulated/cave_mineral/can_build_cable()
	return !density

/turf/simulated/cave_mineral/is_plating()
	return TRUE

/turf/simulated/cave_mineral/explosion_act(target_power, explosion_handler/handler)
	. = ..()
	if(src && target_power > 75)
		mined_ore = 1
		GetDrilled()

/turf/simulated/cave_mineral/Bumped(AM)
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

/turf/simulated/cave_mineral/proc/UpdateMineral()
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
/turf/simulated/cave_mineral/attackby(obj/item/I, mob/living/user)

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

/turf/simulated/cave_mineral/proc/clear_ore_effects()
	for(var/obj/effect/mineral/M in contents)
		qdel(M)

/turf/simulated/cave_mineral/proc/DropMineral()
	if(!mineral)
		return
	clear_ore_effects()
	var/obj/item/ore/O = new mineral.ore (src)
	return O

/turf/simulated/cave_mineral/proc/GetDrilled()

	if (mineral && mineral.result_amount)
		// If the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	// Add some rubble, you did just clear out a big chunk of rock.
	var/turf/simulated/floor/asteroid/N = ChangeTurf(mined_turf)
	if(istype(N))
		N.overlay_detail = "asteroid[rand(0,9)]"
		N.updateMineralOverlays(1)

/turf/simulated/cave_mineral/proc/check_radial_dig()
	return TRUE

// SUBTYPES FOR EACH MINERAL

/turf/simulated/cave_mineral/carbon
	mineral_name = ORE_CARBON

/turf/simulated/cave_mineral/iron
	mineral_name = ORE_IRON

/turf/simulated/cave_mineral/plasma
	mineral_name = ORE_PLASMA

/turf/simulated/cave_mineral/sand
	mineral_name = ORE_SAND

/turf/simulated/cave_mineral/uranium
	mineral_name = ORE_URANIUM

/turf/simulated/cave_mineral/diamond
	mineral_name = ORE_DIAMOND

/turf/simulated/cave_mineral/silver
	mineral_name = ORE_SILVER

/turf/simulated/cave_mineral/gold
	mineral_name = ORE_GOLD

/turf/simulated/cave_mineral/platinum
	mineral_name = ORE_PLATINUM
