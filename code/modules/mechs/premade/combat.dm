/mob/living/exosuit/premade/combat
	name = "combat exosuit"
	desc = "A sleek, modern combat exosuit."

	material = MATERIAL_PLASTEEL
	exosuit_color = COLOR_DARK_GUNMETAL
	installed_armor = /obj/item/robot_parts/robot_component/armour/exosuit/combat
	installed_software_boards = list(
		/obj/item/weapon/circuitboard/exosystem/weapons,
		/obj/item/weapon/circuitboard/exosystem/advweapons
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/mounted_system/taser,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/taser/ion,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)

/mob/living/exosuit/premade/combat/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/combat(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/combat(src)
	if(!head)
		head = new /obj/item/mech_component/sensors/combat(src)
	if(!body)
		body = new /obj/item/mech_component/chassis/combat(src)

	. = ..()


/obj/item/mech_component/sensors/combat
	name = "combat sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution thermal sensors"
	icon_state = "combat_head"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 200
	matter = list(MATERIAL_STEEL = 10)

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin = TRUE
	exosuit_desc_string = "an armored chassis"
	icon_state = "combat_body"
	power_use = 40
	matter = list(MATERIAL_STEEL = 45)

/obj/item/mech_component/chassis/combat/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	. = ..()

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "combat_arms"
	melee_damage = 5
	action_delay = 10
	power_use = 50
	matter = list(MATERIAL_STEEL = 15)

/obj/item/mech_component/propulsion/combat
	name = "combat legs"
	exosuit_desc_string = "sleek hydraulic legs"
	icon_state = "combat_legs"
	move_delay = 3
	power_use = 20
	matter = list(MATERIAL_STEEL = 15)
