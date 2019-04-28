/obj/item/weapon/floor_shocker
	var/power_source
	var/got_cell = FALSE
	var/obj/parent
	var/deployed = FALSE
	var/active = FALSE

	var/passive_power_use = 50
	var/radius = 2

	icon = 'icons/obj/floor_shocker.dmi'
	icon_state = "sapper"
	name = "floor mounted shocker"
	desc = "A nasty sapper that electrifies floors around."
	layer = LOW_OBJ_LAYER
	var/turf_overlay_image

/obj/item/weapon/floor_shocker/New()
	turf_overlay_image = image(icon, "overlay_turf")
	..()

/obj/item/weapon/floor_shocker/Process()
	if(!anchored) return
	if(!active) return
	if(!power_source) return
	for(var/mob/living/mob in range(src, radius))
		fire(mob)

/obj/item/weapon/floor_shocker/attackby(var/obj/item/I, var/mob/living/user, var/params)
	if(fire(user, TRUE))
		return FALSE
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/cell/large))
		if(!got_cell && power_source)
			to_chat(user, "You added cell to shocker.")
			user.drop_item()
			I.forceMove(src)
			power_source = I
			got_cell = TRUE
			update_icon()
			return
	var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING)
			if(active)
				to_chat(user, SPAN_WARNING("Turn it off first!"))
				return
			var/turf/turf = get_turf(src)
			var/obj/structure/cable/C = turf.get_cable_node()
			if(!got_cell & !power_source)
				if(!C)
					to_chat(user, "You need to set up proper wiring there.")
					return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You [anchored?"un":""]anchored [src] [anchored?"from":"to"] floor."))
				anchored = !anchored
				if(!got_cell)
					if(!anchored)
						power_source = null
					else
						power_source = C.powernet
				update_icon()
			return
		if(QUALITY_SCREW_DRIVING)
			if(active)
				to_chat(user, SPAN_WARNING("Turn it off first!"))
				return
			if(!got_cell)
				to_chat(user, SPAN_WARNING("There is nothing to do!"))
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You detached cell from [src]"))
				var/obj/item/cell = power_source
				cell.forceMove(get_turf(user))
				power_source = null
				update_icon()
			return
	return ..()
/obj/item/weapon/floor_shocker/attack_self(var/mob/living/carbon/human/user)
	if(anchored || deployed)//how the fuck.
		CRASH()
		return FALSE
	var/turf/turf = get_step(get_turf(user), user.dir)
	var/obj/structure/table/table = locate(/obj/structure/table/) in turf
	if(table)
		if(table.material)
			if(table.material == MATERIAL_STEEL \
			|| table.material == MATERIAL_IRON \
			|| table.material == MATERIAL_SILVER \
			|| table.material == MATERIAL_GOLD \
			|| table.material == MATERIAL_PLASTEEL \
			|| table.material == MATERIAL_TITANIUM \
			|| table.material == MATERIAL_PLATINUM) //urgh
				if(deploy(user, turf, table))
					return TRUE
	var/obj/machinery/machine = locate(/obj/machinery) in turf
	if(machine)
		if(deploy(user, turf, machine))
			return TRUE
	return FALSE

/obj/item/weapon/floor_shocker/proc/deploy(var/mob/living/carbon/human/user, var/turf/turf, var/obj/parent)
	if(!power_source)
		var/obj/structure/cable/C = turf.get_cable_node()
		if(!C)
			to_chat(user, "You need to set up proper wiring there.")
			return FALSE
		power_source = C.powernet
	if(fire(user, TRUE))
		return FALSE
	if(!do_after(user, 100))
		return FALSE

	src.parent = parent
	user.drop_from_inventory(src)
	src.forceMove(turf)
	deployed = TRUE
	update_icon()
	return TRUE

/obj/item/weapon/floor_shocker/attack_hand(var/mob/living/carbon/human/user)
	if(!deployed)
		..()
	if(anchored && power_source && !fire(user, TRUE))
		active = !active
		update_icon()
		var/datum/effect/effect/system/spark_spread/spark_system = new ()
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		spawn(10)
			qdel(spark_system)
		return

/obj/item/weapon/floor_shocker/update_icon()
	overlays.Cut()
	icon_state = "sapper[deployed?"_deployed":""][active?"_on":""]"
	if(got_cell)
		overlays += image(icon, "overlay_cell")

	for(var/turf/simulated/floor/turf in range(get_turf(src), radius))
		if(active && !turf.density)
			if(!(turf_overlay_image in turf.overlays))
				turf.overlays += turf_overlay_image
		else
			if(turf_overlay_image in turf.overlays)
				turf.overlays -= turf_overlay_image

/obj/item/weapon/floor_shocker/proc/fire(var/mob/living/mob, var/hands = FALSE)
	if(!issilicon(mob) && power_source)
		return electrocute_mob(mob, power_source, src, 0.4, hands)
	return FALSE


/datum/craft_recipe/floor_shocker
	name = "floor mounted shocker"
	result = /obj/item/weapon/floor_shocker
	time = WORKTIME_NORMAL
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
		list(/obj/item/stack/rods, 4),
		list(QUALITY_BOLT_TURNING, 10, 60),
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
		list(/obj/item/stack/cable_coil, 20),
		list(QUALITY_SCREW_DRIVING, 10, 60)
	)
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF