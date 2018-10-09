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


/obj/item/weapon/tool/weldingtool/turn_on(mob/user)

	if (get_fuel() > passive_fuel_cost)
		item_state = "[initial(item_state)]_on"
		..()
		damtype = BURN
		force = force_ignited
		START_PROCESSING(SSobj, src)
	else
		item_state = initial(item_state)
		user << SPAN_WARNING("[src] has no fuel!")


	//Todo: Add a better hit sound for a turned_on welder



/obj/item/weapon/tool/weldingtool/turn_off(mob/user)
	item_state = initial(item_state)
	..()
	damtype = initial(damtype)
	force = initial(force)


/obj/item/weapon/tool/weldingtool/advanced
	icon_state = "adv_welder"
	item_state = "adv_welder"
	glow_color = COLOR_BLUE_LIGHT
	switched_on_qualities = list(QUALITY_WELDING = 40, QUALITY_CAUTERIZING = 15, QUALITY_WIRE_CUTTING = 15)
	max_fuel = 40
	force_ignited = WEAPON_FORCE_PAINFULL*1.15 //Slightly more powerful, not much more so
