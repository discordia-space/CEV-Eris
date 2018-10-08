/obj/item/weapon/tool/weldingtool
	name = "welding tool"
	icon_state = "welder"
	item_state = "welder"
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	var/force_ignited = WEAPON_FORCE_PAINFULL
	throwforce = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_WELDING
	throw_speed = 1
	throw_range = 5
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 3)
	origin_tech = list(TECH_ENGINEERING = 1)
	switched_on_qualities = list(QUALITY_WELDING = 30, QUALITY_CAUTERIZING = 10, QUALITY_WIRE_CUTTING = 10)

	sparks_on_use = TRUE
	eye_hazard = TRUE

	use_fuel_cost = 2
	max_fuel = 25

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE
	var/fuel_meter = TRUE


/obj/item/weapon/tool/weldingtool/turn_on(mob/user)
	if (get_fuel() > 0)
		..()
		damtype = BURN
		force = WEAPON_FORCE_PAINFULL
		START_PROCESSING(SSobj, src)
	else
		user << SPAN_WARNING("[src] has no fuel!")

	//Todo: Add a better hit sound for a turned_on welder



/obj/item/weapon/tool/weldingtool/update_icon()
	overlays.Cut()

	if(switched_on && toggleable)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = "[initial(icon_state)]"

	if(fuel_meter)
		var/ratio = 0
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(get_fuel() >= use_fuel_cost)
			ratio = get_fuel() / max_fuel
			ratio = max(round(ratio, 0.25) * 100, 25)
			overlays += "[icon_state]-[ratio]"

	item_state = icon_state

/obj/item/weapon/tool/weldingtool/turn_off(mob/user)
	..()
	damtype = initial(damtype)
	force = initial(force)


/obj/item/weapon/tool/weldingtool/advanced
	icon_state = "adv_welder"
	item_state = "adv_welder"
	switched_on_qualities = list(QUALITY_WELDING = 40, QUALITY_CAUTERIZING = 15, QUALITY_WIRE_CUTTING = 15)
	max_fuel = 40
	force_ignited = WEAPON_FORCE_PAINFULL+3 //Slightly more powerful, not much more so
	fuel_meter = FALSE
