/obj/item/weapon/tool/weldingtool
	name = "welding tool"
	icon_state = "welder"
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
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
	max_fuel = 30

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE


/obj/item/weapon/tool/weldingtool/turn_on(mob/user)
	if (get_fuel() > 0)
		..()
		damtype = BURN
		force = WEAPON_FORCE_PAINFULL
	else
		user << SPAN_WARNING("[src] has no fuel!")

	//Todo: Add a better hit sound for a turned_on welder

/obj/item/weapon/tool/weldingtool/turn_off(mob/user)
	..()
	damtype = initial(damtype)
	force = initial(force)