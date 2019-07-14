//Biomatter compressor
//This machine converts liquid biomatter to solid one(sheets)
//Working with this also required bio protection cloths

#define BIOMATTER_PER_SHEET 		10
#define CONTAINER_PIXEL_OFFSET 		6

/obj/machinery/biomatter_solidifier
	name = "biomatter solidifier"
	desc = "A Neotheology machine that converts liquid biomatter into the solid."
	icon = 'icons/obj/machines/simple_nt_machines.dmi'
	icon_state = "solidifier"
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 300

	circuit = /obj/item/weapon/circuitboard/neotheology/solidifier
	var/active = FALSE
	var/port_dir = NORTH
	var/obj/structure/reagent_dispensers/biomatter/container
	var/last_time_used = 0


/obj/machinery/biomatter_solidifier/update_icon()
	if(active)
		icon_state = initial(icon_state) + "_on"
	else
		icon_state = initial(icon_state)


/obj/machinery/biomatter_solidifier/Process()
	if(active)
		if(!container)
			abort("Container of liquid biomatter required.")
		else
			if(!container.reagents.has_reagent("biomatter", BIOMATTER_PER_SHEET))
				abort("Insufficient amount of biomatter.")
			else
				container.reagents.remove_reagent("biomatter", BIOMATTER_PER_SHEET)
				var/obj/item/stack/material/biomatter/current_stack
				//if there any stacks here, let's check them
				if(locate(/obj/item/stack/material/biomatter) in loc)
					for(var/obj/item/stack/material/biomatter/stack_on_my_loc in loc)
						//if this isn't full, we use that stack(current)
						if(stack_on_my_loc.amount < stack_on_my_loc.max_amount)
							current_stack = stack_on_my_loc
							break

				if(current_stack)
					current_stack.add(1)
					if(current_stack.amount == current_stack.max_amount)
						state("Stack is ready.")
						ping()
				else
					current_stack = new(loc)


/obj/machinery/biomatter_solidifier/MouseDrop_T(obj/structure/reagent_dispensers/biomatter/tank, mob/user)
	if(get_dir(loc, tank.loc) != port_dir)
		to_chat(user, SPAN_WARNING("Doesn't connect. Port direction located at [dir2text(port_dir)] side of [src]"))
		return

	if(!container)
		container = tank
		container.anchored = TRUE
		switch(port_dir)
			if(SOUTH)
				container.pixel_y += CONTAINER_PIXEL_OFFSET
			if(NORTH)
				container.pixel_y -= CONTAINER_PIXEL_OFFSET
			if(EAST)
				container.pixel_x += CONTAINER_PIXEL_OFFSET
			if(WEST)
				container.pixel_x -= CONTAINER_PIXEL_OFFSET
		playsound(src, 'sound/machines/airlock_ext_close.ogg', 60, 1)
		to_chat(user, SPAN_NOTICE("You attached [tank] to [src]."))
		toxin_attack(user)
	else
		if(container == tank)
			container.pixel_y = initial(container.pixel_y)
			container.pixel_x = initial(container.pixel_x)
			container.anchored = FALSE
			playsound(src, 'sound/machines/airlock_ext_open.ogg', 60, 1)
			to_chat(user, SPAN_NOTICE("You dettached [tank] from [src]."))
			container = null
			toxin_attack(user)
		else
			to_chat(user, SPAN_WARNING("There are already connected container."))


/obj/machinery/biomatter_solidifier/attack_hand(mob/user)
	if(world.time >= last_time_used + 2 SECONDS)
		last_time_used = world.time
		active = !active
		to_chat(user, SPAN_NOTICE("You [active ? "turn [src] on" : "turn [src] off"]."))
		playsound(src, 'sound/machines/click.ogg', 80, 1)
		update_icon()


/obj/machinery/biomatter_solidifier/proc/abort(var/msg)
	state(msg)
	active = !active
	ping()
	update_icon()


#undef CONTAINER_PIXEL_OFFSET
#undef BIOMATTER_PER_SHEET