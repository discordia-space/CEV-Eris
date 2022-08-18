/obj/item/mech_component
	icon = MECH_PARTS_HELD_ICON
	w_class = ITEM_SIZE_HUGE
	gender = PLURAL
	color = COLOR_GUNMETAL
	matter = list(MATERIAL_STEEL = 10)
	dir = SOUTH
	bad_type = /obj/item/mech_component

	price_tag = 150

	var/on_mech_icon = MECH_PARTS_ICON
	var/exosuit_desc_string
	var/total_damage = 0
	var/brute_damage = 0
	var/burn_damage = 0
	var/max_damage = 60
	var/damage_state = 1
	var/list/has_hardpoints = list()
	var/decal
	var/power_use = 0

/obj/item/mech_component/proc/set_colour(new_colour)
	var/last_colour = color
	color = new_colour
	return color != last_colour

/obj/item/mech_component/emp_act(severity)
	take_burn_damage(rand((10 - (severity*3)),15-(severity*4)))
	for(var/obj/item/thing in contents)
		thing.emp_act(severity)

/obj/item/mech_component/examine()
	. = ..()
	if(.)
		if(ready_to_install())
			to_chat(usr, SPAN_NOTICE("It is ready for installation."))
		else
			show_missing_parts(usr)

//These icons have multiple directions but before they're attached we only want south.
/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(mob/user)
	return

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/can_be_repaired()
	if(total_damage >= max_damage)
		return FALSE
	else
		return TRUE

/obj/item/mech_component/proc/update_health()
	total_damage = brute_damage + burn_damage
	if(total_damage > max_damage) total_damage = max_damage
	var/prev_state = damage_state
	damage_state = CLAMP(round((total_damage/max_damage) * 4), MECH_COMPONENT_DAMAGE_UNDAMAGED, MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
	if(damage_state > prev_state)
		if(damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
			playsound(loc, 'sound/mechs/internaldmgalarm.ogg', 40, 1)
		if(damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
			playsound(loc, 'sound/mechs/critdestr.ogg', 50)
/obj/item/mech_component/proc/ready_to_install()
	return TRUE

/obj/item/mech_component/proc/repair_brute_damage(amt)
	take_brute_damage(-amt)

/obj/item/mech_component/proc/repair_burn_damage(amt)
	take_burn_damage(-amt)

/obj/item/mech_component/proc/take_brute_damage(amt)
	brute_damage += amt
	update_health()
	if(total_damage == max_damage)
		take_component_damage(amt,0)

/obj/item/mech_component/proc/take_burn_damage(amt)
	burn_damage += amt
	update_health()
	if(total_damage == max_damage)
		take_component_damage(0,amt)

/obj/item/mech_component/proc/take_component_damage(brute, burn)
	var/list/damageable_components = list()
	for(var/obj/item/robot_parts/robot_component/RC in contents)
		damageable_components += RC
	if(!damageable_components.len)
		return

	var/obj/item/robot_parts/robot_component/RC = pick(damageable_components)
	if(RC.take_damage(brute, burn))
		QDEL_NULL(RC)

/obj/item/mech_component/proc/return_diagnostics(var/mob/user)
	to_chat(user, SPAN_NOTICE("[capitalize(name)]:"))
	to_chat(user, SPAN_NOTICE(" - Integrity: <b>[round((((max_damage - total_damage) / max_damage)) * 100)]%</b>" ))

/obj/item/mech_component/attackby(obj/item/I, mob/living/user)
	if(I.use_tool(user, src, WORKTIME_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_ZERO))
		if(contents.len)
			//Filter non movables
			var/list/valid_contents = list()
			for(var/atom/movable/A in contents)
				if(!A.anchored)
					valid_contents += A
			if(!valid_contents.len)
				return
			var/obj/item/removed = pick(valid_contents)
			if(!(removed in contents))
				return
			if(eject_item(removed, user))
				update_components()
		else
			to_chat(user, SPAN_WARNING("There is nothing to remove."))
		return
	if(istype(I, /obj/item/device/robotanalyzer))
		to_chat(user, SPAN_NOTICE("Diagnostic Report for \the [src]:"))
		return_diagnostics(user)
	return ..()

/obj/item/mech_component/proc/update_components()
	return
