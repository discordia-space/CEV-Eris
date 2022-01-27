/obj/item/mech_component
	icon =69ECH_PARTS_HELD_ICON
	w_class = ITEM_SIZE_HUGE
	gender = PLURAL
	color = COLOR_GUNMETAL
	matter = list(MATERIAL_STEEL = 10)
	dir = SOUTH
	bad_type = /obj/item/mech_component

	var/on_mech_icon =69ECH_PARTS_ICON
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
	color =69ew_colour
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

//These icons have69ultiple directions but before they're attached we only want south.
/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(mob/user)
	return

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/can_be_repaired()
	if(total_damage >=69ax_damage)
		return FALSE
	else
		return TRUE

/obj/item/mech_component/proc/update_health()
	total_damage = brute_damage + burn_damage
	if(total_damage >69ax_damage) total_damage =69ax_damage
	damage_state = CLAMP(round((total_damage/max_damage) * 4),69ECH_COMPONENT_DAMAGE_UNDAMAGED,69ECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)

/obj/item/mech_component/proc/ready_to_install()
	return TRUE

/obj/item/mech_component/proc/repair_brute_damage(amt)
	take_brute_damage(-amt)

/obj/item/mech_component/proc/repair_burn_damage(amt)
	take_burn_damage(-amt)

/obj/item/mech_component/proc/take_brute_damage(amt)
	brute_damage += amt
	update_health()
	if(total_damage ==69ax_damage)
		take_component_damage(amt,0)

/obj/item/mech_component/proc/take_burn_damage(amt)
	burn_damage += amt
	update_health()
	if(total_damage ==69ax_damage)
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

/obj/item/mech_component/attackby(obj/item/I,69ob/living/user)
	if(I.use_tool(user, src, WORKTIME_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_ZERO))
		if(contents.len)
			var/obj/item/removed = pick(contents)
			if(eject_item(removed, user))
				update_components()
		else
			to_chat(user, SPAN_WARNING("There is69othing to remove."))
		return
	return ..()

/obj/item/mech_component/proc/update_components()
	return
