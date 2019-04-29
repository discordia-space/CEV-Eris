/obj/item/weapon/floor_shocker
	var/datum/powernet/powernet
	var/obj/item/weapon/cell/large/cell
	var/obj/parent
	var/active = FALSE

	var/passive_power_use = 200
	var/fire_delay = 40
	var/radius = 2

	icon = 'icons/obj/floor_shocker.dmi'
	icon_state = "sapper"
	name = "floor mounted shocker"
	desc = "A nasty sapper that electrifies floors around. Uses L-size batteries, but has connectors for outer wiring."
	layer = LOW_OBJ_LAYER

/obj/item/weapon/floor_shocker/New()
	..()

/obj/item/weapon/floor_shocker/Process()
	if(!active) return
	if(!cell && !powernet) return

	var/got_power
	if(powernet)
		got_power = powernet.draw_power(passive_power_use)
	else
		got_power = cell.use(passive_power_use)

	if(got_power == 0)
		active = FALSE
		update_icon()
		return
	if(!anchored)
		explosion(get_turf(src), 0,1,2)
		if(src)
			qdel(src)

	for(var/mob/living/mob in range(src, radius))
		if(bresenhem_line_check(get_turf(src), get_turf(mob))) fire(mob)

/obj/item/weapon/floor_shocker/attackby(var/obj/item/I, var/mob/living/user, var/params)
	if(!Adjacent(user))
		return FALSE
	if(fire(user, TRUE))
		return FALSE
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/cell/large))
		if(!cell)
			to_chat(user, SPAN_NOTICE("You added cell to shocker."))
			user.drop_item()
			I.forceMove(src)
			cell = I
			update_icon()
			return
	var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING)
			if(!anchored)
				to_chat(user, SPAN_WARNING("It's not deployed yet."))
				return
			if(active)
				to_chat(user, SPAN_WARNING("Turn it off first!"))
				return
			var/turf/turf = get_turf(src)
			var/obj/structure/cable/C = turf.get_cable_node()
			if(!cell)
				if(!C)
					to_chat(user, SPAN_WARNING("You need to set up proper wiring there."))
					return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You unanchored [src] from floor."))
				anchored = FALSE
				powernet = null
				update_icon()
			return
		if(QUALITY_SCREW_DRIVING)
			if(active)
				to_chat(user, SPAN_WARNING("Turn it off first!"))
				return
			if(!cell)
				to_chat(user, SPAN_WARNING("There is nothing to do!"))
				return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You detached cell from [src]"))
				cell.forceMove(get_turf(user))
				cell = null
				update_icon()
			return
	return ..()
/obj/item/weapon/floor_shocker/attack_self(var/mob/living/carbon/human/user)
	if(anchored)//how the fuck.
		CRASH()

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
				return deploy(user, turf, table)
	var/obj/machinery/power/machine = locate(/obj/machinery/power) in turf
	if(machine)
		return deploy(user, turf, machine)
	to_chat(user, SPAN_WARNING("You need something conductive to attach to!"))
	return FALSE

/obj/item/weapon/floor_shocker/proc/deploy(var/mob/living/carbon/human/user, var/turf/turf, var/obj/parent)
	var/obj/structure/cable/C = turf.get_cable_node()
	if(C)
		powernet = C.powernet
	else if(!cell)
		to_chat(user, SPAN_WARNING("You need to set up proper wiring there."))
		return FALSE

	to_chat(user, SPAN_NOTICE("You started deploying [src]..."))
	if(!do_after(user, 100))
		return FALSE
	to_chat(user, SPAN_NOTICE("You deployed [src]."))

	src.parent = parent
	user.drop_from_inventory(src)
	src.forceMove(turf)
	anchored = TRUE
	update_icon()
	return TRUE

/obj/item/weapon/floor_shocker/attack_hand(var/mob/living/carbon/human/user)
	if(!anchored)
		return ..()
	if(!Adjacent(user))
		return FALSE
	if(!cell && !powernet)
		to_chat(user, "Device is unpowered.")
		return FALSE
	if(fire(user, TRUE))
		active = !active
		update_icon()
		var/datum/effect/effect/system/spark_spread/spark_system = new ()
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		spawn(fire_delay)
			qdel(spark_system)
			while(active)
				Process()
				sleep(fire_delay)
		return TRUE

/obj/item/weapon/floor_shocker/update_icon()
	overlays.Cut()
	icon_state = "sapper[anchored?"_deployed":""][active?"_on":""]"
	if(cell)
		overlays += image(icon, "overlay_cell")

	var/turf/local_turf = get_turf(src)
	if(active)
		for(var/turf/simulated/floor/turf in range(local_turf, radius))
			if(bresenhem_line_check(local_turf, turf))
				var/dx = (turf.x - local_turf.x) * 32
				var/dy = (turf.y - local_turf.y) * 32
				var/matrix/m = new()
				m.Translate(dx, dy)
				var/image/turf_overlay_image = image(icon, "overlay_turf")
				turf_overlay_image.transform = m
				overlays += turf_overlay_image

/obj/item/weapon/floor_shocker/proc/fire(var/mob/living/mob, var/hands = FALSE)
	if(!issilicon(mob))
		if(powernet)
			return electrocute_mob(mob, powernet, src, 0.4, hands)
		if(cell)
			return electrocute_mob(mob, cell, src, 0.4, hands)
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