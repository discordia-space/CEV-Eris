//Biomatter compressor
//This69achine converts liquid biomatter to solid one(sheets)
//Working with this also required bio protection cloths

#define BIOMATTER_PER_SHEET 		1
#define CONTAINER_PIXEL_OFFSET 		6
#define BIOMATTER_SHEETS_PER_TIME  5 // X sheets per 2 seconds

/obj/machinery/biomatter_solidifier
	name = "biomatter solidifier"
	desc = "A Neotheology69achine that converts liquid biomatter into the solid."
	icon = 'icons/obj/machines/simple_nt_machines.dmi'
	icon_state = "solidifier"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 300
	reagent_flags = TRANSPARENT

	var/active = FALSE
	var/port_dir = SOUTH
	var/obj/structure/reagent_dispensers/biomatter/container
	var/last_time_used = 0

/obj/machinery/biomatter_solidifier/Initialize(mapload, d, bolt=TRUE)
	. = ..()
	create_reagents(BIOMATTER_PER_SHEET*BIOMATTER_SHEETS_PER_TIME*3)
	anchored = bolt
	overlays += image(icon = src.icon, icon_state = "tube", layer = LOW_OBJ_LAYER, dir = port_dir)

/obj/machinery/biomatter_solidifier/update_icon()
	if(active)
		icon_state = initial(icon_state) + "_on"
	else
		icon_state = initial(icon_state)
	overlays = list()
	overlays += image(icon = src.icon, icon_state = "tube", layer = LOW_OBJ_LAYER, dir = port_dir)

/obj/machinery/biomatter_solidifier/Process()
	if(active)
		if(reagents.get_free_space() >= BIOMATTER_PER_SHEET)
			if(reagents.total_volume < BIOMATTER_PER_SHEET)
				if(!container)
					abort("Container of liquid biomatter required.")
					return
				else if(!container.reagents.has_reagent(MATERIAL_BIOMATTER, BIOMATTER_PER_SHEET))
					abort("Insufficient amount of biomatter.")
					return
			if(container && container.reagents.has_reagent(MATERIAL_BIOMATTER, BIOMATTER_PER_SHEET))
				var/quantity =69in(reagents.get_free_space(), BIOMATTER_PER_SHEET*BIOMATTER_SHEETS_PER_TIME)
				container.reagents.trans_id_to(src,69ATERIAL_BIOMATTER, quantity, TRUE)
		if(reagents.get_reagent_amount(MATERIAL_BIOMATTER) >= BIOMATTER_PER_SHEET)
			process_biomatter()
		else
			abort("Insufficient amount of biomatter.")

/obj/machinery/biomatter_solidifier/proc/process_biomatter()
	var/quantity =69in(reagents.get_reagent_amount(MATERIAL_BIOMATTER), BIOMATTER_PER_SHEET*BIOMATTER_SHEETS_PER_TIME)
	reagents.remove_reagent(MATERIAL_BIOMATTER, quantity)

	while(quantity > 0)
		var/obj/item/stack/material/biomatter/current_stack
		//if there any stacks here, let's check them
		if(locate(/obj/item/stack/material/biomatter) in loc)
			for(var/obj/item/stack/material/biomatter/stack_on_my_loc in loc)
				if(stack_on_my_loc.amount < stack_on_my_loc.max_amount)
					current_stack = stack_on_my_loc
					break
		//if we found not full stack
		if(current_stack)
			if(current_stack.amount + round(quantity / BIOMATTER_PER_SHEET) >= current_stack.max_amount)
				//if stack cannot hold all quantity we will just fill it and go to next
				var/diff = current_stack.max_amount - current_stack.amount
				current_stack.add(diff)
				quantity -= diff * BIOMATTER_PER_SHEET
				continue
			else
				current_stack.add(round(quantity / BIOMATTER_PER_SHEET))
				quantity = 0
				return
		//if we not found not full stack
		else
			current_stack = new(loc)
			quantity -= 1 * BIOMATTER_PER_SHEET

/obj/machinery/biomatter_solidifier/MouseDrop_T(obj/structure/reagent_dispensers/biomatter/tank,69ob/user)
	if(get_dir(loc, tank.loc) != port_dir)
		to_chat(user, SPAN_WARNING("Doesn't connect. Port direction located at 69dir2text(port_dir)69 side of 69src69"))
		return
	if(!container)
		if(tank.set_anchored(TRUE))
			container = tank
			container.can_anchor = FALSE
			switch(port_dir)
				if(SOUTH)
					container.pixel_y += CONTAINER_PIXEL_OFFSET
				if(NORTH)
					container.pixel_y -= CONTAINER_PIXEL_OFFSET
				if(WEST)
					container.pixel_x += CONTAINER_PIXEL_OFFSET
				if(EAST)
					container.pixel_x -= CONTAINER_PIXEL_OFFSET
			playsound(src, 'sound/machines/airlock_ext_close.ogg', 60, 1)
			to_chat(user, SPAN_NOTICE("You attached 69tank69 to 69src69."))
		else
			to_chat(user, SPAN_WARNING("Ugh. You done something wrong!"))
		toxin_attack(user)
	else if(container == tank)
		container.can_anchor = TRUE
		tank.set_anchored(FALSE)
		container.pixel_y = initial(container.pixel_y)
		container.pixel_x = initial(container.pixel_x)
		playsound(src, 'sound/machines/airlock_ext_open.ogg', 60, 1)
		to_chat(user, SPAN_NOTICE("You dettached 69tank69 from 69src69."))
		container = null
		toxin_attack(user)
	else
		to_chat(user, SPAN_WARNING("There are already connected container."))

	update_icon()

/obj/machinery/biomatter_solidifier/attack_hand(mob/user)
	if(world.time >= last_time_used + 2 SECONDS)
		last_time_used = world.time
		active = !active
		to_chat(user, SPAN_NOTICE("You 69active ? "turn 69src69 on" : "turn 69src69 off"69."))
		playsound(src, 'sound/machines/click.ogg', 80, 1)
		update_icon()


/obj/machinery/biomatter_solidifier/proc/abort(msg)
	state(msg)
	active = !active
	ping()
	update_icon()

#undef BIOMATTER_SHEETS_PER_TIME
#undef CONTAINER_PIXEL_OFFSET
