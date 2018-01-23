/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C, /obj/item/stack/cable_coil) || (flooring && istype(C, /obj/item/stack/rods)))
		return ..(C, user)

	if(flooring)
		if(istype(C, /obj/item/weapon/tool/crowbar))
			if(broken || burnt)
				user << SPAN_NOTICE("You remove the broken [flooring.descriptor].")
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				user << SPAN_DANGER("You forcefully pry off the [flooring.descriptor], destroying them in the process.")
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				user << SPAN_NOTICE("You lever off the [flooring.descriptor].")
				make_plating(1)
			else
				return
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/tool/screwdriver) && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			user << SPAN_NOTICE("You unscrew and remove the [flooring.descriptor].")
			make_plating(1)
			playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/tool/wrench) && (flooring.flags & TURF_REMOVE_WRENCH))
			user << SPAN_NOTICE("You unwrench and remove the [flooring.descriptor].")
			make_plating(1)
			playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			user << SPAN_NOTICE("You shovel off the [flooring.descriptor].")
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/stack/cable_coil))
			user << SPAN_WARNING("You must remove the [flooring.descriptor] first.")
			return
		else if (istype(C, /obj/item/frame))
			var/obj/item/frame/F = C
			//world<<"click on floor"
			F.try_floorbuild(src)
			return
	else

		if(istype(C, /obj/item/stack))
			if(broken || burnt)
				user << SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage.")
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			for(var/flooring_type in flooring_types)
				var/decl/flooring/F = flooring_types[flooring_type]
				if(!F.build_type)
					continue
				if((ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type)) && ((S.type == F.build_type) || (S.build_type == F.build_type)))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				user << SPAN_WARNING("You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs.
		else if(istype(C, /obj/item/weapon/tool/weldingtool))
			var/obj/item/weapon/tool/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0,user))
						user << SPAN_NOTICE("You fix some dents on the broken plating.")
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						user << SPAN_WARNING("You need more welding fuel to complete this task.")
					return
		else if(istype(C,/obj/item/frame))
			var/obj/item/frame/F = C
			//world<<"click on floor"
			F.try_floorbuild(src)
			return
	return ..()


/turf/simulated/floor/can_build_cable(var/mob/user)
	if(!is_plating() || flooring)
		user << SPAN_WARNING("Removing the tiling first.")
		return 0
	if(broken || burnt)
		user << SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage.")
		return 0
	return 1
